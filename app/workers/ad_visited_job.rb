# frozen_string_literal: true
class AdVisitedJob
  include Sidekiq::Worker

  sidekiq_options queue: 'default', retry: true, backtrace: false

  def perform(user_id, ad_id)
    AdVisit.where(ad_id: ad_id, user_id: user_id).first_or_create
  end
end
