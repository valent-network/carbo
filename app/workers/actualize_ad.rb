# frozen_string_literal: true

class ActualizeAd
  include Sidekiq::Worker

  sidekiq_options queue: 'ads', retry: true, backtrace: false

  RECEIVER = { queue: 'provider', class: 'AutoRia::AdProcessor' }

  def perform
    addresses = StaleAddresses.call.map(&:address)

    addresses.each do |url|
      Sidekiq::Client.push(
        'class' => RECEIVER[:class],
        'args' => [url],
        'queue' => RECEIVER[:queue],
        'retry' => true,
        'backtrace' => false,
        'lock' => :until_executed,
      )
    end

    Ad.where(address: addresses).touch_all
  end
end
