# frozen_string_literal: true

ActiveAdmin.register(Region) do
  menu priority: 6, label: proc { I18n.t('active_admin.region') }, parent: 'settings'

  permit_params translations: [:uk, :en]

  index do
    column :id
    column :name
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
