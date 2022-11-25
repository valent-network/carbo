# frozen_string_literal: true
class BusinessPhoneNumber < ApplicationRecord
  belongs_to :phone_number
  delegate :full_number, to: :phone_number

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
