# frozen_string_literal: true
ActiveAdmin.register(BusinessPhoneNumber) do
  menu label: proc { I18n.t('active_admin.business_phone_numbers') }, parent: 'phones'
  actions :index
  includes :phone_number
  config.sort_order = 'ads_count_desc'

  index do
    column { |phone| "+380#{phone.full_number}" }
    column :ads_count
  end

  filter :ads_count
end
