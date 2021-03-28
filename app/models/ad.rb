# frozen_string_literal: true

class Ad < ApplicationRecord
  AD_TYPES = %w[car real_estate].freeze

  attr_reader :friend_name_and_total

  before_update :prepare_ad_price

  has_paper_trail

  validates :price, presence: true, numericality: { greater_than: 0, only_integer: true }
  validates :address, uniqueness: { scope: :ads_source_id }
  validates :ad_type, inclusion: { in: AD_TYPES }
  validates :details, presence: true, json: true
  validates :deleted, inclusion: { in: [true, false] }

  validate :details_object

  belongs_to :ads_source
  belongs_to :phone_number
  has_many :ad_visits, dependent: :delete_all
  has_many :ad_favorites, dependent: :delete_all
  has_many :ad_prices, dependent: :delete_all

  scope :active, -> { where(deleted: false) }

  def phone=(val)
    self.phone_number = PhoneNumber.by_full_number(val).first_or_create! if val.present?
  end

  def associate_friends_with(ads_with_friends)
    associated = ads_with_friends.select { |ad_with_friends| ad_with_friends.id == id }
    return if associated.blank?

    friend = associated.detect(&:is_first_hand) || associated.first

    @friend_name_and_total = {
      name: friend.friend_name,
      friend_hands: friend.is_first_hand ? 1 : 2,
      count: (associated.count - 1),
    }
  end

  private

  def details_object
    errors.add(:details, 'must be a Hash') unless details.is_a?(Hash)
  end

  def prepare_ad_price
    ad_prices.new(price: price) if price_changed?
  end
end
