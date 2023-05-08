# frozen_string_literal: true

module Materializable
  extend ActiveSupport::Concern

  included do
    def self.refresh(concurrently: true)
      # TODO: space before CONCURRENTLY is VERY important
      concurrently_string = concurrently ? " CONCURRENTLY" : ""
      connection.execute("REFRESH MATERIALIZED VIEW#{concurrently_string} #{table_name} WITH DATA")
    end
  end

  def readonly
    true
  end
end
