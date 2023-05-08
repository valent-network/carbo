# frozen_string_literal: true

require "rails_helper"

RSpec.describe(AdsGroupedByMakerModelYear) do
  describe ".by_budget" do
    it "returns aggregated results by { maker => [[model, {data}]] }" do
      ads = build_list(:ad, 10, :active)
      ads.each do |ad|
        ad.details = ad.details.merge("maker" => "BMW", "model" => "X6", "year" => "2015")
        ad.save
      end
      described_class.refresh(concurrently: false)
      min_price = ads.min_by(&:price).price
      max_price = ads.max_by(&:price).price
      avg_price = described_class.first.avg_price
      expect(described_class.by_budget(min_price, max_price)).to(eq("BMW" => [["X6", {min_year: 2015, min_price: min_price, max_price: max_price, max_year: 2015, avg_price: avg_price}]]))
    end
  end
end
