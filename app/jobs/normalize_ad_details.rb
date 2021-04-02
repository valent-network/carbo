# frozen_string_literal: true

class NormalizeAdDetails < ApplicationJob
  queue_as(:default)

  def perform(ads_ids = nil)
    return if ads_ids.blank?
    ads = Ad.where(id: JSON.parse(ads_ids))

    ads.each do |ad|
      PrepareAdOptions.new.call(ad, ad.details)
      ad.save
    end
  end
end
