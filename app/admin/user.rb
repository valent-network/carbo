# frozen_string_literal: true

ActiveAdmin.register(User) do
  actions :index, :show

  includes :phone_number

  index pagination_total: false do
    column :phone_number
    column :name
    column :created_at
    column :updated_at
    actions
  end

  show do
    attributes_table do
      row :name
      row :phone_number
      row :created_at
      row :updated_at
      row :avatar
      row :contacts_count
      row :visible_ads_count
      row :visible_friends_count
    end
    active_admin_comments
  end

  filter :created_at
  filter :updated_at
end
