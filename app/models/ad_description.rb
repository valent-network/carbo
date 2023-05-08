# frozen_string_literal: true

class AdDescription < ApplicationRecord
  belongs_to :ad
  validates :ad, uniqueness: true
end
