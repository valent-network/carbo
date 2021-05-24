# frozen_string_literal: true
class SellerName < ApplicationRecord
  belongs_to :ad
  validates :ad, :value, presence: true
  validates :value, length: { maximum: 255 }
end
