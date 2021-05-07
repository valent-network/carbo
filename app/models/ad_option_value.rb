# frozen_string_literal: true
class AdOptionValue < ApplicationRecord
  has_many :ad_options

  validates :value, presence: true, uniqueness: true
end
