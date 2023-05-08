# frozen_string_literal: true

class AddUniqueIndexesToMviesToEnableConcurrentRefresh < ActiveRecord::Migration[7.0]
  def change
    add_index(:active_known_ads, :id, unique: true)
    add_index(:users_known_ads, [:id, :user_id], unique: true)
    add_index(:users_known_users, [:user_id, :connection_id], unique: true)
  end
end
