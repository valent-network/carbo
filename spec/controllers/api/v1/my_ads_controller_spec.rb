# frozen_string_literal: true

require "rails_helper"

RSpec.describe(Api::V1::MyAdsController) do
  let!(:user) { create(:user) }
  let!(:ad) { create(:ad, phone_number: user.phone_number) }

  before do
    allow(subject).to(receive(:current_user).and_return(user))
  end

  describe "#index" do
    it "OK" do
      get :index
      expect(json_body.map { |ad| ad["id"] }).to(eq([ad.id]))
    end
  end
end
