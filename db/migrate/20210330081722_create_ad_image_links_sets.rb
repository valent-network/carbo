# frozen_string_literal: true

class CreateAdImageLinksSets < ActiveRecord::Migration[6.1]
  def change
    create_table(:ad_image_links_sets) do |t|
      t.belongs_to(:ad, null: false)
      t.string(:value, array: true, default: [])
    end
  end
end
