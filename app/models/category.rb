# frozen_string_literal: true
class Category < ApplicationRecord
  CURRENCIES = %w[$ ₴]

  has_many :ad_option_types

  validates :currency, inclusion: { in: CURRENCIES }, presence: true
end
