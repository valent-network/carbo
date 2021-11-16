# frozen_string_literal: true
ActiveAdmin.register(Rpush::Gcm::App, as: 'Android') do
  menu label: proc { I18n.t('active_admin.android') }, parent: I18n.t('active_admin.other')
  permit_params :name, :auth_key, :connections

  index do
    column :name
    actions
  end

  form do |f|
    f.inputs do
      f.input(:name)
      f.input(:auth_key)
      f.input(:connections)
    end
    f.actions
  end
end
