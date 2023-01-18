# frozen_string_literal: true

ActiveAdmin.register(FilterableValue) do
  menu label: proc { I18n.t('active_admin.filterable_values') }, parent: 'other'
  permit_params :name, :raw_value, :group, :ad_option_type_id
end
