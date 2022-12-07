# frozen_string_literal: true
ActiveAdmin.register(Rpush::Client::ActiveRecord::Apnsp8::App, as: 'Apple') do
  menu label: proc { I18n.t('active_admin.apple') }, parent: 'other'
  permit_params :name, :apn_key, :environment, :apn_key_id, :team_id, :bundle_id, :connections

  index do
    column :name
    column :environment
    actions
  end

  form do |f|
    f.inputs do
      f.input(:name)
      f.input(:apn_key)
      f.input(:environment)
      f.input(:apn_key_id)
      f.input(:team_id)
      f.input(:bundle_id)
      f.input(:connections)
    end
    f.actions
  end
end
