# frozen_string_literal: true

FactoryBot.define do
  factory :region do
    name { FFaker::AddressUS.state }
  end
end
