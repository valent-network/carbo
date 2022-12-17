# frozen_string_literal: true
class FiltersJsonUpdater
  REDIS_KEY = 'global_filter'

  def call
    json = FilterableValue
      .includes(:ad_option_type)
      .joins(:ad_option_type)
      .map { |fv| [fv.ad_option_type.name, [fv.name, fv.raw_value]] }
      .group_by(&:first)
      .transform_values do |v|
        v.map(&:last).group_by(&:first).transform_values { |group| group.map(&:last) }
      end
      .to_json

    REDIS.set(REDIS_KEY, json)
    json
  end
end
