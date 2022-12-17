# frozen_string_literal: true

ActiveAdmin.register(Event) do
  menu priority: 6, label: proc { I18n.t('active_admin.events') }, parent: 'other'
  actions :index, :show

  includes :user

  index do
    column :id
    column :name
    column :user_id
    column :created_at
    actions
  end

  show do
    attributes_table do
      row :id
      row :name
      row :user_id
      row :created_at
      row :data
    end
    active_admin_comments
  end

  filter :created_at
  filter :name, as: :select, collection: Event::EVENT_TYPES
end
