# frozen_string_literal: true

ActiveAdmin.register_page("Invisible Filters") do
  menu label: proc { I18n.t('active_admin.invisible_filters') }

  content do
    render partial: 'filters'
  end
end
