# frozen_string_literal: true

require "rails_helper"

RSpec.describe(ApplicationController) do
  describe "#filters" do
    before do
      create(:filterable_value, ad_option_type: AdOptionType.find_by_name("fuel"), name: "diesel", raw_value: "Diesel (raw)")
      create(:filterable_value, ad_option_type: AdOptionType.find_by_name("fuel"), name: "lpg", raw_value: "Methane (raw)")
      create(:filterable_value, ad_option_type: AdOptionType.find_by_name("fuel"), name: "petrol", raw_value: "Petrol (raw)")
      create(:filterable_value, ad_option_type: AdOptionType.find_by_name("fuel"), name: "other", raw_value: "Other (raw)")

      create(:filterable_value, ad_option_type: AdOptionType.find_by_name("gear"), name: "auto", raw_value: "Automatic (raw)")
      create(:filterable_value, ad_option_type: AdOptionType.find_by_name("wheels"), name: "awd", raw_value: "4WD (raw)")
      create(:filterable_value, ad_option_type: AdOptionType.find_by_name("carcass"), name: "sedan", raw_value: "Sedan (raw)")
    end

    it "OK" do
      get :filters
      expect(response).to(be_ok)
      expect(json_body.keys).to(match_array(%w[fuels gears wheels carcasses hops_count]))
      expect(json_body["fuels"]).to(match_array(["Diesel", "LPG", "Petrol", "Others"]))
    end
  end
end
