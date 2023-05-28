class DashboardDataProducer
  include Sidekiq::Worker

  sidekiq_options queue: "default", retry: true, backtrace: false

  QUERY = <<~SQL
    SELECT now() AS updated_at,
        ( SELECT count(users.id) AS count
               FROM public.users) AS users_count,
        ( SELECT count(users.id) AS count
               FROM public.users
              WHERE (NOT (EXISTS ( SELECT 1
                       FROM public.user_contacts
                      WHERE (user_contacts.user_id = users.id))))) AS users_with_no_contacts_count,
        ( SELECT count(users.id) AS count
               FROM public.users
              WHERE (NOT (EXISTS ( SELECT 1
                       FROM public.user_connections
                      WHERE ((user_connections.user_id = users.id) AND (user_connections.friend_id <> users.id)))))) AS users_with_no_connections_count,
        ( SELECT count(users.id) AS count
               FROM public.users
              WHERE (users.referrer_id IS NOT NULL)) AS users_with_referrer_count,
        ( SELECT count(user_connections.id) AS count
               FROM public.user_connections) AS user_connections_count,
        ( SELECT count(user_devices.id) AS count
               FROM public.user_devices) AS user_devices_count,
        ( SELECT count(ads.id) AS count
               FROM public.ads) AS ads_count,
        ( SELECT count(DISTINCT ads.id) AS count
               FROM (public.ads
                 JOIN public.user_contacts ON ((ads.phone_number_id = user_contacts.phone_number_id)))
              WHERE (ads.deleted = false)) AS effective_ads_count,
        ( SELECT count(ads.id) AS count
               FROM public.ads
              WHERE (ads.deleted = false)) AS active_ads_count,
        ( SELECT count(messages.id) AS count
               FROM public.messages) AS messages_count,
        ( SELECT count(chat_rooms.id) AS count
               FROM public.chat_rooms) AS chat_rooms_count,
        ( SELECT count(phone_numbers.id) AS count
               FROM public.phone_numbers) AS phone_numbers_count,
        ( SELECT count(user_contacts.id) AS count
               FROM public.user_contacts) AS user_contacts_count,
        ( SELECT count(DISTINCT user_contacts.phone_number_id) AS count
               FROM public.user_contacts) AS uniq_user_contacts_count,
        ( SELECT count(ads.id) AS count
               FROM public.ads
              WHERE (ads.phone_number_id IN ( SELECT user_contacts.phone_number_id
                       FROM public.user_contacts))) AS known_ads_count,
        ( SELECT count(ads.id) AS count
               FROM public.ads
              WHERE ((ads.phone_number_id IN ( SELECT user_contacts.phone_number_id
                       FROM public.user_contacts)) AND (ads.updated_at < (now() - '24:00:00'::interval)))) AS syncing_ads_count,
        ( SELECT users.created_at
               FROM public.users
              ORDER BY users.id DESC
             LIMIT 1) AS last_user_created_at,
        ( SELECT ads.created_at
               FROM public.ads
              ORDER BY ads.id DESC
             LIMIT 1) AS last_ad_created_at,
        ( SELECT messages.created_at
               FROM public.messages
              ORDER BY messages.created_at DESC
             LIMIT 1) AS last_message_created_at,
        ( SELECT chat_rooms.created_at
               FROM public.chat_rooms
              ORDER BY chat_rooms.created_at DESC
             LIMIT 1) AS last_chat_room_created_at,
        ( SELECT ads.created_at
               FROM public.ads
              WHERE (ads.id = ( SELECT max(ads_1.id) AS max
                       FROM (public.ads ads_1
                         JOIN public.user_contacts ON ((ads_1.phone_number_id = user_contacts.phone_number_id)))
                      WHERE (ads_1.deleted = false)))
             LIMIT 1) AS last_effective_ad_created_at,
        ( SELECT user_devices.updated_at
               FROM (public.user_devices
                 JOIN public.users ON ((users.id = user_devices.user_id)))
              WHERE (users.id <> 1)
              ORDER BY user_devices.updated_at DESC
             LIMIT 1) AS last_user_device_updated_at,
        ( SELECT json_agg(t.*) AS json_agg
               FROM ( SELECT count(*) AS count,
                        date(events.created_at) AS date
                       FROM public.events
                      WHERE (((events.name)::text = 'invited_user'::text) AND (events.created_at > (now() - '1 mon'::interval)))
                      GROUP BY (date(events.created_at))
                      ORDER BY (date(events.created_at))) t) AS invited_users_chart_data,
        ( SELECT json_agg(t.*) AS json_agg
               FROM ( SELECT count(*) AS count,
                        date(events.created_at) AS date
                       FROM public.events
                      WHERE (((events.name)::text = 'visited_ad'::text) AND (events.created_at > (now() - '1 mon'::interval)))
                      GROUP BY (date(events.created_at))
                      ORDER BY (date(events.created_at))) t) AS visited_ad_chart_data,
        ( SELECT json_agg(t.*) AS json_agg
               FROM ( SELECT count(DISTINCT events.user_id) AS count,
                        date(events.created_at) AS date
                       FROM public.events
                      WHERE (((events.name)::text <> 'snapshot_user_visibility'::text) AND (events.created_at > (now() - '1 mon'::interval)))
                      GROUP BY (date(events.created_at))) t) AS user_activity_chart_data,
        ( SELECT json_agg(t.*) AS json_agg
               FROM ( SELECT count(*) AS count,
                        date(users.created_at) AS date
                       FROM public.users
                      WHERE (users.created_at > (now() - '1 mon'::interval))
                      GROUP BY (date(users.created_at))) t) AS user_registrations_chart_data,
        ( SELECT json_agg(t.*) AS json_agg
               FROM ( SELECT count(*) AS count,
                        date(messages.created_at) AS date
                       FROM (public.messages
                         JOIN public.chat_rooms ON ((chat_rooms.id = messages.chat_room_id)))
                      WHERE ((messages.created_at > (now() - '1 mon'::interval)) AND (chat_rooms.system = false))
                      GROUP BY (date(messages.created_at))) t) AS messages_chart_data,
        ( SELECT json_agg(t.*) AS json_agg
               FROM ( SELECT count(*) AS count,
                        user_devices.os AS os_title
                       FROM public.user_devices
                      GROUP BY user_devices.os) t) AS user_devices_os_data,
        ( SELECT json_agg(t.*) AS json_agg
               FROM ( SELECT count(*) AS count,
                       CONCAT(user_devices.os, ' ', build_version) AS build_code
                      FROM public.user_devices
                      GROUP BY user_devices.os, user_devices.build_version) t) AS user_devices_build_data,
        ( SELECT json_agg(t.*) AS json_agg
              FROM (#{CustomersAdsDistribution.new.call}) AS t) AS users_active_ads_distr_data,
        ( SELECT json_agg(t.*) AS json_agg
              FROM (#{CustomersAdsDistribution.new.call(active_ads_only: false)}) AS t) AS users_all_ads_distr_data,
        ( SELECT json_agg(t.*) AS json_agg
              FROM (#{CustomersAdsDistribution.new.call(active_ads_only: false, potential_customers_only: true)}) AS t) AS potential_users_ads_distr_data,
        ( SELECT json_agg(t.*) AS json_agg
              FROM (SELECT SUBSTR(full_number, 1, 2) AS operator, COUNT(*) FROM phone_numbers GROUP BY SUBSTR(full_number,1,2) ORDER BY COUNT(*)) AS t) AS cell_operators_distr_data,
        ( SELECT json_agg(tt.*) AS json_agg
               FROM ( SELECT users.refcode,
                        t.count
                       FROM (( SELECT users_1.referrer_id,
                                count(users_1.referrer_id) AS count
                               FROM public.users users_1
                              WHERE (users_1.referrer_id IS NOT NULL)
                              GROUP BY users_1.referrer_id
                             HAVING (count(users_1.referrer_id) > 5)
                              ORDER BY (count(users_1.referrer_id)) DESC) t
                         JOIN public.users ON ((users.id = t.referrer_id)))) tt) AS referrers_top,
        ( SELECT json_agg(t.*) AS json_agg
               FROM ( SELECT count(DISTINCT events.user_id) AS count,
                        to_char((date(events.created_at))::timestamp with time zone, 'YYYY-MM'::text) AS date
                       FROM public.events
                      WHERE (((events.name)::text <> 'snapshot_user_visibility'::text) AND (events.created_at > (now() - '6 mons'::interval)))
                      GROUP BY (to_char((date(events.created_at))::timestamp with time zone, 'YYYY-MM'::text))) t) AS mau_chart_data
  SQL

  def perform
    data = ActiveRecord::Base.connection.execute(QUERY).to_json
    etag = Digest::MD5.hexdigest(data.to_s)
    REDIS.set("dashboard_data", data)
    REDIS.set("dashboard_data.etag", etag)
  end
end
