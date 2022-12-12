# frozen_string_literal: true

class Ad < ApplicationRecord
  AD_TYPES = %w[car real_estate].freeze

  attr_reader :friend_name_and_total

  before_update :prepare_ad_price

  validates :price, presence: true, numericality: { greater_than: 0, only_integer: true }
  validates :address, uniqueness: { scope: :ads_source_id }
  validates :ad_type, inclusion: { in: AD_TYPES }
  validates :deleted, inclusion: { in: [true, false] }

  belongs_to :ads_source
  belongs_to :phone_number
  belongs_to :city, optional: true
  has_one :region, through: :city
  has_many :ad_visits, dependent: :delete_all
  has_many :ad_favorites, dependent: :delete_all
  has_many :ad_prices, dependent: :delete_all
  has_many :ad_options, dependent: :delete_all, autosave: true
  has_many :seller_names, dependent: :delete_all, autosave: true
  has_many :state_nums, dependent: :delete_all, autosave: true
  has_one :ad_description, dependent: :delete, autosave: true
  has_one :ad_image_links_set, dependent: :delete, autosave: true
  has_one :ad_extra, dependent: :delete, autosave: true
  has_one :ad_query, dependent: :delete, autosave: true

  delegate :body, to: :ad_description, prefix: true, allow_nil: true
  delegate :value, to: :ad_image_links_set, prefix: true, allow_nil: true
  delegate :details, to: :ad_extra, prefix: true, allow_nil: true
  delegate :title, to: :ad_query, allow_nil: true
  delegate :display_name, to: :city, prefix: true, allow_nil: true
  delegate :display_name, to: :region, prefix: true, allow_nil: true

  scope :active, -> { where(deleted: false) }
  scope :known, -> { joins('JOIN user_contacts ON user_contacts.phone_number_id = ads.phone_number_id') }

  def self.by_options(opt_name, opt_id, val_id)
    joins("JOIN ad_options AS ad_option_#{opt_name} ON ad_option_#{opt_name}.ad_id = ads.id AND ad_option_#{opt_name}.ad_option_type_id = #{opt_id} AND ad_option_#{opt_name}.ad_option_value_id = #{val_id}")
  end

  def phone=(val)
    self.phone_number = PhoneNumber.by_full_number(val).first_or_create! if val.present?
  end

  def associate_friends_with(ads_with_friends)
    associated = ads_with_friends.select { |ad_with_friends| ad_with_friends.id == id }
    return if associated.blank?

    friend = associated.min_by(&:hops_count)

    @friend_name_and_total = {
      name: friend.friend_name,
      friend_hands: friend.hops_count,
      count: (associated.count - 1),
    }
  end

  def details
    @details ||= (ad_extra_details || {}).merge({
      'description' => ad_description_body,
      'images_json_array_tmp' => ad_image_links_set_value,
      'city' => city_display_name,
      'region' => region_display_name,
    })
  end

  def image
    Array.wrap(ad_image_links_set_value).first
  end

  def details=(new_details)
    @details = nil

    raise unless new_details.is_a?(Hash)

    PrepareAdOptions.new.call(self, new_details)
  end

  # Override

  def reload
    @details = nil
    super
  end

  private

  def prepare_ad_price
    ad_prices.new(price: price_was) if price_changed?
  end
end
