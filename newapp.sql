--
-- PostgreSQL database dump
--

-- Dumped from database version 12.1
-- Dumped by pg_dump version 12.1

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

SET default_table_access_method = heap;

--
-- Name: analyze_pages; Type: TABLE; Schema: public; Owner: danutu
--

CREATE TABLE public.analyze_pages (
    id integer NOT NULL,
    name character varying,
    session character varying,
    first_visited date,
    visits integer
);


ALTER TABLE public.analyze_pages OWNER TO danutu;

--
-- Name: analyze_pages_id_seq; Type: SEQUENCE; Schema: public; Owner: danutu
--

CREATE SEQUENCE public.analyze_pages_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.analyze_pages_id_seq OWNER TO danutu;

--
-- Name: analyze_pages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: danutu
--

ALTER SEQUENCE public.analyze_pages_id_seq OWNED BY public.analyze_pages.id;


--
-- Name: analyze_session; Type: TABLE; Schema: public; Owner: danutu
--

CREATE TABLE public.analyze_session (
    id integer NOT NULL,
    ip character varying,
    continent character varying,
    country character varying,
    city character varying,
    os character varying,
    browser character varying,
    session character varying,
    created_at date,
    bot boolean,
    lang character varying,
    referer character varying,
    iso_code character varying
);


ALTER TABLE public.analyze_session OWNER TO danutu;

--
-- Name: analyze_session_id_seq; Type: SEQUENCE; Schema: public; Owner: danutu
--

CREATE SEQUENCE public.analyze_session_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.analyze_session_id_seq OWNER TO danutu;

--
-- Name: analyze_session_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: danutu
--

ALTER SEQUENCE public.analyze_session_id_seq OWNED BY public.analyze_session.id;


--
-- Name: coordinates_locations; Type: TABLE; Schema: public; Owner: danutu
--

CREATE TABLE public.coordinates_locations (
    code_ip integer NOT NULL,
    continent character varying,
    country character varying,
    county character varying,
    city character varying,
    iso_code character varying
);


ALTER TABLE public.coordinates_locations OWNER TO danutu;

--
-- Name: coordinates_locations_id_seq; Type: SEQUENCE; Schema: public; Owner: danutu
--

CREATE SEQUENCE public.coordinates_locations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.coordinates_locations_id_seq OWNER TO danutu;

--
-- Name: ip_coordinated; Type: TABLE; Schema: public; Owner: danutu
--

CREATE TABLE public.ip_coordinated (
    code integer NOT NULL,
    ip character varying,
    longitude character varying,
    latitude character varying
);


ALTER TABLE public.ip_coordinated OWNER TO danutu;

--
-- Name: ip_coordinates_code_seq; Type: SEQUENCE; Schema: public; Owner: danutu
--

CREATE SEQUENCE public.ip_coordinates_code_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ip_coordinates_code_seq OWNER TO danutu;

--
-- Name: likes; Type: TABLE; Schema: public; Owner: danutu
--

CREATE TABLE public.likes (
    id integer NOT NULL,
    post_id integer,
    "user" integer
);


ALTER TABLE public.likes OWNER TO danutu;

--
-- Name: likes_id_seq; Type: SEQUENCE; Schema: public; Owner: danutu
--

CREATE SEQUENCE public.likes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.likes_id_seq OWNER TO danutu;

--
-- Name: notifications; Type: TABLE; Schema: public; Owner: danutu
--

CREATE TABLE public.notifications (
    id integer NOT NULL,
    "user" integer,
    title character varying,
    body character varying,
    link character varying,
    for_user integer,
    checked boolean,
    created_on timestamp without time zone,
    category character varying
);


ALTER TABLE public.notifications OWNER TO danutu;

--
-- Name: notifications_id_seq; Type: SEQUENCE; Schema: public; Owner: danutu
--

CREATE SEQUENCE public.notifications_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.notifications_id_seq OWNER TO danutu;

--
-- Name: podcast_series; Type: TABLE; Schema: public; Owner: danutu
--

CREATE TABLE public.podcast_series (
    id integer NOT NULL,
    name character varying,
    description character varying,
    img character varying
);


ALTER TABLE public.podcast_series OWNER TO danutu;

--
-- Name: podcasts; Type: TABLE; Schema: public; Owner: danutu
--

CREATE TABLE public.podcasts (
    id integer NOT NULL,
    title character varying,
    body character varying,
    audio character varying,
    img character varying,
    series_id integer,
    posted_on date,
    source character varying
);


ALTER TABLE public.podcasts OWNER TO danutu;

--
-- Name: podcasts_id_seq; Type: SEQUENCE; Schema: public; Owner: danutu
--

CREATE SEQUENCE public.podcasts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.podcasts_id_seq OWNER TO danutu;

--
-- Name: podcasts_series_id_seq; Type: SEQUENCE; Schema: public; Owner: danutu
--

CREATE SEQUENCE public.podcasts_series_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.podcasts_series_id_seq OWNER TO danutu;

--
-- Name: posts; Type: TABLE; Schema: public; Owner: danutu
--

CREATE TABLE public.posts (
    id integer NOT NULL,
    title character varying(100),
    text character varying,
    views integer,
    reply integer,
    "user" integer,
    posted_on timestamp without time zone,
    approved boolean,
    closed boolean,
    closed_on date,
    closed_by integer,
    lang character varying,
    thumbnail character varying,
    likes integer,
    read_time character varying
);


ALTER TABLE public.posts OWNER TO danutu;

--
-- Name: posts_id_seq; Type: SEQUENCE; Schema: public; Owner: danutu
--

CREATE SEQUENCE public.posts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.posts_id_seq OWNER TO danutu;

--
-- Name: replies_of_replies; Type: TABLE; Schema: public; Owner: danutu
--

CREATE TABLE public.replies_of_replies (
    id integer NOT NULL,
    text character varying,
    reply_id integer,
    "user" integer,
    posted_on date
);


ALTER TABLE public.replies_of_replies OWNER TO danutu;

--
-- Name: replies_of_replies_id_seq; Type: SEQUENCE; Schema: public; Owner: danutu
--

CREATE SEQUENCE public.replies_of_replies_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.replies_of_replies_id_seq OWNER TO danutu;

--
-- Name: replyes; Type: TABLE; Schema: public; Owner: danutu
--

CREATE TABLE public.replyes (
    id integer NOT NULL,
    text character varying,
    post_id integer,
    "user" integer,
    posted_on date
);


ALTER TABLE public.replyes OWNER TO danutu;

--
-- Name: replyes_id_seq; Type: SEQUENCE; Schema: public; Owner: danutu
--

CREATE SEQUENCE public.replyes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.replyes_id_seq OWNER TO danutu;

--
-- Name: role_id_seq; Type: SEQUENCE; Schema: public; Owner: danutu
--

CREATE SEQUENCE public.role_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.role_id_seq OWNER TO danutu;

--
-- Name: roles; Type: TABLE; Schema: public; Owner: danutu
--

CREATE TABLE public.roles (
    id integer NOT NULL,
    name character varying(30),
    post_permission boolean,
    delete_post_permission boolean,
    delete_reply_permission boolean,
    edit_post_permission boolean,
    edit_reply_permission boolean,
    close_post_permission boolean,
    delete_user_permission boolean,
    modify_user_permission boolean,
    admin_panel_permission boolean
);


ALTER TABLE public.roles OWNER TO danutu;

--
-- Name: subscriber; Type: TABLE; Schema: public; Owner: danutu
--

CREATE TABLE public.subscriber (
    id integer NOT NULL,
    "user" integer,
    created timestamp without time zone,
    modified timestamp without time zone,
    subscription_info text,
    is_active boolean
);


ALTER TABLE public.subscriber OWNER TO danutu;

--
-- Name: subscriber_id_seq; Type: SEQUENCE; Schema: public; Owner: danutu
--

CREATE SEQUENCE public.subscriber_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.subscriber_id_seq OWNER TO danutu;

--
-- Name: subscriber_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: danutu
--

ALTER SEQUENCE public.subscriber_id_seq OWNED BY public.subscriber.id;


--
-- Name: tags; Type: TABLE; Schema: public; Owner: danutu
--

CREATE TABLE public.tags (
    id integer NOT NULL,
    name character varying,
    post integer[]
);


ALTER TABLE public.tags OWNER TO danutu;

--
-- Name: tags_id_seq; Type: SEQUENCE; Schema: public; Owner: danutu
--

CREATE SEQUENCE public.tags_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tags_id_seq OWNER TO danutu;

--
-- Name: user_devices; Type: TABLE; Schema: public; Owner: danutu
--

CREATE TABLE public.user_devices (
    id integer NOT NULL,
    "user" integer,
    device_type character varying,
    device_model character varying,
    device_brand character varying,
    last_access timestamp without time zone,
    activated boolean,
    ip_address character varying[]
);


ALTER TABLE public.user_devices OWNER TO danutu;

--
-- Name: user_devices_id_seq; Type: SEQUENCE; Schema: public; Owner: danutu
--

CREATE SEQUENCE public.user_devices_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.user_devices_id_seq OWNER TO danutu;

--
-- Name: user_id_seq; Type: SEQUENCE; Schema: public; Owner: danutu
--

CREATE SEQUENCE public.user_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.user_id_seq OWNER TO danutu;

--
-- Name: users; Type: TABLE; Schema: public; Owner: danutu
--

CREATE TABLE public.users (
    id integer NOT NULL,
    join_date date,
    name character varying(50),
    real_name character varying(50),
    email character varying(50),
    password character varying(255),
    avatar character varying,
    genre character varying,
    role integer,
    bio character varying(250),
    activated boolean,
    ip_address character varying,
    browser character varying,
    country_name character varying,
    country_flag character varying,
    lang character varying,
    int_tags character varying[],
    birthday date,
    profession character varying,
    saved_posts integer[],
    liked_posts integer[],
    follow integer[],
    followed integer[],
    cover character varying,
    instagram character varying,
    facebook character varying,
    twitter character varying,
    github character varying,
    website character varying,
    theme character varying,
    int_podcasts integer[],
    status_color character varying,
    status character varying,
    theme_mode character varying,
    installed boolean
);


ALTER TABLE public.users OWNER TO danutu;

--
-- Name: analyze_pages id; Type: DEFAULT; Schema: public; Owner: danutu
--

ALTER TABLE ONLY public.analyze_pages ALTER COLUMN id SET DEFAULT nextval('public.analyze_pages_id_seq'::regclass);


--
-- Name: analyze_session id; Type: DEFAULT; Schema: public; Owner: danutu
--

ALTER TABLE ONLY public.analyze_session ALTER COLUMN id SET DEFAULT nextval('public.analyze_session_id_seq'::regclass);


--
-- Name: subscriber id; Type: DEFAULT; Schema: public; Owner: danutu
--

ALTER TABLE ONLY public.subscriber ALTER COLUMN id SET DEFAULT nextval('public.subscriber_id_seq'::regclass);


--
-- Data for Name: analyze_pages; Type: TABLE DATA; Schema: public; Owner: danutu
--

