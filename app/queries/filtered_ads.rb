# frozen_string_literal: true

class FilteredAds
  def call(filters:, should_search_query:)
    ads = Ad.active.distinct(:id)

    ads = ads.where("price >= ?", filters["min_price"].to_i) if filters["min_price"].present?
    ads = ads.where("price <= ?", filters["max_price"].to_i) if filters["max_price"].present?
    ads = ads.where(category_id: filters["category_id"]) if filters["category_id"].present?

    ads = ads.joins(:ad_extra) if filters["extra"].present?

    filters["extra"].each do |opt_type, raw_values|
      filter_clause = raw_values.map do |raw_value|
        # TODO: temporary workaround because year can be either string or integer
        if opt_type == "year"
          [
            %[(ad_extras.details @> '{"#{opt_type}": "#{raw_value}"}')],
            %[(ad_extras.details @> '{"#{opt_type}": #{raw_value.to_i}}')]
          ]
        else
          %[(ad_extras.details @> '{"#{opt_type}": "#{raw_value}"}')]
        end
      end.flatten.join(" OR\n")

      ads = ads.where(filter_clause)
    end

    if filters["query"].present? && should_search_query
      ads = ads.joins(:ad_query).where("ad_queries.title ILIKE ?", "%#{filters["query"].strip}%")
    end

    ads
  end
end
