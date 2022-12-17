# frozen_string_literal: true

ActiveAdmin.register(Category) do
  menu label: proc { I18n.t('active_admin.category') }, parent: 'filters_management'
  permit_params :name
end
