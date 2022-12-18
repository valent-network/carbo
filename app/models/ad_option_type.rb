# frozen_string_literal: true
class AdOptionType < ApplicationRecord
  validates :name, presence: true, uniqueness: true

  has_many :filterable_values, dependent: :destroy

  belongs_to :category

  after_save :update_global_filter

  private

  def update_global_filter
    FiltersJsonUpdater.new.call
  end
end
