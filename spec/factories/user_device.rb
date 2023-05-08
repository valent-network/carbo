# frozen_string_literal: true

FactoryBot.define do
  factory :user_device do
    user
    device_id { SecureRandom.hex }
    access_token { SecureRandom.hex }
    os { %w[android ios].sample }
    push_token { SecureRandom.hex }

    before(:create) do |user_device|
      user_device.build_version ||= (user_device.os == "ios") ? "1.9" : "26"
    end
  end
end
