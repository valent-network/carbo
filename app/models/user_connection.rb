# frozen_string_literal: true
class UserConnection < ApplicationRecord
  FRIENDS_HOPS = 6

  belongs_to :user
  belongs_to :connection, class_name: 'User'
  belongs_to :friend, class_name: 'User'
  has_many :user_contacts, through: :connection

  def self.update_connections_for(user)
    friends_users_ids = UserContact.friends_users_ids_for(user)
    connections_ids = RGR.get_all_rels(user, 6).resultset
      .reject { |a| a.last == user.id }
      .reject { |a| a.first == a.last }
      .reject { |a| a.last.in?(friends_users_ids) }
    return if connections_ids.blank?
    connections_to_upsert = connections_ids.map { |id| { user_id: user.id, friend_id: id.first, connection_id: id.last } }
    transaction do
      upsert_all(connections_to_upsert, unique_by: [:user_id, :connection_id, :friend_id], returning: false)
    end
  end
end
