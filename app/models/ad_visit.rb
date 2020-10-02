# frozen_string_literal: true
class AdVisit < ApplicationRecord
  validates :ad_id, uniqueness: { scope: :user_id }

  belongs_to :user
  belongs_to :ad
end
