--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

--
-- Name: count_rows(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION count_rows() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
    BEGIN
      IF TG_OP = 'INSERT' THEN
        UPDATE rowcount
        SET total_rows = total_rows + 1
        WHERE table_name = TG_RELNAME;
      ELSIF TG_OP = 'DELETE' THEN
        UPDATE rowcount
        SET total_rows = total_rows - 1
        WHERE table_name = TG_RELNAME;
      END IF;
    RETURN NULL;
    END;
    $$;


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: events; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE events (
    id integer NOT NULL,
    email character varying(255),
    name character varying(255),
    category text,
    data text,
    happened_at timestamp without time zone,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    unique_args text,
    mailer_action character varying(255)
);


--
-- Name: events_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE events_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: events_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE events_id_seq OWNED BY events.id;


--
-- Name: rowcount; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE rowcount (
    table_name text NOT NULL,
    total_rows bigint
);


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE schema_migrations (
    version character varying(255) NOT NULL
);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY events ALTER COLUMN id SET DEFAULT nextval('events_id_seq'::regclass);


--
-- Name: events_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY events
    ADD CONSTRAINT events_pkey PRIMARY KEY (id);


--
-- Name: rowcount_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY rowcount
    ADD CONSTRAINT rowcount_pkey PRIMARY KEY (table_name);


--
-- Name: index_events_on_email; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_events_on_email ON events USING btree (email);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user",public;

INSERT INTO schema_migrations (version) VALUES ('20130317175842');

INSERT INTO schema_migrations (version) VALUES ('20130320083748');

INSERT INTO schema_migrations (version) VALUES ('20130320091131');

INSERT INTO schema_migrations (version) VALUES ('20130320094652');

INSERT INTO schema_migrations (version) VALUES ('20130423112658');

INSERT INTO schema_migrations (version) VALUES ('20130624173016');

INSERT INTO schema_migrations (version) VALUES ('20130624183059');

INSERT INTO schema_migrations (version) VALUES ('20130625110032');

INSERT INTO schema_migrations (version) VALUES ('20130629203432');

INSERT INTO schema_migrations (version) VALUES ('20140314222224');

INSERT INTO schema_migrations (version) VALUES ('20140603114446');

