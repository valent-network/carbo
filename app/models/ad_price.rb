# frozen_string_literal: true

class AdPrice < ApplicationRecord
  belongs_to :ad
  validates :price, presence: true, numericality: {greater_than: 0, only_integer: true}
end
