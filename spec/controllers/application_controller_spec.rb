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
    before do
      fuel_opt_type = AdOptionType.find_by_name('fuel')
      create(:filterable_value, ad_option_type: fuel_opt_type, name: 'diesel')

      { diesel: 'Diesel', lpg: 'LPG', petrol: 'Petrol', other: 'Other' }.each do |k, v|
        create(:filterable_value_translation, ad_option_type: fuel_opt_type, name: v, alias_group_name: k, locale: 'en')
      end

      gear_opt_type = AdOptionType.find_by_name('gear')
      create(:filterable_value, ad_option_type: gear_opt_type, name: 'diesel')
      create(:filterable_value_translation, ad_option_type: gear_opt_type, name: 'Diesel', alias_group_name: 'diesel', locale: 'en')

      wheels_opt_type = AdOptionType.find_by_name('wheels')
      create(:filterable_value, ad_option_type: wheels_opt_type, name: 'diesel')
      create(:filterable_value_translation, ad_option_type: wheels_opt_type, name: 'Diesel', alias_group_name: 'diesel', locale: 'en')

      carcass_opt_type = AdOptionType.find_by_name('carcass')
      create(:filterable_value, ad_option_type: carcass_opt_type, name: 'diesel')
      create(:filterable_value_translation, ad_option_type: carcass_opt_type, name: 'Diesel', alias_group_name: 'diesel', locale: 'en')
    end

    it 'OK' do
      get :filters
      expect(response).to(be_ok)
      expect(json_body.keys).to(match_array(%w[fuels gears wheels carcasses hops_count]))
      expect(json_body['fuels']).to(match_array(["Diesel", "LPG", "Petrol", "Other"]))
    end
  end
end
