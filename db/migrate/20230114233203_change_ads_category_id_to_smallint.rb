# frozen_string_literal: true
class ChangeAdsCategoryIdToSmallint < ActiveRecord::Migration[7.0]
  def up
    change_column(:ads, :category_id, :smallint)
  end

  def down
    change_column(:ads, :category_id, :bigint)
  end
end
