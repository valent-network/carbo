# frozen_string_literal: true
class AddIndexesForFutureClustering < ActiveRecord::Migration[7.0]
  def change
    add_index(:user_contacts, [:user_id, :phone_number_id], unique: true)
    add_index(:users, [:phone_number_id, :id], unique: true)
  end
end
