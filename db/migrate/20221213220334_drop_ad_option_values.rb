class DropAdOptionValues < ActiveRecord::Migration[7.0]
  def up
    drop_table(:ad_option_values)
  end

  def down
    create_table(:ad_option_values) do |t|
      t.string(:value, null: false)
    end

    add_index(:ad_option_values, :value, unique: true)
  end
end