COPY public.analyze_pages (id, name, session, first_visited, visits) FROM stdin;
13711	/post/-Tips-for-a-Junior-Dev-121	d1a90d63b4f9867e4b49694a5f9f66d5	2020-03-11	1
13712	/post/-Tips-for-a-Junior-Dev-121	072185756b4724844a6d5fc9d8febe75	2020-03-11	1
13713	/post/How-we-can-overcome-distractions-and-stay-focused-as-developers-155	97651cbfe6f0bd35137a403640ac511f	\N	1
13714	/post/Implementing-an-ActionListener-interface-176	3f93beaf0ddce5c4f8ee92b4640bd0ea	\N	1
13784	/	7aac48c21f8c7aed6bfe07be9b059fca	2020-04-10	1
13785	/post/Implementing-an-ActionListener-interface-176	7da615c25f340092684b851023816d6e	2020-04-10	1
13715	/	28f81a8f1a6fb2ec2d0b4ca3d4e679c3	\N	4
13716	/user/danutu	222189a3cb024baad10a34907237e22f	\N	1
13717	/user/danutu	44c8de6c32c4d0c84047ace9b317ab38	2020-03-15	1
13718	/post/What's-Wrong-with-CSS-189	44c8de6c32c4d0c84047ace9b317ab38	2020-03-15	1
13719	/	44c8de6c32c4d0c84047ace9b317ab38	2020-03-15	1
13720	/post/Just-Keep-Coding!--A-letter-to-junior-developers-119	774dcc2f65fcdec1604cbdd2028c3579	2020-03-15	1
13721	/	774dcc2f65fcdec1604cbdd2028c3579	2020-03-15	1
13722	/post/Implementing-an-ActionListener-interface-176	774dcc2f65fcdec1604cbdd2028c3579	2020-03-15	1
13723	/	bb8f12e12b4b42ed98fee81df20afdfe	2020-03-15	1
13724	/user/danutu	3f39510cee2563a7e6c40f01618bf717	2020-03-15	1
13725	/post/How-we-can-overcome-distractions-and-stay-focused-as-developers-155	3f39510cee2563a7e6c40f01618bf717	2020-03-15	1
13726	/	3f39510cee2563a7e6c40f01618bf717	2020-03-15	1
13727	/admin	3f39510cee2563a7e6c40f01618bf717	2020-03-15	1
13728	/admin/	6d4d4c0c9c26dba23d9a6cd6b83f41fb	2020-03-15	1
13729	/	6d4d4c0c9c26dba23d9a6cd6b83f41fb	2020-03-15	1
13730	/tag/opensource	3b9851091bc141f44ded2f8971b1d407	2020-03-16	1
13731	/	3b9851091bc141f44ded2f8971b1d407	2020-03-16	1
13732	/post/What's-Wrong-with-CSS-189	33cfac615cb8a6e4fd2a7e5292042ba2	2020-03-16	1
13733	/	ebfdc9cba4260a51c74ca3922b01d6a6	2020-03-16	1
13734	/admin	00009d2f6c9d1c7756033694a2a21ec6	2020-03-16	1
13735	/admin/posts	00009d2f6c9d1c7756033694a2a21ec6	2020-03-16	1
13736	/post/Implementing-an-ActionListener-interface-176	00009d2f6c9d1c7756033694a2a21ec6	2020-03-16	1
13737	/	00009d2f6c9d1c7756033694a2a21ec6	2020-03-16	1
13738	/post/Implementing-an-ActionListener-interface-176	6a6e2760177947ac10755b561137414f	2020-03-16	1
13739	/	6a6e2760177947ac10755b561137414f	2020-03-16	1
13740	/	450a34983ef77f14564dcbcb0f721f5a	2020-03-25	1
13741	/user/settings	ac5bb9fd5d15f4d381a4892f91621b42	2020-03-25	1
13742	/user/danutu	ac5bb9fd5d15f4d381a4892f91621b42	2020-03-25	1
13743	/user/settings	ac5bb9fd5d15f4d381a4892f91621b42	2020-03-25	1
13744	/post/How-we-can-overcome-distractions-and-stay-focused-as-developers-155	28ccb6e9b501bd077b14c073f1f7ead2	2020-03-25	1
13745	/	28ccb6e9b501bd077b14c073f1f7ead2	2020-03-25	1
13746	/user/danutu	28ccb6e9b501bd077b14c073f1f7ead2	2020-03-25	1
13747	/user/danutu	28ccb6e9b501bd077b14c073f1f7ead2	2020-03-25	1
13748	/	28ccb6e9b501bd077b14c073f1f7ead2	2020-03-25	1
13749	/post/How-we-can-overcome-distractions-and-stay-focused-as-developers-155	4712579f3427414b254a44f7f550a313	2020-03-25	1
13750	/	4712579f3427414b254a44f7f550a313	2020-03-25	1
13751	/post/Implementing-an-ActionListener-interface-176	e93cab5599fd89d84b8ed30349363cb6	2020-03-25	1
13752	/newpost	e93cab5599fd89d84b8ed30349363cb6	2020-03-25	1
13753	/	4d19b70ac2c7772f74d1535e54ceb768	2020-03-25	1
13754	/post/How-to-compute-distance-from-elements-of-an-array-in-python-13	4d19b70ac2c7772f74d1535e54ceb768	2020-03-25	1
13755	/admin	37a3f298f2e7d51c4a46dba197bbcaf7	2020-03-25	1
13756	/user/settings	37a3f298f2e7d51c4a46dba197bbcaf7	2020-03-25	1
13757	/	37a3f298f2e7d51c4a46dba197bbcaf7	2020-03-25	1
13758	/	4f2f051b4f32b4214a0a6ff607cded8e	2020-03-25	1
13759	/user/settings	6219edc43cada59b7dc07c4e1847993a	2020-03-25	1
13760	/user/settings	f0b6d66d174cffe83e6b484bd66ebe45	2020-03-25	1
13761	/user/danutu	079c427872d4714fd29f669ca2bc02ae	2020-03-26	1
13762	/	079c427872d4714fd29f669ca2bc02ae	2020-03-26	1
13763	/user/danutu	079c427872d4714fd29f669ca2bc02ae	2020-03-26	1
13764	/	079c427872d4714fd29f669ca2bc02ae	2020-03-26	1
13765	/user/danutu	079c427872d4714fd29f669ca2bc02ae	2020-03-26	1
13766	/user/settings	1bb1aa022a7caec142dbacad318a46aa	2020-03-26	1
13767	/user/danutu	1bb1aa022a7caec142dbacad318a46aa	2020-03-26	1
13768	/user/settings	4e281b418e9944b9b12ed2f974d8c00d	2020-03-26	1
13769	/	dab7f52413e6f02aedf7d98726acf0ba	2020-03-26	1
13770	/user/danutu	dab7f52413e6f02aedf7d98726acf0ba	2020-03-26	1
13771	/user/settings	f3f78dc47b5ac28f7af3c4a2ed51f221	2020-03-26	1
13772	/user/alessandrocrt	f3f78dc47b5ac28f7af3c4a2ed51f221	2020-03-26	1
13773	/user/danutu	c2697cd3cbe5db76a7757fd00f10acbc	2020-03-26	1
13774	/newpost	c2697cd3cbe5db76a7757fd00f10acbc	2020-03-26	1
13775	/	c2697cd3cbe5db76a7757fd00f10acbc	2020-03-26	1
13776	/user/danutu	c2816839ea7fc4186480c37d178aa9d9	2020-03-26	1
13777	/user/danutu	9cedd6811f9753694dc37f34da95730f	2020-03-26	1
13778	/	14d9bdcb6223a64dfb2e21d14e328e09	2020-03-26	1
13779	/post/Implementing-an-ActionListener-interface-176	f1f43b36a699958858f09e3b096bc0e5	2020-04-10	1
13780	/	f1f43b36a699958858f09e3b096bc0e5	2020-04-10	1
13781	/post/Implementing-an-ActionListener-interface-176	8d78036b3bc8cb32a41117336bdda2dd	2020-04-10	1
13782	/post/Implementing-an-ActionListener-interface-176	7aac48c21f8c7aed6bfe07be9b059fca	2020-04-10	1
13783	/	7aac48c21f8c7aed6bfe07be9b059fca	2020-04-10	1
13786	/user/filipp0	7da615c25f340092684b851023816d6e	2020-04-10	1
13787	/	7da615c25f340092684b851023816d6e	2020-04-10	1
13788	/user/settings	7da615c25f340092684b851023816d6e	2020-04-10	1
13789	/	d87074f7d53c18283d90ed1e1eef0d26	2020-04-10	1
13790	/post/Implementing-an-ActionListener-interface-176	367d97b07d33c330eea3b875328c79da	2020-04-10	1
13791	/newpost	367d97b07d33c330eea3b875328c79da	2020-04-10	1
13792	/discuss	367d97b07d33c330eea3b875328c79da	2020-04-10	1
13793	/questions	367d97b07d33c330eea3b875328c79da	2020-04-10	1
13794	/	367d97b07d33c330eea3b875328c79da	2020-04-10	1
13795	/user/filipp0	4d5a6e6dabab7edfd29a063fac1f1746	2020-04-10	1
13796	/	4d5a6e6dabab7edfd29a063fac1f1746	2020-04-10	1
13798	/	1159af4629cd7b83a295cb320a816158	2020-04-10	1
13797	/post/Implementing-an-ActionListener-interface-176	4d5a6e6dabab7edfd29a063fac1f1746	2020-04-10	1
13799	/post/Implementing-an-ActionListener-interface-176	d3800b1fb4f5b803e215d117ed1329c6	2020-04-10	1
13802	/post/edit/Done-it's-better-than-Perfect-115	fede59716f9605e66c178e599efcf18c	2020-04-10	1
13803	/post/Done-it's-better-than-Perfect-115	fede59716f9605e66c178e599efcf18c	2020-04-10	1
13807	/post/Done-it's-better-than-Perfect-115	c9a2ffb6fbfc237837803098d8bf1887	2020-04-10	1
13816	/	d1be8d94c22855580b07bec0734c9fae	2020-04-10	1
13800	/user/settings	d3800b1fb4f5b803e215d117ed1329c6	2020-04-10	1
13801	/post/Done-it's-better-than-Perfect-115	fede59716f9605e66c178e599efcf18c	2020-04-10	1
13804	/	fede59716f9605e66c178e599efcf18c	2020-04-10	1
13805	/post/Done-it's-better-than-Perfect-115	d0ea72919ed151e7d3daa3ffc12d1655	2020-04-10	1
13806	/post/Done-it's-better-than-Perfect-115	d0ea72919ed151e7d3daa3ffc12d1655	2020-04-10	1
13808	/	c9a2ffb6fbfc237837803098d8bf1887	2020-04-10	1
13809	/post/How-to-compute-distance-from-elements-of-an-array-in-python-13	d7f55f6e8961552b25d031dfe0f7a3de	2020-04-10	1
13810	/post/edit/How-to-compute-distance-from-elements-of-an-array-in-python-13	d7f55f6e8961552b25d031dfe0f7a3de	2020-04-10	1
13811	/post/How-to-compute-distance-from-elements-of-an-array-in-python-13	d7f55f6e8961552b25d031dfe0f7a3de	2020-04-10	1
13812	/	61f81b5ed349a1c991acc685511a7374	2020-04-10	1
13813	/user/settings	d1be8d94c22855580b07bec0734c9fae	2020-04-10	1
13814	/	d1be8d94c22855580b07bec0734c9fae	2020-04-10	1
13815	/post/Implementing-an-ActionListener-interface-176	d1be8d94c22855580b07bec0734c9fae	2020-04-10	1
13817	/user/settings	d1be8d94c22855580b07bec0734c9fae	2020-04-10	1
13818	/	d1be8d94c22855580b07bec0734c9fae	2020-04-10	1
13819	/post/Implementing-an-ActionListener-interface-176	0a53d2b5b16deb1bf7d7bd04a714629f	2020-04-10	1
13820	/	0a53d2b5b16deb1bf7d7bd04a714629f	2020-04-10	1
13821	/questions	5951fb31dca5808cdb127533a2297f82	2020-04-10	1
13822	/tutorials	5951fb31dca5808cdb127533a2297f82	2020-04-10	1
13823	/questions	5951fb31dca5808cdb127533a2297f82	2020-04-10	1
13824	/	5951fb31dca5808cdb127533a2297f82	2020-04-10	1
13825	/	5951fb31dca5808cdb127533a2297f82	2020-04-10	1
13826	/post/Spy-on-the-DOM-97	1896a5a2b0e6bc2a36c61990627e6ea5	2020-04-10	1
13827	/post/Spy-on-the-DOM-97	1896a5a2b0e6bc2a36c61990627e6ea5	2020-04-10	1
13828	/post/Spy-on-the-DOM-97	1896a5a2b0e6bc2a36c61990627e6ea5	2020-04-10	1
13829	/	e5bc20bf147d2021eb98e2c60d1bb572	2020-04-10	1
13830	/post/How-we-can-overcome-distractions-and-stay-focused-as-developers-155	e5bc20bf147d2021eb98e2c60d1bb572	2020-04-10	1
13831	/	d638f60853dc2b5626a4eb2427b06d99	2020-04-11	1
13832	/questions	910f5ed34ef938258d2d3c3088359669	2020-04-11	1
13833	/tutorials	15d2016613d973642a8b1b715d65484d	2020-04-11	1
13834	/post/somma-79	15d2016613d973642a8b1b715d65484d	2020-04-11	1
13835	/	15d2016613d973642a8b1b715d65484d	2020-04-11	1
13836	/user/danutu	cc4aee35414516eef1c1bfd668122e34	2020-04-11	1
13837	/	cc4aee35414516eef1c1bfd668122e34	2020-04-11	1
13838	/post/Implementing-an-ActionListener-interface-176	cc4aee35414516eef1c1bfd668122e34	2020-04-11	1
13839	/	cc4aee35414516eef1c1bfd668122e34	2020-04-11	1
13840	/saved	f2b2b653b3e77d60f1ec65cbdb51c780	2020-04-11	1
13841	/	f2b2b653b3e77d60f1ec65cbdb51c780	2020-04-11	1
13842	/post/Implementing-an-ActionListener-interface-176	83fd40415eaa1f73b9d10865d5991efc	2020-04-11	1
13843	/	83fd40415eaa1f73b9d10865d5991efc	2020-04-11	1
13844	/	67c003fd9b4630e08c114bb41cb5f598	2020-04-11	1
13845	/user/settings	9b5a02ea24692d61d76f1abf4ce43f36	2020-04-11	1
13846	/user/danutu	9b5a02ea24692d61d76f1abf4ce43f36	2020-04-11	1
13847	/post/Hello-194	3b9f80b07535223afc6ad480892ee79c	2020-04-11	1
13848	/user/danutu	3b9f80b07535223afc6ad480892ee79c	2020-04-11	1
13849	/	3b9f80b07535223afc6ad480892ee79c	2020-04-11	1
13850	/discuss	e0041032417cdb5053f54c04a35486d3	2020-04-11	1
13851	/post/Implementing-an-ActionListener-interface-176	6661193d93f0ac9324a37fb007604efe	2020-04-11	1
13852	/user/filipp0	6661193d93f0ac9324a37fb007604efe	2020-04-11	1
13853	/post/Implementing-an-ActionListener-interface-176	6661193d93f0ac9324a37fb007604efe	2020-04-11	1
13854	/	4ed0675c05d7b6871b8bb560302e55bf	2020-04-11	1
13855	/post/How-create-a-banner-for-a-website-91	e4ef65740aaa94e124bd4e6bb58de710	2020-04-11	1
13856	/	e4ef65740aaa94e124bd4e6bb58de710	2020-04-11	1
13857	/post/How-to-iterate-through-a-specific-key-value-pair-in-array-75	b645ca62ba9ab8bde627aa5359a82d5f	2020-04-11	1
13858	/	47b9008c5f865cfd6594af4145ab0d6a	2020-04-11	1
13859	/admin	47b9008c5f865cfd6594af4145ab0d6a	2020-04-11	1
13860	/admin/	47b9008c5f865cfd6594af4145ab0d6a	2020-04-11	1
13861	/admin/	47b9008c5f865cfd6594af4145ab0d6a	2020-04-11	1
13862	/post/What's-Wrong-with-CSS-189	45046e5040c2902156ebe242f803e1f1	2020-04-11	1
13863	/user/settings	adadbfb27f716dd8c8028bf48e2420af	2020-04-11	1
13864	/user/danutu	b2de92ff56cdee034bee3557a07469a3	2020-04-11	1
13865	/user/settings	b667e044a0447a46e061cb89fe9be216	2020-04-11	1
13866	/	ba8a2f8f048831225d1e2cdb8217c91d	2020-04-11	1
13867	/post/Implementing-an-ActionListener-interface-176	d16d08ca93039966fa6568cade8c54f7	2020-04-11	1
13868	/	d16d08ca93039966fa6568cade8c54f7	2020-04-11	1
13869	/post/Implementing-an-ActionListener-interface-176	d16d08ca93039966fa6568cade8c54f7	2020-04-11	1
13870	/	ad0f65ac704c32060bcd84d2f6f690ef	2020-04-11	1
13871	/post/Implementing-an-ActionListener-interface-176	9ac71895983b9d620dbefa3c6f5e7854	2020-04-11	1
13872	/	3da745adcb87e02fd8d67df11b70663a	2020-04-11	1
13873	/post/Implementing-an-ActionListener-interface-176	b76e3815f6eb50b2c3f788c7dad9319a	2020-04-11	1
13874	/	b76e3815f6eb50b2c3f788c7dad9319a	2020-04-11	1
13875	/	1a02f231d3cfcaf922dd429875e490d1	2020-04-11	1
13876	/post/How-we-can-overcome-distractions-and-stay-focused-as-developers-155	2c66f3884763e8c6e80e0a08869ffcf2	2020-04-11	1
13877	/	2c66f3884763e8c6e80e0a08869ffcf2	2020-04-11	1
13878	/saved	dab149439983d6984e4160336eacb345	2020-04-11	1
13879	/	dab149439983d6984e4160336eacb345	2020-04-11	1
13880	/post/Implementing-an-ActionListener-interface-176	417c1c757ba696fc6e7a8313b5b91bf1	2020-04-11	1
13881	/	56d2a89e28d04feaaf4ecc461a234f33	2020-04-11	1
13882	/post/How-create-a-banner-for-a-website-91	56d2a89e28d04feaaf4ecc461a234f33	2020-04-11	1
13883	/	56d2a89e28d04feaaf4ecc461a234f33	2020-04-11	1
13884	/user/danutu	56d2a89e28d04feaaf4ecc461a234f33	2020-04-11	1
13885	/	56d2a89e28d04feaaf4ecc461a234f33	2020-04-11	1
13886	/user/danutu	9503c630f0807645bf2f203a3896670a	2020-04-11	1
13887	/discuss	96a742684b958b3ce2d686e40959af5e	2020-04-11	1
13888	/saved	5dabcfb30b4fb8a42fb8be0d70783aa4	2020-04-11	1
13889	/discuss	5dabcfb30b4fb8a42fb8be0d70783aa4	2020-04-11	1
13890	/post/Implementing-an-ActionListener-interface-176	edb63823e290cf117cb565b22e626a92	2020-04-11	1
13892	/post/How-we-can-overcome-distractions-and-stay-focused-as-developers-155	2a766f94ff77d74cdfc1677afee26534	2020-04-11	1
13894	/post/How-we-can-overcome-distractions-and-stay-focused-as-developers-155	2a766f94ff77d74cdfc1677afee26534	2020-04-11	1
13891	/	deea0bc630b6fa75bcd765c9bbaf8fdf	2020-04-11	1
13893	/post/How-we-can-overcome-distractions-and-stay-focused-as-developers-155	2a766f94ff77d74cdfc1677afee26534	2020-04-11	1
13895	/	add4ebef64ae21a6ac30b83d5b61f061	2020-04-11	1
\.


--
-- Data for Name: analyze_session; Type: TABLE DATA; Schema: public; Owner: danutu
--

