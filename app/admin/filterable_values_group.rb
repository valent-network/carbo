# frozen_string_literal: true

ActiveAdmin.register(FilterableValuesGroup) do
  menu label: proc { I18n.t('active_admin.filterable_values_groups') }, parent: 'settings'
  permit_params :ad_option_type_id, :name, :position, translations: [:uk, :en]
  config.batch_actions = false
  includes :values, :ad_option_type

  sidebar 'Existing Groups' do
    FilterableValue
      .joins(:ad_option_type)
      .joins("LEFT JOIN filterable_values_groups ON filterable_values_groups.ad_option_type_id = ad_option_types.id AND filterable_values_groups.name = filterable_values.name ")
      .where(filterable_values_groups: { id: nil })
      .group('ad_option_types.id')
      .select('ad_option_types.id, ARRAY_AGG(filterable_values.name) AS values')
      .to_a.map { |x| [x.id, x.values.uniq] }.each do |opt_id, filter_groups|
        div(class: 'existing-filter-values-groups', 'data-ad-option-type-id' => opt_id) do
          filter_groups.map { |v| "<span class='filterable-node'>#{v}</span>" }.join(' ').html_safe
        end
      end
  end

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
