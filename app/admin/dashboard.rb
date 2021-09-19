# frozen_string_literal: true

def chartify(data)
  hash_data = Hash[data.to_a.map { |x| [x['date'], x['count']] }]
  res = ((1.month.ago + 1.day).to_date..Time.now.to_date).map(&:to_s).map do |date|
    hash_data[date] ? [date, hash_data[date]] : [date, 0]
  end

  res
end

ActiveAdmin.register_page('Dashboard') do
  menu priority: 1, label: proc { I18n.t('active_admin.dashboard') }

  content do
    @dashboard = DashboardStats.first
    @effective_ads_percentage = ((@dashboard.effective_ads_count / @dashboard.active_ads_count.to_f) * 100).round(2)
    @known_ads_percentage = (((@dashboard.known_ads_count - @dashboard.syncing_ads_count.to_f) / @dashboard.known_ads_count) * 100).round(2)
    @user_contacts_percentage = ((@dashboard.uniq_user_contacts_count / @dashboard.user_contacts_count.to_f) * 100).round(2)
    @ios_devices_percentage = (@dashboard.user_devices_os_data.find { |t| t['os_title'] == 'ios' }['count'].to_f / @dashboard.user_devices_count) * 100
    @android_devices_percentage = (@dashboard.user_devices_os_data.find { |t| t['os_title'] == 'android' }['count'].to_f / @dashboard.user_devices_count) * 100
    @other_devices_percentage = (@dashboard.user_devices_os_data.find { |t| t['os_title'].nil? }['count'].to_f / @dashboard.user_devices_count) * 100

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
          td { number_to_human @dashboard.users_count }
          td { I18n.l(@dashboard.last_user_created_at) }
        end

        tr do
          td { 'Ads' }
          td { number_to_human @dashboard.ads_count }
          td { I18n.l(@dashboard.last_ad_created_at) }
        end

        tr do
          td { 'Messages' }
          td { number_to_human @dashboard.messages_count }
          td { I18n.l(@dashboard.last_message_created_at) }
        end

        tr do
          td { 'Chat Rooms' }
          td { number_to_human @dashboard.chat_rooms_count }
          td { I18n.l(@dashboard.last_chat_room_created_at) }
        end

        tr do
          td { 'Effective Ads / Active Ads' }
          td do
            div class: 'pb-wrapper' do
              div class: 'pb-progress-bar' do
                span class: 'pb-progress-bar-fill pb-first', style: "width: #{@effective_ads_percentage}%" do
                end
              end
              div class: 'pb-text' do
                span { "<b>#{number_to_human(@dashboard.effective_ads_count)}</b> / #{number_to_human(@dashboard.active_ads_count)}".html_safe }
                span style: "float: right" do
                  "#{@effective_ads_percentage}%"
                end
              end
            end
          end
          td { I18n.l(@dashboard.last_effective_ad_created_at) }
        end

        tr do
          td { 'Syncing Ads / Known Ads' }
          td do
            div class: 'pb-wrapper' do
              div class: 'pb-progress-bar' do
                span class: 'pb-progress-bar-fill pb-first', style: "width: #{@known_ads_percentage}%" do
                end
              end
              div class: 'pb-text' do
                span { "#{number_to_human(@dashboard.syncing_ads_count)} / <b>#{number_to_human(@dashboard.known_ads_count)}</b>".html_safe }
                span style: "float: right" do
                  "#{@known_ads_percentage}%"
                end
              end
            end
          end
        end

        tr do
          td { 'Unique User Contacts / User Contacts / Phone Numbers' }
          td do
            div class: 'pb-wrapper' do
              div class: 'pb-progress-bar' do
                span class: 'pb-progress-bar-fill pb-first', style: "width: #{@user_contacts_percentage}%" do
                end
              end
              div class: 'pb-text' do
                span { "#{number_to_human(@dashboard.uniq_user_contacts_count)} / #{number_to_human(@dashboard.user_contacts_count)} / #{number_to_human(@dashboard.phone_numbers_count)}" }
                span style: "float: right" do
                  "#{@user_contacts_percentage}%"
                end
              end
            end
          end
        end

        tr do
          td { 'User Devices OS' }
          td do
            div class: 'pb-wrapper' do
              div class: 'pb-progress-bar' do
                span class: 'pb-progress-bar-fill pb-first', style: "width: #{@ios_devices_percentage}%; background-color: teal" do
                end
                span class: 'pb-progress-bar-fill', style: "width: #{@android_devices_percentage}%; background-color: purple" do
                end
                span class: 'pb-progress-bar-fill pb-last', style: "width: #{@other_devices_percentage}%" do
                end
              end
              div class: 'pb-text' do
                span do
                  [
                    number_to_human(@dashboard.user_devices_os_data.find { |t| t['os_title'] == 'ios' }['count']),
                    number_to_human(@dashboard.user_devices_os_data.find { |t| t['os_title'] == 'android' }['count']),
                    number_to_human(@dashboard.user_devices_os_data.find { |t| t['os_title'].nil? }['count']),
                  ].join(' / ')
                end
                span style: "float: right" do
                  number_to_human @dashboard.user_devices_count
                end
              end
            end
          end
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

    panel 'MAU' do
      line_chart @dashboard.mau_chart_data.map { |x| ["#{x['date']}-01", x['count']] }
    end

    panel 'Уникальные пользователи' do
      line_chart chartify(@dashboard.user_activity_chart_data)
    end

    panel 'Приглашения' do
      line_chart chartify(@dashboard.invited_users_chart_data)
    end

    panel 'Просмотры объявлений' do
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
