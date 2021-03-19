# frozen_string_literal: true

ActiveAdmin.register_page('Dashboard') do
  menu priority: 1, label: proc { I18n.t('active_admin.dashboard') }

  content do
    @counts = ApproximateCount.for_tables(%w[users ads effective_ads messages chat_rooms user_devices user_contacts effective_user_contacts phone_numbers])
    h1 'Статистика'
    table do
      tbody do
        tr do
          th { 'Сущность' }
          th { 'Количество записей (примерное)' }
          th { 'Последнее обновление' }
        end

        tr do
          td { 'Users' }
          td { @counts[:users] }
          td { I18n.l(User.last.created_at) }
        end
        tr do
          td { 'User Devices' }
          td { @counts[:user_devices] }
          td { I18n.l(UserDevice.most_recent_updated_at) }
        end

        tr do
          td { 'Ads' }
          td { @counts[:ads] }
          td { I18n.l(Ad.last.created_at) }
        end

        tr do
          td { 'Effective Ads' }
          td { "#{@counts[:effective_ads]} (#{((@counts[:effective_ads] / @counts[:ads].to_f) * 100).round(2)}%)" }
          td { I18n.l(Ad.find(EffectiveAd.pluck('max(id)').first).created_at) }
        end

        tr do
          td { 'Messages' }
          td { @counts[:messages] }
          td { I18n.l(Message.order(created_at: :desc).first.created_at) }
        end

        tr do
          td { 'Chat Rooms' }
          td { @counts[:chat_rooms] }
          td { I18n.l(ChatRoom.order(created_at: :desc).first.created_at) }
        end

        tr do
          td
        end

        tr do
          td { 'Phone Numbers' }
          td { @counts[:phone_numbers] }
          td
        end

        tr do
          td { 'User Contacts' }
          td { @counts[:user_contacts] }
          td
        end

        tr do
          td { 'Effective User Contacts' }
          td { @counts[:effective_user_contacts] }
          td
        end

        tr do
          td
        end

        tr do
          td { 'Unique User Contacts Phone Numbers' }
          td { UserContact.select('phone_number_id').distinct.count }
          td
        end

        tr do
          td { 'Known Ads' }
          td { Ad.joins('JOIN user_contacts ON user_contacts.phone_number_id = ads.phone_number_id').count }
          td
        end

        tr do
          td { 'Syncing Ads' }
          td { Ad.joins('JOIN user_contacts ON user_contacts.phone_number_id = ads.phone_number_id').where(deleted: false).where('updated_at < ?', 12.hours.ago).count }
          td
        end
      end
    end

    panel 'Активность пользователей (using UserDevice#updated_at information' do
      line_chart UserDeviceStat.order(:created_at).all.map { |item|
        [item.created_at.strftime("%F"), item.user_devices_appeared_count]
      }
    end

    panel 'Регистрации пользователей' do
      line_chart User.group('date(created_at)').count.map { |u| [u.first.strftime("%F"), u.last] }
    end
  end
end
