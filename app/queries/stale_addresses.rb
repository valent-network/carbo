# frozen_string_literal: true
class StaleAddresses
  ADDRESSES_BATCH_LIMIT = 100

  def self.call
    Ad.select(:address)
      .joins('JOIN effective_ads ON effective_ads.id = ads.id')
      .limit(ADDRESSES_BATCH_LIMIT)
  end
end
