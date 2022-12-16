# frozen_string_literal: true
class UserConnection < ApplicationRecord
  FRIENDS_HOPS = 5

  belongs_to :user
  belongs_to :connection, class_name: 'User'
  belongs_to :friend, class_name: 'User'
  has_many :user_contacts, through: :connection
  has_many :phone_numbers, through: :user_contacts
  has_many :ads, through: :phone_numbers

  scope :visible_ads_count, -> { select('user_connections.user_id, COUNT(DISTINCT ads.id) AS count').joins(:ads).where(ads: { deleted: false }).group('user_connections.user_id') }
  scope :visible_ads_default_count, -> { select('user_connections.user_id, COUNT(DISTINCT ads.id) AS count').joins(:ads).where(ads: { deleted: false }, user_connections: { hops_count: 0..UserFriendlyAdsQuery::DEFAULT_HOPS_COUNT }).group('user_connections.user_id') }
  scope :business_ads_count, -> { select('user_connections.user_id, COUNT(DISTINCT ads.id) AS count').joins(:ads).where(ads: { deleted: false }).where("ads.phone_number_id IN (#{PhoneNumber.business.select(:id).to_sql})").group('user_connections.user_id') }
  scope :known_contacts_count, -> { select('user_connections.user_id, COUNT(DISTINCT "user_contacts"."phone_number_id") AS count').joins(:user_contacts).group('user_connections.user_id') }

  validates :user_id, uniqueness: { scope: %i[friend_id connection_id] }
  validates :user_id, :friend_id, :connection_id, presence: true
end
