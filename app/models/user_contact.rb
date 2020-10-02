# frozen_string_literal: true

class UserContact < ApplicationRecord
  validates :phone_number, uniqueness: { scope: :user_id }
  validates :name, exclusion: { in: [nil] }, length: { maximum: 100 }

  belongs_to :user
  belongs_to :phone_number
  has_one :friend, through: :phone_number, source: :user
end
