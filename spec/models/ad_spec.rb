# frozen_string_literal: true

require "rails_helper"

RSpec.describe(Ad) do
  let(:ad) { create(:ad, :active) }

  describe "#associate_friends_with" do
    subject { ad.friend_name_and_total }

    it "returns nil if no friends provided"

    it "returns nil if friend not associated to ad (?)"

    it "selects the closest-hand friend"

    it "result count excludes associated friend"
  end

  describe "#ad_prices" do
    it "creates AdPrice record on price update" do
      expect { ad.update(price: ad.price + 1000) }.to(change { ad.reload.ad_prices.count }.from(0).to(1))
    end

    it "does not create AdPrice record when Ad was updated but not price" do
      expect { ad.update(deleted: true) }.not_to(change { ad.reload.ad_prices.count })
    end

    it "does not create AdPrice record when Ad was created" do
      expect { create(:ad, :active) }.not_to(change(AdPrice, :count))
    end
  end

  describe "#details" do
    it ".city"
    it ".images_json_array_tmp"
    it "description"
  end
end
