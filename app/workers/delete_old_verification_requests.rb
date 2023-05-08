# frozen_string_literal: true

class DeleteOldVerificationRequests
  include Sidekiq::Worker

  sidekiq_options queue: "default", retry: true, backtrace: false

  def perform
    requests_ids = VerificationRequest.where("updated_at < ?", 2.hours.ago).pluck(:id)
    VerificationRequest.where(id: requests_ids).delete_all
    Sentry.capture_message("[DeleteOldVerificationRequests] #{requests_ids}")
  end
end
