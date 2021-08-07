# frozen_string_literal: true
class DeleteAd
  include Sidekiq::Worker

  sidekiq_options queue: 'provider.ads.delete', retry: true, backtrace: false

  STATUSES = { deleted: 'deleted', failed: 'failed' }

  RECEIVER = { queue: 'provider-ads-status', class: 'AutoRia::StatusUpdater' }

  def perform(address)
    ad = Ad.find_by(address: address)

    if ad
      if ad.update(deleted: true)
        ad.touch
        callback(address: address, status: STATUSES[:deleted])
        logger.info("[DeleteAd][#{ad.id}]")
      else
        callback(address: address, errors: ad.errors.to_hash, status: STATUSES[:failed])
      end
    else
      callback(address: address, status: STATUSES[:deleted])
      logger.info("[DeleteAd][MissingAd]: #{address}")
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
