# frozen_string_literal: true
class DropIdFromSellerNames < ActiveRecord::Migration[6.1]
  def change
    remove_column(:seller_names, :id, :integer, null: false)
  end
end
