# frozen_string_literal: true
class DeleteAd
  include Sidekiq::Worker

  sidekiq_options queue: 'ads', retry: true, backtrace: false

  def perform(address)
    ad = Ad.find_by(address: address)

    if ad
      if ad.update(deleted: true)
        ad.touch
        Sentry.capture_message("[DeleteAd][AdDeletedSuccessfully] data=#{{ address: address, id: ad.id }.to_json}", level: :info)
      else
        Sentry.capture_message("[DeleteAd][UpdateFailure] id=#{ad.id} address=#{address} errors=#{ad.errors.to_hash.to_json}", level: :error)
      end
    else
      Sentry.capture_message("[DeleteAd][AdNotFound] address=#{address}", level: :info)
    end
  end
end
