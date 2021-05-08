class FixAdDescriptionIndex < ActiveRecord::Migration[6.1]
  def change
    remove_index :ad_descriptions, name: :ttt
    remove_index :ad_descriptions, :ad_id
    add_index :ad_descriptions, :ad_id, unique: true
  end
end
