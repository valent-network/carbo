# frozen_string_literal: true

class AddIndexToAdsOnPhoneNumberId < ActiveRecord::Migration[6.0]
  def change
    add_index(:ads, :phone_number_id)
  end
end
