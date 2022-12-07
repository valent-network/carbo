# frozen_string_literal: true

ActiveAdmin.register(PhoneNumber) do
  menu label: proc { I18n.t('active_admin.all_phone_numbers') }, parent: 'phones'
  actions :index

  scope :all, default: true, show_count: false
  scope :having_one_ad, show_count: false
  scope :having_two_or_three_ads, show_count: false
  scope :having_four_to_ten_ads, show_count: false
  scope :having_more_ten_ads, show_count: false

  index pagination_total: false do
    column :full_number
  end

  filter :by_region, as: :select, collection: -> { Region.pluck(:name) }
  filter :not_registered_only, as: :select, collection: -> { ['Yes'] }
  filter :full_number_eq, as: :string
end
