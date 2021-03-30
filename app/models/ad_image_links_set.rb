# frozen_string_literal: true
class AdImageLinksSet < ApplicationRecord
  belongs_to :ad
  validates :value, presence: true
end
