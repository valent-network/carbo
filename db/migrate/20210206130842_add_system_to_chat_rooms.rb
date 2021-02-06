class AddSystemToChatRooms < ActiveRecord::Migration[6.1]
  def change
    add_column :chat_rooms, :system, :boolean, default: false, null: false
    add_index :chat_rooms, :user_id, unique: true, where: 'system = true', name: 'index_on_chat_rooms_user_id_where_system_true'
  end
end
