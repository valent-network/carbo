# frozen_string_literal: true

ActiveAdmin.register(FilterableValue) do
  menu label: proc { I18n.t('active_admin.filterable_values') }
  permit_params :name, :raw_value, :ad_option_type_id
  config.sort_order = 'name_asc'

  index do
    selectable_column
    id_column
    column :ad_option_type
    column :name
    column :raw_value
    actions
  end

  form do |f|
    f.inputs do
      f.input(:name)
      f.input(:raw_value)
      f.input(:ad_option_type, collection: AdOptionType.all)
    end
    f.actions
  end

  filter :ad_option_type
  filter :name, as: :select, collection: -> { FilterableValue.distinct(:name).pluck(:name) }

  collection_action :make_visible, method: :post do
    to_show = params[:filters].select { |_k, v| v == '1' }.keys
    ad_option_type = AdOptionType.find_by_name(params[:filters][:ad_option_type])

    to_show.each do |raw_value|
      FilterableValue.create(ad_option_type: ad_option_type, name: params[:filters][:group_name], raw_value: raw_value)
    end

    redirect_to admin_invisible_filters_path
  end
end
