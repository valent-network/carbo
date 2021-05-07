# frozen_string_literal: true
class AdPricesPresenter
  def call(ad)
    ad.ad_prices.order(created_at: :desc).pluck(:created_at, :price).map do |ap|
      [ap.first.strftime('%F'), ap.last]
    end
  end
end
