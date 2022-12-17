# frozen_string_literal: true
class InvisibleFilterValues
  def call(option_types = FilterableValue::FILTERABLE_OPTIONS)
    option_types_clause = option_types.map do |option_type|
      <<~SQL
        SELECT DISTINCT '#{option_type}' AS ad_option_type, details->>'#{option_type}' AS option_value
        FROM ad_extras
        WHERE details->>'#{option_type}' IS NOT NULL AND details->>'#{option_type}' != ''
      SQL
    end

    <<~SQL
      SELECT ad_option_type, option_value
      FROM (
        #{option_types_clause.join("\nUNION ALL\n")}
      ) AS t
      JOIN ad_option_types ON ad_option_types.name = t.ad_option_type
      LEFT JOIN filterable_values ON filterable_values.raw_value = t.option_value AND ad_option_types.id = filterable_values.ad_option_type_id
      WHERE filterable_values.id IS NULL
    SQL
  end
end
