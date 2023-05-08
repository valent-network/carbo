# frozen_string_literal: true

class UserBlockedPhoneNumber < ApplicationRecord
  belongs_to :user
  belongs_to :phone_number
  validates :user_id, uniqueness: {scope: [:phone_number_id]}
end
