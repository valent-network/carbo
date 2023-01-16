# frozen_string_literal: true
class AdsjustIndexesAndTypesForAdsSupplementalTables < ActiveRecord::Migration[7.0]
  def up
    matview = execute("SELECT pg_get_viewdef('ads_grouped_by_maker_model_year')")[0]['pg_get_viewdef']
    execute('DROP MATERIALIZED VIEW ads_grouped_by_maker_model_year')

    change_column(:ad_extras, :ad_id, :integer)
    change_column(:ad_queries, :ad_id, :integer)

    remove_column(:ad_descriptions, :id)
    remove_column(:ad_extras, :id)
    remove_column(:ad_image_links_sets, :id)
    remove_column(:ad_queries, :id)

    remove_index(:ad_descriptions, :ad_id)
    remove_index(:ad_extras, :ad_id)
    remove_index(:ad_image_links_sets, :ad_id)
    remove_index(:ad_queries, :ad_id)

    execute('ALTER TABLE ad_descriptions ADD PRIMARY KEY (ad_id)')
    execute('ALTER TABLE ad_extras ADD PRIMARY KEY (ad_id)')
    execute('ALTER TABLE ad_image_links_sets ADD PRIMARY KEY (ad_id)')
    execute('ALTER TABLE ad_queries ADD PRIMARY KEY (ad_id)')

    execute(<<~SQL)
      CREATE MATERIALIZED VIEW ads_grouped_by_maker_model_year AS #{matview}
    SQL
  end

  def down
    matview = execute("SELECT pg_get_viewdef('ads_grouped_by_maker_model_year')")[0]['pg_get_viewdef']
    execute('DROP MATERIALIZED VIEW ads_grouped_by_maker_model_year')

    change_column(:ad_extras, :ad_id, :bigint)
    change_column(:ad_queries, :ad_id, :bigint)

    execute('ALTER TABLE ad_descriptions DROP CONSTRAINT ad_descriptions_pkey')
    execute('ALTER TABLE ad_descriptions ADD COLUMN id SERIAL PRIMARY KEY')

    execute('ALTER TABLE ad_extras DROP CONSTRAINT ad_extras_pkey')
    execute('ALTER TABLE ad_extras ADD COLUMN id SERIAL PRIMARY KEY')

    execute('ALTER TABLE ad_image_links_sets DROP CONSTRAINT ad_image_links_sets_pkey')
    execute('ALTER TABLE ad_image_links_sets ADD COLUMN id SERIAL PRIMARY KEY')

    execute('ALTER TABLE ad_queries DROP CONSTRAINT ad_queries_pkey')
    execute('ALTER TABLE ad_queries ADD COLUMN id SERIAL PRIMARY KEY')

    add_index(:ad_descriptions, :ad_id, unique: true)
    add_index(:ad_extras, :ad_id, unique: true)
    add_index(:ad_image_links_sets, :ad_id, unique: true)
    add_index(:ad_queries, :ad_id, unique: true)

    execute('CLUSTER ad_extras USING index_ad_extras_on_ad_id')
    execute('CLUSTER ad_queries USING index_ad_queries_on_ad_id')

    execute(<<~SQL)
      CREATE MATERIALIZED VIEW ads_grouped_by_maker_model_year AS #{matview}
    SQL
  end
end
