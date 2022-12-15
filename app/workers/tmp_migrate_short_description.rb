# frozen_string_literal: true

class TmpMigrateShortDescription
  include Sidekiq::Worker

  sidekiq_options queue: 'system', retry: true, backtrace: false

  def perform
    ads = Ad.joins(:ad_extra)
      .left_joins(:ad_description)
      .includes(:ad_extra)
      .select('ads.id, ad_extras.details AS ad_extra_details')
      .distinct('ads.id')
      .where(ad_descriptions: { short: [nil, ''] })
      .limit(10_000)

    to_upsert = ads.map do |ad|
      { ad_id: ad.id, short: AdCarShortDescriptionPresenter.new.call(ad.ad_extra_details) }
    end

    res = AdDescription.upsert_all(to_upsert, unique_by: [:ad_id]) if to_upsert.present?
    res&.count
  end
end
