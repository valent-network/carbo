# frozen_string_literal: true

ActiveAdmin.register(FilterableValuesGroup) do
  menu label: proc { I18n.t('active_admin.filterable_values_groups') }
  permit_params :ad_option_type_id, :name, :position, translations: [:uk, :en]
  config.batch_actions = false

  index download_links: false do
    column(:name) do |fvg|
      [
        "<b>#{fvg.name}</b>".html_safe,
        fvg.translations.map { |k, v| "#{k}: #{v}" }
      ].flatten.join('<br>').html_safe
    end

    column(:values) do |fvg|
      fvg.values.map { |v| "<span class='filterable-node'>#{v.raw_value}</span>" }.join(' ').html_safe
    end
    actions
  end

  AdOptionType.all.each do |aot|
    scope(aot.name.titleize) { |scope| scope.where(ad_option_type: aot) }
  end

  form do |f|
    f.input(:ad_option_type)
    f.input(:name)
    f.inputs(for: :translations) do |t|
      t.input(:uk, input_html: { value: f.object.translations['uk'] })
      t.input(:en, input_html: { value: f.object.translations['en'] })
    end
    f.actions
  end

  collection_action :reorder, method: :post do
    fvgs = FilterableValuesGroup.where(name: params[:names])
    fvgs.each do |fvg|
      fvg.position = params[:names].index(fvg.name)
    end
    FilterableValuesGroup.transaction do
      fvgs.map(&:save!)
    end

    head :ok
  end
end
