# frozen_string_literal: true

ActiveAdmin.register(Category) do
  menu label: proc { I18n.t('active_admin.category') }, parent: 'filters_management'
  permit_params :name, :currency, translations: [:uk, :en]

  form do |f|
    f.input(:name)
    f.input(:currency, as: :select, include_blank: false, collection: Category::CURRENCIES)
    f.inputs(for: :translations) do |t|
      t.input(:uk)
      t.input(:en)
    end
    f.actions
  end
end
