# frozen_string_literal: true

class VerificationRequest < ApplicationRecord
  validates_associated :phone_number
  validates :verification_code, presence: true, numericality: {integer_only: true}

  belongs_to :phone_number
end
