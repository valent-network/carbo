# frozen_string_literal: true

FactoryBot.define do
  factory :category do
    name { FFaker::Sport.name }
    position { rand(10000) }
    currency { Category::CURRENCIES.sample }
  end
end
