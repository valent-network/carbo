# frozen_string_literal: true
class CreateDemoPhoneNumbers < ActiveRecord::Migration[6.0]
  def change
    create_table :demo_phone_numbers do |t|
      t.belongs_to(:phone_number, null: false)
    end
  end
end
