# frozen_string_literal: true

require "rails_helper"

RSpec.describe(AdPricesPresenter) do
  subject { described_class.new.call(ad) }

  let(:ad) { create(:ad, :active, price: 100) }

  it "returns empty array for no ad versions" do
    expect(subject).to(eq([]))
  end

  it "returns [created_at, price] for version" do
    ad.update(price: 200)
    expect(subject).to(eq([[Time.zone.now.to_date.to_s, 100]]))
  end

  it "returns [created_at, price] for multiple versions" do
    ad.update(price: 200)
    ad.update(price: 300)
    expect(subject).to(eq([[Time.zone.now.to_date.to_s, 200], [Time.zone.now.to_date.to_s, 100]]))
  end

  it "keeps the first date when something was changed but not the price" do
    ad.update(price: 200)
    ad.update(price: 300)
    ad.update(deleted: true)
    ad.ad_prices.each_with_index { |ad_price, index| ad_price.update(created_at: (index + 1).days.ago) }
    expected_prices = [
      [1.days.ago.to_date.to_s, 100],
      [2.days.ago.to_date.to_s, 200]
    ]
    expect(subject).to(eq(expected_prices))
  end
end
