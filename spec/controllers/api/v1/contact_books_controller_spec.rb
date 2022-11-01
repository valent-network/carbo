# frozen_string_literal: true

require 'rails_helper'

RSpec.describe(Api::V1::ContactBooksController) do
  let(:user) { create(:user) }
  let(:ad) { create(:ad, :active) }

  before do
    allow(subject).to(receive(:current_user).and_return(user))
  end

  describe '#update' do
    it 'OK with no contacts' do
      put :update, params: { id: ad.id }
      expect(response).to(be_ok)
    end

    it 'OK with existing contacts' do
      put :update, params: { id: ad.id, contacts: [{ name: "Viktor", 'phoneNumbers': ["+380932345678"] }] }
      expect(response).to(be_ok)
    end

    it 'OK with invalid contacts' do
      put :update, params: { id: ad.id, contacts: "invalid" }
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
