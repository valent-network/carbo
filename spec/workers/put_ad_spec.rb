# frozen_string_literal: true

require "rails_helper"

def prepare_params(data)
  Base64.urlsafe_encode64(Zlib.deflate(data.to_json))
end

RSpec.describe(PutAd) do
  let!(:ads_source) { create(:ads_source, title: PutAd::PROVIDER_NAME) }
  it "requires base64(zip(ad_params))" do
    expect { subject.perform("INVALID") }.to(raise_error(ArgumentError, /invalid base64/))
  end

  context "when Ad exists" do
    let(:ad) { create(:ad) }

    context "with new data" do
      it "changes Ad#updated_at" do
        new_data = {price: ad.price + 1000, phone: ad.phone_number.to_s, deleted: false, details: ad.details.merge(images_json_array_tmp: "[]", address: ad.address, region: [ad.city.name, ad.region.name])}
        expect { subject.perform(prepare_params(new_data)) }.to change { ad.reload.updated_at }
      end
    end
    context "without new data" do
      it "doesn't change Ad#updated_at" do
        same_data = {price: ad.price, phone: ad.phone_number.to_s, deleted: false, details: ad.details.merge(images_json_array_tmp: ad.details["images_json_array_tmp"], address: ad.address, region: [ad.city.name, ad.region.name])}
        expect { subject.perform(prepare_params(same_data)) }.to_not change { ad.reload.updated_at }
      end
    end
  end
end
