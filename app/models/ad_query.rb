# frozen_string_literal: true
class AdQuery < ApplicationRecord
  belongs_to :ad
  validates :title, presence: true
  validates :ad, uniqueness: true
end
