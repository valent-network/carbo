# frozen_string_literal: true
class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.belongs_to(:phone_number, null: false, index: { unique: true })
      t.string(:avatar)
      t.string(:name)

      t.timestamps
    end

    add_foreign_key(:users, :phone_numbers, on_delete: :cascade)
  end
end
