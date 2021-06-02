# frozen_string_literal: true

ActiveAdmin.register(ChatRoom) do
  scope :system, default: true
  actions :index, :show

  index pagination_total: false do
    column :user
    column :created_at
    column(:messages_count) { |chat_room| chat_room.messages.count }
    actions
  end

  show do
    attributes_table do
      row :user
      row :messages do |chat_room|
        chat_room.messages.includes(:user).map do |m|
          "<b>#{m.user ? m.user.name : 'System'}</b>: #{m.body} <small style='float: right'>(#{m.created_at.strftime("%b, %d — %X")})</small>"
        end.join("\n<br>").html_safe
      end
    end
    panel 'Reply' do
      semantic_form_for('system_message', url: system_message_admin_chat_room_path(chat_room)) do |f|
        f.inputs do
          f.input(:body, as: :text, input_html: { maxlength: 255, rows: 5 })
        end +
        f.actions do
          f.submit('Send')
        end
      end
    end
    active_admin_comments
  end

  member_action :system_message, method: :post do
    chat_room = ChatRoom.find(params[:id])
    SendSystemMessageToChatRoom.new.call(user_id: chat_room.user.id, message_text: params[:system_message][:body].strip)
    redirect_to admin_chat_room_path(chat_room), notice: 'Message Sent Succesfully'
  end

  filter :created_at
  filter :updated_at
end
