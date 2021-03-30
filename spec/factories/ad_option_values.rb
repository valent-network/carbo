# frozen_string_literal: true
FactoryBot.define do
  factory :ad_option_value do
    value { FFaker::Skill.specialty }
  end
end
