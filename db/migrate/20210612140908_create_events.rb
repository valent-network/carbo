# frozen_string_literal: true
class CreateEvents < ActiveRecord::Migration[6.1]
  def change
    create_table(:events) do |t|
      t.string(:name)
      t.belongs_to(:user)
      t.jsonb(:data)
      t.datetime(:created_at, null: false)
    end
  end
end
