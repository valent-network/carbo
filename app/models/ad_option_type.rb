# frozen_string_literal: true
class AdOptionType < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  has_many :ad_options
  has_many :ad_option_values, through: :ad_options
end
