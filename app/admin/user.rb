# frozen_string_literal: true

ActiveAdmin.register(User) do
  menu priority: 2, label: proc { I18n.t('active_admin.users') }
  actions :index, :show

  includes :phone_number

  scope :all, default: true, pagination_total: false
  scope :no_contacts, show_count: false, pagination_total: false
  scope :no_connections, show_count: false, pagination_total: false
  scope :with_referrer, show_count: false, pagination_total: false

  index do
    column :id
    actions
    column :admin
    column :name
    column :phone_number
    column :created_at
    column :updated_at
    column :stats
  end

  show do
    attributes_table do
      row :admin
      row :stats
      row :name
      row :phone_number
      row :created_at
      row :updated_at
      row :avatar
      row :contacts_count
      row :registered_friends_count
      row :visible_ads_count
      row :visible_ads_count_for_default_hops
      row :visible_friends_count
      # row :visible_business_ads_count
    end
    active_admin_comments
  end

  filter :created_at
  filter :updated_at
end
