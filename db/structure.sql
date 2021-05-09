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
    id bigint NOT NULL,
    ad_id bigint NOT NULL,
    body text
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
    id bigint NOT NULL,
    ad_id bigint NOT NULL,
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
    id bigint NOT NULL,
    name character varying NOT NULL
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
-- Name: ad_option_values; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ad_option_values (
    id bigint NOT NULL,
    value character varying NOT NULL
);


--
-- Name: ad_option_values_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.ad_option_values_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: ad_option_values_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.ad_option_values_id_seq OWNED BY public.ad_option_values.id;


--
-- Name: ad_options; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ad_options (
    id bigint NOT NULL,
    ad_id bigint NOT NULL,
    ad_option_type_id bigint NOT NULL,
    ad_option_value_id bigint NOT NULL
);


--
-- Name: ad_options_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.ad_options_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: ad_options_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.ad_options_id_seq OWNED BY public.ad_options.id;


--
-- Name: ad_prices; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ad_prices (
    id bigint NOT NULL,
    ad_id bigint NOT NULL,
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
    id bigint NOT NULL,
    phone_number_id bigint NOT NULL,
    ads_source_id bigint NOT NULL,
    price integer NOT NULL,
    deleted boolean DEFAULT false NOT NULL,
    ad_type character varying NOT NULL,
    address character varying NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


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
    updated_at timestamp(6) without time zone NOT NULL
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
-- Name: user_contacts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.user_contacts (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    phone_number_id bigint NOT NULL,
    name character varying(100) NOT NULL
);


--
-- Name: effective_ads; Type: MATERIALIZED VIEW; Schema: public; Owner: -
--

CREATE MATERIALIZED VIEW public.effective_ads AS
 SELECT DISTINCT ads.id,
    ads.phone_number_id,
    ads.price
   FROM (public.ads
     JOIN public.user_contacts ON ((user_contacts.phone_number_id = ads.phone_number_id)))
  WHERE (ads.deleted = false)
  WITH NO DATA;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id bigint NOT NULL,
    phone_number_id bigint NOT NULL,
    name character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    avatar json
);


--
-- Name: effective_user_contacts; Type: MATERIALIZED VIEW; Schema: public; Owner: -
--

CREATE MATERIALIZED VIEW public.effective_user_contacts AS
 SELECT user_contacts.id,
    user_contacts.user_id,
    user_contacts.phone_number_id,
    user_contacts.name
   FROM (public.user_contacts
     JOIN public.users ON ((users.phone_number_id = user_contacts.phone_number_id)))
UNION
 SELECT user_contacts.id,
    user_contacts.user_id,
    user_contacts.phone_number_id,
    user_contacts.name
   FROM public.user_contacts
  WHERE (user_contacts.phone_number_id IN ( SELECT DISTINCT effective_ads.phone_number_id
           FROM public.effective_ads))
  WITH NO DATA;


--
-- Name: messages; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.messages (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    body character varying NOT NULL,
    system boolean DEFAULT false NOT NULL,
    user_id bigint,
    chat_room_id bigint NOT NULL,
    created_at timestamp without time zone NOT NULL
);


--
-- Name: phone_numbers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.phone_numbers (
    id bigint NOT NULL,
    full_number character varying(9) NOT NULL
);


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
    access_token_expiration timestamp without time zone,
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
-- Name: user_device_stats; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.user_device_stats (
    id bigint NOT NULL,
    user_devices_appeared_count integer NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: user_device_stats_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.user_device_stats_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: user_device_stats_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.user_device_stats_id_seq OWNED BY public.user_device_stats.id;


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
    build_version character varying
);


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
-- Name: versions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.versions (
    id bigint NOT NULL,
    item_type character varying,
    "{:null=>false}" character varying,
    item_id bigint NOT NULL,
    event character varying NOT NULL,
    whodunnit character varying,
    object text,
    created_at timestamp without time zone
);


--
-- Name: versions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.versions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: versions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.versions_id_seq OWNED BY public.versions.id;


--
-- Name: active_admin_comments id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_admin_comments ALTER COLUMN id SET DEFAULT nextval('public.active_admin_comments_id_seq'::regclass);


--
-- Name: ad_descriptions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ad_descriptions ALTER COLUMN id SET DEFAULT nextval('public.ad_descriptions_id_seq'::regclass);


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
-- Name: ad_option_values id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ad_option_values ALTER COLUMN id SET DEFAULT nextval('public.ad_option_values_id_seq'::regclass);


