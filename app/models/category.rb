# frozen_string_literal: true
class Category < ApplicationRecord
  include SettingsImpactable

  CURRENCIES = %w[$ ₴]

  has_many :ad_option_types

  validates :currency, inclusion: { in: CURRENCIES }, presence: true
end
