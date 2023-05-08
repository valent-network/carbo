# frozen_string_literal: true

class CreateMessages < ActiveRecord::Migration[6.0]
  def change
    create_table(:messages, id: :uuid) do |t|
      t.string(:body, null: false)
      t.boolean(:system, null: false, default: false)
      t.belongs_to(:chat_room_user)
      t.belongs_to(:user)
      t.belongs_to(:chat_room, null: false)
      t.datetime(:created_at, null: false)
    end
  end
end
