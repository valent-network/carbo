# frozen_string_literal: true
class BusinessPhoneNumber < ApplicationRecord
  belongs_to :phone_number
  delegate :full_number, to: :phone_number
end
