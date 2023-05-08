# frozen_string_literal: true

FactoryBot.define do
  factory :ad_favorite do
    user
    ad
  end
end
