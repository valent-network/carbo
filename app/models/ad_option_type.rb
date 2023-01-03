# frozen_string_literal: true
class AdOptionType < ApplicationRecord
  INPUT_TYPES = %w[default number picker]

  validates :name, presence: true, uniqueness: true
  validates :filterable, inclusion: { in: [true, false] }
  validates :input_type, inclusion: { in: INPUT_TYPES }, presence: true

  has_many :filterable_values, dependent: :destroy

  belongs_to :category

  after_save :update_global_filter

  scope :filterable, -> { where(filterable: true) }

  private

  def update_global_filter
    FiltersJsonUpdater.new.call
  end
end
