# frozen_string_literal: true

ActiveAdmin.register(AdOptionValue) do
  menu priority: 6, label: proc { I18n.t('active_admin.ad_option_values') }
  actions :index, :show
  config.sort_order = 'value_desc'

  index do
    column :id
    column :value
    actions
  end

  show do
    attributes_table do
      row :id
      row :value
      row :active_ads do |ad_option_value|
        ad_option_value.ad_options.joins(:ad).distinct('ads.id').where(ads: { deleted: false }).pluck('ads.address').map { |url| link_to(url, url) }.join("<br>").html_safe
      end
      row :deleted_ads do
        ad_option_value.ad_options.joins(:ad).distinct('ads.id').where(ads: { deleted: true }).pluck('ads.address').map { |url| link_to(url, url) }.join("<br>").html_safe
      end
    end
  end

  # show do
  #   attributes_table do
  #     row :user do |chat_room|
  #       link_to((chat_room.user.name.presence || chat_room.user.id), admin_user_path(chat_room.user))
  #     end
  #     row :messages do |chat_room|
  #       chat_room.messages.includes(:user).order(:created_at).map do |m|
  #         "<b>#{m.user ? (m.user.name.presence || m.user.id) : 'System'}</b><br/>#{m.body}<small style='float: right'>(#{m.created_at.strftime("%b, %d — %X")})</small><hr/>"
  #       end.join("\n<br>").html_safe
  #     end
  #   end
  #   panel 'Reply' do
  #     semantic_form_for('system_message', url: system_message_admin_chat_room_path(chat_room)) do |f|
  #       f.inputs do
  #         f.input(:body, as: :text, input_html: { maxlength: 255, rows: 5 })
  #       end +
  #         f.actions do
  #           f.submit('Send')
  #         end
  #     end
  #   end
  #   active_admin_comments
  # end

  filter :of_type, as: :select, collection: -> { AdOptionType.pluck(:name) }
end
