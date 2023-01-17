# frozen_string_literal: true
class FilterableValue < ApplicationRecord
  include SettingsUpdateable

  belongs_to :ad_option_type

  has_one :category, through: :ad_option_type

  validates :name, :raw_value, presence: true

  def group
    ad_option_type.groups.to_a.detect { |fvg| fvg.name == name }
  end
end
