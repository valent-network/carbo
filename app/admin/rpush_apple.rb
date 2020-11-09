# frozen_string_literal: true
ActiveAdmin.register(Rpush::Apnsp8::App, as: 'Apple') do
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
