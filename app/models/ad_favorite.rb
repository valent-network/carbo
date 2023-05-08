# frozen_string_literal: true

class AdFavorite < ApplicationRecord
  belongs_to :user
  belongs_to :ad

  validates :ad_id, uniqueness: {scope: :user_id}
end
