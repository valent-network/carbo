class CreateSystemStats < ActiveRecord::Migration[6.1]
  def change
    create_table :system_stats do |t|
      t.jsonb :data
    end
  end
end
