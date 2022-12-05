# frozen_string_literal: true
class AdOptionValue < ApplicationRecord
  has_many :ad_options
  has_many :ad_option_types, through: :ad_options
  has_many :filterable_values

  scope :of_type, ->(option_type) { joins(ad_options: :ad_option_type).where(ad_option_types: { name: option_type }).distinct(:value) }
  scope :non_filterable, ->(_) { left_joins(:filterable_values).where(filterable_values: { id: nil }) }

  validates :value, presence: true, uniqueness: true

  def self.ransackable_scopes(_auth_object = nil)
    [:of_type, :non_filterable]
  end

  def display_name
    value
  end
end
