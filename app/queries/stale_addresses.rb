# frozen_string_literal: true
class StaleAddresses
  ADDRESSES_BATCH_LIMIT = 100
  ACTUALIZE_INTERVAL = 24.hours

  def self.call
    ads = Ad.where(ads_source_id: 1).where('updated_at < ?', ACTUALIZE_INTERVAL.ago)

    effective_ads = ads.joins('JOIN effective_ads ON effective_ads.id = ads.id')

    ads = if effective_ads.exists?
      effective_ads
    else
      ads.where('ads.phone_number_id IN (SELECT DISTINCT phone_number_id FROM user_contacts)')
    end

    ads.select(:address).limit(ADDRESSES_BATCH_LIMIT)
  end
end
