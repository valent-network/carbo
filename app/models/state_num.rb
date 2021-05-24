# frozen_string_literal: true
class StateNum < ApplicationRecord
  belongs_to :ad
  validates :ad, :value, presence: true
  validates :value, length: { maximum: 20 }
end
