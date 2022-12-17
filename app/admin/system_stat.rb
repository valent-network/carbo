# frozen_string_literal: true
ActiveAdmin.register(SystemStat) do
  menu priority: 5, label: proc { I18n.t('active_admin.system_stats') }, parent: 'other'
  actions :index, :show

  index do
    id_column
    actions
  end
end
