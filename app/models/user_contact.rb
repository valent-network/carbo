# frozen_string_literal: true

class UserContact < ApplicationRecord
  validates :phone_number, uniqueness: { scope: :user_id }
  validates :name, exclusion: { in: [nil] }, length: { maximum: 100 }

  belongs_to :user
  belongs_to :phone_number
  has_one :friend, through: :phone_number, source: :user

  def self.ad_friends_for_user(ad, user)
    query = UserRootFriendsForAdQuery.new.call(user.id, ad.phone_number_id)
    self.select('my_contacts.*, friends.is_first_hand')
      .from("(#{query}) friends")
      .joins("JOIN user_contacts AS my_contacts ON my_contacts.id = friends.id AND my_contacts.phone_number_id != #{user.phone_number_id}")
      .where("friends.is_first_hand = TRUE OR my_contacts.phone_number_id != #{ad.phone_number_id}")
  end
end
