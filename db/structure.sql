SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: btree_gist; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS btree_gist WITH SCHEMA public;


--
-- Name: EXTENSION btree_gist; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION btree_gist IS 'support for indexing common datatypes in GiST';


--
-- Name: pg_trgm; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_trgm WITH SCHEMA public;


--
-- Name: EXTENSION pg_trgm; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pg_trgm IS 'text similarity measurement and index searching based on trigrams';


--
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;


--
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: active_admin_comments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.active_admin_comments (
    id bigint NOT NULL,
    namespace character varying,
    body text,
    resource_type character varying,
    resource_id bigint,
    author_type character varying,
    author_id bigint,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: active_admin_comments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.active_admin_comments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: active_admin_comments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.active_admin_comments_id_seq OWNED BY public.active_admin_comments.id;


--
-- Name: ad_descriptions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ad_descriptions (
    id integer NOT NULL,
    ad_id integer NOT NULL,
    body text,
    short character varying(200)
);


--
-- Name: ad_descriptions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.ad_descriptions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: ad_descriptions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.ad_descriptions_id_seq OWNED BY public.ad_descriptions.id;


--
-- Name: ad_extras; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ad_extras (
    id bigint NOT NULL,
    details jsonb DEFAULT '{}'::jsonb,
    ad_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: ad_extras_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.ad_extras_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: ad_extras_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.ad_extras_id_seq OWNED BY public.ad_extras.id;


--
-- Name: ad_favorites; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ad_favorites (
    id bigint NOT NULL,
    ad_id bigint NOT NULL,
    user_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: ad_favorites_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.ad_favorites_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: ad_favorites_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.ad_favorites_id_seq OWNED BY public.ad_favorites.id;


--
-- Name: ad_image_links_sets; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ad_image_links_sets (
    id integer NOT NULL,
    ad_id integer NOT NULL,
    value character varying[] DEFAULT '{}'::character varying[]
);


--
-- Name: ad_image_links_sets_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.ad_image_links_sets_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: ad_image_links_sets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.ad_image_links_sets_id_seq OWNED BY public.ad_image_links_sets.id;


--
-- Name: ad_option_types; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ad_option_types (
    id smallint NOT NULL,
    name character varying NOT NULL,
    category_id bigint
);


--
-- Name: ad_option_types_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.ad_option_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: ad_option_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.ad_option_types_id_seq OWNED BY public.ad_option_types.id;


--
-- Name: ad_prices; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ad_prices (
    id integer NOT NULL,
    ad_id integer NOT NULL,
    price integer NOT NULL,
    created_at timestamp without time zone NOT NULL
);


--
-- Name: ad_prices_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.ad_prices_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: ad_prices_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.ad_prices_id_seq OWNED BY public.ad_prices.id;


--
-- Name: ad_queries; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ad_queries (
    id bigint NOT NULL,
    title character varying,
    ad_id bigint,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: ad_queries_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.ad_queries_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: ad_queries_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.ad_queries_id_seq OWNED BY public.ad_queries.id;


--
-- Name: ad_visits; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ad_visits (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    ad_id bigint NOT NULL
);


--
-- Name: ad_visits_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.ad_visits_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: ad_visits_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.ad_visits_id_seq OWNED BY public.ad_visits.id;


--
-- Name: admin_users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.admin_users (
    id bigint NOT NULL,
    email character varying DEFAULT ''::character varying NOT NULL,
    encrypted_password character varying DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying,
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone
);


--
-- Name: admin_users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.admin_users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: admin_users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.admin_users_id_seq OWNED BY public.admin_users.id;


--
-- Name: ads; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ads (
    id integer NOT NULL,
    phone_number_id integer NOT NULL,
    ads_source_id smallint NOT NULL,
    price integer NOT NULL,
    deleted boolean DEFAULT false NOT NULL,
    address character varying NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    city_id smallint,
    category_id bigint
);


--
-- Name: ads_grouped_by_maker_model_year; Type: MATERIALIZED VIEW; Schema: public; Owner: -
--

CREATE MATERIALIZED VIEW public.ads_grouped_by_maker_model_year AS
 SELECT (ad_extras.details ->> 'maker'::text) AS maker,
    (ad_extras.details ->> 'model'::text) AS model,
    (ad_extras.details ->> 'year'::text) AS year,
    min(ads.price) AS min_price,
    (round((avg(ads.price) / (100)::numeric)) * (100)::numeric) AS avg_price,
    max(ads.price) AS max_price
   FROM (public.ads
     JOIN public.ad_extras ON ((ads.id = ad_extras.ad_id)))
  WHERE (ads.deleted = false)
  GROUP BY (ad_extras.details ->> 'maker'::text), (ad_extras.details ->> 'model'::text), (ad_extras.details ->> 'year'::text)
 HAVING (count(ads.*) >= 5)
  ORDER BY (ad_extras.details ->> 'maker'::text), (ad_extras.details ->> 'model'::text), (ad_extras.details ->> 'year'::text)
  WITH NO DATA;


--
-- Name: ads_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.ads_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: ads_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.ads_id_seq OWNED BY public.ads.id;


--
-- Name: ads_sources; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ads_sources (
    id bigint NOT NULL,
    title character varying NOT NULL,
    api_token character varying NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    native boolean DEFAULT false
);


--
-- Name: ads_sources_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.ads_sources_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: ads_sources_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.ads_sources_id_seq OWNED BY public.ads_sources.id;


--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: categories; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.categories (
    id bigint NOT NULL,
    name character varying NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: categories_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.categories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.categories_id_seq OWNED BY public.categories.id;


--
-- Name: chat_room_users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.chat_room_users (
    id bigint NOT NULL,
    chat_room_id bigint NOT NULL,
    user_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    name character varying NOT NULL
);


--
-- Name: chat_room_users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.chat_room_users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: chat_room_users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.chat_room_users_id_seq OWNED BY public.chat_room_users.id;


--
-- Name: chat_rooms; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.chat_rooms (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    ad_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    system boolean DEFAULT false NOT NULL
);


--
-- Name: chat_rooms_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.chat_rooms_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: chat_rooms_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.chat_rooms_id_seq OWNED BY public.chat_rooms.id;


--
-- Name: cities; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.cities (
    id bigint NOT NULL,
    name character varying(255) NOT NULL,
    region_id bigint,
    translations jsonb DEFAULT '{}'::jsonb
);


--
-- Name: cities_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.cities_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: cities_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.cities_id_seq OWNED BY public.cities.id;


--
-- Name: events; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.events (
    id bigint NOT NULL,
    name character varying,
    user_id bigint,
    data jsonb,
    created_at timestamp without time zone NOT NULL
);


--
-- Name: messages; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.messages (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    body character varying NOT NULL,
    system boolean DEFAULT false NOT NULL,
    user_id bigint,
    chat_room_id bigint NOT NULL,
    created_at timestamp without time zone NOT NULL,
    extra jsonb
);


--
-- Name: phone_numbers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.phone_numbers (
    id integer NOT NULL,
    full_number character varying(9) NOT NULL
);


--
-- Name: user_connections; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.user_connections (
    id bigint NOT NULL,
    user_id integer NOT NULL,
    friend_id integer NOT NULL,
    connection_id integer NOT NULL,
    hops_count smallint
);


--
-- Name: user_contacts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.user_contacts (
    id integer NOT NULL,
    user_id integer NOT NULL,
    phone_number_id integer NOT NULL,
    name character varying(100) NOT NULL
);


--
-- Name: user_devices; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.user_devices (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    device_id character varying NOT NULL,
    access_token character varying NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    os character varying,
    push_token character varying,
    build_version character varying,
    session_started_at timestamp without time zone,
    locale character varying
);


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id bigint NOT NULL,
    phone_number_id bigint NOT NULL,
    name character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    avatar json,
    referrer_id integer,
    refcode character varying
);


--
-- Name: dashboard_stats; Type: MATERIALIZED VIEW; Schema: public; Owner: -
--

CREATE MATERIALIZED VIEW public.dashboard_stats AS
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
  WITH NO DATA;


--
-- Name: demo_phone_numbers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.demo_phone_numbers (
    id bigint NOT NULL,
    phone_number_id bigint NOT NULL,
    demo_code integer
);


--
-- Name: demo_phone_numbers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.demo_phone_numbers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: demo_phone_numbers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.demo_phone_numbers_id_seq OWNED BY public.demo_phone_numbers.id;


--
-- Name: events_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.events_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: events_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.events_id_seq OWNED BY public.events.id;


--
-- Name: filterable_values; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.filterable_values (
    id bigint NOT NULL,
    ad_option_type_id bigint,
    name character varying NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    raw_value character varying
);


--
-- Name: filterable_values_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.filterable_values_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: filterable_values_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.filterable_values_id_seq OWNED BY public.filterable_values.id;


--
-- Name: phone_numbers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.phone_numbers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: phone_numbers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.phone_numbers_id_seq OWNED BY public.phone_numbers.id;


--
-- Name: regions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.regions (
    id bigint NOT NULL,
    name character varying(255) NOT NULL,
    translations jsonb DEFAULT '{}'::jsonb
);


--
-- Name: regions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.regions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: regions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.regions_id_seq OWNED BY public.regions.id;


--
-- Name: rpush_apps; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.rpush_apps (
    id bigint NOT NULL,
    name character varying NOT NULL,
    environment character varying,
    certificate text,
    password character varying,
    connections integer DEFAULT 1 NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    type character varying NOT NULL,
    auth_key character varying,
    client_id character varying,
    client_secret character varying,
    access_token character varying,
    access_token_expiration timestamp(6) without time zone,
    apn_key text,
    apn_key_id character varying,
    team_id character varying,
    bundle_id character varying,
    feedback_enabled boolean DEFAULT true
);


--
-- Name: rpush_apps_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.rpush_apps_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: rpush_apps_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.rpush_apps_id_seq OWNED BY public.rpush_apps.id;


--
-- Name: rpush_feedback; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.rpush_feedback (
    id bigint NOT NULL,
    device_token character varying,
    failed_at timestamp without time zone NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    app_id integer
);


--
-- Name: rpush_feedback_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.rpush_feedback_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: rpush_feedback_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.rpush_feedback_id_seq OWNED BY public.rpush_feedback.id;


--
-- Name: rpush_notifications; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.rpush_notifications (
    id bigint NOT NULL,
    badge integer,
    device_token character varying,
    sound character varying,
    alert text,
    data text,
    expiry integer DEFAULT 86400,
    delivered boolean DEFAULT false NOT NULL,
    delivered_at timestamp without time zone,
    failed boolean DEFAULT false NOT NULL,
    failed_at timestamp without time zone,
    error_code integer,
    error_description text,
    deliver_after timestamp without time zone,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    alert_is_json boolean DEFAULT false NOT NULL,
    type character varying NOT NULL,
    collapse_key character varying,
    delay_while_idle boolean DEFAULT false NOT NULL,
    registration_ids text,
    app_id integer NOT NULL,
    retries integer DEFAULT 0,
    uri character varying,
    fail_after timestamp without time zone,
    processing boolean DEFAULT false NOT NULL,
    priority integer,
    url_args text,
    category character varying,
    content_available boolean DEFAULT false NOT NULL,
    notification text,
    mutable_content boolean DEFAULT false NOT NULL,
    external_device_id character varying,
    thread_id character varying,
    dry_run boolean DEFAULT false NOT NULL,
    sound_is_json boolean DEFAULT false
);


--
-- Name: rpush_notifications_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.rpush_notifications_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: rpush_notifications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.rpush_notifications_id_seq OWNED BY public.rpush_notifications.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


--
-- Name: static_pages; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.static_pages (
    id bigint NOT NULL,
    title character varying NOT NULL,
    slug character varying NOT NULL,
    body text,
    meta jsonb,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: static_pages_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.static_pages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: static_pages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.static_pages_id_seq OWNED BY public.static_pages.id;


--
-- Name: system_stats; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.system_stats (
    id bigint NOT NULL,
    data jsonb
);


--
-- Name: system_stats_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.system_stats_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: system_stats_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.system_stats_id_seq OWNED BY public.system_stats.id;


--
-- Name: user_blocked_phone_numbers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.user_blocked_phone_numbers (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    phone_number_id bigint NOT NULL
);


--
-- Name: user_blocked_phone_numbers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.user_blocked_phone_numbers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: user_blocked_phone_numbers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.user_blocked_phone_numbers_id_seq OWNED BY public.user_blocked_phone_numbers.id;


--
-- Name: user_connections_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.user_connections_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: user_connections_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.user_connections_id_seq OWNED BY public.user_connections.id;


--
-- Name: user_contacts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.user_contacts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: user_contacts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.user_contacts_id_seq OWNED BY public.user_contacts.id;


--
-- Name: user_devices_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.user_devices_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: user_devices_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.user_devices_id_seq OWNED BY public.user_devices.id;


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: verification_requests; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.verification_requests (
    id bigint NOT NULL,
    phone_number_id bigint NOT NULL,
    verification_code integer NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: verification_requests_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.verification_requests_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: verification_requests_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.verification_requests_id_seq OWNED BY public.verification_requests.id;


--
-- Name: active_admin_comments id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_admin_comments ALTER COLUMN id SET DEFAULT nextval('public.active_admin_comments_id_seq'::regclass);


--
-- Name: ad_descriptions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ad_descriptions ALTER COLUMN id SET DEFAULT nextval('public.ad_descriptions_id_seq'::regclass);


--
-- Name: ad_extras id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ad_extras ALTER COLUMN id SET DEFAULT nextval('public.ad_extras_id_seq'::regclass);


--
-- Name: ad_favorites id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ad_favorites ALTER COLUMN id SET DEFAULT nextval('public.ad_favorites_id_seq'::regclass);


--
-- Name: ad_image_links_sets id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ad_image_links_sets ALTER COLUMN id SET DEFAULT nextval('public.ad_image_links_sets_id_seq'::regclass);


--
-- Name: ad_option_types id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ad_option_types ALTER COLUMN id SET DEFAULT nextval('public.ad_option_types_id_seq'::regclass);


--
-- Name: ad_prices id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ad_prices ALTER COLUMN id SET DEFAULT nextval('public.ad_prices_id_seq'::regclass);


--
-- Name: ad_queries id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ad_queries ALTER COLUMN id SET DEFAULT nextval('public.ad_queries_id_seq'::regclass);


--
-- Name: ad_visits id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ad_visits ALTER COLUMN id SET DEFAULT nextval('public.ad_visits_id_seq'::regclass);


--
-- Name: admin_users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.admin_users ALTER COLUMN id SET DEFAULT nextval('public.admin_users_id_seq'::regclass);


--
-- Name: ads id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ads ALTER COLUMN id SET DEFAULT nextval('public.ads_id_seq'::regclass);


--
-- Name: ads_sources id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ads_sources ALTER COLUMN id SET DEFAULT nextval('public.ads_sources_id_seq'::regclass);


--
-- Name: categories id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.categories ALTER COLUMN id SET DEFAULT nextval('public.categories_id_seq'::regclass);


--
-- Name: chat_room_users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chat_room_users ALTER COLUMN id SET DEFAULT nextval('public.chat_room_users_id_seq'::regclass);


--
-- Name: chat_rooms id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chat_rooms ALTER COLUMN id SET DEFAULT nextval('public.chat_rooms_id_seq'::regclass);


--
-- Name: cities id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cities ALTER COLUMN id SET DEFAULT nextval('public.cities_id_seq'::regclass);


--
-- Name: demo_phone_numbers id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.demo_phone_numbers ALTER COLUMN id SET DEFAULT nextval('public.demo_phone_numbers_id_seq'::regclass);


--
-- Name: events id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.events ALTER COLUMN id SET DEFAULT nextval('public.events_id_seq'::regclass);


--
-- Name: filterable_values id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.filterable_values ALTER COLUMN id SET DEFAULT nextval('public.filterable_values_id_seq'::regclass);


--
-- Name: phone_numbers id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.phone_numbers ALTER COLUMN id SET DEFAULT nextval('public.phone_numbers_id_seq'::regclass);


--
-- Name: regions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.regions ALTER COLUMN id SET DEFAULT nextval('public.regions_id_seq'::regclass);


--
-- Name: rpush_apps id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.rpush_apps ALTER COLUMN id SET DEFAULT nextval('public.rpush_apps_id_seq'::regclass);


--
-- Name: rpush_feedback id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.rpush_feedback ALTER COLUMN id SET DEFAULT nextval('public.rpush_feedback_id_seq'::regclass);


--
-- Name: rpush_notifications id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.rpush_notifications ALTER COLUMN id SET DEFAULT nextval('public.rpush_notifications_id_seq'::regclass);


--
-- Name: static_pages id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.static_pages ALTER COLUMN id SET DEFAULT nextval('public.static_pages_id_seq'::regclass);


--
-- Name: system_stats id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.system_stats ALTER COLUMN id SET DEFAULT nextval('public.system_stats_id_seq'::regclass);


--
-- Name: user_blocked_phone_numbers id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_blocked_phone_numbers ALTER COLUMN id SET DEFAULT nextval('public.user_blocked_phone_numbers_id_seq'::regclass);


--
-- Name: user_connections id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_connections ALTER COLUMN id SET DEFAULT nextval('public.user_connections_id_seq'::regclass);


--
-- Name: user_contacts id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_contacts ALTER COLUMN id SET DEFAULT nextval('public.user_contacts_id_seq'::regclass);


--
-- Name: user_devices id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_devices ALTER COLUMN id SET DEFAULT nextval('public.user_devices_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: verification_requests id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.verification_requests ALTER COLUMN id SET DEFAULT nextval('public.verification_requests_id_seq'::regclass);


--
-- Name: active_admin_comments active_admin_comments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_admin_comments
    ADD CONSTRAINT active_admin_comments_pkey PRIMARY KEY (id);


--
-- Name: ad_descriptions ad_descriptions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ad_descriptions
    ADD CONSTRAINT ad_descriptions_pkey PRIMARY KEY (id);


--
-- Name: ad_extras ad_extras_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ad_extras
    ADD CONSTRAINT ad_extras_pkey PRIMARY KEY (id);


--
-- Name: ad_favorites ad_favorites_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ad_favorites
    ADD CONSTRAINT ad_favorites_pkey PRIMARY KEY (id);


--
-- Name: ad_image_links_sets ad_image_links_sets_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ad_image_links_sets
    ADD CONSTRAINT ad_image_links_sets_pkey PRIMARY KEY (id);


--
-- Name: ad_option_types ad_option_types_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ad_option_types
    ADD CONSTRAINT ad_option_types_pkey PRIMARY KEY (id);


--
-- Name: ad_prices ad_prices_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ad_prices
    ADD CONSTRAINT ad_prices_pkey PRIMARY KEY (id);


--
-- Name: ad_queries ad_queries_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ad_queries
    ADD CONSTRAINT ad_queries_pkey PRIMARY KEY (id);


--
-- Name: ad_visits ad_visits_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ad_visits
    ADD CONSTRAINT ad_visits_pkey PRIMARY KEY (id);


--
-- Name: admin_users admin_users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.admin_users
    ADD CONSTRAINT admin_users_pkey PRIMARY KEY (id);


--
-- Name: ads ads_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ads
    ADD CONSTRAINT ads_pkey PRIMARY KEY (id);


--
-- Name: ads_sources ads_sources_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ads_sources
    ADD CONSTRAINT ads_sources_pkey PRIMARY KEY (id);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: categories categories_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_pkey PRIMARY KEY (id);


--
-- Name: chat_room_users chat_room_users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chat_room_users
    ADD CONSTRAINT chat_room_users_pkey PRIMARY KEY (id);


--
-- Name: chat_rooms chat_rooms_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chat_rooms
    ADD CONSTRAINT chat_rooms_pkey PRIMARY KEY (id);


--
-- Name: cities cities_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cities
    ADD CONSTRAINT cities_pkey PRIMARY KEY (id);


--
-- Name: demo_phone_numbers demo_phone_numbers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.demo_phone_numbers
    ADD CONSTRAINT demo_phone_numbers_pkey PRIMARY KEY (id);


--
-- Name: events events_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.events
    ADD CONSTRAINT events_pkey PRIMARY KEY (id);


--
-- Name: filterable_values filterable_values_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.filterable_values
    ADD CONSTRAINT filterable_values_pkey PRIMARY KEY (id);


--
-- Name: messages messages_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.messages
    ADD CONSTRAINT messages_pkey PRIMARY KEY (id);


--
-- Name: phone_numbers phone_numbers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.phone_numbers
    ADD CONSTRAINT phone_numbers_pkey PRIMARY KEY (id);

ALTER TABLE public.phone_numbers CLUSTER ON phone_numbers_pkey;


--
-- Name: regions regions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.regions
    ADD CONSTRAINT regions_pkey PRIMARY KEY (id);


--
-- Name: rpush_apps rpush_apps_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.rpush_apps
    ADD CONSTRAINT rpush_apps_pkey PRIMARY KEY (id);


--
-- Name: rpush_feedback rpush_feedback_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.rpush_feedback
    ADD CONSTRAINT rpush_feedback_pkey PRIMARY KEY (id);


--
-- Name: rpush_notifications rpush_notifications_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.rpush_notifications
    ADD CONSTRAINT rpush_notifications_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: static_pages static_pages_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.static_pages
    ADD CONSTRAINT static_pages_pkey PRIMARY KEY (id);


--
-- Name: system_stats system_stats_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.system_stats
    ADD CONSTRAINT system_stats_pkey PRIMARY KEY (id);


--
-- Name: user_blocked_phone_numbers user_blocked_phone_numbers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_blocked_phone_numbers
    ADD CONSTRAINT user_blocked_phone_numbers_pkey PRIMARY KEY (id);


--
-- Name: user_connections user_connections_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_connections
    ADD CONSTRAINT user_connections_pkey PRIMARY KEY (id);


--
-- Name: user_contacts user_contacts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_contacts
    ADD CONSTRAINT user_contacts_pkey PRIMARY KEY (id);


--
-- Name: user_devices user_devices_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_devices
    ADD CONSTRAINT user_devices_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: verification_requests verification_requests_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.verification_requests
    ADD CONSTRAINT verification_requests_pkey PRIMARY KEY (id);


--
-- Name: index_active_admin_comments_on_author_type_and_author_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_active_admin_comments_on_author_type_and_author_id ON public.active_admin_comments USING btree (author_type, author_id);


--
-- Name: index_active_admin_comments_on_namespace; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_active_admin_comments_on_namespace ON public.active_admin_comments USING btree (namespace);


--
-- Name: index_active_admin_comments_on_resource_type_and_resource_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_active_admin_comments_on_resource_type_and_resource_id ON public.active_admin_comments USING btree (resource_type, resource_id);


--
-- Name: index_ad_descriptions_on_ad_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_ad_descriptions_on_ad_id ON public.ad_descriptions USING btree (ad_id);


--
-- Name: index_ad_extras_on_ad_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_ad_extras_on_ad_id ON public.ad_extras USING btree (ad_id);

ALTER TABLE public.ad_extras CLUSTER ON index_ad_extras_on_ad_id;


--
-- Name: index_ad_extras_on_details; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_ad_extras_on_details ON public.ad_extras USING gin (details);


--
-- Name: index_ad_favorites_on_ad_id_and_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_ad_favorites_on_ad_id_and_user_id ON public.ad_favorites USING btree (ad_id, user_id);

ALTER TABLE public.ad_favorites CLUSTER ON index_ad_favorites_on_ad_id_and_user_id;


--
-- Name: index_ad_favorites_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_ad_favorites_on_user_id ON public.ad_favorites USING btree (user_id);


--
-- Name: index_ad_image_links_sets_on_ad_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_ad_image_links_sets_on_ad_id ON public.ad_image_links_sets USING btree (ad_id);


--
-- Name: index_ad_option_types_on_category_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_ad_option_types_on_category_id ON public.ad_option_types USING btree (category_id);


--
-- Name: index_ad_option_types_on_name_and_category_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_ad_option_types_on_name_and_category_id ON public.ad_option_types USING btree (name, category_id);


--
-- Name: index_ad_prices_on_ad_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_ad_prices_on_ad_id ON public.ad_prices USING btree (ad_id);

ALTER TABLE public.ad_prices CLUSTER ON index_ad_prices_on_ad_id;


--
-- Name: index_ad_queries_on_ad_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_ad_queries_on_ad_id ON public.ad_queries USING btree (ad_id);

ALTER TABLE public.ad_queries CLUSTER ON index_ad_queries_on_ad_id;


--
-- Name: index_ad_queries_on_title; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_ad_queries_on_title ON public.ad_queries USING gin (title public.gin_trgm_ops);


--
-- Name: index_ad_visits_on_ad_id_and_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_ad_visits_on_ad_id_and_user_id ON public.ad_visits USING btree (ad_id, user_id);

ALTER TABLE public.ad_visits CLUSTER ON index_ad_visits_on_ad_id_and_user_id;


--
-- Name: index_ad_visits_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_ad_visits_on_user_id ON public.ad_visits USING btree (user_id);


--
-- Name: index_admin_users_on_email; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_admin_users_on_email ON public.admin_users USING btree (email);


--
-- Name: index_admin_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_admin_users_on_reset_password_token ON public.admin_users USING btree (reset_password_token);


--
-- Name: index_ads_on_address; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_ads_on_address ON public.ads USING btree (address);


--
-- Name: index_ads_on_category_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_ads_on_category_id ON public.ads USING btree (category_id);


--
-- Name: index_ads_on_id_and_price; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_ads_on_id_and_price ON public.ads USING btree (id DESC, price) WHERE (deleted = false);


--
-- Name: index_ads_on_phone_number_id_and_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_ads_on_phone_number_id_and_id ON public.ads USING btree (phone_number_id, id);

ALTER TABLE public.ads CLUSTER ON index_ads_on_phone_number_id_and_id;


--
-- Name: index_ads_on_phone_number_id_where_deleted_false_include_price; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_ads_on_phone_number_id_where_deleted_false_include_price ON public.ads USING btree (phone_number_id, id) INCLUDE (price) WHERE (deleted = false);


--
-- Name: index_ads_sources_on_api_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_ads_sources_on_api_token ON public.ads_sources USING btree (api_token);


--
-- Name: index_ads_sources_on_title; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_ads_sources_on_title ON public.ads_sources USING btree (title);


--
-- Name: index_categories_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_categories_on_name ON public.categories USING btree (name);


--
-- Name: index_chat_room_users_on_chat_room_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_chat_room_users_on_chat_room_id ON public.chat_room_users USING btree (chat_room_id);


--
-- Name: index_chat_room_users_on_chat_room_id_and_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_chat_room_users_on_chat_room_id_and_user_id ON public.chat_room_users USING btree (chat_room_id, user_id);


--
-- Name: index_chat_room_users_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_chat_room_users_on_user_id ON public.chat_room_users USING btree (user_id);


--
-- Name: index_chat_rooms_on_ad_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_chat_rooms_on_ad_id ON public.chat_rooms USING btree (ad_id);


--
-- Name: index_chat_rooms_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_chat_rooms_on_user_id ON public.chat_rooms USING btree (user_id);


--
-- Name: index_cities_on_name_and_region_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_cities_on_name_and_region_id ON public.cities USING btree (name, region_id);


--
-- Name: index_cities_on_region_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_cities_on_region_id ON public.cities USING btree (region_id);


--
-- Name: index_dashboard_stats_on_updated_at; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_dashboard_stats_on_updated_at ON public.dashboard_stats USING btree (updated_at);


--
-- Name: index_demo_phone_numbers_on_phone_number_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_demo_phone_numbers_on_phone_number_id ON public.demo_phone_numbers USING btree (phone_number_id);


--
-- Name: index_events_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_events_on_user_id ON public.events USING btree (user_id);


--
-- Name: index_events_on_user_id_and_created_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_events_on_user_id_and_created_at ON public.events USING btree (user_id, created_at) WHERE ((name)::text = 'snapshot_user_visibility'::text);


--
-- Name: index_filterable_values_on_ad_option_type_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_filterable_values_on_ad_option_type_id ON public.filterable_values USING btree (ad_option_type_id);


--
-- Name: index_messages_on_chat_room_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_messages_on_chat_room_id ON public.messages USING btree (chat_room_id);


--
-- Name: index_messages_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_messages_on_user_id ON public.messages USING btree (user_id);


--
-- Name: index_on_chat_rooms_user_id_where_system_true; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_on_chat_rooms_user_id_where_system_true ON public.chat_rooms USING btree (user_id) WHERE (system = true);


--
-- Name: index_phone_numbers_on_full_number; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_phone_numbers_on_full_number ON public.phone_numbers USING btree (full_number);


--
-- Name: index_rpush_feedback_on_device_token; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_rpush_feedback_on_device_token ON public.rpush_feedback USING btree (device_token);


--
-- Name: index_rpush_notifications_multi; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_rpush_notifications_multi ON public.rpush_notifications USING btree (delivered, failed, processing, deliver_after, created_at) WHERE ((NOT delivered) AND (NOT failed));


--
-- Name: index_static_pages_on_slug; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_static_pages_on_slug ON public.static_pages USING btree (slug);


--
-- Name: index_user_blocked_phone_numbers_on_user_id_and_phone_number_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_user_blocked_phone_numbers_on_user_id_and_phone_number_id ON public.user_blocked_phone_numbers USING btree (user_id, phone_number_id);


--
-- Name: index_user_connections_for_feed; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_user_connections_for_feed ON public.user_connections USING btree (user_id, connection_id, hops_count);

ALTER TABLE public.user_connections CLUSTER ON index_user_connections_for_feed;


--
-- Name: index_user_connections_on_uniq; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_user_connections_on_uniq ON public.user_connections USING btree (user_id, connection_id, friend_id);


--
-- Name: index_user_contacts_on_phone_number_id_and_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_user_contacts_on_phone_number_id_and_user_id ON public.user_contacts USING btree (phone_number_id, user_id);


--
-- Name: index_user_contacts_on_phone_number_id_and_user_id_include_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_user_contacts_on_phone_number_id_and_user_id_include_name ON public.user_contacts USING btree (phone_number_id, user_id) INCLUDE (name);


--
-- Name: index_user_contacts_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_user_contacts_on_user_id ON public.user_contacts USING btree (user_id);


--
-- Name: index_user_contacts_on_user_id_and_phone_number_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_user_contacts_on_user_id_and_phone_number_id ON public.user_contacts USING btree (user_id, phone_number_id);

ALTER TABLE public.user_contacts CLUSTER ON index_user_contacts_on_user_id_and_phone_number_id;


--
-- Name: index_user_devices_on_access_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_user_devices_on_access_token ON public.user_devices USING btree (access_token);


--
-- Name: index_user_devices_on_device_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_user_devices_on_device_id ON public.user_devices USING btree (device_id);


--
-- Name: index_user_devices_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_user_devices_on_user_id ON public.user_devices USING btree (user_id);


--
-- Name: index_users_on_phone_number_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_phone_number_id ON public.users USING btree (phone_number_id);


--
-- Name: index_users_on_phone_number_id_and_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_phone_number_id_and_id ON public.users USING btree (phone_number_id, id);

ALTER TABLE public.users CLUSTER ON index_users_on_phone_number_id_and_id;


--
-- Name: index_users_on_refcode; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_refcode ON public.users USING btree (refcode);


--
-- Name: index_users_on_referrer_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_users_on_referrer_id ON public.users USING btree (referrer_id);


--
-- Name: index_verification_requests_on_phone_number_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_verification_requests_on_phone_number_id ON public.verification_requests USING btree (phone_number_id);


--
-- Name: search_budget_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX search_budget_index ON public.ads_grouped_by_maker_model_year USING btree (min_price, max_price);


--
-- Name: uniq_set_referrer_index; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX uniq_set_referrer_index ON public.events USING btree (user_id) WHERE ((name)::text = 'set_referrer'::text);


--
-- Name: uniq_sign_up_index; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX uniq_sign_up_index ON public.events USING btree (user_id) WHERE ((name)::text = 'sign_up'::text);


--
-- Name: stats_for_user_connections_connections; Type: STATISTICS; Schema: public; Owner: -
--

CREATE STATISTICS public.stats_for_user_connections_connections (dependencies) ON user_id, connection_id FROM public.user_connections;


--
-- Name: stats_for_user_connections_friends; Type: STATISTICS; Schema: public; Owner: -
--

CREATE STATISTICS public.stats_for_user_connections_friends (dependencies) ON user_id, friend_id FROM public.user_connections;


--
-- Name: stats_for_user_contacts; Type: STATISTICS; Schema: public; Owner: -
--

CREATE STATISTICS public.stats_for_user_contacts (dependencies) ON user_id, phone_number_id FROM public.user_contacts;


--
-- Name: messages fk_rails_00aac238e8; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.messages
    ADD CONSTRAINT fk_rails_00aac238e8 FOREIGN KEY (chat_room_id) REFERENCES public.chat_rooms(id) ON DELETE CASCADE;


--
-- Name: users fk_rails_0af1806ed1; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT fk_rails_0af1806ed1 FOREIGN KEY (phone_number_id) REFERENCES public.phone_numbers(id) ON DELETE CASCADE;


--
-- Name: ads fk_rails_1957b7156c; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ads
    ADD CONSTRAINT fk_rails_1957b7156c FOREIGN KEY (ads_source_id) REFERENCES public.ads_sources(id) ON DELETE CASCADE;


--
-- Name: messages fk_rails_273a25a7a6; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.messages
    ADD CONSTRAINT fk_rails_273a25a7a6 FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: chat_room_users fk_rails_28e7f29a4f; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chat_room_users
    ADD CONSTRAINT fk_rails_28e7f29a4f FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: user_connections fk_rails_2a83c769c5; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_connections
    ADD CONSTRAINT fk_rails_2a83c769c5 FOREIGN KEY (friend_id) REFERENCES public.users(id);


--
-- Name: ad_favorites fk_rails_433c6ffc89; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ad_favorites
    ADD CONSTRAINT fk_rails_433c6ffc89 FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: ad_descriptions fk_rails_55111271fa; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ad_descriptions
    ADD CONSTRAINT fk_rails_55111271fa FOREIGN KEY (ad_id) REFERENCES public.ads(id) ON DELETE CASCADE;


--
-- Name: user_blocked_phone_numbers fk_rails_62c5663e3d; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_blocked_phone_numbers
    ADD CONSTRAINT fk_rails_62c5663e3d FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: ad_image_links_sets fk_rails_73a21eede7; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ad_image_links_sets
    ADD CONSTRAINT fk_rails_73a21eede7 FOREIGN KEY (ad_id) REFERENCES public.ads(id) ON DELETE CASCADE;


--
-- Name: users fk_rails_92c9bd2db4; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT fk_rails_92c9bd2db4 FOREIGN KEY (referrer_id) REFERENCES public.users(id) ON DELETE RESTRICT;


--
-- Name: verification_requests fk_rails_98c15d8b5e; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.verification_requests
    ADD CONSTRAINT fk_rails_98c15d8b5e FOREIGN KEY (phone_number_id) REFERENCES public.phone_numbers(id) ON DELETE CASCADE;


--
-- Name: ads fk_rails_b1934989b5; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ads
    ADD CONSTRAINT fk_rails_b1934989b5 FOREIGN KEY (category_id) REFERENCES public.categories(id);


--
-- Name: user_connections fk_rails_b58ad388f7; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_connections
    ADD CONSTRAINT fk_rails_b58ad388f7 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: chat_room_users fk_rails_bc998301ae; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chat_room_users
    ADD CONSTRAINT fk_rails_bc998301ae FOREIGN KEY (chat_room_id) REFERENCES public.chat_rooms(id) ON DELETE CASCADE;


--
-- Name: ad_favorites fk_rails_bd23ea336e; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ad_favorites
    ADD CONSTRAINT fk_rails_bd23ea336e FOREIGN KEY (ad_id) REFERENCES public.ads(id) ON DELETE CASCADE;


--
-- Name: ad_visits fk_rails_bdda06f5d6; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ad_visits
    ADD CONSTRAINT fk_rails_bdda06f5d6 FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: user_contacts fk_rails_be7bbd25f6; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_contacts
    ADD CONSTRAINT fk_rails_be7bbd25f6 FOREIGN KEY (phone_number_id) REFERENCES public.phone_numbers(id) ON DELETE CASCADE;


--
-- Name: chat_rooms fk_rails_c4bd9c10f3; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chat_rooms
    ADD CONSTRAINT fk_rails_c4bd9c10f3 FOREIGN KEY (ad_id) REFERENCES public.ads(id) ON DELETE CASCADE;


--
-- Name: demo_phone_numbers fk_rails_c6152da324; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.demo_phone_numbers
    ADD CONSTRAINT fk_rails_c6152da324 FOREIGN KEY (phone_number_id) REFERENCES public.phone_numbers(id) ON DELETE CASCADE;


--
-- Name: ad_prices fk_rails_cd4c7aebef; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ad_prices
    ADD CONSTRAINT fk_rails_cd4c7aebef FOREIGN KEY (ad_id) REFERENCES public.ads(id) ON DELETE CASCADE;


--
-- Name: user_contacts fk_rails_cfeb7cc2a1; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_contacts
    ADD CONSTRAINT fk_rails_cfeb7cc2a1 FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: ad_visits fk_rails_d152f844d2; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ad_visits
    ADD CONSTRAINT fk_rails_d152f844d2 FOREIGN KEY (ad_id) REFERENCES public.ads(id) ON DELETE CASCADE;


--
-- Name: user_connections fk_rails_dedc44dde8; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_connections
    ADD CONSTRAINT fk_rails_dedc44dde8 FOREIGN KEY (connection_id) REFERENCES public.users(id);


--
-- Name: ad_option_types fk_rails_e086518ddb; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ad_option_types
    ADD CONSTRAINT fk_rails_e086518ddb FOREIGN KEY (category_id) REFERENCES public.categories(id);


--
-- Name: cities fk_rails_e0ef2914ca; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cities
    ADD CONSTRAINT fk_rails_e0ef2914ca FOREIGN KEY (region_id) REFERENCES public.regions(id) ON DELETE CASCADE;


--
-- Name: user_devices fk_rails_e700a96826; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_devices
    ADD CONSTRAINT fk_rails_e700a96826 FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: user_blocked_phone_numbers fk_rails_e9928cde2e; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_blocked_phone_numbers
    ADD CONSTRAINT fk_rails_e9928cde2e FOREIGN KEY (phone_number_id) REFERENCES public.phone_numbers(id);


--
-- Name: ads fk_rails_f7e6a33a41; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ads
    ADD CONSTRAINT fk_rails_f7e6a33a41 FOREIGN KEY (phone_number_id) REFERENCES public.phone_numbers(id) ON DELETE CASCADE;


--
-- Name: chat_rooms fk_rails_fb091736d8; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chat_rooms
    ADD CONSTRAINT fk_rails_fb091736d8 FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO "schema_migrations" (version) VALUES
('20200707171001'),
('20200707171003'),
('20200707171004'),
('20200707172000'),
('20200707172006'),
('20200707172007'),
('20200707172023'),
('20200707172025'),
('20200707172029'),
('20200708153418'),
('20200708154421'),
('20200709181647'),
('20200729185825'),
('20200806133228'),
('20200816193450'),
('20200831115130'),
('20201001061800'),
('20201001064055'),
('20201007101246'),
('20201007101247'),
('20201007101254'),
('20201007101315'),
('20201024103631'),
('20201024103951'),
('20201030192732'),
('20201031204555'),
('20201103114215'),
('20201105174219'),
('20201105174220'),
('20201105174221'),
('20201105174222'),
('20201105174223'),
('20201105174224'),
('20201105174225'),
('20201105174226'),
('20201105174227'),
('20201105174228'),
('20201105174229'),
('20201105174230'),
('20201105174231'),
('20201105174232'),
('20201105174233'),
('20201105174234'),
('20201121180726'),
('20201124155628'),
('20201126214710'),
('20201130223551'),
('20201202195700'),
('20210206130842'),
('20210317140913'),
('20210317140918'),
('20210323200730'),
('20210328180036'),
('20210328204025'),
('20210328211421'),
('20210328211424'),
('20210328211426'),
('20210329194349'),
('20210330081722'),
('20210508102119'),
('20210508114138'),
('20210508122655'),
('20210508135012'),
('20210508141659'),
('20210508191744'),
('20210509084235'),
('20210511050910'),
('20210523204018'),
('20210523230607'),
('20210523231446'),
('20210524093908'),
('20210524103240'),
('20210524104800'),
('20210524111522'),
('20210524124950'),
('20210524124954'),
('20210524125620'),
('20210528104250'),
('20210528133750'),
('20210529092800'),
('20210601174519'),
('20210601204622'),
('20210603210605'),
('20210604162647'),
('20210612140908'),
('20210612182750'),
('20210612183516'),
('20210613115227'),
('20210614185805'),
('20210616211101'),
('20210616215226'),
('20210703111050'),
('20210715203008'),
('20210814204316'),
('20210821191558'),
('20210822202438'),
('20210825204417'),
('20210918194333'),
('20210918212740'),
('20210919192139'),
('20210920092905'),
('20210922202047'),
('20210924204212'),
('20210924210053'),
('20210925082350'),
('20211023130942'),
('20211023132934'),
('20211023133410'),
('20211023133756'),
('20211023140945'),
('20211128102012'),
('20221117233245'),
('20221123131714'),
('20221124225005'),
('20221124225553'),
('20221124230552'),
('20221124230927'),
('20221124232851'),
('20221202170729'),
('20221204203325'),
('20221206130721'),
('20221207123334'),
('20221207134116'),
('20221207140949'),
('20221210215729'),
('20221211172613'),
('20221212010039'),
('20221212011330'),
('20221212012407'),
('20221212143033'),
('20221212151349'),
('20221212200038'),
('20221212201534'),
('20221212201814'),
('20221212205750'),
('20221212212301'),
('20221213110340'),
('20221213112542'),
('20221213134103'),
('20221213220328'),
('20221213220334'),
('20221214124328'),
('20221214124559'),
('20221214234730'),
('20221216113749'),
('20221216201112'),
('20221216202521'),
('20221216202530'),
('20221216202806'),
('20221216214724'),
('20221217135748');