--
-- Name: ad_options id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ad_options ALTER COLUMN id SET DEFAULT nextval('public.ad_options_id_seq'::regclass);


--
-- Name: ad_prices id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ad_prices ALTER COLUMN id SET DEFAULT nextval('public.ad_prices_id_seq'::regclass);


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
-- Name: chat_room_users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chat_room_users ALTER COLUMN id SET DEFAULT nextval('public.chat_room_users_id_seq'::regclass);


--
-- Name: chat_rooms id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chat_rooms ALTER COLUMN id SET DEFAULT nextval('public.chat_rooms_id_seq'::regclass);


--
-- Name: demo_phone_numbers id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.demo_phone_numbers ALTER COLUMN id SET DEFAULT nextval('public.demo_phone_numbers_id_seq'::regclass);


--
-- Name: phone_numbers id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.phone_numbers ALTER COLUMN id SET DEFAULT nextval('public.phone_numbers_id_seq'::regclass);


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
-- Name: user_contacts id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_contacts ALTER COLUMN id SET DEFAULT nextval('public.user_contacts_id_seq'::regclass);


--
-- Name: user_device_stats id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_device_stats ALTER COLUMN id SET DEFAULT nextval('public.user_device_stats_id_seq'::regclass);


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
-- Name: versions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.versions ALTER COLUMN id SET DEFAULT nextval('public.versions_id_seq'::regclass);


--
-- Name: ads ads_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ads
    ADD CONSTRAINT ads_pkey PRIMARY KEY (id);


--
-- Name: ads_grouped_by_maker_model_year; Type: MATERIALIZED VIEW; Schema: public; Owner: -
--

CREATE MATERIALIZED VIEW public.ads_grouped_by_maker_model_year AS
 SELECT ads.maker,
    ads.model,
    ads.year,
    min(ads.price) AS min_price,
    (round((avg(ads.price) / (100)::numeric)) * (100)::numeric) AS avg_price,
    max(ads.price) AS max_price
   FROM ( SELECT ads_1.id,
            ads_1.price,
            max((ad_option_values.value)::text) FILTER (WHERE (ad_options.ad_option_type_id = 6)) AS maker,
            max((ad_option_values.value)::text) FILTER (WHERE (ad_options.ad_option_type_id = 7)) AS model,
            max((ad_option_values.value)::text) FILTER (WHERE (ad_options.ad_option_type_id = 4)) AS year
           FROM ((public.ads ads_1
             JOIN public.ad_options ON (((ads_1.id = ad_options.ad_id) AND (ad_options.ad_option_type_id = ANY (ARRAY[(4)::bigint, (6)::bigint, (7)::bigint])))))
             JOIN public.ad_option_values ON ((ad_option_values.id = ad_options.ad_option_value_id)))
          WHERE (ads_1.deleted = false)
          GROUP BY ads_1.id) ads
  GROUP BY ads.maker, ads.model, ads.year
 HAVING (count(ads.*) >= 5)
  ORDER BY ads.maker, ads.model, ads.year
  WITH NO DATA;


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
-- Name: ad_option_values ad_option_values_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ad_option_values
    ADD CONSTRAINT ad_option_values_pkey PRIMARY KEY (id);


--
-- Name: ad_options ad_options_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ad_options
    ADD CONSTRAINT ad_options_pkey PRIMARY KEY (id);


--
-- Name: ad_prices ad_prices_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ad_prices
    ADD CONSTRAINT ad_prices_pkey PRIMARY KEY (id);


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
-- Name: demo_phone_numbers demo_phone_numbers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.demo_phone_numbers
    ADD CONSTRAINT demo_phone_numbers_pkey PRIMARY KEY (id);


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
-- Name: user_contacts user_contacts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_contacts
    ADD CONSTRAINT user_contacts_pkey PRIMARY KEY (id);


--
-- Name: user_device_stats user_device_stats_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_device_stats
    ADD CONSTRAINT user_device_stats_pkey PRIMARY KEY (id);


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
-- Name: versions versions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.versions
    ADD CONSTRAINT versions_pkey PRIMARY KEY (id);


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
-- Name: index_ad_favorites_on_ad_id_and_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_ad_favorites_on_ad_id_and_user_id ON public.ad_favorites USING btree (ad_id, user_id);


