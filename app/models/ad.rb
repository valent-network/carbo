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
  has_many :ad_options, dependent: :delete_all, autosave: true
  has_one :ad_description, dependent: :delete
  has_one :ad_image_links_set, dependent: :delete

  scope :active, -> { where(deleted: false) }

  def self.by_options(opt_name, opt_id, val_ids)
    val_ids = Array.wrap(val_ids).map(&:to_i).join(',')
    joins("JOIN ad_options AS opt_#{opt_name} ON ads.id = opt_#{opt_name}.ad_id AND opt_#{opt_name}.ad_option_type_id = #{opt_id} AND opt_#{opt_name}.ad_option_value_id IN (#{val_ids})")
  end

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

  def new_details
    return @new_details if @new_details

    rel = ad_options.loaded? ? ad_options : ad_options.includes(:ad_option_type, :ad_option_value)

    opts_array = rel.map do |opt|
      [opt.ad_option_type.name, opt.ad_option_value.value]
    end

    @new_details = Hash[opts_array].merge('description' => ad_description&.body, 'images_json_array_tmp' => ad_image_links_set&.value)
  end

  # Override

  def reload
    @new_details = nil
    super
  end

  private

  def details_object
    errors.add(:details, 'must be a Hash') unless details.is_a?(Hash)
  end

  def prepare_ad_price
    ad_prices.new(price: price_was) if price_changed?
  end
end