COPY public.analyze_session (id, ip, continent, country, city, os, browser, session, created_at, bot, lang, referer, iso_code) FROM stdin;
20813	151.76.195.253	Europe	Italy	Pescara	Mac OS	Chrome	072185756b4724844a6d5fc9d8febe75	2020-03-11	f	none	Direct	IT
20814	151.76.195.253	Europe	Italy	Pescara	Mac OS	Chrome	758ab794659ed4ed55dfdc19789097fa	2020-03-11	f	none	Direct	IT
20815	151.76.195.253	Europe	Italy	Pescara	Mac OS	Chrome	8117c73a555c93f5dbfece42e74b68d9	2020-03-12	f	none	Direct	IT
20816	151.76.195.253	Europe	Italy	Pescara	Mac OS	Chrome	4efce82dbda40d5812bb723473f40d07	2020-03-13	f	none	Direct	IT
20817	151.76.195.253	Europe	Italy	Pescara	Mac OS	Chrome	4efce82dbda40d5812bb723473f40d07	2020-03-13	f	none	Direct	IT
20818	151.76.195.253	Europe	Italy	Pescara	Mac OS	Chrome	4efce82dbda40d5812bb723473f40d07	2020-03-13	f	none	Direct	IT
20819	151.76.195.253	Europe	Italy	Pescara	Mac OS	Chrome	4efce82dbda40d5812bb723473f40d07	2020-03-13	f	none	Direct	IT
20820	151.76.195.253	Europe	Italy	Pescara	Mac OS	Chrome	0dae2e078b39a5cd42991214a4128881	2020-03-13	f	none	Direct	IT
20821	151.76.195.253	Europe	Italy	Pescara	Mac OS	Chrome	0dae2e078b39a5cd42991214a4128881	2020-03-13	f	none	Direct	IT
20822	151.76.195.253	Europe	Italy	Pescara	Mac OS	Chrome	81cfd9de9a5443b9a49f759201d263bd	2020-03-13	f	none	Direct	IT
20823	151.76.195.253	Europe	Italy	Pescara	Mac OS	Chrome	97651cbfe6f0bd35137a403640ac511f	2020-03-13	f	none	Direct	IT
20824	151.76.195.253	Europe	Italy	Pescara	Mac OS	Chrome	3f93beaf0ddce5c4f8ee92b4640bd0ea	2020-03-14	f	none	Direct	IT
20825	151.76.195.253	Europe	Italy	Pescara	Mac OS	Chrome	28f81a8f1a6fb2ec2d0b4ca3d4e679c3	2020-03-14	f	none	\N	IT
20826	151.76.195.253	Europe	Italy	Pescara	Mac OS	Chrome	28f81a8f1a6fb2ec2d0b4ca3d4e679c3	2020-03-14	f	none	Direct	IT
20827	151.76.195.253	Europe	Italy	Pescara	Mac OS	Chrome	28f81a8f1a6fb2ec2d0b4ca3d4e679c3	2020-03-14	f	none	Direct	IT
20828	151.76.195.253	Europe	Italy	Pescara	Mac OS	Chrome	28f81a8f1a6fb2ec2d0b4ca3d4e679c3	2020-03-14	f	none	Direct	IT
20829	151.76.195.253	Europe	Italy	Pescara	Mac OS	Chrome	28f81a8f1a6fb2ec2d0b4ca3d4e679c3	2020-03-14	f	none	Direct	IT
20830	151.76.195.253	Europe	Italy	Pescara	Mac OS	Chrome	64d269b352606ad8b59874cd55f52556	2020-03-14	f	none	\N	IT
20831	151.76.195.253	Europe	Italy	Pescara	Mac OS	Chrome	64d269b352606ad8b59874cd55f52556	2020-03-14	f	none	\N	IT
20832	151.76.195.253	Europe	Italy	Pescara	Mac OS	Chrome	c6c5c0e35a15434c382d8b95b0beb5a1	2020-03-14	f	none	\N	IT
20833	151.76.195.253	Europe	Italy	Pescara	Mac OS	Chrome	c6c5c0e35a15434c382d8b95b0beb5a1	2020-03-14	f	none	Direct	IT
20834	151.76.195.253	Europe	Italy	Pescara	Mac OS	Chrome	164d9883a715b4a62821a25ac1b01ee9	2020-03-14	f	none	Direct	IT
20835	151.76.195.253	Europe	Italy	Pescara	Mac OS	Chrome	3c127d66d5db21bcc3fdeabf6da27a41	2020-03-14	f	none	\N	IT
20836	151.76.195.253	Europe	Italy	Pescara	Mac OS	Chrome	be7fc79db8724259d7cbb35a4f083bda	2020-03-14	f	none	Direct	IT
20837	151.76.195.253	Europe	Italy	Pescara	Mac OS	Chrome	222189a3cb024baad10a34907237e22f	2020-03-15	f	none	\N	IT
20838	151.76.195.253	Europe	Italy	Pescara	Mac OS	Chrome	222189a3cb024baad10a34907237e22f	2020-03-15	f	none	Direct	IT
20839	151.76.195.253	Europe	Italy	Pescara	Mac OS	Chrome	44c8de6c32c4d0c84047ace9b317ab38	2020-03-15	f	none	Direct	IT
20840	151.76.195.253	Europe	Italy	Pescara	Mac OS	Chrome	44c8de6c32c4d0c84047ace9b317ab38	2020-03-15	f	none	Direct	IT
20841	151.76.195.253	Europe	Italy	Pescara	Mac OS	Chrome	44c8de6c32c4d0c84047ace9b317ab38	2020-03-15	f	none	Direct	IT
20842	151.76.195.253	Europe	Italy	Pescara	Mac OS	Chrome	774dcc2f65fcdec1604cbdd2028c3579	2020-03-15	f	none	Direct	IT
20843	151.76.195.253	Europe	Italy	Pescara	Mac OS	Chrome	774dcc2f65fcdec1604cbdd2028c3579	2020-03-15	f	none	Direct	IT
20844	151.76.195.253	Europe	Italy	Pescara	Mac OS	Chrome	774dcc2f65fcdec1604cbdd2028c3579	2020-03-15	f	none	Direct	IT
20845	151.76.195.253	Europe	Italy	Pescara	Mac OS	Chrome	bb8f12e12b4b42ed98fee81df20afdfe	2020-03-15	f	none	\N	IT
20846	151.76.195.253	Europe	Italy	Pescara	Mac OS	Chrome	3f39510cee2563a7e6c40f01618bf717	2020-03-15	f	none	\N	IT
20847	151.76.195.253	Europe	Italy	Pescara	Mac OS	Chrome	3f39510cee2563a7e6c40f01618bf717	2020-03-15	f	none	Direct	IT
20848	151.76.195.253	Europe	Italy	Pescara	Mac OS	Chrome	3f39510cee2563a7e6c40f01618bf717	2020-03-15	f	none	Direct	IT
20849	151.76.195.253	Europe	Italy	Pescara	Mac OS	Chrome	3f39510cee2563a7e6c40f01618bf717	2020-03-15	f	none	Direct	IT
20850	151.76.195.253	Europe	Italy	Pescara	Mac OS	Chrome	6d4d4c0c9c26dba23d9a6cd6b83f41fb	2020-03-15	f	none	\N	IT
20851	151.76.195.253	Europe	Italy	Pescara	Mac OS	Chrome	6d4d4c0c9c26dba23d9a6cd6b83f41fb	2020-03-15	f	none	Direct	IT
20852	151.76.195.253	Europe	Italy	Pescara	Mac OS	Chrome	3b9851091bc141f44ded2f8971b1d407	2020-03-16	f	none	\N	IT
20853	151.76.195.253	Europe	Italy	Pescara	Mac OS	Chrome	3b9851091bc141f44ded2f8971b1d407	2020-03-16	f	none	Direct	IT
20854	151.76.195.253	Europe	Italy	Pescara	Mac OS	Chrome	33cfac615cb8a6e4fd2a7e5292042ba2	2020-03-16	f	none	\N	IT
20855	151.76.195.253	Europe	Italy	Pescara	Mac OS	Chrome	ebfdc9cba4260a51c74ca3922b01d6a6	2020-03-16	f	none	\N	IT
20856	151.76.195.253	Europe	Italy	Pescara	Mac OS	Chrome	00009d2f6c9d1c7756033694a2a21ec6	2020-03-16	f	none	Direct	IT
20857	151.76.195.253	Europe	Italy	Pescara	Mac OS	Chrome	00009d2f6c9d1c7756033694a2a21ec6	2020-03-16	f	none	Direct	IT
20858	151.76.195.253	Europe	Italy	Pescara	Mac OS	Chrome	00009d2f6c9d1c7756033694a2a21ec6	2020-03-16	f	none	Direct	IT
20859	151.76.195.253	Europe	Italy	Pescara	Mac OS	Chrome	00009d2f6c9d1c7756033694a2a21ec6	2020-03-16	f	none	Direct	IT
20860	151.76.195.253	Europe	Italy	Pescara	Mac OS	Chrome	6a6e2760177947ac10755b561137414f	2020-03-16	f	none	\N	IT
20861	151.76.195.253	Europe	Italy	Pescara	Mac OS	Chrome	6a6e2760177947ac10755b561137414f	2020-03-16	f	none	\N	IT
20862	151.76.195.253	Europe	Italy	Pescara	Mac OS	Chrome	450a34983ef77f14564dcbcb0f721f5a	2020-03-25	f	none	\N	IT
20863	151.76.195.253	Europe	Italy	Pescara	Mac OS	Chrome	ac5bb9fd5d15f4d381a4892f91621b42	2020-03-25	f	none	Direct	IT
20864	151.76.195.253	Europe	Italy	Pescara	Mac OS	Chrome	ac5bb9fd5d15f4d381a4892f91621b42	2020-03-25	f	none	\N	IT
20865	151.76.195.253	Europe	Italy	Pescara	Mac OS	Chrome	ac5bb9fd5d15f4d381a4892f91621b42	2020-03-25	f	none	Direct	IT
20866	151.76.195.253	Europe	Italy	Pescara	Mac OS	Chrome	28ccb6e9b501bd077b14c073f1f7ead2	2020-03-25	f	none	\N	IT
20867	151.76.195.253	Europe	Italy	Pescara	Mac OS	Chrome	28ccb6e9b501bd077b14c073f1f7ead2	2020-03-25	f	none	\N	IT
20868	151.76.195.253	Europe	Italy	Pescara	Mac OS	Chrome	28ccb6e9b501bd077b14c073f1f7ead2	2020-03-25	f	none	Direct	IT
20869	151.76.195.253	Europe	Italy	Pescara	Mac OS	Chrome	28ccb6e9b501bd077b14c073f1f7ead2	2020-03-25	f	none	Direct	IT
20870	151.76.195.253	Europe	Italy	Pescara	Mac OS	Chrome	28ccb6e9b501bd077b14c073f1f7ead2	2020-03-25	f	none	Direct	IT
20871	151.76.195.253	Europe	Italy	Pescara	Mac OS	Chrome	4712579f3427414b254a44f7f550a313	2020-03-25	f	none	\N	IT
20872	151.76.195.253	Europe	Italy	Pescara	Mac OS	Chrome	4712579f3427414b254a44f7f550a313	2020-03-25	f	none	Direct	IT
20873	151.76.195.253	Europe	Italy	Pescara	Mac OS	Chrome	e93cab5599fd89d84b8ed30349363cb6	2020-03-25	f	none	\N	IT
20874	151.76.195.253	Europe	Italy	Pescara	Mac OS	Chrome	e93cab5599fd89d84b8ed30349363cb6	2020-03-25	f	none	Direct	IT
20875	151.76.195.253	Europe	Italy	Pescara	Mac OS	Chrome	4d19b70ac2c7772f74d1535e54ceb768	2020-03-25	f	none	Direct	IT
20876	151.76.195.253	Europe	Italy	Pescara	Mac OS	Chrome	4d19b70ac2c7772f74d1535e54ceb768	2020-03-25	f	none	Direct	IT
20877	151.76.195.253	Europe	Italy	Pescara	Mac OS	Chrome	37a3f298f2e7d51c4a46dba197bbcaf7	2020-03-25	f	none	\N	IT
20878	151.76.195.253	Europe	Italy	Pescara	Mac OS	Chrome	37a3f298f2e7d51c4a46dba197bbcaf7	2020-03-25	f	none	Direct	IT
20879	151.76.195.253	Europe	Italy	Pescara	Mac OS	Chrome	37a3f298f2e7d51c4a46dba197bbcaf7	2020-03-25	f	none	Direct	IT
20880	151.76.195.253	Europe	Italy	Pescara	Mac OS	Chrome	4f2f051b4f32b4214a0a6ff607cded8e	2020-03-25	f	none	\N	IT
20881	151.76.195.253	Europe	Italy	Pescara	Mac OS	Chrome	6219edc43cada59b7dc07c4e1847993a	2020-03-25	f	none	\N	IT
20882	151.76.195.253	Europe	Italy	Pescara	Mac OS	Chrome	f0b6d66d174cffe83e6b484bd66ebe45	2020-03-25	f	none	\N	IT
20883	151.76.195.253	Europe	Italy	Pescara	Mac OS	Chrome	079c427872d4714fd29f669ca2bc02ae	2020-03-26	f	none	\N	IT
20884	151.76.195.253	Europe	Italy	Pescara	Mac OS	Chrome	079c427872d4714fd29f669ca2bc02ae	2020-03-26	f	none	Direct	IT
20885	151.76.195.253	Europe	Italy	Pescara	Mac OS	Chrome	079c427872d4714fd29f669ca2bc02ae	2020-03-26	f	none	Direct	IT
20886	151.76.195.253	Europe	Italy	Pescara	Mac OS	Chrome	079c427872d4714fd29f669ca2bc02ae	2020-03-26	f	none	Direct	IT
20887	151.76.195.253	Europe	Italy	Pescara	Mac OS	Chrome	079c427872d4714fd29f669ca2bc02ae	2020-03-26	f	none	Direct	IT
20888	151.76.195.253	Europe	Italy	Pescara	Mac OS	Chrome	1bb1aa022a7caec142dbacad318a46aa	2020-03-26	f	none	Direct	IT
20889	151.76.195.253	Europe	Italy	Pescara	Mac OS	Chrome	1bb1aa022a7caec142dbacad318a46aa	2020-03-26	f	none	Direct	IT
20890	151.76.195.253	Europe	Italy	Pescara	Mac OS	Chrome	4e281b418e9944b9b12ed2f974d8c00d	2020-03-26	f	none	\N	IT
20891	151.76.195.253	Europe	Italy	Pescara	Mac OS	Chrome	dab7f52413e6f02aedf7d98726acf0ba	2020-03-26	f	none	Direct	IT
20892	151.76.195.253	Europe	Italy	Pescara	Mac OS	Chrome	dab7f52413e6f02aedf7d98726acf0ba	2020-03-26	f	none	Direct	IT
20893	151.76.195.253	Europe	Italy	Pescara	Mac OS	Chrome	f3f78dc47b5ac28f7af3c4a2ed51f221	2020-03-26	f	none	Direct	IT
20894	151.76.195.253	Europe	Italy	Pescara	Mac OS	Chrome	f3f78dc47b5ac28f7af3c4a2ed51f221	2020-03-26	f	none	Direct	IT
20895	151.76.195.253	Europe	Italy	Pescara	Mac OS	Chrome	c2697cd3cbe5db76a7757fd00f10acbc	2020-03-26	f	none	Direct	IT
20896	151.76.195.253	Europe	Italy	Pescara	Mac OS	Chrome	c2697cd3cbe5db76a7757fd00f10acbc	2020-03-26	f	none	Direct	IT
20897	151.76.195.253	Europe	Italy	Pescara	Mac OS	Chrome	c2697cd3cbe5db76a7757fd00f10acbc	2020-03-26	f	none	Direct	IT
20898	151.76.195.253	Europe	Italy	Pescara	Mac OS	Chrome	c2816839ea7fc4186480c37d178aa9d9	2020-03-26	f	none	\N	IT
20899	151.76.195.253	Europe	Italy	Pescara	Mac OS	Chrome	9cedd6811f9753694dc37f34da95730f	2020-03-26	f	none	\N	IT
20900	151.76.195.253	Europe	Italy	Pescara	Mac OS	Chrome	14d9bdcb6223a64dfb2e21d14e328e09	2020-03-26	f	none	Direct	IT
20901	151.76.195.253	Europe	Italy	Pescara	Mac OS	ChromiumEdge	f1f43b36a699958858f09e3b096bc0e5	2020-04-10	f	none	\N	IT
20902	151.76.195.253	Europe	Italy	Pescara	Mac OS	ChromiumEdge	f1f43b36a699958858f09e3b096bc0e5	2020-04-10	f	none	Direct	IT
20903	151.76.195.253	Europe	Italy	Pescara	Mac OS	ChromiumEdge	8d78036b3bc8cb32a41117336bdda2dd	2020-04-10	f	none	\N	IT
20904	151.76.195.253	Europe	Italy	Pescara	Mac OS	ChromiumEdge	7aac48c21f8c7aed6bfe07be9b059fca	2020-04-10	f	none	\N	IT
20905	151.76.195.253	Europe	Italy	Pescara	Mac OS	ChromiumEdge	7aac48c21f8c7aed6bfe07be9b059fca	2020-04-10	f	none	Direct	IT
20906	151.76.195.253	Europe	Italy	Pescara	Mac OS	ChromiumEdge	7aac48c21f8c7aed6bfe07be9b059fca	2020-04-10	f	none	Direct	IT
20907	151.76.195.253	Europe	Italy	Pescara	Mac OS	ChromiumEdge	7da615c25f340092684b851023816d6e	2020-04-10	f	none	\N	IT
20908	151.76.195.253	Europe	Italy	Pescara	Mac OS	ChromiumEdge	7da615c25f340092684b851023816d6e	2020-04-10	f	none	Direct	IT
20909	151.76.195.253	Europe	Italy	Pescara	Mac OS	ChromiumEdge	7da615c25f340092684b851023816d6e	2020-04-10	f	none	Direct	IT
20910	151.76.195.253	Europe	Italy	Pescara	Mac OS	ChromiumEdge	7da615c25f340092684b851023816d6e	2020-04-10	f	none	\N	IT
20911	151.76.195.253	Europe	Italy	Pescara	Mac OS	ChromiumEdge	d87074f7d53c18283d90ed1e1eef0d26	2020-04-10	f	none	\N	IT
20912	151.76.195.253	Europe	Italy	Pescara	Mac OS	ChromiumEdge	367d97b07d33c330eea3b875328c79da	2020-04-10	f	none	Direct	IT
20913	151.76.195.253	Europe	Italy	Pescara	Mac OS	ChromiumEdge	367d97b07d33c330eea3b875328c79da	2020-04-10	f	none	Direct	IT
20914	151.76.195.253	Europe	Italy	Pescara	Mac OS	ChromiumEdge	367d97b07d33c330eea3b875328c79da	2020-04-10	f	none	Direct	IT
20915	151.76.195.253	Europe	Italy	Pescara	Mac OS	ChromiumEdge	367d97b07d33c330eea3b875328c79da	2020-04-10	f	none	Direct	IT
20916	151.76.195.253	Europe	Italy	Pescara	Mac OS	ChromiumEdge	367d97b07d33c330eea3b875328c79da	2020-04-10	f	none	Direct	IT
20917	151.76.195.253	Europe	Italy	Pescara	Mac OS	ChromiumEdge	4d5a6e6dabab7edfd29a063fac1f1746	2020-04-10	f	none	\N	IT
20918	151.76.195.253	Europe	Italy	Pescara	Mac OS	ChromiumEdge	4d5a6e6dabab7edfd29a063fac1f1746	2020-04-10	f	none	Direct	IT
20919	151.76.195.253	Europe	Italy	Pescara	Mac OS	ChromiumEdge	4d5a6e6dabab7edfd29a063fac1f1746	2020-04-10	f	none	\N	IT
20920	151.76.195.253	Europe	Italy	Pescara	Mac OS	ChromiumEdge	1159af4629cd7b83a295cb320a816158	2020-04-10	f	none	Direct	IT
20921	151.76.195.253	Europe	Italy	Pescara	Mac OS	ChromiumEdge	d3800b1fb4f5b803e215d117ed1329c6	2020-04-10	f	none	Direct	IT
20922	151.76.195.253	Europe	Italy	Pescara	Mac OS	ChromiumEdge	d3800b1fb4f5b803e215d117ed1329c6	2020-04-10	f	none	Direct	IT
20923	151.76.195.253	Europe	Italy	Pescara	Mac OS	ChromiumEdge	fede59716f9605e66c178e599efcf18c	2020-04-10	f	none	Direct	IT
20924	151.76.195.253	Europe	Italy	Pescara	Mac OS	ChromiumEdge	fede59716f9605e66c178e599efcf18c	2020-04-10	f	none	Direct	IT
20925	151.76.195.253	Europe	Italy	Pescara	Mac OS	ChromiumEdge	fede59716f9605e66c178e599efcf18c	2020-04-10	f	none	Direct	IT
20926	151.76.195.253	Europe	Italy	Pescara	Mac OS	ChromiumEdge	fede59716f9605e66c178e599efcf18c	2020-04-10	f	none	Direct	IT
20927	151.76.195.253	Europe	Italy	Pescara	Mac OS	ChromiumEdge	d0ea72919ed151e7d3daa3ffc12d1655	2020-04-10	f	none	Direct	IT
20928	151.76.195.253	Europe	Italy	Pescara	Mac OS	ChromiumEdge	d0ea72919ed151e7d3daa3ffc12d1655	2020-04-10	f	none	Direct	IT
20929	151.76.195.253	Europe	Italy	Pescara	Mac OS	ChromiumEdge	c9a2ffb6fbfc237837803098d8bf1887	2020-04-10	f	none	Direct	IT
20930	151.76.195.253	Europe	Italy	Pescara	Mac OS	ChromiumEdge	c9a2ffb6fbfc237837803098d8bf1887	2020-04-10	f	none	Direct	IT
20931	151.76.195.253	Europe	Italy	Pescara	Mac OS	ChromiumEdge	d7f55f6e8961552b25d031dfe0f7a3de	2020-04-10	f	none	Direct	IT
20932	151.76.195.253	Europe	Italy	Pescara	Mac OS	ChromiumEdge	d7f55f6e8961552b25d031dfe0f7a3de	2020-04-10	f	none	Direct	IT
20933	151.76.195.253	Europe	Italy	Pescara	Mac OS	ChromiumEdge	d7f55f6e8961552b25d031dfe0f7a3de	2020-04-10	f	none	Direct	IT
20934	151.76.195.253	Europe	Italy	Pescara	Mac OS	ChromiumEdge	61f81b5ed349a1c991acc685511a7374	2020-04-10	f	none	Direct	IT
20935	151.76.195.253	Europe	Italy	Pescara	Mac OS	ChromiumEdge	d1be8d94c22855580b07bec0734c9fae	2020-04-10	f	none	\N	IT
20936	151.76.195.253	Europe	Italy	Pescara	Mac OS	ChromiumEdge	d1be8d94c22855580b07bec0734c9fae	2020-04-10	f	none	Direct	IT
20937	151.76.195.253	Europe	Italy	Pescara	Mac OS	ChromiumEdge	d1be8d94c22855580b07bec0734c9fae	2020-04-10	f	none	Direct	IT
20938	151.76.195.253	Europe	Italy	Pescara	Mac OS	ChromiumEdge	d1be8d94c22855580b07bec0734c9fae	2020-04-10	f	none	Direct	IT
20939	151.76.195.253	Europe	Italy	Pescara	Mac OS	ChromiumEdge	d1be8d94c22855580b07bec0734c9fae	2020-04-10	f	none	Direct	IT
20940	151.76.195.253	Europe	Italy	Pescara	Mac OS	ChromiumEdge	d1be8d94c22855580b07bec0734c9fae	2020-04-10	f	none	Direct	IT
20941	151.76.195.253	Europe	Italy	Pescara	Mac OS	ChromiumEdge	0a53d2b5b16deb1bf7d7bd04a714629f	2020-04-10	f	none	Direct	IT
20942	151.76.195.253	Europe	Italy	Pescara	Mac OS	ChromiumEdge	0a53d2b5b16deb1bf7d7bd04a714629f	2020-04-10	f	none	Direct	IT
20943	151.76.195.253	Europe	Italy	Pescara	Mac OS	ChromiumEdge	5951fb31dca5808cdb127533a2297f82	2020-04-10	f	none	Direct	IT
20944	151.76.195.253	Europe	Italy	Pescara	Mac OS	ChromiumEdge	5951fb31dca5808cdb127533a2297f82	2020-04-10	f	none	Direct	IT
20945	151.76.195.253	Europe	Italy	Pescara	Mac OS	ChromiumEdge	5951fb31dca5808cdb127533a2297f82	2020-04-10	f	none	Direct	IT
20946	151.76.195.253	Europe	Italy	Pescara	Mac OS	ChromiumEdge	5951fb31dca5808cdb127533a2297f82	2020-04-10	f	none	Direct	IT
20947	151.76.195.253	Europe	Italy	Pescara	Mac OS	ChromiumEdge	5951fb31dca5808cdb127533a2297f82	2020-04-10	f	none	\N	IT
20948	151.76.195.253	Europe	Italy	Pescara	Mac OS	ChromiumEdge	1896a5a2b0e6bc2a36c61990627e6ea5	2020-04-10	f	none	Direct	IT
20949	151.76.195.253	Europe	Italy	Pescara	Mac OS	ChromiumEdge	1896a5a2b0e6bc2a36c61990627e6ea5	2020-04-10	f	none	Direct	IT
20950	151.76.195.253	Europe	Italy	Pescara	Mac OS	ChromiumEdge	1896a5a2b0e6bc2a36c61990627e6ea5	2020-04-10	f	none	Direct	IT
20951	151.76.195.253	Europe	Italy	Pescara	Mac OS	ChromiumEdge	e5bc20bf147d2021eb98e2c60d1bb572	2020-04-10	f	none	Direct	IT
20952	151.76.195.253	Europe	Italy	Pescara	Mac OS	ChromiumEdge	e5bc20bf147d2021eb98e2c60d1bb572	2020-04-10	f	none	Direct	IT
20953	151.76.195.253	Europe	Italy	Pescara	Mac OS	ChromiumEdge	d638f60853dc2b5626a4eb2427b06d99	2020-04-11	f	none	Direct	IT
20954	151.76.195.253	Europe	Italy	Pescara	Mac OS	ChromiumEdge	910f5ed34ef938258d2d3c3088359669	2020-04-11	f	none	\N	IT
20955	151.76.195.253	Europe	Italy	Pescara	Mac OS	ChromiumEdge	15d2016613d973642a8b1b715d65484d	2020-04-11	f	none	\N	IT
20956	151.76.195.253	Europe	Italy	Pescara	Mac OS	ChromiumEdge	15d2016613d973642a8b1b715d65484d	2020-04-11	f	none	Direct	IT
20957	151.76.195.253	Europe	Italy	Pescara	Mac OS	ChromiumEdge	15d2016613d973642a8b1b715d65484d	2020-04-11	f	none	Direct	IT
20958	151.76.195.253	Europe	Italy	Pescara	Mac OS	ChromiumEdge	cc4aee35414516eef1c1bfd668122e34	2020-04-11	f	none	\N	IT
20959	151.76.195.253	Europe	Italy	Pescara	Mac OS	ChromiumEdge	cc4aee35414516eef1c1bfd668122e34	2020-04-11	f	none	Direct	IT
20960	151.76.195.253	Europe	Italy	Pescara	Mac OS	ChromiumEdge	cc4aee35414516eef1c1bfd668122e34	2020-04-11	f	none	Direct	IT
20961	151.76.195.253	Europe	Italy	Pescara	Mac OS	ChromiumEdge	cc4aee35414516eef1c1bfd668122e34	2020-04-11	f	none	Direct	IT
20962	151.76.195.253	Europe	Italy	Pescara	Mac OS	ChromiumEdge	f2b2b653b3e77d60f1ec65cbdb51c780	2020-04-11	f	none	\N	IT
20963	151.76.195.253	Europe	Italy	Pescara	Mac OS	ChromiumEdge	f2b2b653b3e77d60f1ec65cbdb51c780	2020-04-11	f	none	\N	IT
20964	151.76.195.253	Europe	Italy	Pescara	Mac OS	ChromiumEdge	83fd40415eaa1f73b9d10865d5991efc	2020-04-11	f	none	\N	IT
20965	151.76.195.253	Europe	Italy	Pescara	Mac OS	ChromiumEdge	83fd40415eaa1f73b9d10865d5991efc	2020-04-11	f	none	Direct	IT
20966	151.76.195.253	Europe	Italy	Pescara	Mac OS	ChromiumEdge	67c003fd9b4630e08c114bb41cb5f598	2020-04-11	f	none	\N	IT
20967	151.76.195.253	Europe	Italy	Pescara	Mac OS	ChromiumEdge	9b5a02ea24692d61d76f1abf4ce43f36	2020-04-11	f	none	Direct	IT
20968	151.76.195.253	Europe	Italy	Pescara	Mac OS	ChromiumEdge	9b5a02ea24692d61d76f1abf4ce43f36	2020-04-11	f	none	Direct	IT
20969	151.76.195.253	Europe	Italy	Pescara	Mac OS	ChromiumEdge	3b9f80b07535223afc6ad480892ee79c	2020-04-11	f	none	Direct	IT
20970	151.76.195.253	Europe	Italy	Pescara	Mac OS	ChromiumEdge	3b9f80b07535223afc6ad480892ee79c	2020-04-11	f	none	Direct	IT
20971	151.76.195.253	Europe	Italy	Pescara	Mac OS	ChromiumEdge	3b9f80b07535223afc6ad480892ee79c	2020-04-11	f	none	Direct	IT
20972	151.76.195.253	Europe	Italy	Pescara	Mac OS	ChromiumEdge	e0041032417cdb5053f54c04a35486d3	2020-04-11	f	none	\N	IT
20973	151.76.195.253	Europe	Italy	Pescara	Mac OS	ChromiumEdge	6661193d93f0ac9324a37fb007604efe	2020-04-11	f	none	\N	IT
20974	151.76.195.253	Europe	Italy	Pescara	Mac OS	ChromiumEdge	6661193d93f0ac9324a37fb007604efe	2020-04-11	f	none	Direct	IT
20975	151.76.195.253	Europe	Italy	Pescara	Mac OS	ChromiumEdge	6661193d93f0ac9324a37fb007604efe	2020-04-11	f	none	Direct	IT
20976	151.76.195.253	Europe	Italy	Pescara	Mac OS	ChromiumEdge	4ed0675c05d7b6871b8bb560302e55bf	2020-04-11	f	none	\N	IT
20977	151.76.195.253	Europe	Italy	Pescara	Mac OS	ChromiumEdge	e4ef65740aaa94e124bd4e6bb58de710	2020-04-11	f	none	\N	IT
20978	151.76.195.253	Europe	Italy	Pescara	Mac OS	ChromiumEdge	e4ef65740aaa94e124bd4e6bb58de710	2020-04-11	f	none	\N	IT
20979	151.76.195.253	Europe	Italy	Pescara	Mac OS	ChromiumEdge	b645ca62ba9ab8bde627aa5359a82d5f	2020-04-11	f	none	Direct	IT
20980	151.76.195.253	Europe	Italy	Pescara	Mac OS	ChromiumEdge	47b9008c5f865cfd6594af4145ab0d6a	2020-04-11	f	none	Direct	IT
20981	151.76.195.253	Europe	Italy	Pescara	Mac OS	ChromiumEdge	47b9008c5f865cfd6594af4145ab0d6a	2020-04-11	f	none	Direct	IT
20982	151.76.195.253	Europe	Italy	Pescara	Mac OS	ChromiumEdge	47b9008c5f865cfd6594af4145ab0d6a	2020-04-11	f	none	Direct	IT
20986	151.76.195.253	Europe	Italy	Pescara	Mac OS	ChromiumEdge	b2de92ff56cdee034bee3557a07469a3	2020-04-11	f	none	Direct	IT
20987	151.76.195.253	Europe	Italy	Pescara	Mac OS	ChromiumEdge	b667e044a0447a46e061cb89fe9be216	2020-04-11	f	none	\N	IT
20983	151.76.195.253	Europe	Italy	Pescara	Mac OS	ChromiumEdge	47b9008c5f865cfd6594af4145ab0d6a	2020-04-11	f	none	\N	IT
20984	151.76.195.253	Europe	Italy	Pescara	Mac OS	ChromiumEdge	45046e5040c2902156ebe242f803e1f1	2020-04-11	f	none	Direct	IT
20985	151.76.195.253	Europe	Italy	Pescara	Mac OS	ChromiumEdge	adadbfb27f716dd8c8028bf48e2420af	2020-04-11	f	none	\N	IT
20988	151.76.195.253	Europe	Italy	Pescara	Mac OS	ChromiumEdge	ba8a2f8f048831225d1e2cdb8217c91d	2020-04-11	f	none	\N	IT
20989	151.76.195.253	Europe	Italy	Pescara	Mac OS	ChromiumEdge	d16d08ca93039966fa6568cade8c54f7	2020-04-11	f	none	\N	IT
20990	151.76.195.253	Europe	Italy	Pescara	Mac OS	ChromiumEdge	d16d08ca93039966fa6568cade8c54f7	2020-04-11	f	none	Direct	IT
20991	151.76.195.253	Europe	Italy	Pescara	Mac OS	ChromiumEdge	d16d08ca93039966fa6568cade8c54f7	2020-04-11	f	none	Direct	IT
20992	151.76.195.253	Europe	Italy	Pescara	Mac OS	ChromiumEdge	ad0f65ac704c32060bcd84d2f6f690ef	2020-04-11	f	none	\N	IT
20993	151.76.195.253	Europe	Italy	Pescara	Mac OS	ChromiumEdge	9ac71895983b9d620dbefa3c6f5e7854	2020-04-11	f	none	\N	IT
20994	151.76.195.253	Europe	Italy	Pescara	Mac OS	ChromiumEdge	3da745adcb87e02fd8d67df11b70663a	2020-04-11	f	none	\N	IT
20995	151.76.195.253	Europe	Italy	Pescara	Mac OS	ChromiumEdge	b76e3815f6eb50b2c3f788c7dad9319a	2020-04-11	f	none	\N	IT
20996	151.76.195.253	Europe	Italy	Pescara	Mac OS	ChromiumEdge	b76e3815f6eb50b2c3f788c7dad9319a	2020-04-11	f	none	Direct	IT
20997	151.76.195.253	Europe	Italy	Pescara	Mac OS	ChromiumEdge	1a02f231d3cfcaf922dd429875e490d1	2020-04-11	f	none	\N	IT
20998	151.76.195.253	Europe	Italy	Pescara	Mac OS	ChromiumEdge	2c66f3884763e8c6e80e0a08869ffcf2	2020-04-11	f	none	\N	IT
20999	151.76.195.253	Europe	Italy	Pescara	Mac OS	ChromiumEdge	2c66f3884763e8c6e80e0a08869ffcf2	2020-04-11	f	none	Direct	IT
21000	151.76.195.253	Europe	Italy	Pescara	Mac OS	ChromiumEdge	dab149439983d6984e4160336eacb345	2020-04-11	f	none	\N	IT
21001	151.76.195.253	Europe	Italy	Pescara	Mac OS	ChromiumEdge	dab149439983d6984e4160336eacb345	2020-04-11	f	none	Direct	IT
21002	151.76.195.253	Europe	Italy	Pescara	Mac OS	ChromiumEdge	417c1c757ba696fc6e7a8313b5b91bf1	2020-04-11	f	none	\N	IT
21003	151.76.195.253	Europe	Italy	Pescara	Mac OS	ChromiumEdge	56d2a89e28d04feaaf4ecc461a234f33	2020-04-11	f	none	\N	IT
21004	151.76.195.253	Europe	Italy	Pescara	Mac OS	ChromiumEdge	56d2a89e28d04feaaf4ecc461a234f33	2020-04-11	f	none	Direct	IT
21005	151.76.195.253	Europe	Italy	Pescara	Mac OS	ChromiumEdge	56d2a89e28d04feaaf4ecc461a234f33	2020-04-11	f	none	Direct	IT
21006	151.76.195.253	Europe	Italy	Pescara	Mac OS	ChromiumEdge	56d2a89e28d04feaaf4ecc461a234f33	2020-04-11	f	none	Direct	IT
21007	151.76.195.253	Europe	Italy	Pescara	Mac OS	ChromiumEdge	56d2a89e28d04feaaf4ecc461a234f33	2020-04-11	f	none	Direct	IT
21008	151.76.195.253	Europe	Italy	Pescara	Mac OS	ChromiumEdge	9503c630f0807645bf2f203a3896670a	2020-04-11	f	none	Direct	IT
21009	151.76.195.253	Europe	Italy	Pescara	Mac OS	ChromiumEdge	96a742684b958b3ce2d686e40959af5e	2020-04-11	f	none	\N	IT
21010	151.76.195.253	Europe	Italy	Pescara	Mac OS	ChromiumEdge	5dabcfb30b4fb8a42fb8be0d70783aa4	2020-04-11	f	none	\N	IT
21011	151.76.195.253	Europe	Italy	Pescara	Mac OS	ChromiumEdge	5dabcfb30b4fb8a42fb8be0d70783aa4	2020-04-11	f	none	Direct	IT
21012	151.76.195.253	Europe	Italy	Pescara	Mac OS	ChromiumEdge	edb63823e290cf117cb565b22e626a92	2020-04-11	f	none	\N	IT
21013	151.76.195.253	Europe	Italy	Pescara	Mac OS	ChromiumEdge	deea0bc630b6fa75bcd765c9bbaf8fdf	2020-04-11	f	none	\N	IT
21014	151.76.195.253	Europe	Italy	Pescara	Mac OS	ChromiumEdge	2a766f94ff77d74cdfc1677afee26534	2020-04-11	f	none	Direct	IT
21015	151.76.195.253	Europe	Italy	Pescara	Mac OS	ChromiumEdge	2a766f94ff77d74cdfc1677afee26534	2020-04-11	f	none	Direct	IT
21016	151.76.195.253	Europe	Italy	Pescara	Mac OS	ChromiumEdge	2a766f94ff77d74cdfc1677afee26534	2020-04-11	f	none	Direct	IT
21017	151.76.195.253	Europe	Italy	Pescara	Mac OS	ChromiumEdge	add4ebef64ae21a6ac30b83d5b61f061	2020-04-11	f	none	\N	IT
\.


