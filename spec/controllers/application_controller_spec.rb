# frozen_string_literal: true

require 'rails_helper'

RSpec.describe(ApplicationController) do
  describe '#langing' do
    it 'OK' do
      get :landing
      expect(response).to(be_ok)
    end
    it 'OK' do
      get :filters
      expect(response).to(be_ok)
      expect(json_body.keys).to(match_array(%w[fuels gears wheels carcasses]))
      expect(json_body['fuels']).to(eq(['Газ', 'Газ / Бензин', 'Бензин', 'Гибрид', 'Дизель', 'Электро']))
    end
  end
end
