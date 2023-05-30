# frozen_string_literal: true

class ActualizeAd
  INTERVAL = ENV.fetch("ACTUALIZE_AD_INTERVAL_HOURS", 24).hours.to_i
  include Sidekiq::Worker

  sidekiq_options queue: "ads", retry: true, backtrace: false

  RECEIVER = {queue: "provider", class: "AutoRia::AdProcessor"}

  def perform
    active_known_ids = Ad.known.active.pluck("DISTINCT(ads.id)")
    recently_updated_ids = REDIS.keys("actualized:*").map { |key| key.gsub(/\Aactualized:/, "").to_i }
    to_actualize_ids = active_known_ids - recently_updated_ids
    addresses = Ad.where(id: to_actualize_ids).pluck(:address)

    addresses.each do |url|
      Sidekiq::Client.push({
        "class" => RECEIVER[:class],
        "args" => [url],
        "queue" => RECEIVER[:queue],
        "retry" => true,
        "backtrace" => false,
        "lock" => :until_executed
      })
    end

    to_actualize_ids.each do |id|
      REDIS.set("actualized:#{id}", 1)
      REDIS.expire("actualized:#{id}", INTERVAL)
    end
  end
end
