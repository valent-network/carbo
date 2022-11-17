# frozen_string_literal: true
class DeleteAd
  include Sidekiq::Worker

  sidekiq_options queue: 'ads', retry: true, backtrace: false

  def perform(address)
    ad = Ad.find_by(address: address)

    if ad
      if ad.update(deleted: true)
        ad.touch
        logger.info("[DeleteAd] id=#{ad.id} address=#{address}")
        CreateEvent.call('delete_ad', user: nil, data: { address: address, id: ad.id })
      else
        logger.warn("[DeleteAd][UpdateFailure] id=#{ad.id} address=#{address} errors=#{ad.errors.to_hash.to_json}")
      end
    else
      logger.warn("[DeleteAd][AdNotFound] address=#{address}")
    end
  end
end
