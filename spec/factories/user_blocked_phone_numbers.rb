# frozen_string_literal: true
FactoryBot.define do
  factory :user_blocked_phone_number do
    user
    phone_number
  end
end
