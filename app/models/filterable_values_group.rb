# frozen_string_literal: true
class FilterableValuesGroup < ApplicationRecord
  include SettingsUpdateable

  belongs_to :ad_option_type

  validates :name, presence: true, uniqueness: { scope: [:ad_option_type_id] }

  has_many :values, primary_key: :name, foreign_key: :name, class_name: 'FilterableValue'
end
