# frozen_string_literal: true

class User < ApplicationRecord
  validates_associated :phone_number
  validates :phone_number, uniqueness: true
  validates :name, length: { maximum: 50 }, if: proc { |user| user.name.present? }

  belongs_to :phone_number

  has_many :user_contacts, dependent: :delete_all
  has_many :user_devices, dependent: :delete_all
  has_many :ad_visits, dependent: :delete_all
  has_many :ad_favorites, dependent: :delete_all
  has_many :ads, through: :phone_number, dependent: false
  has_many :chat_rooms, dependent: :destroy
  has_many :chat_room_users, dependent: :destroy
  has_many :messages, dependent: :destroy

  mount_base64_uploader :avatar, AvatarUploader

  def contacts_count
    user_contacts.count
  end

  def visible_ads_count
    UserFriendlyAdsQuery.new.call(user: self, limit: 0).count
  end

  def visible_friends_count
    User.connection.execute(KnownNumbers.new.call(id)).count
  end
end
