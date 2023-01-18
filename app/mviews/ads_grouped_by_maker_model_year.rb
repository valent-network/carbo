# frozen_string_literal: true

class AdsGroupedByMakerModelYear < MatviewModel
  self.table_name = 'ads_grouped_by_maker_model_year'

  def self.by_budget(min, max)
    where('? BETWEEN min_price AND max_price OR ? BETWEEN min_price AND max_price', min, max)
      .group_by(&:maker)
      .transform_values do |all_maker_models|
        all_maker_models.group_by(&:model).transform_values do |models|
          {
            min_year: models.min_by(&:year).year.to_i,
            max_year: models.max_by(&:year).year.to_i,
            min_price: models.min_by(&:min_price).min_price,
            max_price: models.max_by(&:max_price).max_price,
            avg_price: (models.sum(&:avg_price).to_f / models.count).to_i,
          }
        end.sort_by(&:first)
          .sort_by(&:first)
      end
  end
end
