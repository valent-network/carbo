# frozen_string_literal: true
class AdCarOptionsPresenter
  def call(ad_details)
    res = {}

    race_value = ad_details['race'].to_i / 1000
    engine_value = (ad_details['engine_capacity'].to_f / 1000).round(1)

    engine = I18n.t('ad_options.engine_value', value: engine_value, fuel_type: ad_details['fuel']) if ad_details['engine_capacity'].to_f.positive?
    race = I18n.t('ad_options.race_value', value: race_value) if ad_details['race'].to_i.positive?

    res[:engine] = [I18n.t('ad_options.engine'), engine]
    res[:race] = [I18n.t('ad_options.race'), race]
    res[:gear] = [I18n.t('ad_options.gear'), ad_details['gear']]
    res[:wheels] = [I18n.t('ad_options.wheels'), ad_details['wheels']]
    res[:carcass] = [I18n.t('ad_options.carcass'), ad_details['carcass']]
    res[:color] = [I18n.t('ad_options.color'), ad_details['color']]
    res[:year] = [I18n.t('ad_options.year'), ad_details['year']]
    res[:horse_powers] = [I18n.t('ad_options.horse_powers'), "#{ad_details['horse_powers']} л.с"] if ad_details['horse_powers'].to_i.positive?

    res.select { |_k, v| v.last.present? }
  end
end
