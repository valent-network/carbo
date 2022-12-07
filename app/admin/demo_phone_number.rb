# frozen_string_literal: true

ActiveAdmin.register(DemoPhoneNumber) do
  menu label: proc { I18n.t('active_admin.demo_phone_numbers') }, parent: 'phones'
  permit_params :phone, :demo_code
  includes :phone_number

  index do
    column :phone
    column :demo_code
    actions
  end

  filter :created_at

  form do |f|
    f.inputs do
      f.input(:phone)
      f.input(:demo_code)
    end
    f.actions
  end
end
