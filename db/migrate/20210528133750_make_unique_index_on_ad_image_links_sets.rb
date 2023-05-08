# frozen_string_literal: true

class MakeUniqueIndexOnAdImageLinksSets < ActiveRecord::Migration[6.1]
  def change
    remove_index(:ad_image_links_sets, :ad_id)
    add_index(:ad_image_links_sets, :ad_id, unique: true)
  end
end
