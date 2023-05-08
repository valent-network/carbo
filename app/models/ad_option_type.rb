# frozen_string_literal: true

class AdOptionType < ApplicationRecord
  include SettingsImpactable

  INPUT_TYPES = %w[default number picker]

  validates :name, presence: true, uniqueness: true
  validates :filterable, inclusion: {in: [true, false]}
  validates :input_type, inclusion: {in: INPUT_TYPES}, presence: true

  has_many :filterable_values, dependent: :destroy
  has_many :groups, dependent: :destroy, class_name: "FilterableValuesGroup"

  belongs_to :category

  scope :filterable, -> { where(filterable: true) }

  def known_options
    options_from_ads = KnownOption.where(k: name)
      .joins("LEFT JOIN filterable_values ON LOWER(filterable_values.raw_value) = LOWER(known_options.v)")
      .where(filterable_values: {id: nil})
      .pluck(:v)

    existing_filterable_values = filterable_values.pluck(:raw_value)
    options_from_translations = groups.map(&:translations).map(&:values).flatten.reject { |v| v.in?(existing_filterable_values) }.compact

    options_from_ads + options_from_translations
  end
end
