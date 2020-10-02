# frozen_string_literal: true

require 'rails_helper'

RSpec.describe(AdsController) do
  let!(:ad) { create(:ad) }

  describe '#show' do
    it 'OK' do
      get :show, params: { id: ad.id }
      expect(response).to(be_ok)
    end
  end
end
