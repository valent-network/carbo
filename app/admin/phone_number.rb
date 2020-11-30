# frozen_string_literal: true

ActiveAdmin.register(PhoneNumber) do
  actions :index

  scope :having_one_ad
  scope :having_two_or_three_ads
  scope :having_four_to_ten_ads
  scope :having_more_ten_ads

  index do
    column :full_number
  end

  filter :by_region, as: :select, collection: -> { UA_REGIONS }
  filter :not_registered_only, as: :select, collection: -> { ['Yes'] }
  filter :full_number_eq, as: :string
end
