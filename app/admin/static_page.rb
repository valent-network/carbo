# frozen_string_literal: true

ActiveAdmin.register(StaticPage) do
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
