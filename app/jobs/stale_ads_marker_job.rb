# frozen_string_literal: true
class StaleAdsMarkerJob < ApplicationJob
  queue_as :default

  def perform
    Ad.where('updated_at < ?', 1.month.ago).update_all(stale: true)
  end
end