--
-- Data for Name: coordinates_locations; Type: TABLE DATA; Schema: public; Owner: danutu
--

COPY public.coordinates_locations (code_ip, continent, country, county, city, iso_code) FROM stdin;
12	Europe	Italia	Pescara	Pescara	it
1	Europe	Italia	Pescara	Montesilvano	it
14	Europe	Italia	Pescara	Montesilvano	it
16	Europe	Italia	Pescara	Pescara	it
18	Europe	Italia	Pescara	Montesilvano	it
20	Europe	România	Suceava	Suceava	ro
48	Europe	Italia	Pescara	Montesilvano	it
50	Europe	Italia	Pescara	Montesilvano	it
52	Europe	Italia	Pescara	Montesilvano	it
56	Europe	Italia	Roma Capitale	Roma	it
58	Europe	Italia	Pescara	Pescara	it
54	Europe	Italia	Pescara	Montesilvano	it
60	Europe	Italia	Pescara	Montesilvano	it
62	Europe	Italia	Campobasso	Termoli	it
64	Europe	Italia	Pescara	Montesilvano	it
66	Europe	Italia	Pescara	Pescara	it
\.


--
-- Data for Name: ip_coordinated; Type: TABLE DATA; Schema: public; Owner: danutu
--

COPY public.ip_coordinated (code, ip, longitude, latitude) FROM stdin;
62	151.26.170.183	14.997094400000002	42.0012032
1	151.76.194.180	14.132412299999999	42.5050423
58	5.90.170.219	14.20996288288854	42.44854050666278
50	151.26.251.38	14.1326217	42.5055054
18	151.76.132.83	14.1326973	42.5052529
16	79.3.19.242	14.2047274	42.4519717
60	151.26.238.178	14.1327067	42.505474799999995
52	151.26.235.124	14.181479999999999	42.4934185
48	151.76.134.19	14.134476800000002	42.4992768
14	151.26.239.201	14.1549453	42.4963413
54	151.26.254.132	14.132655699999999	42.5055057
56	5.179.180.18	12.56738	41.871939999999995
20	86.120.42.5	26.2514203	47.6500006
66	151.26.178.211	14.1859747	42.461295
64	151.26.234.66	14.134996500000002	42.499259099999996
12	79.9.149.195	14.2047274	42.4519717
\.


