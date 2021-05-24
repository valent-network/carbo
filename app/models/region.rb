# frozen_string_literal: true
class Region < ApplicationRecord
  has_many :cities
  validates :name, presence: true, length: { maximum: 255 }
end
