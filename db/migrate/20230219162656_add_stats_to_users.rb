# frozen_string_literal: true

class AddStatsToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column(:users, :stats, :jsonb, default: {})
  end
end
