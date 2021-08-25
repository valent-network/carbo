# frozen_string_literal: true
class AdCarShortDescriptionPresenter
  def call(details)
    result = []
    race_value = details['race'].to_i / 1000
    engine_value = (details['engine_capacity'].to_f / 1000).round(1)
    engine_string = engine_value.positive? ? "#{details['fuel']} #{engine_value} л" : details['fuel']

    result << "#{race_value} тыс. км" if race_value.positive?
    result << details['gear'] if details['gear'].present?
    result << engine_string if details['fuel'].present?
    result << "#{details['horse_powers']} л. с" if details['horse_powers'].present?

    result.join(', ')
  end
end
