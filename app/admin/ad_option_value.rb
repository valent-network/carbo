# frozen_string_literal: true

ActiveAdmin.register(AdOptionValue) do
  menu priority: 6, label: proc { I18n.t('active_admin.ad_option_values') }
  actions :index, :show, :destroy
  config.sort_order = 'value_desc'
  config.per_page = [100, 1000, 5000]

  filter :of_type, as: :select, collection: -> { AdOptionType.pluck(:name) }
  filter :non_filterable, as: :select, collection: -> { ['Yes'] }
  filter :without_active_ads, as: :select, collection: -> { ['Yes'] }
  filter :without_ad_options, as: :select, collection: -> { ['Yes'] }

  index do
    selectable_column
    id_column
    column :id
    column :value
    actions
  end

  show do
    attributes_table do
      row :id
      row :value
      row :ad_options do |ad_option_value|
        ad_option_value.ad_options.select(:ad_option_type_id).distinct(:ad_option_type_id).map(&:ad_option_type).map(&:name).join(', ')
      end
      row :active_ads do |ad_option_value|
        ad_option_value.ad_options.joins(:ad).distinct('ads.id').where(ads: { deleted: false }).pluck('ads.address').map { |url| link_to(url, url) }.join("<br>").html_safe
      end
      row :deleted_ads do
        ad_option_value.ad_options.joins(:ad).distinct('ads.id').where(ads: { deleted: true }).pluck('ads.address').map { |url| link_to(url, url) }.join("<br>").html_safe
      end
      row :actions do |ad_option_value|
        semantic_form_for('', url: actualize_ads_admin_ad_option_value_path(ad_option_value), method: :post) do |f|
          f.actions do
            f.submit('Actualize')
          end
        end
      end
    end
  end

  member_action :actualize_ads, method: :post do
    addresses = resource.ad_options.joins(:ad).distinct('ads.address').pluck(:address)
    jobs = Sidekiq::ScheduledSet.new
    jobs.each { |job| job.delete if job.args.first.in?(addresses) }
    addresses.each do |url|
      Sidekiq::Client.push(
        'class' => 'AutoRia::AdProcessor',
        'args' => [url],
        'queue' => 'provider',
        'retry' => true,
        'backtrace' => false,
      )
    end
    Ad.where(address: addresses).touch_all

    redirect_to admin_ad_option_value_path(resource), notice: t('active_admin.notices.actualize_success').html_safe
  end

  batch_action :make_filterable, form: { type: :text, name: :text } do |ids, inputs|
    ad_option_type = AdOptionType.find_by_name(inputs['type'])

    FilterableValue.insert_all(ids.map { |id| { ad_option_value_id: id, ad_option_type_id: ad_option_type.id, name: inputs['name'] } })
    redirect_to request.referrer, notice: t('active_admin.notices.make_filterable_success')
  end
end
