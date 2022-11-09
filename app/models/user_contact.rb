# frozen_string_literal: true

class UserContact < ApplicationRecord
  validates :phone_number, uniqueness: { scope: :user_id }
  validates :name, exclusion: { in: [nil] }, length: { maximum: 100 }

  belongs_to :user
  belongs_to :phone_number
  has_one :friend, through: :phone_number, source: :user

  scope :effective, -> {} # TODO

  # TODO: Fix or cover with tests COALESCE function for cases where connections
  # still don't have hops_count associated
  def self.ad_friends_for_user(ad, user)
    my_contacts = user.user_contacts.select('user_contacts.*, 1 AS hops_count').where(phone_number_id: ad.phone_number_id)
    t = select('user_contacts.id, (COALESCE(MIN(user_connections.hops_count), 6) + 1) AS hops_count')
      .where(user: user)
      .joins('JOIN users ON users.phone_number_id = user_contacts.phone_number_id')
      .joins('JOIN user_connections ON user_connections.friend_id = users.id')
      .joins('JOIN user_contacts AS friends_contacts ON friends_contacts.user_id = user_connections.connection_id')
      .where(user_connections: { user_id: user.id }, user_contacts: { user_id: user.id })
      .where('friends_contacts.phone_number_id = ?', ad.phone_number_id)
      .group('user_contacts.id')
    friends_contacts = UserContact.select('user_contacts.*, t.hops_count').joins("JOIN (#{t.to_sql}) AS t ON t.id = user_contacts.id")

    friends = find_by_sql("#{my_contacts.to_sql} UNION #{friends_contacts.to_sql}")
    ActiveRecord::Associations::Preloader.new(records: friends, associations: [phone_number: :user]).call
    friends
  end

  def self.friends_users_ids_for(user)
    user.user_contacts.joins("JOIN users AS registered_users ON registered_users.phone_number_id = user_contacts.phone_number_id AND registered_users.id != #{user.id}").pluck('registered_users.id')
  end
end
