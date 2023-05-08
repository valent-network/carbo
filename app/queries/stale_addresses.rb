# frozen_string_literal: true

class StaleAddresses
  BATCH_LIMIT = ENV.fetch("STALE_ADDRESSES_BATCH_LIMIT", 100)
  UPDATE_INTERVAL = ENV.fetch("STALE_ADDRESSES_UPDATE_UINTERVAL_HOURS", 24).hours.to_i

  def self.call
    update_interval_ago = Time.zone.now - UPDATE_INTERVAL

    Ad.known.active.distinct("ads.id").select(:address)
      .where("ads.updated_at < ?", update_interval_ago)
      .limit(BATCH_LIMIT)
  end
end
