# frozen_string_literal: true

class UpdateAdStats
  include Sidekiq::Worker

  sidekiq_options queue: "system", retry: true, backtrace: false

  def perform
    conn = ActiveRecord::Base.connection

    Ad.transaction do
      conn.execute(%[UPDATE ads SET stats = t.stats FROM (#{Ad.known.active.with_stats.to_sql}) t WHERE t.id = ads.id])
      conn.execute(%[UPDATE ads SET stats = t.stats FROM (#{Ad.joins(phone_number: :user).with_stats.to_sql}) t WHERE t.id = ads.id])
    end
  end
end
