# frozen_string_literal: true

require 'rails_helper'

RSpec.describe(Api::V1::FeedAdsController) do
  let!(:user) { create(:user) }
  let!(:friend) { create(:user) }
  let!(:friend_contact) { create(:user_contact, user: user, phone_number: friend.phone_number) }
  let!(:ad) { create(:ad, :active, phone_number: friend.phone_number) }

  before do
    allow(subject).to(receive(:current_user).and_return(user))
  end

  describe '#index' do
    it 'OK' do
      get :index
      expect(response).to(be_ok)
    end

    it 'returns friend_name_and_total in serialzier' do
      EffectiveAd.refresh
      EffectiveUserContact.refresh
      get :index
      ads = json_body
      ad = ads.first
      expect(ads.count).to(eq(1))
      expect(ad['friend_name_and_total']['count']).to(eq(0))
      expect(ad['friend_name_and_total']['name']).to(eq(friend_contact.name))
    end

    it 'filters ads' do
      get :index, params: { filters: { min_price: ad.price + 1000 } }
      expect(json_body.count).to(eq(0))
    end

    context 'Not authenticated' do
      it 'fails with 401' do
        allow(subject).to(receive(:current_user).and_return(nil))
        get :index
        expect(response).to(be_unauthorized)
      end
    end
  end
end
