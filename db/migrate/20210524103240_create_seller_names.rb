# frozen_string_literal: true

class CreateSellerNames < ActiveRecord::Migration[6.1]
  def change
    create_table(:seller_names) do |t|
      t.integer(:ad_id, null: false)
      t.string(:value, null: false, limit: 255)
      t.timestamps
    end

    add_index(:seller_names, :ad_id)
  end
end
