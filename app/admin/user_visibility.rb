# frozen_string_literal: true

ActiveAdmin.register(UserVisibility) do
  menu priority: 6, label: proc { I18n.t('active_admin.user_visibility') }, parent: 'other'

  actions :index

  filter :user
end
