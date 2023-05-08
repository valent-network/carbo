# frozen_string_literal: true

class AddExtraColumnToMessages < ActiveRecord::Migration[7.0]
  def change
    add_column(:messages, :extra, :jsonb)
  end
end
