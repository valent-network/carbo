# frozen_string_literal: true
FactoryBot.define do
  factory :region do
    name { FFaker::Address.us_state }
  end
end
