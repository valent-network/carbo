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
      fuel_opt_val = create(:ad).ad_options.where(ad_option_type: fuel_opt_type).first.ad_option_value
      create(:filterable_value, ad_option_type: fuel_opt_type, ad_option_value: fuel_opt_val, name: 'diesel')

      { diesel: 'Diesel', lpg: 'LPG', petrol: 'Petrol', other: 'Other' }.each do |k, v|
        create(:filterable_value_translation, ad_option_type: fuel_opt_type, name: v, alias_group_name: k, locale: 'en')
      end

      gear_opt_type = AdOptionType.find_by_name('gear')
      gear_opt_val = create(:ad).ad_options.where(ad_option_type: gear_opt_type).first.ad_option_value
      create(:filterable_value, ad_option_type: gear_opt_type, ad_option_value: gear_opt_val, name: 'diesel')
      create(:filterable_value_translation, ad_option_type: gear_opt_type, name: 'Diesel', alias_group_name: 'diesel', locale: 'en')

      wheels_opt_type = AdOptionType.find_by_name('wheels')
      wheels_opt_val = create(:ad).ad_options.where(ad_option_type: wheels_opt_type).first.ad_option_value
      create(:filterable_value, ad_option_type: wheels_opt_type, ad_option_value: wheels_opt_val, name: 'diesel')
      create(:filterable_value_translation, ad_option_type: wheels_opt_type, name: 'Diesel', alias_group_name: 'diesel', locale: 'en')

      carcass_opt_type = AdOptionType.find_by_name('carcass')
      carcass_opt_val = create(:ad).ad_options.where(ad_option_type: carcass_opt_type).first.ad_option_value
      create(:filterable_value, ad_option_type: carcass_opt_type, ad_option_value: carcass_opt_val, name: 'diesel')
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
