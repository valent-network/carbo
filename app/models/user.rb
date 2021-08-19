# frozen_string_literal: true

class User < ApplicationRecord
  validates_associated :phone_number
  validates :phone_number, :refcode, uniqueness: true
  validates :name, length: { maximum: 50 }, if: proc { |user| user.name.present? }

  belongs_to :phone_number
  belongs_to :referrer, foreign_key: :referrer_id, class_name: 'User', optional: true

  has_one :ref_c, class_name: 'UserContact', foreign_key: :phone_number_id, primary_key: :phone_number_id
  has_one :referrer_contact, through: :referrer, source: :ref_c, primary_key: :phone_number_id, foreign_key: :phone_number_id

  has_many :user_contacts, dependent: :delete_all
  has_many :user_devices, dependent: :delete_all
  has_many :ad_visits, dependent: :delete_all
  has_many :ad_favorites, dependent: :delete_all
  has_many :ads, through: :phone_number, dependent: false
  has_many :chat_rooms, dependent: :destroy
  has_many :chat_room_users, dependent: :destroy
  has_many :messages, dependent: :destroy
  has_many :events, dependent: :delete_all

  mount_base64_uploader :avatar, AvatarUploader

  scope :no_contacts, -> () { where.not('EXISTS (SELECT 1 FROM user_contacts WHERE user_contacts.user_id = users.id)') }
  scope :with_referrer, -> () { where.not(referrer_id: nil) }

  def update_friends!
    USER_FRIENDS_GRAPH.update_friends_for(self)
  end

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
