# frozen_string_literal: true
FactoryBot.define do
  factory :state_num do
    ad
    value { rand(100_000..999_999).to_s }
  end
end
