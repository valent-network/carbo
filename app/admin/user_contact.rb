# frozen_string_literal: true

ActiveAdmin.register(UserContact) do
  menu label: proc { I18n.t('active_admin.user_contacts') }, parent: 'other'
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
