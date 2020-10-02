# frozen_string_literal: true

ActiveAdmin.register(AdsSource) do
  permit_params :title, :api_token

  index do
    column :title
    actions
  end

  filter :title
end
