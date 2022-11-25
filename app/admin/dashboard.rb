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
    @known_ads_percentage = ((@dashboard.known_ads_count.to_f / @dashboard.ads_count) * 100).round(2)
    @users_with_contacts_percentage = ((1 - (@dashboard.users_with_no_contacts_count / @dashboard.users_count.to_f)) * 100).round
    @users_with_connections_count = ((@dashboard.users_count - @dashboard.users_with_no_contacts_count) - @dashboard.users_with_no_connections_count)

    columns do
      column do
        panel 'MAU' do
          area_chart @dashboard.mau_chart_data.map { |x| ["#{x['date']}-01", x['count']] }
        end
        panel 'DAU' do
          area_chart chartify(@dashboard.user_activity_chart_data)
        end
        panel 'Daliy Visited Ads' do
          area_chart chartify(@dashboard.visited_ad_chart_data)
        end
      end

      column do
        columns do
          column do
            panel "Ads" do
              pie_chart({ "Known (#{@known_ads_percentage}%)" => @dashboard.known_ads_count, 'Unknown': @dashboard.ads_count - @dashboard.known_ads_count })
            end
          end

          column do
            panel "Active Ads" do
              pie_chart({ "Effective (#{@effective_ads_percentage}%)": @dashboard.effective_ads_count, 'Other': @dashboard.active_ads_count - @dashboard.effective_ads_count })
            end
          end
        end

        columns do
          column do
            panel "Users" do
              pie_chart({ "With contacts (#{@users_with_contacts_percentage}%)": @dashboard.users_count - @dashboard.users_with_no_contacts_count, 'Without contacts': @dashboard.users_with_no_contacts_count })
            end
          end

          column do
            panel "Users With Contacts" do
              pie_chart({ 'Have connections': @users_with_connections_count, 'No connections': @dashboard.users_with_no_connections_count })
            end
          end
        end

        columns do
          column do
            panel "Devices" do
              pie_chart @dashboard.user_devices_os_data.map { |x| { x['os_title'] => x['count'].to_i } }.inject(:merge)
            end
          end

          column do
            panel "User Contacts" do
              pie_chart({ 'Unique': @dashboard.uniq_user_contacts_count, 'Duplicate': @dashboard.user_contacts_count - @dashboard.uniq_user_contacts_count })
            end
          end
        end
      end
    end

    hr

    table do
      thead do
        tr do
          td "Updated At"
          td "Last User"
          td "Last Ad"
          td "Last Effective Ad"
          td "last Message"
          td "Last ChatRoom"
        end
      end
      tbody do
        tr do
          td { @dashboard.updated_at.strftime("%x %X") }
          td { "<b>#{I18n.l(@dashboard.last_user_created_at)}</b>".html_safe }
          td { I18n.l(@dashboard.last_ad_created_at) }
          td { I18n.l(@dashboard.last_effective_ad_created_at) }
          td { I18n.l(@dashboard.last_message_created_at) }
          td { I18n.l(@dashboard.last_chat_room_created_at) }
        end
      end
    end
  end
end
