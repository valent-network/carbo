# frozen_string_literal: true

class DashboardStats < ApplicationRecord
  self.primary_key = 'updated_at'

  def self.refresh(concurrently: true)
    # TODO: space before CONCURRENTLY is VERY important
    concurrently_string = concurrently ? ' CONCURRENTLY' : ''
    KnownAd.refresh(concurrently: concurrently)
    connection.execute("REFRESH MATERIALIZED VIEW#{concurrently_string} #{table_name} WITH DATA")
  end

  def readonly
    true
  end
end
