# frozen_string_literal: true
class CreatePhoneNumbers < ActiveRecord::Migration[6.0]
  def change
    create_table(:phone_numbers) do |t|
      t.string(:full_number, null: false, limit: 9)
    end

    add_index(:phone_numbers, :full_number, unique: true)
  end
end
