# frozen_string_literal: true
class AddReferrerIdToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column(:users, :referrer_id, :integer)
    add_index(:users, :referrer_id)
    add_foreign_key(:users, :users, on_delete: :restrict, column: :referrer_id)
  end
end
