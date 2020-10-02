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

SET default_tablespace = '';

SET default_with_oids = false;

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
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
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
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
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
-- Name: admin_users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.admin_users (
    id bigint NOT NULL,
    email character varying DEFAULT ''::character varying NOT NULL,
    encrypted_password character varying DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying,
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
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
    url_id bigint,
    car_maker_id bigint,
    car_gear_type_id bigint,
    car_fuel_type_id bigint,
    car_wheels_type_id bigint,
    car_carcass_type_id bigint,
    car_details_id bigint,
    car_color_id bigint,
    price integer NOT NULL,
    year integer NOT NULL,
    race bigint,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    car_model_id integer,
    active boolean DEFAULT true NOT NULL,
    city_id integer,
    customs_clear boolean,
    new_car boolean,
    ad_updated_at timestamp without time zone,
    phone_number_id integer,
    images_json_array_tmp text,
    deleted boolean,
    engine_capacity integer,
    ad_description_id integer,
    ads_source_id integer
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
    title character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
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
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: car_carcass_types; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.car_carcass_types (
    id bigint NOT NULL,
    title character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    filter_union_id integer
);


--
-- Name: car_carcass_types_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.car_carcass_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: car_carcass_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.car_carcass_types_id_seq OWNED BY public.car_carcass_types.id;


--
-- Name: car_colors; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.car_colors (
    id bigint NOT NULL,
    title character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: car_colors_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.car_colors_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: car_colors_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.car_colors_id_seq OWNED BY public.car_colors.id;


--
-- Name: car_fuel_types; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.car_fuel_types (
    id bigint NOT NULL,
    title character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    filter_union_id integer
);


--
-- Name: car_fuel_types_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.car_fuel_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: car_fuel_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.car_fuel_types_id_seq OWNED BY public.car_fuel_types.id;


--
-- Name: car_gear_types; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.car_gear_types (
    id bigint NOT NULL,
    title character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    filter_union_id integer
);


--
-- Name: car_gear_types_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.car_gear_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: car_gear_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.car_gear_types_id_seq OWNED BY public.car_gear_types.id;


--
-- Name: car_maker_aliases; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.car_maker_aliases (
    id bigint NOT NULL,
    car_maker_id bigint NOT NULL,
    title character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: car_maker_aliases_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.car_maker_aliases_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: car_maker_aliases_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.car_maker_aliases_id_seq OWNED BY public.car_maker_aliases.id;


--
-- Name: car_makers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.car_makers (
    id bigint NOT NULL,
    title character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    display_name character varying
);


--
-- Name: car_makers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.car_makers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: car_makers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.car_makers_id_seq OWNED BY public.car_makers.id;


--
-- Name: car_model_aliases; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.car_model_aliases (
    id bigint NOT NULL,
    car_model_id bigint NOT NULL,
    car_maker_id bigint NOT NULL,
    title character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: car_model_aliases_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.car_model_aliases_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: car_model_aliases_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.car_model_aliases_id_seq OWNED BY public.car_model_aliases.id;


--
-- Name: car_models; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.car_models (
    id bigint NOT NULL,
    title character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    car_maker_id integer,
    active boolean DEFAULT true NOT NULL,
    display_name character varying
);


--
-- Name: car_models_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.car_models_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: car_models_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.car_models_id_seq OWNED BY public.car_models.id;


--
-- Name: car_registrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.car_registrations (
    id bigint NOT NULL,
    number character varying NOT NULL,
    car_model_id bigint NOT NULL,
    registered_at timestamp without time zone NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    extra_data jsonb
);


--
-- Name: car_registrations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.car_registrations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: car_registrations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.car_registrations_id_seq OWNED BY public.car_registrations.id;


--
-- Name: car_wheels_types; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.car_wheels_types (
    id bigint NOT NULL,
    title character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    filter_union_id integer
);


--
-- Name: car_wheels_types_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.car_wheels_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: car_wheels_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.car_wheels_types_id_seq OWNED BY public.car_wheels_types.id;


--
-- Name: cities; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.cities (
    id bigint NOT NULL,
    region_id bigint,
    title character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    display_name character varying
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
-- Name: filter_unions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.filter_unions (
    id bigint NOT NULL,
    title character varying,
    key character varying,
    ids character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: filter_unions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.filter_unions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: filter_unions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.filter_unions_id_seq OWNED BY public.filter_unions.id;


--
-- Name: images; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.images (
    id bigint NOT NULL,
    attachment character varying,
    car_model_id bigint,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: images_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.images_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: images_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.images_id_seq OWNED BY public.images.id;


--
-- Name: models_aggregated_matview; Type: MATERIALIZED VIEW; Schema: public; Owner: -
--

CREATE MATERIALIZED VIEW public.models_aggregated_matview AS
 SELECT max((car_makers.display_name)::text) AS maker,
    max((car_models.display_name)::text) AS model,
    ads.year,
    min(ads.price) AS min_price,
    (avg(ads.price))::integer AS avg_price,
    max(ads.price) AS max_price,
    count(*) AS ads_count,
    max(car_makers.id) AS maker_id,
    max(car_models.id) AS model_id
   FROM ((public.ads
     JOIN public.car_models ON ((car_models.id = ads.car_model_id)))
     JOIN public.car_makers ON ((car_makers.id = car_models.car_maker_id)))
  WHERE ((ads.deleted = false) AND (ads.ads_source_id = 1) AND (ads.updated_at >= (now() - '2 mons'::interval)))
  GROUP BY ads.car_model_id, ads.year
  ORDER BY ads.car_model_id, ads.year
  WITH NO DATA;


--
-- Name: phone_numbers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.phone_numbers (
    id bigint NOT NULL,
    full_number character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
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
-- Name: regions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.regions (
    id bigint NOT NULL,
    title character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    display_name character varying
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
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


--
-- Name: urls; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.urls (
    id bigint NOT NULL,
    address text NOT NULL,
    ads_source_id bigint NOT NULL,
    status character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: urls_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.urls_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: urls_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.urls_id_seq OWNED BY public.urls.id;


--
-- Name: user_contacts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.user_contacts (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    name character varying,
    phone_number_id bigint NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


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
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id bigint NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    access_token character varying,
    phone_number_id integer
);


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
    verification_code integer NOT NULL,
    phone_number_id bigint NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
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
    item_type character varying NOT NULL,
    item_id integer NOT NULL,
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
-- Name: car_carcass_types id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.car_carcass_types ALTER COLUMN id SET DEFAULT nextval('public.car_carcass_types_id_seq'::regclass);


--
-- Name: car_colors id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.car_colors ALTER COLUMN id SET DEFAULT nextval('public.car_colors_id_seq'::regclass);


--
-- Name: car_fuel_types id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.car_fuel_types ALTER COLUMN id SET DEFAULT nextval('public.car_fuel_types_id_seq'::regclass);


--
-- Name: car_gear_types id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.car_gear_types ALTER COLUMN id SET DEFAULT nextval('public.car_gear_types_id_seq'::regclass);


--
-- Name: car_maker_aliases id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.car_maker_aliases ALTER COLUMN id SET DEFAULT nextval('public.car_maker_aliases_id_seq'::regclass);


--
-- Name: car_makers id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.car_makers ALTER COLUMN id SET DEFAULT nextval('public.car_makers_id_seq'::regclass);


--
-- Name: car_model_aliases id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.car_model_aliases ALTER COLUMN id SET DEFAULT nextval('public.car_model_aliases_id_seq'::regclass);


--
-- Name: car_models id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.car_models ALTER COLUMN id SET DEFAULT nextval('public.car_models_id_seq'::regclass);


--
-- Name: car_registrations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.car_registrations ALTER COLUMN id SET DEFAULT nextval('public.car_registrations_id_seq'::regclass);


--
-- Name: car_wheels_types id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.car_wheels_types ALTER COLUMN id SET DEFAULT nextval('public.car_wheels_types_id_seq'::regclass);


--
-- Name: cities id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cities ALTER COLUMN id SET DEFAULT nextval('public.cities_id_seq'::regclass);


--
-- Name: filter_unions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.filter_unions ALTER COLUMN id SET DEFAULT nextval('public.filter_unions_id_seq'::regclass);


--
-- Name: images id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.images ALTER COLUMN id SET DEFAULT nextval('public.images_id_seq'::regclass);


--
-- Name: phone_numbers id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.phone_numbers ALTER COLUMN id SET DEFAULT nextval('public.phone_numbers_id_seq'::regclass);


--
-- Name: regions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.regions ALTER COLUMN id SET DEFAULT nextval('public.regions_id_seq'::regclass);


--
-- Name: urls id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.urls ALTER COLUMN id SET DEFAULT nextval('public.urls_id_seq'::regclass);


--
-- Name: user_contacts id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_contacts ALTER COLUMN id SET DEFAULT nextval('public.user_contacts_id_seq'::regclass);


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
-- Name: car_carcass_types car_carcass_types_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.car_carcass_types
    ADD CONSTRAINT car_carcass_types_pkey PRIMARY KEY (id);


--
-- Name: car_colors car_colors_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.car_colors
    ADD CONSTRAINT car_colors_pkey PRIMARY KEY (id);


--
-- Name: car_fuel_types car_fuel_types_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.car_fuel_types
    ADD CONSTRAINT car_fuel_types_pkey PRIMARY KEY (id);


--
-- Name: car_gear_types car_gear_types_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.car_gear_types
    ADD CONSTRAINT car_gear_types_pkey PRIMARY KEY (id);


--
-- Name: car_maker_aliases car_maker_aliases_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.car_maker_aliases
    ADD CONSTRAINT car_maker_aliases_pkey PRIMARY KEY (id);


--
-- Name: car_makers car_makers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.car_makers
    ADD CONSTRAINT car_makers_pkey PRIMARY KEY (id);


--
-- Name: car_model_aliases car_model_aliases_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.car_model_aliases
    ADD CONSTRAINT car_model_aliases_pkey PRIMARY KEY (id);


--
-- Name: car_models car_models_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.car_models
    ADD CONSTRAINT car_models_pkey PRIMARY KEY (id);


--
-- Name: car_registrations car_registrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.car_registrations
    ADD CONSTRAINT car_registrations_pkey PRIMARY KEY (id);


--
-- Name: car_wheels_types car_wheels_types_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.car_wheels_types
    ADD CONSTRAINT car_wheels_types_pkey PRIMARY KEY (id);


--
-- Name: cities cities_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cities
    ADD CONSTRAINT cities_pkey PRIMARY KEY (id);


--
-- Name: filter_unions filter_unions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.filter_unions
    ADD CONSTRAINT filter_unions_pkey PRIMARY KEY (id);


--
-- Name: images images_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.images
    ADD CONSTRAINT images_pkey PRIMARY KEY (id);


--
-- Name: phone_numbers phone_numbers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.phone_numbers
    ADD CONSTRAINT phone_numbers_pkey PRIMARY KEY (id);


--
-- Name: regions regions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.regions
    ADD CONSTRAINT regions_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: urls urls_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.urls
    ADD CONSTRAINT urls_pkey PRIMARY KEY (id);


--
-- Name: user_contacts user_contacts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_contacts
    ADD CONSTRAINT user_contacts_pkey PRIMARY KEY (id);


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
-- Name: ads_search_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ads_search_index ON public.ads USING btree (price, year, updated_at, car_model_id, car_maker_id, deleted, ads_source_id);


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
-- Name: index_admin_users_on_email; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_admin_users_on_email ON public.admin_users USING btree (email);


--
-- Name: index_admin_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_admin_users_on_reset_password_token ON public.admin_users USING btree (reset_password_token);


--
-- Name: index_ads_on_car_carcass_type_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_ads_on_car_carcass_type_id ON public.ads USING btree (car_carcass_type_id);


--
-- Name: index_ads_on_car_color_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_ads_on_car_color_id ON public.ads USING btree (car_color_id);


--
-- Name: index_ads_on_car_details_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_ads_on_car_details_id ON public.ads USING btree (car_details_id);


--
-- Name: index_ads_on_car_fuel_type_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_ads_on_car_fuel_type_id ON public.ads USING btree (car_fuel_type_id);


--
-- Name: index_ads_on_car_gear_type_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_ads_on_car_gear_type_id ON public.ads USING btree (car_gear_type_id);


--
-- Name: index_ads_on_car_maker_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_ads_on_car_maker_id ON public.ads USING btree (car_maker_id);


--
-- Name: index_ads_on_car_model_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_ads_on_car_model_id ON public.ads USING btree (car_model_id);


--
-- Name: index_ads_on_car_model_id_and_car_maker_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_ads_on_car_model_id_and_car_maker_id ON public.ads USING btree (car_model_id, car_maker_id);


--
-- Name: index_ads_on_car_wheels_type_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_ads_on_car_wheels_type_id ON public.ads USING btree (car_wheels_type_id);


--
-- Name: index_ads_on_city_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_ads_on_city_id ON public.ads USING btree (city_id);


--
-- Name: index_ads_on_created_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_ads_on_created_at ON public.ads USING btree (created_at);


--
-- Name: index_ads_on_gear_fuel_wheels_carcass_types_ids; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_ads_on_gear_fuel_wheels_carcass_types_ids ON public.ads USING btree (car_gear_type_id, car_fuel_type_id, car_wheels_type_id, car_carcass_type_id);


--
-- Name: index_ads_on_phone_number_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_ads_on_phone_number_id ON public.ads USING btree (phone_number_id);


--
-- Name: index_ads_on_price; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_ads_on_price ON public.ads USING btree (price);


--
-- Name: index_ads_on_url_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_ads_on_url_id ON public.ads USING btree (url_id);


--
-- Name: index_ads_on_year; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_ads_on_year ON public.ads USING btree (year);


--
-- Name: index_car_carcass_types_on_filter_union_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_car_carcass_types_on_filter_union_id ON public.car_carcass_types USING btree (filter_union_id);


--
-- Name: index_car_fuel_types_on_filter_union_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_car_fuel_types_on_filter_union_id ON public.car_fuel_types USING btree (filter_union_id);


--
-- Name: index_car_gear_types_on_filter_union_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_car_gear_types_on_filter_union_id ON public.car_gear_types USING btree (filter_union_id);


--
-- Name: index_car_maker_aliases_on_car_maker_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_car_maker_aliases_on_car_maker_id ON public.car_maker_aliases USING btree (car_maker_id);


--
-- Name: index_car_maker_aliases_on_title; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_car_maker_aliases_on_title ON public.car_maker_aliases USING btree (title);


--
-- Name: index_car_model_aliases_on_car_maker_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_car_model_aliases_on_car_maker_id ON public.car_model_aliases USING btree (car_maker_id);


--
-- Name: index_car_model_aliases_on_car_model_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_car_model_aliases_on_car_model_id ON public.car_model_aliases USING btree (car_model_id);


--
-- Name: index_car_model_aliases_on_title_and_car_maker_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_car_model_aliases_on_title_and_car_maker_id ON public.car_model_aliases USING btree (title, car_maker_id);


--
-- Name: index_car_models_on_car_maker_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_car_models_on_car_maker_id ON public.car_models USING btree (car_maker_id);


--
-- Name: index_car_models_on_display_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_car_models_on_display_name ON public.car_models USING btree (display_name);


--
-- Name: index_car_registrations_on_car_model_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_car_registrations_on_car_model_id ON public.car_registrations USING btree (car_model_id);


--
-- Name: index_car_registrations_on_number; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_car_registrations_on_number ON public.car_registrations USING btree (number);


--
-- Name: index_car_wheels_types_on_filter_union_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_car_wheels_types_on_filter_union_id ON public.car_wheels_types USING btree (filter_union_id);


--
-- Name: index_cities_on_region_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_cities_on_region_id ON public.cities USING btree (region_id);


--
-- Name: index_images_on_car_model_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_images_on_car_model_id ON public.images USING btree (car_model_id);


--
-- Name: index_phone_numbers_on_full_number; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_phone_numbers_on_full_number ON public.phone_numbers USING btree (full_number);


--
-- Name: index_urls_on_ads_source_id_and_updated_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_urls_on_ads_source_id_and_updated_at ON public.urls USING btree (ads_source_id, updated_at);


--
-- Name: index_user_contacts_on_phone_number_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_user_contacts_on_phone_number_id ON public.user_contacts USING btree (phone_number_id);


--
-- Name: index_user_contacts_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_user_contacts_on_user_id ON public.user_contacts USING btree (user_id);


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
-- Name: models_aggregated_matview_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX models_aggregated_matview_idx ON public.models_aggregated_matview USING btree (year, min_price, max_price, ads_count, maker_id, model_id, maker, model);


--
-- Name: tst; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX tst ON public.urls USING btree (address);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO "schema_migrations" (version) VALUES
('20180808094353'),
('20180808094405'),
('20180808094410'),
('20180808094447'),
('20180808094517'),
('20180808094534'),
('20180808094717'),
('20180808094819'),
('20180808194407'),
('20180811155007'),
('20180811155112'),
('20180816184444'),
('20180816194652'),
('20181230190908'),
('20181230191255'),
('20190105133219'),
('20190105164354'),
('20190105164356'),
('20190105164758'),
('20190105181653'),
('20190105184604'),
('20190105193900'),
('20190106135947'),
('20190216101932'),
('20190216101951'),
('20190216102440'),
('20190216145041'),
('20190217172908'),
('20190217182933'),
('20190218150752'),
('20190219100449'),
('20190219100931'),
('20190220084408'),
('20190220085042'),
('20190220085104'),
('20190221080219'),
('20190221112916'),
('20190227084338'),
('20190304155141'),
('20190304160124'),
('20190304163717'),
('20190320131021'),
('20190320131540'),
('20190320135348'),
('20190320142711'),
('20190321085426'),
('20190324170322'),
('20190325152643'),
('20190331202900'),
('20191208082917'),
('20191208083710'),
('20191216230938'),
('20191216231849'),
('20191217000219'),
('20191217000226'),
('20191218084519'),
('20191218142657');


