# frozen_string_literal: true
class AddDemoCodeToDemoPhoneNumbers < ActiveRecord::Migration[6.0]
  def change
    add_column(:demo_phone_numbers, :demo_code, :integer)
  end
end
