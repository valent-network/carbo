# frozen_string_literal: true

require 'rails_helper'

RSpec.describe(Api::V1::UsersController) do
  let(:user) { create(:user) }
  let(:device) { create(:user_device, user: user) }
  let(:ad) { create(:ad, :active) }

  before do
    allow(subject).to(receive(:current_user).and_return(user))
    allow(subject).to(receive(:current_device).and_return(device))
  end

  describe '#update' do
    context 'With valid params' do
      it 'OK' do
        old_name = user.name
        new_name = FFaker::Name.name
        expect { put(:update, params: { user: { name: new_name }, device: { os: 'android' } }) }.to(change { user.reload.name }.from(old_name).to(new_name))
        expect(response).to(be_ok)
      end
    end

    context 'With invalid params' do
      it 'does not save user and returns error' do
        invalid_name = 'a' * 10000
        expect { put(:update, params: { user: { name: invalid_name } }) }.not_to(change { user.reload.name })
        expect(response).to(be_unprocessable)
        expect(json_body['message']).to(eq('error'))
      end
    end
  end

  describe '#show' do
    it 'OK' do
      get :show
      expect(response).to(be_ok)
    end
  end
end
