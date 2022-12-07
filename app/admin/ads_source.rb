# frozen_string_literal: true

ActiveAdmin.register(AdsSource) do
  menu label: proc { I18n.t('active_admin.ads_sources') }, parent: 'other'
  permit_params :title, :api_token

  index do
    column :title
    actions
  end

  filter :title
end
