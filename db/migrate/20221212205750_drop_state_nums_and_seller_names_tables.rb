# frozen_string_literal: true
class DropStateNumsAndSellerNamesTables < ActiveRecord::Migration[7.0]
  def up
    drop_table(:state_nums)
    drop_table(:seller_names)
  end

  def down
    create_table(:seller_names) do |t|
      t.integer(:ad_id, null: false)
      t.string(:value, null: false, limit: 255)
    end
    add_index(:seller_names, :ad_id)

    create_table(:state_nums, id: false) do |t|
      t.integer(:ad_id, null: false)
      t.string(:value, null: false, limit: 20)
    end
    add_index(:state_nums, :ad_id)
  end
end
