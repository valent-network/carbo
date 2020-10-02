# frozen_string_literal: true

class AdsSource < ApplicationRecord
  validates :title, :api_token, presence: true, uniqueness: true

  has_many :ads, dependent: :destroy
end
