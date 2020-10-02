# frozen_string_literal: true

FactoryBot.define do
  factory :user_contact do
    phone_number
    user
    name { FFaker::Name.name }
  end
end
