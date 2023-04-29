# frozen_string_literal: true

ActiveAdmin.register(FilterableValue) do
  menu priority: 16, label: proc { I18n.t('active_admin.filterable_values') }, parent: 'settings'
  permit_params :name, :raw_value, :group, :ad_option_type_id
end
