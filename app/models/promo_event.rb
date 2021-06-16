# frozen_string_literal: true
class PromoEvent < ApplicationRecord
  self.primary_key = :id
  self.table_name = 'promo_events_matview'

  belongs_to :user, foreign_key: :refcode, primary_key: :refcode
  belongs_to :event
end
