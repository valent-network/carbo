# frozen_string_literal: true

class AddIndexesForPerformanceAndPrepareRemoveEav < ActiveRecord::Migration[7.0]
  def change
    add_index(:ad_extras, :details, using: :gin)
    add_index(:ads, [:id, :price], order: {id: :desc}, where: "deleted = FALSE")
    add_index(:ads, [:phone_number_id, :id])
    add_index(:user_connections, [:user_id, :connection_id, :hops_count], name: :index_user_connections_for_feed)
  end
end
