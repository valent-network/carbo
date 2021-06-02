# frozen_string_literal: true

ActiveAdmin.register(VerificationRequest) do
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
