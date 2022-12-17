# frozen_string_literal: true
class PutAd
  include Sidekiq::Worker

  sidekiq_options queue: 'ads', retry: true, backtrace: false

  AD_DETAILS_PARAMS = %i[
    maker
    model
    race
    year
    images_json_array_tmp
    engine_capacity
    fuel
    horse_powers
    gear
    wheels
    carcass
    color
    description
    state_num
    seller_name
    region
  ]

  MAX_RETRIES_ON_DEADLOCK = 3

  def perform(base64_zipped_ad_params)
    original_ad_params = Zlib.inflate(Base64.urlsafe_decode64(base64_zipped_ad_params))
    ad_params = JSON.parse(original_ad_params).with_indifferent_access

    address = ad_params[:details][:address]
    ad = Ad.where(address: address).first_or_initialize
    ad.ads_source = AdsSource.where(title: 'auto.ria.com').first_or_create

    ad_contract = AdCarContract.new.call(ad_params)

    if ad_contract.failure?
      logger.warn("[PutAd][ValidationErrors] id=#{ad&.id} address=#{address} errors=#{ad_contract.errors.to_h.to_json}")
    else
      ad.assign_attributes(ad_params.slice(:price, :phone, :ad_type))
      ad.updated_at = Time.zone.now
      PrepareAdOptions.new.call(ad, ad_params[:details].slice(*AD_DETAILS_PARAMS))

      begin
        retries ||= 0
        if ad.save
          Rails.logger.warn("[PutAd][AdSaved] data=#{{ address: address, id: ad.id }.to_json}")
        else
          logger.warn("[PutAd][AdNotSaved] id=#{ad&.id} address=#{address} errors=#{ad.errors.to_hash.to_json}")
        end
      rescue PG::TRDeadlockDetected
        retry if (retries += 1) < MAX_RETRIES_ON_DEADLOCK
      rescue ActiveRecord::RecordNotUnique, PG::UniqueViolation
        logger.warn("[PutAd][DuplicateRaceCondition] id=#{ad&.id} address=#{address}")
      end
    end
  end
end
