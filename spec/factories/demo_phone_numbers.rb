# frozen_string_literal: true

FactoryBot.define do
  factory :demo_phone_number do
    phone_number
    demo_code { rand(1000..9999) }
  end
end
