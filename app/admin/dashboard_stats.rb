# frozen_string_literal: true
ActiveAdmin.register(DashboardStats) do
  menu priority: 4, label: proc { I18n.t('active_admin.dashboard_stats') }
  actions :index, :show

  index do
    actions
    column :updated_at
    column :users_count
    column :users_with_no_contacts_count
    column :users_with_no_connections_count
    column :users_with_referrer_count
    column :user_connections_count
    column :user_devices_count
    column :ads_count
    column :effective_ads_count
    column :active_ads_count
    column :messages_count
    column :chat_rooms_count
    column :phone_numbers_count
    column :user_contacts_count
    column :uniq_user_contacts_count
    column :known_ads_count
    column :syncing_ads_count
  end

  show do
    default_main_content
    panel "Redis" do
      rkeys = []

      REDIS_KEYS.each do |rkey|
        rkeys << panel(rkey) do
          semantic_form_for('rkey', url: update_redis_key_admin_dashboard_stat_path(1), method: :post) do |f|
            f.inputs do
              f.input(:key, as: :hidden, input_html: { value: rkey }, label: false) +
                f.input(:value, input_html: { value: REDIS.get(rkey) }, label: false)
            end +
              f.actions do
                f.submit('Update')
              end
          end
        end
      end

      rkeys.join.html_safe
    end
  end

  member_action :update_redis_key, method: :post do
    REDIS.set(params['rkey']['key'], params['rkey']['value'])
    redirect_to admin_dashboard_stats_path, notice: "Redis key <b>#{params['rkey']['key']}</b> updated successfully".html_safe
  end

  controller do
    def find_resource
      DashboardStats.first
    end
  end
end
