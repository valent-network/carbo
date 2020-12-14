# frozen_string_literal: true
FactoryBot.define do
  factory :user_device_stat do
    user_devices_appeared_count { rand(100) }
  end
end
