# frozen_string_literal: true
FactoryBot.define do
  factory :seller_name do
    ad
    value { FFaker::Name.name }
  end
end
