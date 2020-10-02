# frozen_string_literal: true

ActiveAdmin.register(Ad) do
  index pagination_total: false do
    column :price
    column :created_at
    column :updated_at
  end

  filter :price
  filter :created_at
  filter :updated_at
end
