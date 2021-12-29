# frozen_string_literal: true

require 'rails_helper'

RSpec.describe(PromoEventsController) do
  let!(:ad) { create(:ad) }

  describe '#index' do
    it 'OK' do
      get :index
      expect(response).to(be_ok)
    end
  end
end
