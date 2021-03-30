# frozen_string_literal: true
class AdOptionValue < ApplicationRecord
  validates :value, presence: true, uniqueness: true
end
