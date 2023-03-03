# frozen_string_literal: true
class DropStaticPages < ActiveRecord::Migration[7.0]
  def up
    drop_table(:static_pages)
  end

  def down
    create_table(:static_pages) do |t|
      t.string(:title, null: false)
      t.string(:slug, null: false)
      t.text(:body)
      t.jsonb(:meta)
      t.timestamps
    end

    add_index(:static_pages, :slug, unique: true)
  end
end
