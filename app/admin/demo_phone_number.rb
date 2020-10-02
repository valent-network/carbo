# frozen_string_literal: true

ActiveAdmin.register(DemoPhoneNumber) do
  permit_params :phone, :demo_code

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
