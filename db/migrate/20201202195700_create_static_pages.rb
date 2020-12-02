# frozen_string_literal: true
class CreateStaticPages < ActiveRecord::Migration[6.0]
  def change
    create_table :static_pages do |t|
      t.string(:title, null: false)
      t.string(:slug, null: false)
      t.text(:body)
      t.jsonb(:meta)
      t.timestamps
    end

    add_index(:static_pages, :slug, unique: true)
  end
end
