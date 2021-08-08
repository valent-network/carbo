# frozen_string_literal: true
class PutAd
  include Sidekiq::Worker

  sidekiq_options queue: 'provider-ads-new', retry: true, backtrace: false

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

  STATUSES = {
    failed: 'failed',
    completed: 'completed',
  }

  RECEIVER = { queue: 'provider-ads-status', class: 'AutoRia::StatusUpdater' }

  MAX_RETRIES_ON_DEADLOCK = 3

  def perform(ad_params)
    ad_params = JSON.parse(ad_params).with_indifferent_access

    address = ad_params[:details][:address]
    ad = Ad.where(address: address).first_or_initialize
    ad.ads_source_id = 1 # TODO: remove AdSource completely

    ad_contract = AdCarContract.new.call(ad_params)

    if ad_contract.failure?
      callback(errors: ad_contract.errors.to_h, address: address, status: STATUSES[:failed])
      logger.info("[PutAd][ValidationErrors] #{address}")
    else
      ad.assign_attributes(ad_params.slice(:price, :phone, :ad_type))
      ad.updated_at = Time.zone.now
      PrepareAdOptions.new.call(ad, ad_params.slice(*AD_DETAILS_PARAMS))

      begin
        retries ||= 0
        if ad.save
          callback(id: ad.id, address: address, status: STATUSES[:completed])
          logger.info("[PutAd][#{address}]")
        else
          callback(errors: ad.errors.to_hash, address: address, status: STATUSES[:failed])
          logger.info("[PutAd][Errors] #{address}")
        end
      rescue PG::TRDeadlockDetected
        retry if (retries += 1) < MAX_RETRIES_ON_DEADLOCK
      rescue ActiveRecord::RecordNotUnique, PG::UniqueViolation
        logger.info("[PutAd][DuplicateRaceCondition] #{address}")
      end
    end
  end

  private

  def callback(params)
    Sidekiq::Client.push(
      'class' => RECEIVER[:class],
      'args' => [params.to_json],
      'queue' => RECEIVER[:queue],
      'retry' => true,
      'backtrace' => false,
    )
  end
end
