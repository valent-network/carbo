# frozen_string_literal: true

require 'rails_helper'

RSpec.describe(BudgetController) do
  before do
    5.times do
      ad = create(:ad, :active, :car)

      ad.update!(details: ad.details.merge(maker: 'BMW', model: 'X6', year: 2022))
    end
    AdsGroupedByMakerModelYear.refresh
  end

  describe '#search_models' do
    it 'OK' do
      get :search_models, params: { price: 10000 }
      expect(response).to(be_ok)
    end
  end

  describe '#show_model' do
    it 'OK' do
      get :show_model, params: { maker: 'BMW', model: 'X6' }
      expect(response).to(be_ok)
    end
  end

  describe '#show_model_year' do
    it 'OK' do
      get :show_model_year, params: { maker: 'BMW', model: 'X6', year: '2022' }
      expect(response).to(be_ok)
    end
  end

  describe '#show_ads' do
    it 'OK' do
      get :show_ads
      expect(response).to(be_ok)
    end
  end
end
