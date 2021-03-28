class CreateAdPrices < ActiveRecord::Migration[6.1]
  def change
    create_table :ad_prices do |t|
      t.belongs_to(:ad, null: false)
      t.integer(:price, null: false)
      t.datetime(:created_at, null: false)
    end
  end
end
