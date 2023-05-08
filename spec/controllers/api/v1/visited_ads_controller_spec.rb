# frozen_string_literal: true

require "rails_helper"

RSpec.describe(Api::V1::VisitedAdsController) do
  let!(:user) { create(:user) }
  let!(:ad) { create(:ad) }
  let!(:ad_visit) { create(:ad_visit, ad: ad, user: user) }

  before do
    allow(subject).to(receive(:current_user).and_return(user))
  end

  describe "#index" do
    it "OK" do
      # Emulate background worker
      CreateEvent.new.perform(user.id, "visited_ad", Time.zone.now.to_i, {ad_id: ad.id}.to_json)

      get :index
      expect(json_body.map { |ad| ad["id"] }).to(eq([ad.id]))
    end
  end
end
