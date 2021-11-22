# frozen_string_literal: true

require 'rails_helper'

RSpec.describe(ApplicationController) do
  describe '#landing' do
    it 'OK' do
      get :landing
      expect(response).to(be_ok)
    end
  end

  describe '#filters' do
    it 'OK' do
      get :filters
      expect(response).to(be_ok)
      expect(json_body.keys).to(match_array(%w[fuels gears wheels carcasses hops_count]))
      expect(json_body['fuels']).to(eq(['Газ', 'Газ / Бензин', 'Бензин', 'Гибрид', 'Дизель', 'Электро']))
    end
  end
end
