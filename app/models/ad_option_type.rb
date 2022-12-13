# frozen_string_literal: true
class AdOptionType < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  has_many :ad_options, dependent: :destroy
  has_many :filterable_values, dependent: :destroy
end
