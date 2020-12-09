# frozen_string_literal: true

ActiveAdmin.register_page('Dashboard') do
  menu priority: 1, label: proc { I18n.t('active_admin.dashboard') }

  content do
    h1 'Stats'
    table do
      tbody do
        tr do
          td { 'Users' }
          td { User.count }
          td { I18n.l(User.last.created_at) }
        end

        tr do
          td { 'Ads' }
          td { Ad.count }
          td { I18n.l(Ad.last.created_at) }
        end

        tr do
          td { 'Effective Ads' }
          td { Ad.joins('JOIN user_contacts ON user_contacts.phone_number_id = ads.phone_number_id').count }
          td
        end

        tr do
          td { 'Messages' }
          td { Message.count }
          td { I18n.l(Message.order(created_at: :desc).first.created_at) }
        end

        tr do
          td { 'Chat Rooms' }
          td { ChatRoom.count }
          td { I18n.l(ChatRoom.order(created_at: :desc).first.created_at) }
        end

        tr do
          td { 'Phone Numbers' }
          td { PhoneNumber.count }
          td
        end

        tr do
          td { 'User Contacts' }
          td { UserContact.count }
          td
        end

        tr do
          td { 'User Devices' }
          td { UserDevice.count }
          td { I18n.l(UserDevice.most_recent_updated_at) }
        end
      end
    end
  end
end
