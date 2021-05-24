# frozen_string_literal: true

require 'rails_helper'

RSpec.describe(Api::V1::ProviderAdsController) do
  let!(:ads_source) { create(:ads_source, api_token: 'TOKEN') }
  let(:user) { create(:user) }
  let(:ad_params) do
    {
      price: 1000,
      deleted: false,
      phone: '+380931234567',
      ad_type: 'car',
      details: { race: 1000, maker: 'BMW', model: 'X6', address: 'http://example.com/ads/123', images_json_array_tmp: '[]' },
    }
  end

  before do
    allow(subject).to(receive(:current_user).and_return(user))
    request.headers.merge!('Authorization' => 'TOKEN')
  end

  describe '#index' do
    it 'OK' do
      get :index
      expect(response).to(be_ok)
    end
  end

  describe '#update_ad' do
    it 'OK' do
      put :update_ad, params: { ad: ad_params }
      expect(response).to(be_ok)
    end

    context 'With not successful ad#update' do
      it 'responds with error' do
        expect_any_instance_of(Ad).to(receive(:save).and_return(false))
        put :update_ad, params: { ad: ad_params }
        expect(response).to(be_unprocessable)
      end
    end

    context 'With invalid params' do
      it '#images_json_array_tmp' do
        ad_params = {
          price: 1000,
          deleted: false,
          phone: '+380931234567',
          ad_type: 'car',
          details: { race: 1000, maker: 'BMW', model: 'X6', address: 'http://example.com/ads/123', images_json_array_tmp: '' },
        }
        put :update_ad, params: { ad: ad_params }
        expect(response).to_not(be_ok)
        expect(json_body['errors']['details']['images_json_array_tmp']).to(eq(['failed to JSON.parse']))
      end
    end
  end

  describe '#delete_ad' do
    it 'OK' do
      ad = create(:ad, :active, ad_params.merge(ads_source_id: ads_source.id))
      delete :delete_ad, params: { ad: { details: { address: ad.address } } }
      expect(response).to(be_ok)
    end

    it 'sends error to Airbrake' do
      delete :delete_ad, params: { ad: { details: { address: 'invalid' } } }
      expect(response.status).to(eq(422))
      expect(json_body['error']).to(eq('invalid URL'))
    end
  end
end
