# frozen_string_literal: true

require 'rails_helper'

RSpec.describe(Api::V1::FavoriteAdsController) do
  let!(:user) { create(:user) }
  let!(:ad) { create(:ad) }

  before do
    allow(subject).to(receive(:current_user).and_return(user))
  end

  describe '#index' do
    before do
      create(:ad_favorite, ad: ad, user: user)
    end
    it 'OK' do
      get :index
      expect(json_body.map { |ad| ad['id'] }).to(eq([ad.id]))
    end
  end

  describe '#create' do
    context 'With valid params' do
      it 'creates fav record' do
        expect { post(:create, params: { id: ad.id }) }.to(change { user.ad_favorites.where(ad: ad).count }.from(0).to(1))
        expect(response).to(be_ok)
        expect(json_body['message']).to(eq('ok'))
      end
    end

    context 'With invalid params' do
      it 'does not create record' do
        expect { post(:create, params: { id: 'INVALID' }) }.to_not(change { user.ad_favorites.where(ad: ad).count })
        expect(response).to(be_unprocessable)
        expect(json_body['message']).to(eq('error'))
        expect(json_body['errors']).to(eq(['Ad must exist']))
      end
    end
  end

  describe '#destroy' do
    context 'With valid params' do
      it 'destroy fav record' do
        create(:ad_favorite, ad: ad, user: user)
        expect { delete(:destroy, params: { id: ad.id }) }.to(change { user.ad_favorites.where(ad: ad).count }.from(1).to(0))
        expect(response).to(be_ok)
        expect(json_body['message']).to(eq('ok'))
      end
    end

    context 'With invalid params' do
      it 'does not destroy record' do
        expect { delete(:destroy, params: { id: 'INVALID' }) }.to_not(change { user.ad_favorites.where(ad: ad).count })
        expect(response).to(be_unprocessable)
        expect(json_body['message']).to(eq('error'))
        expect(json_body['errors']).to(eq(['Ad must exist']))
      end
    end
  end
end
