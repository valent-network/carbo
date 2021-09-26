# frozen_string_literal: true
ActiveAdmin.register(BusinessPhoneNumber) do
  actions :index
  includes :phone_number
  config.sort_order = 'ads_count_desc'

  index do
    column { |phone| "+380#{phone.full_number}" }
    column :ads_count
  end

  filter :ads_count
end
