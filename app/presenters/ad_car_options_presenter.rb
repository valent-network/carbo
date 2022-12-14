# frozen_string_literal: true
class AdCarOptionsPresenter
  def call(ad_details)
    res = {}

    race_value = ad_details['race'].to_i / 1000
    race = I18n.t('ad_options.race_value', value: race_value) if ad_details['race'].to_i.positive?
    engine_value = (ad_details['engine_capacity'].to_f / 1000).round(1)

    translations = FilterableValue.raw_value_to_translation_for_groups([
      ['fuel', ad_details['fuel']],
      ['gear', ad_details['gear']],
      ['wheels', ad_details['wheels']],
      ['carcass', ad_details['carcass']],
      ['color', ad_details['color']],
    ])

    engine = I18n.t('ad_options.engine_value', value: engine_value, fuel_type: translations['fuel']) if ad_details['engine_capacity'].to_f.positive?

    res[:engine] = [I18n.t('ad_options.engine'), engine]

    res[:gear] = [I18n.t('ad_options.gear'), translations['gear']]
    res[:wheels] = [I18n.t('ad_options.wheels'), translations['wheels']]
    res[:carcass] = [I18n.t('ad_options.carcass'), translations['carcass']]
    res[:color] = [I18n.t('ad_options.color'), translations['color']]

    res[:location] = [I18n.t('ad_options.location'), ad_details['region']] if ad_details['region'].present?

    res[:race] = [I18n.t('ad_options.race'), race]
    res[:year] = [I18n.t('ad_options.year'), ad_details['year']]

    res[:horse_powers] = [I18n.t('ad_options.horse_powers'), I18n.t('ad_options.hp_value', value: ad_details['horse_powers'])] if ad_details['horse_powers'].to_i.positive?

    res.select { |_k, v| v.last.present? }
  end
end
