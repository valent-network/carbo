# frozen_string_literal: true

class PhoneNumber < ApplicationRecord
  OPERATORS = %w[67 68 96 97 98 50 66 95 99 63 93 73 91 92 94].freeze
  validates :full_number, uniqueness: true, phone: {
    possible: true,
    allow_blank: false,
    types: [:mobile],
    countries: [:ua],
    extensions: false,
  }

  has_many :ads, dependent: :destroy
  has_many :user_contacts, dependent: :delete_all
  has_one :user, dependent: :destroy
  has_one :demo_phone_number, dependent: :destroy

  delegate :demo, :demo=, to: :demo_phone_number, allow_nil: true

  scope :having_one_ad, -> { joins(:ads).group('phone_numbers.id').having('COUNT(ads.*) = 1') }
  scope :having_two_or_three_ads, -> { joins(:ads).group('phone_numbers.id').having('COUNT(ads.*) BETWEEN 2 AND 3') }
  scope :having_four_to_ten_ads, -> { joins(:ads).group('phone_numbers.id').having('COUNT(ads.*) BETWEEN 4 AND 10') }
  scope :having_more_ten_ads, -> { joins(:ads).group('phone_numbers.id').having('COUNT(ads.*) >= 10') }

  scope :by_full_number, ->(phone_number) { where(full_number: Phonelib.parse(phone_number).national.to_s.gsub(/\s/, '').to_i) }

  def self.by_region(region_name)
    joins(ads: [city: [:region]]).where(regions: { name: region_name })
  end

  def self.not_registered_only(_value)
    where.not(id: User.select(:phone_number_id))
  end

  def self.ransackable_scopes(_auth_object = nil)
    [:by_region, :not_registered_only]
  end

  def to_s
    "+380#{full_number}"
  end

  def demo?
    demo_phone_number.present?
  end
end
