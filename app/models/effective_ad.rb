# frozen_string_literal: true
class EffectiveAd < ApplicationRecord
  def self.refresh(concurrently: true)
    connection.execute("REFRESH MATERIALIZED VIEW #{concurrently ? 'CONCURRENTLY' : ''} #{table_name}")
  end

  def readonly
    true
  end
end
