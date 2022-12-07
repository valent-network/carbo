# frozen_string_literal: true

ActiveAdmin.register(FilterableValueTranslation) do
  menu label: proc { I18n.t('active_admin.filterable_value_translations') }
  permit_params :name, :ad_option_type_id, :alias_group_name, :locale
  config.sort_order = 'ad_option_type_id_asc'

  index do
    selectable_column
    id_column
    column :name
    column :alias_group_name
    column :locale
    column :ad_option_type
    actions
  end
end
