# frozen_string_literal: true

FactoryBot.define do
  factory :ads_source do
    title { "#{FFaker::Internet.domain_name}.#{SecureRandom.urlsafe_base64(3)}" }
    api_token { SecureRandom.hex }
  end
end
