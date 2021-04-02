# frozen_string_literal: true
class AdDescription < ApplicationRecord
  belongs_to :ad
  validates :body, presence: true
  validates :ad, uniqueness: true
end
