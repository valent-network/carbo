# frozen_string_literal: true
class FilterableValueTranslation < ApplicationRecord
  belongs_to :ad_option_type
  validates :name, presence: true, uniqueness: { scope: [:ad_option_type_id, :locale] }
  validates :locale, presence: true, inclusion: { in: %w[en uk] }
  validates :alias_group_name, presence: true
  has_many :filterable_values, foreign_key: :name, primary_key: :alias_group_name

  def self.all_values_grouped
    joins(:ad_option_type, filterable_values: [:ad_option_value]).where(locale: :en).pluck('ad_option_types.name, ad_option_values.value').group_by(&:first).transform_values { |v| v.map(&:last) }
  end

  def self.aliases_for(option_type_name, translated_name)
    aliases = unscoped.joins(:ad_option_type).where(ad_option_types: { name: option_type_name }).where('LOWER(filterable_value_translations.name) = ?', translated_name.downcase)

    raise if aliases.count > 1

    als = aliases.first
    return [] unless als

    als.ad_option_type.filterable_values.joins(:ad_option_value).where(name: als.alias_group_name).pluck('ad_option_values.value')
  end
end
