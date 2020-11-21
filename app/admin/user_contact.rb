# frozen_string_literal: true

ActiveAdmin.register(UserContact) do
  actions :index

  includes :phone_number, :user

  index pagination_total: false do
    column :phone_number
    column :user
    column :name
  end

  filter :created_at
  filter :updated_at
end
