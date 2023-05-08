# frozen_string_literal: true

class CreateAdQueries < ActiveRecord::Migration[7.0]
  def change
    create_table(:ad_queries) do |t|
      t.string(:title)
      t.belongs_to(:ad)
      t.timestamps
    end

    add_index(:ad_queries, :title, using: :gin, opclass: {title: :gin_trgm_ops})
  end
end
