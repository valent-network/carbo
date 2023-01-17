# frozen_string_literal: true

ActiveAdmin.register(City) do
  menu priority: 6, label: proc { I18n.t('active_admin.city') }, parent: 'settings'

  permit_params translations: [:uk, :en]

  includes :region

  index do
    column :id
    column :name
    column :region
    column :translations
    column :created_at
    actions
  end

  form do |f|
    f.inputs(for: :translations) do |t|
      t.input(:uk)
      t.input(:en)
    end
    f.actions
  end
end
