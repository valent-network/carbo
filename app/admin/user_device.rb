# frozen_string_literal: true

ActiveAdmin.register(UserDevice) do
  menu label: proc { I18n.t('active_admin.user_devices') }, parent: I18n.t('active_admin.other')
  actions :index

  includes :user

  index do
    column(:user) { |user_device| link_to((user_device.user.name.presence || user_device.user.id), admin_user_path(user_device.user)) }
    column :os
    column :build_version
    column :updated_at
  end

  filter :build_version
  filter :os
end
