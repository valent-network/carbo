# frozen_string_literal: true

ActiveAdmin.register(VerificationRequest) do
  menu label: proc { I18n.t('active_admin.verification_requests') }, parent: 'other'
  actions :index

  index pagination_total: false do
    column :phone_number
    column :verification_code
    column :created_at
    column :updated_at
  end

  filter :created_at
  filter :updated_at
end
