# frozen_string_literal: true

ActiveAdmin.register(Region) do
  menu priority: 12, label: proc { I18n.t("active_admin.region") }, parent: "settings"

  permit_params :name, translations: [:uk, :en]

  index do
    column :id
    column :name
    column :translations
    column :created_at
    actions
  end

  form do |f|
    f.input(:name)
    f.inputs(for: :translations) do |t|
      t.input(:uk, input_html: {value: f.object.translations["uk"]})
      t.input(:en, input_html: {value: f.object.translations["en"]})
    end
    f.actions
  end
end
