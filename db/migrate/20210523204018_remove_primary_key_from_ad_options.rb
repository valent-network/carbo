# frozen_string_literal: true

class RemovePrimaryKeyFromAdOptions < ActiveRecord::Migration[6.1]
  def up
    execute("ALTER TABLE ad_options DROP CONSTRAINT ad_options_pkey")
  end

  def down
    execute("ALTER TABLE ad_options ADD PRIMARY KEY (id)")
  end
end
