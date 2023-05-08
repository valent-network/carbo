# frozen_string_literal: true

class AddInputTypeToAdOptionTypes < ActiveRecord::Migration[7.0]
  def change
    add_column(:ad_option_types, :input_type, :string, default: :text, null: false)
  end
end
