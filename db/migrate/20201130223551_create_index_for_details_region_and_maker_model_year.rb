# frozen_string_literal: true

class CreateIndexForDetailsRegionAndMakerModelYear < ActiveRecord::Migration[6.0]
  def change
    execute("CREATE INDEX details_region_year_maker_model_index ON ads((details->'region'->>0), (details->>'year'), (details->>'maker'), (details->>'model'))")
  end
end
