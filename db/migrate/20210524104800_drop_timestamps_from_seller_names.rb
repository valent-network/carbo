# frozen_string_literal: true
class DropTimestampsFromSellerNames < ActiveRecord::Migration[6.1]
  def change
    remove_column(:seller_names, :created_at)
    remove_column(:seller_names, :updated_at)
  end
end
