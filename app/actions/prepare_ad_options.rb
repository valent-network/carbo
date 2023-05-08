# frozen_string_literal: true
class PrepareAdOptions
  def call(ad, details)
    details = details.dup.stringify_keys

    details.delete('address')

    if details['region'].blank? || details['city'].blank?
      if details['region'].is_a?(Array)
        details['region'], details['city'] = details['region']
        # TODO: FIX
        # Rails.logger.warn("[PrepareAdOptions][region-old] #{details}")
        # Sidekiq.logger.warn("[PrepareAdOptions][region-old] #{details}")
      else
        Rails.logger.error("[PrepareAdOptions][region] #{details}")
        Sidekiq.logger.error("[PrepareAdOptions][region] #{details}")
      end
    end

    description_body = details.delete('description')
    images_links = details.delete('images_json_array_tmp')
    region = details['region'].to_s.strip
    city = details['city'].to_s.strip

    if region.present? && city.present?
      region_record = Region.where(name: region).first_or_create
      city_record = City.where(name: city, region: region_record).first_or_create
      ad.city = city_record
    elsif region.present? && city.blank?
      begin
        r = JSON.parse(region)
        region_record = Region.where(name: r.first).first_or_create
        city_record = City.where(name: r.last, region: region_record).first_or_create
        ad.city = city_record
      rescue => e
        Sentry.capture_exception(e)
      end
    end

    images_links = case images_links
    when String
      JSON.parse(images_links)
    when Array
      images_links
    else
      Sentry.capture_message("[PrepareAdOptions][NoImages]#{images_links}", level: :error)
      []
    end

    details.delete('region')
    details.delete('city')

    ad_extra = ad.ad_extra || ad.build_ad_extra
    ad_extra.details = details

    details.delete('state_num')
    details.delete('seller_name')

    ad_query = ad.ad_query || ad.build_ad_query
    ad_query.title = [details['maker'], details['model'], details['year']].join(' ')

    ad_description = ad.ad_description || ad.build_ad_description

    ad_description.short = I18n.with_locale(:uk) { AdCarShortDescriptionPresenter.new.call(details) }
    ad_description.body = description_body.presence

    if images_links.present?
      ad_image_links_set = ad.ad_image_links_set || ad.build_ad_image_links_set
      ad_image_links_set.value = images_links
    else
      ad.ad_image_links_set&.mark_for_destruction
    end
  end
end
