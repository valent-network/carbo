# frozen_string_literal: true
class EffectiveUserContact < ApplicationRecord
  def self.refresh
    connection.execute("REFRESH MATERIALIZED VIEW CONCURRENTLY #{table_name}")
  end

  def readonly
    true
  end
end
