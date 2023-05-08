# frozen_string_literal: true

class CreateAdImages < ActiveRecord::Migration[7.0]
  def change
    create_table(:ad_images) do |t|
      t.string(:attachment, null: false)
      t.integer(:position, limit: 2, null: false)
      t.belongs_to(:ad)
      t.timestamps
    end
  end
end
