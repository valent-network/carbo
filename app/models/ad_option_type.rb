# frozen_string_literal: true
class AdOptionType < ApplicationRecord
  validates :name, presence: true, uniqueness: true
end
