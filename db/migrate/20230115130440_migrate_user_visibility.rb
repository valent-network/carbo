# frozen_string_literal: true
class MigrateUserVisibility < ActiveRecord::Migration[7.0]
  def up
    execute(<<~SQL)
      INSERT INTO user_visibilities(user_id, data, created_at)
      SELECT user_id, data, created_at
      FROM events
      WHERE name = 'snapshot_user_visibility'
    SQL
    execute(<<~SQL)
      DROP INDEX index_events_on_user_id_and_created_at
    SQL
    execute(<<~SQL)
      DELETE FROM events WHERE name = 'snapshot_user_visibility'
    SQL
  end

  def down
    execute(<<~SQL)
      INSERT INTO events(name, user_id, data, created_at)
      SELECT 'snapshot_user_visibility', user_id, data, created_at
      FROM user_visibilities
    SQL
    execute(<<~SQL)
      DELETE FROM user_visibilities
    SQL
    add_index(:events, %i[user_id created_at], where: "(name)::text = 'snapshot_user_visibility'::text")
  end
end
