# frozen_string_literal: true
class FilterableValue < ApplicationRecord
  belongs_to :ad_option_value
  belongs_to :ad_option_type
  validates :name, presence: true
  validates :ad_option_value, uniqueness: { scope: [:ad_option_type] }

  #  [ [AdOptionType#name, AdOptionValue#value], ... ] => { AdOptionType#name => FilterableValueTranslation#name }
  #  [ ['fuel', 'Gasoline'], ... ] => { 'fuel': 'lpg' }
  # assume 1:1 mapping of AdOptionType#name + AdOptionValue#value + Locale => FilterableValueTranslation#name
  def self.alias_group_name_for_alias(groups)
    joins(:ad_option_type, :ad_option_value)
      .joins("JOIN filterable_value_translations AS fvt ON fvt.locale = '#{I18n.locale}' AND fvt.ad_option_type_id = filterable_values.ad_option_type_id AND fvt.alias_group_name = filterable_values.name")
      .where(ad_option_types: { name: groups.map(&:first) }, ad_option_values: { value: groups.map(&:last) })
      .pluck('ad_option_types.name, fvt.name')
      .to_h
  end
end