--
-- Data for Name: likes; Type: TABLE DATA; Schema: public; Owner: danutu
--

COPY public.likes (id, post_id, "user") FROM stdin;
\.


--
-- Data for Name: notifications; Type: TABLE DATA; Schema: public; Owner: danutu
--

COPY public.notifications (id, "user", title, body, link, for_user, checked, created_on, category) FROM stdin;
33	2	danutu replied to your post	How we can overcome distractions and stay focused as developers	/post/How-we-can-overcome-distractions-and-stay-focused-as-developers-155?notification_id=33	2	t	2020-04-13 00:11:45.406161	reply
31	2	danutu replied to your post	How we can overcome distractions and stay focused as developers	/post/How-we-can-overcome-distractions-and-stay-focused-as-developers-155?notification_id=31	2	t	2020-04-13 00:10:56.692519	reply
29	2	danutu replied to your post	How we can overcome distractions and stay focused as developers	/post/How-we-can-overcome-distractions-and-stay-focused-as-developers-155?notification_id=29	2	t	2020-04-13 00:10:21.382501	reply
27	2	danutu replied to your post	How we can overcome distractions and stay focused as developers	/post/How-we-can-overcome-distractions-and-stay-focused-as-developers-155?notification_id=27	2	t	2020-04-13 00:09:32.618779	reply
36	2	danutu mentioned you in a comment	@danutu not a bad id	/post/Django-search-form-for-filtering-16?notification_id=36	2	t	2020-04-13 00:52:09.46811	reply
35	2	danutu replied to your post	Django search form for filtering	/post/Django-search-form-for-filtering-16?notification_id=35	2	t	2020-04-13 00:52:06.46712	reply
44	2	danutu replied to your post	Implementing an ActionListener interface	/post/Implementing-an-ActionListener-interface-176?notification_id=44	8	f	2020-04-15 00:11:07.20673	reply
45	2	danutu mentioned you in a comment	@danutu ggg\n	/post/Implementing-an-ActionListener-interface-176?notification_id=45	8	f	2020-04-15 00:11:07.218399	reply
15	2	danutu unliked your post	Implementing an ActionListener interface	/post/Implementing-an-ActionListener-interface-176?notification_id=15	8	f	2020-04-11 16:57:12.937112	unlike
16	2	danutu liked your post	Implementing an ActionListener interface	/post/Implementing-an-ActionListener-interface-176?notification_id=16	8	f	2020-04-11 16:57:33.60519	like
17	2	danutu unliked your post	How we can overcome distractions and stay focused as developers	/post/How-we-can-overcome-distractions-and-stay-focused-as-developers-155?notification_id=17	2	t	2020-04-11 17:01:08.702386	unlike
18	2	danutu liked your post	How we can overcome distractions and stay focused as developers	/post/How-we-can-overcome-distractions-and-stay-focused-as-developers-155?notification_id=18	2	t	2020-04-11 17:01:23.633502	like
19	2	danutu unliked your post	Spy on the DOM	/post/Spy-on-the-DOM-97?notification_id=19	2	f	2020-04-11 17:36:55.226568	unlike
20	2	danutu liked your post	Spy on the DOM	/post/Spy-on-the-DOM-97?notification_id=20	2	f	2020-04-11 17:36:58.142838	like
21	2	danutu unliked your post	How to iterate through a specific key-value pair in array	/post/How-to-iterate-through-a-specific-key-value-pair-in-array-75?notification_id=21	2	f	2020-04-11 17:37:01.32051	unlike
22	2	danutu liked your post	How to iterate through a specific key-value pair in array	/post/How-to-iterate-through-a-specific-key-value-pair-in-array-75?notification_id=22	2	f	2020-04-11 17:37:04.420734	like
23	2	danutu replied to your post	How we can overcome distractions and stay focused as developers	/post/How-we-can-overcome-distractions-and-stay-focused-as-developers-155?notification_id=23	2	t	2020-04-13 00:06:39.353972	reply
25	2	danutu replied to your post	How we can overcome distractions and stay focused as developers	/post/How-we-can-overcome-distractions-and-stay-focused-as-developers-155?notification_id=25	2	t	2020-04-13 00:07:46.842343	reply
34	2	@danutu mentioned you in a comment	@danutu ce faci\n	/post/How-we-can-overcome-distractions-and-stay-focused-as-developers-155?notification_id=34	2	t	2020-04-13 00:11:48.598108	reply
\.


--
-- Data for Name: podcast_series; Type: TABLE DATA; Schema: public; Owner: danutu
--

COPY public.podcast_series (id, name, description, img) FROM stdin;
9	CodeNewbie	gg	p_series_9.webp
\.


--
-- Data for Name: podcasts; Type: TABLE DATA; Schema: public; Owner: danutu
--

COPY public.podcasts (id, title, body, audio, img, series_id, posted_on, source) FROM stdin;
\.


--
-- Data for Name: posts; Type: TABLE DATA; Schema: public; Owner: danutu
--

