# frozen_string_literal: true
class FilterableValue < ApplicationRecord
  MOBILE_MAPPING = {
    fuel: :fuels,
    gear: :gears,
    carcass: :carcasses,
    wheels: :wheels,
  }

  belongs_to :ad_option_type

  validates :name, :raw_value, presence: true

  after_save :update_global_filter

  #  [ [AdOptionType#name, FilterableValue#raw_value], ... ] => { AdOptionType#name => Translation }
  #  [ ['fuel', 'Gasoline'], ... ] => { 'fuel': 'lpg' }
  # assume 1:1 mapping of AdOptionType#name + FilterableValue#raw_value + Locale => Translation
  def self.raw_value_to_translation_for_groups(groups)
    groups.reject { |g| g.last.blank? }.map { |g| [g.first, raw_value_to_translation(g.first, g.last)] }.to_h
  end

  def self.raw_value_to_value_group(option_type, raw_value)
    global_json[option_type]&.detect { |group| group.last.map(&:to_s).map(&:downcase).include?(raw_value.to_s.downcase) }&.first
  end

  def self.value_group_to_raw_values(option_type, value_group)
    global_json[option_type]&.detect { |group| group.first.to_s.casecmp(value_group.to_s).zero? }&.last
  end

  def self.raw_value_to_translation(option_type, raw_value)
    value_group = global_json[option_type]&.detect { |group| group.last.map(&:to_s).map(&:downcase).include?(raw_value.to_s.downcase) }&.first
    return unless value_group

    I18n.t("filters.types.#{option_type}.#{value_group}")
  end

  def self.translation_to_raw_values(option_type, translation)
    value_group = I18n.t("filters.types.#{option_type}").detect { |t| t.last.to_s.casecmp(translation.to_s).zero? }.first
    global_json[option_type].try(:[], value_group.to_s)
  end

  def self.filters
    global_json.select { |option_type, _| MOBILE_MAPPING[option_type.to_sym].present? }.map do |option_type, option_value_groups|
      [
        MOBILE_MAPPING[option_type.to_sym],
        option_value_groups.keys.map { |value_group| I18n.t("filters.types.#{option_type}.#{value_group}") }
      ]
    end.to_h
  end

  private_class_method def self.global_json
    json = REDIS.get(FiltersJsonUpdater::REDIS_KEY).presence ||
      FiltersJsonUpdater.new.call.presence ||
      '{}'

    JSON.parse(json)
  rescue StandardError => e
    Rails.logger.warn(e)
    {}
  end

  private

  def update_global_filter
    FiltersJsonUpdater.new.call
  end
end
