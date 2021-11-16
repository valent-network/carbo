# frozen_string_literal: true

ActiveAdmin.register(Ad) do
  menu label: proc { I18n.t('active_admin.ads') }, parent: I18n.t('active_admin.other')
  actions :index

  index pagination_total: false do
    column :price
    column :created_at
    column :updated_at
  end

  filter :price
  filter :created_at
  filter :updated_at
end