COPY public.posts (id, title, text, views, reply, "user", posted_on, approved, closed, closed_on, closed_by, lang, thumbnail, likes, read_time) FROM stdin;
79	somma	<p>come si fa un problema che calcola la somma</p><p><br></p>	0	0	11	2019-10-05 00:00:00	t	f	\N	\N	it	\N	1	1 min read
85	Integrare un css in un file html	<p>Come posso richiamare un file css in un file html </p>	0	0	8	2019-10-07 00:00:00	t	f	\N	\N	it	\N	1	1 min read
91	How create a banner for a website	<p>How can i create a banner on my website above description and above menu?</p>	0	0	8	2019-10-07 00:00:00	t	f	\N	\N	en	\N	1	1 min read
93	What's an interesting question you've been asked at an interview?	<p>Not necessarily a&nbsp;<em>difficult </em>question, but what is something you've been asked that was uncommon, weird, interesting, puzzling or flabbergasting?</p>	0	0	2	2019-10-12 00:00:00	t	f	\N	\N	en	\N	1	1 min read
14	Convert datetime.datetime to day of the week, and then plot	<p>I have a list of datetime.datetime objects:</p>\n<pre class="prettyprint"><code>x1 = [ datetime.datetime(2019, 8, 18, 21, 21, 23), datetime.datetime(2019, 8, 18, 20, 38, 6), datetime.datetime(2019, 8, 18, 18, 45, 38), datetime.datetime(2019, 8, 18, 15, 35, 25), datetime.datetime(2019, 8, 18, 15, 29, 54), datetime.datetime(2019, 8, 18, 15, 26, 19) ]</code></pre><p>And I would like to extract the day of the week they are (0 Monday, 6 Sunday, for example), and then plot 7 histogram, one per day, with the hours in the x axis.</p>\n<p>So far no luck using .weekday()</p>\n	88	0	2	2019-08-19 00:00:00	t	f	\N	\N	en	\N	2	1 min read
15	I am trying to validate phone numbers in a dataframe	<p>I am trying to validate the Phone number in my dataframe. The code should flag the number as home or Mobile or Invalid</p>\n<p>This is specific to UK phone number validation. And i tried Regex but it wont flag the number.</p>\n<pre class="prettyprint"><code>import pandas as pd \nimport re\n# display(df)\n# df.head()\ndf[&#39;Phonenumber&#39;]=df(df.withColumn(&#39;Phone_Number_Validity&#39;, if(isValid(df)):       \n             # print (&quot;Mobile Number&quot;)      \n             else : \n             # print (&quot;Home Number&quot;)))\ndisplay(df) </code></pre><p>Getting Syntax error</p>\n	69	0	2	2019-08-19 00:00:00	t	f	\N	\N	en	\N	2	1 min read
126	P***s	<p>Cum sa fac pi*** mica inapoi si p*** mai mare</p>	0	0	25	2019-11-08 00:00:00	t	f	\N	\N	ro	\N	1	1 min read
1	Welcome To NewApp	<p>Hey everyone, this is a new forum, i hope we can learn from each other and create awesomes apps &lt;3</p>	175	0	2	2019-07-20 00:00:00	t	t	2019-08-04	2	en	\N	2	1 min read
16	Django search form for filtering	<p>I am currently doing a search using forms</p>\n<p>This is my views.py</p>\n<pre class="prettyprint"><code>class HomeView(generic.ListView):\n        model = Consultant\n        template_name = &#39;sogeti/home.html&#39;\n\n        def get_queryset(self):\n                query = self.request.GET.get(&#39;q&#39;)\n                if query:\n                        return Consultant.objects.filter(\n                                Q(first_name__icontains=query) |\n                                Q(last_name__icontains=query) |\n                                Q(group__***le_techGroup__contains=query) |\n                                Q(practices__***le_practice__contains=query)\n                        )\n                else:\n                        return Consultant.objects.all()</code></pre><p>and this is my home.html</p>\n<pre class="prettyprint"><code>&lt;form action=&quot;&quot; method=&quot;get&quot; class=&quot;form-inline&quot;&gt;\n    &lt;input type=&quot;text&quot; name=&quot;q&quot; placeholder=&quot;Enter Keyword&quot; value=&quot;{{ request.GET.q }}&quot; class=&quot;form-control&quot;&gt;\n    &lt;select name=&quot;filter&quot; class=&quot;form-control&quot;&gt;\n            &lt;option value=&quot;all&quot;&gt;All&lt;/option&gt;\n            &lt;option value=&quot;people&quot;&gt;People&lt;/option&gt;\n            &lt;option value=&quot;certification&quot;&gt;Certification&lt;/option&gt;\n            &lt;option value=&quot;skillset&quot;&gt;Skillset&lt;/option&gt;\n    &lt;/select&gt;\n    &lt;input type=&quot;submit&quot; value=&quot;Search&quot; class=&quot;btn btn-default&quot;&gt;\n&lt;/form&gt;</code></pre><p>My first problem is that when it tries to search something (Eg: bla) that is not in my database, it returns a blank screen. Nothing at all. Tried searching but could not get any answers.</p>\n<p>My second problem is how am I able to specify my search using HTML select and options to filter. As you can see from my home.html I have the tag with option value but no idea how to utilize it for Django.</p>\n	443	0	2	2019-08-19 00:00:00	t	f	\N	\N	en	\N	3	1 min read
121	 Tips for a Junior Dev	<p>I have read a couple articles with advice for Junior Developers so I decided to write a few myself to share and reflect on my journey in that role. Working as a Junior Developer can be challenging. You might often find times that you are overloaded with information to soak up or unable to finish a task/project. I am a Junior Developer and I have gone through a couple challenges and thought I would share some tips on how to get through those challenges.</p>\n<h3 id="1-staying-positive-your-mental-approach-to-your-work-is-very-important">1. Staying positive Your mental approach to your work is very important.</h3>\n<p>Having a positive mindset when solving a task can increase your chances of solving it. I find that if I tell myself I can solve a task, often times, I end up doing so. And when I am not too positive, I find that I take longer to get the task done. There may be a couple of things that might disrupt that kind of positive energy. It might be things in your life that you are going through or the atmosphere at work or even the weather. One thing I know definitely affects my positive energy is social media. One small message from someone or a post can take up 5-10 mins of my time after which I have to try again to focus on the task I was working on. A good solution for this is to put your phone on mute or somewhere far away whilst you are working so that you do not get distracted. Sounds simple but often times its hard to stay more than 30 minutes without looking at your phone. So try as much possible to be off your phone to keep those positive vibes. Another way I try build some positive energy is to listen to my favorite music playlist right before starting my task or during. Once I listen to a couple good jams, I feel more motivated and my brain just clears up. I also try and make sure I listen to the same playlist every time I start working on a task. I believe keeping this routine tells my brain that it is time to get things done.</p>\n<h3 id="2-being-eager-to-learn-working-as-a-junior-dev-you-will-be-introduced-to-a-lot-of-new-languages-frameworks-concepts-code-bases-that-your-company-uses-and-it-might-be-a-lot-to-assimilate">2. Being eager to learn Working as a Junior Dev, you will be introduced to a lot of new languages, frameworks, concepts, code-bases that your company uses and it might be a lot to assimilate.</h3>\n<p>First thing would be to itemize all the things you are not comfortable with and create a schedule of learning them. The developers in your company or even outside can direct you on getting familiar with everything and can direct you on the right path. Do not be afraid to ask when there is something you do not understand. You might have a lot of questions but asking does not mean that you are less qualified for the job. Developers are some of the most helpful and supportive professionals I know. Being a second-career dev, I am often surprised at the sheer number of developer meetups, forums, groups where people are asking questions and others are ready to provide answers( big ups to <a href="https://stackoverflow.com/">StackOverflow!</a>). Most developers are always willing to help because we have gone through similar challenges so feel free to raise a question when you get stuck.</p>\n<h3 id="3-knowing-when-to-take-a-time-out">3. Knowing when to take a time-out</h3>\n<p>It is always good to take a break once in a while especially when you get stuck on something, be it a task, understanding a concept or trying to solve that pesky bug. When I get stuck, I try to get some water and walk a little. This helps me to rethink my approach to a task and also give my brain some time to rest. Often times it is during the short walks that I find the solution to the problem I was having. Learning when to give yourself a time-out can help keep your stamina up so keep practicing this.</p>\n<h3 id="4-having-mentors-i-would-recommend-having-mentors-to-guide-you-on-your-learning-journey">4. Having mentors I would recommend having mentors to guide you on your learning journey.</h3>\n<p>This could be senior developer at your company, someone within your community or someone you look up to. I know its very hard to find mentors but keep trying.</p>\n<h3 id="5-remembering-why-you-chose-this-career-path">5. Remembering why you chose this career path</h3>\n<p>Sometimes you might be in a really tough position in your career that you feel that maybe it was not meant for you or maybe you should try follow a different path. When you start feeling like that just rethink why you decided to choose software development. Look back at the things you have built and think of how working on those projects or tasks made you feel.</p>\n<h3 id="6-being-part-of-a-community">6. Being part of a community</h3>\n<p>I have grown a lot in my career by being part of a developer community. To be honest, seeing the activities in these communities is what made be decide to switch careers back in 2017. I am very grateful to the <a href="https://web.facebook.com/groups/DevCLusaka/">Developer Circle&#39;s Lusaka group</a> for showing me that software development is actually a fun and interesting field and that you can get a very good salary from it. Attending community events, you get to learn a lot about what is trending in your field, meet other developers like yourself, who can encourage you and of course, find companies or people looking to hire developers. So make sure you are in at least one community. And as you grow in that community try to give feedback/support to other developers.</p>\n<h3 id="7-this-one-is-key-dont-call-yourself-a-junior-developer">7. This one is key... DON&#39;T CALL YOURSELF A JUNIOR DEVELOPER!!!</h3>\n<p>You may have just started learning software development and are looking to get a job or you are already working as a Junior Developer at a company but in the long run, you want to have a title such as, Intermediate Developer or Senior Developer right? Well, calling yourself a Junior Developer might get you that entry-level job but you want to grow out of that role and the best place to start is to stop keeping that title. When you start thinking of yourself in a higher position, you will start growing and gaining the right skills required. So shave the &quot;Junior&quot; off and start earning the next higher role. I hope you enjoyed these few tips and I would like to here yours!</p>\n<p>Post from <a href="https://dev.to">dev</a></p>\n	0	0	2	2019-10-26 00:00:00	t	f	\N	\N	en	\N	1	5 min read
13	How to compute distance from elements of an array in python?	<p>I have a numpy array where each element is a position, like this :</p>\n<pre class="prettyprint"><code>array([[1, 1, 0], [2, 2, 0], [3, 3, 1]])</code></pre><p>And I want to compute the distance between each element. So here, the expected output is :</p>\n<pre class="prettyprint"><code>[0, 1.414213, 1.732050]</code></pre><p>The distance is calculated as it follows : For the first element it is 0 because ther isn&#39;t any element before. For the second it is <code>sqrt((2 - 1)**2 + (2 - 1)**2 + (0 - 0)**2))</code> and so on</p>\n<p>However, there is a lot of elements (around some thousands), and this operation is repeated multiple times. So I need a way to execute this very fast.</p>\n<p>I was wondering if there is a library (or even better a numpy function) that could solve my problem. I used cdist from scipy.spatial.distance before, but it doesn&#39;t work anymore (I have problems with scipy dependencies), so I&#39;m searching for another way.</p>\n	72	0	2	2019-08-19 00:00:00	t	f	\N	\N	en	\N	1	1 min read
97	Spy on the DOM	<p>This module allows you to quickly see a DOM element&#39;s attributes by simply hovering your mouse over it inside your browser. Basically, it&#39;s an on-the-fly inspector.</p>\n<p>Copy the entire code block below and paste it into your browser web console. Now hover your mouse around whatever web page you&#39;re on. <strong>What do you see?</strong></p>\n<pre class="prettyprint"><code>(function SpyOn() {\n\n    const \\_id = &#39;spyon-container&#39;,\n                \\_posBuffer = 3;\n\n    function init() {\n        document.body.addEventListener(&#39;mousemove&#39;, glide);\n        document.body.addEventListener(&#39;mouseover&#39;, show);\n        document.body.addEventListener(&#39;mouseleave&#39;, hide);\n    }\n\n    function hide(e) {\n        document.getElementById(\\_id).style.display = &#39;none&#39;;\n    }\n\n    function show(e) {\n        const spyContainer = document.getElementById(\\_id);\n        if (!spyContainer) {\n            create();\n            return;\n        }\n        if (spyContainer.style.display !== &#39;block&#39;) {\n            spyContainer.style.display = &#39;block&#39;;\n        }\n    }\n\n    function glide(e) {\n        const spyContainer = document.getElementById(\\_id);\n        if (!spyContainer) {\n            create();\n            return;\n        }\n        const left = e.clientX + getScrollPos().left + \\_posBuffer;\n        const top = e.clientY + getScrollPos().top + \\_posBuffer;\n        spyContainer.innerHTML = showAttributes(e.target);\n        if (left + spyContainer.offsetWidth &gt; window.innerWidth) {\n            spyContainer.style.left = left - spyContainer.offsetWidth + &#39;px&#39;;\n        } else {\n            spyContainer.style.left = left + &#39;px&#39;;\n        }\n        spyContainer.style.top = top + &#39;px&#39;;\n    }\n\n    function getScrollPos() {\n        const ieEdge = document.all ? false : true;\n        if (!ieEdge) {\n            return {\n                left : document.body.scrollLeft,\n                top : document.body.scrollTop\n            };\n        } else {\n            return {\n                left : document.documentElement.scrollLeft,\n                top : document.documentElement.scrollTop\n            };\n        }\n    }\n\n    function showAttributes(el) {\n        const nodeName = \\`&lt;span style=&quot;font-weight:bold;&quot;&gt;${el.nodeName.toLowerCase()}&lt;/span&gt;&lt;br/&gt;\\`;\n        const attrArr = Array.from(el.attributes);\n        const attributes = attrArr.reduce((attrs, attr) =&gt; {\n            attrs += \\`&lt;span style=&quot;color:#ffffcc;&quot;&gt;${attr.nodeName}&lt;/span&gt;=&quot;${attr.nodeValue}&quot;&lt;br/&gt;\\`;\n            return attrs;\n        }, &#39;&#39;);\n        return nodeName + attributes;\n    }\n\n    function create() {\n        const div = document.createElement(&#39;div&#39;);\n        div.id = \\_id;\n        div.setAttribute(&#39;style&#39;, \\`\n            position: absolute;\n            left: 0;\n            top: 0;\n            width: auto;\n            height: auto;\n            padding: 10px;\n            box-sizing: border-box;\n            color: #fff;\n            background-color: #444;\n            z-index: 100000;\n            font-size: 12px;\n            border-radius: 5px;\n            line-height: 20px;\n            max-width: 45%;\n            \\`\n        );\n        document.body.appendChild(div);\n    }\n\n    init();\n\n})();</code></pre><h3 id="how-it-works">How it works</h3>\n<p>This module is implemented as an <a href="https://developer.mozilla.org/en-US/docs/Glossary/IIFE">IIFE</a>. This way, you can just copy and paste the code into your web console whenever you need some DOM spying assitance. A div is inserted into your document&#39;s body and mouse event listeners are enabled on the body. Attributes are retrieved from the target element, reduced down to a single string and then displayed inside the tooltip.</p>\n<h3 id="use-cases">Use cases</h3>\n<ol>\n<li>Help troubleshoot a UI bug</li>\n<li>Ensure that your app&#39;s DOM elements are working as expected (getting the right class on click, etc)</li>\n<li>Find out how another web app is structured</li>\n</ol>\n<h3 id="what-you-can-learn-from-this-code">What you can learn from this code</h3>\n<ol>\n<li>How to implement a tooltip module using vanilla JS</li>\n<li>How to parse a DOM object&#39;s attributes</li>\n<li>How to find the mouse&#39;s X and Y position</li>\n<li>How to take into account the document&#39;s scroll position</li>\n<li>Understand how different browsers behave - Edge vs. Chrome vs. Safari</li>\n</ol>\n<h3 id="open-source">Open source</h3>\n<p>You can find the source code <a href="https://github.com/eddieherm/spyon">here</a> and I encourage you to make it better! Perhaps you don&#39;t want it to be implemented as an IIFE, or maybe you want to show other data, or maybe it&#39;s just broken!</p>\n<p><strong>Happy spying!</strong></p>\n	0	0	2	2019-10-14 00:00:00	t	f	\N	\N	en	\N	2	2 min read
119	Just Keep Coding!- A letter to junior developers	<p>Hi Junior Developer,</p><p>I decided to write this letter to you. You’re probably just starting out on your dream developer career. I was there at some point and know the feelings of fear and doubt very well.</p><p>So I thought why not write a letter to encourage and motivate you to keep coding. There’s plenty of people of the net already talking about the technical stuff. Just remember, no matter how many mistakes you make or if the apps you develop don’t have the quality of outcome as you expected, just stay focused. Stay swimming on this ocean of codes, where you’ll eventually grow your seed through the code you create to make life better and processes easier.</p><p>The aim of this is to show you in this stage that despite it being hard right now, there are some valuable and powerful things you can take advantage of. So don’t worry! Even the most seasoned developers have felt and passed the same stage, under the same struggle. And, of course, you’re not alone. Though I am still a beginner at some topics, I am learning and getting better every single day.</p><p><br></p><h1>The Beginner Stage</h1><p>Sometimes you probably feel like this stage pushes you forward, and other times it pushes you backward.</p><p>For a while, you feel the momentum and say, “This is living. This is what I want to do with my life!” But when things are hard to solve or when you face complex concepts and you’re not able to figure them out, you might say, “Come on! This is not what I want to do for the rest of my life.” You feel frustrated and need encouragement to move forward. It’s a struggle that lives inside you and is holding you back. I know this feeling very well, too.</p><p>At this stage, you make a lot of bad things, and this is given for different reasons: Some of you want to get a job fast. Others just want to survive or need to earn some money, so you’re more likely to accept low-budget projects.</p><p>So we’re making bad decisions, making optimistic plans, and building software with poor and low-quality code as well. But this is normal. It’s just the beginning. You’ll find a way to jump to the next level. I can categorically say to you:&nbsp;<em>It is worthwhile — just keep coding!</em></p><p><br></p><h1>The power and values of this stage</h1><p>I would like to spotlight the most important values at this stage: the willpower, the voraciousness, and the ambitions you’ll need in order to learn more, to become better, to have the courage to go beyond your goals, the willingness to give the extra mile, and the ability to be humble and embrace feedback.</p><p>Take advantage of these superpowers to progress in your development skills. You and I have dreams and goals, so we must force ourselves until we accomplish them. Add value to this world with your code by helping others. We want to be part of the change by writing quality code and sharing our knowledge, experiences, and lessons. The world will thank you!</p><p><br></p><h1>Your desire to build a successful developer career</h1><p>Most of us want to build a successful developer career, right? But let’s first clarify what a successful developer career means.</p><p>Successful, in general, means you’re able to accomplish your own metrics or your goals.</p><p>For some, the goal may be adding important contributions to an open-source project. Others may want to impact and help others with their knowledge by acting as mentors. Others want to leave footprints with their code. And some just want to work in a fantastic tech startup or at a big tech company, such as Google, Facebook, LinkedIn, etc. The list is endless.</p><p>But in general terms, it all comes down to becoming a strong developer — a master on what you do — then deciding how to get your ideas into the world.</p><p><br></p><h1>Self-motivation, self-discipline, and focus</h1><p>I truly believe building a solid developer career is not easy, and you won’t accomplish it overnight.</p><p>If someone else has told you the opposite, he/she has lied to you. Having said that, building a strong developer career depends on several factors, and all of them play on your side so you have control over them.</p><p>From my point of view, the three most important factors are self-motivation, self-discipline, and focus. Without focus, you don’t clearly know where you want to arrive in the short, medium, or long-term. Your sight is a blur — you might not have a clear path or you might even have the wrong path.</p><p>The real problem when we start out in this career is that we are expecting to see great results after we finish some video courses, some tutorials, some posts, or after completing some pet projects.</p><p>But the software-development field works the same as when you start to go to the gym. If you want to see progress, you should build self-discipline and self-motivation. You’ll see notable results after some weeks and months — as long as you maintain your consistency and discipline. You must train your brain and develop the muscle to gain use cases, becoming better at problem-solving and more creative.</p><p><br></p><h1>Finally, Some Advice</h1><p>Finally, I would like to give you a few tips and a piece of advice based on my learned lessons, experiences, mistakes, and failures.</p><h3>Enjoy the process</h3><p>I know this stage is hard in terms of how to get, retain, and understand all the information, concepts, paradigms, design patterns, data structures, and algorithms you’re receiving every day.</p><p>I encourage you to just keep coding. Enjoy what you’re working on no matter if it’s a small, medium, or big project. Please stop focusing on the results — enjoy and travel with the process instead. The results will come in time.</p><h3>Plan first — then code</h3><p>In the beginning, I constantly skipped the planning phase. I just wanted to see real progress and outputs on my UI. I started the task just thinking a little bit about it, without doing proper analysis and planning the best way or approach to solve and complete it. I ended up wasting more time in the end.</p><p>Plan and objective, and stay aware of it. But then code. Too much planning it also not a good idea.</p><p><em>To solve a problem, think about the different ways to solve it.</em></p><p>Usually, when we’re in front of a problem, we try to solve it as soon as we can. We decide to go with the first solution that comes to us. We forget to think of the complexity, the use cases, and the buggy potentials.</p><p>Just keep coding — it’s the only way to master this field.</p><p>Thanks for reading! If this story turned out to be interesting, I’d really appreciate it if you like and share it with your friends. I hope to add a little bit more knowledge to you.</p><p><br></p><p>Post from <a href="https://dev.to/blarzhernandez/just-keep-coding-a-letter-to-junior-developers-21h8" target="_blank">dev.to</a></p>	0	0	2	2019-10-23 00:00:00	t	f	\N	\N	en	\N	1	5 min read
115	Done it's better than Perfect	<p>How many side projects have you started, but never released? What about articles? Designs? Open source libraries? I have way more than I can count. They're collecting dust on external hard drives and in Github repos. Things that I got excited about, started, and never released.</p><p><br></p><p>This is nothing new for me, and maybe not for you, either. It's easy to fall into the trap of "this design needs to be pixel perfect before I can release it", or "this one last feature is essential; I can't ship without it." These thoughts are roadblocks. They prevent your creation from seeing the light of day.</p><p><br></p><p>"Done is better than perfect", "Good enough is good enough", "Perfect is the enemy of good". I didn't coin any of these phrases, and I'm not the first one to repeat them. </p><p><br></p><p>For every one of the above items, there was a moment where I thought "let me just tweak this one thing, then I can release it." Every single one. But I knew that if I kept tweaking them until they were perfect, they'd never be done, and I never would have shared them.</p><p><br></p><p>A funny thing about shipping, is that it gets easier the more you do it. Patrick McKenzie has a great quote:</p><p><br></p><p>Being able to successfully ship things is a useful muscle to develop.</p><p><br></p><p>The more you ship, the easier it becomes. You start to doubt yourself less, and you put more out into the world.</p><p><br></p><p>Here's another funny thing about shipping: it can bring about unexpected opportunities. I've had people email me after reading or watching my content, and checking out my open source libraries. I now have ideas for more content to produce, related to the stuff I recently shipped. It's a virtuous cycle.</p><p><br></p><p>This makes me wonder: how many opportunities have I missed from not releasing my previous work? How many cool work opportunities and new clients could there have been? How many people could have learned something new from reading my source code and articles?</p><p><br></p><p>Starting things is easy. Shipping them is hard. So start exercising that muscle.</p>	0	0	2	2019-10-18 00:00:00	t	f	\N	\N	en	\N	1	2 min read
155	How we can overcome distractions and stay focused as developers	<h3 id="the-distractions-that-surround-us-arent-going-anywhere-so-learning-to-overcome-them-is-one-of-the-best-things-we-can-do-for-ourselves-as-developers-to-always-stay-focused-and-get-our-staff-done">The distractions that surround us aren&#39;t going anywhere, so learning to overcome them is one of the best things we can do for ourselves as developers to always stay focused and get our staff done.</h3>\n<p>Here are 5 tips that can help us to stay focused during work by managing distraction and eliminating chances for procrastination as developers;</p>\n<h1 id="1-set-plans">1. Set plans</h1>\n<p>All successful people are great planners whereby they make lists for every major and minor objective. When a task comes your way, spend some time thinking about how you will accomplish it instead of jumping into it straight away. Write down every step necessary from start to finish, with a timeline.</p>\n<h1 id="2-break-it-down">2. Break it down.</h1>\n<p>Especially when distractions are high, make tasks smaller and break down your large projects into smaller tasks to help you concentrate and give you a sense of accomplishment and progress.</p>\n<h1 id="3-set-deadlines">3. Set deadlines</h1>\n<p>If you&#39;re working on a complex task, it takes an average of 90 minutes to accomplish anything worthwhile and about 30 minutes just to get your mind on the task. Once you are in the flow, set a concentrated period of time and when the time runs out, stop. It&#39;s easier to stay focused when you have an end in sight.</p>\n<h1 id="4-go-offline">4. Go offline</h1>\n<p>Some of the biggest sources of distraction come from email, social media, and cell phones. If you want real focus, take yourself offline until you&#39;ve accomplished what you need to do.</p>\n<h1 id="5-give-yourself-a-break">5. Give yourself a break</h1>\n<p>one of the keys to doing great work is to know when to take a break. When you start to feel distracted, take a break every 2hours of work, your break can be for about 15 to 20 minutes. A short break can help you clear up your mind.</p>\n<p>Our ability to stay focused is more than just a worthwhile thing to cultivate--it&#39;s a critical factor in our success or failure as developers. Getting things done is imperative, and focus is the key to getting things done.</p>\n<p>I hope these tips will help some of us to improve on ourselves as developers.</p>\n<p>In case there is anything I have missed that you feel it&#39;s worth to be included then you can comment below 👏</p>\n<p>Post from <a href="https://dev.to/weptim/how-we-can-overcome-distractions-and-stay-focused-as-a-developers-49nd">dev</a></p>\n	0	0	2	2019-12-04 08:34:58.95478	t	f	\N	\N	en	\N	2	2 min read
189	What's Wrong with CSS?	<p>Some noted problems that might hold CSS back and open up new development of preprocessors or CSS-in-JS.</p>\n<p>CSS is enjoyable to write until it’s getting really messy in big projects, the problem with CSS isn’t CSS, it’s humans; This problem is compounded as styles grow, each developer needs to know more context in order to style effectively.</p>\n<p>CSS was initially designed with simplicity in mind and it worked very well as dominant styling language for the web. The things that many JS developers hate about CSS are the same things that make it so powerful. Let’s look at some noted problems with CSS until today:</p>\n<h2 id="lacking-of-built-in-namespaces">Lacking of built-in namespaces</h2>\n<p>Any programming languages lacking built-in namespaces will have problems at scale and CSS is obviously one of them. Global namespace was designed as core feature of CSS to enable portability and cascading. This is the DNA of CSS, CSS-in-JS fixed that very well when build tools can intercept and generate scopes automatically for you.</p>\n<h2 id="too-static-to-change">Too static to change</h2>\n<p>Vanilla CSS is just a set of static layout rules; even though variables and expression have been added recently, CSS is still too simple to keep up with dynamic web pages. It’s hard to implement theming and dynamically changing styles based on incoming data from JavaScript.</p>\n<h2 id="unavoidably-repeating-yourself">Unavoidably repeating yourself</h2>\n<p>Lack of variables so we have to repeat colors all over the place. Lack of nesting so we have to repeat huge blocks of CSS all over the place. In short, CSS violates the living crap out of the DRY principle.</p>\n<h2 id="stuck-with-the-past">Stuck with the past</h2>\n<p>Three cornerstones HTML, CSS, JavaScript must not break the web; maintaining backward and forward compatible is the number one priority when design new features. Even though we can introduce new features but we can’t get out of bad decisions from the past completely, adoption rate and browser support are too important to revolutionize the language.</p>\n<h2 id="resistant-from-static-analysis">Resistant from static analysis</h2>\n<p>How can we apply some static analysis like dead code elimination and minification to CSS? we can’t! the global nature and cascading styles from inline, internal and external sources make it impossible to perform those kinds of optimization.</p>\n<h2 id="non-deterministic-resolution-to-human">Non deterministic resolution to human</h2>\n<p>According to how css works, styles are merged from multiple sources (inline, internal, external stylesheets) and origins (user agent, user, author, !important, …), going though specificity calculation, inheritance and defaulting. This complicated process is not for human, it is for machine.</p>\n<p>The modern web is moving very fast, more dynamic and at a higher level of abstraction. People don’t build websites with vanilla HTML, CSS, JavaScript anymore, it’s possible but too slow and missing out too many cooked production optimizations provided by frameworks and tools.</p>\n<p>How can CSS meet the incompatible demands for simplicity (from developers), flexibility (from designers), and responsiveness (from users)? It can’t by itself, it needs help from more abstract high-level tools and techniques like pre-processors, post-processors, css-in-js to make it closer to a programming language.</p>\n<p>Above problems will prevent CSS from being used on daily basis by developers but it still mostly works just fine behind the scenes. We’re generating plain vanilla CSS using general-purpose programming languages, this could be done at project build time, or even dynamically on every page load if you have a good caching strategy.</p>\n<p>We don’t need to make CSS great again and accept it as a low-level technology, we should focus on building more supporting tools and languages that ultimately compiled to vanilla CSS so it can run perfectly in all browsers.</p>\n<p>Originally published on <a href="advancedweb.dev">advancedweb.dev</a> — a tutorial site focused on creating high quality web development tutorials, books and courses.</p>\n	0	0	2	2020-03-03 23:51:16.37551	f	f	\N	\N	en	\N	1	3 min read
75	How to iterate through a specific key-value pair in array	<p>I am working with a JSON object that consists of 250+ arrays (data related to different countries, language, currency etc.) I need a particular key-value pair (country code) to be pulled out of each array and stored in a different variable so I could use it for something else later.</p>\n<p>I have tried using forEach method but I don&#39;t have a lot of experience with it so I haven&#39;t succeeded. After googling similar questions I found that people are usually asking how to iterate though all key/value pairs and not a specific one like in this case.</p>\n<pre class="prettyprint"><code>$.getJSON(&quot;https://restcountries.eu/rest/v2/all&quot;, function(callback) { \n        var isoCode = callback\\[5\\].alpha2Code;\n        console.log(isoCode);\n });</code></pre><p>The code above pulls out the alpha2code (country code) for a specific array ([5] in this example). Which is the goal, but I need to somehow automate the process so it goes through all 250 arrays, pulls all the country codes and stores them in separate variable.</p>\n	76	0	2	2019-09-19 00:00:00	t	f	\N	\N	en	/static/thumbail_post/post_75.jpeg	2	1 min read
176	Implementing an ActionListener interface	<p>Hi, i have a problem when i put the ActionListener interface in my program. the error is &quot;Listener is not abstract and does not override abstract method actionPerfomed(java.awt.event.ActionEvent) in java.awt.event.ActionListener&quot;. I&#39;ve tryed to fix it adding new import but it still does not work. The code is below. *i&#39;m testing with BlueJ editor*</p>\n<pre class="prettyprint"><code>import javax.swing.*;\nimport java.awt.event.*;\nimport java.awt.*;\nimport java.awt.event.ActionListener.*;\nimport java.awt.event.ActionEvent.*;\nimport java.lang.Object.*;\n\npublic class Listener implements ActionListener {\n        public void actionPerfomed(ActionEvent e){\n             ...\n        }\n}</code></pre>	0	0	8	2020-02-16 12:25:05.423225	t	f	\N	\N	en	\N	1	1 min read
\.


