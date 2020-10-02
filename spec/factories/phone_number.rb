# frozen_string_literal: true

FactoryBot.define do
  factory :phone_number do
    full_number { "93#{rand(1_000_000..9_999_999)}" }
  end
end
