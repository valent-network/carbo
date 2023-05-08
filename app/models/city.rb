# frozen_string_literal: true

class City < ApplicationRecord
  include SettingsImpactable

  belongs_to :region

  validates :region, :name, presence: true
  validates :name, length: {maximum: 255}
  validates :region, uniqueness: {scope: :name}

  def display_name
    # Translated with https://www.grafiati.com/en/transliteration
    translations[I18n.locale.to_s].presence || name
  end
end
