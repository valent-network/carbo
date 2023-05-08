# frozen_string_literal: true

ActiveAdmin.register_page("Sortable") do
  menu label: proc { I18n.t("active_admin.sortable_filters") }
  belongs_to :ad_option_type

  content do
    render partial: "sortable"
  end
end
