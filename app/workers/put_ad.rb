# frozen_string_literal: true

class PutAd
  NATIVE_CATEGORY_NAME = "vehicles"
  PROVIDER_NAME = "auto.ria.com"

  include Sidekiq::Worker

  sidekiq_options queue: "ads", retry: true, backtrace: false

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
    return if NativizedProviderAd.where(address: address).exists?

    ad = Ad.where(address: address).first_or_initialize
    ad.ads_source = AdsSource.where(title: PROVIDER_NAME).first_or_create
    ad.category = Category.where(name: NATIVE_CATEGORY_NAME).first_or_create

    ad_contract = AdCarContract.new.call(ad_params)

    if ad_contract.failure?
      Sentry.capture_message("[PutAd][ValidationErrors] id=#{ad&.id} address=#{address} errors=#{ad_contract.errors.to_h.to_json}", level: :warning)
    else
      ad.assign_attributes(ad_params.slice(:price, :phone))
      ad.updated_at = Time.zone.now
      PrepareAdOptions.new.call(ad, ad_params[:details].slice(*AD_DETAILS_PARAMS))

      begin
        retries ||= 0
        if ad.save
          Sentry.capture_message("[PutAd][AdSaved] data=#{{address: address, id: ad.id}.to_json}", level: :info)
        else
          Sentry.capture_message("[PutAd][AdNotSaved] id=#{ad&.id} address=#{address} errors=#{ad.errors.to_hash.to_json}", level: :warning)
        end
      rescue PG::TRDeadlockDetected => e
        Sentry.capture_exception(e)
        retry if (retries += 1) < MAX_RETRIES_ON_DEADLOCK
      rescue ActiveRecord::RecordNotUnique, PG::UniqueViolation => e
        Sentry.capture_exception(e)
        Sentry.capture_message("[PutAd][DuplicateRaceCondition] id=#{ad&.id} address=#{address}", level: :warning)
      end
    end
  end
end
