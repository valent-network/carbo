# frozen_string_literal: true
class CreateAdDescriptions < ActiveRecord::Migration[6.1]
  def change
    create_table(:ad_descriptions) do |t|
      t.belongs_to(:ad, null: false)
      t.text(:body)
    end
  end
end
