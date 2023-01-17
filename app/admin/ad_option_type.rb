# frozen_string_literal: true

ActiveAdmin.register(AdOptionType) do
  menu label: proc { I18n.t('active_admin.ad_option_types') }, parent: 'settings'
  permit_params :category_id, :name, :filterable, :input_type, :position, translations: [:uk, :en]
  config.sort_order = 'position_asc'
  config.batch_actions = false

  Category.all.each do |category|
    scope(category.name.titleize) { |scope| scope.where(category: category) }
  end

  index do
    selectable_column
    column(:id)
    column(:name) do |aot|
      [
        "<b>#{aot.name}</b>".html_safe,
        aot.translations.map { |k, v| "#{k}: #{v}" }
      ].flatten.join('<br>').html_safe
    end
    column(:category)
    column(:filterable)
    column(:input_type)
    column(:position)
    column(:groups) do |aot|
      "
      <span class='filterable-values-groups-sortable-list' data-name='#{aot.name}'>
        #{aot.groups.order(:position).map { |fvg| "<span class='filterable-node'>#{fvg.name}</span>" }.join(' ')}
      </span>
      #{link_to(t('active_admin.edit'), admin_ad_option_type_sortable_path(aot))}
      ".html_safe
    end
    actions
  end

  form do |f|
    f.input(:category, include_blank: false)
    f.input(:name)
    f.input(:filterable)
    f.input(:position)
    f.input(:input_type, as: :select, include_blank: false, collection: AdOptionType::INPUT_TYPES)
    f.inputs(for: :translations) do |t|
      t.input(:uk, input_html: { value: f.object.translations['uk'] })
      t.input(:en, input_html: { value: f.object.translations['en'] })
    end
    f.actions
  end

  filter :filterable
  filter :input_type, as: :select, collection: AdOptionType::INPUT_TYPES

  collection_action :reorder, method: :post do
    aots = AdOptionType.where(name: params[:names])
    aots.each do |aot|
      aot.position = params[:names].index(aot.name)
    end
    AdOptionType.transaction do
      aots.map(&:save!)
    end

    head :ok
  end
end
