# frozen_string_literal: true
class EffectiveAd < ApplicationRecord
  def self.refresh
    connection.execute("REFRESH MATERIALIZED VIEW CONCURRENTLY #{table_name}")
  end

  def readonly
    true
  end
end
