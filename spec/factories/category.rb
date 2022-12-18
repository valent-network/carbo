# frozen_string_literal: true

FactoryBot.define do
  factory :category do
    name { FFaker::Sport.name }
  end
end
