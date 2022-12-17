# frozen_string_literal: true

ActiveAdmin.register_page("Invisible Filters") do
  menu label: proc { I18n.t('active_admin.invisible_filters') }, parent: 'filters_management'

  content do
    render partial: 'filters'
  end
end
