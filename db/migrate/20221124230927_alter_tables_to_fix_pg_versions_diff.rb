# frozen_string_literal: true

class AlterTablesToFixPgVersionsDiff < ActiveRecord::Migration[7.0]
  def up
    change_column(:rpush_apps, :access_token_expiration, "timestamp(6)")
  end

  def down
    change_column(:rpush_apps, :access_token_expiration, "timestamp")
  end
end
