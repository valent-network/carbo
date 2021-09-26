# frozen_string_literal: true
ActiveAdmin.register(SystemStat) do
  actions :index, :show

  index do
    id_column
    actions
  end
end
