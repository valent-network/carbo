# frozen_string_literal: true

FactoryBot.define do
  factory :filterable_value_translation do
    ad_option_type
    name { FFaker::Vehicle.fuel_type.parameterize }
    alias_group_name { FFaker::Vehicle.fuel_type }
    locale { %w[en uk].sample }
  end
end
