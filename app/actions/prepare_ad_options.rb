# frozen_string_literal: true
class PrepareAdOptions
  def call(ad, details)
    details = details.dup.stringify_keys

    details.delete('address')

    details['region'], details['city'] = details['region']
    description_body = details.delete('description')
    images_links = details.delete('images_json_array_tmp')
    state_num = details.delete('state_num').to_s.strip
    seller_name = details.delete('seller_name').to_s.strip
    region = details.delete('region').to_s.strip
    city = details.delete('city').to_s.strip

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
        Rails.logger.error(e)
      end
    end

    images_links = case images_links
    when String
      JSON.parse(images_links)
    when Array
      images_links
    else
      Rails.logger.error("[PrepareAdOptions][NoImages]#{images_links}")
      []
    end

    keys = details.keys.uniq
    values = details.values.select(&:present?).uniq

    ad_option_types = AdOptionType.where(name: keys).to_a
    ad_option_values = AdOptionValue.where(value: values).to_a
    ad_options = ad.ad_options.to_a

    if description_body.present?
      ad_description = ad.ad_description || ad.build_ad_description
      ad_description.body = description_body
    else
      ad.ad_description&.mark_for_destruction
    end

    if state_num.present?
      ad.state_nums.where(value: state_num).first_or_initialize
    end

    if seller_name.present?
      ad.seller_names.where(value: seller_name).first_or_initialize
    end

    if images_links.present?
      ad_image_links_set = ad.ad_image_links_set || ad.build_ad_image_links_set
      ad_image_links_set.value = images_links
    else
      ad.ad_image_links_set&.mark_for_destruction
    end

    details.each do |key, val|
      opt_type = ad_option_types.detect { |ot| ot.name == key.to_s } || AdOptionType.new(name: key)

      ad_option = ad_options.detect { |ao| ao.ad_option_type_id == opt_type.id } || ad.ad_options.new(ad_option_type: opt_type)

      if val.present?
        opt_value = ad_option_values.detect do |ov|
          val.class.in?([TrueClass, FalseClass]) ? (ActiveModel::Type::Boolean.new.cast(ov.value) == val) : (ov.value == val.to_s)
        end || AdOptionValue.create(value: val)
        ad_option.ad_option_value = opt_value
      else
        ad_option.mark_for_destruction
        ad_options.detect { |opt| opt.id == ad_option.id }&.mark_for_destruction
      end
    end

    ad_options.reject { |ao| ao.ad_option_type_id.in?(ad_option_types.map(&:id)) }.map(&:mark_for_destruction)
  end
end
