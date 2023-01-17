# frozen_string_literal: true
class Region < ApplicationRecord
  include SettingsImpactable

  has_many :cities

  validates :name, presence: true, length: { maximum: 255 }

  def display_name
    translations[I18n.locale.to_s].presence || name
  end
end
