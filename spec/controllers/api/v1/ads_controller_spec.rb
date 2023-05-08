# frozen_string_literal: true

require "rails_helper"

RSpec.describe(Api::V1::AdsController) do
  let!(:user) { create(:user) }
  let!(:friend) { create(:user) }
  let!(:friend_contact) { create(:user_contact, user: user, phone_number: friend.phone_number) }
  let!(:ad) { create(:ad, :active, phone_number: friend.phone_number) }

  before do
    allow(subject).to(receive(:current_user).and_return(user))
  end

  describe "#show" do
    it "OK" do
      ad.update(price: ad.price + 100)
      get :show, params: {id: ad.id}
      expect(response).to(be_ok)
    end
  end
end
