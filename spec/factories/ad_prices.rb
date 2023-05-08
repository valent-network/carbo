# frozen_string_literal: true

FactoryBot.define do
  factory :ad_price do
    ad
    price { rand(10_000) }
  end
end
