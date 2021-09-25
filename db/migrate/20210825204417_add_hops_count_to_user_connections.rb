# frozen_string_literal: true
class AddHopsCountToUserConnections < ActiveRecord::Migration[6.1]
  def change
    add_column(:user_connections, :hops_count, :smallint)
  end
end
