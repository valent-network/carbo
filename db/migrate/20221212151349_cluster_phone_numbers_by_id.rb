# frozen_string_literal: true

class ClusterPhoneNumbersById < ActiveRecord::Migration[7.0]
  def up
    execute("CLUSTER phone_numbers USING phone_numbers_pkey")
  end

  def down
    execute("ALTER TABLE phone_numbers SET WITHOUT CLUSTER")
  end
end
