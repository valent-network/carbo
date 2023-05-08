# frozen_string_literal: true

FactoryBot.define do
  factory :user_connection do
    user
    association :connection, factory: :user
    association :friend, factory: :user
  end
end
