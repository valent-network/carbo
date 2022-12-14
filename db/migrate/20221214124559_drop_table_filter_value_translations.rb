# frozen_string_literal: true
class DropTableFilterValueTranslations < ActiveRecord::Migration[7.0]
  def up
    drop_table(:filterable_value_translations)
  end

  def down
    create_table(:filterable_value_translations) do |t|
      t.belongs_to(:ad_option_type)
      t.string(:alias_group_name, null: false)
      t.string(:name, null: false)
      t.string(:locale, null: false)

      t.timestamps
    end

    add_index(:filterable_value_translations, [:name, :ad_option_type_id, :locale], unique: :true, name: :index_filterable_value_translations_on_uniq)
  end
end