--
-- Data for Name: replies_of_replies; Type: TABLE DATA; Schema: public; Owner: danutu
--

COPY public.replies_of_replies (id, text, reply_id, "user", posted_on) FROM stdin;
12	<p>@danutu ggg</p>\n	110	2	2020-04-15
\.


--
-- Data for Name: replyes; Type: TABLE DATA; Schema: public; Owner: danutu
--

COPY public.replyes (id, text, post_id, "user", posted_on) FROM stdin;
20	<p><img src="https://www.magnahost.co.za/po/img7.jpg" alt="https://www.magnahost.co.za/po/img7.jpg"></p>\n<p>if you looking for something like this</p>\n<p>html</p>\n<pre class="prettyprint"><code>&lt;div class=&quot;landing&quot;&gt;Hello World&lt;/div&gt;</code></pre><p>css</p>\n<pre class="prettyprint"><code>.landing { backgound-image: url(&quot;image.jpg&quot;); width: 100%; text-align: center; }</code></pre>	91	2	\N
13	<p>Ecco come si fa</p>\n<pre class="prettyprint"><code>&lt;link rel=&quot;stylesheet&quot; href=&quot;il nome del file piu la sua estensione&quot;&gt;</code></pre><p>Per esempio</p>\n<pre class="prettyprint"><code>&lt;link rel=&quot;stylesheet&quot; href=&quot;style.css&quot;&gt;</code></pre>	85	2	\N
12	<p>Ecco qui</p>\n<pre class="prettyprint"><code>int main(){\n    int a,b;\n    cin&gt;&gt;a&gt;&gt;b;\n    cout&lt;&lt;a+b;\n}</code></pre>	79	2	\N
47	<p>pai fii atent, ia un dildau d ala mic si o futi pe mata asa i se face pizda mica ca se obisnuieste cu o pula mai mica, si pula mai mare titangel</p>	126	2	2019-11-08
110	<p>First of all you have to include</p>\n<pre class="prettyprint"><code>import javax.swing.*;\nimport java.awt.*\nimport java.awt.event.*;</code></pre><p>Try to add <code>@Override</code> before the method declaration like this:</p>\n<pre class="prettyprint"><code>@Override  \npublic void actionPerformed(ActionEvent e) {\n    //do something here\n}</code></pre>	176	2	2020-02-17
\.


--
-- Data for Name: roles; Type: TABLE DATA; Schema: public; Owner: danutu
--

COPY public.roles (id, name, post_permission, delete_post_permission, delete_reply_permission, edit_post_permission, edit_reply_permission, close_post_permission, delete_user_permission, modify_user_permission, admin_panel_permission) FROM stdin;
10	Admin	t	t	t	t	t	t	t	t	t
0	Member	t	f	f	f	f	f	f	f	f
\.


--
-- Data for Name: subscriber; Type: TABLE DATA; Schema: public; Owner: danutu
--

COPY public.subscriber (id, "user", created, modified, subscription_info, is_active) FROM stdin;
12	2	\N	\N	{'endpoint': 'https://fcm.googleapis.com/fcm/send/d04MmBqNky0:APA91bF81Bi5fun3jZBXSCrDD0godycHjorNM3Fq06YW7Y5gJCT4DyOVxh0Pyw1vA7FDm0nJr5oe74sLY0ifMj_8DF9PEMCqpGcEYyqc0XTsGmC4JyYyzWxbxv3TrjhR0zMtuceY4jxP', 'expirationTime': None, 'keys': {'p256dh': 'BHo8aoJ0LtD5C2nIXfCVXDsLIe6Eyv6VdLf4SrAXy45tbHJm5q603VKntbyI_o4ocQZ4TnkP54Ipvq8gIm9n-go', 'auth': 'V_A05HZsizxsQ3kj1tSy9A'}}	t
13	2	\N	\N	{'endpoint': 'https://fcm.googleapis.com/fcm/send/eLVDm9WkN1w:APA91bHD0NItte7o_jmQroTR2NBpAvpPKQx7PuybcbH2fhTsSpBjbxDp7vwHh7G9toiCGveug6n3JbgbdegUKgRqFvPihtVjCNNNRS5c6y5BrcF9p_BrJQ9hGVUmcQBjDtkyGMxq6EUK', 'expirationTime': None, 'keys': {'p256dh': 'BBTxLSH6QwsgOfmhsG4lpRUoTYi5OMVXw0aN7ms5GzYfW13vZZ0ZmLG1W5jzSvw6CchWw6Eds7aYHSW08dcwX0A', 'auth': 'OtDQCNoytFRCAg1VrDoomg'}}	t
14	2	\N	\N	{'endpoint': 'https://fcm.googleapis.com/fcm/send/eGTZn8dyHI0:APA91bFWUU4DqDT3P3ZsPVGNCWWmkq-CNBQz-4oJky170C_517KBQxMqQckX567nlopfUIdj0qPscTngBn_yE5HV23sH1G3dpSqf5mtji3KlwsUaVuo9byaNEAHE61F8JfvtYUVj6V-Y', 'expirationTime': None, 'keys': {'p256dh': 'BA_9xOZBhS9uetJB7nKID5YK0K3c8FDM9fPqNE63_kdmPMGqwRJyaWrNV017dGfMUy7zXGAKEBld-07a3CGAWiY', 'auth': 'sR4fed4Lcrt4D6Qe7ehmIg'}}	t
15	6	\N	\N	{'endpoint': 'https://fcm.googleapis.com/fcm/send/e_oRtMwZqbU:APA91bGN_Qi_zJxe_D4ayqSyvLMy5mD6aLihOpMHBlSTmEV438mvUPKnVLedm1pqvnS3DHP_SZLzYCywOVaZ9mlfzoc4qyYozjkvFVUjh4yHaF1e3R1H4wKb-KFT7Hdz2lLIpIYA0F4o', 'expirationTime': None, 'keys': {'p256dh': 'BGFZExl3Fnm-v7kbjL7BkjKHURFRAxjqo1mxObTc6l0dIdQKtWvSYm_dbLNbW_jKEIdwFRvUBypNvuMCUvh6bb8', 'auth': 'l3dnOeL8K0Y0DWSxlgE21A'}}	t
16	2	\N	\N	{'endpoint': 'https://fcm.googleapis.com/fcm/send/dKdwWoW_2xg:APA91bGbH-Un_d3b7tgKHoDqqt1oPBfJqgelsWc5dMpRPURHoFLuBahCNNmGgY8MgcqFg1chktxnrCStFTPdZKb4PLo-sXuiEpY5JGo6eMtIRA7PkWZ8G3L8Qgx0Bk42YAnj91rHsfRX', 'expirationTime': None, 'keys': {'p256dh': 'BEcnb_bqmdg4kyBGzKVLhACP_91x_bEfSX78PY7Nf4UiOgjEc_l40NO8aO4MoyhgTIJJ5yYWa9IxBFEpI0Xq7Wk', 'auth': 'rtiGvN8Q-GDUuBgri9WD4g'}}	t
17	2	\N	\N	{'endpoint': 'https://fcm.googleapis.com/fcm/send/dYTdxsZ_g6M:APA91bGCC4cV7maaJs-xtYDIY3dvs_6GNaw6uqEvvjek8zHNK-CKBcjTkqRZdNcmRJBUB4rR--x3MZFQN53cMdqFq9T18ssJl-BFqbmz-Z8JVfUWUc7a91dBpdXb7HuyAanyO8yEzx-X', 'expirationTime': None, 'keys': {'p256dh': 'BBEqi6M0PqiMh0uyxRNFIR2dudnIx785XIr-j02irbeB8rFviGTLtcS0v0KmhL3MDRhj8oEEJ62cQ2ZSL9Rq3g4', 'auth': 'kgG1-naPXftCS4uHnLsV9Q'}}	t
18	6	\N	\N	{'endpoint': 'https://fcm.googleapis.com/fcm/send/dT-48JsrU9s:APA91bETe05Uxs9WDFdHEboS6UWt-3aD9WxH4hnrKIWrYuvNqR6Yoyd3eiyemPd7aMCqMkmUChNUp5VAQP2c9uUYRGPkBQUVJDwtAI9D8zEQQ2BuXf5XOjy_ID_QS0AZwT9stSKEEmIc', 'expirationTime': None, 'keys': {'p256dh': 'BClBrlfJqEu4DAt9gkvcHV60K_dSiBZvlY4klVRZyPfT2yh8U7knkPdUdFM8KPp2yatqXvd_x3A9KnMTOnx_eUc', 'auth': 'EDcITziBNYar_ee1Ut2kPg'}}	t
19	2	\N	\N	{'endpoint': 'https://fcm.googleapis.com/fcm/send/dCwp28GUew4:APA91bFiAovS8gBXhbddwxosPJvnBxbLe_IUdLgU_l2jbEDiCm1Kup0gNItsUQGj9STBqiqCn49urHjeSFxncNNGlBelZ1gzbRPmMsM019eqlS0V2-CyEr78-pVPSyODIuwh9dIqwOJN', 'expirationTime': None, 'keys': {'p256dh': 'BAz9ahwfLUKXS8DOc2Z0hYWONPLzGeCA0Ud_Dfyym2aJo8-0aDaDUOyzy5WOWaIoXWsLL7iqEpCog8KGkVf6geA', 'auth': 'Ku7s2St1OiOXi7hj2eFmAg'}}	t
10	2	\N	\N	{'endpoint': 'https://fcm.googleapis.com/fcm/send/dMvvVMOja2w:APA91bHYW-wI6D-r3KiPQ1kkYv7oGuGXj4Xu7mL8zULN8q4iU-O4v0Pp_AznpmLuUsNMl0Cc4VfMh3omT_9k8vsOKWINhRxdzGap9UQCgfhJry1v2WMY_8WC9totfuKo5kjaVN3_3nVJ', 'expirationTime': None, 'keys': {'p256dh': 'BF-PdPW3rhL9eia6W5exNWm0SXlKf-fAP8XW5c7CfOjidnlDb7IQ9eU6ByOPO4DacafsO_iAsqrF30jeFHRTxIY', 'auth': '_T09toeTD4NkcALVtsFXnw'}}	t
11	2	\N	\N	{'endpoint': 'https://fcm.googleapis.com/fcm/send/cyqAQeLlf44:APA91bHK2ikUft0uogpGi6tPjzbpq7AbGJPYaNPygZ4Il1juWL1EmHyFJE2USYgvUW98_-7nsKJ4hAlyEvcOOqvWBoK1j5oPe6UxynPxNgzFXVXSJsIlNlSXMTeWci0Tk17GOeBzMLp8', 'expirationTime': None, 'keys': {'p256dh': 'BDszKCRUDCVOFcjMutRyzk_q4Vo9VETc-1-yBO-80G7BGxs8m6_5XhMju5RJwVOUKSppe73bY5F2FCg1Dbe-sPA', 'auth': 'rD2fIdvSiYoz-mhSKDZN_g'}}	t
20	2	\N	\N	{'endpoint': 'https://fcm.googleapis.com/fcm/send/ct8aL0PDzFU:APA91bGQ-oAK8EP9mQyRSx1VeA3xLazLn89YQZNnM0QNNL3XkHgEonctLP9u1l7i5UY5H081GD-0optcwQTUmqXE-GKTsDpmhtDErGUWoIWdxgEDVxdEeAZHr2h5Fh4BY2vt3fOSJAzE', 'expirationTime': None, 'keys': {'p256dh': 'BMbgoQM4psA3IJqKSOM8iolcSDqZTvGaFpq2DGo_W6wvqC9Dr3nRXs6T3z3NGcox7-MZsIscyjCVrfqyseDG0Zw', 'auth': 'SNl-742Doy2s9qH9wdOi4g'}}	t
21	2	\N	\N	{'endpoint': 'https://fcm.googleapis.com/fcm/send/c03_M1Z992Y:APA91bEOM6nTJaQEzNMj12K9dZ6FRIxXD5F0Su8fUSCfrUoHnhqqLuHBq-_Z5t-jDzwj6q4OuKwrFPfMQrPB5TsWWNvbOZeObp7Sk9EeWXSahOrXJpymxK-0kiw9tOqwiFH4IIpfrbAj', 'expirationTime': None, 'keys': {'p256dh': 'BLB_doJlGhj1bQGUL6OoXzeiSmlI382h74AQHD1p9gmh1sjD2D4AqNdfvqfGBeyM0Aw-uMp1gaxXCrJ-eK0MKbc', 'auth': '2OJsRGJZOkeq7MY1SRqXYg'}}	t
22	2	\N	\N	{'endpoint': 'https://fcm.googleapis.com/fcm/send/eKD-fAnF9tc:APA91bEb7pTR7TT07iRSFIwidiwrMkh1xdaN7A0mf-YUwrYUPCItbevAG341klIR6thphdHiDFWj6D6rCIP-r0AK8SsGm9IZ4Sf5mZUoBZMP1IccgCUeUi-s33i-tPLhc9fWFsBNhajY', 'expirationTime': None, 'keys': {'p256dh': 'BH3sbtSMfhDQBryUT7Os6c8BDANLlsvW6_mzDbIy9QhiAO60gVuQ2iRxUbvSjSWrEPwLOrv_cimXzSbHkGRVIMw', 'auth': 'NCDHzD9TTjSWviGiHEvFZQ'}}	t
23	2	\N	\N	{'endpoint': 'https://fcm.googleapis.com/fcm/send/d0-tgN3NUs8:APA91bFUzEk-rNuM-lSWV1pi_afIbs5UUHbKAq20r7_Q0e0Ee6Tz3I9Ixdrrzuz47FK7cKpmQkI7HNn-jXlZxLhjtldaxtMsXrw-N_xpZXCsgBrK00HnL02bRqdCnQ9JepHPRZ9GDprL', 'expirationTime': None, 'keys': {'p256dh': 'BNhNfjVpDd3fnqTDc6HnmOmxFpu_ozkYSVxRwipOLwwTBJR4bfVmuCV5OaDijrT37ThtrvIG0bufybsmKVKHJaU', 'auth': 'iveU5z5iAGrVaoViZQq0Cw'}}	t
\.


--
-- Data for Name: tags; Type: TABLE DATA; Schema: public; Owner: danutu
--

COPY public.tags (id, name, post) FROM stdin;
27	numpy	{13,68}
19	python	{1,13,14,15,16,45,58,61,68,140,171}
18	java	{1,176}
62	actionlistener	{176}
37	json	{75}
23	c++	{1,79}
50	general	{115}
52	advice	{119}
53	motivation	{119}
54	programming	{119}
55	juniordev	{121}
20	ruby	{1}
21	go	{1}
22	php	{1}
25	c	{1}
45	opensource	{97}
26	performance	{13}
49	career	{115,121}
28	datetime	{14}
29	pandas	{15}
30	dataframe	{15}
31	azure-databricks	{15}
32	django	{16}
33	django-forms	{16}
34	django-views	{16}
57	cumsafacpizdamicainapoi	{126}
36	flask	{61}
46	release	{}
48	tutorial	{}
38	html	{85,91}
59	productivity	{155}
41	discuss	{93,155}
42	howto	{97}
43	gnome	{}
24	javascript	{1,75,97,168,170,173,189}
39	css	{85,91,189}
44	webdev	{97,189}
51	beginners	{119,121,155,189}
61	svelte	{168,170,171,173}
\.


--
-- Data for Name: user_devices; Type: TABLE DATA; Schema: public; Owner: danutu
--

COPY public.user_devices (id, "user", device_type, device_model, device_brand, last_access, activated, ip_address) FROM stdin;
8	2	smartphone	Nexus 5	Google	2019-11-22 09:07:54.278167	t	{79.9.149.195,151.76.194.180}
10	20	desktop		UNK	2019-11-26 05:51:09.681488	t	{79.9.149.195}
11	31	smartphone	GALAXY A50	Samsung	2019-11-26 07:23:11.759055	t	{37.161.249.124}
12	4	desktop		UNK	2019-11-26 12:18:21.966555	t	{151.76.194.180}
13	8	desktop		UNK	2020-02-16 12:08:49.765541	t	{151.26.193.66,151.26.170.183}
7	2	smartphone	P20 Lite	Huawei	2019-11-26 18:16:37.241304	t	{151.76.194.180,151.76.194.180,151.76.194.180,79.3.19.242}
9	2	desktop		UNK	2020-02-26 11:35:10.322447	t	{151.76.194.180,79.9.149.195,151.26.239.201,79.3.19.242,151.76.132.83,86.120.42.5,151.76.134.19,151.26.251.38,151.26.235.124,151.26.254.132,151.26.238.178,151.76.192.171}
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: danutu
--

COPY public.users (id, join_date, name, real_name, email, password, avatar, genre, role, bio, activated, ip_address, browser, country_name, country_flag, lang, int_tags, birthday, profession, saved_posts, liked_posts, follow, followed, cover, instagram, facebook, twitter, github, website, theme, int_podcasts, status_color, status, theme_mode, installed) FROM stdin;
8	2019-09-20	filipp0	Filippo Benevenga	filippobenevenga2002@gmail.com	$2b$12$pwv7oavlVIZ0pjvz0YzkI.EDriYyelxcjP0CRzyHntBlClUX.RzrW	https://newapp.nl/static/profile_pics/user_8.webp	Male	0	Hey, I’m a Neo Dev	t	151.26.170.183	Chrome	Italy	it	it	{}	\N	Hey, I’m a Neo Dev	{}	{15,14}	{2}	{2}	https://newapp.nl/static/profile_cover/user_8.webp	filippo_benevenga	\N	\N	\N	\N	Dark	{}	#cc1616	Offline	\N	\N
4	2019-09-06	daniel	Dan Ioan	dany89ytro@gmail.com	$2b$12$Oc7Wkm0nm/Phu0UDPknoDuuJbidfJiemYaWmumduUpjt2RLCsX6BS	https://www.component-creator.com/images/testimonials/defaultuser.png	Male	0	Hey i`m new here	t	151.76.194.180	Chrome	Italy	it	it	{javascript}	\N	None	{}	{16,1,75,97}	{2}	{2}	\N						Light	{}	#cc1616	Offline	system	\N
6	2019-09-20	alessandrocrt	Alessandro Carta	alecarta002@gmail.com	$2b$12$gL.vW/kpHzs8TLinmz7xkeBuzOK5McipYMREawDkmIt0weKpmCuKy	https://www.component-creator.com/images/testimonials/defaultuser.png	None	0	Hey i`m new here	t	151.37.112.183	Chrome	Italy	it	it	{c++,python,html,css}	\N	\N	{}	{16,155}	{2}	{2}	\N	\N	\N	\N	\N	\N	Dark	{}	\N	\N	\N	\N
12	2019-10-12	bosco	John	bwjbrown42@gmail.com	$2b$12$DcOQ80OXZ2S/RnhG98SVdOJJmByP844cVOoXbhM4z43RpT4g5eMRy	https://www.component-creator.com/images/testimonials/defaultuser.png	None	0	Hey i`m new here	\N	129.205.113.101	Chrome	Nigeria	ng	en	{}	\N	\N	{}	{}	{}	{}	\N	\N	\N	\N	\N	\N	Light	{}	\N	\N	\N	\N
11	2019-10-05	s.iezzi	samuele	samuele.iezzi123@gmail.com	$2b$12$I9y0Vo2sAk//3Uh./sELOeq6efBr6.Ts5wEm8TzYePVzNT2eLpNz6	https://www.component-creator.com/images/testimonials/defaultuser.png	None	0	Hey i`m new here	t	79.3.19.242	Chrome	Italy	it	it	{}	\N	\N	{}	{1}	{2}	{2}	\N	\N	\N	\N	\N	\N	Light	{}	\N	\N	\N	\N
7	2019-09-20	barbacani02	Luca Barbacani	barbas1907@gmail.com	$2b$12$7.TRpZLOtbpbZdepiFF3SOM4E7rD83rk4MXgVoDNDcPIcnQpFHIF2	https://www.component-creator.com/images/testimonials/defaultuser.png	None	0	Hey i`m new here	t	37.162.218.159	Chrome	Italy	it	it	{c++}	\N	\N	{}	{}	{2}	{2}	\N	\N	\N	\N	\N	\N	Light	{}	\N	\N	\N	\N
5	2019-09-14	tuccyno	Lorenzo	lorenzo.tucci90@virgilio.it	$2b$12$de21f9n5pa8DEsM70PfMN.XV6yoSQrcaJq3QTvJrehiP1XXTxgX4C	/static/profile_pics/user_5.jpg	Male	0	Hey i`m new here	t	79.9.149.195	Chrome	Italy	it	it	{c++,python}	\N	None	{}	{}	{2}	{2}	\N	https://www.instagram.com/lorenzo_tucc1					Dark	{}	\N	\N	\N	\N
19	2019-11-05	funnygame	Francesco Guerrero	faferrarigp75@gmail.com	$2b$12$VVQsPBDSzgzRAFd2I9fagOE81o/RQ7giLzHhKdSOMAQIK4unUEcy6	https://www.component-creator.com/images/testimonials/defaultuser.png	None	0	Hey i`m new here, it's a pleasure to meet you!	t	5.90.173.65	Chrome	Italy	it	it	{}	\N	Student	{}	{}	{2}	{2}	\N	https://www.instagram.com/francesco.guerrero/					Dark	{}	\N	\N	\N	\N
20	2019-11-05	topogigio	Armand LuLett	ndando.nda@gmail.com	$2b$12$6gsbwYW9Bitt0CtU6CCDjOMGYSa9EaMdYfaOU3fUCq/7MwLWu5CZG	/static/profile_pics/user_20.webp	Male	0	.	t	79.9.149.195	Chrome	Italy	it	it	{}	\N	None	{}	{}	{}	{2}	/static/profile_cover/user_20.webp						Light	{}	#cc1616	Offline	\N	\N
31	2019-11-26	emmegabri	Gabriele	hotskymarco@hotmail.it	$2b$12$luf/lKq8YSQDP844M7p94uz2Pw/j3Lqc63Mv7kmizwJjqMzCN7XWi	https://www.component-creator.com/images/testimonials/defaultuser.png	None	0	Hey i`m new here	t	37.161.249.124	Chrome	Italy	it	it	{}	\N	\N	{}	{}	{}	{}	\N	\N	\N	\N	\N	\N	Light	{}	#cc1616	Offline	system	\N
25	2019-11-08	ciprian	Ciprian Sutu	sutuciprian89@gmail.com	$2b$12$gqKW29rE1EeBiGRLSuX1eOLff.o3L9oZJJhIeGQE8DpjARaGhnmgu	https://www.component-creator.com/images/testimonials/defaultuser.png	Male	0	Hey i`m new here	t	86.120.42.5	Chrome	Romania	ro	ro	{}	\N	None	{}	{}	{}	{2}	\N						Light	{}	\N	\N	\N	\N
2	2019-07-20	danutu	Daniel Ionut	danutu@newapp.nl	$2b$12$kZ1VTFKIwidOiH31fWbJX.rOZuUDQsbCJ8J3B9.6ptn.mQZJ11m0m	/static/profile_pics/user_2.webp	Female	10	The website Developer	t	151.76.192.171	Chrome	Italy	it	it	{opensource,beginners,javascript,css,flask,python,svelte}	2001-09-29	Junior Web Developer	{93,16,13}	{13,79,85,91,15,95,126,170,93,119,16,1,121,14,194,189,115,155,97,75,176}	{7,19,20,5,4,25,8,11,6}	{7,5,8,6,11,19,4}	https://newapp.nl/static/profile_cover/user_2.webp	daniel9ionut	danutu89	Danutu89	Danutu89	https://newapp.nl	Dark	{}	#00c413	Online	manual	\N
\.


--
-- Name: analyze_pages_id_seq; Type: SEQUENCE SET; Schema: public; Owner: danutu
--

SELECT pg_catalog.setval('public.analyze_pages_id_seq', 13895, true);


--
-- Name: analyze_session_id_seq; Type: SEQUENCE SET; Schema: public; Owner: danutu
--

SELECT pg_catalog.setval('public.analyze_session_id_seq', 21017, true);


--
-- Name: coordinates_locations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: danutu
--

SELECT pg_catalog.setval('public.coordinates_locations_id_seq', 1, false);


--
-- Name: ip_coordinates_code_seq; Type: SEQUENCE SET; Schema: public; Owner: danutu
--

SELECT pg_catalog.setval('public.ip_coordinates_code_seq', 66, true);


--
-- Name: likes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: danutu
--

SELECT pg_catalog.setval('public.likes_id_seq', 1, false);


--
-- Name: notifications_id_seq; Type: SEQUENCE SET; Schema: public; Owner: danutu
--

SELECT pg_catalog.setval('public.notifications_id_seq', 45, true);


--
-- Name: podcasts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: danutu
--

SELECT pg_catalog.setval('public.podcasts_id_seq', 1, false);


--
-- Name: podcasts_series_id_seq; Type: SEQUENCE SET; Schema: public; Owner: danutu
--

SELECT pg_catalog.setval('public.podcasts_series_id_seq', 9, true);


--
-- Name: posts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: danutu
--

SELECT pg_catalog.setval('public.posts_id_seq', 194, true);


--
-- Name: replies_of_replies_id_seq; Type: SEQUENCE SET; Schema: public; Owner: danutu
--

SELECT pg_catalog.setval('public.replies_of_replies_id_seq', 12, true);


--
-- Name: replyes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: danutu
--

SELECT pg_catalog.setval('public.replyes_id_seq', 142, true);


--
-- Name: role_id_seq; Type: SEQUENCE SET; Schema: public; Owner: danutu
--

SELECT pg_catalog.setval('public.role_id_seq', 1, false);


--
-- Name: subscriber_id_seq; Type: SEQUENCE SET; Schema: public; Owner: danutu
--

SELECT pg_catalog.setval('public.subscriber_id_seq', 23, true);


--
-- Name: tags_id_seq; Type: SEQUENCE SET; Schema: public; Owner: danutu
--

SELECT pg_catalog.setval('public.tags_id_seq', 62, true);


--
-- Name: user_devices_id_seq; Type: SEQUENCE SET; Schema: public; Owner: danutu
--

SELECT pg_catalog.setval('public.user_devices_id_seq', 13, true);


--
-- Name: user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: danutu
--

SELECT pg_catalog.setval('public.user_id_seq', 42, true);


--
-- Name: analyze_pages analyze_pages_pkey; Type: CONSTRAINT; Schema: public; Owner: danutu
--

ALTER TABLE ONLY public.analyze_pages
    ADD CONSTRAINT analyze_pages_pkey PRIMARY KEY (id);


--
-- Name: analyze_session analyze_session_pkey; Type: CONSTRAINT; Schema: public; Owner: danutu
--

ALTER TABLE ONLY public.analyze_session
    ADD CONSTRAINT analyze_session_pkey PRIMARY KEY (id);


--
-- Name: coordinates_locations coordinates_locations_pkey; Type: CONSTRAINT; Schema: public; Owner: danutu
--

ALTER TABLE ONLY public.coordinates_locations
    ADD CONSTRAINT coordinates_locations_pkey PRIMARY KEY (code_ip);


--
-- Name: ip_coordinated ip_coordinated_pkey; Type: CONSTRAINT; Schema: public; Owner: danutu
--

ALTER TABLE ONLY public.ip_coordinated
    ADD CONSTRAINT ip_coordinated_pkey PRIMARY KEY (code);


--
-- Name: likes likes_pkey; Type: CONSTRAINT; Schema: public; Owner: danutu
--

ALTER TABLE ONLY public.likes
    ADD CONSTRAINT likes_pkey PRIMARY KEY (id);


--
-- Name: notifications notifications_pkey; Type: CONSTRAINT; Schema: public; Owner: danutu
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT notifications_pkey PRIMARY KEY (id);


--
-- Name: podcast_series podcast_series_pkey; Type: CONSTRAINT; Schema: public; Owner: danutu
--

ALTER TABLE ONLY public.podcast_series
    ADD CONSTRAINT podcast_series_pkey PRIMARY KEY (id);


--
-- Name: podcasts podcasts_pkey; Type: CONSTRAINT; Schema: public; Owner: danutu
--

ALTER TABLE ONLY public.podcasts
    ADD CONSTRAINT podcasts_pkey PRIMARY KEY (id);


--
-- Name: posts posts_pkey; Type: CONSTRAINT; Schema: public; Owner: danutu
--

ALTER TABLE ONLY public.posts
    ADD CONSTRAINT posts_pkey PRIMARY KEY (id);


--
-- Name: replies_of_replies replies_of_replies_pkey; Type: CONSTRAINT; Schema: public; Owner: danutu
--

ALTER TABLE ONLY public.replies_of_replies
    ADD CONSTRAINT replies_of_replies_pkey PRIMARY KEY (id);


--
-- Name: replyes replyes_pkey; Type: CONSTRAINT; Schema: public; Owner: danutu
--

ALTER TABLE ONLY public.replyes
    ADD CONSTRAINT replyes_pkey PRIMARY KEY (id);


--
-- Name: roles roles_pkey; Type: CONSTRAINT; Schema: public; Owner: danutu
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (id);


--
-- Name: subscriber subscriber_pkey; Type: CONSTRAINT; Schema: public; Owner: danutu
--

ALTER TABLE ONLY public.subscriber
    ADD CONSTRAINT subscriber_pkey PRIMARY KEY (id);


--
-- Name: tags tags_pkey; Type: CONSTRAINT; Schema: public; Owner: danutu
--

ALTER TABLE ONLY public.tags
    ADD CONSTRAINT tags_pkey PRIMARY KEY (id);


--
-- Name: user_devices user_devices_pkey; Type: CONSTRAINT; Schema: public; Owner: danutu
--

ALTER TABLE ONLY public.user_devices
    ADD CONSTRAINT user_devices_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: danutu
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: ix_users_id; Type: INDEX; Schema: public; Owner: danutu
--

CREATE INDEX ix_users_id ON public.users USING btree (id);


--
-- Name: coordinates_locations coordinates_locations_code_ip_fkey; Type: FK CONSTRAINT; Schema: public; Owner: danutu
--

ALTER TABLE ONLY public.coordinates_locations
    ADD CONSTRAINT coordinates_locations_code_ip_fkey FOREIGN KEY (code_ip) REFERENCES public.ip_coordinated(code);


--
-- Name: likes likes_user_fkey; Type: FK CONSTRAINT; Schema: public; Owner: danutu
--

ALTER TABLE ONLY public.likes
    ADD CONSTRAINT likes_user_fkey FOREIGN KEY ("user") REFERENCES public.users(id);


--
-- Name: notifications notifications_for_user_fkey; Type: FK CONSTRAINT; Schema: public; Owner: danutu
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT notifications_for_user_fkey FOREIGN KEY (for_user) REFERENCES public.users(id);


--
-- Name: notifications notifications_user_fkey; Type: FK CONSTRAINT; Schema: public; Owner: danutu
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT notifications_user_fkey FOREIGN KEY ("user") REFERENCES public.users(id);


--
-- Name: podcasts podcasts_series_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: danutu
--

ALTER TABLE ONLY public.podcasts
    ADD CONSTRAINT podcasts_series_id_fkey FOREIGN KEY (series_id) REFERENCES public.podcast_series(id);


--
-- Name: posts posts_user_fkey; Type: FK CONSTRAINT; Schema: public; Owner: danutu
--

ALTER TABLE ONLY public.posts
    ADD CONSTRAINT posts_user_fkey FOREIGN KEY ("user") REFERENCES public.users(id);


--
-- Name: replies_of_replies replies_of_replies_reply_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: danutu
--

ALTER TABLE ONLY public.replies_of_replies
    ADD CONSTRAINT replies_of_replies_reply_id_fkey FOREIGN KEY (reply_id) REFERENCES public.replyes(id);


--
-- Name: replies_of_replies replies_of_replies_user_fkey; Type: FK CONSTRAINT; Schema: public; Owner: danutu
--

ALTER TABLE ONLY public.replies_of_replies
    ADD CONSTRAINT replies_of_replies_user_fkey FOREIGN KEY ("user") REFERENCES public.users(id);


--
-- Name: replyes replyes_user_fkey; Type: FK CONSTRAINT; Schema: public; Owner: danutu
--

ALTER TABLE ONLY public.replyes
    ADD CONSTRAINT replyes_user_fkey FOREIGN KEY ("user") REFERENCES public.users(id);


--
-- Name: user_devices user_devices_user_fkey; Type: FK CONSTRAINT; Schema: public; Owner: danutu
--

ALTER TABLE ONLY public.user_devices
    ADD CONSTRAINT user_devices_user_fkey FOREIGN KEY ("user") REFERENCES public.users(id);


--
-- Name: users users_role_fkey; Type: FK CONSTRAINT; Schema: public; Owner: danutu
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_role_fkey FOREIGN KEY (role) REFERENCES public.roles(id);


--
-- PostgreSQL database dump complete
--

