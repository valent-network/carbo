# frozen_string_literal: true

ActiveAdmin.register(StaticPage) do
  menu priority: 8, label: proc { I18n.t('active_admin.static_pages') }, parent: 'system'
  permit_params :title, :slug, :body, :meta

  index do
    column :title
    column :slug
    actions
  end

  form do |f|
    f.inputs do
      f.input(:title)
      f.input(:slug)
      f.input(:body)
      f.input(:meta, as: :text)
    end
    f.actions
  end

  filter :title
  filter :slug
end
