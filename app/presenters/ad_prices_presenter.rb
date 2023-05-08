# frozen_string_literal: true

class AdPricesPresenter
  def call(ad)
    ad.ad_prices.sort_by(&:created_at).reverse.map do |ap|
      [ap.created_at.strftime("%F"), ap.price]
    end
  end
end
