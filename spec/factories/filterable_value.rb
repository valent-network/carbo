# frozen_string_literal: true

FactoryBot.define do
  factory :filterable_value do
    ad_option_type { AdOptionType.filterable.sample }
    name { FFaker::Vehicle.fuel_type.parameterize }
    before(:create) do |fv|
      group_name, group_name_translation = I18n.t("filters.types.#{fv.ad_option_type.name}").to_a.sample

      fv.name ||= group_name
      fv.raw_value ||= "Raw #{group_name_translation} #{rand}"
    end
  end
end
