# frozen_string_literal: true
class ApproximateCount < ApplicationRecord
  self.table_name = 'pg_class'
  self.primary_key = nil

  default_scope -> {}

  def self.for_tables(table_names)
    rel = select('relname', 'reltuples::bigint AS count').where(relname: Array.wrap(table_names))
    Hash[rel.map { |approx| [approx.relname.to_sym, approx.count] }]
  end

  def readonly
    true
  end
end
