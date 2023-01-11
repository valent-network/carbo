# frozen_string_literal: true

class KnownOption < ApplicationRecord
  # self.primary_key = :k,:v

  def self.refresh(concurrently: true)
    # TODO: space before CONCURRENTLY is VERY important
    concurrently_string = concurrently ? ' CONCURRENTLY' : ''
    connection.execute("REFRESH MATERIALIZED VIEW#{concurrently_string} #{table_name} WITH DATA")
  end

  def readonly
    true
  end
end
