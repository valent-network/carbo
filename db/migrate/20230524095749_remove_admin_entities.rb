class RemoveAdminEntities < ActiveRecord::Migration[7.0]
  def up
    drop_table(:admin_users)
    drop_table(:active_admin_comments)
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
