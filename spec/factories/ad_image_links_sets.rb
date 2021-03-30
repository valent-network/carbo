# frozen_string_literal: true
FactoryBot.define do
  factory :ad_image_links_set do
    ad
    value { ["#{FFaker::Internet.domain_name}.#{SecureRandom.urlsafe_base64(3)}"] }
  end
end
