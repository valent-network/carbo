# frozen_string_literal: true
class City < ApplicationRecord
  belongs_to :region
  validates :region, :name, presence: true
  validates :name, length: { maximum: 255 }
  validates :region, uniqueness: { scope: :name }
end
