# frozen_string_literal: true
class AdCarShortDescriptionPresenter
  def call(details)
    result = []
    translated_details = translate(details)
    race_value = details['race'].to_i / 1000
    engine_capacity = (details['engine_capacity'].to_f / 1000).round(1)
    engine_string = engine_capacity.positive? ? I18n.t('ad_options.full_engine_value', engine_type: translated_details['fuel'], engine_capacity: engine_capacity) : translated_details['fuel']

    result << I18n.t('ad_options.race_value', value: race_value) if race_value.positive?
    result << translated_details['gear'] if translated_details['gear'].present?
    result << engine_string if translated_details['fuel'].present?
    result << I18n.t('ad_options.hp_value', value: details['horse_powers']) if details['horse_powers'].present?
    result << I18n.t('ad_options.city_value', value: details['city']) if details['city'].present?

    result.join(', ')
  end

  private

  def translate(details)
    groups = [
      ['fuel', details['fuel']],
      ['gear', details['gear']],
    ]

    FilterableValue.alias_group_name_for_alias(groups)
  end
end
