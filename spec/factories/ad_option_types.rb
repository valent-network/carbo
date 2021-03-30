# frozen_string_literal: true
FactoryBot.define do
  factory :ad_option_type do
    name { FFaker::Skill.tech_skill }
  end
end
