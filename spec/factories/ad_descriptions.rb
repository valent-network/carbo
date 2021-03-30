# frozen_string_literal: true
FactoryBot.define do
  factory :ad_description do
    ad
    body { FFaker::Lorem.sentences(5) }
  end
end
