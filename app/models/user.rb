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
  has_many :user_connections, dependent: :delete_all
  has_many :user_blocked_phone_numbers, dependent: :delete_all

  mount_base64_uploader :avatar, AvatarUploader

  scope :no_contacts, -> () { where.not('EXISTS (SELECT 1 FROM user_contacts WHERE user_contacts.user_id = users.id)') }
  scope :no_connections, -> () { where.not('EXISTS (SELECT 1 FROM user_connections WHERE user_connections.user_id = users.id AND user_connections.friend_id != users.id)') }
  scope :with_referrer, -> () { where.not(referrer_id: nil) }

  def update_friends!
    USER_FRIENDS_GRAPH.update_friends_for(self)
  end

  def blocked_users_ids
    user_blocked_phone_numbers.joins(phone_number: :user).pluck('users.id')
  end

  def update_connections!
    connections = USER_FRIENDS_GRAPH.get_friends_connections(self, UserConnection::FRIENDS_HOPS).resultset

    # We don't care that someone knows us
    connections.reject! { |connection| connection[1] == id }

    # We need this to omit joins to find self user_contacts
    connections.push([id, id, 1])

    connections.reject!(&:blank?)

    connections_to_upsert = connections.map { |conn| { user_id: id, friend_id: conn[0], connection_id: conn[1], hops_count: conn[2] } }

    UserConnection.transaction do
      UserConnection.upsert_all(connections_to_upsert, unique_by: [:user_id, :connection_id, :friend_id], returning: false)
    end
  end

  def contacts_count
    user_contacts.count
  end

  def registered_friends_count
    user_contacts.joins(phone_number: :user).count.to_i
  end

  def visible_ads_count
    user_connections.visible_ads_count.to_a&.first&.count.to_i
  end

  def visible_ads_count_for_default_hops
    user_connections.visible_ads_default_count.to_a&.first&.count.to_i
  end

  def visible_business_ads_count
    user_connections.business_ads_count.to_a&.first&.count.to_i
  end

  def visible_friends_count
    UserContact.select(:phone_number_id).distinct(:phone_number_id).where("user_id IN (#{user_connections.distinct(:connection_id).select(:connection_id).to_sql})").count
  end

  def current_visibility
    {
      default_hops: UserFriendlyAdsQuery::DEFAULT_HOPS_COUNT,
      contacts_count: contacts_count,
      registered_friends_count: registered_friends_count,
      visible_friends_count: visible_friends_count,
      visible_ads_count: visible_ads_count,
      visible_ads_count_for_default_hops: visible_ads_count_for_default_hops,
      visible_business_ads_count: visible_business_ads_count,
    }
  end
end
