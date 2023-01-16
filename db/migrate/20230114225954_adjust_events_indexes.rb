# frozen_string_literal: true
class AdjustEventsIndexes < ActiveRecord::Migration[7.0]
  def up
    matview = execute("SELECT pg_get_viewdef('dashboard_stats')")[0]['pg_get_viewdef']
    execute('DROP MATERIALIZED VIEW dashboard_stats')
    change_column(:events, :id, :integer)
    change_column(:events, :user_id, :integer)
    execute(<<~SQL)
      CREATE MATERIALIZED VIEW dashboard_stats AS #{matview}
    SQL
  end

  def down
    matview = execute("SELECT pg_get_viewdef('dashboard_stats')")[0]['pg_get_viewdef']
    execute('DROP MATERIALIZED VIEW dashboard_stats')
    change_column(:events, :id, :bigint)
    change_column(:events, :user_id, :bigint)
    execute(<<~SQL)
      CREATE MATERIALIZED VIEW dashboard_stats AS #{matview}
    SQL
  end
end
