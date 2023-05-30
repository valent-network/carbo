# frozen_string_literal: true

class UserContact < ApplicationRecord
  validates :phone_number, uniqueness: {scope: :user_id}
  validates :name, exclusion: {in: [nil]}, length: {maximum: 100}

  belongs_to :user
  belongs_to :phone_number
  has_one :friend, through: :phone_number, source: :user

  scope :effective, -> {} # TODO

  # Here we return User's UserContacts who can connect with the provided Ad
  # based on UserConnection
  def self.ad_friends_for_user(ad, user)
    friends = UserContact.find_by_sql(<<~SQL)
      SELECT my_contacts.*, MIN(user_connections.hops_count + 1) AS hops_count
      FROM user_contacts AS my_contacts
      LEFT JOIN users AS my_friends ON my_friends.phone_number_id = my_contacts.phone_number_id
      JOIN user_connections ON user_connections.user_id = my_contacts.user_id
      JOIN user_contacts AS known_contacts ON known_contacts.user_id = user_connections.connection_id
      WHERE known_contacts.phone_number_id != #{user.phone_number_id}
            AND my_contacts.phone_number_id != #{user.phone_number_id}
            AND my_contacts.user_id = #{user.id}
            AND known_contacts.phone_number_id = #{ad.phone_number_id}
            AND (
              user_connections.friend_id = my_friends.id OR (
                user_connections.friend_id = #{user.id} AND my_contacts.phone_number_id = #{ad.phone_number_id}
              )
            )
      GROUP BY my_contacts.id
    SQL

    ActiveRecord::Associations::Preloader.new(records: friends, associations: [phone_number: :user]).call
    friends
  end

  def self.friends_users_ids_for(user)
    user.user_contacts.joins("JOIN users AS registered_users ON registered_users.phone_number_id = user_contacts.phone_number_id AND registered_users.id != #{user.id}").pluck("registered_users.id")
  end
end
