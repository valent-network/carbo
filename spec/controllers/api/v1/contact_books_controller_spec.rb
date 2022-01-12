# frozen_string_literal: true

require 'rails_helper'

RSpec.describe(Api::V1::ContactBooksController) do
  let(:user) { create(:user) }
  let(:ad) { create(:ad, :active) }

  before do
    allow(subject).to(receive(:current_user).and_return(user))
  end

  describe '#update' do
    it 'OK' do
      put :update, params: { id: ad.id }
      expect(response).to(be_ok)
    end
  end

  describe '#destroy' do
    it 'OK' do
      expect(USER_FRIENDS_GRAPH).to(receive(:delete_friends_for))
      delete :destroy, params: { id: ad.id }
      expect(response).to(be_ok)
    end
  end
end
