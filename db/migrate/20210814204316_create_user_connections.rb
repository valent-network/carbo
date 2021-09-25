# frozen_string_literal: true
class CreateUserConnections < ActiveRecord::Migration[6.1]
  def change
    create_table(:user_connections) do |t|
      t.integer(:user_id, null: false)
      t.integer(:friend_id, null: false)
      t.integer(:connection_id, null: false)
    end

    add_index(:user_connections, %i[user_id connection_id friend_id], unique: true, name: :index_user_connections_on_uniq)

    add_foreign_key(:user_connections, :users)
    add_foreign_key(:user_connections, :users, column: :connection_id)
    add_foreign_key(:user_connections, :users, column: :friend_id)
  end
end