--
-- Name: index_ad_favorites_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_ad_favorites_on_user_id ON public.ad_favorites USING btree (user_id);


--
-- Name: index_ad_image_links_sets_on_ad_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_ad_image_links_sets_on_ad_id ON public.ad_image_links_sets USING btree (ad_id);


--
-- Name: index_ad_option_types_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_ad_option_types_on_name ON public.ad_option_types USING btree (name);


--
-- Name: index_ad_option_values_on_value; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_ad_option_values_on_value ON public.ad_option_values USING btree (value);


--
-- Name: index_ad_options_on_ad_id_and_ad_option_type_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_ad_options_on_ad_id_and_ad_option_type_id ON public.ad_options USING btree (ad_id, ad_option_type_id);


--
-- Name: index_ad_prices_on_ad_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_ad_prices_on_ad_id ON public.ad_prices USING btree (ad_id);


--
-- Name: index_ad_visits_on_ad_id_and_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_ad_visits_on_ad_id_and_user_id ON public.ad_visits USING btree (ad_id, user_id);


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
-- Name: index_ads_on_address_and_ads_source_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_ads_on_address_and_ads_source_id ON public.ads USING btree (address, ads_source_id);


--
-- Name: index_ads_on_phone_number_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_ads_on_phone_number_id ON public.ads USING btree (phone_number_id);


--
-- Name: index_ads_on_phone_number_id_and_updated_at_and_price; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_ads_on_phone_number_id_and_updated_at_and_price ON public.ads USING btree (phone_number_id, updated_at DESC, price) WHERE (deleted = false);


--
-- Name: index_ads_sources_on_api_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_ads_sources_on_api_token ON public.ads_sources USING btree (api_token);


--
-- Name: index_ads_sources_on_title; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_ads_sources_on_title ON public.ads_sources USING btree (title);


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
-- Name: index_demo_phone_numbers_on_phone_number_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_demo_phone_numbers_on_phone_number_id ON public.demo_phone_numbers USING btree (phone_number_id);


--
-- Name: index_effective_ads_on_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_effective_ads_on_id ON public.effective_ads USING btree (id DESC);


--
-- Name: index_effective_ads_on_phone_number_id_and_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_effective_ads_on_phone_number_id_and_id ON public.effective_ads USING btree (phone_number_id, id DESC);


--
-- Name: index_effective_ads_on_price; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_effective_ads_on_price ON public.effective_ads USING btree (price);


--
-- Name: index_effective_user_contacts_on_phone_number_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_effective_user_contacts_on_phone_number_id ON public.effective_user_contacts USING btree (phone_number_id);


--
-- Name: index_effective_user_contacts_on_phone_number_id_and_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_effective_user_contacts_on_phone_number_id_and_user_id ON public.effective_user_contacts USING btree (phone_number_id, user_id);


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
-- Name: index_user_contacts_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_user_contacts_on_name ON public.user_contacts USING gist (name public.gist_trgm_ops);


--
-- Name: index_user_contacts_on_phone_number_id_and_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_user_contacts_on_phone_number_id_and_user_id ON public.user_contacts USING btree (phone_number_id, user_id);


--
-- Name: index_user_contacts_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_user_contacts_on_user_id ON public.user_contacts USING btree (user_id);


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
-- Name: index_verification_requests_on_phone_number_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_verification_requests_on_phone_number_id ON public.verification_requests USING btree (phone_number_id);


--
-- Name: index_versions_on_item_type_and_item_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_versions_on_item_type_and_item_id ON public.versions USING btree (item_type, item_id);


--
-- Name: search_budget_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX search_budget_index ON public.ads_grouped_by_maker_model_year USING btree (min_price, max_price);


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
-- Name: ad_favorites fk_rails_433c6ffc89; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ad_favorites
    ADD CONSTRAINT fk_rails_433c6ffc89 FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


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
-- Name: user_devices fk_rails_e700a96826; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_devices
    ADD CONSTRAINT fk_rails_e700a96826 FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: ads fk_rails_f7e6a33a41; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ads
    ADD CONSTRAINT fk_rails_f7e6a33a41 FOREIGN KEY (phone_number_id) REFERENCES public.phone_numbers(id) ON DELETE CASCADE;


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
('20201214222348'),
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
('20210508191744');


