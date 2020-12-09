# frozen_string_literal: true

ActiveAdmin.register(UserDevice) do
  actions :index

  index do
    column :user
    column :user_id
    column :os
    column :build_version
    column :updated_at
  end

  filter :build_version
  filter :os
end
