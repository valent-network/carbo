# frozen_string_literal: true

class DemoPhoneNumber < ApplicationRecord
  DEMO_CODE = 2007
  belongs_to :phone_number
  validates :demo_code, inclusion: {in: 1000..9999}

  def phone=(value)
    self.phone_number = PhoneNumber.by_full_number(value).first_or_initialize
  end

  def phone
    phone_number.to_s
  end
end
