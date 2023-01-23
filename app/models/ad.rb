# frozen_string_literal: true

class Ad < ApplicationRecord
  attr_reader :friend_name_and_total

  before_update :prepare_ad_price
  before_validation :set_native_address, :set_native_source

  validates :price, presence: true, numericality: { greater_than: 0, only_integer: true }
  validates :address, uniqueness: { scope: :ads_source_id }
  validates :deleted, inclusion: { in: [true, false] }

  belongs_to :ads_source
  belongs_to :phone_number
  belongs_to :city, optional: true
  belongs_to :category
  has_one :region, through: :city
  has_many :ad_visits, dependent: :delete_all
  has_many :ad_favorites, dependent: :delete_all
  has_many :ad_prices, dependent: :delete_all
  has_many :chat_rooms, dependent: :nullify
  has_many :ad_images, dependent: :destroy, autosave: true
  has_one :ad_description, dependent: :delete, autosave: true
  has_one :ad_image_links_set, dependent: :delete, autosave: true
  has_one :ad_extra, dependent: :delete, autosave: true
  has_one :ad_query, dependent: :delete, autosave: true

  delegate :body, to: :ad_description, prefix: true, allow_nil: true
  delegate :short, to: :ad_description, prefix: true, allow_nil: true
  delegate :value, to: :ad_image_links_set, prefix: true, allow_nil: true
  delegate :details, to: :ad_extra, prefix: true, allow_nil: true
  delegate :title, to: :ad_query, allow_nil: true
  delegate :display_name, to: :city, prefix: true, allow_nil: true
  delegate :display_name, to: :region, prefix: true, allow_nil: true
  delegate :currency, to: :category, prefix: true

  scope :active, -> { where(deleted: false) }
  scope :opts, ->(query) { by_options(query.split(';').first.strip, query.split(';').last.strip) }
  scope :known, -> { joins('JOIN user_contacts ON user_contacts.phone_number_id = ads.phone_number_id') }

  scope :order_by_visit_for, ->(user) { joins(:ad_visits).joins("JOIN events ON events.user_id = ad_visits.user_id").where(ad_visits: { user_id: user.id }, events: { name: 'visited_ad' }).where("(events.data->>'ad_id')::integer = ads.id").order('events.created_at DESC') }
  scope :order_by_fav_for, ->(user) { joins(:ad_favorites).joins("JOIN events ON events.user_id = ad_favorites.user_id").where(ad_favorites: { user_id: user.id }, events: { name: 'favorited_ad' }).where("(events.data->>'ad_id')::integer = ads.id").order('events.created_at DESC') }

  accepts_nested_attributes_for :ad_query, :ad_description, :ad_extra, :ad_image_links_set, update_only: true
  accepts_nested_attributes_for :ad_images, allow_destroy: true

  attr_reader :my_ad

  def self.by_options(opt_type, opt_val)
    joins(:ad_extra).where(%[ad_extras.details @> '{"#{opt_type}": "#{opt_val}"}'])
  end

  def phone=(val)
    self.phone_number = PhoneNumber.by_full_number(val).first_or_create! if val.present?
  end

  def my_ad!
    @my_ad = true
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

  def details=(new_details)
    @details = nil

    raise unless new_details.is_a?(Hash)

    PrepareAdOptions.new.call(self, new_details)
  end

  # Override

  def reload
    @details = nil
    # @my_ad = nil # TODO
    super
  end

  def self.ransackable_scopes(_auth_object = nil)
    [:opts]
  end

  private

  def set_native_address
    self.address ||= "https://recar.io/ads/#{SecureRandom.uuid}"
  end

  def set_native_source
    self.ads_source ||= AdsSource.find_by(native: true)
  end

  def prepare_ad_price
    ad_prices.new(price: price_was) if price_changed?
  end
end
