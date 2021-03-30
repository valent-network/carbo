# frozen_string_literal: true

class NormalizeAdDetails < ApplicationJob
  queue_as(:default)

  def perform
    Ad.left_joins(:ad_options).where(ad_options: { id: nil }).limit(100).each do |ad|
      PrepareAdOptions.new.call(ad, ad.details)
      ad.save
    end
  end
end
