# frozen_string_literal: true

ActiveAdmin.register(User) do
  includes :phone_number, :user_contacts

  index pagination_total: false do
    column :phone_number
    column :contacts_count
    column :visible_ads_count
    column :visible_friends_count
    column :created_at
    column :updated_at
  end

  # filter :phone_number
  filter :created_at
  filter :updated_at
end
