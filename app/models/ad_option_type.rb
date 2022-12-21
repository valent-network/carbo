# frozen_string_literal: true
class AdOptionType < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  validates :filterable, inclusion: { in: [true, false] }

  has_many :filterable_values, dependent: :destroy

  belongs_to :category

  after_save :update_global_filter

  scope :filterable, -> { where(filterable: true) }

  private

  def update_global_filter
    FiltersJsonUpdater.new.call
  end
end
