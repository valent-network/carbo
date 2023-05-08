# frozen_string_literal: true

class MarkOldAdsAsDeleted
  include Sidekiq::Worker

  sidekiq_options queue: "default", retry: true, backtrace: false

  def perform
    Ad.where(deleted: false).where("updated_at <= NOW() - INTERVAL '2 months'").update_all(deleted: true)
  end
end
