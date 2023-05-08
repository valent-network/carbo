# frozen_string_literal: true

class AdCarShortDescriptionPresenter
  def call(details)
    result = []
    translated_details = translate(details)
    race_value = details["race"].to_i / 1000
    engine_capacity = (details["engine_capacity"].to_f / 1000).round(1)
    engine_string = engine_capacity.positive? ? I18n.t("ad_options.full_engine_value", engine_type: translated_details["fuel"], engine_capacity: engine_capacity) : translated_details["fuel"]

    result << I18n.t("ad_options.race_value", value: race_value) if race_value.positive?
    result << translated_details["gear"] if translated_details["gear"].present?
    result << engine_string if translated_details["fuel"].present?
    result << I18n.t("ad_options.hp_value", value: details["horse_powers"]) if details["horse_powers"].present?
    result << I18n.t("ad_options.city_value", value: details["city"]) if details["city"].present?

    result.join(", ")
  end

  private

  def translate(details)
    groups = [
      ["fuel", details["fuel"]],
      ["gear", details["gear"]]
    ]

    raw_value_to_translation_for_groups(groups)
  end

  #  [ [AdOptionType#name, FilterableValue#raw_value], ... ] => { AdOptionType#name => Translation }
  #  [ ['fuel', 'Gasoline'], ... ] => { 'fuel': 'lpg' }
  # assume 1:1 mapping of AdOptionType#name + FilterableValue#raw_value + Locale => Translation
  def raw_value_to_translation_for_groups(groups)
    filters = CachedSettings.new.filters

    groups.reject { |g| g.last.blank? }.map do |g|
      option_type, raw_value = g
      value_group = filters[option_type]&.detect { |group| group.last.map(&:to_s).map(&:downcase).include?(raw_value.to_s.downcase) }&.first

      [
        option_type,
        value_group ? I18n.t("filters.types.#{option_type}.#{value_group}") : nil
      ]
    end.to_h
  end
end
