class AddStatistics < ActiveRecord::Migration[6.1]
  def up
    execute('CREATE STATISTICS stats_for_user_contacts (dependencies) ON user_id, phone_number_id FROM user_contacts')
    execute('CREATE STATISTICS stats_for_user_connections_friends (dependencies) ON user_id, friend_id FROM user_connections')
    execute('CREATE STATISTICS stats_for_user_connections_connections (dependencies) ON user_id, connection_id FROM user_connections')
  end

  def down
    execute('DROP STATISTICS stats_for_user_contacts')
    execute('DROP STATISTICS stats_for_user_connections_friends')
    execute('DROP STATISTICS stats_for_user_connections_connections')
  end
end
