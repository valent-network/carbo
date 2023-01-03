# frozen_string_literal: true
class AddCurrencyToCategories < ActiveRecord::Migration[7.0]
  def change
    add_column(:categories, :currency, :string)
  end
end
