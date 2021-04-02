# frozen_string_literal: true

class NormalizeAdDetails < ApplicationJob
  queue_as(:default)

  def perform(ads_id)
    ads = Ad.where(id: ads_ids)

    ads.each do |ad|
      PrepareAdOptions.new.call(ad, ad.details)
      ad.save
    end
  end
end
