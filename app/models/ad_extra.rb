# frozen_string_literal: true

class AdExtra < ApplicationRecord
  belongs_to :ad
  validates :ad, uniqueness: true
end
