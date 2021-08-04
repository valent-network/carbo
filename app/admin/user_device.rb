# frozen_string_literal: true

ActiveAdmin.register(UserDevice) do
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
