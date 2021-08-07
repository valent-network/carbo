# frozen_string_literal: true

class ProviderActualizeRequest
  include Sidekiq::Worker

  sidekiq_options queue: 'provider-actualize', retry: true, backtrace: false

  RECEIVER = { queue: 'provider-auto-ria-actualizer', class: 'AutoRia::Actualizer' }

  def perform
    addresses = StaleAddresses.call.map(&:address)
    Ad.where(address: addresses).touch_all

    Sidekiq::Client.push(
      'class' => RECEIVER[:class],
      'args' => [addresses.to_json],
      'queue' => RECEIVER[:queue],
      'retry' => true,
      'backtrace' => false,
    )
  end
end
