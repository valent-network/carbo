# frozen_string_literal: true

ActiveAdmin.register(PromoEvent) do
  menu label: proc { I18n.t('active_admin.promo_events') }, parent: I18n.t('active_admin.other')
  actions :index, :show

  index do
    column :id
    column :refcode
    column :full_phone_number_masked
    column :name
    column :created_at
    actions
  end

  show do
    attributes_table do
      row :id
      row :refcode
      row :name
      row :full_user_phone_number do |promo_event|
        link_to promo_event.user.phone_number.to_s, "tel:#{promo_event.user.phone_number}"
      end
      row :event
      row :created_at
    end
  end

  filter :id
end
