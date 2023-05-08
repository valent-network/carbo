# frozen_string_literal: true

class CreateStateNums < ActiveRecord::Migration[6.1]
  def change
    create_table(:state_nums, id: false) do |t|
      t.integer(:ad_id, null: false)
      t.string(:value, null: false, limit: 20)
    end

    add_index(:state_nums, :ad_id)
  end
end
