# frozen_string_literal: true

FactoryBot.define do
  factory :verification_request do
    verification_code { rand(1000..9999) }
    phone_number
  end
end
