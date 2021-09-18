# frozen_string_literal: true

def chartify(data)
  hash_data = Hash[data.to_a.map { |x| [x['date'], x['count']] }]
  res = ((1.month.ago + 1.day).to_date.to_s..Time.now.to_date.to_s).map do |date|
    hash_data[date] ? [date, hash_data[date]] : [date, 0]
  end

  res
end

ActiveAdmin.register_page('Dashboard') do
  menu priority: 1, label: proc { I18n.t('active_admin.dashboard') }

  content do
    @dashboard = DashboardStats.first

    h1 'Статистика'
    h6 "Обновлено: #{@dashboard.updated_at.strftime("%x %X")}"
    table do
      tbody do
        tr do
          th { 'Сущность' }
          th { 'Количество записей' }
          th { 'Последнее обновление' }
        end

        tr do
          td { 'Users' }
          td { @dashboard.users_count }
          td { I18n.l(@dashboard.last_user_created_at) }
        end

        tr do
          td { 'User Devices' }
          td { @dashboard.user_devices_count }
          td { I18n.l(@dashboard.last_user_device_updated_at) }
        end

        tr do
          td { 'Ads' }
          td { @dashboard.ads_count }
          td { I18n.l(@dashboard.last_ad_created_at) }
        end

        tr do
          td { 'Effective Ads' }
          td { "#{@dashboard.effective_ads_count} (#{((@dashboard.effective_ads_count / @dashboard.active_ads_count.to_f) * 100).round(2)}%)" }
          td { I18n.l(@dashboard.last_effective_ad_created_at) }
        end

        tr do
          td { 'Messages' }
          td { @dashboard.messages_count }
          td { I18n.l(@dashboard.last_message_created_at) }
        end

        tr do
          td { 'Chat Rooms' }
          td { @dashboard.chat_rooms_count }
          td { I18n.l(@dashboard.last_chat_room_created_at) }
        end

        tr do
          td { 'Phone Numbers' }
          td { @dashboard.phone_numbers_count }
          td
        end

        tr do
          td { 'User Contacts' }
          td { @dashboard.user_contacts_count }
          td
        end

        tr do
          td { 'Unique User Contacts Phone Numbers' }
          td { @dashboard.uniq_user_contacts_count }
          td
        end

        tr do
          td { 'Known Ads' }
          td { @dashboard.known_ads_count }
          td
        end

        tr do
          td { 'Syncing Ads' }
          td { @dashboard.syncing_ads_count }
          td
        end
      end

      @dashboard.user_devices_os_data.each do |os|
        tr do
          td { "Устройств #{os['os_title'] || 'N/A'}" }
          td { os['count'] }
          td
        end
      end
    end

    h1 'Топ приглашающих'
    table do
      tbody do
        tr do
          th { 'Пригласительный код' }
          th { 'Количество приглашённых' }
        end
        @dashboard.referrers_top.each do |ref_top|
          tr do
            th { ref_top['refcode'] }
            th { ref_top['count'] }
          end
        end
      end
    end

    panel 'Активность пользователей (using UserDevice#updated_at information)' do
      line_chart chartify(@dashboard.user_activity_chart_data)
    end

    panel 'Активность приглашений' do
      line_chart chartify(@dashboard.invited_users_chart_data)
    end

    panel 'Активность просмотров объявлений' do
      line_chart chartify(@dashboard.visited_ad_chart_data)
    end

    panel 'Регистрации пользователей' do
      line_chart chartify(@dashboard.user_registrations_chart_data)
    end

    panel 'Активность сообщений' do
      line_chart chartify(@dashboard.messages_chart_data)
    end
  end
end
