# frozen_string_literal: true

ActiveAdmin.register_page("Dashboard") do
  menu priority: 1, label: proc { I18n.t("active_admin.dashboard") }

  content do
    h1 "Dashboard"
  end
end
