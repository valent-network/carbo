# frozen_string_literal: true

ActiveAdmin.register(FilterableValuesGroup) do
  menu label: proc { I18n.t('active_admin.filterable_values_groups') }, parent: 'filters_management'
  permit_params :ad_option_type_id, :name, translations: [:uk, :en]

  form do |f|
    f.input(:ad_option_type)
    f.input(:name)
    f.inputs(for: :translations) do |t|
      t.input(:uk)
      t.input(:en)
    end
    f.actions
  end
end
