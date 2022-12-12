class FixAdQueriesAdIdIndex < ActiveRecord::Migration[7.0]
  def up
    remove_index :ad_queries, :ad_id
    add_index :ad_queries, :ad_id, unique: true
    execute('CLUSTER ad_queries USING index_ad_queries_on_ad_id')
  end

  def down
    remove_index :ad_queries, :ad_id
    add_index :ad_queries, :ad_id, unique: true
    execute('ALTER TABLE ad_queries SET WITHOUT CLUSTER')
  end
end
