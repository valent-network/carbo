# frozen_string_literal: true

class UserContact < ApplicationRecord
  validates :phone_number, uniqueness: { scope: :user_id }
  validates :name, exclusion: { in: [nil] }, length: { maximum: 100 }

  belongs_to :user
  belongs_to :phone_number
  has_one :friend, through: :phone_number, source: :user

  scope :effective, -> {} # TODO

  def self.ad_friends_for_user(ad, user)
    friends_ids = UserConnection.where(user: user).joins(connection: :user_contacts).where(user_contacts: { phone_number_id: ad.phone_number_id }).select(:friend_id)
    friends_phone_numbers_ids = User.where(id: friends_ids).select(:phone_number_id)

    to_select = [
      'user_contacts.*',
      "(user_contacts.phone_number_id = #{ad.phone_number_id}) AS is_first_hand",
    ].join(', ')

    select(to_select)
      .where(user: user)
      .where("phone_number_id IN (#{friends_phone_numbers_ids.to_sql}) OR phone_number_id = #{ad.phone_number_id}")
  end

  def self.friends_users_ids_for(user)
    user.user_contacts.joins("JOIN users AS registered_users ON registered_users.phone_number_id = user_contacts.phone_number_id AND registered_users.id != #{user.id}").pluck('registered_users.id')
  end
end
