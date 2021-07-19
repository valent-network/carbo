# frozen_string_literal: true

class MarkOldAdsAsDeleted < ApplicationJob
  queue_as(:default)

  def perform
    Ad.where(deleted: false).where("updated_at <= NOW() - INTERVAL '2 months'").update_all(deleted: true)
  end
end
