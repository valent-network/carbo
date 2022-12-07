class AddUkAndEnTranslationsToRegions < ActiveRecord::Migration[7.0]
  def change
    add_column :regions, :translations, :jsonb, default: {}
  end
end
