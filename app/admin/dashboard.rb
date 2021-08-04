# frozen_string_literal: true

ActiveAdmin.register_page('Dashboard') do
  menu priority: 1, label: proc { I18n.t('active_admin.dashboard') }

  content do
    @counts = ApproximateCount.for_tables(%w[users ads effective_ads messages chat_rooms user_devices user_contacts effective_user_contacts phone_numbers])
    @referrers_top = User.where.not(referrer_id: nil).group(:referrer_id).having('COUNT(referrer_id) > 5').count.sort_by(&:last).reverse
    @referrers_top_users = Hash[User.where(id: @referrers_top.map(&:first)).pluck(:id, :refcode)]

    h1 'Статистика'
    table do
      tbody do
        tr do
          th { 'Сущность' }
          th { 'Количество записей' }
          th { 'Последнее обновление' }
        end

        tr do
          td
          td '<b><center>Примерное</center></b>'.html_safe
          td
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
          td { "#{@counts[:effective_ads]} (#{((@counts[:effective_ads] / Ad.active.count.to_f) * 100).round(2)}%)" }
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
          td '<b><center>Точное</center></b>'.html_safe
          td
        end

        tr do
          td { 'Unique User Contacts Phone Numbers' }
          td { UserContact.select('phone_number_id').distinct.count }
          td
        end

        tr do
          td { 'Known Ads' }
          td { Ad.where('ads.phone_number_id IN (SELECT phone_number_id FROM user_contacts)').count }
          td
        end

        tr do
          td { 'Syncing Ads' }
          td { Ad.where('ads.phone_number_id IN (SELECT phone_number_id FROM user_contacts)').where('updated_at < ?', 24.hours.ago).count }
          td
        end
      end

      tr do
        td
        td '<b><center>Устройства</center></b>'.html_safe
        td
      end

      UserDevice.group(:os).count.each do |os, count|
        tr do
          td { os || 'N/A' }
          td { count }
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
        @referrers_top.each do |ref_top|
          tr do
            th { @referrers_top_users[ref_top.first] }
            th { ref_top.last }
          end
        end
      end
    end

    panel 'Активность пользователей (using UserDevice#updated_at information)' do
      line_chart UserDeviceStat.where('updated_at > ?', 1.month.ago).order(:created_at).map { |item|
        [item.created_at.strftime("%F"), item.user_devices_appeared_count]
      }
    end

    panel 'Активность приглашений' do
      line_chart Event.where(name: "invited_user").where('created_at > ?', 1.month.ago).order('date(created_at)').group('date(created_at)').count.map { |u| [u.first.strftime("%F"), u.last] }
    end

    panel 'Активность просмотров объявлений' do
      line_chart Event.where(name: "visited_ad").where('created_at > ?', 1.month.ago).order('date(created_at)').group('date(created_at)').count.map { |u| [u.first.strftime("%F"), u.last] }
    end

    panel 'Регистрации пользователей' do
      line_chart User.where('created_at > ?', 1.month.ago).group('date(created_at)').count.map { |u| [u.first.strftime("%F"), u.last] }
    end

    panel 'Активность сообщений' do
      line_chart Message.joins(:chat_room).where('messages.created_at > ?', 1.month.ago).where(chat_rooms: { system: false }).group('date(messages.created_at)').count.map { |u| [u.first.strftime("%F"), u.last] }
    end
  end
end
