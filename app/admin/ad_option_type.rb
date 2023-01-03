# frozen_string_literal: true

ActiveAdmin.register(AdOptionType) do
  menu label: proc { I18n.t('active_admin.ad_option_types') }, parent: 'filters_management'
  permit_params :category_id, :name, :filterable, :input_type, translations: [:uk, :en]

  form do |f|
    f.input(:category, include_blank: false)
    f.input(:name)
    f.input(:filterable)
    f.input(:input_type, as: :select, include_blank: false, collection: AdOptionType::INPUT_TYPES)
    f.inputs(for: :translations) do |t|
      t.input(:uk)
      t.input(:en)
    end
    f.actions
  end
end
