# frozen_string_literal: true
FactoryBot.define do
  factory :static_page do
    title { FFaker::Lorem.sentence }
    slug { FFaker::Lorem.word }
    body { FFaker::Lorem.sentences.join("\n") }
  end
end
