class AddIndexToDashboardStatsMatview < ActiveRecord::Migration[7.0]
  def change
    add_index(:dashboard_stats, :updated_at, unique: true)
  end
end
