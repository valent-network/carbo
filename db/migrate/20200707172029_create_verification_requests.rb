# frozen_string_literal: true
class CreateVerificationRequests < ActiveRecord::Migration[6.0]
  def change
    create_table(:verification_requests) do |t|
      t.belongs_to(:phone_number, null: false, index: { unique: true })

      t.integer(:verification_code, null: false)

      t.timestamps
    end
  end
end
