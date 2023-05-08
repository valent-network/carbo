# frozen_string_literal: true

class CreateUserVisibilities < ActiveRecord::Migration[7.0]
  def change
    create_table(:user_visibilities, id: false) do |t|
      t.integer(:user_id, null: false)
      t.jsonb(:data, default: {})
      t.datetime(:created_at)
    end

    add_index(:user_visibilities, :user_id)
    add_foreign_key(:user_visibilities, :users)
  end
end
