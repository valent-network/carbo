# frozen_string_literal: true
class ChangeIdFromBigintToIntegerOnUserConnections < ActiveRecord::Migration[7.0]
  def up
    matview = execute("SELECT pg_get_viewdef('dashboard_stats')")[0]['pg_get_viewdef']
    execute('DROP MATERIALIZED VIEW dashboard_stats')
    change_column(:user_connections, :id, :integer)
    execute(<<~SQL)
      CREATE MATERIALIZED VIEW dashboard_stats AS #{matview}
    SQL
  end

  def down
    matview = execute("SELECT pg_get_viewdef('dashboard_stats')")[0]['pg_get_viewdef']
    execute('DROP MATERIALIZED VIEW dashboard_stats')
    change_column(:user_connections, :id, :bigint)
    execute(<<~SQL)
      CREATE MATERIALIZED VIEW dashboard_stats AS #{matview}
    SQL
  end
end
