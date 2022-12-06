# frozen_string_literal: true
class AdOptionValue < ApplicationRecord
  has_many :ad_options, dependent: :delete_all
  has_many :ad_option_types, through: :ad_options
  has_many :ads, through: :ad_options
  has_many :filterable_values

  scope :of_type, ->(option_type) { left_joins(ad_options: :ad_option_type).where(ad_option_types: { name: option_type }).distinct(:value) }
  scope :non_filterable, ->(_) { left_joins(:filterable_values).where(filterable_values: { id: nil }) }
  scope :without_ad_options, ->(_) { left_joins(:ad_options).where(ad_options: { id: nil }) }
  scope :without_active_ads, ->(_) { joins(:ads).group("ad_option_values.id").having('TRUE = ALL(ARRAY_AGG(ads.deleted))') }

  validates :value, presence: true, uniqueness: true

  def self.ransackable_scopes(_auth_object = nil)
    [:of_type, :non_filterable, :without_ad_options, :without_active_ads]
  end

  def display_name
    value
  end
end
