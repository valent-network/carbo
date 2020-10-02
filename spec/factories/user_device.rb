# frozen_string_literal: true

FactoryBot.define do
  factory :user_device do
    user
    device_id { SecureRandom.hex }
    access_token { SecureRandom.hex }
    os { %w[android ios].sample }
  end
end
