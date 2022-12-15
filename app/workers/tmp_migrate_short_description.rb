# frozen_string_literal: true

class TmpMigrateShortDescription
  include Sidekiq::Worker

  sidekiq_options queue: 'system', retry: true, backtrace: false

  def perform
    Ad.joins(:ad_extra)
      .left_joins(:ad_description)
      .includes(:ad_extra)
      .select('ads.id, ad_extras.details AS ad_extra_details')
      .distinct('ads.id')
      .where(ad_descriptions: { short: [nil, ''] })
      .find_in_batches(batch_size: 10000) do |ads|
        to_upsert = []

        ads.each do |ad|
          short = AdCarShortDescriptionPresenter.new.call(ad.ad_extra_details)
          to_upsert << { ad_id: ad.id, short: short } if short.present?
        end

        puts to_upsert.size

        AdDescription.upsert_all(to_upsert, unique_by: [:ad_id]) if to_upsert.present?
      end
  end
end
