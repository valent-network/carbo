# frozen_string_literal: true

class AddPrimaryKeyToAdOptions < ActiveRecord::Migration[7.0]
  def up
    execute("ALTER TABLE ad_options ADD PRIMARY KEY (id)")
  end

  def down
    execute("ALTER TABLE ad_options DROP CONSTRAINT ad_options_pkey")
  end
end
