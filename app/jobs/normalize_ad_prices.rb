# frozen_string_literal: true

class NormalizeAdPrices < ApplicationJob
  queue_as(:default)

  def perform(ad_ids)
    ads = Ad.where(id: JSON.parse(ad_ids))

    ads.each do |ad|
      prices = AdPricesPresenter.new.call(ad)
      prices.each do |price_record|
        created_at, price = price_record
        ad.ad_prices.create(price: price, created_at: created_at)
      end
    end
  end
end
