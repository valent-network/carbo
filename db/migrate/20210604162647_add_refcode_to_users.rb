# frozen_string_literal: true
class AddRefcodeToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column(:users, :refcode, :string)
    add_index(:users, :refcode, unique: true)
  end
end
