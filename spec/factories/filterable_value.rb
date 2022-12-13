# frozen_string_literal: true

FactoryBot.define do
  factory :filterable_value do
    ad_option_type
    name { FFaker::Vehicle.fuel_type.parameterize }
  end
end
