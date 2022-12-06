# frozen_string_literal: true

ActiveAdmin.register(FilterableValue) do
  menu label: proc { I18n.t('active_admin.filterable_values') }
  permit_params :name, :ad_option_type_id, :ad_option_value_id
  config.sort_order = 'name_asc'

  index do
    selectable_column
    id_column
    column :name
    column :ad_option_type
    column :ad_option_value
    actions
  end

  form do |f|
    f.inputs do
      f.input(:name)
      f.input(:ad_option_type, collection: AdOptionType.all)
      f.input(:ad_option_value_id)
    end
    f.actions
  end

  filter :ad_option_type
  filter :name, as: :select, collection: FilterableValue.distinct(:name).pluck(:name)
end
