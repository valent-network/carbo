# frozen_string_literal: true

ActiveAdmin.register(AdOptionType) do
  menu label: proc { I18n.t('active_admin.ad_option_types') }, parent: 'filters_management'
  permit_params :category_id
end
