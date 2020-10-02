# frozen_string_literal: true
class AdVisitedJob < ApplicationJob
  queue_as :default

  def perform(user_id, ad_id)
    AdVisit.where(ad_id: ad_id, user_id: user_id).first_or_create
  end
end
