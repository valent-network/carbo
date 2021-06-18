# frozen_string_literal: true

class DeleteOldVerificationRequests < ApplicationJob
  queue_as(:default)

  def perform
    requests_ids = VerificationRequest.where('updated_at < ?', 2.hours.ago).pluck(:id)
    VerificationRequest.where(id: requests_ids).delete_all
    Rails.logger.info("[DeleteOldVerificationRequests] #{requests_ids}")
  end
end
