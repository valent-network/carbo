# frozen_string_literal: true

ActiveAdmin.register(ChatRoom) do
  scope :system, default: true
  actions :index, :show
  includes :messages, :user

  index pagination_total: false do
    column(:user) { |chat_room| link_to((chat_room.user.name.presence || chat_room.user.id), admin_user_path(chat_room.user)) }
    column(:created_at)
    column(:last_message) do |chat_room|
      last_message = chat_room.messages.sort_by(&:created_at).last
      last_message.user_id ? last_message.body : 'System'
    end
    column(:messages_count) { |chat_room| chat_room.messages.size }
    actions
  end

  show do
    attributes_table do
      row :user do |chat_room|
        link_to((chat_room.user.name.presence || chat_room.user.id), admin_user_path(chat_room.user))
      end
      row :messages do |chat_room|
        chat_room.messages.includes(:user).order(:created_at).map do |m|
          "<b>#{m.user ? (m.user.name.presence || m.user.id) : 'System'}</b><br/>#{m.body}<small style='float: right'>(#{m.created_at.strftime("%b, %d — %X")})</small><hr/>"
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
