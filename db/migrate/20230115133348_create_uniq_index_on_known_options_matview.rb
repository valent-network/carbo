# frozen_string_literal: true

class CreateUniqIndexOnKnownOptionsMatview < ActiveRecord::Migration[7.0]
  def change
    add_index(:known_options, %i[k v], unique: true)
  end
end
