# frozen_string_literal: true
class FilterableValue < ApplicationRecord
  belongs_to :ad_option_value
  belongs_to :ad_option_type
  validates :name, presence: true
  validates :ad_option_value, uniqueness: { scope: [:ad_option_type] }
end
