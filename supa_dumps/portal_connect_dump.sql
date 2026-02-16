--
-- PostgreSQL database dump
--

\restrict mZnlKEmm1e2xFNaH2YZWb5CkqM1nFi4OhxsyadGwq1CDvf6SfFgaVkOEXlz5xIk

-- Dumped from database version 17.6
-- Dumped by pg_dump version 18.1

-- Started on 2026-02-15 18:59:29

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 31 (class 2615 OID 16494)
-- Name: auth; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA auth;


--
-- TOC entry 21 (class 2615 OID 16388)
-- Name: extensions; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA extensions;


--
-- TOC entry 29 (class 2615 OID 16624)
-- Name: graphql; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA graphql;


--
-- TOC entry 28 (class 2615 OID 16613)
-- Name: graphql_public; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA graphql_public;


--
-- TOC entry 13 (class 2615 OID 16386)
-- Name: pgbouncer; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA pgbouncer;


--
-- TOC entry 22 (class 2615 OID 106219)
-- Name: public; Type: SCHEMA; Schema: -; Owner: -
--

-- *not* creating schema, since initdb creates it


--
-- TOC entry 5185 (class 0 OID 0)
-- Dependencies: 22
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON SCHEMA public IS '';


--
-- TOC entry 10 (class 2615 OID 16605)
-- Name: realtime; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA realtime;


--
-- TOC entry 32 (class 2615 OID 16542)
-- Name: storage; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA storage;


--
-- TOC entry 12 (class 2615 OID 17292)
-- Name: supabase_migrations; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA supabase_migrations;


--
-- TOC entry 26 (class 2615 OID 16653)
-- Name: vault; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA vault;


--
-- TOC entry 7 (class 3079 OID 109220)
-- Name: btree_gist; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS btree_gist WITH SCHEMA public;


--
-- TOC entry 5186 (class 0 OID 0)
-- Dependencies: 7
-- Name: EXTENSION btree_gist; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION btree_gist IS 'Required for exclusion constraints combining equality and range operators';


--
-- TOC entry 6 (class 3079 OID 16689)
-- Name: pg_graphql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_graphql WITH SCHEMA graphql;


--
-- TOC entry 5187 (class 0 OID 0)
-- Dependencies: 6
-- Name: EXTENSION pg_graphql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pg_graphql IS 'pg_graphql: GraphQL support';


--
-- TOC entry 2 (class 3079 OID 16389)
-- Name: pg_stat_statements; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_stat_statements WITH SCHEMA extensions;


--
-- TOC entry 5188 (class 0 OID 0)
-- Dependencies: 2
-- Name: EXTENSION pg_stat_statements; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pg_stat_statements IS 'track planning and execution statistics of all SQL statements executed';


--
-- TOC entry 4 (class 3079 OID 16443)
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA extensions;


--
-- TOC entry 5189 (class 0 OID 0)
-- Dependencies: 4
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


--
-- TOC entry 5 (class 3079 OID 16654)
-- Name: supabase_vault; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS supabase_vault WITH SCHEMA vault;


--
-- TOC entry 5190 (class 0 OID 0)
-- Dependencies: 5
-- Name: EXTENSION supabase_vault; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION supabase_vault IS 'Supabase Vault Extension';


--
-- TOC entry 3 (class 3079 OID 16432)
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA extensions;


--
-- TOC entry 5191 (class 0 OID 0)
-- Dependencies: 3
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


--
-- TOC entry 1367 (class 1247 OID 16782)
-- Name: aal_level; Type: TYPE; Schema: auth; Owner: -
--

CREATE TYPE auth.aal_level AS ENUM (
    'aal1',
    'aal2',
    'aal3'
);


--
-- TOC entry 1391 (class 1247 OID 16923)
-- Name: code_challenge_method; Type: TYPE; Schema: auth; Owner: -
--

CREATE TYPE auth.code_challenge_method AS ENUM (
    's256',
    'plain'
);


--
-- TOC entry 1364 (class 1247 OID 16776)
-- Name: factor_status; Type: TYPE; Schema: auth; Owner: -
--

CREATE TYPE auth.factor_status AS ENUM (
    'unverified',
    'verified'
);


--
-- TOC entry 1361 (class 1247 OID 16771)
-- Name: factor_type; Type: TYPE; Schema: auth; Owner: -
--

CREATE TYPE auth.factor_type AS ENUM (
    'totp',
    'webauthn',
    'phone'
);


--
-- TOC entry 1520 (class 1247 OID 32617)
-- Name: oauth_authorization_status; Type: TYPE; Schema: auth; Owner: -
--

CREATE TYPE auth.oauth_authorization_status AS ENUM (
    'pending',
    'approved',
    'denied',
    'expired'
);


--
-- TOC entry 1532 (class 1247 OID 32689)
-- Name: oauth_client_type; Type: TYPE; Schema: auth; Owner: -
--

CREATE TYPE auth.oauth_client_type AS ENUM (
    'public',
    'confidential'
);


--
-- TOC entry 1403 (class 1247 OID 17004)
-- Name: oauth_registration_type; Type: TYPE; Schema: auth; Owner: -
--

CREATE TYPE auth.oauth_registration_type AS ENUM (
    'dynamic',
    'manual'
);


--
-- TOC entry 1523 (class 1247 OID 32626)
-- Name: oauth_response_type; Type: TYPE; Schema: auth; Owner: -
--

CREATE TYPE auth.oauth_response_type AS ENUM (
    'code'
);


--
-- TOC entry 1397 (class 1247 OID 16965)
-- Name: one_time_token_type; Type: TYPE; Schema: auth; Owner: -
--

CREATE TYPE auth.one_time_token_type AS ENUM (
    'confirmation_token',
    'reauthentication_token',
    'recovery_token',
    'email_change_token_new',
    'email_change_token_current',
    'phone_change_token'
);


--
-- TOC entry 1442 (class 1247 OID 109107)
-- Name: ads_advertiser_status; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.ads_advertiser_status AS ENUM (
    'active',
    'inactive'
);


--
-- TOC entry 1445 (class 1247 OID 109112)
-- Name: ads_campaign_status; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.ads_campaign_status AS ENUM (
    'draft',
    'active',
    'paused',
    'ended'
);


--
-- TOC entry 1550 (class 1247 OID 106648)
-- Name: audit_category; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.audit_category AS ENUM (
    'auth',
    'users',
    'content',
    'media',
    'reports',
    'settings',
    'integrations',
    'system'
);


--
-- TOC entry 1547 (class 1247 OID 106642)
-- Name: audit_result; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.audit_result AS ENUM (
    'success',
    'failure'
);


--
-- TOC entry 1544 (class 1247 OID 106634)
-- Name: audit_severity; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.audit_severity AS ENUM (
    'info',
    'warning',
    'critical'
);


--
-- TOC entry 1592 (class 1247 OID 106457)
-- Name: content_slot; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.content_slot AS ENUM (
    'home_hero',
    'home_inspire',
    'home_experiences',
    'home_where_stay',
    'home_food',
    'home_agenda',
    'home_city_updates'
);


--
-- TOC entry 1427 (class 1247 OID 106526)
-- Name: event_status; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.event_status AS ENUM (
    'draft',
    'published',
    'archived'
);


--
-- TOC entry 1541 (class 1247 OID 106625)
-- Name: invitation_status; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.invitation_status AS ENUM (
    'pending',
    'accepted',
    'expired',
    'revoked'
);


--
-- TOC entry 1569 (class 1247 OID 106422)
-- Name: media_kind; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.media_kind AS ENUM (
    'image',
    'video'
);


--
-- TOC entry 1572 (class 1247 OID 106428)
-- Name: media_owner; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.media_owner AS ENUM (
    'site',
    'post',
    'place'
);


--
-- TOC entry 1481 (class 1247 OID 106224)
-- Name: member_role; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.member_role AS ENUM (
    'owner',
    'admin',
    'editor',
    'viewer'
);


--
-- TOC entry 1484 (class 1247 OID 106234)
-- Name: place_kind; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.place_kind AS ENUM (
    'lodging',
    'food',
    'attraction',
    'service',
    'medical'
);


--
-- TOC entry 1487 (class 1247 OID 106246)
-- Name: place_status; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.place_status AS ENUM (
    'draft',
    'published',
    'archived'
);


--
-- TOC entry 1601 (class 1247 OID 109923)
-- Name: platform_role; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.platform_role AS ENUM (
    'super_admin',
    'connect_admin',
    'user_admin'
);


--
-- TOC entry 1613 (class 1247 OID 106497)
-- Name: post_kind; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.post_kind AS ENUM (
    'blog',
    'news'
);


--
-- TOC entry 1586 (class 1247 OID 109907)
-- Name: site_status; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.site_status AS ENUM (
    'published',
    'draft',
    'archived'
);


--
-- TOC entry 1430 (class 1247 OID 17155)
-- Name: action; Type: TYPE; Schema: realtime; Owner: -
--

CREATE TYPE realtime.action AS ENUM (
    'INSERT',
    'UPDATE',
    'DELETE',
    'TRUNCATE',
    'ERROR'
);


--
-- TOC entry 1418 (class 1247 OID 17115)
-- Name: equality_op; Type: TYPE; Schema: realtime; Owner: -
--

CREATE TYPE realtime.equality_op AS ENUM (
    'eq',
    'neq',
    'lt',
    'lte',
    'gt',
    'gte',
    'in'
);


--
-- TOC entry 1421 (class 1247 OID 17129)
-- Name: user_defined_filter; Type: TYPE; Schema: realtime; Owner: -
--

CREATE TYPE realtime.user_defined_filter AS (
	column_name text,
	op realtime.equality_op,
	value text
);


--
-- TOC entry 1439 (class 1247 OID 17200)
-- Name: wal_column; Type: TYPE; Schema: realtime; Owner: -
--

CREATE TYPE realtime.wal_column AS (
	name text,
	type_name text,
	type_oid oid,
	value jsonb,
	is_pkey boolean,
	is_selectable boolean
);


--
-- TOC entry 1433 (class 1247 OID 17167)
-- Name: wal_rls; Type: TYPE; Schema: realtime; Owner: -
--

CREATE TYPE realtime.wal_rls AS (
	wal jsonb,
	is_rls_enabled boolean,
	subscription_ids uuid[],
	errors text[]
);


--
-- TOC entry 1469 (class 1247 OID 20260)
-- Name: buckettype; Type: TYPE; Schema: storage; Owner: -
--

CREATE TYPE storage.buckettype AS ENUM (
    'STANDARD',
    'ANALYTICS',
    'VECTOR'
);


--
-- TOC entry 493 (class 1255 OID 16540)
-- Name: email(); Type: FUNCTION; Schema: auth; Owner: -
--

CREATE FUNCTION auth.email() RETURNS text
    LANGUAGE sql STABLE
    AS $$
  select 
  coalesce(
    nullif(current_setting('request.jwt.claim.email', true), ''),
    (nullif(current_setting('request.jwt.claims', true), '')::jsonb ->> 'email')
  )::text
$$;


--
-- TOC entry 5192 (class 0 OID 0)
-- Dependencies: 493
-- Name: FUNCTION email(); Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON FUNCTION auth.email() IS 'Deprecated. Use auth.jwt() -> ''email'' instead.';


--
-- TOC entry 536 (class 1255 OID 16753)
-- Name: jwt(); Type: FUNCTION; Schema: auth; Owner: -
--

CREATE FUNCTION auth.jwt() RETURNS jsonb
    LANGUAGE sql STABLE
    AS $$
  select 
    coalesce(
        nullif(current_setting('request.jwt.claim', true), ''),
        nullif(current_setting('request.jwt.claims', true), '')
    )::jsonb
$$;


--
-- TOC entry 393 (class 1255 OID 16539)
-- Name: role(); Type: FUNCTION; Schema: auth; Owner: -
--

CREATE FUNCTION auth.role() RETURNS text
    LANGUAGE sql STABLE
    AS $$
  select 
  coalesce(
    nullif(current_setting('request.jwt.claim.role', true), ''),
    (nullif(current_setting('request.jwt.claims', true), '')::jsonb ->> 'role')
  )::text
$$;


--
-- TOC entry 5193 (class 0 OID 0)
-- Dependencies: 393
-- Name: FUNCTION role(); Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON FUNCTION auth.role() IS 'Deprecated. Use auth.jwt() -> ''role'' instead.';


--
-- TOC entry 430 (class 1255 OID 16538)
-- Name: uid(); Type: FUNCTION; Schema: auth; Owner: -
--

CREATE FUNCTION auth.uid() RETURNS uuid
    LANGUAGE sql STABLE
    AS $$
  select 
  coalesce(
    nullif(current_setting('request.jwt.claim.sub', true), ''),
    (nullif(current_setting('request.jwt.claims', true), '')::jsonb ->> 'sub')
  )::uuid
$$;


--
-- TOC entry 5194 (class 0 OID 0)
-- Dependencies: 430
-- Name: FUNCTION uid(); Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON FUNCTION auth.uid() IS 'Deprecated. Use auth.jwt() -> ''sub'' instead.';


--
-- TOC entry 570 (class 1255 OID 16597)
-- Name: grant_pg_cron_access(); Type: FUNCTION; Schema: extensions; Owner: -
--

CREATE FUNCTION extensions.grant_pg_cron_access() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF EXISTS (
    SELECT
    FROM pg_event_trigger_ddl_commands() AS ev
    JOIN pg_extension AS ext
    ON ev.objid = ext.oid
    WHERE ext.extname = 'pg_cron'
  )
  THEN
    grant usage on schema cron to postgres with grant option;

    alter default privileges in schema cron grant all on tables to postgres with grant option;
    alter default privileges in schema cron grant all on functions to postgres with grant option;
    alter default privileges in schema cron grant all on sequences to postgres with grant option;

    alter default privileges for user supabase_admin in schema cron grant all
        on sequences to postgres with grant option;
    alter default privileges for user supabase_admin in schema cron grant all
        on tables to postgres with grant option;
    alter default privileges for user supabase_admin in schema cron grant all
        on functions to postgres with grant option;

    grant all privileges on all tables in schema cron to postgres with grant option;
    revoke all on table cron.job from postgres;
    grant select on table cron.job to postgres with grant option;
  END IF;
END;
$$;


--
-- TOC entry 5195 (class 0 OID 0)
-- Dependencies: 570
-- Name: FUNCTION grant_pg_cron_access(); Type: COMMENT; Schema: extensions; Owner: -
--

COMMENT ON FUNCTION extensions.grant_pg_cron_access() IS 'Grants access to pg_cron';


--
-- TOC entry 528 (class 1255 OID 16618)
-- Name: grant_pg_graphql_access(); Type: FUNCTION; Schema: extensions; Owner: -
--

CREATE FUNCTION extensions.grant_pg_graphql_access() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $_$
DECLARE
    func_is_graphql_resolve bool;
BEGIN
    func_is_graphql_resolve = (
        SELECT n.proname = 'resolve'
        FROM pg_event_trigger_ddl_commands() AS ev
        LEFT JOIN pg_catalog.pg_proc AS n
        ON ev.objid = n.oid
    );

    IF func_is_graphql_resolve
    THEN
        -- Update public wrapper to pass all arguments through to the pg_graphql resolve func
        DROP FUNCTION IF EXISTS graphql_public.graphql;
        create or replace function graphql_public.graphql(
            "operationName" text default null,
            query text default null,
            variables jsonb default null,
            extensions jsonb default null
        )
            returns jsonb
            language sql
        as $$
            select graphql.resolve(
                query := query,
                variables := coalesce(variables, '{}'),
                "operationName" := "operationName",
                extensions := extensions
            );
        $$;

        -- This hook executes when `graphql.resolve` is created. That is not necessarily the last
        -- function in the extension so we need to grant permissions on existing entities AND
        -- update default permissions to any others that are created after `graphql.resolve`
        grant usage on schema graphql to postgres, anon, authenticated, service_role;
        grant select on all tables in schema graphql to postgres, anon, authenticated, service_role;
        grant execute on all functions in schema graphql to postgres, anon, authenticated, service_role;
        grant all on all sequences in schema graphql to postgres, anon, authenticated, service_role;
        alter default privileges in schema graphql grant all on tables to postgres, anon, authenticated, service_role;
        alter default privileges in schema graphql grant all on functions to postgres, anon, authenticated, service_role;
        alter default privileges in schema graphql grant all on sequences to postgres, anon, authenticated, service_role;

        -- Allow postgres role to allow granting usage on graphql and graphql_public schemas to custom roles
        grant usage on schema graphql_public to postgres with grant option;
        grant usage on schema graphql to postgres with grant option;
    END IF;

END;
$_$;


--
-- TOC entry 5196 (class 0 OID 0)
-- Dependencies: 528
-- Name: FUNCTION grant_pg_graphql_access(); Type: COMMENT; Schema: extensions; Owner: -
--

COMMENT ON FUNCTION extensions.grant_pg_graphql_access() IS 'Grants access to pg_graphql';


--
-- TOC entry 471 (class 1255 OID 16599)
-- Name: grant_pg_net_access(); Type: FUNCTION; Schema: extensions; Owner: -
--

CREATE FUNCTION extensions.grant_pg_net_access() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF EXISTS (
    SELECT 1
    FROM pg_event_trigger_ddl_commands() AS ev
    JOIN pg_extension AS ext
    ON ev.objid = ext.oid
    WHERE ext.extname = 'pg_net'
  )
  THEN
    IF NOT EXISTS (
      SELECT 1
      FROM pg_roles
      WHERE rolname = 'supabase_functions_admin'
    )
    THEN
      CREATE USER supabase_functions_admin NOINHERIT CREATEROLE LOGIN NOREPLICATION;
    END IF;

    GRANT USAGE ON SCHEMA net TO supabase_functions_admin, postgres, anon, authenticated, service_role;

    IF EXISTS (
      SELECT FROM pg_extension
      WHERE extname = 'pg_net'
      -- all versions in use on existing projects as of 2025-02-20
      -- version 0.12.0 onwards don't need these applied
      AND extversion IN ('0.2', '0.6', '0.7', '0.7.1', '0.8', '0.10.0', '0.11.0')
    ) THEN
      ALTER function net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) SECURITY DEFINER;
      ALTER function net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) SECURITY DEFINER;

      ALTER function net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) SET search_path = net;
      ALTER function net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) SET search_path = net;

      REVOKE ALL ON FUNCTION net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) FROM PUBLIC;
      REVOKE ALL ON FUNCTION net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) FROM PUBLIC;

      GRANT EXECUTE ON FUNCTION net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) TO supabase_functions_admin, postgres, anon, authenticated, service_role;
      GRANT EXECUTE ON FUNCTION net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) TO supabase_functions_admin, postgres, anon, authenticated, service_role;
    END IF;
  END IF;
END;
$$;


--
-- TOC entry 5197 (class 0 OID 0)
-- Dependencies: 471
-- Name: FUNCTION grant_pg_net_access(); Type: COMMENT; Schema: extensions; Owner: -
--

COMMENT ON FUNCTION extensions.grant_pg_net_access() IS 'Grants access to pg_net';


--
-- TOC entry 374 (class 1255 OID 16609)
-- Name: pgrst_ddl_watch(); Type: FUNCTION; Schema: extensions; Owner: -
--

CREATE FUNCTION extensions.pgrst_ddl_watch() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  cmd record;
BEGIN
  FOR cmd IN SELECT * FROM pg_event_trigger_ddl_commands()
  LOOP
    IF cmd.command_tag IN (
      'CREATE SCHEMA', 'ALTER SCHEMA'
    , 'CREATE TABLE', 'CREATE TABLE AS', 'SELECT INTO', 'ALTER TABLE'
    , 'CREATE FOREIGN TABLE', 'ALTER FOREIGN TABLE'
    , 'CREATE VIEW', 'ALTER VIEW'
    , 'CREATE MATERIALIZED VIEW', 'ALTER MATERIALIZED VIEW'
    , 'CREATE FUNCTION', 'ALTER FUNCTION'
    , 'CREATE TRIGGER'
    , 'CREATE TYPE', 'ALTER TYPE'
    , 'CREATE RULE'
    , 'COMMENT'
    )
    -- don't notify in case of CREATE TEMP table or other objects created on pg_temp
    AND cmd.schema_name is distinct from 'pg_temp'
    THEN
      NOTIFY pgrst, 'reload schema';
    END IF;
  END LOOP;
END; $$;


--
-- TOC entry 605 (class 1255 OID 16610)
-- Name: pgrst_drop_watch(); Type: FUNCTION; Schema: extensions; Owner: -
--

CREATE FUNCTION extensions.pgrst_drop_watch() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  obj record;
BEGIN
  FOR obj IN SELECT * FROM pg_event_trigger_dropped_objects()
  LOOP
    IF obj.object_type IN (
      'schema'
    , 'table'
    , 'foreign table'
    , 'view'
    , 'materialized view'
    , 'function'
    , 'trigger'
    , 'type'
    , 'rule'
    )
    AND obj.is_temporary IS false -- no pg_temp objects
    THEN
      NOTIFY pgrst, 'reload schema';
    END IF;
  END LOOP;
END; $$;


--
-- TOC entry 405 (class 1255 OID 16620)
-- Name: set_graphql_placeholder(); Type: FUNCTION; Schema: extensions; Owner: -
--

CREATE FUNCTION extensions.set_graphql_placeholder() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $_$
    DECLARE
    graphql_is_dropped bool;
    BEGIN
    graphql_is_dropped = (
        SELECT ev.schema_name = 'graphql_public'
        FROM pg_event_trigger_dropped_objects() AS ev
        WHERE ev.schema_name = 'graphql_public'
    );

    IF graphql_is_dropped
    THEN
        create or replace function graphql_public.graphql(
            "operationName" text default null,
            query text default null,
            variables jsonb default null,
            extensions jsonb default null
        )
            returns jsonb
            language plpgsql
        as $$
            DECLARE
                server_version float;
            BEGIN
                server_version = (SELECT (SPLIT_PART((select version()), ' ', 2))::float);

                IF server_version >= 14 THEN
                    RETURN jsonb_build_object(
                        'errors', jsonb_build_array(
                            jsonb_build_object(
                                'message', 'pg_graphql extension is not enabled.'
                            )
                        )
                    );
                ELSE
                    RETURN jsonb_build_object(
                        'errors', jsonb_build_array(
                            jsonb_build_object(
                                'message', 'pg_graphql is only available on projects running Postgres 14 onwards.'
                            )
                        )
                    );
                END IF;
            END;
        $$;
    END IF;

    END;
$_$;


--
-- TOC entry 5198 (class 0 OID 0)
-- Dependencies: 405
-- Name: FUNCTION set_graphql_placeholder(); Type: COMMENT; Schema: extensions; Owner: -
--

COMMENT ON FUNCTION extensions.set_graphql_placeholder() IS 'Reintroduces placeholder function for graphql_public.graphql';


--
-- TOC entry 496 (class 1255 OID 16387)
-- Name: get_auth(text); Type: FUNCTION; Schema: pgbouncer; Owner: -
--

CREATE FUNCTION pgbouncer.get_auth(p_usename text) RETURNS TABLE(username text, password text)
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO ''
    AS $_$
  BEGIN
      RAISE DEBUG 'PgBouncer auth request: %', p_usename;

      RETURN QUERY
      SELECT
          rolname::text,
          CASE WHEN rolvaliduntil < now()
              THEN null
              ELSE rolpassword::text
          END
      FROM pg_authid
      WHERE rolname=$1 and rolcanlogin;
  END;
  $_$;


--
-- TOC entry 622 (class 1255 OID 111268)
-- Name: accept_invitation(text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.accept_invitation(_token text) RETURNS jsonb
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
declare
  v_token_hash text;
  v_inv_id uuid;
  v_inv_email text;
  v_inv_role public.member_role;
  v_inv_status public.invitation_status;
  v_inv_expires_at timestamp with time zone;
  v_inv_created_at timestamp with time zone;
  v_email text;
  v_user_id uuid;
  v_sites_count int := 0;
begin
  v_user_id := auth.uid();
  if v_user_id is null then
    raise exception 'not_authenticated';
  end if;

  v_email := public.current_user_email();
  if v_email = '' then
    raise exception 'email_missing';
  end if;

  -- Hash token with SHA-256 hex (must match stored token_hash)
  v_token_hash := encode(digest(_token, 'sha256'), 'hex');

  -- Use explicit column selection instead of SELECT *
  select ui.id, ui.email, ui.role, ui.status, ui.expires_at, ui.created_at
    into v_inv_id, v_inv_email, v_inv_role, v_inv_status, v_inv_expires_at, v_inv_created_at
  from public.user_invitations ui
  where ui.token_hash = v_token_hash
    and ui.status = 'pending'
    and ui.revoked_at is null
    and (ui.expires_at is null or ui.expires_at > now())
  limit 1;

  if v_inv_id is null then
    raise exception 'invitation_not_found_or_invalid';
  end if;

  if lower(v_inv_email) <> lower(v_email) then
    raise exception 'email_mismatch';
  end if;

  -- Insert memberships for all sites linked to this invitation
  insert into public.site_members (site_id, user_id, role)
  select uis.site_id, v_user_id, v_inv_role::public.member_role
  from public.user_invitation_sites uis
  where uis.invitation_id = v_inv_id
  on conflict (site_id, user_id) do update
    set role = excluded.role;

  get diagnostics v_sites_count = row_count;

  -- Mark invitation accepted
  update public.user_invitations
    set status = 'accepted',
        accepted_at = now(),
        updated_at = now()
  where id = v_inv_id;

  return jsonb_build_object(
    'ok', true,
    'invitation_id', v_inv_id,
    'sites_granted', v_sites_count,
    'role', v_inv_role
  );
end;
$$;


--
-- TOC entry 481 (class 1255 OID 111189)
-- Name: ads_get_for_placement(uuid, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.ads_get_for_placement(_site_id uuid, _slot_key text) RETURNS TABLE(campaign_id uuid, advertiser_name text, creative_id uuid, title text, cta_text text, target_url text, media_url text)
    LANGUAGE plpgsql STABLE SECURITY DEFINER
    SET search_path TO 'public'
    SET row_security TO 'on'
    AS $$
DECLARE
    v_is_member boolean;
BEGIN
    -- Verify caller is a member of the site
    SELECT EXISTS (
        SELECT 1 FROM public.site_members sm
        WHERE sm.site_id = _site_id
        AND sm.user_id = auth.uid()
    ) INTO v_is_member;

    -- If not a member and not a platform admin, raise exception
    IF NOT v_is_member AND NOT public.is_super_admin() AND NOT public.is_connect_admin() THEN
        RAISE EXCEPTION 'access_denied' USING HINT = 'You must be a member of this site to view ads';
    END IF;

    RETURN QUERY
    SELECT 
        c.id as campaign_id,
        adv.name as advertiser_name,
        cr.id as creative_id,
        cr.title,
        cr.cta_text,
        cr.target_url,
        m.public_url as media_url
    FROM public.ads_campaigns c
    JOIN public.ads_advertisers adv ON c.advertiser_id = adv.id
    JOIN public.ads_slots s ON c.slot_id = s.id
    JOIN public.ads_creatives cr ON cr.campaign_id = c.id
    LEFT JOIN public.media m ON cr.media_id = m.id
    WHERE c.site_id = _site_id
      AND s.key = _slot_key
      AND s.is_active = true
      AND c.status = 'active'
      AND cr.is_active = true
      AND now() >= c.starts_at
      AND now() <= c.ends_at
    ORDER BY c.starts_at DESC
    LIMIT 1;
END;
$$;


--
-- TOC entry 502 (class 1255 OID 115948)
-- Name: approve_place(uuid, uuid, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.approve_place(p_place_id uuid, p_curator_id uuid, p_notes text DEFAULT NULL::text) RETURNS jsonb
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
DECLARE
  v_validation jsonb;
  v_place record;
BEGIN
  v_validation := validate_place_quality(p_place_id);
  
  IF NOT (v_validation->>'valid')::boolean THEN
    RETURN jsonb_build_object(
      'success', false,
      'error', 'Place does not meet quality standards',
      'validation', v_validation
    );
  END IF;

  UPDATE places SET
    curation_status = 'approved',
    curated_by = p_curator_id,
    curated_at = now(),
    status = 'published',
    data_verified_at = now(),
    updated_at = now()
  WHERE id = p_place_id
  RETURNING * INTO v_place;

  IF v_place.import_batch_id IS NOT NULL THEN
    UPDATE import_batches
    SET items_approved = items_approved + 1
    WHERE id = v_place.import_batch_id;
  END IF;

  RETURN jsonb_build_object(
    'success', true,
    'place_id', p_place_id,
    'published_at', now()
  );
END;
$$;


--
-- TOC entry 650 (class 1255 OID 111336)
-- Name: calculate_network_metrics(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.calculate_network_metrics() RETURNS TABLE(total_sites integer, total_published_sites integer, avg_growth_rate numeric, avg_uptime numeric, network_health_status text)
    LANGUAGE sql STABLE SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
    SELECT 
        COUNT(*)::integer as total_sites,
        COUNT(*) FILTER (WHERE s.status = 'published')::integer as total_published_sites,
        COALESCE(AVG(sm.growth_rate_percent), 0)::decimal(5,2) as avg_growth_rate,
        COALESCE(AVG(sm.uptime_percent), 99.90)::decimal(5,2) as avg_uptime,
        CASE 
            WHEN AVG(sm.uptime_percent) >= 99.9 THEN 'excellent'
            WHEN AVG(sm.uptime_percent) >= 99.0 THEN 'good'
            WHEN AVG(sm.uptime_percent) >= 95.0 THEN 'warning'
            ELSE 'critical'
        END as network_health_status
    FROM public.sites s
    LEFT JOIN public.site_metrics sm ON sm.site_id = s.id
    WHERE s.is_active = true;
$$;


--
-- TOC entry 556 (class 1255 OID 111127)
-- Name: can_accept_invitation(uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.can_accept_invitation(_invitation_id uuid) RETURNS boolean
    LANGUAGE plpgsql STABLE
    AS $$
DECLARE
    v_email text;
    v_status text;
    v_expires_at timestamptz;
BEGIN
    SELECT email, status, expires_at INTO v_email, v_status, v_expires_at
    FROM public.user_invitations
    WHERE id = _invitation_id;

    -- Invitation must exist
    IF v_email IS NULL THEN
        RETURN FALSE;
    END IF;

    -- Must be pending
    IF v_status != 'pending' THEN
        RETURN FALSE;
    END IF;

    -- Must not be expired
    IF v_expires_at < now() THEN
        RETURN FALSE;
    END IF;

    -- Must match current user's email
    RETURN v_email = (SELECT email FROM auth.users WHERE id = auth.uid());
END;
$$;


--
-- TOC entry 441 (class 1255 OID 106382)
-- Name: can_write_site_slug(text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.can_write_site_slug(_slug text) RETURNS boolean
    LANGUAGE sql STABLE
    AS $$
  select exists (
    select 1
    from public.sites s
    join public.site_members sm on sm.site_id = s.id
    where s.slug = _slug
      and sm.user_id = auth.uid()
      and sm.role in ('owner','admin','editor')
  );
$$;


--
-- TOC entry 653 (class 1255 OID 111238)
-- Name: current_user_email(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.current_user_email() RETURNS text
    LANGUAGE sql STABLE SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
  SELECT COALESCE(
    (auth.jwt() ->> 'email'),
    (auth.jwt() ->> 'raw_app_meta_data')::jsonb ->> 'email',
    ''
  );
$$;


--
-- TOC entry 647 (class 1255 OID 115897)
-- Name: get_ads_by_slot(text, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.get_ads_by_slot(p_site_slug text, p_slot_key text) RETURNS jsonb
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
declare
  v_site_id uuid;
  v_slot_id uuid;
  v_campaign_id uuid;
  v_advertiser_name text;
  v_creative_id uuid;
  v_title text;
  v_cta_text text;
  v_target_url text;
  v_media_url text;
begin
  if p_slot_key is null then
    return jsonb_build_object('status', 'error', 'error', 'Parametro slot_key obrigatorio');
  end if;
  
  select id into v_site_id from sites where slug = p_site_slug and is_active = true;
  
  if v_site_id is null then
    return jsonb_build_object('status', 'error', 'error', 'Site nao encontrado');
  end if;
  
  -- Buscar slot
  select id into v_slot_id
  from ads_slots
  where site_id = v_site_id and key = p_slot_key and is_active = true;
  
  if v_slot_id is null then
    return jsonb_build_object('status', 'ok', 'data', '[]'::jsonb, 'error', null);
  end if;
  
  -- Buscar campanha ativa
  select c.id, adv.name
  into v_campaign_id, v_advertiser_name
  from ads_campaigns c
  join ads_advertisers adv on adv.id = c.advertiser_id
  where c.site_id = v_site_id
    and c.slot_id = v_slot_id
    and c.status = 'active'
    and now() >= c.starts_at
    and now() <= c.ends_at
  order by c.starts_at desc
  limit 1;
  
  if v_campaign_id is null then
    return jsonb_build_object('status', 'ok', 'data', '[]'::jsonb, 'error', null);
  end if;
  
  -- Buscar criativo ativo
  select cr.id, cr.title, cr.cta_text, cr.target_url, m.public_url
  into v_creative_id, v_title, v_cta_text, v_target_url, v_media_url
  from ads_creatives cr
  left join media m on m.id = cr.media_id
  where cr.campaign_id = v_campaign_id
    and cr.is_active = true
  order by cr.created_at desc
  limit 1;
  
  if v_creative_id is null then
    return jsonb_build_object('status', 'ok', 'data', '[]'::jsonb, 'error', null);
  end if;
  
  return jsonb_build_object(
    'status', 'ok',
    'data', jsonb_build_array(jsonb_build_object(
      'campaign_id', v_campaign_id,
      'advertiser_name', v_advertiser_name,
      'creative_id', v_creative_id,
      'title', v_title,
      'cta_text', v_cta_text,
      'target_url', v_target_url,
      'media_url', v_media_url,
      'slot_key', p_slot_key
    )),
    'error', null
  );
exception when others then
  return jsonb_build_object('status', 'error', 'error', SQLERRM);
end;
$$;


--
-- TOC entry 656 (class 1255 OID 115890)
-- Name: get_hero_banners_by_site(text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.get_hero_banners_by_site(p_site_slug text) RETURNS jsonb
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
declare
  v_site_id uuid;
  v_result jsonb;
begin
  -- Buscar site_id pelo slug
  select id into v_site_id
  from sites
  where slug = p_site_slug
    and is_active = true;
  
  if v_site_id is null then
    return jsonb_build_object('status', 'error', 'error', 'Site nao encontrado');
  end if;
  
  -- Buscar banners (executa como owner da função, ignora RLS)
  select jsonb_build_object(
    'status', 'ok',
    'data', coalesce(jsonb_agg(
      jsonb_build_object(
        'id', hb.id,
        'title_i18n', hb.title_i18n,
        'subtitle_i18n', hb.subtitle_i18n,
        'cta_label_i18n', hb.cta_label_i18n,
        'cta_url', hb.cta_url,
        'target_view', hb.target_view,
        'kind', hb.kind,
        'sort_order', hb.sort_order,
        'starts_at', hb.starts_at,
        'ends_at', hb.ends_at,
        'is_active', hb.is_active,
        'primary_media_id', hb.primary_media_id,
        'media', jsonb_build_object(
          'public_url', m.public_url,
          'storage_path', m.storage_path,
          'alt_i18n', m.alt_i18n
        )
      ) order by hb.sort_order
    ), '[]'::jsonb),
    'error', null
  ) into v_result
  from hero_banners hb
  left join media m on m.id = hb.primary_media_id
  where hb.site_id = v_site_id
    and hb.is_active = true
    and (hb.starts_at is null or hb.starts_at <= now())
    and (hb.ends_at is null or hb.ends_at >= now())
  limit 5;
  
  return v_result;
exception when others then
  return jsonb_build_object('status', 'error', 'error', SQLERRM);
end;
$$;


--
-- TOC entry 515 (class 1255 OID 115891)
-- Name: get_home_slots_by_site(text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.get_home_slots_by_site(p_site_slug text) RETURNS jsonb
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
declare
  v_site_id uuid;
begin
  select id into v_site_id from sites where slug = p_site_slug and is_active = true;
  
  if v_site_id is null then
    return jsonb_build_object('status', 'error', 'error', 'Site nao encontrado');
  end if;
  
  return jsonb_build_object(
    'status', 'ok',
    'data', coalesce((
      select jsonb_agg(row_to_json(sc) order by sc.slot)
      from site_content sc
      where sc.site_id = v_site_id and sc.is_active = true
    ), '[]'::jsonb),
    'error', null
  );
exception when others then
  return jsonb_build_object('status', 'error', 'error', SQLERRM);
end;
$$;


--
-- TOC entry 420 (class 1255 OID 115892)
-- Name: get_latest_posts_by_site(text, text, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.get_latest_posts_by_site(p_site_slug text, p_kind text DEFAULT 'news'::text, p_limit integer DEFAULT 6) RETURNS jsonb
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
declare
  v_site_id uuid;
begin
  select id into v_site_id from sites where slug = p_site_slug and is_active = true;
  
  if v_site_id is null then
    return jsonb_build_object('status', 'error', 'error', 'Site nao encontrado');
  end if;
  
  return jsonb_build_object(
    'status', 'ok',
    'data', coalesce((
      select jsonb_agg(row_to_json(p))
      from (
        select * from posts
        where site_id = v_site_id 
          and status = 'published' 
          and kind = p_kind::post_kind  -- CAST para enum
        order by published_at desc nulls last, updated_at desc
        limit p_limit
      ) p
    ), '[]'::jsonb),
    'error', null
  );
exception when others then
  return jsonb_build_object('status', 'error', 'error', SQLERRM);
end;
$$;


--
-- TOC entry 696 (class 1255 OID 115950)
-- Name: get_pending_curation(text, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.get_pending_curation(p_kind text DEFAULT NULL::text, p_limit integer DEFAULT 20) RETURNS jsonb
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
DECLARE
  v_result jsonb;
BEGIN
  SELECT jsonb_agg(
    jsonb_build_object(
      'id', p.id,
      'name', p.name,
      'kind', p.kind,
      'curation_status', p.curation_status,
      'created_at', p.created_at,
      'image_count', (SELECT COUNT(*) FROM place_images WHERE place_id = p.id),
      'validation', validate_place_quality(p.id)
    )
  ) INTO v_result
  FROM places p
  WHERE p.curation_status = 'pending'
    AND (p_kind IS NULL OR p.kind = p_kind)
  ORDER BY p.created_at DESC
  LIMIT p_limit;

  RETURN jsonb_build_object(
    'success', true,
    'data', COALESCE(v_result, '[]'::jsonb),
    'total_pending', (SELECT COUNT(*) FROM places WHERE curation_status = 'pending')
  );
END;
$$;


--
-- TOC entry 671 (class 1255 OID 115895)
-- Name: get_place_by_slug(text, text, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.get_place_by_slug(p_site_slug text, p_slug text, p_kind text DEFAULT NULL::text) RETURNS jsonb
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
declare
  v_site_id uuid;
  v_result jsonb;
begin
  select id into v_site_id from sites where slug = p_site_slug and is_active = true;
  
  if v_site_id is null then
    return jsonb_build_object('status', 'error', 'error', 'Site nao encontrado');
  end if;
  
  select row_to_json(pl) into v_result
  from places pl
  where pl.site_id = v_site_id 
    and pl.slug = p_slug
    and (p_kind is null or pl.kind = p_kind::place_kind)  -- CAST para enum
  limit 1;
  
  return jsonb_build_object(
    'status', case when v_result is not null then 'ok' else 'ok' end,
    'data', case when v_result is not null then jsonb_build_array(v_result) else '[]'::jsonb end,
    'error', null
  );
exception when others then
  return jsonb_build_object('status', 'error', 'error', SQLERRM);
end;
$$;


--
-- TOC entry 661 (class 1255 OID 116023)
-- Name: get_places_by_kind_and_site(text, text, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.get_places_by_kind_and_site(p_site_slug text DEFAULT 'urubici'::text, p_kind text DEFAULT 'attraction'::text, p_limit integer DEFAULT 8) RETURNS TABLE(id uuid, name text, name_i18n jsonb, slug text, kind text, status text, curation_status text, description text, description_i18n jsonb, short_description text, short_i18n jsonb, images jsonb, meta jsonb, created_at timestamp with time zone, updated_at timestamp with time zone, address_line text, city text, state text, country text, lat numeric, lng numeric, phone text, website text)
    LANGUAGE plpgsql
    AS $$
BEGIN
  RETURN QUERY
  SELECT 
    p.id,
    p.name_i18n->>'pt' as name,
    p.name_i18n,
    p.slug,
    p.kind::text,  -- Cast enum para text no retorno
    p.status::text,  -- Cast enum para text no retorno
    p.curation_status,
    COALESCE(p.description_i18n->>'pt', p.short_i18n->>'pt', '') as description,
    p.description_i18n,
    COALESCE(p.short_i18n->>'pt', '') as short_description,
    p.short_i18n,
    (
      SELECT jsonb_agg(
        jsonb_build_object(
          'url', pi.url,
          'caption', pi.caption,
          'sort_order', pi.sort_order,
          'is_primary', pi.is_primary
        )
        ORDER BY pi.sort_order
      )
      FROM place_images pi
      WHERE pi.place_id = p.id
    ) as images,
    p.meta,
    p.created_at,
    p.updated_at,
    p.address_line,
    p.city,
    p.state,
    p.country,
    p.lat,
    p.lng,
    p.phone,
    p.website
  FROM places p
  WHERE 
    p.kind::text = p_kind  -- ✅ CORREÇÃO: Cast explícito do enum para text
    AND p.status::text = 'published'  -- ✅ Cast do enum status também
    AND p.curation_status = 'approved'
  ORDER BY 
    p.sort_order NULLS LAST,
    p.created_at DESC
  LIMIT p_limit;
END;
$$;


--
-- TOC entry 500 (class 1255 OID 115896)
-- Name: get_post_by_slug(text, text, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.get_post_by_slug(p_site_slug text, p_slug text, p_kind text DEFAULT NULL::text) RETURNS jsonb
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
declare
  v_site_id uuid;
  v_result jsonb;
begin
  select id into v_site_id from sites where slug = p_site_slug and is_active = true;
  
  if v_site_id is null then
    return jsonb_build_object('status', 'error', 'error', 'Site nao encontrado');
  end if;
  
  select row_to_json(pt) into v_result
  from posts pt
  where pt.site_id = v_site_id 
    and pt.slug = p_slug
    and (p_kind is null or pt.kind = p_kind::post_kind)  -- CAST para enum
  limit 1;
  
  return jsonb_build_object(
    'status', case when v_result is not null then 'ok' else 'ok' end,
    'data', case when v_result is not null then jsonb_build_array(v_result) else '[]'::jsonb end,
    'error', null
  );
exception when others then
  return jsonb_build_object('status', 'error', 'error', SQLERRM);
end;
$$;


--
-- TOC entry 415 (class 1255 OID 115894)
-- Name: get_upcoming_events_by_site(text, integer, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.get_upcoming_events_by_site(p_site_slug text, p_limit integer DEFAULT 8, p_from_days integer DEFAULT 7) RETURNS jsonb
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
declare
  v_site_id uuid;
  v_from_iso timestamptz;
begin
  select id into v_site_id from sites where slug = p_site_slug and is_active = true;
  
  if v_site_id is null then
    return jsonb_build_object('status', 'error', 'error', 'Site nao encontrado');
  end if;
  
  v_from_iso := now() - (p_from_days || ' days')::interval;
  
  return jsonb_build_object(
    'status', 'ok',
    'data', coalesce((
      select jsonb_agg(row_to_json(e))
      from (
        select * from events
        where site_id = v_site_id 
          and status = 'published'::event_status  -- Garantir cast
          and start_at >= v_from_iso
        order by start_at asc
        limit p_limit
      ) e
    ), '[]'::jsonb),
    'error', null
  );
exception when others then
  return jsonb_build_object('status', 'error', 'error', SQLERRM);
end;
$$;


--
-- TOC entry 530 (class 1255 OID 106253)
-- Name: i18n_has_pt(jsonb); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.i18n_has_pt(j jsonb) RETURNS boolean
    LANGUAGE sql IMMUTABLE
    AS $$ select (j ? 'pt') and (nullif(trim(j->>'pt'), '') is not null); $$;


--
-- TOC entry 554 (class 1255 OID 109941)
-- Name: is_connect_admin(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.is_connect_admin() RETURNS boolean
    LANGUAGE sql STABLE SECURITY DEFINER
    SET search_path TO 'public'
    SET row_security TO 'off'
    AS $$
    SELECT EXISTS (
        SELECT 1 FROM public.platform_roles
        WHERE user_id = auth.uid() AND role IN ('super_admin', 'connect_admin')
    );
$$;


--
-- TOC entry 443 (class 1255 OID 111106)
-- Name: is_platform_admin(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.is_platform_admin() RETURNS boolean
    LANGUAGE sql STABLE SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
  select exists (
    select 1
    from public.platform_roles pr
    where pr.user_id = auth.uid()
      and pr.role in ('super_admin', 'connect_admin')
  );
$$;


--
-- TOC entry 5199 (class 0 OID 0)
-- Dependencies: 443
-- Name: FUNCTION is_platform_admin(); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION public.is_platform_admin() IS 'DEPRECATED: Use is_connect_admin() instead. This function will be removed in a future version.';


--
-- TOC entry 677 (class 1255 OID 106495)
-- Name: is_site_member(uuid, public.member_role[]); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.is_site_member(_site_id uuid, _roles public.member_role[]) RETURNS boolean
    LANGUAGE sql STABLE SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
  select public.is_site_member_no_rls(_site_id, _roles);
$$;


--
-- TOC entry 501 (class 1255 OID 111269)
-- Name: is_site_member_no_rls(uuid, public.member_role[]); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.is_site_member_no_rls(_site_id uuid, _roles public.member_role[]) RETURNS boolean
    LANGUAGE sql STABLE SECURITY DEFINER
    SET search_path TO 'public'
    SET row_security TO 'off'
    AS $$
  -- Additional validation: ensure caller is authenticated
  -- This prevents anonymous users from exploiting this function
  select 
    case 
      when auth.uid() is null then false
      else exists (
        select 1
        from public.site_members sm
        where sm.site_id = _site_id
          and sm.user_id = auth.uid()
          and sm.role = any(_roles)
      )
    end;
$$;


--
-- TOC entry 442 (class 1255 OID 109940)
-- Name: is_super_admin(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.is_super_admin() RETURNS boolean
    LANGUAGE sql STABLE SECURITY DEFINER
    SET search_path TO 'public'
    SET row_security TO 'off'
    AS $$
    SELECT EXISTS (
        SELECT 1 FROM public.platform_roles
        WHERE user_id = auth.uid() AND role = 'super_admin'
    );
$$;


--
-- TOC entry 412 (class 1255 OID 111303)
-- Name: is_user_platform_admin(uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.is_user_platform_admin(_user_id uuid) RETURNS boolean
    LANGUAGE sql STABLE SECURITY DEFINER
    SET search_path TO 'public'
    SET row_security TO 'off'
    AS $$
    SELECT EXISTS (
        SELECT 1 FROM public.platform_roles
        WHERE user_id = _user_id 
        AND role IN ('super_admin', 'connect_admin')
    );
$$;


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 360 (class 1259 OID 111306)
-- Name: site_metrics; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.site_metrics (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    site_id uuid NOT NULL,
    total_posts integer DEFAULT 0,
    total_events integer DEFAULT 0,
    total_places integer DEFAULT 0,
    total_media integer DEFAULT 0,
    growth_rate_percent numeric(5,2) DEFAULT 0.00,
    uptime_percent numeric(5,2) DEFAULT 99.90,
    last_sync_at timestamp with time zone DEFAULT now(),
    total_visits integer DEFAULT 0,
    total_unique_visitors integer DEFAULT 0,
    calculated_at timestamp with time zone DEFAULT now() NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- TOC entry 580 (class 1255 OID 111337)
-- Name: refresh_site_metrics(uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.refresh_site_metrics(p_site_id uuid) RETURNS public.site_metrics
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
DECLARE
    v_metrics public.site_metrics;
    v_total_posts integer;
    v_total_events integer;
    v_total_places integer;
    v_total_media integer;
    v_prev_month_posts integer;
    v_current_month_posts integer;
    v_growth_rate decimal(5,2);
BEGIN
    -- Contar conteúdo atual
    SELECT COUNT(*) INTO v_total_posts FROM public.posts WHERE site_id = p_site_id;
    SELECT COUNT(*) INTO v_total_events FROM public.events WHERE site_id = p_site_id;
    SELECT COUNT(*) INTO v_total_places FROM public.places WHERE site_id = p_site_id;
    SELECT COUNT(*) INTO v_total_media FROM public.media WHERE site_id = p_site_id;
    
    -- Calcular taxa de crescimento (comparando com mês anterior)
    SELECT COUNT(*) INTO v_current_month_posts 
    FROM public.posts 
    WHERE site_id = p_site_id 
    AND created_at >= date_trunc('month', now());
    
    SELECT COUNT(*) INTO v_prev_month_posts 
    FROM public.posts 
    WHERE site_id = p_site_id 
    AND created_at >= date_trunc('month', now() - interval '1 month')
    AND created_at < date_trunc('month', now());
    
    IF v_prev_month_posts > 0 THEN
        v_growth_rate := ((v_current_month_posts - v_prev_month_posts)::decimal / v_prev_month_posts * 100);
    ELSE
        v_growth_rate := CASE WHEN v_current_month_posts > 0 THEN 100.00 ELSE 0.00 END;
    END IF;
    
    -- Inserir ou atualizar métricas
    INSERT INTO public.site_metrics (
        site_id, 
        total_posts, 
        total_events, 
        total_places, 
        total_media,
        growth_rate_percent,
        calculated_at
    ) VALUES (
        p_site_id,
        v_total_posts,
        v_total_events,
        v_total_places,
        v_total_media,
        v_growth_rate,
        now()
    )
    ON CONFLICT (site_id) 
    DO UPDATE SET
        total_posts = EXCLUDED.total_posts,
        total_events = EXCLUDED.total_events,
        total_places = EXCLUDED.total_places,
        total_media = EXCLUDED.total_media,
        growth_rate_percent = EXCLUDED.growth_rate_percent,
        calculated_at = now()
    RETURNING * INTO v_metrics;
    
    RETURN v_metrics;
END;
$$;


--
-- TOC entry 586 (class 1255 OID 115949)
-- Name: reject_place(uuid, uuid, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.reject_place(p_place_id uuid, p_curator_id uuid, p_reason text) RETURNS jsonb
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
DECLARE
  v_place record;
BEGIN
  UPDATE places SET
    curation_status = 'rejected',
    curated_by = p_curator_id,
    curated_at = now(),
    status = 'draft',
    updated_at = now()
  WHERE id = p_place_id
  RETURNING * INTO v_place;

  IF v_place.import_batch_id IS NOT NULL THEN
    UPDATE import_batches
    SET items_rejected = items_rejected + 1
    WHERE id = v_place.import_batch_id;
  END IF;

  RETURN jsonb_build_object(
    'success', true,
    'place_id', p_place_id,
    'reason', p_reason
  );
END;
$$;


--
-- TOC entry 627 (class 1255 OID 115889)
-- Name: test_hero_access(uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.test_hero_access(p_site_id uuid) RETURNS jsonb
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
declare
  v_count int;
  v_error text;
begin
  -- Testar como anon
  set local role anon;
  
  select count(*) into v_count
  from hero_banners
  where site_id = p_site_id 
    and is_active = true
    and (starts_at is null or starts_at <= now())
    and (ends_at is null or ends_at >= now());
  
  return jsonb_build_object(
    'success', true,
    'count', v_count,
    'site_id', p_site_id
  );
exception when others then
  return jsonb_build_object(
    'success', false,
    'error', SQLERRM
  );
end;
$$;


--
-- TOC entry 487 (class 1255 OID 106374)
-- Name: touch_updated_at(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.touch_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW;
END;
$$;


--
-- TOC entry 545 (class 1255 OID 111333)
-- Name: update_site_metrics_updated_at(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.update_site_metrics_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW;
END;
$$;


--
-- TOC entry 479 (class 1255 OID 115947)
-- Name: validate_place_quality(uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.validate_place_quality(p_place_id uuid) RETURNS jsonb
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
DECLARE
  v_place record;
  v_image_count int;
  v_primary_image_exists boolean;
  v_quality_score numeric;
  v_errors text[] := '{}';
  v_checks_passed int := 0;
  v_total_checks int := 6;
BEGIN
  SELECT * INTO v_place FROM places WHERE id = p_place_id;
  
  IF v_place IS NULL THEN
    RETURN jsonb_build_object(
      'valid', false,
      'errors', ARRAY['Place not found'],
      'score', 0
    );
  END IF;

  IF v_place.name IS NOT NULL AND length(trim(v_place.name)) >= 3 THEN
    v_checks_passed := v_checks_passed + 1;
  ELSE
    v_errors := array_append(v_errors, 'Nome muito curto ou não preenchido');
  END IF;

  IF v_place.description IS NOT NULL AND length(v_place.description) >= 200 THEN
    v_checks_passed := v_checks_passed + 1;
  ELSE
    v_errors := array_append(v_errors, 'Descrição deve ter no mínimo 200 caracteres');
  END IF;

  IF v_place.lat IS NOT NULL AND v_place.lng IS NOT NULL 
     AND v_place.lat BETWEEN -34 AND -22
     AND v_place.lng BETWEEN -74 AND -34 THEN
    v_checks_passed := v_checks_passed + 1;
  ELSE
    v_errors := array_append(v_errors, 'Coordenadas GPS inválidas ou não preenchidas');
  END IF;

  IF v_place.phone IS NOT NULL OR v_place.website IS NOT NULL THEN
    v_checks_passed := v_checks_passed + 1;
  ELSE
    v_errors := array_append(v_errors, 'Telefone ou website não preenchido');
  END IF;

  SELECT COUNT(*) INTO v_image_count 
  FROM place_images 
  WHERE place_id = p_place_id;
  
  IF v_image_count >= 3 THEN
    v_checks_passed := v_checks_passed + 1;
  ELSE
    v_errors := array_append(v_errors, 'Mínimo de 3 imagens necessárias');
  END IF;

  SELECT EXISTS(
    SELECT 1 FROM place_images 
    WHERE place_id = p_place_id AND is_primary = true
  ) INTO v_primary_image_exists;
  
  IF v_primary_image_exists THEN
    v_checks_passed := v_checks_passed + 1;
  ELSE
    v_errors := array_append(v_errors, 'Imagem principal não definida');
  END IF;

  v_quality_score := (v_checks_passed::numeric / v_total_checks::numeric) * 10;

  RETURN jsonb_build_object(
    'valid', v_checks_passed = v_total_checks,
    'checks_passed', v_checks_passed,
    'total_checks', v_total_checks,
    'score', round(v_quality_score, 1),
    'errors', v_errors
  );
END;
$$;


--
-- TOC entry 414 (class 1255 OID 17193)
-- Name: apply_rls(jsonb, integer); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer DEFAULT (1024 * 1024)) RETURNS SETOF realtime.wal_rls
    LANGUAGE plpgsql
    AS $$
declare
-- Regclass of the table e.g. public.notes
entity_ regclass = (quote_ident(wal ->> 'schema') || '.' || quote_ident(wal ->> 'table'))::regclass;

-- I, U, D, T: insert, update ...
action realtime.action = (
    case wal ->> 'action'
        when 'I' then 'INSERT'
        when 'U' then 'UPDATE'
        when 'D' then 'DELETE'
        else 'ERROR'
    end
);

-- Is row level security enabled for the table
is_rls_enabled bool = relrowsecurity from pg_class where oid = entity_;

subscriptions realtime.subscription[] = array_agg(subs)
    from
        realtime.subscription subs
    where
        subs.entity = entity_
        -- Filter by action early - only get subscriptions interested in this action
        -- action_filter column can be: '*' (all), 'INSERT', 'UPDATE', or 'DELETE'
        and (subs.action_filter = '*' or subs.action_filter = action::text);

-- Subscription vars
roles regrole[] = array_agg(distinct us.claims_role::text)
    from
        unnest(subscriptions) us;

working_role regrole;
claimed_role regrole;
claims jsonb;

subscription_id uuid;
subscription_has_access bool;
visible_to_subscription_ids uuid[] = '{}';

-- structured info for wal's columns
columns realtime.wal_column[];
-- previous identity values for update/delete
old_columns realtime.wal_column[];

error_record_exceeds_max_size boolean = octet_length(wal::text) > max_record_bytes;

-- Primary jsonb output for record
output jsonb;

begin
perform set_config('role', null, true);

columns =
    array_agg(
        (
            x->>'name',
            x->>'type',
            x->>'typeoid',
            realtime.cast(
                (x->'value') #>> '{}',
                coalesce(
                    (x->>'typeoid')::regtype, -- null when wal2json version <= 2.4
                    (x->>'type')::regtype
                )
            ),
            (pks ->> 'name') is not null,
            true
        )::realtime.wal_column
    )
    from
        jsonb_array_elements(wal -> 'columns') x
        left join jsonb_array_elements(wal -> 'pk') pks
            on (x ->> 'name') = (pks ->> 'name');

old_columns =
    array_agg(
        (
            x->>'name',
            x->>'type',
            x->>'typeoid',
            realtime.cast(
                (x->'value') #>> '{}',
                coalesce(
                    (x->>'typeoid')::regtype, -- null when wal2json version <= 2.4
                    (x->>'type')::regtype
                )
            ),
            (pks ->> 'name') is not null,
            true
        )::realtime.wal_column
    )
    from
        jsonb_array_elements(wal -> 'identity') x
        left join jsonb_array_elements(wal -> 'pk') pks
            on (x ->> 'name') = (pks ->> 'name');

for working_role in select * from unnest(roles) loop

    -- Update `is_selectable` for columns and old_columns
    columns =
        array_agg(
            (
                c.name,
                c.type_name,
                c.type_oid,
                c.value,
                c.is_pkey,
                pg_catalog.has_column_privilege(working_role, entity_, c.name, 'SELECT')
            )::realtime.wal_column
        )
        from
            unnest(columns) c;

    old_columns =
            array_agg(
                (
                    c.name,
                    c.type_name,
                    c.type_oid,
                    c.value,
                    c.is_pkey,
                    pg_catalog.has_column_privilege(working_role, entity_, c.name, 'SELECT')
                )::realtime.wal_column
            )
            from
                unnest(old_columns) c;

    if action <> 'DELETE' and count(1) = 0 from unnest(columns) c where c.is_pkey then
        return next (
            jsonb_build_object(
                'schema', wal ->> 'schema',
                'table', wal ->> 'table',
                'type', action
            ),
            is_rls_enabled,
            -- subscriptions is already filtered by entity
            (select array_agg(s.subscription_id) from unnest(subscriptions) as s where claims_role = working_role),
            array['Error 400: Bad Request, no primary key']
        )::realtime.wal_rls;

    -- The claims role does not have SELECT permission to the primary key of entity
    elsif action <> 'DELETE' and sum(c.is_selectable::int) <> count(1) from unnest(columns) c where c.is_pkey then
        return next (
            jsonb_build_object(
                'schema', wal ->> 'schema',
                'table', wal ->> 'table',
                'type', action
            ),
            is_rls_enabled,
            (select array_agg(s.subscription_id) from unnest(subscriptions) as s where claims_role = working_role),
            array['Error 401: Unauthorized']
        )::realtime.wal_rls;

    else
        output = jsonb_build_object(
            'schema', wal ->> 'schema',
            'table', wal ->> 'table',
            'type', action,
            'commit_timestamp', to_char(
                ((wal ->> 'timestamp')::timestamptz at time zone 'utc'),
                'YYYY-MM-DD"T"HH24:MI:SS.MS"Z"'
            ),
            'columns', (
                select
                    jsonb_agg(
                        jsonb_build_object(
                            'name', pa.attname,
                            'type', pt.typname
                        )
                        order by pa.attnum asc
                    )
                from
                    pg_attribute pa
                    join pg_type pt
                        on pa.atttypid = pt.oid
                where
                    attrelid = entity_
                    and attnum > 0
                    and pg_catalog.has_column_privilege(working_role, entity_, pa.attname, 'SELECT')
            )
        )
        -- Add "record" key for insert and update
        || case
            when action in ('INSERT', 'UPDATE') then
                jsonb_build_object(
                    'record',
                    (
                        select
                            jsonb_object_agg(
                                -- if unchanged toast, get column name and value from old record
                                coalesce((c).name, (oc).name),
                                case
                                    when (c).name is null then (oc).value
                                    else (c).value
                                end
                            )
                        from
                            unnest(columns) c
                            full outer join unnest(old_columns) oc
                                on (c).name = (oc).name
                        where
                            coalesce((c).is_selectable, (oc).is_selectable)
                            and ( not error_record_exceeds_max_size or (octet_length((c).value::text) <= 64))
                    )
                )
            else '{}'::jsonb
        end
        -- Add "old_record" key for update and delete
        || case
            when action = 'UPDATE' then
                jsonb_build_object(
                        'old_record',
                        (
                            select jsonb_object_agg((c).name, (c).value)
                            from unnest(old_columns) c
                            where
                                (c).is_selectable
                                and ( not error_record_exceeds_max_size or (octet_length((c).value::text) <= 64))
                        )
                    )
            when action = 'DELETE' then
                jsonb_build_object(
                    'old_record',
                    (
                        select jsonb_object_agg((c).name, (c).value)
                        from unnest(old_columns) c
                        where
                            (c).is_selectable
                            and ( not error_record_exceeds_max_size or (octet_length((c).value::text) <= 64))
                            and ( not is_rls_enabled or (c).is_pkey ) -- if RLS enabled, we can't secure deletes so filter to pkey
                    )
                )
            else '{}'::jsonb
        end;

        -- Create the prepared statement
        if is_rls_enabled and action <> 'DELETE' then
            if (select 1 from pg_prepared_statements where name = 'walrus_rls_stmt' limit 1) > 0 then
                deallocate walrus_rls_stmt;
            end if;
            execute realtime.build_prepared_statement_sql('walrus_rls_stmt', entity_, columns);
        end if;

        visible_to_subscription_ids = '{}';

        for subscription_id, claims in (
                select
                    subs.subscription_id,
                    subs.claims
                from
                    unnest(subscriptions) subs
                where
                    subs.entity = entity_
                    and subs.claims_role = working_role
                    and (
                        realtime.is_visible_through_filters(columns, subs.filters)
                        or (
                          action = 'DELETE'
                          and realtime.is_visible_through_filters(old_columns, subs.filters)
                        )
                    )
        ) loop

            if not is_rls_enabled or action = 'DELETE' then
                visible_to_subscription_ids = visible_to_subscription_ids || subscription_id;
            else
                -- Check if RLS allows the role to see the record
                perform
                    -- Trim leading and trailing quotes from working_role because set_config
                    -- doesn't recognize the role as valid if they are included
                    set_config('role', trim(both '"' from working_role::text), true),
                    set_config('request.jwt.claims', claims::text, true);

                execute 'execute walrus_rls_stmt' into subscription_has_access;

                if subscription_has_access then
                    visible_to_subscription_ids = visible_to_subscription_ids || subscription_id;
                end if;
            end if;
        end loop;

        perform set_config('role', null, true);

        return next (
            output,
            is_rls_enabled,
            visible_to_subscription_ids,
            case
                when error_record_exceeds_max_size then array['Error 413: Payload Too Large']
                else '{}'
            end
        )::realtime.wal_rls;

    end if;
end loop;

perform set_config('role', null, true);
end;
$$;


--
-- TOC entry 444 (class 1255 OID 17272)
-- Name: broadcast_changes(text, text, text, text, text, record, record, text); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime.broadcast_changes(topic_name text, event_name text, operation text, table_name text, table_schema text, new record, old record, level text DEFAULT 'ROW'::text) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
    -- Declare a variable to hold the JSONB representation of the row
    row_data jsonb := '{}'::jsonb;
BEGIN
    IF level = 'STATEMENT' THEN
        RAISE EXCEPTION 'function can only be triggered for each row, not for each statement';
    END IF;
    -- Check the operation type and handle accordingly
    IF operation = 'INSERT' OR operation = 'UPDATE' OR operation = 'DELETE' THEN
        row_data := jsonb_build_object('old_record', OLD, 'record', NEW, 'operation', operation, 'table', table_name, 'schema', table_schema);
        PERFORM realtime.send (row_data, event_name, topic_name);
    ELSE
        RAISE EXCEPTION 'Unexpected operation type: %', operation;
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Failed to process the row: %', SQLERRM;
END;

$$;


--
-- TOC entry 431 (class 1255 OID 17205)
-- Name: build_prepared_statement_sql(text, regclass, realtime.wal_column[]); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) RETURNS text
    LANGUAGE sql
    AS $$
      /*
      Builds a sql string that, if executed, creates a prepared statement to
      tests retrive a row from *entity* by its primary key columns.
      Example
          select realtime.build_prepared_statement_sql('public.notes', '{"id"}'::text[], '{"bigint"}'::text[])
      */
          select
      'prepare ' || prepared_statement_name || ' as
          select
              exists(
                  select
                      1
                  from
                      ' || entity || '
                  where
                      ' || string_agg(quote_ident(pkc.name) || '=' || quote_nullable(pkc.value #>> '{}') , ' and ') || '
              )'
          from
              unnest(columns) pkc
          where
              pkc.is_pkey
          group by
              entity
      $$;


--
-- TOC entry 540 (class 1255 OID 17152)
-- Name: cast(text, regtype); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime."cast"(val text, type_ regtype) RETURNS jsonb
    LANGUAGE plpgsql IMMUTABLE
    AS $$
    declare
      res jsonb;
    begin
      execute format('select to_jsonb(%L::'|| type_::text || ')', val)  into res;
      return res;
    end
    $$;


--
-- TOC entry 427 (class 1255 OID 17146)
-- Name: check_equality_op(realtime.equality_op, regtype, text, text); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) RETURNS boolean
    LANGUAGE plpgsql IMMUTABLE
    AS $$
      /*
      Casts *val_1* and *val_2* as type *type_* and check the *op* condition for truthiness
      */
      declare
          op_symbol text = (
              case
                  when op = 'eq' then '='
                  when op = 'neq' then '!='
                  when op = 'lt' then '<'
                  when op = 'lte' then '<='
                  when op = 'gt' then '>'
                  when op = 'gte' then '>='
                  when op = 'in' then '= any'
                  else 'UNKNOWN OP'
              end
          );
          res boolean;
      begin
          execute format(
              'select %L::'|| type_::text || ' ' || op_symbol
              || ' ( %L::'
              || (
                  case
                      when op = 'in' then type_::text || '[]'
                      else type_::text end
              )
              || ')', val_1, val_2) into res;
          return res;
      end;
      $$;


--
-- TOC entry 380 (class 1255 OID 17201)
-- Name: is_visible_through_filters(realtime.wal_column[], realtime.user_defined_filter[]); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) RETURNS boolean
    LANGUAGE sql IMMUTABLE
    AS $_$
    /*
    Should the record be visible (true) or filtered out (false) after *filters* are applied
    */
        select
            -- Default to allowed when no filters present
            $2 is null -- no filters. this should not happen because subscriptions has a default
            or array_length($2, 1) is null -- array length of an empty array is null
            or bool_and(
                coalesce(
                    realtime.check_equality_op(
                        op:=f.op,
                        type_:=coalesce(
                            col.type_oid::regtype, -- null when wal2json version <= 2.4
                            col.type_name::regtype
                        ),
                        -- cast jsonb to text
                        val_1:=col.value #>> '{}',
                        val_2:=f.value
                    ),
                    false -- if null, filter does not match
                )
            )
        from
            unnest(filters) f
            join unnest(columns) col
                on f.column_name = col.name;
    $_$;


--
-- TOC entry 572 (class 1255 OID 17212)
-- Name: list_changes(name, name, integer, integer); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) RETURNS SETOF realtime.wal_rls
    LANGUAGE sql
    SET log_min_messages TO 'fatal'
    AS $$
      with pub as (
        select
          concat_ws(
            ',',
            case when bool_or(pubinsert) then 'insert' else null end,
            case when bool_or(pubupdate) then 'update' else null end,
            case when bool_or(pubdelete) then 'delete' else null end
          ) as w2j_actions,
          coalesce(
            string_agg(
              realtime.quote_wal2json(format('%I.%I', schemaname, tablename)::regclass),
              ','
            ) filter (where ppt.tablename is not null and ppt.tablename not like '% %'),
            ''
          ) w2j_add_tables
        from
          pg_publication pp
          left join pg_publication_tables ppt
            on pp.pubname = ppt.pubname
        where
          pp.pubname = publication
        group by
          pp.pubname
        limit 1
      ),
      w2j as (
        select
          x.*, pub.w2j_add_tables
        from
          pub,
          pg_logical_slot_get_changes(
            slot_name, null, max_changes,
            'include-pk', 'true',
            'include-transaction', 'false',
            'include-timestamp', 'true',
            'include-type-oids', 'true',
            'format-version', '2',
            'actions', pub.w2j_actions,
            'add-tables', pub.w2j_add_tables
          ) x
      )
      select
        xyz.wal,
        xyz.is_rls_enabled,
        xyz.subscription_ids,
        xyz.errors
      from
        w2j,
        realtime.apply_rls(
          wal := w2j.data::jsonb,
          max_record_bytes := max_record_bytes
        ) xyz(wal, is_rls_enabled, subscription_ids, errors)
      where
        w2j.w2j_add_tables <> ''
        and xyz.subscription_ids[1] is not null
    $$;


--
-- TOC entry 667 (class 1255 OID 17145)
-- Name: quote_wal2json(regclass); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime.quote_wal2json(entity regclass) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $$
      select
        (
          select string_agg('' || ch,'')
          from unnest(string_to_array(nsp.nspname::text, null)) with ordinality x(ch, idx)
          where
            not (x.idx = 1 and x.ch = '"')
            and not (
              x.idx = array_length(string_to_array(nsp.nspname::text, null), 1)
              and x.ch = '"'
            )
        )
        || '.'
        || (
          select string_agg('' || ch,'')
          from unnest(string_to_array(pc.relname::text, null)) with ordinality x(ch, idx)
          where
            not (x.idx = 1 and x.ch = '"')
            and not (
              x.idx = array_length(string_to_array(nsp.nspname::text, null), 1)
              and x.ch = '"'
            )
          )
      from
        pg_class pc
        join pg_namespace nsp
          on pc.relnamespace = nsp.oid
      where
        pc.oid = entity
    $$;


--
-- TOC entry 641 (class 1255 OID 17271)
-- Name: send(jsonb, text, text, boolean); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime.send(payload jsonb, event text, topic text, private boolean DEFAULT true) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
  generated_id uuid;
  final_payload jsonb;
BEGIN
  BEGIN
    -- Generate a new UUID for the id
    generated_id := gen_random_uuid();

    -- Check if payload has an 'id' key, if not, add the generated UUID
    IF payload ? 'id' THEN
      final_payload := payload;
    ELSE
      final_payload := jsonb_set(payload, '{id}', to_jsonb(generated_id));
    END IF;

    -- Set the topic configuration
    EXECUTE format('SET LOCAL realtime.topic TO %L', topic);

    -- Attempt to insert the message
    INSERT INTO realtime.messages (id, payload, event, topic, private, extension)
    VALUES (generated_id, final_payload, event, topic, private, 'broadcast');
  EXCEPTION
    WHEN OTHERS THEN
      -- Capture and notify the error
      RAISE WARNING 'ErrorSendingBroadcastMessage: %', SQLERRM;
  END;
END;
$$;


--
-- TOC entry 457 (class 1255 OID 17143)
-- Name: subscription_check_filters(); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime.subscription_check_filters() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
    /*
    Validates that the user defined filters for a subscription:
    - refer to valid columns that the claimed role may access
    - values are coercable to the correct column type
    */
    declare
        col_names text[] = coalesce(
                array_agg(c.column_name order by c.ordinal_position),
                '{}'::text[]
            )
            from
                information_schema.columns c
            where
                format('%I.%I', c.table_schema, c.table_name)::regclass = new.entity
                and pg_catalog.has_column_privilege(
                    (new.claims ->> 'role'),
                    format('%I.%I', c.table_schema, c.table_name)::regclass,
                    c.column_name,
                    'SELECT'
                );
        filter realtime.user_defined_filter;
        col_type regtype;

        in_val jsonb;
    begin
        for filter in select * from unnest(new.filters) loop
            -- Filtered column is valid
            if not filter.column_name = any(col_names) then
                raise exception 'invalid column for filter %', filter.column_name;
            end if;

            -- Type is sanitized and safe for string interpolation
            col_type = (
                select atttypid::regtype
                from pg_catalog.pg_attribute
                where attrelid = new.entity
                      and attname = filter.column_name
            );
            if col_type is null then
                raise exception 'failed to lookup type for column %', filter.column_name;
            end if;

            -- Set maximum number of entries for in filter
            if filter.op = 'in'::realtime.equality_op then
                in_val = realtime.cast(filter.value, (col_type::text || '[]')::regtype);
                if coalesce(jsonb_array_length(in_val), 0) > 100 then
                    raise exception 'too many values for `in` filter. Maximum 100';
                end if;
            else
                -- raises an exception if value is not coercable to type
                perform realtime.cast(filter.value, col_type);
            end if;

        end loop;

        -- Apply consistent order to filters so the unique constraint on
        -- (subscription_id, entity, filters) can't be tricked by a different filter order
        new.filters = coalesce(
            array_agg(f order by f.column_name, f.op, f.value),
            '{}'
        ) from unnest(new.filters) f;

        return new;
    end;
    $$;


--
-- TOC entry 682 (class 1255 OID 17178)
-- Name: to_regrole(text); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime.to_regrole(role_name text) RETURNS regrole
    LANGUAGE sql IMMUTABLE
    AS $$ select role_name::regrole $$;


--
-- TOC entry 644 (class 1255 OID 17265)
-- Name: topic(); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime.topic() RETURNS text
    LANGUAGE sql STABLE
    AS $$
select nullif(current_setting('realtime.topic', true), '')::text;
$$;


--
-- TOC entry 579 (class 1255 OID 17053)
-- Name: can_insert_object(text, text, uuid, jsonb); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.can_insert_object(bucketid text, name text, owner uuid, metadata jsonb) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
  INSERT INTO "storage"."objects" ("bucket_id", "name", "owner", "metadata") VALUES (bucketid, name, owner, metadata);
  -- hack to rollback the successful insert
  RAISE sqlstate 'PT200' using
  message = 'ROLLBACK',
  detail = 'rollback successful insert';
END
$$;


--
-- TOC entry 542 (class 1255 OID 20279)
-- Name: delete_leaf_prefixes(text[], text[]); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.delete_leaf_prefixes(bucket_ids text[], names text[]) RETURNS void
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    v_rows_deleted integer;
BEGIN
    LOOP
        WITH candidates AS (
            SELECT DISTINCT
                t.bucket_id,
                unnest(storage.get_prefixes(t.name)) AS name
            FROM unnest(bucket_ids, names) AS t(bucket_id, name)
        ),
        uniq AS (
             SELECT
                 bucket_id,
                 name,
                 storage.get_level(name) AS level
             FROM candidates
             WHERE name <> ''
             GROUP BY bucket_id, name
        ),
        leaf AS (
             SELECT
                 p.bucket_id,
                 p.name,
                 p.level
             FROM storage.prefixes AS p
                  JOIN uniq AS u
                       ON u.bucket_id = p.bucket_id
                           AND u.name = p.name
                           AND u.level = p.level
             WHERE NOT EXISTS (
                 SELECT 1
                 FROM storage.objects AS o
                 WHERE o.bucket_id = p.bucket_id
                   AND o.level = p.level + 1
                   AND o.name COLLATE "C" LIKE p.name || '/%'
             )
             AND NOT EXISTS (
                 SELECT 1
                 FROM storage.prefixes AS c
                 WHERE c.bucket_id = p.bucket_id
                   AND c.level = p.level + 1
                   AND c.name COLLATE "C" LIKE p.name || '/%'
             )
        )
        DELETE
        FROM storage.prefixes AS p
            USING leaf AS l
        WHERE p.bucket_id = l.bucket_id
          AND p.name = l.name
          AND p.level = l.level;

        GET DIAGNOSTICS v_rows_deleted = ROW_COUNT;
        EXIT WHEN v_rows_deleted = 0;
    END LOOP;
END;
$$;


--
-- TOC entry 598 (class 1255 OID 20257)
-- Name: enforce_bucket_name_length(); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.enforce_bucket_name_length() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
begin
    if length(new.name) > 100 then
        raise exception 'bucket name "%" is too long (% characters). Max is 100.', new.name, length(new.name);
    end if;
    return new;
end;
$$;


--
-- TOC entry 620 (class 1255 OID 17027)
-- Name: extension(text); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.extension(name text) RETURNS text
    LANGUAGE plpgsql IMMUTABLE
    AS $$
DECLARE
    _parts text[];
    _filename text;
BEGIN
    SELECT string_to_array(name, '/') INTO _parts;
    SELECT _parts[array_length(_parts,1)] INTO _filename;
    RETURN reverse(split_part(reverse(_filename), '.', 1));
END
$$;


--
-- TOC entry 516 (class 1255 OID 17026)
-- Name: filename(text); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.filename(name text) RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
_parts text[];
BEGIN
	select string_to_array(name, '/') into _parts;
	return _parts[array_length(_parts,1)];
END
$$;


--
-- TOC entry 398 (class 1255 OID 17025)
-- Name: foldername(text); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.foldername(name text) RETURNS text[]
    LANGUAGE plpgsql IMMUTABLE
    AS $$
DECLARE
    _parts text[];
BEGIN
    -- Split on "/" to get path segments
    SELECT string_to_array(name, '/') INTO _parts;
    -- Return everything except the last segment
    RETURN _parts[1 : array_length(_parts,1) - 1];
END
$$;


--
-- TOC entry 498 (class 1255 OID 118335)
-- Name: get_common_prefix(text, text, text); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.get_common_prefix(p_key text, p_prefix text, p_delimiter text) RETURNS text
    LANGUAGE sql IMMUTABLE
    AS $$
SELECT CASE
    WHEN position(p_delimiter IN substring(p_key FROM length(p_prefix) + 1)) > 0
    THEN left(p_key, length(p_prefix) + position(p_delimiter IN substring(p_key FROM length(p_prefix) + 1)))
    ELSE NULL
END;
$$;


--
-- TOC entry 475 (class 1255 OID 20220)
-- Name: get_level(text); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.get_level(name text) RETURNS integer
    LANGUAGE sql IMMUTABLE STRICT
    AS $$
SELECT array_length(string_to_array("name", '/'), 1);
$$;


--
-- TOC entry 691 (class 1255 OID 20236)
-- Name: get_prefix(text); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.get_prefix(name text) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
SELECT
    CASE WHEN strpos("name", '/') > 0 THEN
             regexp_replace("name", '[\/]{1}[^\/]+\/?$', '')
         ELSE
             ''
        END;
$_$;


--
-- TOC entry 534 (class 1255 OID 20237)
-- Name: get_prefixes(text); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.get_prefixes(name text) RETURNS text[]
    LANGUAGE plpgsql IMMUTABLE STRICT
    AS $$
DECLARE
    parts text[];
    prefixes text[];
    prefix text;
BEGIN
    -- Split the name into parts by '/'
    parts := string_to_array("name", '/');
    prefixes := '{}';

    -- Construct the prefixes, stopping one level below the last part
    FOR i IN 1..array_length(parts, 1) - 1 LOOP
            prefix := array_to_string(parts[1:i], '/');
            prefixes := array_append(prefixes, prefix);
    END LOOP;

    RETURN prefixes;
END;
$$;


--
-- TOC entry 435 (class 1255 OID 20255)
-- Name: get_size_by_bucket(); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.get_size_by_bucket() RETURNS TABLE(size bigint, bucket_id text)
    LANGUAGE plpgsql STABLE
    AS $$
BEGIN
    return query
        select sum((metadata->>'size')::bigint) as size, obj.bucket_id
        from "storage".objects as obj
        group by obj.bucket_id;
END
$$;


--
-- TOC entry 488 (class 1255 OID 17092)
-- Name: list_multipart_uploads_with_delimiter(text, text, text, integer, text, text); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.list_multipart_uploads_with_delimiter(bucket_id text, prefix_param text, delimiter_param text, max_keys integer DEFAULT 100, next_key_token text DEFAULT ''::text, next_upload_token text DEFAULT ''::text) RETURNS TABLE(key text, id text, created_at timestamp with time zone)
    LANGUAGE plpgsql
    AS $_$
BEGIN
    RETURN QUERY EXECUTE
        'SELECT DISTINCT ON(key COLLATE "C") * from (
            SELECT
                CASE
                    WHEN position($2 IN substring(key from length($1) + 1)) > 0 THEN
                        substring(key from 1 for length($1) + position($2 IN substring(key from length($1) + 1)))
                    ELSE
                        key
                END AS key, id, created_at
            FROM
                storage.s3_multipart_uploads
            WHERE
                bucket_id = $5 AND
                key ILIKE $1 || ''%'' AND
                CASE
                    WHEN $4 != '''' AND $6 = '''' THEN
                        CASE
                            WHEN position($2 IN substring(key from length($1) + 1)) > 0 THEN
                                substring(key from 1 for length($1) + position($2 IN substring(key from length($1) + 1))) COLLATE "C" > $4
                            ELSE
                                key COLLATE "C" > $4
                            END
                    ELSE
                        true
                END AND
                CASE
                    WHEN $6 != '''' THEN
                        id COLLATE "C" > $6
                    ELSE
                        true
                    END
            ORDER BY
                key COLLATE "C" ASC, created_at ASC) as e order by key COLLATE "C" LIMIT $3'
        USING prefix_param, delimiter_param, max_keys, next_key_token, bucket_id, next_upload_token;
END;
$_$;


--
-- TOC entry 607 (class 1255 OID 118336)
-- Name: list_objects_with_delimiter(text, text, text, integer, text, text, text); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.list_objects_with_delimiter(_bucket_id text, prefix_param text, delimiter_param text, max_keys integer DEFAULT 100, start_after text DEFAULT ''::text, next_token text DEFAULT ''::text, sort_order text DEFAULT 'asc'::text) RETURNS TABLE(name text, id uuid, metadata jsonb, updated_at timestamp with time zone, created_at timestamp with time zone, last_accessed_at timestamp with time zone)
    LANGUAGE plpgsql STABLE
    AS $_$
DECLARE
    v_peek_name TEXT;
    v_current RECORD;
    v_common_prefix TEXT;

    -- Configuration
    v_is_asc BOOLEAN;
    v_prefix TEXT;
    v_start TEXT;
    v_upper_bound TEXT;
    v_file_batch_size INT;

    -- Seek state
    v_next_seek TEXT;
    v_count INT := 0;

    -- Dynamic SQL for batch query only
    v_batch_query TEXT;

BEGIN
    -- ========================================================================
    -- INITIALIZATION
    -- ========================================================================
    v_is_asc := lower(coalesce(sort_order, 'asc')) = 'asc';
    v_prefix := coalesce(prefix_param, '');
    v_start := CASE WHEN coalesce(next_token, '') <> '' THEN next_token ELSE coalesce(start_after, '') END;
    v_file_batch_size := LEAST(GREATEST(max_keys * 2, 100), 1000);

    -- Calculate upper bound for prefix filtering (bytewise, using COLLATE "C")
    IF v_prefix = '' THEN
        v_upper_bound := NULL;
    ELSIF right(v_prefix, 1) = delimiter_param THEN
        v_upper_bound := left(v_prefix, -1) || chr(ascii(delimiter_param) + 1);
    ELSE
        v_upper_bound := left(v_prefix, -1) || chr(ascii(right(v_prefix, 1)) + 1);
    END IF;

    -- Build batch query (dynamic SQL - called infrequently, amortized over many rows)
    IF v_is_asc THEN
        IF v_upper_bound IS NOT NULL THEN
            v_batch_query := 'SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata ' ||
                'FROM storage.objects o WHERE o.bucket_id = $1 AND o.name COLLATE "C" >= $2 ' ||
                'AND o.name COLLATE "C" < $3 ORDER BY o.name COLLATE "C" ASC LIMIT $4';
        ELSE
            v_batch_query := 'SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata ' ||
                'FROM storage.objects o WHERE o.bucket_id = $1 AND o.name COLLATE "C" >= $2 ' ||
                'ORDER BY o.name COLLATE "C" ASC LIMIT $4';
        END IF;
    ELSE
        IF v_upper_bound IS NOT NULL THEN
            v_batch_query := 'SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata ' ||
                'FROM storage.objects o WHERE o.bucket_id = $1 AND o.name COLLATE "C" < $2 ' ||
                'AND o.name COLLATE "C" >= $3 ORDER BY o.name COLLATE "C" DESC LIMIT $4';
        ELSE
            v_batch_query := 'SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata ' ||
                'FROM storage.objects o WHERE o.bucket_id = $1 AND o.name COLLATE "C" < $2 ' ||
                'ORDER BY o.name COLLATE "C" DESC LIMIT $4';
        END IF;
    END IF;

    -- ========================================================================
    -- SEEK INITIALIZATION: Determine starting position
    -- ========================================================================
    IF v_start = '' THEN
        IF v_is_asc THEN
            v_next_seek := v_prefix;
        ELSE
            -- DESC without cursor: find the last item in range
            IF v_upper_bound IS NOT NULL THEN
                SELECT o.name INTO v_next_seek FROM storage.objects o
                WHERE o.bucket_id = _bucket_id AND o.name COLLATE "C" >= v_prefix AND o.name COLLATE "C" < v_upper_bound
                ORDER BY o.name COLLATE "C" DESC LIMIT 1;
            ELSIF v_prefix <> '' THEN
                SELECT o.name INTO v_next_seek FROM storage.objects o
                WHERE o.bucket_id = _bucket_id AND o.name COLLATE "C" >= v_prefix
                ORDER BY o.name COLLATE "C" DESC LIMIT 1;
            ELSE
                SELECT o.name INTO v_next_seek FROM storage.objects o
                WHERE o.bucket_id = _bucket_id
                ORDER BY o.name COLLATE "C" DESC LIMIT 1;
            END IF;

            IF v_next_seek IS NOT NULL THEN
                v_next_seek := v_next_seek || delimiter_param;
            ELSE
                RETURN;
            END IF;
        END IF;
    ELSE
        -- Cursor provided: determine if it refers to a folder or leaf
        IF EXISTS (
            SELECT 1 FROM storage.objects o
            WHERE o.bucket_id = _bucket_id
              AND o.name COLLATE "C" LIKE v_start || delimiter_param || '%'
            LIMIT 1
        ) THEN
            -- Cursor refers to a folder
            IF v_is_asc THEN
                v_next_seek := v_start || chr(ascii(delimiter_param) + 1);
            ELSE
                v_next_seek := v_start || delimiter_param;
            END IF;
        ELSE
            -- Cursor refers to a leaf object
            IF v_is_asc THEN
                v_next_seek := v_start || delimiter_param;
            ELSE
                v_next_seek := v_start;
            END IF;
        END IF;
    END IF;

    -- ========================================================================
    -- MAIN LOOP: Hybrid peek-then-batch algorithm
    -- Uses STATIC SQL for peek (hot path) and DYNAMIC SQL for batch
    -- ========================================================================
    LOOP
        EXIT WHEN v_count >= max_keys;

        -- STEP 1: PEEK using STATIC SQL (plan cached, very fast)
        IF v_is_asc THEN
            IF v_upper_bound IS NOT NULL THEN
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = _bucket_id AND o.name COLLATE "C" >= v_next_seek AND o.name COLLATE "C" < v_upper_bound
                ORDER BY o.name COLLATE "C" ASC LIMIT 1;
            ELSE
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = _bucket_id AND o.name COLLATE "C" >= v_next_seek
                ORDER BY o.name COLLATE "C" ASC LIMIT 1;
            END IF;
        ELSE
            IF v_upper_bound IS NOT NULL THEN
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = _bucket_id AND o.name COLLATE "C" < v_next_seek AND o.name COLLATE "C" >= v_prefix
                ORDER BY o.name COLLATE "C" DESC LIMIT 1;
            ELSIF v_prefix <> '' THEN
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = _bucket_id AND o.name COLLATE "C" < v_next_seek AND o.name COLLATE "C" >= v_prefix
                ORDER BY o.name COLLATE "C" DESC LIMIT 1;
            ELSE
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = _bucket_id AND o.name COLLATE "C" < v_next_seek
                ORDER BY o.name COLLATE "C" DESC LIMIT 1;
            END IF;
        END IF;

        EXIT WHEN v_peek_name IS NULL;

        -- STEP 2: Check if this is a FOLDER or FILE
        v_common_prefix := storage.get_common_prefix(v_peek_name, v_prefix, delimiter_param);

        IF v_common_prefix IS NOT NULL THEN
            -- FOLDER: Emit and skip to next folder (no heap access needed)
            name := rtrim(v_common_prefix, delimiter_param);
            id := NULL;
            updated_at := NULL;
            created_at := NULL;
            last_accessed_at := NULL;
            metadata := NULL;
            RETURN NEXT;
            v_count := v_count + 1;

            -- Advance seek past the folder range
            IF v_is_asc THEN
                v_next_seek := left(v_common_prefix, -1) || chr(ascii(delimiter_param) + 1);
            ELSE
                v_next_seek := v_common_prefix;
            END IF;
        ELSE
            -- FILE: Batch fetch using DYNAMIC SQL (overhead amortized over many rows)
            -- For ASC: upper_bound is the exclusive upper limit (< condition)
            -- For DESC: prefix is the inclusive lower limit (>= condition)
            FOR v_current IN EXECUTE v_batch_query USING _bucket_id, v_next_seek,
                CASE WHEN v_is_asc THEN COALESCE(v_upper_bound, v_prefix) ELSE v_prefix END, v_file_batch_size
            LOOP
                v_common_prefix := storage.get_common_prefix(v_current.name, v_prefix, delimiter_param);

                IF v_common_prefix IS NOT NULL THEN
                    -- Hit a folder: exit batch, let peek handle it
                    v_next_seek := v_current.name;
                    EXIT;
                END IF;

                -- Emit file
                name := v_current.name;
                id := v_current.id;
                updated_at := v_current.updated_at;
                created_at := v_current.created_at;
                last_accessed_at := v_current.last_accessed_at;
                metadata := v_current.metadata;
                RETURN NEXT;
                v_count := v_count + 1;

                -- Advance seek past this file
                IF v_is_asc THEN
                    v_next_seek := v_current.name || delimiter_param;
                ELSE
                    v_next_seek := v_current.name;
                END IF;

                EXIT WHEN v_count >= max_keys;
            END LOOP;
        END IF;
    END LOOP;
END;
$_$;


--
-- TOC entry 470 (class 1255 OID 17108)
-- Name: operation(); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.operation() RETURNS text
    LANGUAGE plpgsql STABLE
    AS $$
BEGIN
    RETURN current_setting('storage.operation', true);
END;
$$;


--
-- TOC entry 678 (class 1255 OID 118341)
-- Name: protect_delete(); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.protect_delete() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Check if storage.allow_delete_query is set to 'true'
    IF COALESCE(current_setting('storage.allow_delete_query', true), 'false') != 'true' THEN
        RAISE EXCEPTION 'Direct deletion from storage tables is not allowed. Use the Storage API instead.'
            USING HINT = 'This prevents accidental data loss from orphaned objects.',
                  ERRCODE = '42501';
    END IF;
    RETURN NULL;
END;
$$;


--
-- TOC entry 577 (class 1255 OID 17042)
-- Name: search(text, text, integer, integer, integer, text, text, text); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.search(prefix text, bucketname text, limits integer DEFAULT 100, levels integer DEFAULT 1, offsets integer DEFAULT 0, search text DEFAULT ''::text, sortcolumn text DEFAULT 'name'::text, sortorder text DEFAULT 'asc'::text) RETURNS TABLE(name text, id uuid, updated_at timestamp with time zone, created_at timestamp with time zone, last_accessed_at timestamp with time zone, metadata jsonb)
    LANGUAGE plpgsql STABLE
    AS $_$
DECLARE
    v_peek_name TEXT;
    v_current RECORD;
    v_common_prefix TEXT;
    v_delimiter CONSTANT TEXT := '/';

    -- Configuration
    v_limit INT;
    v_prefix TEXT;
    v_prefix_lower TEXT;
    v_is_asc BOOLEAN;
    v_order_by TEXT;
    v_sort_order TEXT;
    v_upper_bound TEXT;
    v_file_batch_size INT;

    -- Dynamic SQL for batch query only
    v_batch_query TEXT;

    -- Seek state
    v_next_seek TEXT;
    v_count INT := 0;
    v_skipped INT := 0;
BEGIN
    -- ========================================================================
    -- INITIALIZATION
    -- ========================================================================
    v_limit := LEAST(coalesce(limits, 100), 1500);
    v_prefix := coalesce(prefix, '') || coalesce(search, '');
    v_prefix_lower := lower(v_prefix);
    v_is_asc := lower(coalesce(sortorder, 'asc')) = 'asc';
    v_file_batch_size := LEAST(GREATEST(v_limit * 2, 100), 1000);

    -- Validate sort column
    CASE lower(coalesce(sortcolumn, 'name'))
        WHEN 'name' THEN v_order_by := 'name';
        WHEN 'updated_at' THEN v_order_by := 'updated_at';
        WHEN 'created_at' THEN v_order_by := 'created_at';
        WHEN 'last_accessed_at' THEN v_order_by := 'last_accessed_at';
        ELSE v_order_by := 'name';
    END CASE;

    v_sort_order := CASE WHEN v_is_asc THEN 'asc' ELSE 'desc' END;

    -- ========================================================================
    -- NON-NAME SORTING: Use path_tokens approach (unchanged)
    -- ========================================================================
    IF v_order_by != 'name' THEN
        RETURN QUERY EXECUTE format(
            $sql$
            WITH folders AS (
                SELECT path_tokens[$1] AS folder
                FROM storage.objects
                WHERE objects.name ILIKE $2 || '%%'
                  AND bucket_id = $3
                  AND array_length(objects.path_tokens, 1) <> $1
                GROUP BY folder
                ORDER BY folder %s
            )
            (SELECT folder AS "name",
                   NULL::uuid AS id,
                   NULL::timestamptz AS updated_at,
                   NULL::timestamptz AS created_at,
                   NULL::timestamptz AS last_accessed_at,
                   NULL::jsonb AS metadata FROM folders)
            UNION ALL
            (SELECT path_tokens[$1] AS "name",
                   id, updated_at, created_at, last_accessed_at, metadata
             FROM storage.objects
             WHERE objects.name ILIKE $2 || '%%'
               AND bucket_id = $3
               AND array_length(objects.path_tokens, 1) = $1
             ORDER BY %I %s)
            LIMIT $4 OFFSET $5
            $sql$, v_sort_order, v_order_by, v_sort_order
        ) USING levels, v_prefix, bucketname, v_limit, offsets;
        RETURN;
    END IF;

    -- ========================================================================
    -- NAME SORTING: Hybrid skip-scan with batch optimization
    -- ========================================================================

    -- Calculate upper bound for prefix filtering
    IF v_prefix_lower = '' THEN
        v_upper_bound := NULL;
    ELSIF right(v_prefix_lower, 1) = v_delimiter THEN
        v_upper_bound := left(v_prefix_lower, -1) || chr(ascii(v_delimiter) + 1);
    ELSE
        v_upper_bound := left(v_prefix_lower, -1) || chr(ascii(right(v_prefix_lower, 1)) + 1);
    END IF;

    -- Build batch query (dynamic SQL - called infrequently, amortized over many rows)
    IF v_is_asc THEN
        IF v_upper_bound IS NOT NULL THEN
            v_batch_query := 'SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata ' ||
                'FROM storage.objects o WHERE o.bucket_id = $1 AND lower(o.name) COLLATE "C" >= $2 ' ||
                'AND lower(o.name) COLLATE "C" < $3 ORDER BY lower(o.name) COLLATE "C" ASC LIMIT $4';
        ELSE
            v_batch_query := 'SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata ' ||
                'FROM storage.objects o WHERE o.bucket_id = $1 AND lower(o.name) COLLATE "C" >= $2 ' ||
                'ORDER BY lower(o.name) COLLATE "C" ASC LIMIT $4';
        END IF;
    ELSE
        IF v_upper_bound IS NOT NULL THEN
            v_batch_query := 'SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata ' ||
                'FROM storage.objects o WHERE o.bucket_id = $1 AND lower(o.name) COLLATE "C" < $2 ' ||
                'AND lower(o.name) COLLATE "C" >= $3 ORDER BY lower(o.name) COLLATE "C" DESC LIMIT $4';
        ELSE
            v_batch_query := 'SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata ' ||
                'FROM storage.objects o WHERE o.bucket_id = $1 AND lower(o.name) COLLATE "C" < $2 ' ||
                'ORDER BY lower(o.name) COLLATE "C" DESC LIMIT $4';
        END IF;
    END IF;

    -- Initialize seek position
    IF v_is_asc THEN
        v_next_seek := v_prefix_lower;
    ELSE
        -- DESC: find the last item in range first (static SQL)
        IF v_upper_bound IS NOT NULL THEN
            SELECT o.name INTO v_peek_name FROM storage.objects o
            WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" >= v_prefix_lower AND lower(o.name) COLLATE "C" < v_upper_bound
            ORDER BY lower(o.name) COLLATE "C" DESC LIMIT 1;
        ELSIF v_prefix_lower <> '' THEN
            SELECT o.name INTO v_peek_name FROM storage.objects o
            WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" >= v_prefix_lower
            ORDER BY lower(o.name) COLLATE "C" DESC LIMIT 1;
        ELSE
            SELECT o.name INTO v_peek_name FROM storage.objects o
            WHERE o.bucket_id = bucketname
            ORDER BY lower(o.name) COLLATE "C" DESC LIMIT 1;
        END IF;

        IF v_peek_name IS NOT NULL THEN
            v_next_seek := lower(v_peek_name) || v_delimiter;
        ELSE
            RETURN;
        END IF;
    END IF;

    -- ========================================================================
    -- MAIN LOOP: Hybrid peek-then-batch algorithm
    -- Uses STATIC SQL for peek (hot path) and DYNAMIC SQL for batch
    -- ========================================================================
    LOOP
        EXIT WHEN v_count >= v_limit;

        -- STEP 1: PEEK using STATIC SQL (plan cached, very fast)
        IF v_is_asc THEN
            IF v_upper_bound IS NOT NULL THEN
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" >= v_next_seek AND lower(o.name) COLLATE "C" < v_upper_bound
                ORDER BY lower(o.name) COLLATE "C" ASC LIMIT 1;
            ELSE
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" >= v_next_seek
                ORDER BY lower(o.name) COLLATE "C" ASC LIMIT 1;
            END IF;
        ELSE
            IF v_upper_bound IS NOT NULL THEN
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" < v_next_seek AND lower(o.name) COLLATE "C" >= v_prefix_lower
                ORDER BY lower(o.name) COLLATE "C" DESC LIMIT 1;
            ELSIF v_prefix_lower <> '' THEN
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" < v_next_seek AND lower(o.name) COLLATE "C" >= v_prefix_lower
                ORDER BY lower(o.name) COLLATE "C" DESC LIMIT 1;
            ELSE
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" < v_next_seek
                ORDER BY lower(o.name) COLLATE "C" DESC LIMIT 1;
            END IF;
        END IF;

        EXIT WHEN v_peek_name IS NULL;

        -- STEP 2: Check if this is a FOLDER or FILE
        v_common_prefix := storage.get_common_prefix(lower(v_peek_name), v_prefix_lower, v_delimiter);

        IF v_common_prefix IS NOT NULL THEN
            -- FOLDER: Handle offset, emit if needed, skip to next folder
            IF v_skipped < offsets THEN
                v_skipped := v_skipped + 1;
            ELSE
                name := split_part(rtrim(storage.get_common_prefix(v_peek_name, v_prefix, v_delimiter), v_delimiter), v_delimiter, levels);
                id := NULL;
                updated_at := NULL;
                created_at := NULL;
                last_accessed_at := NULL;
                metadata := NULL;
                RETURN NEXT;
                v_count := v_count + 1;
            END IF;

            -- Advance seek past the folder range
            IF v_is_asc THEN
                v_next_seek := lower(left(v_common_prefix, -1)) || chr(ascii(v_delimiter) + 1);
            ELSE
                v_next_seek := lower(v_common_prefix);
            END IF;
        ELSE
            -- FILE: Batch fetch using DYNAMIC SQL (overhead amortized over many rows)
            -- For ASC: upper_bound is the exclusive upper limit (< condition)
            -- For DESC: prefix_lower is the inclusive lower limit (>= condition)
            FOR v_current IN EXECUTE v_batch_query
                USING bucketname, v_next_seek,
                    CASE WHEN v_is_asc THEN COALESCE(v_upper_bound, v_prefix_lower) ELSE v_prefix_lower END, v_file_batch_size
            LOOP
                v_common_prefix := storage.get_common_prefix(lower(v_current.name), v_prefix_lower, v_delimiter);

                IF v_common_prefix IS NOT NULL THEN
                    -- Hit a folder: exit batch, let peek handle it
                    v_next_seek := lower(v_current.name);
                    EXIT;
                END IF;

                -- Handle offset skipping
                IF v_skipped < offsets THEN
                    v_skipped := v_skipped + 1;
                ELSE
                    -- Emit file
                    name := split_part(v_current.name, v_delimiter, levels);
                    id := v_current.id;
                    updated_at := v_current.updated_at;
                    created_at := v_current.created_at;
                    last_accessed_at := v_current.last_accessed_at;
                    metadata := v_current.metadata;
                    RETURN NEXT;
                    v_count := v_count + 1;
                END IF;

                -- Advance seek past this file
                IF v_is_asc THEN
                    v_next_seek := lower(v_current.name) || v_delimiter;
                ELSE
                    v_next_seek := lower(v_current.name);
                END IF;

                EXIT WHEN v_count >= v_limit;
            END LOOP;
        END IF;
    END LOOP;
END;
$_$;


--
-- TOC entry 630 (class 1255 OID 118339)
-- Name: search_by_timestamp(text, text, integer, integer, text, text, text, text); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.search_by_timestamp(p_prefix text, p_bucket_id text, p_limit integer, p_level integer, p_start_after text, p_sort_order text, p_sort_column text, p_sort_column_after text) RETURNS TABLE(key text, name text, id uuid, updated_at timestamp with time zone, created_at timestamp with time zone, last_accessed_at timestamp with time zone, metadata jsonb)
    LANGUAGE plpgsql STABLE
    AS $_$
DECLARE
    v_cursor_op text;
    v_query text;
    v_prefix text;
BEGIN
    v_prefix := coalesce(p_prefix, '');

    IF p_sort_order = 'asc' THEN
        v_cursor_op := '>';
    ELSE
        v_cursor_op := '<';
    END IF;

    v_query := format($sql$
        WITH raw_objects AS (
            SELECT
                o.name AS obj_name,
                o.id AS obj_id,
                o.updated_at AS obj_updated_at,
                o.created_at AS obj_created_at,
                o.last_accessed_at AS obj_last_accessed_at,
                o.metadata AS obj_metadata,
                storage.get_common_prefix(o.name, $1, '/') AS common_prefix
            FROM storage.objects o
            WHERE o.bucket_id = $2
              AND o.name COLLATE "C" LIKE $1 || '%%'
        ),
        -- Aggregate common prefixes (folders)
        -- Both created_at and updated_at use MIN(obj_created_at) to match the old prefixes table behavior
        aggregated_prefixes AS (
            SELECT
                rtrim(common_prefix, '/') AS name,
                NULL::uuid AS id,
                MIN(obj_created_at) AS updated_at,
                MIN(obj_created_at) AS created_at,
                NULL::timestamptz AS last_accessed_at,
                NULL::jsonb AS metadata,
                TRUE AS is_prefix
            FROM raw_objects
            WHERE common_prefix IS NOT NULL
            GROUP BY common_prefix
        ),
        leaf_objects AS (
            SELECT
                obj_name AS name,
                obj_id AS id,
                obj_updated_at AS updated_at,
                obj_created_at AS created_at,
                obj_last_accessed_at AS last_accessed_at,
                obj_metadata AS metadata,
                FALSE AS is_prefix
            FROM raw_objects
            WHERE common_prefix IS NULL
        ),
        combined AS (
            SELECT * FROM aggregated_prefixes
            UNION ALL
            SELECT * FROM leaf_objects
        ),
        filtered AS (
            SELECT *
            FROM combined
            WHERE (
                $5 = ''
                OR ROW(
                    date_trunc('milliseconds', %I),
                    name COLLATE "C"
                ) %s ROW(
                    COALESCE(NULLIF($6, '')::timestamptz, 'epoch'::timestamptz),
                    $5
                )
            )
        )
        SELECT
            split_part(name, '/', $3) AS key,
            name,
            id,
            updated_at,
            created_at,
            last_accessed_at,
            metadata
        FROM filtered
        ORDER BY
            COALESCE(date_trunc('milliseconds', %I), 'epoch'::timestamptz) %s,
            name COLLATE "C" %s
        LIMIT $4
    $sql$,
        p_sort_column,
        v_cursor_op,
        p_sort_column,
        p_sort_order,
        p_sort_order
    );

    RETURN QUERY EXECUTE v_query
    USING v_prefix, p_bucket_id, p_level, p_limit, p_start_after, p_sort_column_after;
END;
$_$;


--
-- TOC entry 385 (class 1255 OID 20253)
-- Name: search_legacy_v1(text, text, integer, integer, integer, text, text, text); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.search_legacy_v1(prefix text, bucketname text, limits integer DEFAULT 100, levels integer DEFAULT 1, offsets integer DEFAULT 0, search text DEFAULT ''::text, sortcolumn text DEFAULT 'name'::text, sortorder text DEFAULT 'asc'::text) RETURNS TABLE(name text, id uuid, updated_at timestamp with time zone, created_at timestamp with time zone, last_accessed_at timestamp with time zone, metadata jsonb)
    LANGUAGE plpgsql STABLE
    AS $_$
declare
    v_order_by text;
    v_sort_order text;
begin
    case
        when sortcolumn = 'name' then
            v_order_by = 'name';
        when sortcolumn = 'updated_at' then
            v_order_by = 'updated_at';
        when sortcolumn = 'created_at' then
            v_order_by = 'created_at';
        when sortcolumn = 'last_accessed_at' then
            v_order_by = 'last_accessed_at';
        else
            v_order_by = 'name';
        end case;

    case
        when sortorder = 'asc' then
            v_sort_order = 'asc';
        when sortorder = 'desc' then
            v_sort_order = 'desc';
        else
            v_sort_order = 'asc';
        end case;

    v_order_by = v_order_by || ' ' || v_sort_order;

    return query execute
        'with folders as (
           select path_tokens[$1] as folder
           from storage.objects
             where objects.name ilike $2 || $3 || ''%''
               and bucket_id = $4
               and array_length(objects.path_tokens, 1) <> $1
           group by folder
           order by folder ' || v_sort_order || '
     )
     (select folder as "name",
            null as id,
            null as updated_at,
            null as created_at,
            null as last_accessed_at,
            null as metadata from folders)
     union all
     (select path_tokens[$1] as "name",
            id,
            updated_at,
            created_at,
            last_accessed_at,
            metadata
     from storage.objects
     where objects.name ilike $2 || $3 || ''%''
       and bucket_id = $4
       and array_length(objects.path_tokens, 1) = $1
     order by ' || v_order_by || ')
     limit $5
     offset $6' using levels, prefix, search, bucketname, limits, offsets;
end;
$_$;


--
-- TOC entry 507 (class 1255 OID 20277)
-- Name: search_v2(text, text, integer, integer, text, text, text, text); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.search_v2(prefix text, bucket_name text, limits integer DEFAULT 100, levels integer DEFAULT 1, start_after text DEFAULT ''::text, sort_order text DEFAULT 'asc'::text, sort_column text DEFAULT 'name'::text, sort_column_after text DEFAULT ''::text) RETURNS TABLE(key text, name text, id uuid, updated_at timestamp with time zone, created_at timestamp with time zone, last_accessed_at timestamp with time zone, metadata jsonb)
    LANGUAGE plpgsql STABLE
    AS $$
DECLARE
    v_sort_col text;
    v_sort_ord text;
    v_limit int;
BEGIN
    -- Cap limit to maximum of 1500 records
    v_limit := LEAST(coalesce(limits, 100), 1500);

    -- Validate and normalize sort_order
    v_sort_ord := lower(coalesce(sort_order, 'asc'));
    IF v_sort_ord NOT IN ('asc', 'desc') THEN
        v_sort_ord := 'asc';
    END IF;

    -- Validate and normalize sort_column
    v_sort_col := lower(coalesce(sort_column, 'name'));
    IF v_sort_col NOT IN ('name', 'updated_at', 'created_at') THEN
        v_sort_col := 'name';
    END IF;

    -- Route to appropriate implementation
    IF v_sort_col = 'name' THEN
        -- Use list_objects_with_delimiter for name sorting (most efficient: O(k * log n))
        RETURN QUERY
        SELECT
            split_part(l.name, '/', levels) AS key,
            l.name AS name,
            l.id,
            l.updated_at,
            l.created_at,
            l.last_accessed_at,
            l.metadata
        FROM storage.list_objects_with_delimiter(
            bucket_name,
            coalesce(prefix, ''),
            '/',
            v_limit,
            start_after,
            '',
            v_sort_ord
        ) l;
    ELSE
        -- Use aggregation approach for timestamp sorting
        -- Not efficient for large datasets but supports correct pagination
        RETURN QUERY SELECT * FROM storage.search_by_timestamp(
            prefix, bucket_name, v_limit, levels, start_after,
            v_sort_ord, v_sort_col, sort_column_after
        );
    END IF;
END;
$$;


--
-- TOC entry 461 (class 1255 OID 17043)
-- Name: update_updated_at_column(); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.update_updated_at_column() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW; 
END;
$$;


--
-- TOC entry 298 (class 1259 OID 16525)
-- Name: audit_log_entries; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.audit_log_entries (
    instance_id uuid,
    id uuid NOT NULL,
    payload json,
    created_at timestamp with time zone,
    ip_address character varying(64) DEFAULT ''::character varying NOT NULL
);


--
-- TOC entry 5200 (class 0 OID 0)
-- Dependencies: 298
-- Name: TABLE audit_log_entries; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.audit_log_entries IS 'Auth: Audit trail for user actions.';


--
-- TOC entry 315 (class 1259 OID 16927)
-- Name: flow_state; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.flow_state (
    id uuid NOT NULL,
    user_id uuid,
    auth_code text,
    code_challenge_method auth.code_challenge_method,
    code_challenge text,
    provider_type text NOT NULL,
    provider_access_token text,
    provider_refresh_token text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    authentication_method text NOT NULL,
    auth_code_issued_at timestamp with time zone,
    invite_token text,
    referrer text,
    oauth_client_state_id uuid,
    linking_target_id uuid,
    email_optional boolean DEFAULT false NOT NULL
);


--
-- TOC entry 5201 (class 0 OID 0)
-- Dependencies: 315
-- Name: TABLE flow_state; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.flow_state IS 'Stores metadata for all OAuth/SSO login flows';


--
-- TOC entry 306 (class 1259 OID 16725)
-- Name: identities; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.identities (
    provider_id text NOT NULL,
    user_id uuid NOT NULL,
    identity_data jsonb NOT NULL,
    provider text NOT NULL,
    last_sign_in_at timestamp with time zone,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    email text GENERATED ALWAYS AS (lower((identity_data ->> 'email'::text))) STORED,
    id uuid DEFAULT gen_random_uuid() NOT NULL
);


--
-- TOC entry 5202 (class 0 OID 0)
-- Dependencies: 306
-- Name: TABLE identities; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.identities IS 'Auth: Stores identities associated to a user.';


--
-- TOC entry 5203 (class 0 OID 0)
-- Dependencies: 306
-- Name: COLUMN identities.email; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON COLUMN auth.identities.email IS 'Auth: Email is a generated column that references the optional email property in the identity_data';


--
-- TOC entry 297 (class 1259 OID 16518)
-- Name: instances; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.instances (
    id uuid NOT NULL,
    uuid uuid,
    raw_base_config text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone
);


--
-- TOC entry 5204 (class 0 OID 0)
-- Dependencies: 297
-- Name: TABLE instances; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.instances IS 'Auth: Manages users across multiple sites.';


--
-- TOC entry 310 (class 1259 OID 16814)
-- Name: mfa_amr_claims; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.mfa_amr_claims (
    session_id uuid NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    authentication_method text NOT NULL,
    id uuid NOT NULL
);


--
-- TOC entry 5205 (class 0 OID 0)
-- Dependencies: 310
-- Name: TABLE mfa_amr_claims; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.mfa_amr_claims IS 'auth: stores authenticator method reference claims for multi factor authentication';


--
-- TOC entry 309 (class 1259 OID 16802)
-- Name: mfa_challenges; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.mfa_challenges (
    id uuid NOT NULL,
    factor_id uuid NOT NULL,
    created_at timestamp with time zone NOT NULL,
    verified_at timestamp with time zone,
    ip_address inet NOT NULL,
    otp_code text,
    web_authn_session_data jsonb
);


--
-- TOC entry 5206 (class 0 OID 0)
-- Dependencies: 309
-- Name: TABLE mfa_challenges; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.mfa_challenges IS 'auth: stores metadata about challenge requests made';


--
-- TOC entry 308 (class 1259 OID 16789)
-- Name: mfa_factors; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.mfa_factors (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    friendly_name text,
    factor_type auth.factor_type NOT NULL,
    status auth.factor_status NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    secret text,
    phone text,
    last_challenged_at timestamp with time zone,
    web_authn_credential jsonb,
    web_authn_aaguid uuid,
    last_webauthn_challenge_data jsonb
);


--
-- TOC entry 5207 (class 0 OID 0)
-- Dependencies: 308
-- Name: TABLE mfa_factors; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.mfa_factors IS 'auth: stores metadata about factors';


--
-- TOC entry 5208 (class 0 OID 0)
-- Dependencies: 308
-- Name: COLUMN mfa_factors.last_webauthn_challenge_data; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON COLUMN auth.mfa_factors.last_webauthn_challenge_data IS 'Stores the latest WebAuthn challenge data including attestation/assertion for customer verification';


--
-- TOC entry 329 (class 1259 OID 32629)
-- Name: oauth_authorizations; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.oauth_authorizations (
    id uuid NOT NULL,
    authorization_id text NOT NULL,
    client_id uuid NOT NULL,
    user_id uuid,
    redirect_uri text NOT NULL,
    scope text NOT NULL,
    state text,
    resource text,
    code_challenge text,
    code_challenge_method auth.code_challenge_method,
    response_type auth.oauth_response_type DEFAULT 'code'::auth.oauth_response_type NOT NULL,
    status auth.oauth_authorization_status DEFAULT 'pending'::auth.oauth_authorization_status NOT NULL,
    authorization_code text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    expires_at timestamp with time zone DEFAULT (now() + '00:03:00'::interval) NOT NULL,
    approved_at timestamp with time zone,
    nonce text,
    CONSTRAINT oauth_authorizations_authorization_code_length CHECK ((char_length(authorization_code) <= 255)),
    CONSTRAINT oauth_authorizations_code_challenge_length CHECK ((char_length(code_challenge) <= 128)),
    CONSTRAINT oauth_authorizations_expires_at_future CHECK ((expires_at > created_at)),
    CONSTRAINT oauth_authorizations_nonce_length CHECK ((char_length(nonce) <= 255)),
    CONSTRAINT oauth_authorizations_redirect_uri_length CHECK ((char_length(redirect_uri) <= 2048)),
    CONSTRAINT oauth_authorizations_resource_length CHECK ((char_length(resource) <= 2048)),
    CONSTRAINT oauth_authorizations_scope_length CHECK ((char_length(scope) <= 4096)),
    CONSTRAINT oauth_authorizations_state_length CHECK ((char_length(state) <= 4096))
);


--
-- TOC entry 334 (class 1259 OID 66768)
-- Name: oauth_client_states; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.oauth_client_states (
    id uuid NOT NULL,
    provider_type text NOT NULL,
    code_verifier text,
    created_at timestamp with time zone NOT NULL
);


--
-- TOC entry 5209 (class 0 OID 0)
-- Dependencies: 334
-- Name: TABLE oauth_client_states; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.oauth_client_states IS 'Stores OAuth states for third-party provider authentication flows where Supabase acts as the OAuth client.';


--
-- TOC entry 317 (class 1259 OID 17009)
-- Name: oauth_clients; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.oauth_clients (
    id uuid NOT NULL,
    client_secret_hash text,
    registration_type auth.oauth_registration_type NOT NULL,
    redirect_uris text NOT NULL,
    grant_types text NOT NULL,
    client_name text,
    client_uri text,
    logo_uri text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    client_type auth.oauth_client_type DEFAULT 'confidential'::auth.oauth_client_type NOT NULL,
    token_endpoint_auth_method text NOT NULL,
    CONSTRAINT oauth_clients_client_name_length CHECK ((char_length(client_name) <= 1024)),
    CONSTRAINT oauth_clients_client_uri_length CHECK ((char_length(client_uri) <= 2048)),
    CONSTRAINT oauth_clients_logo_uri_length CHECK ((char_length(logo_uri) <= 2048)),
    CONSTRAINT oauth_clients_token_endpoint_auth_method_check CHECK ((token_endpoint_auth_method = ANY (ARRAY['client_secret_basic'::text, 'client_secret_post'::text, 'none'::text])))
);


--
-- TOC entry 330 (class 1259 OID 32662)
-- Name: oauth_consents; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.oauth_consents (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    client_id uuid NOT NULL,
    scopes text NOT NULL,
    granted_at timestamp with time zone DEFAULT now() NOT NULL,
    revoked_at timestamp with time zone,
    CONSTRAINT oauth_consents_revoked_after_granted CHECK (((revoked_at IS NULL) OR (revoked_at >= granted_at))),
    CONSTRAINT oauth_consents_scopes_length CHECK ((char_length(scopes) <= 2048)),
    CONSTRAINT oauth_consents_scopes_not_empty CHECK ((char_length(TRIM(BOTH FROM scopes)) > 0))
);


--
-- TOC entry 316 (class 1259 OID 16977)
-- Name: one_time_tokens; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.one_time_tokens (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    token_type auth.one_time_token_type NOT NULL,
    token_hash text NOT NULL,
    relates_to text NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    CONSTRAINT one_time_tokens_token_hash_check CHECK ((char_length(token_hash) > 0))
);


--
-- TOC entry 296 (class 1259 OID 16507)
-- Name: refresh_tokens; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.refresh_tokens (
    instance_id uuid,
    id bigint NOT NULL,
    token character varying(255),
    user_id character varying(255),
    revoked boolean,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    parent character varying(255),
    session_id uuid
);


--
-- TOC entry 5210 (class 0 OID 0)
-- Dependencies: 296
-- Name: TABLE refresh_tokens; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.refresh_tokens IS 'Auth: Store of tokens used to refresh JWT tokens once they expire.';


--
-- TOC entry 295 (class 1259 OID 16506)
-- Name: refresh_tokens_id_seq; Type: SEQUENCE; Schema: auth; Owner: -
--

CREATE SEQUENCE auth.refresh_tokens_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5211 (class 0 OID 0)
-- Dependencies: 295
-- Name: refresh_tokens_id_seq; Type: SEQUENCE OWNED BY; Schema: auth; Owner: -
--

ALTER SEQUENCE auth.refresh_tokens_id_seq OWNED BY auth.refresh_tokens.id;


--
-- TOC entry 313 (class 1259 OID 16856)
-- Name: saml_providers; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.saml_providers (
    id uuid NOT NULL,
    sso_provider_id uuid NOT NULL,
    entity_id text NOT NULL,
    metadata_xml text NOT NULL,
    metadata_url text,
    attribute_mapping jsonb,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    name_id_format text,
    CONSTRAINT "entity_id not empty" CHECK ((char_length(entity_id) > 0)),
    CONSTRAINT "metadata_url not empty" CHECK (((metadata_url = NULL::text) OR (char_length(metadata_url) > 0))),
    CONSTRAINT "metadata_xml not empty" CHECK ((char_length(metadata_xml) > 0))
);


--
-- TOC entry 5212 (class 0 OID 0)
-- Dependencies: 313
-- Name: TABLE saml_providers; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.saml_providers IS 'Auth: Manages SAML Identity Provider connections.';


--
-- TOC entry 314 (class 1259 OID 16874)
-- Name: saml_relay_states; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.saml_relay_states (
    id uuid NOT NULL,
    sso_provider_id uuid NOT NULL,
    request_id text NOT NULL,
    for_email text,
    redirect_to text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    flow_state_id uuid,
    CONSTRAINT "request_id not empty" CHECK ((char_length(request_id) > 0))
);


--
-- TOC entry 5213 (class 0 OID 0)
-- Dependencies: 314
-- Name: TABLE saml_relay_states; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.saml_relay_states IS 'Auth: Contains SAML Relay State information for each Service Provider initiated login.';


--
-- TOC entry 299 (class 1259 OID 16533)
-- Name: schema_migrations; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.schema_migrations (
    version character varying(255) NOT NULL
);


--
-- TOC entry 5214 (class 0 OID 0)
-- Dependencies: 299
-- Name: TABLE schema_migrations; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.schema_migrations IS 'Auth: Manages updates to the auth system.';


--
-- TOC entry 307 (class 1259 OID 16755)
-- Name: sessions; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.sessions (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    factor_id uuid,
    aal auth.aal_level,
    not_after timestamp with time zone,
    refreshed_at timestamp without time zone,
    user_agent text,
    ip inet,
    tag text,
    oauth_client_id uuid,
    refresh_token_hmac_key text,
    refresh_token_counter bigint,
    scopes text,
    CONSTRAINT sessions_scopes_length CHECK ((char_length(scopes) <= 4096))
);


--
-- TOC entry 5215 (class 0 OID 0)
-- Dependencies: 307
-- Name: TABLE sessions; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.sessions IS 'Auth: Stores session data associated to a user.';


--
-- TOC entry 5216 (class 0 OID 0)
-- Dependencies: 307
-- Name: COLUMN sessions.not_after; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON COLUMN auth.sessions.not_after IS 'Auth: Not after is a nullable column that contains a timestamp after which the session should be regarded as expired.';


--
-- TOC entry 5217 (class 0 OID 0)
-- Dependencies: 307
-- Name: COLUMN sessions.refresh_token_hmac_key; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON COLUMN auth.sessions.refresh_token_hmac_key IS 'Holds a HMAC-SHA256 key used to sign refresh tokens for this session.';


--
-- TOC entry 5218 (class 0 OID 0)
-- Dependencies: 307
-- Name: COLUMN sessions.refresh_token_counter; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON COLUMN auth.sessions.refresh_token_counter IS 'Holds the ID (counter) of the last issued refresh token.';


--
-- TOC entry 312 (class 1259 OID 16841)
-- Name: sso_domains; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.sso_domains (
    id uuid NOT NULL,
    sso_provider_id uuid NOT NULL,
    domain text NOT NULL,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    CONSTRAINT "domain not empty" CHECK ((char_length(domain) > 0))
);


--
-- TOC entry 5219 (class 0 OID 0)
-- Dependencies: 312
-- Name: TABLE sso_domains; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.sso_domains IS 'Auth: Manages SSO email address domain mapping to an SSO Identity Provider.';


--
-- TOC entry 311 (class 1259 OID 16832)
-- Name: sso_providers; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.sso_providers (
    id uuid NOT NULL,
    resource_id text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    disabled boolean,
    CONSTRAINT "resource_id not empty" CHECK (((resource_id = NULL::text) OR (char_length(resource_id) > 0)))
);


--
-- TOC entry 5220 (class 0 OID 0)
-- Dependencies: 311
-- Name: TABLE sso_providers; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.sso_providers IS 'Auth: Manages SSO identity provider information; see saml_providers for SAML.';


--
-- TOC entry 5221 (class 0 OID 0)
-- Dependencies: 311
-- Name: COLUMN sso_providers.resource_id; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON COLUMN auth.sso_providers.resource_id IS 'Auth: Uniquely identifies a SSO provider according to a user-chosen resource ID (case insensitive), useful in infrastructure as code.';


--
-- TOC entry 294 (class 1259 OID 16495)
-- Name: users; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.users (
    instance_id uuid,
    id uuid NOT NULL,
    aud character varying(255),
    role character varying(255),
    email character varying(255),
    encrypted_password character varying(255),
    email_confirmed_at timestamp with time zone,
    invited_at timestamp with time zone,
    confirmation_token character varying(255),
    confirmation_sent_at timestamp with time zone,
    recovery_token character varying(255),
    recovery_sent_at timestamp with time zone,
    email_change_token_new character varying(255),
    email_change character varying(255),
    email_change_sent_at timestamp with time zone,
    last_sign_in_at timestamp with time zone,
    raw_app_meta_data jsonb,
    raw_user_meta_data jsonb,
    is_super_admin boolean,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    phone text DEFAULT NULL::character varying,
    phone_confirmed_at timestamp with time zone,
    phone_change text DEFAULT ''::character varying,
    phone_change_token character varying(255) DEFAULT ''::character varying,
    phone_change_sent_at timestamp with time zone,
    confirmed_at timestamp with time zone GENERATED ALWAYS AS (LEAST(email_confirmed_at, phone_confirmed_at)) STORED,
    email_change_token_current character varying(255) DEFAULT ''::character varying,
    email_change_confirm_status smallint DEFAULT 0,
    banned_until timestamp with time zone,
    reauthentication_token character varying(255) DEFAULT ''::character varying,
    reauthentication_sent_at timestamp with time zone,
    is_sso_user boolean DEFAULT false NOT NULL,
    deleted_at timestamp with time zone,
    is_anonymous boolean DEFAULT false NOT NULL,
    CONSTRAINT users_email_change_confirm_status_check CHECK (((email_change_confirm_status >= 0) AND (email_change_confirm_status <= 2)))
);


--
-- TOC entry 5222 (class 0 OID 0)
-- Dependencies: 294
-- Name: TABLE users; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.users IS 'Auth: Stores user login data within a secure schema.';


--
-- TOC entry 5223 (class 0 OID 0)
-- Dependencies: 294
-- Name: COLUMN users.is_sso_user; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON COLUMN auth.users.is_sso_user IS 'Auth: Set this column to true when the account comes from SSO. These accounts can have duplicate emails.';


--
-- TOC entry 368 (class 1259 OID 116080)
-- Name: ad_clicks; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ad_clicks (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    impression_id uuid,
    campaign_id uuid NOT NULL,
    creative_id uuid NOT NULL,
    session_id uuid NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- TOC entry 5224 (class 0 OID 0)
-- Dependencies: 368
-- Name: TABLE ad_clicks; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.ad_clicks IS 'Tracks ad clicks for CTR calculation';


--
-- TOC entry 5225 (class 0 OID 0)
-- Dependencies: 368
-- Name: COLUMN ad_clicks.impression_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.ad_clicks.impression_id IS 'Links click to specific impression (may be null if impression not tracked)';


--
-- TOC entry 367 (class 1259 OID 116046)
-- Name: ad_impressions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ad_impressions (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    site_id uuid NOT NULL,
    campaign_id uuid NOT NULL,
    creative_id uuid NOT NULL,
    slot_id uuid NOT NULL,
    session_id uuid NOT NULL,
    page_path text NOT NULL,
    viewport_visible boolean DEFAULT false NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- TOC entry 5226 (class 0 OID 0)
-- Dependencies: 367
-- Name: TABLE ad_impressions; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.ad_impressions IS 'Tracks ad impressions for performance analytics';


--
-- TOC entry 5227 (class 0 OID 0)
-- Dependencies: 367
-- Name: COLUMN ad_impressions.viewport_visible; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.ad_impressions.viewport_visible IS 'True if ad was visible in viewport (Intersection Observer)';


--
-- TOC entry 355 (class 1259 OID 109121)
-- Name: ads_advertisers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ads_advertisers (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    site_id uuid NOT NULL,
    name text NOT NULL,
    contact_name text,
    contact_email text,
    contact_phone text,
    status public.ads_advertiser_status DEFAULT 'active'::public.ads_advertiser_status NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT ads_advertisers_email_chk CHECK (((contact_email IS NULL) OR (POSITION(('@'::text) IN (contact_email)) > 1)))
);


--
-- TOC entry 5228 (class 0 OID 0)
-- Dependencies: 355
-- Name: TABLE ads_advertisers; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.ads_advertisers IS 'Advertisers per site for ADS Connect module';


--
-- TOC entry 5229 (class 0 OID 0)
-- Dependencies: 355
-- Name: COLUMN ads_advertisers.site_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.ads_advertisers.site_id IS 'Multi-tenant isolation';


--
-- TOC entry 5230 (class 0 OID 0)
-- Dependencies: 355
-- Name: COLUMN ads_advertisers.status; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.ads_advertisers.status IS 'Active advertisers can create campaigns';


--
-- TOC entry 357 (class 1259 OID 109159)
-- Name: ads_campaigns; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ads_campaigns (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    site_id uuid NOT NULL,
    advertiser_id uuid NOT NULL,
    slot_id uuid NOT NULL,
    starts_at timestamp with time zone NOT NULL,
    ends_at timestamp with time zone NOT NULL,
    status public.ads_campaign_status DEFAULT 'draft'::public.ads_campaign_status NOT NULL,
    price_cents integer NOT NULL,
    currency text DEFAULT 'BRL'::text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT ads_campaigns_currency_chk CHECK ((currency ~ '^[A-Z]{3}$'::text)),
    CONSTRAINT ads_campaigns_dates_chk CHECK ((ends_at > starts_at)),
    CONSTRAINT ads_campaigns_price_chk CHECK ((price_cents >= 0))
);


--
-- TOC entry 5231 (class 0 OID 0)
-- Dependencies: 357
-- Name: TABLE ads_campaigns; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.ads_campaigns IS 'Advertising campaigns with time-based exclusivity';


--
-- TOC entry 5232 (class 0 OID 0)
-- Dependencies: 357
-- Name: COLUMN ads_campaigns.starts_at; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.ads_campaigns.starts_at IS 'Campaign start timestamp (inclusive)';


--
-- TOC entry 5233 (class 0 OID 0)
-- Dependencies: 357
-- Name: COLUMN ads_campaigns.ends_at; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.ads_campaigns.ends_at IS 'Campaign end timestamp (exclusive)';


--
-- TOC entry 5234 (class 0 OID 0)
-- Dependencies: 357
-- Name: COLUMN ads_campaigns.status; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.ads_campaigns.status IS 'Only active campaigns enforce exclusivity';


--
-- TOC entry 5235 (class 0 OID 0)
-- Dependencies: 357
-- Name: COLUMN ads_campaigns.price_cents; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.ads_campaigns.price_cents IS 'Price in cents to avoid floating point issues';


--
-- TOC entry 356 (class 1259 OID 109140)
-- Name: ads_slots; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ads_slots (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    site_id uuid NOT NULL,
    key text NOT NULL,
    placement text NOT NULL,
    size_hint text,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT ads_slots_key_format_chk CHECK ((key ~ '^[a-z][a-z0-9_]*$'::text))
);


--
-- TOC entry 5236 (class 0 OID 0)
-- Dependencies: 356
-- Name: TABLE ads_slots; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.ads_slots IS 'Available advertising slots per site';


--
-- TOC entry 5237 (class 0 OID 0)
-- Dependencies: 356
-- Name: COLUMN ads_slots.key; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.ads_slots.key IS 'Technical slug (e.g., home_hero, places_list_top)';


--
-- TOC entry 5238 (class 0 OID 0)
-- Dependencies: 356
-- Name: COLUMN ads_slots.placement; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.ads_slots.placement IS 'Human-readable description';


--
-- TOC entry 5239 (class 0 OID 0)
-- Dependencies: 356
-- Name: COLUMN ads_slots.size_hint; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.ads_slots.size_hint IS 'Recommended dimensions (e.g., 1200x600)';


--
-- TOC entry 370 (class 1259 OID 116110)
-- Name: ad_campaign_performance; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.ad_campaign_performance AS
 SELECT c.id AS campaign_id,
    c.site_id,
    c.advertiser_id,
    c.slot_id,
    c.status AS campaign_status,
    a.name AS advertiser_name,
    s.placement AS slot_name,
    s.key AS slot_key,
    count(DISTINCT i.id) AS impressions,
    count(DISTINCT
        CASE
            WHEN i.viewport_visible THEN i.id
            ELSE NULL::uuid
        END) AS visible_impressions,
    count(DISTINCT cl.id) AS clicks,
    round((((count(DISTINCT cl.id))::numeric / (NULLIF(count(DISTINCT i.id), 0))::numeric) * (100)::numeric), 2) AS ctr_percent,
    count(DISTINCT i.session_id) AS unique_viewers,
    c.price_cents,
    c.currency,
    c.starts_at,
    c.ends_at
   FROM ((((public.ads_campaigns c
     LEFT JOIN public.ads_advertisers a ON ((c.advertiser_id = a.id)))
     LEFT JOIN public.ads_slots s ON ((c.slot_id = s.id)))
     LEFT JOIN public.ad_impressions i ON (((c.id = i.campaign_id) AND (i.created_at >= c.starts_at) AND (i.created_at < c.ends_at))))
     LEFT JOIN public.ad_clicks cl ON (((c.id = cl.campaign_id) AND (cl.created_at >= c.starts_at) AND (cl.created_at < c.ends_at))))
  GROUP BY c.id, c.site_id, c.advertiser_id, c.slot_id, c.status, a.name, s.placement, s.key, c.price_cents, c.currency, c.starts_at, c.ends_at;


--
-- TOC entry 5240 (class 0 OID 0)
-- Dependencies: 370
-- Name: VIEW ad_campaign_performance; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON VIEW public.ad_campaign_performance IS 'Aggregated ad campaign performance metrics with CTR calculation';


--
-- TOC entry 358 (class 1259 OID 109189)
-- Name: ads_creatives; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ads_creatives (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    campaign_id uuid NOT NULL,
    media_id uuid,
    title text NOT NULL,
    cta_text text,
    target_url text NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT ads_creatives_url_chk CHECK (((target_url IS NULL) OR (target_url = ''::text) OR (target_url ~ '^https?://'::text) OR (target_url ~ '^/'::text) OR (target_url ~ '^mailto:'::text) OR (target_url ~ '^tel:'::text) OR (target_url ~ '^#'::text)))
);


--
-- TOC entry 5241 (class 0 OID 0)
-- Dependencies: 358
-- Name: TABLE ads_creatives; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.ads_creatives IS 'Creative assets for campaigns (supports A/B testing)';


--
-- TOC entry 5242 (class 0 OID 0)
-- Dependencies: 358
-- Name: COLUMN ads_creatives.media_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.ads_creatives.media_id IS 'References existing media table for asset management';


--
-- TOC entry 5243 (class 0 OID 0)
-- Dependencies: 358
-- Name: COLUMN ads_creatives.target_url; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.ads_creatives.target_url IS 'Click-through URL (absolute or relative)';


--
-- TOC entry 5244 (class 0 OID 0)
-- Dependencies: 358
-- Name: COLUMN ads_creatives.is_active; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.ads_creatives.is_active IS 'Allows multiple creatives per campaign for rotation';


--
-- TOC entry 352 (class 1259 OID 106734)
-- Name: api_keys; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.api_keys (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name text NOT NULL,
    site_id uuid,
    scopes text[] DEFAULT ARRAY[]::text[] NOT NULL,
    key_hash text NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    created_by uuid,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    last_used_at timestamp with time zone,
    expires_at timestamp with time zone
);


--
-- TOC entry 351 (class 1259 OID 106708)
-- Name: audit_logs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.audit_logs (
    id bigint NOT NULL,
    occurred_at timestamp with time zone DEFAULT now() NOT NULL,
    category public.audit_category NOT NULL,
    severity public.audit_severity DEFAULT 'info'::public.audit_severity NOT NULL,
    result public.audit_result DEFAULT 'success'::public.audit_result NOT NULL,
    actor_user_id uuid,
    site_id uuid,
    action text NOT NULL,
    entity_type text,
    entity_id uuid,
    ip inet,
    user_agent text,
    metadata jsonb DEFAULT '{}'::jsonb NOT NULL
);


--
-- TOC entry 350 (class 1259 OID 106707)
-- Name: audit_logs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.audit_logs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5245 (class 0 OID 0)
-- Dependencies: 350
-- Name: audit_logs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.audit_logs_id_seq OWNED BY public.audit_logs.id;


--
-- TOC entry 362 (class 1259 OID 112465)
-- Name: event_categories; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.event_categories (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    site_id uuid NOT NULL,
    name text NOT NULL,
    color text DEFAULT '#3B82F6'::text,
    sort_order integer DEFAULT 0,
    is_active boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


--
-- TOC entry 344 (class 1259 OID 106533)
-- Name: events; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.events (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    site_id uuid NOT NULL,
    status public.event_status DEFAULT 'draft'::public.event_status NOT NULL,
    slug text NOT NULL,
    title_i18n jsonb NOT NULL,
    summary_i18n jsonb,
    body_i18n jsonb,
    start_at timestamp with time zone NOT NULL,
    end_at timestamp with time zone,
    all_day boolean DEFAULT false NOT NULL,
    location_name text,
    address_line text,
    city text,
    state text,
    lat numeric(9,6),
    lng numeric(9,6),
    primary_media_id uuid,
    source_name text,
    source_url text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    organizer_name text,
    category_id uuid,
    country text,
    postal_code text,
    meta jsonb DEFAULT '{}'::jsonb NOT NULL,
    cover_url text,
    CONSTRAINT events_title_pt CHECK (public.i18n_has_pt(title_i18n))
);


--
-- TOC entry 5246 (class 0 OID 0)
-- Dependencies: 344
-- Name: COLUMN events.cover_url; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.events.cover_url IS 'URL da imagem de capa (hero section) do evento';


--
-- TOC entry 363 (class 1259 OID 114742)
-- Name: hero_banners; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.hero_banners (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    site_id uuid NOT NULL,
    title_i18n jsonb NOT NULL,
    subtitle_i18n jsonb,
    cta_label_i18n jsonb,
    cta_url text,
    target_view text,
    kind text DEFAULT 'editorial'::text NOT NULL,
    primary_media_id uuid,
    sort_order integer DEFAULT 0 NOT NULL,
    starts_at timestamp with time zone,
    ends_at timestamp with time zone,
    is_active boolean DEFAULT true NOT NULL,
    meta jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT hero_banners_kind_check CHECK ((kind = ANY (ARRAY['editorial'::text, 'ads'::text])))
);


--
-- TOC entry 364 (class 1259 OID 115927)
-- Name: import_batches; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.import_batches (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    source text NOT NULL,
    category text NOT NULL,
    total_items integer DEFAULT 0,
    items_staged integer DEFAULT 0,
    items_approved integer DEFAULT 0,
    items_rejected integer DEFAULT 0,
    quality_score_avg numeric(3,1),
    imported_by uuid,
    notes text,
    created_at timestamp with time zone DEFAULT now(),
    completed_at timestamp with time zone
);


--
-- TOC entry 342 (class 1259 OID 106435)
-- Name: media; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.media (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    site_id uuid NOT NULL,
    kind public.media_kind DEFAULT 'image'::public.media_kind NOT NULL,
    storage_path text NOT NULL,
    public_url text,
    alt_i18n jsonb,
    caption_i18n jsonb,
    owner_type public.media_owner DEFAULT 'site'::public.media_owner NOT NULL,
    owner_id uuid,
    sort_order integer DEFAULT 0 NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- TOC entry 366 (class 1259 OID 116024)
-- Name: page_views; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.page_views (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    site_id uuid NOT NULL,
    page_path text NOT NULL,
    referrer text,
    user_agent text,
    session_id uuid NOT NULL,
    user_id uuid,
    ip_hash text,
    country_code text,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- TOC entry 5247 (class 0 OID 0)
-- Dependencies: 366
-- Name: TABLE page_views; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.page_views IS 'Tracks page views for portal traffic analytics';


--
-- TOC entry 5248 (class 0 OID 0)
-- Dependencies: 366
-- Name: COLUMN page_views.session_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.page_views.session_id IS 'Browser session identifier (generated client-side)';


--
-- TOC entry 5249 (class 0 OID 0)
-- Dependencies: 366
-- Name: COLUMN page_views.ip_hash; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.page_views.ip_hash IS 'Hashed IP address for privacy compliance (LGPD)';


--
-- TOC entry 338 (class 1259 OID 106296)
-- Name: place_categories; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.place_categories (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    site_id uuid NOT NULL,
    kind public.place_kind NOT NULL,
    slug text NOT NULL,
    name_i18n jsonb NOT NULL,
    sort_order integer DEFAULT 0 NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    name text NOT NULL,
    color text DEFAULT '#3B82F6'::text,
    parent_id uuid,
    category_type text,
    description text,
    icon text,
    CONSTRAINT category_name_pt CHECK (public.i18n_has_pt(name_i18n)),
    CONSTRAINT place_categories_category_type_check CHECK ((category_type = ANY (ARRAY['onde_ir'::text, 'onde_ficar'::text, 'onde_comer'::text, 'o_que_fazer'::text, 'guia_medico'::text])))
);


--
-- TOC entry 365 (class 1259 OID 115992)
-- Name: place_images; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.place_images (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    place_id uuid NOT NULL,
    url text NOT NULL,
    caption text,
    sort_order integer DEFAULT 0,
    is_primary boolean DEFAULT false,
    created_at timestamp with time zone DEFAULT now()
);


--
-- TOC entry 340 (class 1259 OID 106339)
-- Name: place_media; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.place_media (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    place_id uuid NOT NULL,
    kind text DEFAULT 'image'::text NOT NULL,
    url text NOT NULL,
    alt_i18n jsonb,
    sort_order integer DEFAULT 0 NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT place_media_kind_chk CHECK ((kind = ANY (ARRAY['image'::text, 'video'::text, 'document'::text, 'other'::text])))
);


--
-- TOC entry 339 (class 1259 OID 106315)
-- Name: places; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.places (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    site_id uuid NOT NULL,
    kind public.place_kind NOT NULL,
    status public.place_status DEFAULT 'draft'::public.place_status NOT NULL,
    slug text NOT NULL,
    name_i18n jsonb NOT NULL,
    short_i18n jsonb,
    description_i18n jsonb,
    category_id uuid,
    phone text,
    whatsapp text,
    email text,
    website text,
    address_line text,
    city text,
    state text,
    postal_code text,
    lat numeric(9,6),
    lng numeric(9,6),
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    country text,
    video_url text,
    secondary_category_id uuid,
    sort_order integer DEFAULT 0 NOT NULL,
    meta jsonb DEFAULT '{}'::jsonb NOT NULL,
    category_type text,
    subcategory_id uuid,
    attributes jsonb DEFAULT '{}'::jsonb,
    is_featured boolean DEFAULT false,
    meta_title text,
    meta_description text,
    curation_status text DEFAULT 'pending'::text,
    curated_by uuid,
    curated_at timestamp with time zone,
    data_source text,
    data_verified_at timestamp with time zone,
    import_batch_id uuid,
    tags text[] DEFAULT '{}'::text[],
    CONSTRAINT place_name_pt CHECK (public.i18n_has_pt(name_i18n)),
    CONSTRAINT places_category_type_check CHECK ((category_type = ANY (ARRAY['onde_ir'::text, 'onde_ficar'::text, 'onde_comer'::text, 'o_que_fazer'::text, 'guia_medico'::text]))),
    CONSTRAINT places_curation_status_check CHECK ((curation_status = ANY (ARRAY['pending'::text, 'in_review'::text, 'approved'::text, 'rejected'::text])))
);


--
-- TOC entry 359 (class 1259 OID 109927)
-- Name: platform_roles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.platform_roles (
    user_id uuid NOT NULL,
    role public.platform_role NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- TOC entry 369 (class 1259 OID 116105)
-- Name: portal_kpis_summary; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.portal_kpis_summary AS
 SELECT site_id,
    count(*) AS total_views,
    count(DISTINCT session_id) AS unique_visitors,
    count(DISTINCT date(created_at)) AS days_active,
    round(((count(*))::numeric / (NULLIF(count(DISTINCT session_id), 0))::numeric), 2) AS pages_per_session,
    min(created_at) AS first_view,
    max(created_at) AS last_view
   FROM public.page_views
  WHERE (created_at >= (now() - '30 days'::interval))
  GROUP BY site_id;


--
-- TOC entry 5250 (class 0 OID 0)
-- Dependencies: 369
-- Name: VIEW portal_kpis_summary; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON VIEW public.portal_kpis_summary IS 'Aggregated portal traffic metrics for last 30 days';


--
-- TOC entry 345 (class 1259 OID 106561)
-- Name: post_categories; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.post_categories (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    site_id uuid NOT NULL,
    slug text NOT NULL,
    name_i18n jsonb NOT NULL,
    sort_order integer DEFAULT 0 NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT post_cat_pt CHECK (public.i18n_has_pt(name_i18n))
);


--
-- TOC entry 347 (class 1259 OID 106606)
-- Name: post_tag_links; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.post_tag_links (
    post_id uuid NOT NULL,
    tag_id uuid NOT NULL
);


--
-- TOC entry 346 (class 1259 OID 106584)
-- Name: post_tags; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.post_tags (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    site_id uuid NOT NULL,
    slug text NOT NULL,
    name_i18n jsonb NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT post_tag_pt CHECK (public.i18n_has_pt(name_i18n))
);


--
-- TOC entry 341 (class 1259 OID 106355)
-- Name: posts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.posts (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    site_id uuid NOT NULL,
    slug text NOT NULL,
    title_i18n jsonb NOT NULL,
    excerpt_i18n jsonb,
    content_i18n jsonb,
    cover_url text,
    status public.place_status DEFAULT 'draft'::public.place_status NOT NULL,
    published_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    kind public.post_kind DEFAULT 'blog'::public.post_kind NOT NULL,
    author_name text,
    meta jsonb DEFAULT '{}'::jsonb NOT NULL,
    CONSTRAINT post_title_pt CHECK (public.i18n_has_pt(title_i18n))
);


--
-- TOC entry 336 (class 1259 OID 106266)
-- Name: profiles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.profiles (
    user_id uuid NOT NULL,
    display_name text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- TOC entry 343 (class 1259 OID 106471)
-- Name: site_content; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.site_content (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    site_id uuid NOT NULL,
    slot public.content_slot NOT NULL,
    title_i18n jsonb,
    subtitle_i18n jsonb,
    body_i18n jsonb,
    primary_media_id uuid,
    cta_label_i18n jsonb,
    cta_url text,
    payload jsonb,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- TOC entry 337 (class 1259 OID 106279)
-- Name: site_members; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.site_members (
    site_id uuid NOT NULL,
    user_id uuid NOT NULL,
    role public.member_role DEFAULT 'viewer'::public.member_role NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- TOC entry 361 (class 1259 OID 111339)
-- Name: site_members_with_users; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.site_members_with_users AS
 SELECT sm.site_id,
    sm.user_id,
    sm.role,
    sm.created_at,
    u.email AS user_email,
    u.raw_user_meta_data AS user_metadata
   FROM (public.site_members sm
     LEFT JOIN auth.users u ON ((u.id = sm.user_id)));


--
-- TOC entry 5251 (class 0 OID 0)
-- Dependencies: 361
-- Name: VIEW site_members_with_users; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON VIEW public.site_members_with_users IS 'View que expõe site_members com dados do usuário da tabela auth.users';


--
-- TOC entry 335 (class 1259 OID 106254)
-- Name: sites; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sites (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    slug text NOT NULL,
    name_i18n jsonb NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    default_locale text DEFAULT 'pt'::text NOT NULL,
    supported_locales text[] DEFAULT ARRAY['pt'::text, 'en'::text, 'es'::text] NOT NULL,
    primary_domain text,
    meta jsonb DEFAULT '{}'::jsonb NOT NULL,
    status public.site_status DEFAULT 'draft'::public.site_status NOT NULL,
    CONSTRAINT sites_name_pt CHECK (public.i18n_has_pt(name_i18n))
);


--
-- TOC entry 349 (class 1259 OID 106691)
-- Name: user_invitation_sites; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.user_invitation_sites (
    invitation_id uuid NOT NULL,
    site_id uuid NOT NULL,
    portal_role public.member_role DEFAULT 'viewer'::public.member_role NOT NULL
);


--
-- TOC entry 348 (class 1259 OID 106670)
-- Name: user_invitations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.user_invitations (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    email text NOT NULL,
    invited_by uuid NOT NULL,
    status public.invitation_status DEFAULT 'pending'::public.invitation_status NOT NULL,
    role public.member_role DEFAULT 'viewer'::public.member_role NOT NULL,
    token_hash text NOT NULL,
    expires_at timestamp with time zone DEFAULT (now() + '7 days'::interval) NOT NULL,
    accepted_at timestamp with time zone,
    revoked_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    metadata jsonb DEFAULT '{}'::jsonb NOT NULL,
    CONSTRAINT user_invitations_email_format_chk CHECK (((email ~~ '%@%'::text) AND (POSITION(('@'::text) IN (email)) > 1)))
);


--
-- TOC entry 354 (class 1259 OID 106781)
-- Name: webhook_deliveries; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.webhook_deliveries (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    webhook_id uuid NOT NULL,
    site_id uuid,
    event_type text NOT NULL,
    attempt integer DEFAULT 1 NOT NULL,
    status text DEFAULT 'pending'::text NOT NULL,
    response_code integer,
    latency_ms integer,
    error text,
    request_body jsonb,
    response_body text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    delivered_at timestamp with time zone,
    idempotency_key text,
    next_attempt_at timestamp with time zone,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT webhook_deliveries_status_chk CHECK ((status = ANY (ARRAY['pending'::text, 'success'::text, 'failed'::text, 'retrying'::text, 'disabled'::text])))
);


--
-- TOC entry 353 (class 1259 OID 106757)
-- Name: webhooks; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.webhooks (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name text NOT NULL,
    site_id uuid,
    event_type text NOT NULL,
    target_url text NOT NULL,
    secret text,
    is_active boolean DEFAULT true NOT NULL,
    retry_policy jsonb DEFAULT '{"backoff": "exponential", "max_attempts": 5}'::jsonb NOT NULL,
    timeout_ms integer DEFAULT 8000 NOT NULL,
    created_by uuid,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- TOC entry 326 (class 1259 OID 17275)
-- Name: messages; Type: TABLE; Schema: realtime; Owner: -
--

CREATE TABLE realtime.messages (
    topic text NOT NULL,
    extension text NOT NULL,
    payload jsonb,
    event text,
    private boolean DEFAULT false,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    inserted_at timestamp without time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL
)
PARTITION BY RANGE (inserted_at);


--
-- TOC entry 320 (class 1259 OID 17109)
-- Name: schema_migrations; Type: TABLE; Schema: realtime; Owner: -
--

CREATE TABLE realtime.schema_migrations (
    version bigint NOT NULL,
    inserted_at timestamp(0) without time zone
);


--
-- TOC entry 323 (class 1259 OID 17131)
-- Name: subscription; Type: TABLE; Schema: realtime; Owner: -
--

CREATE TABLE realtime.subscription (
    id bigint NOT NULL,
    subscription_id uuid NOT NULL,
    entity regclass NOT NULL,
    filters realtime.user_defined_filter[] DEFAULT '{}'::realtime.user_defined_filter[] NOT NULL,
    claims jsonb NOT NULL,
    claims_role regrole GENERATED ALWAYS AS (realtime.to_regrole((claims ->> 'role'::text))) STORED NOT NULL,
    created_at timestamp without time zone DEFAULT timezone('utc'::text, now()) NOT NULL,
    action_filter text DEFAULT '*'::text,
    CONSTRAINT subscription_action_filter_check CHECK ((action_filter = ANY (ARRAY['*'::text, 'INSERT'::text, 'UPDATE'::text, 'DELETE'::text])))
);


--
-- TOC entry 322 (class 1259 OID 17130)
-- Name: subscription_id_seq; Type: SEQUENCE; Schema: realtime; Owner: -
--

ALTER TABLE realtime.subscription ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME realtime.subscription_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 300 (class 1259 OID 16546)
-- Name: buckets; Type: TABLE; Schema: storage; Owner: -
--

CREATE TABLE storage.buckets (
    id text NOT NULL,
    name text NOT NULL,
    owner uuid,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    public boolean DEFAULT false,
    avif_autodetection boolean DEFAULT false,
    file_size_limit bigint,
    allowed_mime_types text[],
    owner_id text,
    type storage.buckettype DEFAULT 'STANDARD'::storage.buckettype NOT NULL
);


--
-- TOC entry 5252 (class 0 OID 0)
-- Dependencies: 300
-- Name: COLUMN buckets.owner; Type: COMMENT; Schema: storage; Owner: -
--

COMMENT ON COLUMN storage.buckets.owner IS 'Field is deprecated, use owner_id instead';


--
-- TOC entry 328 (class 1259 OID 20266)
-- Name: buckets_analytics; Type: TABLE; Schema: storage; Owner: -
--

CREATE TABLE storage.buckets_analytics (
    name text NOT NULL,
    type storage.buckettype DEFAULT 'ANALYTICS'::storage.buckettype NOT NULL,
    format text DEFAULT 'ICEBERG'::text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    deleted_at timestamp with time zone
);


--
-- TOC entry 331 (class 1259 OID 52049)
-- Name: buckets_vectors; Type: TABLE; Schema: storage; Owner: -
--

CREATE TABLE storage.buckets_vectors (
    id text NOT NULL,
    type storage.buckettype DEFAULT 'VECTOR'::storage.buckettype NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- TOC entry 302 (class 1259 OID 16588)
-- Name: migrations; Type: TABLE; Schema: storage; Owner: -
--

CREATE TABLE storage.migrations (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    hash character varying(40) NOT NULL,
    executed_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- TOC entry 301 (class 1259 OID 16561)
-- Name: objects; Type: TABLE; Schema: storage; Owner: -
--

CREATE TABLE storage.objects (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    bucket_id text,
    name text,
    owner uuid,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    last_accessed_at timestamp with time zone DEFAULT now(),
    metadata jsonb,
    path_tokens text[] GENERATED ALWAYS AS (string_to_array(name, '/'::text)) STORED,
    version text,
    owner_id text,
    user_metadata jsonb
);


--
-- TOC entry 5253 (class 0 OID 0)
-- Dependencies: 301
-- Name: COLUMN objects.owner; Type: COMMENT; Schema: storage; Owner: -
--

COMMENT ON COLUMN storage.objects.owner IS 'Field is deprecated, use owner_id instead';


--
-- TOC entry 318 (class 1259 OID 17057)
-- Name: s3_multipart_uploads; Type: TABLE; Schema: storage; Owner: -
--

CREATE TABLE storage.s3_multipart_uploads (
    id text NOT NULL,
    in_progress_size bigint DEFAULT 0 NOT NULL,
    upload_signature text NOT NULL,
    bucket_id text NOT NULL,
    key text NOT NULL COLLATE pg_catalog."C",
    version text NOT NULL,
    owner_id text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    user_metadata jsonb
);


--
-- TOC entry 319 (class 1259 OID 17071)
-- Name: s3_multipart_uploads_parts; Type: TABLE; Schema: storage; Owner: -
--

CREATE TABLE storage.s3_multipart_uploads_parts (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    upload_id text NOT NULL,
    size bigint DEFAULT 0 NOT NULL,
    part_number integer NOT NULL,
    bucket_id text NOT NULL,
    key text NOT NULL COLLATE pg_catalog."C",
    etag text NOT NULL,
    owner_id text,
    version text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- TOC entry 332 (class 1259 OID 52059)
-- Name: vector_indexes; Type: TABLE; Schema: storage; Owner: -
--

CREATE TABLE storage.vector_indexes (
    id text DEFAULT gen_random_uuid() NOT NULL,
    name text NOT NULL COLLATE pg_catalog."C",
    bucket_id text NOT NULL,
    data_type text NOT NULL,
    dimension integer NOT NULL,
    distance_metric text NOT NULL,
    metadata_configuration jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- TOC entry 327 (class 1259 OID 17293)
-- Name: schema_migrations; Type: TABLE; Schema: supabase_migrations; Owner: -
--

CREATE TABLE supabase_migrations.schema_migrations (
    version text NOT NULL,
    statements text[],
    name text,
    created_by text,
    idempotency_key text,
    rollback text[]
);


--
-- TOC entry 333 (class 1259 OID 61240)
-- Name: seed_files; Type: TABLE; Schema: supabase_migrations; Owner: -
--

CREATE TABLE supabase_migrations.seed_files (
    path text NOT NULL,
    hash text NOT NULL
);


--
-- TOC entry 4099 (class 2604 OID 16510)
-- Name: refresh_tokens id; Type: DEFAULT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.refresh_tokens ALTER COLUMN id SET DEFAULT nextval('auth.refresh_tokens_id_seq'::regclass);


--
-- TOC entry 4228 (class 2604 OID 106711)
-- Name: audit_logs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.audit_logs ALTER COLUMN id SET DEFAULT nextval('public.audit_logs_id_seq'::regclass);


--
-- TOC entry 5117 (class 0 OID 16525)
-- Dependencies: 298
-- Data for Name: audit_log_entries; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.audit_log_entries (instance_id, id, payload, created_at, ip_address) FROM stdin;
00000000-0000-0000-0000-000000000000	7f000753-3378-424c-920b-f371f21131a8	{"action":"user_confirmation_requested","actor_id":"560ba75b-2f81-4485-9f66-5890747d1e97","actor_username":"jafesantana@gmail.com","actor_via_sso":false,"log_type":"user","traits":{"provider":"email"}}	2025-10-01 03:21:45.605501+00	
00000000-0000-0000-0000-000000000000	b2477d44-0530-44f4-a0c8-533030a4aa5a	{"action":"user_signedup","actor_id":"560ba75b-2f81-4485-9f66-5890747d1e97","actor_username":"jafesantana@gmail.com","actor_via_sso":false,"log_type":"team","traits":{"provider":"email"}}	2025-10-01 03:22:51.146684+00	
00000000-0000-0000-0000-000000000000	cef8cf8a-f271-46e6-9071-3a474a902392	{"action":"login","actor_id":"560ba75b-2f81-4485-9f66-5890747d1e97","actor_username":"jafesantana@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-10-01 03:23:12.8642+00	
00000000-0000-0000-0000-000000000000	71cc2055-cdfb-4bc6-98fb-9213154bf4e6	{"action":"login","actor_id":"560ba75b-2f81-4485-9f66-5890747d1e97","actor_username":"jafesantana@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-10-01 03:23:31.916535+00	
00000000-0000-0000-0000-000000000000	88d4e24d-ee91-4e1f-83a2-324ec2c95d0e	{"action":"login","actor_id":"560ba75b-2f81-4485-9f66-5890747d1e97","actor_username":"jafesantana@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-10-01 03:25:39.100716+00	
00000000-0000-0000-0000-000000000000	5f1415ff-83ac-4884-ac38-b3575d98ef64	{"action":"token_refreshed","actor_id":"560ba75b-2f81-4485-9f66-5890747d1e97","actor_username":"jafesantana@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-10-01 04:22:01.46242+00	
00000000-0000-0000-0000-000000000000	74d0954f-aac2-48c6-81af-2ae3c391204e	{"action":"token_revoked","actor_id":"560ba75b-2f81-4485-9f66-5890747d1e97","actor_username":"jafesantana@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-10-01 04:22:01.470137+00	
00000000-0000-0000-0000-000000000000	08dc4368-febb-4950-90fa-c1d16b552ebb	{"action":"token_refreshed","actor_id":"560ba75b-2f81-4485-9f66-5890747d1e97","actor_username":"jafesantana@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-10-01 04:24:38.359916+00	
00000000-0000-0000-0000-000000000000	0a5bf5ef-d887-4c78-888f-1e0339c0f8e7	{"action":"token_revoked","actor_id":"560ba75b-2f81-4485-9f66-5890747d1e97","actor_username":"jafesantana@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-10-01 04:24:38.362757+00	
00000000-0000-0000-0000-000000000000	65174633-e1b7-47f9-b23c-2c58b2edcfcf	{"action":"token_refreshed","actor_id":"560ba75b-2f81-4485-9f66-5890747d1e97","actor_username":"jafesantana@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-10-01 05:44:19.564883+00	
00000000-0000-0000-0000-000000000000	6b85fcd6-080b-4567-9fe7-3c651df8045a	{"action":"token_revoked","actor_id":"560ba75b-2f81-4485-9f66-5890747d1e97","actor_username":"jafesantana@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-10-01 05:44:19.588923+00	
00000000-0000-0000-0000-000000000000	61355911-2c0b-4bcf-aa6b-641839e83209	{"action":"token_refreshed","actor_id":"560ba75b-2f81-4485-9f66-5890747d1e97","actor_username":"jafesantana@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-10-01 06:37:54.114919+00	
00000000-0000-0000-0000-000000000000	0455de55-5a49-4614-b580-85bf8a83c068	{"action":"token_revoked","actor_id":"560ba75b-2f81-4485-9f66-5890747d1e97","actor_username":"jafesantana@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-10-01 06:37:54.121572+00	
00000000-0000-0000-0000-000000000000	1368867f-8e8e-42c9-8855-169824d4b4d0	{"action":"token_refreshed","actor_id":"560ba75b-2f81-4485-9f66-5890747d1e97","actor_username":"jafesantana@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-10-01 06:57:06.207117+00	
00000000-0000-0000-0000-000000000000	3abab135-e2d0-4278-89ff-c00409cc9112	{"action":"token_revoked","actor_id":"560ba75b-2f81-4485-9f66-5890747d1e97","actor_username":"jafesantana@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-10-01 06:57:06.221211+00	
00000000-0000-0000-0000-000000000000	b8794468-6d69-48ff-b007-797bf7c39ef5	{"action":"token_refreshed","actor_id":"560ba75b-2f81-4485-9f66-5890747d1e97","actor_username":"jafesantana@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-10-01 07:36:50.286745+00	
00000000-0000-0000-0000-000000000000	9f8d1422-0fae-4579-9230-fa862a21214f	{"action":"token_revoked","actor_id":"560ba75b-2f81-4485-9f66-5890747d1e97","actor_username":"jafesantana@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-10-01 07:36:50.307345+00	
00000000-0000-0000-0000-000000000000	28e05b8c-8fc9-4999-8379-073230155e43	{"action":"token_refreshed","actor_id":"560ba75b-2f81-4485-9f66-5890747d1e97","actor_username":"jafesantana@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-10-01 14:04:10.651865+00	
00000000-0000-0000-0000-000000000000	dfbdf8dc-aedf-4439-853d-db73fc2f086f	{"action":"token_revoked","actor_id":"560ba75b-2f81-4485-9f66-5890747d1e97","actor_username":"jafesantana@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-10-01 14:04:10.675471+00	
00000000-0000-0000-0000-000000000000	adc8d87c-3db0-41dc-a78c-05e87e912950	{"action":"token_refreshed","actor_id":"560ba75b-2f81-4485-9f66-5890747d1e97","actor_username":"jafesantana@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-10-01 16:46:51.300058+00	
00000000-0000-0000-0000-000000000000	2d4840b5-418d-4c5d-b499-0095e0a3431e	{"action":"token_revoked","actor_id":"560ba75b-2f81-4485-9f66-5890747d1e97","actor_username":"jafesantana@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-10-01 16:46:51.315871+00	
00000000-0000-0000-0000-000000000000	827ef0e3-9ba6-4b72-9976-2507d487f632	{"action":"token_refreshed","actor_id":"560ba75b-2f81-4485-9f66-5890747d1e97","actor_username":"jafesantana@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-10-01 17:45:27.008737+00	
00000000-0000-0000-0000-000000000000	3bfad34a-538f-457b-a7ac-226d7138829b	{"action":"token_revoked","actor_id":"560ba75b-2f81-4485-9f66-5890747d1e97","actor_username":"jafesantana@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-10-01 17:45:27.025072+00	
00000000-0000-0000-0000-000000000000	49c3a39a-9427-43f0-b267-e5b8ccbab718	{"action":"token_refreshed","actor_id":"560ba75b-2f81-4485-9f66-5890747d1e97","actor_username":"jafesantana@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-10-01 20:24:23.958502+00	
00000000-0000-0000-0000-000000000000	dc38bc97-efb7-414c-a017-c2ec0d3efba5	{"action":"token_revoked","actor_id":"560ba75b-2f81-4485-9f66-5890747d1e97","actor_username":"jafesantana@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-10-01 20:24:23.984752+00	
00000000-0000-0000-0000-000000000000	e1e8bf58-cb3e-4d4b-857c-759843b01e8f	{"action":"token_refreshed","actor_id":"560ba75b-2f81-4485-9f66-5890747d1e97","actor_username":"jafesantana@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-10-01 20:24:38.978368+00	
00000000-0000-0000-0000-000000000000	a0a8a5d9-48ed-4e65-a65a-0552dd4558c9	{"action":"token_refreshed","actor_id":"560ba75b-2f81-4485-9f66-5890747d1e97","actor_username":"jafesantana@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-10-02 12:56:25.702144+00	
00000000-0000-0000-0000-000000000000	cd0e75b7-7b7a-495c-ae7e-9a6df9430564	{"action":"token_revoked","actor_id":"560ba75b-2f81-4485-9f66-5890747d1e97","actor_username":"jafesantana@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-10-02 12:56:25.725789+00	
00000000-0000-0000-0000-000000000000	5eeec119-8aa8-45ef-927b-24092d241dc3	{"action":"token_refreshed","actor_id":"560ba75b-2f81-4485-9f66-5890747d1e97","actor_username":"jafesantana@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-10-02 15:34:57.733302+00	
00000000-0000-0000-0000-000000000000	acdc0ea1-f63f-435c-9868-39ab0e07447d	{"action":"token_revoked","actor_id":"560ba75b-2f81-4485-9f66-5890747d1e97","actor_username":"jafesantana@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-10-02 15:34:57.745543+00	
00000000-0000-0000-0000-000000000000	b674268b-10e6-4d5a-818d-ada0a8ea5efb	{"action":"token_refreshed","actor_id":"560ba75b-2f81-4485-9f66-5890747d1e97","actor_username":"jafesantana@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-10-02 17:06:34.322124+00	
00000000-0000-0000-0000-000000000000	dbc3c173-ac25-4a8f-ae12-e7451a75fa0d	{"action":"token_revoked","actor_id":"560ba75b-2f81-4485-9f66-5890747d1e97","actor_username":"jafesantana@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-10-02 17:06:34.342357+00	
00000000-0000-0000-0000-000000000000	a46f6a8b-7ce2-4424-b8f4-fb18ec952922	{"action":"token_refreshed","actor_id":"560ba75b-2f81-4485-9f66-5890747d1e97","actor_username":"jafesantana@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-10-02 17:09:01.892865+00	
00000000-0000-0000-0000-000000000000	099c2bf7-8ea5-4b19-b70b-440e7897e436	{"action":"token_revoked","actor_id":"560ba75b-2f81-4485-9f66-5890747d1e97","actor_username":"jafesantana@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-10-02 17:09:01.894392+00	
00000000-0000-0000-0000-000000000000	f424cb13-df2b-487a-816a-feeefbacbf91	{"action":"token_refreshed","actor_id":"560ba75b-2f81-4485-9f66-5890747d1e97","actor_username":"jafesantana@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-10-02 18:37:38.38436+00	
00000000-0000-0000-0000-000000000000	c81350b7-ac82-4885-a31f-06175108fd41	{"action":"token_revoked","actor_id":"560ba75b-2f81-4485-9f66-5890747d1e97","actor_username":"jafesantana@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-10-02 18:37:38.401871+00	
00000000-0000-0000-0000-000000000000	56f97b42-cba9-4ed6-9ed5-41bceef57129	{"action":"token_refreshed","actor_id":"560ba75b-2f81-4485-9f66-5890747d1e97","actor_username":"jafesantana@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-10-02 20:04:02.746534+00	
00000000-0000-0000-0000-000000000000	5dbc0f9b-a353-48d5-80f8-6665531747e4	{"action":"token_revoked","actor_id":"560ba75b-2f81-4485-9f66-5890747d1e97","actor_username":"jafesantana@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-10-02 20:04:02.760893+00	
00000000-0000-0000-0000-000000000000	239b0ed2-7ab1-4ef6-927f-80fbed285dff	{"action":"token_refreshed","actor_id":"560ba75b-2f81-4485-9f66-5890747d1e97","actor_username":"jafesantana@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-10-02 23:31:41.932872+00	
00000000-0000-0000-0000-000000000000	2f098ffe-6fb6-464d-bc10-48bc0ce189a5	{"action":"token_revoked","actor_id":"560ba75b-2f81-4485-9f66-5890747d1e97","actor_username":"jafesantana@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-10-02 23:31:41.949146+00	
00000000-0000-0000-0000-000000000000	de62de0c-3da7-4407-89a6-442287af01f6	{"action":"token_refreshed","actor_id":"560ba75b-2f81-4485-9f66-5890747d1e97","actor_username":"jafesantana@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-10-03 00:48:19.0107+00	
00000000-0000-0000-0000-000000000000	f523ef12-787c-4271-a8c3-fccdff2f02c2	{"action":"token_revoked","actor_id":"560ba75b-2f81-4485-9f66-5890747d1e97","actor_username":"jafesantana@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-10-03 00:48:19.030781+00	
00000000-0000-0000-0000-000000000000	9621cc4f-9a2f-4e2d-a5e4-8c7b38f8eaba	{"action":"token_refreshed","actor_id":"560ba75b-2f81-4485-9f66-5890747d1e97","actor_username":"jafesantana@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-10-03 00:48:46.506174+00	
00000000-0000-0000-0000-000000000000	2d7d6738-2ccd-4ec7-94f3-51a956f22972	{"action":"token_revoked","actor_id":"560ba75b-2f81-4485-9f66-5890747d1e97","actor_username":"jafesantana@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-10-03 00:48:46.512595+00	
00000000-0000-0000-0000-000000000000	bde865ae-c4b1-4ef4-9345-048396ba85e7	{"action":"token_refreshed","actor_id":"560ba75b-2f81-4485-9f66-5890747d1e97","actor_username":"jafesantana@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-10-03 01:46:28.434773+00	
00000000-0000-0000-0000-000000000000	835c06b6-55c3-4bf3-bd36-df397d19a405	{"action":"token_revoked","actor_id":"560ba75b-2f81-4485-9f66-5890747d1e97","actor_username":"jafesantana@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-10-03 01:46:28.444093+00	
00000000-0000-0000-0000-000000000000	7fdc9d0d-2141-4574-81fc-adf6212af5a0	{"action":"user_confirmation_requested","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"user","traits":{"provider":"email"}}	2025-10-05 01:41:48.695137+00	
00000000-0000-0000-0000-000000000000	9e2e009f-a14a-4394-90a9-e65edac88a2a	{"action":"user_signedup","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"team","traits":{"provider":"email"}}	2025-10-05 01:42:45.563136+00	
00000000-0000-0000-0000-000000000000	cf627175-89e6-45f1-a120-31ffa1019f30	{"action":"login","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-10-05 02:37:50.252277+00	
00000000-0000-0000-0000-000000000000	eb987b01-b197-428f-9c32-aa029a892903	{"action":"token_refreshed","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-10-05 04:48:54.079558+00	
00000000-0000-0000-0000-000000000000	d68c25cf-8317-4873-8219-f8314d2dcd82	{"action":"token_revoked","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-10-05 04:48:54.101569+00	
00000000-0000-0000-0000-000000000000	d51e1d13-7642-43f1-a5a9-c09600a6033d	{"action":"user_recovery_requested","actor_id":"560ba75b-2f81-4485-9f66-5890747d1e97","actor_username":"jafesantana@gmail.com","actor_via_sso":false,"log_type":"user"}	2025-11-13 14:28:57.464225+00	
00000000-0000-0000-0000-000000000000	7db14088-6c67-45e1-b61e-a3d0b278d1e8	{"action":"login","actor_id":"560ba75b-2f81-4485-9f66-5890747d1e97","actor_username":"jafesantana@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-11-13 14:30:11.48904+00	
00000000-0000-0000-0000-000000000000	020d3489-913c-4bbe-b0a6-ecf99707a62f	{"action":"user_deleted","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"jafesantana@gmail.com","user_id":"560ba75b-2f81-4485-9f66-5890747d1e97","user_phone":""}}	2025-11-13 14:30:22.121647+00	
00000000-0000-0000-0000-000000000000	db60bb90-e5ba-4452-a184-70da89ca3b40	{"action":"user_recovery_requested","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"user"}	2025-11-13 14:31:05.698778+00	
00000000-0000-0000-0000-000000000000	44249c00-510a-44a5-84f5-de08f0481d89	{"action":"user_signedup","actor_id":"aaf9f46c-0fe1-4794-a822-f6e385bdef8c","actor_username":"jafesantana@gmail.com","actor_via_sso":false,"log_type":"team","traits":{"provider":"email"}}	2025-11-13 14:32:04.118373+00	
00000000-0000-0000-0000-000000000000	5d21b40d-b7b7-4ef5-8514-7751c7ac53bd	{"action":"login","actor_id":"aaf9f46c-0fe1-4794-a822-f6e385bdef8c","actor_username":"jafesantana@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-11-13 14:32:04.122537+00	
00000000-0000-0000-0000-000000000000	b19caac5-893a-4ca2-b3d8-e153c85d8567	{"action":"token_refreshed","actor_id":"aaf9f46c-0fe1-4794-a822-f6e385bdef8c","actor_username":"jafesantana@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-11-13 15:30:35.185044+00	
00000000-0000-0000-0000-000000000000	b9cb627d-93f9-4fd4-85c7-4c55c4fc845e	{"action":"token_revoked","actor_id":"aaf9f46c-0fe1-4794-a822-f6e385bdef8c","actor_username":"jafesantana@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-11-13 15:30:35.206015+00	
00000000-0000-0000-0000-000000000000	57e5c474-1841-4474-94ca-b5f31bf7c0d8	{"action":"login","actor_id":"aaf9f46c-0fe1-4794-a822-f6e385bdef8c","actor_username":"jafesantana@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-11-13 15:30:56.127964+00	
00000000-0000-0000-0000-000000000000	21954c1d-e9a0-4828-ba8b-a9d7fbb28ee2	{"action":"token_refreshed","actor_id":"aaf9f46c-0fe1-4794-a822-f6e385bdef8c","actor_username":"jafesantana@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-11-13 19:29:15.833881+00	
00000000-0000-0000-0000-000000000000	abb952aa-49c9-4567-8acd-85bd04f6c6ba	{"action":"token_revoked","actor_id":"aaf9f46c-0fe1-4794-a822-f6e385bdef8c","actor_username":"jafesantana@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-11-13 19:29:15.85541+00	
00000000-0000-0000-0000-000000000000	e16463a1-090b-49fd-af9a-21aea1378a2b	{"action":"token_refreshed","actor_id":"aaf9f46c-0fe1-4794-a822-f6e385bdef8c","actor_username":"jafesantana@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-11-13 19:29:20.10251+00	
00000000-0000-0000-0000-000000000000	98ea4839-0afd-4868-81d4-73006c972ec1	{"action":"token_refreshed","actor_id":"aaf9f46c-0fe1-4794-a822-f6e385bdef8c","actor_username":"jafesantana@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-11-13 19:30:30.413658+00	
00000000-0000-0000-0000-000000000000	2ad40c74-d7b6-439b-af62-f3129f24be1b	{"action":"token_revoked","actor_id":"aaf9f46c-0fe1-4794-a822-f6e385bdef8c","actor_username":"jafesantana@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-11-13 19:30:30.41498+00	
00000000-0000-0000-0000-000000000000	b27ed88a-c0c4-4737-84c7-06118eea69f8	{"action":"token_refreshed","actor_id":"aaf9f46c-0fe1-4794-a822-f6e385bdef8c","actor_username":"jafesantana@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-11-26 15:29:13.362374+00	
00000000-0000-0000-0000-000000000000	21e53deb-8493-4260-9339-ec5691431569	{"action":"token_revoked","actor_id":"aaf9f46c-0fe1-4794-a822-f6e385bdef8c","actor_username":"jafesantana@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-11-26 15:29:13.38185+00	
00000000-0000-0000-0000-000000000000	24d95c05-0170-4247-9ead-2863c18270b4	{"action":"token_refreshed","actor_id":"aaf9f46c-0fe1-4794-a822-f6e385bdef8c","actor_username":"jafesantana@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-11-26 15:29:49.106857+00	
00000000-0000-0000-0000-000000000000	ab00e3a1-8120-4c82-b41f-48bfa56d1eaa	{"action":"token_revoked","actor_id":"aaf9f46c-0fe1-4794-a822-f6e385bdef8c","actor_username":"jafesantana@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-11-26 15:29:49.107822+00	
00000000-0000-0000-0000-000000000000	ff8a4a23-16dd-4f0e-876c-7cc91184cfee	{"action":"login","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-11-26 16:20:50.896506+00	
00000000-0000-0000-0000-000000000000	65d4f7b8-da49-4167-a1b5-28d1043d0bef	{"action":"token_refreshed","actor_id":"aaf9f46c-0fe1-4794-a822-f6e385bdef8c","actor_username":"jafesantana@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-11-26 16:27:29.568592+00	
00000000-0000-0000-0000-000000000000	b5b29aed-67ae-442c-91bc-6d3e42d21524	{"action":"token_revoked","actor_id":"aaf9f46c-0fe1-4794-a822-f6e385bdef8c","actor_username":"jafesantana@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-11-26 16:27:29.570693+00	
00000000-0000-0000-0000-000000000000	fed14983-3fe4-435c-80a8-1c1edb677bc3	{"action":"token_refreshed","actor_id":"aaf9f46c-0fe1-4794-a822-f6e385bdef8c","actor_username":"jafesantana@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-11-26 16:27:59.349875+00	
00000000-0000-0000-0000-000000000000	335d09ce-5cdc-420c-a5b7-f01f322768d7	{"action":"token_revoked","actor_id":"aaf9f46c-0fe1-4794-a822-f6e385bdef8c","actor_username":"jafesantana@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-11-26 16:27:59.350974+00	
00000000-0000-0000-0000-000000000000	62df623e-2bce-42e8-bf07-3743ef7a0988	{"action":"token_refreshed","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-11-26 17:20:09.777757+00	
00000000-0000-0000-0000-000000000000	e8593de6-106f-4eb4-a549-31712962d0bc	{"action":"token_revoked","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-11-26 17:20:09.785279+00	
00000000-0000-0000-0000-000000000000	45c32758-b403-4c87-9097-b24adfae28c3	{"action":"token_refreshed","actor_id":"aaf9f46c-0fe1-4794-a822-f6e385bdef8c","actor_username":"jafesantana@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-11-26 17:26:10.768862+00	
00000000-0000-0000-0000-000000000000	5c7bcdef-44b5-467f-beb4-38cfb7841088	{"action":"token_revoked","actor_id":"aaf9f46c-0fe1-4794-a822-f6e385bdef8c","actor_username":"jafesantana@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-11-26 17:26:10.77396+00	
00000000-0000-0000-0000-000000000000	2d736352-4a3b-49ef-89ae-9b60fc100129	{"action":"token_refreshed","actor_id":"aaf9f46c-0fe1-4794-a822-f6e385bdef8c","actor_username":"jafesantana@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-11-26 17:26:19.189795+00	
00000000-0000-0000-0000-000000000000	83bc10f1-6b5b-4c02-95dd-cf304fc59fc2	{"action":"token_revoked","actor_id":"aaf9f46c-0fe1-4794-a822-f6e385bdef8c","actor_username":"jafesantana@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-11-26 17:26:19.192894+00	
00000000-0000-0000-0000-000000000000	c695c072-af06-42f4-a293-feed590920aa	{"action":"token_refreshed","actor_id":"aaf9f46c-0fe1-4794-a822-f6e385bdef8c","actor_username":"jafesantana@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-11-26 18:44:16.513417+00	
00000000-0000-0000-0000-000000000000	e7be793e-4c59-461a-9bc8-271f0cbbc1a6	{"action":"token_refreshed","actor_id":"aaf9f46c-0fe1-4794-a822-f6e385bdef8c","actor_username":"jafesantana@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-11-26 18:44:16.514188+00	
00000000-0000-0000-0000-000000000000	9498ef32-9e17-4a9d-bc2a-f87e850c5643	{"action":"token_revoked","actor_id":"aaf9f46c-0fe1-4794-a822-f6e385bdef8c","actor_username":"jafesantana@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-11-26 18:44:16.538343+00	
00000000-0000-0000-0000-000000000000	db5df7b3-0dbf-478a-b70a-e59de13f7d4a	{"action":"token_revoked","actor_id":"aaf9f46c-0fe1-4794-a822-f6e385bdef8c","actor_username":"jafesantana@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-11-26 18:44:16.53825+00	
00000000-0000-0000-0000-000000000000	1af58ec6-7621-4f1f-82c3-13bce46483d4	{"action":"token_refreshed","actor_id":"aaf9f46c-0fe1-4794-a822-f6e385bdef8c","actor_username":"jafesantana@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-11-26 19:45:52.604141+00	
00000000-0000-0000-0000-000000000000	c2d77c14-2fef-4122-9bf3-6f909870b627	{"action":"token_refreshed","actor_id":"aaf9f46c-0fe1-4794-a822-f6e385bdef8c","actor_username":"jafesantana@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-11-26 19:45:52.606489+00	
00000000-0000-0000-0000-000000000000	3fa40d84-2af0-4353-ac88-e2183d37cee4	{"action":"token_revoked","actor_id":"aaf9f46c-0fe1-4794-a822-f6e385bdef8c","actor_username":"jafesantana@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-11-26 19:45:52.614623+00	
00000000-0000-0000-0000-000000000000	7ea9b988-867a-48e8-9d09-f6cf3a1b9958	{"action":"token_revoked","actor_id":"aaf9f46c-0fe1-4794-a822-f6e385bdef8c","actor_username":"jafesantana@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-11-26 19:45:52.615328+00	
00000000-0000-0000-0000-000000000000	52c8f2f1-9396-400b-b7ea-6bf292785c0d	{"action":"token_refreshed","actor_id":"aaf9f46c-0fe1-4794-a822-f6e385bdef8c","actor_username":"jafesantana@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-11-26 20:57:51.659264+00	
00000000-0000-0000-0000-000000000000	86eff93b-ec97-4f70-9df6-2e740ced5620	{"action":"token_revoked","actor_id":"aaf9f46c-0fe1-4794-a822-f6e385bdef8c","actor_username":"jafesantana@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-11-26 20:57:51.676426+00	
00000000-0000-0000-0000-000000000000	e5dfc746-8118-43a7-ae89-01ab825fb233	{"action":"token_refreshed","actor_id":"aaf9f46c-0fe1-4794-a822-f6e385bdef8c","actor_username":"jafesantana@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-11-26 20:58:23.610609+00	
00000000-0000-0000-0000-000000000000	8055e927-6691-45f2-afd9-62aba328b424	{"action":"token_revoked","actor_id":"aaf9f46c-0fe1-4794-a822-f6e385bdef8c","actor_username":"jafesantana@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-11-26 20:58:23.611919+00	
00000000-0000-0000-0000-000000000000	9131bd09-37aa-4a63-9844-931db628e495	{"action":"token_refreshed","actor_id":"aaf9f46c-0fe1-4794-a822-f6e385bdef8c","actor_username":"jafesantana@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-11-26 21:56:00.630623+00	
00000000-0000-0000-0000-000000000000	5e3b4f7f-eb9c-4a88-9f5d-aaf7f9fdd5c1	{"action":"token_revoked","actor_id":"aaf9f46c-0fe1-4794-a822-f6e385bdef8c","actor_username":"jafesantana@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-11-26 21:56:00.640036+00	
00000000-0000-0000-0000-000000000000	dd010465-e7bd-42ac-84fa-88384d51f16f	{"action":"token_refreshed","actor_id":"aaf9f46c-0fe1-4794-a822-f6e385bdef8c","actor_username":"jafesantana@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-11-26 21:56:41.324635+00	
00000000-0000-0000-0000-000000000000	75c05460-5c75-4b75-850a-05f6fd378946	{"action":"token_revoked","actor_id":"aaf9f46c-0fe1-4794-a822-f6e385bdef8c","actor_username":"jafesantana@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-11-26 21:56:41.336628+00	
00000000-0000-0000-0000-000000000000	5f09bc04-c3c4-4db5-923a-0de0732ad27f	{"action":"logout","actor_id":"aaf9f46c-0fe1-4794-a822-f6e385bdef8c","actor_username":"jafesantana@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-11-26 22:08:51.440805+00	
00000000-0000-0000-0000-000000000000	976579aa-d155-43ca-8c62-ca4314dd35e2	{"action":"login","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-11-26 22:09:03.667327+00	
00000000-0000-0000-0000-000000000000	43c569c5-966f-495c-bf1e-7f84ac2572a0	{"action":"token_refreshed","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-11-26 23:08:14.913419+00	
00000000-0000-0000-0000-000000000000	deb4e445-00c8-404e-8b1b-510899f8998e	{"action":"token_revoked","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-11-26 23:08:14.935257+00	
00000000-0000-0000-0000-000000000000	e60b3511-09a6-41cf-8052-d384afcfcf9f	{"action":"token_refreshed","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-11-28 01:10:35.308396+00	
00000000-0000-0000-0000-000000000000	6bef6c0b-ed49-4a18-beeb-693d90602928	{"action":"token_revoked","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-11-28 01:10:35.323181+00	
00000000-0000-0000-0000-000000000000	deda9263-8980-48ab-9379-7a4157e55bf8	{"action":"login","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-11-28 01:28:10.967004+00	
00000000-0000-0000-0000-000000000000	b90e8386-190e-444b-971a-ba25f3833e5d	{"action":"token_refreshed","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-11-28 02:10:01.856369+00	
00000000-0000-0000-0000-000000000000	880b2cf3-d43c-4c72-9633-1ca4ca82771a	{"action":"token_revoked","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-11-28 02:10:01.879279+00	
00000000-0000-0000-0000-000000000000	1e4c9cad-f64c-4ec1-8d41-9ed72216f0d5	{"action":"token_refreshed","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-11-28 02:27:21.744042+00	
00000000-0000-0000-0000-000000000000	4f261d82-ae11-46df-a892-be1197d6128a	{"action":"token_revoked","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-11-28 02:27:21.762337+00	
00000000-0000-0000-0000-000000000000	c998a454-ba1b-410e-89f0-20856c82e390	{"action":"token_refreshed","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-11-28 03:08:21.716907+00	
00000000-0000-0000-0000-000000000000	cec79946-3f47-468e-9777-3b229009f3d3	{"action":"token_revoked","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-11-28 03:08:21.739545+00	
00000000-0000-0000-0000-000000000000	3e134a87-883a-4811-8d94-35a4ca244cdb	{"action":"token_refreshed","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-11-28 03:25:23.860834+00	
00000000-0000-0000-0000-000000000000	f7bad6c2-7638-4c4b-bc1b-4589253a7fd1	{"action":"token_revoked","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-11-28 03:25:23.871219+00	
00000000-0000-0000-0000-000000000000	b8738363-76c4-4fc2-8d1a-bc1279f11a15	{"action":"token_refreshed","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-11-28 04:21:42.400782+00	
00000000-0000-0000-0000-000000000000	f482653e-0310-4153-8f33-93666f8d2216	{"action":"token_revoked","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-11-28 04:21:42.412534+00	
00000000-0000-0000-0000-000000000000	8d7ac244-d4fc-4bd3-aff9-de2bd59ca037	{"action":"token_refreshed","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-11-28 04:23:24.474819+00	
00000000-0000-0000-0000-000000000000	d990229c-ccbe-4304-a489-a449d2cf86d4	{"action":"token_revoked","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-11-28 04:23:24.492576+00	
00000000-0000-0000-0000-000000000000	8ae14534-c0d0-4214-bf44-893778b83c90	{"action":"token_refreshed","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-11-28 05:20:56.806392+00	
00000000-0000-0000-0000-000000000000	1d1b6c17-075b-4985-bfb5-09cf276b0e1a	{"action":"token_revoked","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-11-28 05:20:56.813629+00	
00000000-0000-0000-0000-000000000000	a3ef6b46-0ef3-407c-b3ff-4429b3b17112	{"action":"token_refreshed","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-11-28 05:21:57.463248+00	
00000000-0000-0000-0000-000000000000	d55b560f-89ad-4294-ac29-15ce79947291	{"action":"token_revoked","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-11-28 05:21:57.465691+00	
00000000-0000-0000-0000-000000000000	592fcbe0-c402-4d9c-84b3-5e295b488ee8	{"action":"token_refreshed","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-11-28 06:20:10.144656+00	
00000000-0000-0000-0000-000000000000	6247056c-2f06-45c4-9683-6b3ea989ce06	{"action":"token_revoked","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-11-28 06:20:10.162722+00	
00000000-0000-0000-0000-000000000000	0f74182a-45db-4d18-8449-9f2c81f77b2f	{"action":"token_refreshed","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-11-28 07:19:01.922852+00	
00000000-0000-0000-0000-000000000000	cb4b49ca-737e-4c53-ac8f-450a85f54052	{"action":"token_revoked","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-11-28 07:19:01.937896+00	
00000000-0000-0000-0000-000000000000	41f3acad-7a2a-4c69-9e2d-1ca29eb43806	{"action":"token_refreshed","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-11-28 08:19:02.057935+00	
00000000-0000-0000-0000-000000000000	718ac28a-3194-434a-93a3-391b4bff7056	{"action":"token_revoked","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-11-28 08:19:02.06984+00	
00000000-0000-0000-0000-000000000000	4674b384-5e3f-4193-855d-82dc65bb7ac7	{"action":"token_refreshed","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-11-28 09:19:02.245394+00	
00000000-0000-0000-0000-000000000000	b5f1bb68-8eca-4f0d-869e-df3eb7aa6e41	{"action":"token_revoked","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-11-28 09:19:02.256483+00	
00000000-0000-0000-0000-000000000000	293e067c-92e3-4488-8506-ed50b14c0901	{"action":"token_refreshed","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-11-28 10:19:01.993357+00	
00000000-0000-0000-0000-000000000000	38fa6010-d714-4096-867c-5ad08d91db10	{"action":"token_revoked","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-11-28 10:19:02.00715+00	
00000000-0000-0000-0000-000000000000	f5f46fb3-970a-491d-86f4-5edccd27509d	{"action":"token_refreshed","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-11-28 11:19:01.987329+00	
00000000-0000-0000-0000-000000000000	362e5f51-a715-4a76-a938-e0f82891a5c8	{"action":"token_revoked","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-11-28 11:19:02.005781+00	
00000000-0000-0000-0000-000000000000	a7921458-f7e9-4cae-a403-c4c734bfb582	{"action":"token_refreshed","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-11-28 12:19:01.975372+00	
00000000-0000-0000-0000-000000000000	87217a3f-eb17-450d-adee-19ee81f5c5aa	{"action":"token_revoked","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-11-28 12:19:01.987496+00	
00000000-0000-0000-0000-000000000000	bff3c1aa-6137-4b03-882b-457812f039fe	{"action":"token_refreshed","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-11-28 13:18:08.784685+00	
00000000-0000-0000-0000-000000000000	7423868e-1a76-4bd9-a058-8a13946948c8	{"action":"token_revoked","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-11-28 13:18:08.794217+00	
00000000-0000-0000-0000-000000000000	482e4a0c-072a-4ed3-914a-30cff7d2c6db	{"action":"token_refreshed","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-11-28 13:20:53.525508+00	
00000000-0000-0000-0000-000000000000	204eefdd-095b-4bdd-9da2-f59bb506b7ce	{"action":"token_revoked","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-11-28 13:20:53.527244+00	
00000000-0000-0000-0000-000000000000	65f57039-795e-4587-8944-0ef0dcb8cc12	{"action":"token_refreshed","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-11-28 14:17:01.869194+00	
00000000-0000-0000-0000-000000000000	a0db96d4-ac37-4bfe-8bf9-5116a3ca12ed	{"action":"token_revoked","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-11-28 14:17:01.891206+00	
00000000-0000-0000-0000-000000000000	694407cc-d399-40b2-8df5-5517aa7cd5a2	{"action":"token_refreshed","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-11-28 14:28:07.297093+00	
00000000-0000-0000-0000-000000000000	63c3de83-1e17-494b-a5a2-54aa862adb5b	{"action":"token_revoked","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-11-28 14:28:07.304956+00	
00000000-0000-0000-0000-000000000000	e3076eaa-e527-4d16-9ad5-47e0bbc6262d	{"action":"token_refreshed","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-11-28 15:16:02.118745+00	
00000000-0000-0000-0000-000000000000	f04887b0-1b29-4cab-a873-3e53217dd771	{"action":"token_revoked","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-11-28 15:16:02.134769+00	
00000000-0000-0000-0000-000000000000	3a502ef7-dbdc-44df-ac23-dc3c23cc103f	{"action":"token_refreshed","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-11-28 15:54:25.459245+00	
00000000-0000-0000-0000-000000000000	667e1a2d-b4c5-42ff-ab31-eda0cacccf4a	{"action":"token_revoked","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-11-28 15:54:25.46908+00	
00000000-0000-0000-0000-000000000000	6716c7ac-6bc6-432f-bccf-8772b2d994ec	{"action":"token_refreshed","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-11-28 16:15:02.062476+00	
00000000-0000-0000-0000-000000000000	d412583b-a213-4f3d-99e6-fe025cd23dd6	{"action":"token_revoked","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-11-28 16:15:02.074184+00	
00000000-0000-0000-0000-000000000000	3abb8c99-94a5-469d-9abb-f4613a70a57a	{"action":"token_refreshed","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-11-28 17:15:02.021422+00	
00000000-0000-0000-0000-000000000000	ef20c4d0-8464-4a0d-90ae-2067acbb5f64	{"action":"token_revoked","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-11-28 17:15:02.047292+00	
00000000-0000-0000-0000-000000000000	64acc8e2-a820-41e9-942c-08d011364b70	{"action":"token_refreshed","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-11-28 18:15:02.134667+00	
00000000-0000-0000-0000-000000000000	8af1196f-1a37-4ebc-b426-ff4f8c2de54e	{"action":"token_revoked","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-11-28 18:15:02.150382+00	
00000000-0000-0000-0000-000000000000	aad93afc-5a94-4480-843b-d6f33a937f86	{"action":"token_refreshed","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-11-28 18:53:28.867793+00	
00000000-0000-0000-0000-000000000000	8734a1a2-318d-4483-bbf5-1c24ec7d7a8e	{"action":"token_revoked","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-11-28 18:53:28.876145+00	
00000000-0000-0000-0000-000000000000	6e173999-758b-4bb5-bd8d-b220bbbc24d7	{"action":"token_refreshed","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-11-28 19:14:02.081854+00	
00000000-0000-0000-0000-000000000000	07673b10-dc5f-47fc-8b88-2914719f64cd	{"action":"token_revoked","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-11-28 19:14:02.090134+00	
00000000-0000-0000-0000-000000000000	8a73cc5c-4c10-4ce5-a1e8-152ab5d553e4	{"action":"token_refreshed","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-11-28 20:14:02.144218+00	
00000000-0000-0000-0000-000000000000	cdad7991-5ff2-44ce-bc65-08e8d75c3680	{"action":"token_revoked","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-11-28 20:14:02.16048+00	
00000000-0000-0000-0000-000000000000	a30daa45-595d-43e5-a3e6-4d2f3caa8601	{"action":"token_refreshed","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-11-28 21:01:21.827667+00	
00000000-0000-0000-0000-000000000000	d3892bc8-27ed-42b2-a87a-8f43dddbae08	{"action":"token_revoked","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-11-28 21:01:21.836582+00	
00000000-0000-0000-0000-000000000000	d0a33ed5-0d02-4eb2-966b-4ebcf0dfeda3	{"action":"login","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-01-31 18:53:20.120557+00	
00000000-0000-0000-0000-000000000000	f3325303-530c-4af0-88d7-1a599e6682f9	{"action":"login","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-01-31 18:59:19.476236+00	
00000000-0000-0000-0000-000000000000	69fbeecb-7127-4427-916a-141696b7e571	{"action":"login","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-01-31 21:44:22.809326+00	
00000000-0000-0000-0000-000000000000	86852ac6-e661-4f86-b4bc-1f3ea50c981a	{"action":"token_refreshed","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-02-01 11:47:35.597157+00	
00000000-0000-0000-0000-000000000000	ef132ba8-32b1-4581-be37-9c8a9635e1e6	{"action":"token_revoked","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-02-01 11:47:35.605966+00	
00000000-0000-0000-0000-000000000000	5efbfee2-8b9a-459f-8888-4199cbaf0b3d	{"action":"token_refreshed","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-02-01 20:27:51.996176+00	
00000000-0000-0000-0000-000000000000	419a0171-ad96-4a20-a970-861b5002fce8	{"action":"token_revoked","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-02-01 20:27:52.022348+00	
00000000-0000-0000-0000-000000000000	5456b3b9-7dbc-4ea5-8f4f-62ad44133f90	{"action":"login","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-02-02 14:08:21.160693+00	
00000000-0000-0000-0000-000000000000	52ecf0fb-77a9-4c0e-b9a6-3df17a1dbfa2	{"action":"login","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-02-02 14:31:16.947088+00	
00000000-0000-0000-0000-000000000000	3ee83b32-81cf-4d93-9236-6ccad2aa36b4	{"action":"login","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-02-02 14:32:00.180146+00	
00000000-0000-0000-0000-000000000000	29b6dda4-7a7d-4cfd-a8ac-eacbe057d223	{"action":"login","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-02-02 14:35:58.208448+00	
00000000-0000-0000-0000-000000000000	b879c3e5-ae1a-4443-a1d0-9a769fae5598	{"action":"login","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-02-02 14:36:55.33609+00	
00000000-0000-0000-0000-000000000000	4e6a958a-7136-4d92-bbbe-2d30b31c5f59	{"action":"login","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-02-02 14:51:28.259242+00	
00000000-0000-0000-0000-000000000000	870639d7-473a-4af3-8717-0c0581d7d169	{"action":"token_refreshed","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-02-02 14:52:01.02912+00	
00000000-0000-0000-0000-000000000000	913e724f-52c2-4365-897e-e98607fa85e9	{"action":"token_revoked","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-02-02 14:52:01.030444+00	
00000000-0000-0000-0000-000000000000	3d4a5b41-3ec3-459a-95c6-eefb6128d4b8	{"action":"login","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-02-02 14:52:22.60015+00	
00000000-0000-0000-0000-000000000000	a6721f27-ffa0-40c3-a4a0-07df5f079ade	{"action":"login","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-02-02 14:57:46.431967+00	
00000000-0000-0000-0000-000000000000	e675e39e-b2f6-4ffe-9141-7b0e453a2baf	{"action":"login","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-02-02 14:59:03.082039+00	
00000000-0000-0000-0000-000000000000	863a22ba-c0c1-4392-8e61-9757e15446fc	{"action":"token_refreshed","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-02-02 16:39:36.348552+00	
00000000-0000-0000-0000-000000000000	de50a35d-100d-4d97-a9e3-05c7f97cbf0a	{"action":"token_revoked","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-02-02 16:39:36.364306+00	
00000000-0000-0000-0000-000000000000	7bb39585-b8e1-4bbc-8736-13efc07d4618	{"action":"login","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-02-02 16:39:51.438769+00	
00000000-0000-0000-0000-000000000000	2171b610-9f8f-4284-9f86-b81c4737c813	{"action":"login","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-02-02 16:42:43.052479+00	
00000000-0000-0000-0000-000000000000	bdc22653-f246-4d7e-ba36-47151bb78b1e	{"action":"login","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-02-02 16:43:41.805679+00	
00000000-0000-0000-0000-000000000000	f1567a14-ddf0-4579-a797-0b97f13c4900	{"action":"login","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-02-02 16:46:49.082762+00	
00000000-0000-0000-0000-000000000000	b4f7b744-942f-418b-a292-86bf0225774f	{"action":"login","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-02-02 16:53:04.382113+00	
00000000-0000-0000-0000-000000000000	6466c6a9-b478-4075-a351-62761b7c4697	{"action":"login","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-02-02 16:58:29.624711+00	
00000000-0000-0000-0000-000000000000	9f0012a5-a1d2-4b2c-a436-c322443a927c	{"action":"login","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-02-02 17:04:42.638384+00	
00000000-0000-0000-0000-000000000000	ba0b83fb-91e9-4bf4-950b-81033d216fa8	{"action":"token_refreshed","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-02-02 18:05:31.597763+00	
00000000-0000-0000-0000-000000000000	c62c4357-a905-4208-b182-54349d218452	{"action":"token_revoked","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-02-02 18:05:31.603171+00	
00000000-0000-0000-0000-000000000000	07e91b90-3bae-4503-a67f-18719dd11d3c	{"action":"login","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-02-02 18:14:30.539668+00	
00000000-0000-0000-0000-000000000000	987c852c-c450-4f54-99ff-caf9cc193cd8	{"action":"login","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-02-02 18:31:57.379513+00	
00000000-0000-0000-0000-000000000000	a20a3af1-b55f-4b92-b66a-cec59c67d4cd	{"action":"login","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-02-02 18:32:54.289384+00	
00000000-0000-0000-0000-000000000000	b84507fe-9276-44d7-b243-8b927e87ea01	{"action":"login","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-02-02 18:38:06.451021+00	
00000000-0000-0000-0000-000000000000	a3a84b2d-3fa0-46c7-86f5-9325dcdecc0a	{"action":"login","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-02-02 18:54:24.170267+00	
00000000-0000-0000-0000-000000000000	26ade118-48a1-488f-a381-d42892adb6ee	{"action":"login","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-02-02 19:14:58.630078+00	
00000000-0000-0000-0000-000000000000	ee4ff537-c108-44ae-9dfd-8f8077dfd8f1	{"action":"token_refreshed","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-02-02 23:11:12.571348+00	
00000000-0000-0000-0000-000000000000	d0d8624c-3ce9-44fc-b791-e085978a946c	{"action":"token_revoked","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-02-02 23:11:12.59428+00	
00000000-0000-0000-0000-000000000000	2d3a7a0d-ab02-452a-a381-02673cb993e3	{"action":"login","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-02-02 23:11:46.514593+00	
00000000-0000-0000-0000-000000000000	bfeabc03-c042-4796-b6ab-20eb8d5e2e4c	{"action":"token_refreshed","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-02-03 03:07:16.7982+00	
00000000-0000-0000-0000-000000000000	cefaf210-2ecd-42f5-adca-45e11419303f	{"action":"token_revoked","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-02-03 03:07:16.821119+00	
00000000-0000-0000-0000-000000000000	9cacbf13-bff8-45a7-9bbd-94b1b94ebca4	{"action":"login","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-02-03 03:18:25.375466+00	
00000000-0000-0000-0000-000000000000	1f6dc544-5079-4b5b-be0a-468fa12bf642	{"action":"token_refreshed","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-02-03 10:41:53.592947+00	
00000000-0000-0000-0000-000000000000	2fe80d3d-a6db-455f-9c83-7e5e3034486c	{"action":"token_revoked","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-02-03 10:41:53.614121+00	
00000000-0000-0000-0000-000000000000	851c29d6-7127-4880-940f-04ae8d83b8ae	{"action":"token_refreshed","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-02-03 11:02:09.749838+00	
00000000-0000-0000-0000-000000000000	4bafac3e-eb1c-4513-b1f7-dbf9436e95c3	{"action":"token_revoked","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-02-03 11:02:09.758704+00	
00000000-0000-0000-0000-000000000000	b7031e67-7b40-4c3f-8eba-6d896dd9df10	{"action":"token_refreshed","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-02-03 11:02:11.737889+00	
00000000-0000-0000-0000-000000000000	01b5a1b2-9a49-4dde-9a8e-652825708f8d	{"action":"token_refreshed","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-02-03 12:02:35.623473+00	
00000000-0000-0000-0000-000000000000	ea613c4b-ade4-47d4-bf70-b1abb5a73273	{"action":"token_revoked","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-02-03 12:02:35.644173+00	
00000000-0000-0000-0000-000000000000	7352af73-8379-4550-adda-606abb8c8234	{"action":"token_refreshed","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-02-03 13:04:50.805695+00	
00000000-0000-0000-0000-000000000000	ee30e417-7f17-4512-a66d-ea604259597b	{"action":"token_revoked","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-02-03 13:04:50.829285+00	
00000000-0000-0000-0000-000000000000	f9fcd1a7-b31a-407b-a1c2-224c2cada30c	{"action":"token_refreshed","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-02-03 14:03:27.030013+00	
00000000-0000-0000-0000-000000000000	c90d45ed-e8a5-4000-99e0-e8f7ba56a79e	{"action":"token_revoked","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-02-03 14:03:27.039267+00	
00000000-0000-0000-0000-000000000000	ca669679-e014-48ea-922c-e0fc5be8e33e	{"action":"token_refreshed","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-02-03 15:03:40.472815+00	
00000000-0000-0000-0000-000000000000	0751da74-6ea2-4db1-8b61-5d560f0b79b8	{"action":"token_revoked","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-02-03 15:03:40.488226+00	
00000000-0000-0000-0000-000000000000	8cbb1a00-e4ac-4eac-88a9-949bc05fd8b7	{"action":"token_refreshed","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-02-03 16:01:45.997022+00	
00000000-0000-0000-0000-000000000000	93443435-a957-4774-83a6-801ec0c812d6	{"action":"token_revoked","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-02-03 16:01:46.005228+00	
00000000-0000-0000-0000-000000000000	a07eb90b-1c57-439b-a7eb-3f6831265557	{"action":"token_refreshed","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-02-03 17:00:16.15175+00	
00000000-0000-0000-0000-000000000000	bc438972-b89a-4d21-a5d2-3a80a7ac932c	{"action":"token_revoked","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-02-03 17:00:16.164895+00	
00000000-0000-0000-0000-000000000000	519994ec-1213-4fdb-b671-15bc45aac7ee	{"action":"token_refreshed","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-02-03 17:58:46.102471+00	
00000000-0000-0000-0000-000000000000	06c2be4f-f43b-495d-bad2-a73971e3b883	{"action":"token_revoked","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-02-03 17:58:46.118525+00	
00000000-0000-0000-0000-000000000000	9b1a9908-db8c-47f9-8543-d66d444dff40	{"action":"token_refreshed","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-02-04 00:36:36.443056+00	
00000000-0000-0000-0000-000000000000	6714f52e-6310-4518-8e74-5ec33dd8d399	{"action":"token_revoked","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-02-04 00:36:36.46864+00	
00000000-0000-0000-0000-000000000000	1ba9a9f8-b38e-450b-b01d-778b3f30fbf2	{"action":"token_refreshed","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-02-04 01:35:02.865912+00	
00000000-0000-0000-0000-000000000000	3e4ae494-4067-4172-b865-fbb23b66d32d	{"action":"token_revoked","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-02-04 01:35:02.884098+00	
00000000-0000-0000-0000-000000000000	d2f2ef37-9042-4e12-835b-97b674e7eda1	{"action":"token_refreshed","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-02-04 11:33:36.489304+00	
00000000-0000-0000-0000-000000000000	dc83eb2f-f94e-4825-b821-2e7e100d08da	{"action":"token_revoked","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-02-04 11:33:36.517491+00	
00000000-0000-0000-0000-000000000000	884e1318-a739-4cb7-a6e6-bcc40e8e800e	{"action":"login","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-02-04 11:33:54.520843+00	
00000000-0000-0000-0000-000000000000	a2fc22fd-189f-47ef-b4d2-d113f41ade6e	{"action":"token_refreshed","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-02-04 12:36:47.327878+00	
00000000-0000-0000-0000-000000000000	1fd393b7-86b1-493a-84ca-94af22470faa	{"action":"token_revoked","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-02-04 12:36:47.336023+00	
00000000-0000-0000-0000-000000000000	d987ee5f-1af2-4a11-b74b-86edbe02f3f2	{"action":"token_refreshed","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-02-04 13:37:04.799171+00	
00000000-0000-0000-0000-000000000000	df72a76b-3d20-43e8-89c3-faf3b6489e7b	{"action":"token_revoked","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-02-04 13:37:04.823811+00	
00000000-0000-0000-0000-000000000000	ab48aa63-9d3c-4d5d-a5c8-24c23be1e3bc	{"action":"token_refreshed","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-02-04 14:59:01.518167+00	
00000000-0000-0000-0000-000000000000	50dbeb54-9375-41dc-92f8-7b3234a9192b	{"action":"token_revoked","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-02-04 14:59:01.526042+00	
00000000-0000-0000-0000-000000000000	ab132e2e-812f-4b42-ae0f-a78e222ba242	{"action":"token_refreshed","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-02-04 17:33:17.564587+00	
00000000-0000-0000-0000-000000000000	f8a884c5-eed8-4071-8da4-af5cdf4af61e	{"action":"token_revoked","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-02-04 17:33:17.583251+00	
00000000-0000-0000-0000-000000000000	08f9398a-799f-4086-9227-95029e514612	{"action":"login","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-02-04 17:34:58.29301+00	
00000000-0000-0000-0000-000000000000	e8568cf3-84d2-445b-943e-256f0820b44c	{"action":"token_refreshed","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-02-04 18:33:06.695528+00	
00000000-0000-0000-0000-000000000000	61a61290-d2cb-4658-a75f-92e9a3abd592	{"action":"token_revoked","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-02-04 18:33:06.712144+00	
00000000-0000-0000-0000-000000000000	cafb0d15-8d7c-4955-a097-380fa4b6d2af	{"action":"token_refreshed","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-02-04 19:33:24.104639+00	
00000000-0000-0000-0000-000000000000	431c18e6-1a69-46bc-bf3a-46f6afa53ca7	{"action":"token_revoked","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-02-04 19:33:24.109694+00	
00000000-0000-0000-0000-000000000000	233f8cc9-9849-4138-b77e-17fefb6913b9	{"action":"token_refreshed","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-02-04 20:40:26.616654+00	
00000000-0000-0000-0000-000000000000	50f45cf5-5bdf-4dc2-a937-48b696ce6b3f	{"action":"token_revoked","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-02-04 20:40:26.632726+00	
00000000-0000-0000-0000-000000000000	533744d3-64a5-44e9-9752-b557865f76fe	{"action":"token_refreshed","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-02-04 21:39:55.667839+00	
00000000-0000-0000-0000-000000000000	d931a08c-5b37-4dd3-8f37-fcac411b1561	{"action":"token_revoked","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-02-04 21:39:55.675791+00	
00000000-0000-0000-0000-000000000000	e75d6998-e067-45c5-a4e5-6cbd7c9fa531	{"action":"token_refreshed","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-02-05 01:38:07.082339+00	
00000000-0000-0000-0000-000000000000	f0c578e4-8555-4b94-b3b5-f76d14ed8523	{"action":"token_revoked","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-02-05 01:38:07.095189+00	
00000000-0000-0000-0000-000000000000	4e6c4b71-3fc4-4bd7-8c52-b22cdc7727ee	{"action":"token_refreshed","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-02-05 11:08:05.359792+00	
00000000-0000-0000-0000-000000000000	18c293b8-59ac-4861-9862-bcc544b43b4b	{"action":"token_revoked","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-02-05 11:08:05.381023+00	
00000000-0000-0000-0000-000000000000	612a6e6a-eb28-419f-867e-98e461f6123a	{"action":"token_refreshed","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-02-05 12:06:23.949179+00	
00000000-0000-0000-0000-000000000000	7f8328b4-4302-452b-aa2e-a9938ef07f39	{"action":"token_revoked","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-02-05 12:06:23.961984+00	
00000000-0000-0000-0000-000000000000	98d0f36d-6e15-4d38-8397-501e1729e750	{"action":"token_refreshed","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-02-05 13:27:57.836178+00	
00000000-0000-0000-0000-000000000000	bf55b3bf-7bfe-4adb-bf18-37234d05f61c	{"action":"token_revoked","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-02-05 13:27:57.847525+00	
00000000-0000-0000-0000-000000000000	fb07c8e9-1794-4581-a505-494fca06bed1	{"action":"token_refreshed","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-02-05 14:52:01.904368+00	
00000000-0000-0000-0000-000000000000	7ca150b8-6a32-4c9c-b294-9ad5f26a5163	{"action":"token_revoked","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-02-05 14:52:01.917103+00	
00000000-0000-0000-0000-000000000000	41a34b32-69ca-4a65-9d91-372865dfde00	{"action":"token_refreshed","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-02-05 17:00:57.950497+00	
00000000-0000-0000-0000-000000000000	2f5e5bcd-173c-4f22-8f0b-2c3932e75155	{"action":"token_revoked","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-02-05 17:00:57.971338+00	
00000000-0000-0000-0000-000000000000	a56ef0e2-d7d3-4982-adb9-d7cfa00f36e0	{"action":"login","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-02-05 17:03:22.108401+00	
00000000-0000-0000-0000-000000000000	45394464-d273-4996-b349-30c03c6bea4a	{"action":"token_refreshed","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-02-05 18:02:15.530482+00	
00000000-0000-0000-0000-000000000000	bdbf9e4c-f99d-4091-af65-5075384470f1	{"action":"token_revoked","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-02-05 18:02:15.546836+00	
00000000-0000-0000-0000-000000000000	21fdee89-915e-4de1-ae2d-023f1da8cb63	{"action":"token_refreshed","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-02-06 10:16:25.959831+00	
00000000-0000-0000-0000-000000000000	3cb72926-bd53-43ce-8aaa-43926a07f625	{"action":"token_revoked","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-02-06 10:16:25.983488+00	
00000000-0000-0000-0000-000000000000	a6f5636f-102f-4a96-ba89-c4f01a79f26e	{"action":"token_refreshed","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-02-06 11:14:32.777162+00	
00000000-0000-0000-0000-000000000000	be8acc5e-b9bb-4992-912b-ae7e8ee96247	{"action":"token_revoked","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-02-06 11:14:32.786346+00	
00000000-0000-0000-0000-000000000000	48205946-bea2-438d-be10-33e38ce38e4b	{"action":"token_refreshed","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-02-06 11:32:04.493265+00	
00000000-0000-0000-0000-000000000000	305dd30b-5a3a-4d6a-beb9-b96bbbd39c69	{"action":"token_revoked","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-02-06 11:32:04.507794+00	
00000000-0000-0000-0000-000000000000	2f02c4ae-64ca-4d28-8114-fb287aca3a99	{"action":"login","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-02-06 11:42:17.190813+00	
00000000-0000-0000-0000-000000000000	c61f8c3f-1bfc-4870-922b-1223fdf42af3	{"action":"token_refreshed","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-02-06 12:12:32.621283+00	
00000000-0000-0000-0000-000000000000	d417225f-0f67-4567-b358-10e72a34ba17	{"action":"token_revoked","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-02-06 12:12:32.639094+00	
00000000-0000-0000-0000-000000000000	d1c435e0-57e1-4e69-ab8b-6e8e3f042a47	{"action":"token_refreshed","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-02-06 13:56:46.801702+00	
00000000-0000-0000-0000-000000000000	c458131f-8f1a-4dfc-8953-621f26be4603	{"action":"token_revoked","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-02-06 13:56:46.819276+00	
00000000-0000-0000-0000-000000000000	d850a686-b624-4d66-9e3e-3b680ee6d12e	{"action":"login","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-02-06 13:57:11.469117+00	
00000000-0000-0000-0000-000000000000	23721d72-3086-4534-ba54-732eca78ff2b	{"action":"token_refreshed","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-02-06 15:15:14.319139+00	
00000000-0000-0000-0000-000000000000	1d46b9cd-8555-4b74-a1f5-b433c6439588	{"action":"token_revoked","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-02-06 15:15:14.336325+00	
00000000-0000-0000-0000-000000000000	d4a51e35-5f9f-455b-a94e-c858ad5d34c3	{"action":"token_refreshed","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-02-07 15:14:45.09623+00	
00000000-0000-0000-0000-000000000000	00f1639b-3e68-4ba7-9ffa-9a540c4c7f4b	{"action":"token_revoked","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-02-07 15:14:45.120989+00	
00000000-0000-0000-0000-000000000000	3d87e236-0606-4fd5-9da6-8e5f31b4220f	{"action":"token_refreshed","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-02-07 16:16:05.380552+00	
00000000-0000-0000-0000-000000000000	bc330eb3-356a-482b-ac8a-cb7b8085fa22	{"action":"token_revoked","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-02-07 16:16:05.395368+00	
00000000-0000-0000-0000-000000000000	e57af2c6-808d-4a9d-b1dc-587b1537a519	{"action":"token_refreshed","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-02-07 17:14:37.185445+00	
00000000-0000-0000-0000-000000000000	5d486dc7-2875-4d04-b749-b3fc3f59aabc	{"action":"token_revoked","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-02-07 17:14:37.200942+00	
00000000-0000-0000-0000-000000000000	ba8c0783-3d07-40f4-80d1-7affdfe7ac5e	{"action":"token_refreshed","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-02-07 18:15:01.478968+00	
00000000-0000-0000-0000-000000000000	6d8a7906-1e45-4d79-b5cf-76db19ae04a6	{"action":"token_revoked","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-02-07 18:15:01.489288+00	
00000000-0000-0000-0000-000000000000	ce4d2d47-4e0d-4317-9acd-4684a9398ed0	{"action":"token_refreshed","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-02-07 19:13:32.598941+00	
00000000-0000-0000-0000-000000000000	7b60e24c-5d20-4742-aa30-35ffafaaaa73	{"action":"token_revoked","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-02-07 19:13:32.623403+00	
00000000-0000-0000-0000-000000000000	e355d46a-77f6-49ab-9f73-a80f384d2665	{"action":"token_refreshed","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-02-07 21:29:09.40592+00	
00000000-0000-0000-0000-000000000000	8688c0bd-e2ae-40a3-afd9-0f2bae834944	{"action":"token_revoked","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-02-07 21:29:09.420161+00	
00000000-0000-0000-0000-000000000000	f7be2ecb-2d99-43c8-a89d-4ffb247474c1	{"action":"token_refreshed","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-02-08 00:36:29.97071+00	
00000000-0000-0000-0000-000000000000	f547cd50-d6b8-4002-8436-4553bc51d718	{"action":"token_revoked","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-02-08 00:36:29.995505+00	
00000000-0000-0000-0000-000000000000	9e204e46-a2e6-4af3-b332-72b134eb2fbe	{"action":"token_refreshed","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-02-08 16:22:15.05841+00	
00000000-0000-0000-0000-000000000000	0f8f6768-a61a-4af8-8bbb-2a39fdf950c6	{"action":"token_revoked","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-02-08 16:22:15.077513+00	
00000000-0000-0000-0000-000000000000	ee61866b-9df5-425c-a7aa-808a0e82d456	{"action":"token_refreshed","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-02-08 17:21:10.058298+00	
00000000-0000-0000-0000-000000000000	00c5aec9-2101-4a7b-ab22-4039e6cf8591	{"action":"token_revoked","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-02-08 17:21:10.073976+00	
00000000-0000-0000-0000-000000000000	7f04cb8b-a3f1-4aab-a9e6-31e5a4937012	{"action":"token_refreshed","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-02-08 19:03:56.569234+00	
00000000-0000-0000-0000-000000000000	959e382f-4619-41ec-a2c1-bae7b13c669b	{"action":"token_revoked","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-02-08 19:03:56.588254+00	
00000000-0000-0000-0000-000000000000	3c98b6a6-2e96-4963-9c0d-d77618fa1277	{"action":"token_refreshed","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-02-09 01:52:45.093161+00	
00000000-0000-0000-0000-000000000000	372900b5-428c-4aac-8954-2adc32af4739	{"action":"token_revoked","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-02-09 01:52:45.118342+00	
00000000-0000-0000-0000-000000000000	6e6e718b-cc27-4354-a86a-ea990d9d6817	{"action":"token_refreshed","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-02-09 01:53:02.00153+00	
00000000-0000-0000-0000-000000000000	ce3e7b82-c32e-4746-b440-81a76ce91b32	{"action":"token_refreshed","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-02-09 02:54:03.005605+00	
00000000-0000-0000-0000-000000000000	a86c0e8b-cc2f-461f-b407-664fcde89729	{"action":"token_revoked","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-02-09 02:54:03.032043+00	
00000000-0000-0000-0000-000000000000	3f945611-0597-43ed-bed9-09de31b9f801	{"action":"token_refreshed","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-02-09 13:16:16.912078+00	
00000000-0000-0000-0000-000000000000	140c752a-4ed6-40cc-8c57-3fd89e41d919	{"action":"token_revoked","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-02-09 13:16:16.935309+00	
00000000-0000-0000-0000-000000000000	e0687e0b-1d00-407d-ac2c-9890cf4c4a1e	{"action":"token_refreshed","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-02-09 14:48:19.420123+00	
00000000-0000-0000-0000-000000000000	f7cc6230-6a3c-4868-bbf1-eb7a1503d902	{"action":"token_revoked","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-02-09 14:48:19.434101+00	
00000000-0000-0000-0000-000000000000	52ef0e4a-3653-4e74-8c5f-5ba44340caad	{"action":"token_refreshed","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-02-10 01:07:34.075393+00	
00000000-0000-0000-0000-000000000000	8fd07b5f-6888-4a84-b2b0-d3bd4512cd88	{"action":"token_revoked","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-02-10 01:07:34.091901+00	
00000000-0000-0000-0000-000000000000	def37e94-48ec-43c9-b7bc-b035e8fe8bc1	{"action":"token_refreshed","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-02-10 10:23:12.228871+00	
00000000-0000-0000-0000-000000000000	5599f754-1c08-4513-820a-d02b2fc13475	{"action":"token_revoked","actor_id":"c7079292-56a2-427b-9cd4-154a61f65968","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-02-10 10:23:12.256213+00	
\.


--
-- TOC entry 5131 (class 0 OID 16927)
-- Dependencies: 315
-- Data for Name: flow_state; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.flow_state (id, user_id, auth_code, code_challenge_method, code_challenge, provider_type, provider_access_token, provider_refresh_token, created_at, updated_at, authentication_method, auth_code_issued_at, invite_token, referrer, oauth_client_state_id, linking_target_id, email_optional) FROM stdin;
\.


--
-- TOC entry 5122 (class 0 OID 16725)
-- Dependencies: 306
-- Data for Name: identities; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.identities (provider_id, user_id, identity_data, provider, last_sign_in_at, created_at, updated_at, id) FROM stdin;
c7079292-56a2-427b-9cd4-154a61f65968	c7079292-56a2-427b-9cd4-154a61f65968	{"sub": "c7079292-56a2-427b-9cd4-154a61f65968", "email": "cooperti.sistemas@gmail.com", "email_verified": true, "phone_verified": false}	email	2025-10-05 01:41:48.673898+00	2025-10-05 01:41:48.67453+00	2025-10-05 01:41:48.67453+00	f4727d9b-a163-4783-8870-421b02f618cd
\.


--
-- TOC entry 5116 (class 0 OID 16518)
-- Dependencies: 297
-- Data for Name: instances; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.instances (id, uuid, raw_base_config, created_at, updated_at) FROM stdin;
\.


--
-- TOC entry 5126 (class 0 OID 16814)
-- Dependencies: 310
-- Data for Name: mfa_amr_claims; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.mfa_amr_claims (session_id, created_at, updated_at, authentication_method, id) FROM stdin;
87f74328-0080-4ba1-9ad6-67dbd3836552	2025-10-05 01:42:45.607473+00	2025-10-05 01:42:45.607473+00	otp	0d27cc42-dfe5-4dea-bd96-ef8c213e33d1
9cb65583-7f80-422b-a277-54df8286b496	2025-10-05 02:37:50.299115+00	2025-10-05 02:37:50.299115+00	password	96a02e5d-49a3-4531-b956-32518a5a921d
9174e09f-3c02-48b8-8fe8-45b53371831f	2025-11-26 16:20:50.941998+00	2025-11-26 16:20:50.941998+00	password	a17f65d4-756d-4587-a414-23348b588adc
1ad799ae-3bf3-4a4c-84d5-44cfc6fe7de3	2025-11-26 22:09:03.693133+00	2025-11-26 22:09:03.693133+00	password	2c09ace9-bf6c-464a-876e-d54a4ad81ecd
267a5764-8ede-4d05-bb1f-c3b518064ac4	2025-11-28 01:28:11.017748+00	2025-11-28 01:28:11.017748+00	password	43589f2c-7437-4383-a7f1-a8532f6a7679
8ccb8679-d068-4337-88c1-127dfb5b1757	2026-01-31 18:53:20.210529+00	2026-01-31 18:53:20.210529+00	password	e443b5c7-7d15-41e4-a4db-ec486200d0b0
a93862ac-920f-42ac-9bf7-2e66363b930f	2026-01-31 18:59:19.50966+00	2026-01-31 18:59:19.50966+00	password	638ca605-43b9-4912-ae58-686fd527c58f
36dd35b3-2b64-4394-8ff4-81a867c7f21a	2026-01-31 21:44:22.930119+00	2026-01-31 21:44:22.930119+00	password	855f1076-1933-4cde-9ebc-a60ace1f0e6b
d900436c-3b92-447f-81ea-90e9b0e8dd13	2026-02-02 14:08:21.293618+00	2026-02-02 14:08:21.293618+00	password	f7d972e2-b136-4e8e-823e-0321f66d59c9
66d1608a-caec-4936-abf8-a558af756266	2026-02-02 14:31:16.966512+00	2026-02-02 14:31:16.966512+00	password	aa676e60-a694-411c-bcf8-31bdb0e2f608
58641c05-2336-4e3a-905f-3d517cc2fad8	2026-02-02 14:32:00.190739+00	2026-02-02 14:32:00.190739+00	password	664aab65-7d7b-4608-a591-d73205ad21f2
13c75f55-be4c-45b1-9ff3-b1900968fed4	2026-02-02 14:35:58.231861+00	2026-02-02 14:35:58.231861+00	password	3175b8fe-e958-4a37-944c-fb87342c2fd1
3f42ad46-d99b-4238-9773-8d3a2829e1bd	2026-02-02 14:36:55.339511+00	2026-02-02 14:36:55.339511+00	password	36b5eeb4-a7d2-483a-b438-1ff86544ce3a
429df3af-ac3a-4bbe-8d9a-d1840b6f7a9f	2026-02-02 14:51:28.275984+00	2026-02-02 14:51:28.275984+00	password	afe344fa-7a66-46e0-b367-07b749364db6
8a150aff-991a-480b-a8db-c90a61ae3c37	2026-02-02 14:52:22.603905+00	2026-02-02 14:52:22.603905+00	password	52e61e72-3a4d-4789-9e35-9b817ce0e597
5274c41f-b890-4e61-83b4-8fe8bf24cb5a	2026-02-02 14:57:46.518385+00	2026-02-02 14:57:46.518385+00	password	81c8386e-6fa4-4b59-9fe5-4ba9afa7d2ed
ac025c83-5c09-4757-af91-5a1ce88eaab3	2026-02-02 14:59:03.088126+00	2026-02-02 14:59:03.088126+00	password	edae26c2-bf16-42f6-9a3f-e56cafed0210
2d64d90e-0d62-4901-b6bc-c7eac5efb5fe	2026-02-02 16:39:51.44904+00	2026-02-02 16:39:51.44904+00	password	7ef38c8f-01a9-4f37-8d3a-86051240725b
7a432c92-7af3-4c4a-bbd6-64b1f4c271ab	2026-02-02 16:42:43.102728+00	2026-02-02 16:42:43.102728+00	password	6ecdb249-0539-44f7-bad4-709e43f41c0a
14044e63-d200-4e0c-b070-1ac42122dbd4	2026-02-02 16:43:41.810409+00	2026-02-02 16:43:41.810409+00	password	2ac49d5e-f68c-421e-836f-c9d9ffb92fdf
f345baaf-e676-426e-87ad-ddd220add89c	2026-02-02 16:46:49.091164+00	2026-02-02 16:46:49.091164+00	password	a4d01acc-b03b-4b87-a67d-d73e0cc9aefc
ae473925-e162-4165-8454-8af1e01cfec0	2026-02-02 16:53:04.387672+00	2026-02-02 16:53:04.387672+00	password	79ec6be0-6157-48ea-a552-7873919909b3
92939b35-ce78-4c73-b77e-fd6cf357802e	2026-02-02 16:58:29.651069+00	2026-02-02 16:58:29.651069+00	password	93330028-f905-4b09-a2e7-1d9049e630a7
4761524a-189a-4da5-b180-8010a1569514	2026-02-02 17:04:42.654449+00	2026-02-02 17:04:42.654449+00	password	aee1f9d2-bec3-4a96-9084-2b8544dccc19
2b519d8a-5451-420c-99a0-8dc0d1dcf2e8	2026-02-02 18:14:30.638045+00	2026-02-02 18:14:30.638045+00	password	71986a5d-5aa0-459d-8a68-03c31a462de1
eca9060c-7f66-41e3-bf78-30a2ba44536e	2026-02-02 18:31:57.442253+00	2026-02-02 18:31:57.442253+00	password	a4a9f078-d4e3-4bff-8c73-764f83c2265f
eb88c7ad-a2ff-47c1-8b7c-e374bd38281c	2026-02-02 18:32:54.292865+00	2026-02-02 18:32:54.292865+00	password	6a8b80b5-d63d-443a-8c4e-ff509101a0d0
d7eef71a-7134-41b7-8bb1-71e702e853a9	2026-02-02 18:38:06.466694+00	2026-02-02 18:38:06.466694+00	password	b9c59a21-eb96-4c7c-a3e7-ab912cc31e56
bb513d84-9604-4595-b6e3-5f8d27af7d04	2026-02-02 18:54:24.196396+00	2026-02-02 18:54:24.196396+00	password	d5a881cd-1cbc-4847-b786-bc67295af4c2
b247f0cf-a4ba-4da3-b928-af1dc6d6aead	2026-02-02 19:14:58.700456+00	2026-02-02 19:14:58.700456+00	password	86b41ee5-5c15-493c-8ea6-d1a4c04f1d6c
7b90c7de-efbc-4427-8e9a-8b9fbf21709c	2026-02-02 23:11:46.529448+00	2026-02-02 23:11:46.529448+00	password	84a0bf1a-cfbe-402e-a28b-68f5abd860b1
dcfda444-bdab-406c-87b2-2620b11f6082	2026-02-03 03:18:25.44626+00	2026-02-03 03:18:25.44626+00	password	a175cff0-95f6-4a04-af29-c95fc705856f
78a606ee-9726-423f-8f21-857813bff0bc	2026-02-04 11:33:54.53508+00	2026-02-04 11:33:54.53508+00	password	c7be1192-3d44-475f-a544-cd6b9ae874d6
930c1ffe-e534-4619-be2f-5741b517ee78	2026-02-04 17:34:58.3125+00	2026-02-04 17:34:58.3125+00	password	a27de512-d335-4b56-8df8-14fd17c36cbb
ba967492-2f8b-48a2-9dfd-20bc35de250a	2026-02-05 17:03:22.185241+00	2026-02-05 17:03:22.185241+00	password	7d0f43d3-5f04-42b7-9538-bfe5a30dbd00
aa442422-e59e-4f8a-8278-ba9affb34444	2026-02-06 11:42:17.282138+00	2026-02-06 11:42:17.282138+00	password	a5554581-244c-4634-be9c-2ff6f0036ed5
8e9de588-a847-41df-aaba-6bbd46700f57	2026-02-06 13:57:11.49381+00	2026-02-06 13:57:11.49381+00	password	3f8e80f6-d3eb-4864-9872-0d047cf9b05a
\.


--
-- TOC entry 5125 (class 0 OID 16802)
-- Dependencies: 309
-- Data for Name: mfa_challenges; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.mfa_challenges (id, factor_id, created_at, verified_at, ip_address, otp_code, web_authn_session_data) FROM stdin;
\.


--
-- TOC entry 5124 (class 0 OID 16789)
-- Dependencies: 308
-- Data for Name: mfa_factors; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.mfa_factors (id, user_id, friendly_name, factor_type, status, created_at, updated_at, secret, phone, last_challenged_at, web_authn_credential, web_authn_aaguid, last_webauthn_challenge_data) FROM stdin;
\.


--
-- TOC entry 5141 (class 0 OID 32629)
-- Dependencies: 329
-- Data for Name: oauth_authorizations; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.oauth_authorizations (id, authorization_id, client_id, user_id, redirect_uri, scope, state, resource, code_challenge, code_challenge_method, response_type, status, authorization_code, created_at, expires_at, approved_at, nonce) FROM stdin;
\.


--
-- TOC entry 5146 (class 0 OID 66768)
-- Dependencies: 334
-- Data for Name: oauth_client_states; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.oauth_client_states (id, provider_type, code_verifier, created_at) FROM stdin;
\.


--
-- TOC entry 5133 (class 0 OID 17009)
-- Dependencies: 317
-- Data for Name: oauth_clients; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.oauth_clients (id, client_secret_hash, registration_type, redirect_uris, grant_types, client_name, client_uri, logo_uri, created_at, updated_at, deleted_at, client_type, token_endpoint_auth_method) FROM stdin;
\.


--
-- TOC entry 5142 (class 0 OID 32662)
-- Dependencies: 330
-- Data for Name: oauth_consents; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.oauth_consents (id, user_id, client_id, scopes, granted_at, revoked_at) FROM stdin;
\.


--
-- TOC entry 5132 (class 0 OID 16977)
-- Dependencies: 316
-- Data for Name: one_time_tokens; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.one_time_tokens (id, user_id, token_type, token_hash, relates_to, created_at, updated_at) FROM stdin;
bd3ac0bd-3a2e-45dd-bf15-03e5ab482535	c7079292-56a2-427b-9cd4-154a61f65968	recovery_token	5c255f6b0d0287f03240e4fdb20bdd4e0e29ac327b3d06facf2f513d	cooperti.sistemas@gmail.com	2025-11-13 14:31:07.477757	2025-11-13 14:31:07.477757
\.


--
-- TOC entry 5115 (class 0 OID 16507)
-- Dependencies: 296
-- Data for Name: refresh_tokens; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.refresh_tokens (instance_id, id, token, user_id, revoked, created_at, updated_at, parent, session_id) FROM stdin;
00000000-0000-0000-0000-000000000000	78	4lps2tmyucqa	c7079292-56a2-427b-9cd4-154a61f65968	t	2025-11-28 18:53:28.896546+00	2025-11-28 21:01:21.843238+00	lncqujo66mlk	1ad799ae-3bf3-4a4c-84d5-44cfc6fe7de3
00000000-0000-0000-0000-000000000000	81	y46b3ol6brt2	c7079292-56a2-427b-9cd4-154a61f65968	f	2025-11-28 21:01:21.85591+00	2025-11-28 21:01:21.85591+00	4lps2tmyucqa	1ad799ae-3bf3-4a4c-84d5-44cfc6fe7de3
00000000-0000-0000-0000-000000000000	82	u5oz4xhfwzox	c7079292-56a2-427b-9cd4-154a61f65968	f	2026-01-31 18:53:20.168402+00	2026-01-31 18:53:20.168402+00	\N	8ccb8679-d068-4337-88c1-127dfb5b1757
00000000-0000-0000-0000-000000000000	84	2ok56k2ogpxr	c7079292-56a2-427b-9cd4-154a61f65968	t	2026-01-31 21:44:22.884596+00	2026-02-01 11:47:35.606683+00	\N	36dd35b3-2b64-4394-8ff4-81a867c7f21a
00000000-0000-0000-0000-000000000000	85	3u2xash4elky	c7079292-56a2-427b-9cd4-154a61f65968	t	2026-02-01 11:47:35.616233+00	2026-02-01 20:27:52.023107+00	2ok56k2ogpxr	36dd35b3-2b64-4394-8ff4-81a867c7f21a
00000000-0000-0000-0000-000000000000	86	uvo2djcayope	c7079292-56a2-427b-9cd4-154a61f65968	f	2026-02-01 20:27:52.046679+00	2026-02-01 20:27:52.046679+00	3u2xash4elky	36dd35b3-2b64-4394-8ff4-81a867c7f21a
00000000-0000-0000-0000-000000000000	87	cwefb6ilvjjm	c7079292-56a2-427b-9cd4-154a61f65968	f	2026-02-02 14:08:21.235491+00	2026-02-02 14:08:21.235491+00	\N	d900436c-3b92-447f-81ea-90e9b0e8dd13
00000000-0000-0000-0000-000000000000	88	tfoafiujb6zb	c7079292-56a2-427b-9cd4-154a61f65968	f	2026-02-02 14:31:16.959803+00	2026-02-02 14:31:16.959803+00	\N	66d1608a-caec-4936-abf8-a558af756266
00000000-0000-0000-0000-000000000000	89	s7ykttvbpoyi	c7079292-56a2-427b-9cd4-154a61f65968	f	2026-02-02 14:32:00.189412+00	2026-02-02 14:32:00.189412+00	\N	58641c05-2336-4e3a-905f-3d517cc2fad8
00000000-0000-0000-0000-000000000000	90	uhmai2d54alj	c7079292-56a2-427b-9cd4-154a61f65968	f	2026-02-02 14:35:58.222859+00	2026-02-02 14:35:58.222859+00	\N	13c75f55-be4c-45b1-9ff3-b1900968fed4
00000000-0000-0000-0000-000000000000	50	dqg5xnjtscpg	c7079292-56a2-427b-9cd4-154a61f65968	t	2025-11-26 22:09:03.680039+00	2025-11-26 23:08:14.937008+00	\N	1ad799ae-3bf3-4a4c-84d5-44cfc6fe7de3
00000000-0000-0000-0000-000000000000	91	tcc643to7ulb	c7079292-56a2-427b-9cd4-154a61f65968	f	2026-02-02 14:36:55.338178+00	2026-02-02 14:36:55.338178+00	\N	3f42ad46-d99b-4238-9773-8d3a2829e1bd
00000000-0000-0000-0000-000000000000	51	axf5bxfmcctp	c7079292-56a2-427b-9cd4-154a61f65968	t	2025-11-26 23:08:14.952911+00	2025-11-28 01:10:35.325885+00	dqg5xnjtscpg	1ad799ae-3bf3-4a4c-84d5-44cfc6fe7de3
00000000-0000-0000-0000-000000000000	83	ykmdwminhxke	c7079292-56a2-427b-9cd4-154a61f65968	t	2026-01-31 18:59:19.494064+00	2026-02-02 14:52:01.030995+00	\N	a93862ac-920f-42ac-9bf7-2e66363b930f
00000000-0000-0000-0000-000000000000	52	k4poykqyukhv	c7079292-56a2-427b-9cd4-154a61f65968	t	2025-11-28 01:10:35.341587+00	2025-11-28 02:10:01.881185+00	axf5bxfmcctp	1ad799ae-3bf3-4a4c-84d5-44cfc6fe7de3
00000000-0000-0000-0000-000000000000	93	qdrzvpslgyjo	c7079292-56a2-427b-9cd4-154a61f65968	f	2026-02-02 14:52:01.034873+00	2026-02-02 14:52:01.034873+00	ykmdwminhxke	a93862ac-920f-42ac-9bf7-2e66363b930f
00000000-0000-0000-0000-000000000000	53	wsewbrkqwtvq	c7079292-56a2-427b-9cd4-154a61f65968	t	2025-11-28 01:28:11.003266+00	2025-11-28 02:27:21.764175+00	\N	267a5764-8ede-4d05-bb1f-c3b518064ac4
00000000-0000-0000-0000-000000000000	94	2daxpcawmjb6	c7079292-56a2-427b-9cd4-154a61f65968	f	2026-02-02 14:52:22.601892+00	2026-02-02 14:52:22.601892+00	\N	8a150aff-991a-480b-a8db-c90a61ae3c37
00000000-0000-0000-0000-000000000000	54	77dkxkhk46uh	c7079292-56a2-427b-9cd4-154a61f65968	t	2025-11-28 02:10:01.899762+00	2025-11-28 03:08:21.741894+00	k4poykqyukhv	1ad799ae-3bf3-4a4c-84d5-44cfc6fe7de3
00000000-0000-0000-0000-000000000000	95	s2cstdaxpp6i	c7079292-56a2-427b-9cd4-154a61f65968	f	2026-02-02 14:57:46.477064+00	2026-02-02 14:57:46.477064+00	\N	5274c41f-b890-4e61-83b4-8fe8bf24cb5a
00000000-0000-0000-0000-000000000000	55	2uxqxx6h74tb	c7079292-56a2-427b-9cd4-154a61f65968	t	2025-11-28 02:27:21.778254+00	2025-11-28 03:25:23.872984+00	wsewbrkqwtvq	267a5764-8ede-4d05-bb1f-c3b518064ac4
00000000-0000-0000-0000-000000000000	92	dya26mdeupqf	c7079292-56a2-427b-9cd4-154a61f65968	t	2026-02-02 14:51:28.268684+00	2026-02-06 11:32:04.508487+00	\N	429df3af-ac3a-4bbe-8d9a-d1840b6f7a9f
00000000-0000-0000-0000-000000000000	56	47tkd3xyuk77	c7079292-56a2-427b-9cd4-154a61f65968	t	2025-11-28 03:08:21.760837+00	2025-11-28 04:21:42.413809+00	77dkxkhk46uh	1ad799ae-3bf3-4a4c-84d5-44cfc6fe7de3
00000000-0000-0000-0000-000000000000	57	xnyajlqov3p7	c7079292-56a2-427b-9cd4-154a61f65968	t	2025-11-28 03:25:23.878962+00	2025-11-28 04:23:24.494953+00	2uxqxx6h74tb	267a5764-8ede-4d05-bb1f-c3b518064ac4
00000000-0000-0000-0000-000000000000	58	vydzwahgharg	c7079292-56a2-427b-9cd4-154a61f65968	t	2025-11-28 04:21:42.424507+00	2025-11-28 05:20:56.815513+00	47tkd3xyuk77	1ad799ae-3bf3-4a4c-84d5-44cfc6fe7de3
00000000-0000-0000-0000-000000000000	59	kak5gpif66qx	c7079292-56a2-427b-9cd4-154a61f65968	t	2025-11-28 04:23:24.51396+00	2025-11-28 05:21:57.466287+00	xnyajlqov3p7	267a5764-8ede-4d05-bb1f-c3b518064ac4
00000000-0000-0000-0000-000000000000	61	suxzwisnsenh	c7079292-56a2-427b-9cd4-154a61f65968	t	2025-11-28 05:21:57.467277+00	2025-11-28 06:20:10.164032+00	kak5gpif66qx	267a5764-8ede-4d05-bb1f-c3b518064ac4
00000000-0000-0000-0000-000000000000	62	tvjv5tpf5ifn	c7079292-56a2-427b-9cd4-154a61f65968	t	2025-11-28 06:20:10.187874+00	2025-11-28 07:19:01.940032+00	suxzwisnsenh	267a5764-8ede-4d05-bb1f-c3b518064ac4
00000000-0000-0000-0000-000000000000	63	zpecharzzdnr	c7079292-56a2-427b-9cd4-154a61f65968	t	2025-11-28 07:19:01.954785+00	2025-11-28 08:19:02.07168+00	tvjv5tpf5ifn	267a5764-8ede-4d05-bb1f-c3b518064ac4
00000000-0000-0000-0000-000000000000	64	v4wa5mrup2zq	c7079292-56a2-427b-9cd4-154a61f65968	t	2025-11-28 08:19:02.084543+00	2025-11-28 09:19:02.260907+00	zpecharzzdnr	267a5764-8ede-4d05-bb1f-c3b518064ac4
00000000-0000-0000-0000-000000000000	65	htvrtq4vs7yy	c7079292-56a2-427b-9cd4-154a61f65968	t	2025-11-28 09:19:02.273013+00	2025-11-28 10:19:02.008388+00	v4wa5mrup2zq	267a5764-8ede-4d05-bb1f-c3b518064ac4
00000000-0000-0000-0000-000000000000	25	glfzpeuqaehm	c7079292-56a2-427b-9cd4-154a61f65968	f	2025-10-05 01:42:45.584356+00	2025-10-05 01:42:45.584356+00	\N	87f74328-0080-4ba1-9ad6-67dbd3836552
00000000-0000-0000-0000-000000000000	66	lnpoet6crapz	c7079292-56a2-427b-9cd4-154a61f65968	t	2025-11-28 10:19:02.02384+00	2025-11-28 11:19:02.007185+00	htvrtq4vs7yy	267a5764-8ede-4d05-bb1f-c3b518064ac4
00000000-0000-0000-0000-000000000000	26	m7lwa52ae3t7	c7079292-56a2-427b-9cd4-154a61f65968	t	2025-10-05 02:37:50.277673+00	2025-10-05 04:48:54.10347+00	\N	9cb65583-7f80-422b-a277-54df8286b496
00000000-0000-0000-0000-000000000000	27	lmitypgricmt	c7079292-56a2-427b-9cd4-154a61f65968	f	2025-10-05 04:48:54.123088+00	2025-10-05 04:48:54.123088+00	m7lwa52ae3t7	9cb65583-7f80-422b-a277-54df8286b496
00000000-0000-0000-0000-000000000000	67	qoqoaurx43hs	c7079292-56a2-427b-9cd4-154a61f65968	t	2025-11-28 11:19:02.022003+00	2025-11-28 12:19:01.988134+00	lnpoet6crapz	267a5764-8ede-4d05-bb1f-c3b518064ac4
00000000-0000-0000-0000-000000000000	68	blpedyjtxf6m	c7079292-56a2-427b-9cd4-154a61f65968	t	2025-11-28 12:19:01.997831+00	2025-11-28 13:18:08.796026+00	qoqoaurx43hs	267a5764-8ede-4d05-bb1f-c3b518064ac4
00000000-0000-0000-0000-000000000000	60	yit6iehgiboe	c7079292-56a2-427b-9cd4-154a61f65968	t	2025-11-28 05:20:56.823059+00	2025-11-28 13:20:53.528039+00	vydzwahgharg	1ad799ae-3bf3-4a4c-84d5-44cfc6fe7de3
00000000-0000-0000-0000-000000000000	69	nnxxaaazsek4	c7079292-56a2-427b-9cd4-154a61f65968	t	2025-11-28 13:18:08.808197+00	2025-11-28 14:17:01.893401+00	blpedyjtxf6m	267a5764-8ede-4d05-bb1f-c3b518064ac4
00000000-0000-0000-0000-000000000000	70	udw6nb2psmk7	c7079292-56a2-427b-9cd4-154a61f65968	t	2025-11-28 13:20:53.530137+00	2025-11-28 14:28:07.305666+00	yit6iehgiboe	1ad799ae-3bf3-4a4c-84d5-44cfc6fe7de3
00000000-0000-0000-0000-000000000000	36	n3pu7smxizha	c7079292-56a2-427b-9cd4-154a61f65968	t	2025-11-26 16:20:50.927079+00	2025-11-26 17:20:09.786555+00	\N	9174e09f-3c02-48b8-8fe8-45b53371831f
00000000-0000-0000-0000-000000000000	39	ds5b2tj43pnc	c7079292-56a2-427b-9cd4-154a61f65968	f	2025-11-26 17:20:09.794867+00	2025-11-26 17:20:09.794867+00	n3pu7smxizha	9174e09f-3c02-48b8-8fe8-45b53371831f
00000000-0000-0000-0000-000000000000	71	d3szqc7lpmng	c7079292-56a2-427b-9cd4-154a61f65968	t	2025-11-28 14:17:01.916599+00	2025-11-28 15:16:02.135946+00	nnxxaaazsek4	267a5764-8ede-4d05-bb1f-c3b518064ac4
00000000-0000-0000-0000-000000000000	72	42ucovlpr5kr	c7079292-56a2-427b-9cd4-154a61f65968	t	2025-11-28 14:28:07.315064+00	2025-11-28 15:54:25.470922+00	udw6nb2psmk7	1ad799ae-3bf3-4a4c-84d5-44cfc6fe7de3
00000000-0000-0000-0000-000000000000	73	uezfbixgnska	c7079292-56a2-427b-9cd4-154a61f65968	t	2025-11-28 15:16:02.156268+00	2025-11-28 16:15:02.078352+00	d3szqc7lpmng	267a5764-8ede-4d05-bb1f-c3b518064ac4
00000000-0000-0000-0000-000000000000	75	iibmwpci224g	c7079292-56a2-427b-9cd4-154a61f65968	t	2025-11-28 16:15:02.093249+00	2025-11-28 17:15:02.048072+00	uezfbixgnska	267a5764-8ede-4d05-bb1f-c3b518064ac4
00000000-0000-0000-0000-000000000000	76	rfwvybsd7epz	c7079292-56a2-427b-9cd4-154a61f65968	t	2025-11-28 17:15:02.0645+00	2025-11-28 18:15:02.151717+00	iibmwpci224g	267a5764-8ede-4d05-bb1f-c3b518064ac4
00000000-0000-0000-0000-000000000000	74	lncqujo66mlk	c7079292-56a2-427b-9cd4-154a61f65968	t	2025-11-28 15:54:25.481513+00	2025-11-28 18:53:28.879955+00	42ucovlpr5kr	1ad799ae-3bf3-4a4c-84d5-44cfc6fe7de3
00000000-0000-0000-0000-000000000000	77	h2dfze57fha2	c7079292-56a2-427b-9cd4-154a61f65968	t	2025-11-28 18:15:02.170183+00	2025-11-28 19:14:02.090797+00	rfwvybsd7epz	267a5764-8ede-4d05-bb1f-c3b518064ac4
00000000-0000-0000-0000-000000000000	79	gi5hjky7xoei	c7079292-56a2-427b-9cd4-154a61f65968	t	2025-11-28 19:14:02.105172+00	2025-11-28 20:14:02.163517+00	h2dfze57fha2	267a5764-8ede-4d05-bb1f-c3b518064ac4
00000000-0000-0000-0000-000000000000	80	j2q4wnk6f4mg	c7079292-56a2-427b-9cd4-154a61f65968	f	2025-11-28 20:14:02.182483+00	2025-11-28 20:14:02.182483+00	gi5hjky7xoei	267a5764-8ede-4d05-bb1f-c3b518064ac4
00000000-0000-0000-0000-000000000000	96	rvbk3zlrmdjz	c7079292-56a2-427b-9cd4-154a61f65968	t	2026-02-02 14:59:03.084698+00	2026-02-02 16:39:36.365592+00	\N	ac025c83-5c09-4757-af91-5a1ce88eaab3
00000000-0000-0000-0000-000000000000	97	i6rap22i5oeu	c7079292-56a2-427b-9cd4-154a61f65968	f	2026-02-02 16:39:36.377503+00	2026-02-02 16:39:36.377503+00	rvbk3zlrmdjz	ac025c83-5c09-4757-af91-5a1ce88eaab3
00000000-0000-0000-0000-000000000000	98	vqrjnmkvsguz	c7079292-56a2-427b-9cd4-154a61f65968	f	2026-02-02 16:39:51.447743+00	2026-02-02 16:39:51.447743+00	\N	2d64d90e-0d62-4901-b6bc-c7eac5efb5fe
00000000-0000-0000-0000-000000000000	99	ukcua5yeowe4	c7079292-56a2-427b-9cd4-154a61f65968	f	2026-02-02 16:42:43.081905+00	2026-02-02 16:42:43.081905+00	\N	7a432c92-7af3-4c4a-bbd6-64b1f4c271ab
00000000-0000-0000-0000-000000000000	100	euorzd5x3xy4	c7079292-56a2-427b-9cd4-154a61f65968	f	2026-02-02 16:43:41.808419+00	2026-02-02 16:43:41.808419+00	\N	14044e63-d200-4e0c-b070-1ac42122dbd4
00000000-0000-0000-0000-000000000000	101	lnktu3l3x47w	c7079292-56a2-427b-9cd4-154a61f65968	f	2026-02-02 16:46:49.087565+00	2026-02-02 16:46:49.087565+00	\N	f345baaf-e676-426e-87ad-ddd220add89c
00000000-0000-0000-0000-000000000000	102	phwbzj6jrgqt	c7079292-56a2-427b-9cd4-154a61f65968	f	2026-02-02 16:53:04.385549+00	2026-02-02 16:53:04.385549+00	\N	ae473925-e162-4165-8454-8af1e01cfec0
00000000-0000-0000-0000-000000000000	103	vd4agjsbxl3y	c7079292-56a2-427b-9cd4-154a61f65968	f	2026-02-02 16:58:29.641157+00	2026-02-02 16:58:29.641157+00	\N	92939b35-ce78-4c73-b77e-fd6cf357802e
00000000-0000-0000-0000-000000000000	104	2wdb65c3clyl	c7079292-56a2-427b-9cd4-154a61f65968	t	2026-02-02 17:04:42.650752+00	2026-02-02 18:05:31.603851+00	\N	4761524a-189a-4da5-b180-8010a1569514
00000000-0000-0000-0000-000000000000	105	gf2suaxfjgko	c7079292-56a2-427b-9cd4-154a61f65968	f	2026-02-02 18:05:31.613033+00	2026-02-02 18:05:31.613033+00	2wdb65c3clyl	4761524a-189a-4da5-b180-8010a1569514
00000000-0000-0000-0000-000000000000	106	idsgepfzbr75	c7079292-56a2-427b-9cd4-154a61f65968	f	2026-02-02 18:14:30.603283+00	2026-02-02 18:14:30.603283+00	\N	2b519d8a-5451-420c-99a0-8dc0d1dcf2e8
00000000-0000-0000-0000-000000000000	107	s66r4s4g2tkx	c7079292-56a2-427b-9cd4-154a61f65968	f	2026-02-02 18:31:57.425259+00	2026-02-02 18:31:57.425259+00	\N	eca9060c-7f66-41e3-bf78-30a2ba44536e
00000000-0000-0000-0000-000000000000	108	om5dtzuxpvlt	c7079292-56a2-427b-9cd4-154a61f65968	f	2026-02-02 18:32:54.29157+00	2026-02-02 18:32:54.29157+00	\N	eb88c7ad-a2ff-47c1-8b7c-e374bd38281c
00000000-0000-0000-0000-000000000000	109	fttp4gomae7u	c7079292-56a2-427b-9cd4-154a61f65968	f	2026-02-02 18:38:06.462414+00	2026-02-02 18:38:06.462414+00	\N	d7eef71a-7134-41b7-8bb1-71e702e853a9
00000000-0000-0000-0000-000000000000	110	d756zywhuzmo	c7079292-56a2-427b-9cd4-154a61f65968	f	2026-02-02 18:54:24.189019+00	2026-02-02 18:54:24.189019+00	\N	bb513d84-9604-4595-b6e3-5f8d27af7d04
00000000-0000-0000-0000-000000000000	111	u46acqer7tfk	c7079292-56a2-427b-9cd4-154a61f65968	t	2026-02-02 19:14:58.680232+00	2026-02-02 23:11:12.595042+00	\N	b247f0cf-a4ba-4da3-b928-af1dc6d6aead
00000000-0000-0000-0000-000000000000	112	kdkho2mumvs2	c7079292-56a2-427b-9cd4-154a61f65968	f	2026-02-02 23:11:12.614844+00	2026-02-02 23:11:12.614844+00	u46acqer7tfk	b247f0cf-a4ba-4da3-b928-af1dc6d6aead
00000000-0000-0000-0000-000000000000	113	p32xjzbgdwt5	c7079292-56a2-427b-9cd4-154a61f65968	t	2026-02-02 23:11:46.528014+00	2026-02-03 03:07:16.821831+00	\N	7b90c7de-efbc-4427-8e9a-8b9fbf21709c
00000000-0000-0000-0000-000000000000	114	s4nnketplfvn	c7079292-56a2-427b-9cd4-154a61f65968	t	2026-02-03 03:07:16.841484+00	2026-02-03 10:41:53.614815+00	p32xjzbgdwt5	7b90c7de-efbc-4427-8e9a-8b9fbf21709c
00000000-0000-0000-0000-000000000000	115	xdzdll53oyjv	c7079292-56a2-427b-9cd4-154a61f65968	t	2026-02-03 03:18:25.431511+00	2026-02-03 11:02:09.759467+00	\N	dcfda444-bdab-406c-87b2-2620b11f6082
00000000-0000-0000-0000-000000000000	117	g2i4wni7oifz	c7079292-56a2-427b-9cd4-154a61f65968	t	2026-02-03 11:02:09.765308+00	2026-02-03 12:02:35.644925+00	xdzdll53oyjv	dcfda444-bdab-406c-87b2-2620b11f6082
00000000-0000-0000-0000-000000000000	118	wpnjovekuy7j	c7079292-56a2-427b-9cd4-154a61f65968	t	2026-02-03 12:02:35.666856+00	2026-02-03 13:04:50.830058+00	g2i4wni7oifz	dcfda444-bdab-406c-87b2-2620b11f6082
00000000-0000-0000-0000-000000000000	119	gnlfm6nluig2	c7079292-56a2-427b-9cd4-154a61f65968	t	2026-02-03 13:04:50.846056+00	2026-02-03 14:03:27.041146+00	wpnjovekuy7j	dcfda444-bdab-406c-87b2-2620b11f6082
00000000-0000-0000-0000-000000000000	120	a4jayepd7joe	c7079292-56a2-427b-9cd4-154a61f65968	t	2026-02-03 14:03:27.048001+00	2026-02-03 15:03:40.488932+00	gnlfm6nluig2	dcfda444-bdab-406c-87b2-2620b11f6082
00000000-0000-0000-0000-000000000000	121	y2cahyn4m7fm	c7079292-56a2-427b-9cd4-154a61f65968	t	2026-02-03 15:03:40.503891+00	2026-02-03 16:01:46.005924+00	a4jayepd7joe	dcfda444-bdab-406c-87b2-2620b11f6082
00000000-0000-0000-0000-000000000000	122	5t3ci4porsqf	c7079292-56a2-427b-9cd4-154a61f65968	t	2026-02-03 16:01:46.013832+00	2026-02-03 17:00:16.165581+00	y2cahyn4m7fm	dcfda444-bdab-406c-87b2-2620b11f6082
00000000-0000-0000-0000-000000000000	123	ocfmrp2vy7qu	c7079292-56a2-427b-9cd4-154a61f65968	t	2026-02-03 17:00:16.171804+00	2026-02-03 17:58:46.119234+00	5t3ci4porsqf	dcfda444-bdab-406c-87b2-2620b11f6082
00000000-0000-0000-0000-000000000000	124	7y7onp2xadac	c7079292-56a2-427b-9cd4-154a61f65968	t	2026-02-03 17:58:46.127847+00	2026-02-04 00:36:36.469303+00	ocfmrp2vy7qu	dcfda444-bdab-406c-87b2-2620b11f6082
00000000-0000-0000-0000-000000000000	125	cgewvza6t23h	c7079292-56a2-427b-9cd4-154a61f65968	t	2026-02-04 00:36:36.493569+00	2026-02-04 01:35:02.885569+00	7y7onp2xadac	dcfda444-bdab-406c-87b2-2620b11f6082
00000000-0000-0000-0000-000000000000	126	sb6hqmsbym3t	c7079292-56a2-427b-9cd4-154a61f65968	t	2026-02-04 01:35:02.893357+00	2026-02-04 11:33:36.518256+00	cgewvza6t23h	dcfda444-bdab-406c-87b2-2620b11f6082
00000000-0000-0000-0000-000000000000	127	bvgsupvwhlze	c7079292-56a2-427b-9cd4-154a61f65968	f	2026-02-04 11:33:36.540171+00	2026-02-04 11:33:36.540171+00	sb6hqmsbym3t	dcfda444-bdab-406c-87b2-2620b11f6082
00000000-0000-0000-0000-000000000000	128	irgxsp3hzi7m	c7079292-56a2-427b-9cd4-154a61f65968	t	2026-02-04 11:33:54.533703+00	2026-02-04 12:36:47.336721+00	\N	78a606ee-9726-423f-8f21-857813bff0bc
00000000-0000-0000-0000-000000000000	129	fi7eyz5s33pt	c7079292-56a2-427b-9cd4-154a61f65968	t	2026-02-04 12:36:47.351747+00	2026-02-04 13:37:04.82753+00	irgxsp3hzi7m	78a606ee-9726-423f-8f21-857813bff0bc
00000000-0000-0000-0000-000000000000	130	xiftrv6bv6ej	c7079292-56a2-427b-9cd4-154a61f65968	t	2026-02-04 13:37:04.848711+00	2026-02-04 14:59:01.52667+00	fi7eyz5s33pt	78a606ee-9726-423f-8f21-857813bff0bc
00000000-0000-0000-0000-000000000000	131	2wymu2cok2t3	c7079292-56a2-427b-9cd4-154a61f65968	t	2026-02-04 14:59:01.535298+00	2026-02-04 17:33:17.583928+00	xiftrv6bv6ej	78a606ee-9726-423f-8f21-857813bff0bc
00000000-0000-0000-0000-000000000000	132	b7aqrmzljj4i	c7079292-56a2-427b-9cd4-154a61f65968	f	2026-02-04 17:33:17.600288+00	2026-02-04 17:33:17.600288+00	2wymu2cok2t3	78a606ee-9726-423f-8f21-857813bff0bc
00000000-0000-0000-0000-000000000000	133	ezb4yyzqkcyo	c7079292-56a2-427b-9cd4-154a61f65968	t	2026-02-04 17:34:58.309033+00	2026-02-04 18:33:06.71416+00	\N	930c1ffe-e534-4619-be2f-5741b517ee78
00000000-0000-0000-0000-000000000000	134	2dlomy345bop	c7079292-56a2-427b-9cd4-154a61f65968	t	2026-02-04 18:33:06.730272+00	2026-02-04 19:33:24.110362+00	ezb4yyzqkcyo	930c1ffe-e534-4619-be2f-5741b517ee78
00000000-0000-0000-0000-000000000000	135	x66p4rpkijof	c7079292-56a2-427b-9cd4-154a61f65968	t	2026-02-04 19:33:24.115546+00	2026-02-04 20:40:26.63355+00	2dlomy345bop	930c1ffe-e534-4619-be2f-5741b517ee78
00000000-0000-0000-0000-000000000000	136	dteqz3qo64es	c7079292-56a2-427b-9cd4-154a61f65968	t	2026-02-04 20:40:26.652502+00	2026-02-04 21:39:55.676491+00	x66p4rpkijof	930c1ffe-e534-4619-be2f-5741b517ee78
00000000-0000-0000-0000-000000000000	137	km5nyxzwlchl	c7079292-56a2-427b-9cd4-154a61f65968	t	2026-02-04 21:39:55.685352+00	2026-02-05 01:38:07.09717+00	dteqz3qo64es	930c1ffe-e534-4619-be2f-5741b517ee78
00000000-0000-0000-0000-000000000000	138	u3tjgoythiqo	c7079292-56a2-427b-9cd4-154a61f65968	t	2026-02-05 01:38:07.103442+00	2026-02-05 11:08:05.381732+00	km5nyxzwlchl	930c1ffe-e534-4619-be2f-5741b517ee78
00000000-0000-0000-0000-000000000000	139	ntg4p6bbenpg	c7079292-56a2-427b-9cd4-154a61f65968	t	2026-02-05 11:08:05.402818+00	2026-02-05 12:06:23.964743+00	u3tjgoythiqo	930c1ffe-e534-4619-be2f-5741b517ee78
00000000-0000-0000-0000-000000000000	140	xba4jwkgpqp7	c7079292-56a2-427b-9cd4-154a61f65968	t	2026-02-05 12:06:23.976232+00	2026-02-05 13:27:57.84868+00	ntg4p6bbenpg	930c1ffe-e534-4619-be2f-5741b517ee78
00000000-0000-0000-0000-000000000000	141	ujkck2pd6n2m	c7079292-56a2-427b-9cd4-154a61f65968	t	2026-02-05 13:27:57.858103+00	2026-02-05 14:52:01.917812+00	xba4jwkgpqp7	930c1ffe-e534-4619-be2f-5741b517ee78
00000000-0000-0000-0000-000000000000	142	3wymtolo67sf	c7079292-56a2-427b-9cd4-154a61f65968	t	2026-02-05 14:52:01.926824+00	2026-02-05 17:00:57.972037+00	ujkck2pd6n2m	930c1ffe-e534-4619-be2f-5741b517ee78
00000000-0000-0000-0000-000000000000	143	ms5x3af5dq5r	c7079292-56a2-427b-9cd4-154a61f65968	f	2026-02-05 17:00:57.990342+00	2026-02-05 17:00:57.990342+00	3wymtolo67sf	930c1ffe-e534-4619-be2f-5741b517ee78
00000000-0000-0000-0000-000000000000	144	hz7rmjjtjvf2	c7079292-56a2-427b-9cd4-154a61f65968	t	2026-02-05 17:03:22.163781+00	2026-02-05 18:02:15.547494+00	\N	ba967492-2f8b-48a2-9dfd-20bc35de250a
00000000-0000-0000-0000-000000000000	145	62hbs6p2or6p	c7079292-56a2-427b-9cd4-154a61f65968	t	2026-02-05 18:02:15.563332+00	2026-02-06 10:16:25.984144+00	hz7rmjjtjvf2	ba967492-2f8b-48a2-9dfd-20bc35de250a
00000000-0000-0000-0000-000000000000	146	4mufpyy4ns3o	c7079292-56a2-427b-9cd4-154a61f65968	t	2026-02-06 10:16:26.00534+00	2026-02-06 11:14:32.787309+00	62hbs6p2or6p	ba967492-2f8b-48a2-9dfd-20bc35de250a
00000000-0000-0000-0000-000000000000	116	s2sefq4weimq	c7079292-56a2-427b-9cd4-154a61f65968	t	2026-02-03 10:41:53.632354+00	2026-02-09 14:48:19.436713+00	s4nnketplfvn	7b90c7de-efbc-4427-8e9a-8b9fbf21709c
00000000-0000-0000-0000-000000000000	148	263x3ofhxqrx	c7079292-56a2-427b-9cd4-154a61f65968	f	2026-02-06 11:32:04.521043+00	2026-02-06 11:32:04.521043+00	dya26mdeupqf	429df3af-ac3a-4bbe-8d9a-d1840b6f7a9f
00000000-0000-0000-0000-000000000000	147	zaju3encsqjz	c7079292-56a2-427b-9cd4-154a61f65968	t	2026-02-06 11:14:32.79588+00	2026-02-06 12:12:32.640324+00	4mufpyy4ns3o	ba967492-2f8b-48a2-9dfd-20bc35de250a
00000000-0000-0000-0000-000000000000	149	43tqtzw62x2y	c7079292-56a2-427b-9cd4-154a61f65968	t	2026-02-06 11:42:17.244494+00	2026-02-06 13:56:46.819975+00	\N	aa442422-e59e-4f8a-8278-ba9affb34444
00000000-0000-0000-0000-000000000000	151	n3xsalurqxsy	c7079292-56a2-427b-9cd4-154a61f65968	f	2026-02-06 13:56:46.836346+00	2026-02-06 13:56:46.836346+00	43tqtzw62x2y	aa442422-e59e-4f8a-8278-ba9affb34444
00000000-0000-0000-0000-000000000000	152	eqiq6biqlimc	c7079292-56a2-427b-9cd4-154a61f65968	t	2026-02-06 13:57:11.492458+00	2026-02-06 15:15:14.337016+00	\N	8e9de588-a847-41df-aaba-6bbd46700f57
00000000-0000-0000-0000-000000000000	153	uc2nudji6fby	c7079292-56a2-427b-9cd4-154a61f65968	f	2026-02-06 15:15:14.352482+00	2026-02-06 15:15:14.352482+00	eqiq6biqlimc	8e9de588-a847-41df-aaba-6bbd46700f57
00000000-0000-0000-0000-000000000000	150	tlqk4le2cs6j	c7079292-56a2-427b-9cd4-154a61f65968	t	2026-02-06 12:12:32.659083+00	2026-02-07 15:14:45.121687+00	zaju3encsqjz	ba967492-2f8b-48a2-9dfd-20bc35de250a
00000000-0000-0000-0000-000000000000	154	d5rcxbnzp4qy	c7079292-56a2-427b-9cd4-154a61f65968	t	2026-02-07 15:14:45.1402+00	2026-02-07 16:16:05.396135+00	tlqk4le2cs6j	ba967492-2f8b-48a2-9dfd-20bc35de250a
00000000-0000-0000-0000-000000000000	155	6jlzmgt3ssuo	c7079292-56a2-427b-9cd4-154a61f65968	t	2026-02-07 16:16:05.408801+00	2026-02-07 17:14:37.203045+00	d5rcxbnzp4qy	ba967492-2f8b-48a2-9dfd-20bc35de250a
00000000-0000-0000-0000-000000000000	156	dwzrejmswurq	c7079292-56a2-427b-9cd4-154a61f65968	t	2026-02-07 17:14:37.216648+00	2026-02-07 18:15:01.491782+00	6jlzmgt3ssuo	ba967492-2f8b-48a2-9dfd-20bc35de250a
00000000-0000-0000-0000-000000000000	157	fczhjqowqrei	c7079292-56a2-427b-9cd4-154a61f65968	t	2026-02-07 18:15:01.501203+00	2026-02-07 19:13:32.62477+00	dwzrejmswurq	ba967492-2f8b-48a2-9dfd-20bc35de250a
00000000-0000-0000-0000-000000000000	158	m3rpaavmuxez	c7079292-56a2-427b-9cd4-154a61f65968	t	2026-02-07 19:13:32.646455+00	2026-02-07 21:29:09.420879+00	fczhjqowqrei	ba967492-2f8b-48a2-9dfd-20bc35de250a
00000000-0000-0000-0000-000000000000	159	4ykmonapvsug	c7079292-56a2-427b-9cd4-154a61f65968	t	2026-02-07 21:29:09.437927+00	2026-02-08 00:36:30.005292+00	m3rpaavmuxez	ba967492-2f8b-48a2-9dfd-20bc35de250a
00000000-0000-0000-0000-000000000000	160	pwcvwwlmdy2n	c7079292-56a2-427b-9cd4-154a61f65968	t	2026-02-08 00:36:30.023117+00	2026-02-08 16:22:15.078991+00	4ykmonapvsug	ba967492-2f8b-48a2-9dfd-20bc35de250a
00000000-0000-0000-0000-000000000000	161	dojypkxer5bc	c7079292-56a2-427b-9cd4-154a61f65968	t	2026-02-08 16:22:15.091729+00	2026-02-08 17:21:10.079133+00	pwcvwwlmdy2n	ba967492-2f8b-48a2-9dfd-20bc35de250a
00000000-0000-0000-0000-000000000000	162	342ad4rlkv2u	c7079292-56a2-427b-9cd4-154a61f65968	t	2026-02-08 17:21:10.092397+00	2026-02-08 19:03:56.58896+00	dojypkxer5bc	ba967492-2f8b-48a2-9dfd-20bc35de250a
00000000-0000-0000-0000-000000000000	163	j3zvyatavxt4	c7079292-56a2-427b-9cd4-154a61f65968	t	2026-02-08 19:03:56.60156+00	2026-02-09 01:52:45.119002+00	342ad4rlkv2u	ba967492-2f8b-48a2-9dfd-20bc35de250a
00000000-0000-0000-0000-000000000000	164	tjqi5gbwpaaw	c7079292-56a2-427b-9cd4-154a61f65968	t	2026-02-09 01:52:45.137197+00	2026-02-09 02:54:03.032795+00	j3zvyatavxt4	ba967492-2f8b-48a2-9dfd-20bc35de250a
00000000-0000-0000-0000-000000000000	165	hgjxpqvjqc63	c7079292-56a2-427b-9cd4-154a61f65968	t	2026-02-09 02:54:03.051455+00	2026-02-09 13:16:16.936557+00	tjqi5gbwpaaw	ba967492-2f8b-48a2-9dfd-20bc35de250a
00000000-0000-0000-0000-000000000000	167	2tf5b3loglst	c7079292-56a2-427b-9cd4-154a61f65968	f	2026-02-09 14:48:19.446242+00	2026-02-09 14:48:19.446242+00	s2sefq4weimq	7b90c7de-efbc-4427-8e9a-8b9fbf21709c
00000000-0000-0000-0000-000000000000	166	k2gbo5wwlzuz	c7079292-56a2-427b-9cd4-154a61f65968	t	2026-02-09 13:16:16.954297+00	2026-02-10 01:07:34.093131+00	hgjxpqvjqc63	ba967492-2f8b-48a2-9dfd-20bc35de250a
00000000-0000-0000-0000-000000000000	168	4p34xntp7fdc	c7079292-56a2-427b-9cd4-154a61f65968	t	2026-02-10 01:07:34.110332+00	2026-02-10 10:23:12.25767+00	k2gbo5wwlzuz	ba967492-2f8b-48a2-9dfd-20bc35de250a
00000000-0000-0000-0000-000000000000	169	n47fqilkr3ue	c7079292-56a2-427b-9cd4-154a61f65968	f	2026-02-10 10:23:12.274694+00	2026-02-10 10:23:12.274694+00	4p34xntp7fdc	ba967492-2f8b-48a2-9dfd-20bc35de250a
\.


--
-- TOC entry 5129 (class 0 OID 16856)
-- Dependencies: 313
-- Data for Name: saml_providers; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.saml_providers (id, sso_provider_id, entity_id, metadata_xml, metadata_url, attribute_mapping, created_at, updated_at, name_id_format) FROM stdin;
\.


--
-- TOC entry 5130 (class 0 OID 16874)
-- Dependencies: 314
-- Data for Name: saml_relay_states; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.saml_relay_states (id, sso_provider_id, request_id, for_email, redirect_to, created_at, updated_at, flow_state_id) FROM stdin;
\.


--
-- TOC entry 5118 (class 0 OID 16533)
-- Dependencies: 299
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.schema_migrations (version) FROM stdin;
20171026211738
20171026211808
20171026211834
20180103212743
20180108183307
20180119214651
20180125194653
00
20210710035447
20210722035447
20210730183235
20210909172000
20210927181326
20211122151130
20211124214934
20211202183645
20220114185221
20220114185340
20220224000811
20220323170000
20220429102000
20220531120530
20220614074223
20220811173540
20221003041349
20221003041400
20221011041400
20221020193600
20221021073300
20221021082433
20221027105023
20221114143122
20221114143410
20221125140132
20221208132122
20221215195500
20221215195800
20221215195900
20230116124310
20230116124412
20230131181311
20230322519590
20230402418590
20230411005111
20230508135423
20230523124323
20230818113222
20230914180801
20231027141322
20231114161723
20231117164230
20240115144230
20240214120130
20240306115329
20240314092811
20240427152123
20240612123726
20240729123726
20240802193726
20240806073726
20241009103726
20250717082212
20250731150234
20250804100000
20250901200500
20250903112500
20250904133000
20250925093508
20251007112900
20251104100000
20251111201300
20251201000000
20260115000000
20260121000000
\.


--
-- TOC entry 5123 (class 0 OID 16755)
-- Dependencies: 307
-- Data for Name: sessions; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.sessions (id, user_id, created_at, updated_at, factor_id, aal, not_after, refreshed_at, user_agent, ip, tag, oauth_client_id, refresh_token_hmac_key, refresh_token_counter, scopes) FROM stdin;
a93862ac-920f-42ac-9bf7-2e66363b930f	c7079292-56a2-427b-9cd4-154a61f65968	2026-01-31 18:59:19.486789+00	2026-02-02 14:52:01.038352+00	\N	aal1	\N	2026-02-02 14:52:01.038257	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36	168.232.24.174	\N	\N	\N	\N	\N
8a150aff-991a-480b-a8db-c90a61ae3c37	c7079292-56a2-427b-9cd4-154a61f65968	2026-02-02 14:52:22.60104+00	2026-02-02 14:52:22.60104+00	\N	aal1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36	168.232.24.174	\N	\N	\N	\N	\N
5274c41f-b890-4e61-83b4-8fe8bf24cb5a	c7079292-56a2-427b-9cd4-154a61f65968	2026-02-02 14:57:46.443946+00	2026-02-02 14:57:46.443946+00	\N	aal1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36	168.232.24.174	\N	\N	\N	\N	\N
9174e09f-3c02-48b8-8fe8-45b53371831f	c7079292-56a2-427b-9cd4-154a61f65968	2025-11-26 16:20:50.9087+00	2025-11-26 17:20:09.805669+00	\N	aal1	\N	2025-11-26 17:20:09.805039	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	138.0.69.159	\N	\N	\N	\N	\N
ac025c83-5c09-4757-af91-5a1ce88eaab3	c7079292-56a2-427b-9cd4-154a61f65968	2026-02-02 14:59:03.083299+00	2026-02-02 16:39:36.393191+00	\N	aal1	\N	2026-02-02 16:39:36.393071	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36	168.232.24.174	\N	\N	\N	\N	\N
2d64d90e-0d62-4901-b6bc-c7eac5efb5fe	c7079292-56a2-427b-9cd4-154a61f65968	2026-02-02 16:39:51.441102+00	2026-02-02 16:39:51.441102+00	\N	aal1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36	168.232.24.174	\N	\N	\N	\N	\N
7a432c92-7af3-4c4a-bbd6-64b1f4c271ab	c7079292-56a2-427b-9cd4-154a61f65968	2026-02-02 16:42:43.069254+00	2026-02-02 16:42:43.069254+00	\N	aal1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36	168.232.24.174	\N	\N	\N	\N	\N
14044e63-d200-4e0c-b070-1ac42122dbd4	c7079292-56a2-427b-9cd4-154a61f65968	2026-02-02 16:43:41.806932+00	2026-02-02 16:43:41.806932+00	\N	aal1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36	168.232.24.174	\N	\N	\N	\N	\N
f345baaf-e676-426e-87ad-ddd220add89c	c7079292-56a2-427b-9cd4-154a61f65968	2026-02-02 16:46:49.086088+00	2026-02-02 16:46:49.086088+00	\N	aal1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36	168.232.24.174	\N	\N	\N	\N	\N
ae473925-e162-4165-8454-8af1e01cfec0	c7079292-56a2-427b-9cd4-154a61f65968	2026-02-02 16:53:04.384018+00	2026-02-02 16:53:04.384018+00	\N	aal1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36	168.232.24.174	\N	\N	\N	\N	\N
92939b35-ce78-4c73-b77e-fd6cf357802e	c7079292-56a2-427b-9cd4-154a61f65968	2026-02-02 16:58:29.631712+00	2026-02-02 16:58:29.631712+00	\N	aal1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36	168.232.24.174	\N	\N	\N	\N	\N
4761524a-189a-4da5-b180-8010a1569514	c7079292-56a2-427b-9cd4-154a61f65968	2026-02-02 17:04:42.645551+00	2026-02-02 18:05:31.623189+00	\N	aal1	\N	2026-02-02 18:05:31.622428	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36	168.232.24.174	\N	\N	\N	\N	\N
2b519d8a-5451-420c-99a0-8dc0d1dcf2e8	c7079292-56a2-427b-9cd4-154a61f65968	2026-02-02 18:14:30.562285+00	2026-02-02 18:14:30.562285+00	\N	aal1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36	168.232.24.174	\N	\N	\N	\N	\N
eca9060c-7f66-41e3-bf78-30a2ba44536e	c7079292-56a2-427b-9cd4-154a61f65968	2026-02-02 18:31:57.407343+00	2026-02-02 18:31:57.407343+00	\N	aal1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36	168.232.24.174	\N	\N	\N	\N	\N
eb88c7ad-a2ff-47c1-8b7c-e374bd38281c	c7079292-56a2-427b-9cd4-154a61f65968	2026-02-02 18:32:54.290654+00	2026-02-02 18:32:54.290654+00	\N	aal1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36	168.232.24.174	\N	\N	\N	\N	\N
87f74328-0080-4ba1-9ad6-67dbd3836552	c7079292-56a2-427b-9cd4-154a61f65968	2025-10-05 01:42:45.571256+00	2025-10-05 01:42:45.571256+00	\N	aal1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0	104.28.222.134	\N	\N	\N	\N	\N
9cb65583-7f80-422b-a277-54df8286b496	c7079292-56a2-427b-9cd4-154a61f65968	2025-10-05 02:37:50.262343+00	2025-10-05 04:48:54.146419+00	\N	aal1	\N	2025-10-05 04:48:54.146313	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0	104.28.222.130	\N	\N	\N	\N	\N
267a5764-8ede-4d05-bb1f-c3b518064ac4	c7079292-56a2-427b-9cd4-154a61f65968	2025-11-28 01:28:10.987076+00	2025-11-28 20:14:02.206118+00	\N	aal1	\N	2025-11-28 20:14:02.204765	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	138.0.69.159	\N	\N	\N	\N	\N
1ad799ae-3bf3-4a4c-84d5-44cfc6fe7de3	c7079292-56a2-427b-9cd4-154a61f65968	2025-11-26 22:09:03.668335+00	2025-11-28 21:01:21.870325+00	\N	aal1	\N	2025-11-28 21:01:21.869102	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	138.0.69.159	\N	\N	\N	\N	\N
8ccb8679-d068-4337-88c1-127dfb5b1757	c7079292-56a2-427b-9cd4-154a61f65968	2026-01-31 18:53:20.143038+00	2026-01-31 18:53:20.143038+00	\N	aal1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36	168.232.24.174	\N	\N	\N	\N	\N
d7eef71a-7134-41b7-8bb1-71e702e853a9	c7079292-56a2-427b-9cd4-154a61f65968	2026-02-02 18:38:06.458285+00	2026-02-02 18:38:06.458285+00	\N	aal1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36	168.232.24.174	\N	\N	\N	\N	\N
36dd35b3-2b64-4394-8ff4-81a867c7f21a	c7079292-56a2-427b-9cd4-154a61f65968	2026-01-31 21:44:22.838656+00	2026-02-01 20:27:52.074879+00	\N	aal1	\N	2026-02-01 20:27:52.07475	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36	138.0.69.39	\N	\N	\N	\N	\N
bb513d84-9604-4595-b6e3-5f8d27af7d04	c7079292-56a2-427b-9cd4-154a61f65968	2026-02-02 18:54:24.1803+00	2026-02-02 18:54:24.1803+00	\N	aal1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36	168.232.24.174	\N	\N	\N	\N	\N
d900436c-3b92-447f-81ea-90e9b0e8dd13	c7079292-56a2-427b-9cd4-154a61f65968	2026-02-02 14:08:21.19224+00	2026-02-02 14:08:21.19224+00	\N	aal1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36	168.232.24.174	\N	\N	\N	\N	\N
66d1608a-caec-4936-abf8-a558af756266	c7079292-56a2-427b-9cd4-154a61f65968	2026-02-02 14:31:16.954851+00	2026-02-02 14:31:16.954851+00	\N	aal1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36	168.232.24.174	\N	\N	\N	\N	\N
58641c05-2336-4e3a-905f-3d517cc2fad8	c7079292-56a2-427b-9cd4-154a61f65968	2026-02-02 14:32:00.184746+00	2026-02-02 14:32:00.184746+00	\N	aal1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36	168.232.24.174	\N	\N	\N	\N	\N
13c75f55-be4c-45b1-9ff3-b1900968fed4	c7079292-56a2-427b-9cd4-154a61f65968	2026-02-02 14:35:58.217678+00	2026-02-02 14:35:58.217678+00	\N	aal1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36	168.232.24.174	\N	\N	\N	\N	\N
3f42ad46-d99b-4238-9773-8d3a2829e1bd	c7079292-56a2-427b-9cd4-154a61f65968	2026-02-02 14:36:55.337284+00	2026-02-02 14:36:55.337284+00	\N	aal1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0	168.232.24.174	\N	\N	\N	\N	\N
b247f0cf-a4ba-4da3-b928-af1dc6d6aead	c7079292-56a2-427b-9cd4-154a61f65968	2026-02-02 19:14:58.651279+00	2026-02-02 23:11:12.636387+00	\N	aal1	\N	2026-02-02 23:11:12.636287	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36	168.232.24.174	\N	\N	\N	\N	\N
aa442422-e59e-4f8a-8278-ba9affb34444	c7079292-56a2-427b-9cd4-154a61f65968	2026-02-06 11:42:17.213511+00	2026-02-06 13:56:46.851672+00	\N	aal1	\N	2026-02-06 13:56:46.851572	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0	168.232.24.174	\N	\N	\N	\N	\N
78a606ee-9726-423f-8f21-857813bff0bc	c7079292-56a2-427b-9cd4-154a61f65968	2026-02-04 11:33:54.522418+00	2026-02-04 17:33:17.620583+00	\N	aal1	\N	2026-02-04 17:33:17.620475	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36	138.0.69.39	\N	\N	\N	\N	\N
dcfda444-bdab-406c-87b2-2620b11f6082	c7079292-56a2-427b-9cd4-154a61f65968	2026-02-03 03:18:25.399104+00	2026-02-04 11:33:36.557288+00	\N	aal1	\N	2026-02-04 11:33:36.557151	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36	138.0.69.39	\N	\N	\N	\N	\N
930c1ffe-e534-4619-be2f-5741b517ee78	c7079292-56a2-427b-9cd4-154a61f65968	2026-02-04 17:34:58.295761+00	2026-02-05 17:00:58.009587+00	\N	aal1	\N	2026-02-05 17:00:58.009474	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36	138.0.69.39	\N	\N	\N	\N	\N
429df3af-ac3a-4bbe-8d9a-d1840b6f7a9f	c7079292-56a2-427b-9cd4-154a61f65968	2026-02-02 14:51:28.264891+00	2026-02-06 11:32:04.541448+00	\N	aal1	\N	2026-02-06 11:32:04.541308	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0	168.232.24.174	\N	\N	\N	\N	\N
ba967492-2f8b-48a2-9dfd-20bc35de250a	c7079292-56a2-427b-9cd4-154a61f65968	2026-02-05 17:03:22.133797+00	2026-02-10 10:23:12.301509+00	\N	aal1	\N	2026-02-10 10:23:12.300754	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36	138.0.69.97	\N	\N	\N	\N	\N
7b90c7de-efbc-4427-8e9a-8b9fbf21709c	c7079292-56a2-427b-9cd4-154a61f65968	2026-02-02 23:11:46.517384+00	2026-02-09 14:48:19.463846+00	\N	aal1	\N	2026-02-09 14:48:19.463733	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36	168.232.24.174	\N	\N	\N	\N	\N
8e9de588-a847-41df-aaba-6bbd46700f57	c7079292-56a2-427b-9cd4-154a61f65968	2026-02-06 13:57:11.470318+00	2026-02-06 15:15:14.372034+00	\N	aal1	\N	2026-02-06 15:15:14.371933	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0	168.232.24.174	\N	\N	\N	\N	\N
\.


--
-- TOC entry 5128 (class 0 OID 16841)
-- Dependencies: 312
-- Data for Name: sso_domains; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.sso_domains (id, sso_provider_id, domain, created_at, updated_at) FROM stdin;
\.


--
-- TOC entry 5127 (class 0 OID 16832)
-- Dependencies: 311
-- Data for Name: sso_providers; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.sso_providers (id, resource_id, created_at, updated_at, disabled) FROM stdin;
\.


--
-- TOC entry 5113 (class 0 OID 16495)
-- Dependencies: 294
-- Data for Name: users; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.users (instance_id, id, aud, role, email, encrypted_password, email_confirmed_at, invited_at, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user, deleted_at, is_anonymous) FROM stdin;
00000000-0000-0000-0000-000000000000	c7079292-56a2-427b-9cd4-154a61f65968	authenticated	authenticated	cooperti.sistemas@gmail.com	$2a$10$vEfdudS2lxO.LBULJnuR2.pQVV3gbl9J0G8uNrWrfC/92Bz5B2Sza	2025-10-05 01:42:45.565189+00	\N		2025-10-05 01:41:48.706787+00	5c255f6b0d0287f03240e4fdb20bdd4e0e29ac327b3d06facf2f513d	2025-11-13 14:31:05.699396+00			\N	2026-02-06 13:57:11.470231+00	{"provider": "email", "providers": ["email"]}	{"sub": "c7079292-56a2-427b-9cd4-154a61f65968", "email": "cooperti.sistemas@gmail.com", "email_verified": true, "phone_verified": false}	\N	2025-10-05 01:41:48.609135+00	2026-02-10 10:23:12.28488+00	\N	\N			\N		0	\N		\N	f	\N	f
\.


--
-- TOC entry 5179 (class 0 OID 116080)
-- Dependencies: 368
-- Data for Name: ad_clicks; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.ad_clicks (id, impression_id, campaign_id, creative_id, session_id, created_at) FROM stdin;
\.


--
-- TOC entry 5178 (class 0 OID 116046)
-- Dependencies: 367
-- Data for Name: ad_impressions; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.ad_impressions (id, site_id, campaign_id, creative_id, slot_id, session_id, page_path, viewport_visible, created_at) FROM stdin;
\.


--
-- TOC entry 5167 (class 0 OID 109121)
-- Dependencies: 355
-- Data for Name: ads_advertisers; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.ads_advertisers (id, site_id, name, contact_name, contact_email, contact_phone, status, created_at, updated_at) FROM stdin;
f82b90a5-d4a6-4198-adf1-a2f170a30639	9623f594-49ac-4b3f-a84e-19a261338229	Test Advertiser - Exclusivity	John Doe	john@example.com	\N	active	2026-01-29 13:17:16.225194+00	2026-01-29 14:15:35.237262+00
e5183f44-40a8-40a0-8122-c9c84b815eb1	9c5297ee-89af-4f6f-911a-541813232150	Internal Promo	\N	admin@urubici.com	\N	active	2026-02-07 16:04:16.469058+00	2026-02-07 16:04:16.469058+00
\.


--
-- TOC entry 5169 (class 0 OID 109159)
-- Dependencies: 357
-- Data for Name: ads_campaigns; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.ads_campaigns (id, site_id, advertiser_id, slot_id, starts_at, ends_at, status, price_cents, currency, created_at, updated_at) FROM stdin;
e2af53e0-050a-4df9-8659-cd734731ee0d	9623f594-49ac-4b3f-a84e-19a261338229	f82b90a5-d4a6-4198-adf1-a2f170a30639	ee88d8e6-b7f5-427c-b24b-b1c55a2de2a3	2026-02-01 03:00:00+00	2026-03-01 02:59:59+00	active	100000	BRL	2026-01-29 13:17:16.225194+00	2026-01-29 13:17:16.225194+00
690e3065-d8f4-4f37-a075-b18afb40c7d7	9623f594-49ac-4b3f-a84e-19a261338229	f82b90a5-d4a6-4198-adf1-a2f170a30639	ee88d8e6-b7f5-427c-b24b-b1c55a2de2a3	2026-03-01 03:00:00+00	2026-04-01 02:59:59+00	active	110000	BRL	2026-01-29 13:17:16.225194+00	2026-01-29 13:17:16.225194+00
fae81516-ca49-4978-b8dd-08f5fb94cc18	9623f594-49ac-4b3f-a84e-19a261338229	f82b90a5-d4a6-4198-adf1-a2f170a30639	ee88d8e6-b7f5-427c-b24b-b1c55a2de2a3	2026-02-10 03:00:00+00	2026-02-21 02:59:59+00	draft	90000	BRL	2026-01-29 13:17:16.225194+00	2026-01-29 13:17:16.225194+00
8e5b22c7-f467-46de-afb6-1465fda6ffe3	9623f594-49ac-4b3f-a84e-19a261338229	f82b90a5-d4a6-4198-adf1-a2f170a30639	ee88d8e6-b7f5-427c-b24b-b1c55a2de2a3	2026-02-05 03:00:00+00	2026-02-26 02:59:59+00	paused	95000	BRL	2026-01-29 13:17:16.225194+00	2026-01-29 13:17:16.225194+00
d47b058d-f1f5-42e1-bf68-b808d18a37f4	9623f594-49ac-4b3f-a84e-19a261338229	f82b90a5-d4a6-4198-adf1-a2f170a30639	8557c0b5-c938-4ca5-9d5f-740569b32155	2026-02-01 03:00:00+00	2026-03-01 02:59:59+00	active	80000	BRL	2026-01-29 13:17:16.225194+00	2026-01-29 13:17:16.225194+00
07f06561-b733-48ce-8f0f-dcb71fe64d4a	9623f594-49ac-4b3f-a84e-19a261338229	f82b90a5-d4a6-4198-adf1-a2f170a30639	ee88d8e6-b7f5-427c-b24b-b1c55a2de2a3	2026-02-10 03:00:00+00	2026-02-21 02:59:59+00	draft	90000	BRL	2026-01-29 14:15:35.237262+00	2026-01-29 14:15:35.237262+00
fa99957b-4d30-4cd7-bc48-8b4bdfec776b	9623f594-49ac-4b3f-a84e-19a261338229	f82b90a5-d4a6-4198-adf1-a2f170a30639	ee88d8e6-b7f5-427c-b24b-b1c55a2de2a3	2026-02-05 03:00:00+00	2026-02-26 02:59:59+00	paused	95000	BRL	2026-01-29 14:15:35.237262+00	2026-01-29 14:15:35.237262+00
\.


--
-- TOC entry 5170 (class 0 OID 109189)
-- Dependencies: 358
-- Data for Name: ads_creatives; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.ads_creatives (id, campaign_id, media_id, title, cta_text, target_url, is_active, created_at, updated_at) FROM stdin;
7ff09ed0-54d2-4502-a0ec-bf0d2eb43bfd	e2af53e0-050a-4df9-8659-cd734731ee0d	\N	Creative 1	\N	https://example.com/1	t	2026-01-29 15:16:30.336541+00	2026-01-29 15:16:30.336541+00
\.


--
-- TOC entry 5168 (class 0 OID 109140)
-- Dependencies: 356
-- Data for Name: ads_slots; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.ads_slots (id, site_id, key, placement, size_hint, is_active, created_at, updated_at) FROM stdin;
ee88d8e6-b7f5-427c-b24b-b1c55a2de2a3	9623f594-49ac-4b3f-a84e-19a261338229	home_hero	Hero principal da home	1200x600	t	2026-01-29 13:08:48.808008+00	2026-01-29 13:08:48.808008+00
8557c0b5-c938-4ca5-9d5f-740569b32155	9623f594-49ac-4b3f-a84e-19a261338229	home_mid	Meio da home	728x90	t	2026-01-29 13:08:48.808008+00	2026-01-29 13:08:48.808008+00
1d143690-fd5d-403e-945b-1c07da2a4929	9623f594-49ac-4b3f-a84e-19a261338229	places_list_top	Topo da lista de atrativos	970x250	t	2026-01-29 13:08:48.808008+00	2026-01-29 13:08:48.808008+00
03c7114d-cbd8-48c3-b96c-c0735b212432	9623f594-49ac-4b3f-a84e-19a261338229	place_detail_sidebar	Sidebar do detalhe do atrativo	300x600	t	2026-01-29 13:08:48.808008+00	2026-01-29 13:08:48.808008+00
a5c70839-6bfc-4cd6-8926-77fd1b3f5811	9623f594-49ac-4b3f-a84e-19a261338229	blog_list_top	Topo da lista de posts	728x90	t	2026-01-29 13:08:48.808008+00	2026-01-29 13:08:48.808008+00
ec806e01-7d2a-449e-a42c-90d9de646c91	9623f594-49ac-4b3f-a84e-19a261338229	events_list_top	Topo da agenda de eventos	970x250	t	2026-01-29 13:08:48.808008+00	2026-01-29 13:08:48.808008+00
8aab17de-12ec-4162-af75-9f2487ba706c	91aac245-fdfa-485f-ad88-d4fa7f70d13d	home_hero	Hero principal da home	1200x600	t	2026-01-29 13:08:48.808008+00	2026-01-29 13:08:48.808008+00
972626e9-e664-4259-984e-77860ebf4f02	91aac245-fdfa-485f-ad88-d4fa7f70d13d	home_mid	Meio da home	728x90	t	2026-01-29 13:08:48.808008+00	2026-01-29 13:08:48.808008+00
d8287892-5b33-485e-aa01-734584035cbf	91aac245-fdfa-485f-ad88-d4fa7f70d13d	places_list_top	Topo da lista de atrativos	970x250	t	2026-01-29 13:08:48.808008+00	2026-01-29 13:08:48.808008+00
84e889cb-0d9a-4be1-91b8-fab5aee13f70	91aac245-fdfa-485f-ad88-d4fa7f70d13d	place_detail_sidebar	Sidebar do detalhe do atrativo	300x600	t	2026-01-29 13:08:48.808008+00	2026-01-29 13:08:48.808008+00
faaab1d3-f497-452a-bd90-23c2b2f12405	91aac245-fdfa-485f-ad88-d4fa7f70d13d	blog_list_top	Topo da lista de posts	728x90	t	2026-01-29 13:08:48.808008+00	2026-01-29 13:08:48.808008+00
8ab71fdb-de18-40e5-8387-0c25a47fd759	91aac245-fdfa-485f-ad88-d4fa7f70d13d	events_list_top	Topo da agenda de eventos	970x250	t	2026-01-29 13:08:48.808008+00	2026-01-29 13:08:48.808008+00
bdc32dfb-cdcf-4ae9-ba16-6c53e18f715e	9c5297ee-89af-4f6f-911a-541813232150	home_hero	Hero principal da home	1200x600	t	2026-01-29 13:08:48.808008+00	2026-01-29 13:08:48.808008+00
111b3729-036f-49fc-b933-32bdf75a8c7f	9c5297ee-89af-4f6f-911a-541813232150	home_mid	Meio da home	728x90	t	2026-01-29 13:08:48.808008+00	2026-01-29 13:08:48.808008+00
bc033ae6-e95c-448d-b875-b280490d164d	9c5297ee-89af-4f6f-911a-541813232150	places_list_top	Topo da lista de atrativos	970x250	t	2026-01-29 13:08:48.808008+00	2026-01-29 13:08:48.808008+00
caac8da0-2bc2-40ce-a4ce-17f833e9a59a	9c5297ee-89af-4f6f-911a-541813232150	place_detail_sidebar	Sidebar do detalhe do atrativo	300x600	t	2026-01-29 13:08:48.808008+00	2026-01-29 13:08:48.808008+00
dd78d648-06d9-4b37-bcdd-4ad682e14724	9c5297ee-89af-4f6f-911a-541813232150	blog_list_top	Topo da lista de posts	728x90	t	2026-01-29 13:08:48.808008+00	2026-01-29 13:08:48.808008+00
5b93668d-8ec9-449f-a75e-065dca2b177a	9c5297ee-89af-4f6f-911a-541813232150	events_list_top	Topo da agenda de eventos	970x250	t	2026-01-29 13:08:48.808008+00	2026-01-29 13:08:48.808008+00
\.


--
-- TOC entry 5164 (class 0 OID 106734)
-- Dependencies: 352
-- Data for Name: api_keys; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.api_keys (id, name, site_id, scopes, key_hash, is_active, created_by, created_at, last_used_at, expires_at) FROM stdin;
\.


--
-- TOC entry 5163 (class 0 OID 106708)
-- Dependencies: 351
-- Data for Name: audit_logs; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.audit_logs (id, occurred_at, category, severity, result, actor_user_id, site_id, action, entity_type, entity_id, ip, user_agent, metadata) FROM stdin;
\.


--
-- TOC entry 5173 (class 0 OID 112465)
-- Dependencies: 362
-- Data for Name: event_categories; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.event_categories (id, site_id, name, color, sort_order, is_active, created_at, updated_at) FROM stdin;
8bc5e045-95dc-43d6-bb1d-b1ea39d025f4	9c5297ee-89af-4f6f-911a-541813232150	Workshop	#10B981	1	t	2026-02-04 12:56:22.874864+00	2026-02-04 12:56:22.874864+00
b5240e1a-6573-44fe-8d75-d3ffead18d9c	91aac245-fdfa-485f-ad88-d4fa7f70d13d	Workshop	#10B981	1	t	2026-02-04 12:56:22.874864+00	2026-02-04 12:56:22.874864+00
4eaa31ca-b3fc-4ef3-9369-be9a8dbf7301	9623f594-49ac-4b3f-a84e-19a261338229	Workshop	#10B981	1	t	2026-02-04 12:56:22.874864+00	2026-02-04 12:56:22.874864+00
45068081-e8ae-4f5f-b06b-50d5889addaa	010f3e62-feb2-4a65-8d09-0f698388d26f	Workshop	#10B981	1	t	2026-02-04 12:56:22.874864+00	2026-02-04 12:56:22.874864+00
6ba85230-bf33-409e-823f-d32d338cc139	9c5297ee-89af-4f6f-911a-541813232150	Palestra	#3B82F6	2	t	2026-02-04 12:56:22.874864+00	2026-02-04 12:56:22.874864+00
69e10473-c2a2-4849-af06-866bd0871891	91aac245-fdfa-485f-ad88-d4fa7f70d13d	Palestra	#3B82F6	2	t	2026-02-04 12:56:22.874864+00	2026-02-04 12:56:22.874864+00
1bcc6b07-cd25-4c83-b8d3-17c2618cde53	9623f594-49ac-4b3f-a84e-19a261338229	Palestra	#3B82F6	2	t	2026-02-04 12:56:22.874864+00	2026-02-04 12:56:22.874864+00
a11e7ca6-2116-4fb5-88fa-5a3b61a32e50	010f3e62-feb2-4a65-8d09-0f698388d26f	Palestra	#3B82F6	2	t	2026-02-04 12:56:22.874864+00	2026-02-04 12:56:22.874864+00
b1086b2b-02e5-40b4-8895-69614cada4e4	9c5297ee-89af-4f6f-911a-541813232150	Conferência	#8B5CF6	3	t	2026-02-04 12:56:22.874864+00	2026-02-04 12:56:22.874864+00
2b59c6e9-a6d4-4f33-bafe-7564c5551ac8	91aac245-fdfa-485f-ad88-d4fa7f70d13d	Conferência	#8B5CF6	3	t	2026-02-04 12:56:22.874864+00	2026-02-04 12:56:22.874864+00
35f06da7-e1b9-4523-8677-b63c43c735ed	9623f594-49ac-4b3f-a84e-19a261338229	Conferência	#8B5CF6	3	t	2026-02-04 12:56:22.874864+00	2026-02-04 12:56:22.874864+00
3fd0f4bb-787c-4eea-8ffc-3470e15c6d9a	010f3e62-feb2-4a65-8d09-0f698388d26f	Conferência	#8B5CF6	3	t	2026-02-04 12:56:22.874864+00	2026-02-04 12:56:22.874864+00
28267cde-7b67-40fa-af59-b7acd2681e89	9c5297ee-89af-4f6f-911a-541813232150	Meetup	#F59E0B	4	t	2026-02-04 12:56:22.874864+00	2026-02-04 12:56:22.874864+00
96faa82f-a500-46aa-84f8-d061a5c05f88	91aac245-fdfa-485f-ad88-d4fa7f70d13d	Meetup	#F59E0B	4	t	2026-02-04 12:56:22.874864+00	2026-02-04 12:56:22.874864+00
2646a209-f206-42c9-b252-8e6248a73633	9623f594-49ac-4b3f-a84e-19a261338229	Meetup	#F59E0B	4	t	2026-02-04 12:56:22.874864+00	2026-02-04 12:56:22.874864+00
92105f14-3605-4aa3-9da4-bf4b13e0ddb2	010f3e62-feb2-4a65-8d09-0f698388d26f	Meetup	#F59E0B	4	t	2026-02-04 12:56:22.874864+00	2026-02-04 12:56:22.874864+00
bb9c69de-dde9-4d53-b377-4d1c36181b98	9c5297ee-89af-4f6f-911a-541813232150	Congresso	#EF4444	5	t	2026-02-04 12:56:22.874864+00	2026-02-04 12:56:22.874864+00
99213f56-8e51-4316-892d-09698be2b0b4	91aac245-fdfa-485f-ad88-d4fa7f70d13d	Congresso	#EF4444	5	t	2026-02-04 12:56:22.874864+00	2026-02-04 12:56:22.874864+00
04426f16-84ca-475b-83cc-3acad469dc54	9623f594-49ac-4b3f-a84e-19a261338229	Congresso	#EF4444	5	t	2026-02-04 12:56:22.874864+00	2026-02-04 12:56:22.874864+00
1ea1a426-e756-49c2-945b-a5cbcd22e2f7	010f3e62-feb2-4a65-8d09-0f698388d26f	Congresso	#EF4444	5	t	2026-02-04 12:56:22.874864+00	2026-02-04 12:56:22.874864+00
\.


--
-- TOC entry 5156 (class 0 OID 106533)
-- Dependencies: 344
-- Data for Name: events; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.events (id, site_id, status, slug, title_i18n, summary_i18n, body_i18n, start_at, end_at, all_day, location_name, address_line, city, state, lat, lng, primary_media_id, source_name, source_url, created_at, updated_at, organizer_name, category_id, country, postal_code, meta, cover_url) FROM stdin;
22e7cc15-f6ec-4b26-85ff-ec0dfa72bcdc	9623f594-49ac-4b3f-a84e-19a261338229	published	festival-inverno-urubici	{"en": "Winter Festival (example)", "es": "Festival de Invierno (ejemplo)", "pt": "Festival de Inverno (exemplo)"}	{"en": "Cultural program and gastronomy.", "es": "Programación cultural y gastronomía.", "pt": "Programação cultural e gastronomia."}	\N	2026-02-04 14:53:40.985486+00	2026-02-04 17:53:40.985486+00	f	Centro da Cidade	\N	Urubici	SC	\N	\N	\N	\N	\N	2026-01-25 14:53:40.985486+00	2026-01-25 14:53:40.985486+00	\N	\N	\N	\N	{}	\N
322f9aab-7b8a-41f7-897e-8f19688aa3e6	9c5297ee-89af-4f6f-911a-541813232150	published	agenda-semanal-urubici	{"en": "Weekly agenda — Urubici", "es": "Agenda semanal — Urubici", "pt": "Agenda semanal — Urubici"}	{"en": "A baseline event to validate list and detail.", "es": "Un evento base para validar lista y detalle.", "pt": "Um evento-base para validar listagem e detalhe."}	{"en": "Initial baseline event so the portal launches alive.", "es": "Evento inicial para que el portal nazca con vida.", "pt": "Evento inicial (baseline) para o portal já nascer com vida."}	2026-02-03 14:11:07.611982+00	2026-02-03 16:11:07.611982+00	f	Centro de Urubici	\N	Urubici	SC	\N	\N	\N	\N	\N	2026-01-27 13:56:47.655831+00	2026-01-27 14:11:07.611982+00	Portal Urubici	\N	BR	\N	{"seo": {"category": "eventos"}}	\N
2bfbda27-c061-4435-b494-b71a34702785	9c5297ee-89af-4f6f-911a-541813232150	published	festival-inverno-urubici	{"pt": "Festival de Inverno 2026"}	{"pt": "Musica, gastronomia e artesanato regional."}	{"pt": "Programacao completa no centro da cidade."}	2026-02-18 19:22:34.881947+00	2026-02-20 19:22:34.881947+00	f	Praca Central	\N	Urubici	SC	\N	\N	\N	\N	\N	2026-02-06 19:22:34.881947+00	2026-02-06 19:22:34.881947+00	\N	\N	BR	\N	{"tag": "Cultura"}	\N
d96ce57b-3ff4-4b5c-9d50-d04f2b9ff42d	9c5297ee-89af-4f6f-911a-541813232150	published	maratona-altitude	{"pt": "Maratona de Altitude"}	{"pt": "Percurso com vistas da Serra do Corvo Branco."}	{"pt": "Largada no Parque do Avencal."}	2026-02-24 19:22:34.881947+00	2026-02-25 19:22:34.881947+00	f	Parque do Avencal	\N	Urubici	SC	\N	\N	\N	\N	\N	2026-02-06 19:22:34.881947+00	2026-02-06 19:22:34.881947+00	\N	\N	BR	\N	{"tag": "Esporte"}	\N
a65e8173-7d52-449a-831b-7064142ba3d7	9c5297ee-89af-4f6f-911a-541813232150	published	feira-sabores-serra	{"pt": "Feira Sabores da Serra"}	{"pt": "Produtores locais e degustacoes de vinhos."}	{"pt": "Evento com harmonizacao e cozinha regional."}	2026-03-02 19:22:34.881947+00	2026-03-03 19:22:34.881947+00	f	Mercado Municipal	\N	Urubici	SC	\N	\N	\N	\N	\N	2026-02-06 19:22:34.881947+00	2026-02-06 19:22:34.881947+00	\N	\N	BR	\N	{"tag": "Gastronomia"}	\N
529a9546-11a8-4425-bcb6-cf88ea253fe1	9c5297ee-89af-4f6f-911a-541813232150	published	circuito-trilhas-noturnas	{"pt": "Circuito de Trilhas Noturnas"}	{"pt": "Experiencia guiada com observacao do ceu."}	{"pt": "Saida com guias credenciados."}	2026-03-08 19:22:34.881947+00	2026-03-09 19:22:34.881947+00	f	Morro da Igreja	\N	Urubici	SC	\N	\N	\N	\N	\N	2026-02-06 19:22:34.881947+00	2026-02-06 19:22:34.881947+00	\N	\N	BR	\N	{"tag": "Natureza"}	\N
708ea5eb-b74f-4ee8-b684-c69cf001891c	9c5297ee-89af-4f6f-911a-541813232150	published	encontro-fotografia-serra	{"pt": "Encontro de Fotografia da Serra"}	{"pt": "Workshops e saias fotograficas ao amanhecer."}	{"pt": "Instrutores convidados e roteiros exclusivos."}	2026-03-14 19:22:34.881947+00	2026-03-16 19:22:34.881947+00	f	Mirante do Morro	\N	Urubici	SC	\N	\N	\N	\N	\N	2026-02-06 19:22:34.881947+00	2026-02-06 19:22:34.881947+00	\N	\N	BR	\N	{"tag": "Fotografia"}	\N
62d6abf6-f352-4f25-9776-b3095b81d8f2	9c5297ee-89af-4f6f-911a-541813232150	published	semana-rotas-inteligentes	{"pt": "Semana de Rotas Inteligentes"}	{"pt": "Tecnologia e turismo de experiencia."}	{"pt": "Palestras e demos de mobilidade."}	2026-03-20 19:22:34.881947+00	2026-03-22 19:22:34.881947+00	f	Centro de Eventos	\N	Urubici	SC	\N	\N	\N	\N	\N	2026-02-06 19:22:34.881947+00	2026-02-06 19:22:34.881947+00	\N	\N	BR	\N	{"tag": "Inovacao"}	\N
\.


--
-- TOC entry 5174 (class 0 OID 114742)
-- Dependencies: 363
-- Data for Name: hero_banners; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.hero_banners (id, site_id, title_i18n, subtitle_i18n, cta_label_i18n, cta_url, target_view, kind, primary_media_id, sort_order, starts_at, ends_at, is_active, meta, created_at, updated_at) FROM stdin;
93cfd0b2-7074-42ff-b42f-ec48af66aeae	91aac245-fdfa-485f-ad88-d4fa7f70d13d	{"pt": "Destaques da Serra"}	{"pt": "Explore atrativos e rotas inteligentes"}	{"pt": "Ver atrativos"}	\N	experiences	editorial	\N	1	\N	\N	t	\N	2026-02-06 11:38:49.084114+00	2026-02-06 11:38:49.084114+00
5d75ca69-fa45-4927-90a6-e5106ee96d2d	91aac245-fdfa-485f-ad88-d4fa7f70d13d	{"pt": "Agenda Cultural"}	{"pt": "Eventos e experiencias em tempo real"}	{"pt": "Ver eventos"}	\N	events	editorial	\N	2	\N	\N	t	\N	2026-02-06 11:38:49.084114+00	2026-02-06 11:38:49.084114+00
5cbb060f-fb4c-4f6c-a252-f7151478df79	91aac245-fdfa-485f-ad88-d4fa7f70d13d	{"pt": "Noticias e Atualizacoes"}	{"pt": "Acompanhe novidades do portal"}	{"pt": "Ler noticias"}	\N	news	editorial	\N	3	\N	\N	t	\N	2026-02-06 11:38:49.084114+00	2026-02-06 11:38:49.084114+00
2c11e8ac-7baa-4163-b82d-afcc2ddc969e	9623f594-49ac-4b3f-a84e-19a261338229	{"pt": "Destaques da Serra"}	{"pt": "Explore atrativos e rotas inteligentes"}	{"pt": "Ver atrativos"}	\N	experiences	editorial	\N	1	\N	\N	t	\N	2026-02-06 11:38:49.084114+00	2026-02-06 11:38:49.084114+00
ce4c44a7-eb99-487e-8812-181d8c4e87a1	9623f594-49ac-4b3f-a84e-19a261338229	{"pt": "Agenda Cultural"}	{"pt": "Eventos e experiencias em tempo real"}	{"pt": "Ver eventos"}	\N	events	editorial	\N	2	\N	\N	t	\N	2026-02-06 11:38:49.084114+00	2026-02-06 11:38:49.084114+00
67d28eb1-679f-4eea-89e4-3bb65afa7e6f	9623f594-49ac-4b3f-a84e-19a261338229	{"pt": "Noticias e Atualizacoes"}	{"pt": "Acompanhe novidades do portal"}	{"pt": "Ler noticias"}	\N	news	editorial	\N	3	\N	\N	t	\N	2026-02-06 11:38:49.084114+00	2026-02-06 11:38:49.084114+00
b3e06a59-6726-44d7-92e4-271f4b1af506	010f3e62-feb2-4a65-8d09-0f698388d26f	{"pt": "Destaques da Serra"}	{"pt": "Explore atrativos e rotas inteligentes"}	{"pt": "Ver atrativos"}	\N	experiences	editorial	\N	1	\N	\N	t	\N	2026-02-06 11:38:49.084114+00	2026-02-06 11:38:49.084114+00
78c27dbf-ffc0-4553-9b70-a7f7f599c923	010f3e62-feb2-4a65-8d09-0f698388d26f	{"pt": "Agenda Cultural"}	{"pt": "Eventos e experiencias em tempo real"}	{"pt": "Ver eventos"}	\N	events	editorial	\N	2	\N	\N	t	\N	2026-02-06 11:38:49.084114+00	2026-02-06 11:38:49.084114+00
6b50bab7-7e0d-496f-86ad-3efc72a58634	010f3e62-feb2-4a65-8d09-0f698388d26f	{"pt": "Noticias e Atualizacoes"}	{"pt": "Acompanhe novidades do portal"}	{"pt": "Ler noticias"}	\N	news	editorial	\N	3	\N	\N	t	\N	2026-02-06 11:38:49.084114+00	2026-02-06 11:38:49.084114+00
6d701980-c6ff-4e5b-8072-d0160278b7aa	9c5297ee-89af-4f6f-911a-541813232150	{"pt": "Destaques da Serra"}	{"pt": "Explore atrativos e rotas inteligentes"}	{"pt": "Ver atrativos"}	\N	experiences	editorial	81b4cb34-75ca-4814-bb54-b659ce780b94	5	\N	\N	t	\N	2026-02-06 11:38:49.084114+00	2026-02-06 18:30:39.795315+00
0a27e80f-de44-4fd7-a76d-85774c7f1f00	9c5297ee-89af-4f6f-911a-541813232150	{"pt": "Agenda Cultural"}	{"pt": "Eventos e experiencias em tempo real"}	{"pt": "Ver eventos"}	\N	events	editorial	ad3cd9ce-c5a5-4f2d-b8b2-111c34bf51cd	6	\N	\N	t	\N	2026-02-06 11:38:49.084114+00	2026-02-06 18:30:39.795315+00
fd9c4083-e2d3-46f7-8d05-bc6fa778e958	9c5297ee-89af-4f6f-911a-541813232150	{"pt": "Noticias e Atualizacoes"}	{"pt": "Acompanhe novidades do portal"}	{"pt": "Ler noticias"}	\N	news	editorial	34af8b39-7520-4374-ac83-18024c71a940	3	\N	\N	t	\N	2026-02-06 11:38:49.084114+00	2026-02-06 18:30:39.795315+00
4a33bf4b-dd04-46bc-b991-ca7a98a0a2fe	9c5297ee-89af-4f6f-911a-541813232150	{"pt": "Agenda de Eventos"}	{"pt": "Experiencias e eventos em tempo real"}	{"pt": "Ver eventos"}	\N	events	editorial	c25d0c11-743c-44af-948a-7c44e7fc7406	2	\N	\N	t	\N	2026-02-06 14:20:02.339393+00	2026-02-06 18:30:39.795315+00
847408c6-2fa1-430e-8390-5753f65b5460	9c5297ee-89af-4f6f-911a-541813232150	{"pt": "Blog da Serra"}	{"pt": "Guias e historias sobre Urubici"}	{"pt": "Ler blog"}	\N	blog	editorial	50da0c67-d5c8-460f-af70-f84393bdbdad	4	\N	\N	t	\N	2026-02-06 14:20:02.339393+00	2026-02-06 18:30:39.795315+00
9def18db-7d28-48a2-9700-c0f6e0c96949	9c5297ee-89af-4f6f-911a-541813232150	{"pt": "Destaques de Urubici"}	{"pt": "Explore atracoes e roteiros inteligentes"}	{"pt": "Ver atracoes"}	\N	experiences	editorial	f80ff615-775e-4b29-a8da-043450a68332	1	\N	\N	t	\N	2026-02-06 14:20:02.339393+00	2026-02-06 18:30:39.795315+00
\.


--
-- TOC entry 5175 (class 0 OID 115927)
-- Dependencies: 364
-- Data for Name: import_batches; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.import_batches (id, source, category, total_items, items_staged, items_approved, items_rejected, quality_score_avg, imported_by, notes, created_at, completed_at) FROM stdin;
e9dc6bb0-b9d3-4d95-a02c-8f54b06dea3b	wikipedia	attraction	18	18	0	0	\N	\N	Atrações Wikipedia - 2026-02-07	2026-02-07 08:36:23.470513+00	2026-02-07 08:36:23.470513+00
0ce344c8-bd92-4b6f-b1ac-29a405b882a3	agent_autonomo	restaurant	10	10	0	0	\N	\N	Restaurantes - Agente Autônomo	2026-02-07 08:55:16.193766+00	2026-02-07 08:55:16.193766+00
bcefcee8-0993-482b-8825-77fd6b39fd5f	agent_autonomo	lodging	10	10	0	0	\N	\N	Hospedagens - Agente Autônomo	2026-02-07 08:55:16.193766+00	2026-02-07 08:55:16.193766+00
d9474168-7310-4b1e-a125-1e46a38c2a4b	agent_autonomo	restaurant	10	10	0	0	\N	\N	Restaurantes - Agente Autônomo	2026-02-07 09:04:46.545361+00	\N
d142b0a5-fd36-49f8-979a-e467326f36af	agent_autonomo	lodging	10	10	0	0	\N	\N	Hospedagens - Agente Autônomo	2026-02-07 09:05:06.122465+00	\N
8bd9f727-e8d3-453d-b43b-8d1fc0fbe715	agent_autonomo	restaurant	10	10	0	0	\N	\N	Restaurantes - Agente Autônomo	2026-02-07 09:06:53.675339+00	\N
aaa613a5-8349-4e8c-88bb-df90fefedb20	agent_autonomo	medical	10	10	0	0	\N	\N	Guia Médico - Agente Autônomo	2026-02-07 09:10:39.807896+00	2026-02-07 09:10:39.807896+00
\.


--
-- TOC entry 5154 (class 0 OID 106435)
-- Dependencies: 342
-- Data for Name: media; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.media (id, site_id, kind, storage_path, public_url, alt_i18n, caption_i18n, owner_type, owner_id, sort_order, is_active, created_at, updated_at) FROM stdin;
c25d0c11-743c-44af-948a-7c44e7fc7406	9c5297ee-89af-4f6f-911a-541813232150	image	seed/hero/urubici/eventos.jpg	https://images.unsplash.com/photo-1469474968028-56623f02e42e?auto=format&fit=crop&w=1600&q=80	{"pt": "Eventos em destaque"}	{"pt": "Agenda cultural e experiencias"}	site	9c5297ee-89af-4f6f-911a-541813232150	2	t	2026-02-06 14:20:02.339393+00	2026-02-06 14:20:02.339393+00
50da0c67-d5c8-460f-af70-f84393bdbdad	9c5297ee-89af-4f6f-911a-541813232150	image	seed/hero/urubici/blog.jpg	https://images.unsplash.com/photo-1456324504439-367cee3b3c32?auto=format&fit=crop&w=1600&q=80	{"pt": "Blog e historias locais"}	{"pt": "Conteudos premium sobre Urubici"}	site	9c5297ee-89af-4f6f-911a-541813232150	4	t	2026-02-06 14:20:02.339393+00	2026-02-06 14:20:02.339393+00
34af8b39-7520-4374-ac83-18024c71a940	9c5297ee-89af-4f6f-911a-541813232150	image	seed/hero/urubici/noticias.jpg	https://images.unsplash.com/photo-1524995997946-a1c2e315a42f?auto=format&fit=crop&w=1600&q=80	{"pt": "Noticias e atualizacoes"}	{"pt": "Novidades do portal"}	site	9c5297ee-89af-4f6f-911a-541813232150	3	t	2026-02-06 14:20:02.339393+00	2026-02-06 14:20:02.339393+00
f80ff615-775e-4b29-a8da-043450a68332	9c5297ee-89af-4f6f-911a-541813232150	image	seed/hero/urubici/atracoes.jpg	https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?auto=format&fit=crop&w=1600&q=80	{"pt": "Atracoes em Urubici"}	{"pt": "Atracoes e roteiros inteligentes"}	site	9c5297ee-89af-4f6f-911a-541813232150	1	t	2026-02-06 14:20:02.339393+00	2026-02-06 14:20:02.339393+00
81b4cb34-75ca-4814-bb54-b659ce780b94	9c5297ee-89af-4f6f-911a-541813232150	image	seed/hero/urubici/serra.jpg	https://images.unsplash.com/photo-1469474968028-56623f02e42e?auto=format&fit=crop&w=1600&q=80	{"pt": "Serra e canions de Urubici"}	{"pt": "Paisagens com neblina e altitude"}	site	9c5297ee-89af-4f6f-911a-541813232150	5	t	2026-02-06 18:30:39.795315+00	2026-02-06 18:38:15.642293+00
ad3cd9ce-c5a5-4f2d-b8b2-111c34bf51cd	9c5297ee-89af-4f6f-911a-541813232150	image	seed/hero/urubici/cultura.jpg	https://images.unsplash.com/photo-1456324504439-367cee3b3c32?auto=format&fit=crop&w=1600&q=80	{"pt": "Cultura e historias de Urubici"}	{"pt": "Conteudos locais e experiencias"}	site	9c5297ee-89af-4f6f-911a-541813232150	6	t	2026-02-06 18:30:39.795315+00	2026-02-06 18:38:15.642293+00
\.


--
-- TOC entry 5177 (class 0 OID 116024)
-- Dependencies: 366
-- Data for Name: page_views; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.page_views (id, site_id, page_path, referrer, user_agent, session_id, user_id, ip_hash, country_code, created_at) FROM stdin;
99b03d3c-0a60-4dcd-9e10-e1a44393be2c	9c5297ee-89af-4f6f-911a-541813232150	/	http://localhost:3000/	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36	8cda50e1-2f3a-4ea9-8554-d8dbdb628316	c7079292-56a2-427b-9cd4-154a61f65968	\N	\N	2026-02-07 15:57:47.921499+00
634e920b-12b2-41b2-8a85-4bd0e195d8dd	9c5297ee-89af-4f6f-911a-541813232150	/	http://localhost:3000/	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36	8cda50e1-2f3a-4ea9-8554-d8dbdb628316	c7079292-56a2-427b-9cd4-154a61f65968	\N	\N	2026-02-07 15:57:47.916683+00
6955a71d-4147-4368-ba61-31577ee34f8a	9c5297ee-89af-4f6f-911a-541813232150	/	http://localhost:3000/	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36	8cda50e1-2f3a-4ea9-8554-d8dbdb628316	c7079292-56a2-427b-9cd4-154a61f65968	\N	\N	2026-02-07 16:16:05.972262+00
3271c58f-d76c-45ab-ba8b-5a2db6a863af	9c5297ee-89af-4f6f-911a-541813232150	/	http://localhost:3000/	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36	8cda50e1-2f3a-4ea9-8554-d8dbdb628316	c7079292-56a2-427b-9cd4-154a61f65968	\N	\N	2026-02-07 16:16:06.056247+00
3b4e278c-facd-4a7a-81a1-8c7490cb97be	9c5297ee-89af-4f6f-911a-541813232150	/	http://localhost:3000/	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36	8cda50e1-2f3a-4ea9-8554-d8dbdb628316	c7079292-56a2-427b-9cd4-154a61f65968	\N	\N	2026-02-07 16:29:03.565314+00
1fa2b3a5-36ee-4efd-9f9c-c095765230f3	9c5297ee-89af-4f6f-911a-541813232150	/	http://localhost:3000/	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36	8cda50e1-2f3a-4ea9-8554-d8dbdb628316	c7079292-56a2-427b-9cd4-154a61f65968	\N	\N	2026-02-07 16:29:03.565311+00
ed48fefb-ae04-47b0-921e-091ab1db2d88	9c5297ee-89af-4f6f-911a-541813232150	/	http://localhost:3000/	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36	8cda50e1-2f3a-4ea9-8554-d8dbdb628316	c7079292-56a2-427b-9cd4-154a61f65968	\N	\N	2026-02-07 16:35:00.427987+00
df83ed0e-7a4e-4069-b360-761d6601611e	9c5297ee-89af-4f6f-911a-541813232150	/	http://localhost:3000/	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36	8cda50e1-2f3a-4ea9-8554-d8dbdb628316	c7079292-56a2-427b-9cd4-154a61f65968	\N	\N	2026-02-07 16:35:00.432087+00
bd8f85c6-20d8-41f3-b1d9-1962b6026550	9c5297ee-89af-4f6f-911a-541813232150	/	http://localhost:3000/	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36	8cda50e1-2f3a-4ea9-8554-d8dbdb628316	c7079292-56a2-427b-9cd4-154a61f65968	\N	\N	2026-02-07 16:39:07.098356+00
9d0ee971-ff3d-4625-9911-d15f6f5f7640	9c5297ee-89af-4f6f-911a-541813232150	/	http://localhost:3000/	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36	8cda50e1-2f3a-4ea9-8554-d8dbdb628316	c7079292-56a2-427b-9cd4-154a61f65968	\N	\N	2026-02-07 16:39:07.108748+00
1e09e69a-506a-4a48-9e6b-2a8f68b31448	9c5297ee-89af-4f6f-911a-541813232150	/	http://localhost:3000/	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36	8cda50e1-2f3a-4ea9-8554-d8dbdb628316	c7079292-56a2-427b-9cd4-154a61f65968	\N	\N	2026-02-07 16:46:00.46228+00
5653ea45-5a66-4ad8-a9ec-54dbddf95b76	9c5297ee-89af-4f6f-911a-541813232150	/	http://localhost:3000/	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36	8cda50e1-2f3a-4ea9-8554-d8dbdb628316	c7079292-56a2-427b-9cd4-154a61f65968	\N	\N	2026-02-07 16:46:00.472537+00
7cf4c6df-f448-4032-bbab-975a209bf610	9c5297ee-89af-4f6f-911a-541813232150	/	http://localhost:3000/	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36	8cda50e1-2f3a-4ea9-8554-d8dbdb628316	c7079292-56a2-427b-9cd4-154a61f65968	\N	\N	2026-02-07 16:46:52.943778+00
0e59118e-a2b1-4af1-ad4f-330f93dbe38a	9c5297ee-89af-4f6f-911a-541813232150	/	http://localhost:3000/	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36	8cda50e1-2f3a-4ea9-8554-d8dbdb628316	c7079292-56a2-427b-9cd4-154a61f65968	\N	\N	2026-02-07 16:47:04.046537+00
13b8a753-f163-43ed-91a2-8c5232cfc423	9c5297ee-89af-4f6f-911a-541813232150	/	http://localhost:3000/	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36	8cda50e1-2f3a-4ea9-8554-d8dbdb628316	c7079292-56a2-427b-9cd4-154a61f65968	\N	\N	2026-02-07 16:47:22.888175+00
743b0f0f-3c33-4736-8f45-e4d80ce84b92	9c5297ee-89af-4f6f-911a-541813232150	/	http://localhost:3000/	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36	8cda50e1-2f3a-4ea9-8554-d8dbdb628316	c7079292-56a2-427b-9cd4-154a61f65968	\N	\N	2026-02-07 16:47:28.04873+00
e38e3149-1b12-4c06-b109-bc6e84ea8b21	9c5297ee-89af-4f6f-911a-541813232150	/	http://localhost:3000/	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36	8cda50e1-2f3a-4ea9-8554-d8dbdb628316	c7079292-56a2-427b-9cd4-154a61f65968	\N	\N	2026-02-07 16:48:18.691944+00
5249f8db-d2f8-4264-a60c-56c2b76e2840	9c5297ee-89af-4f6f-911a-541813232150	/	http://localhost:3000/	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36	8cda50e1-2f3a-4ea9-8554-d8dbdb628316	c7079292-56a2-427b-9cd4-154a61f65968	\N	\N	2026-02-07 16:48:50.675405+00
b6069fc0-cff4-4297-83cb-ebe6264ffd66	9c5297ee-89af-4f6f-911a-541813232150	/	http://localhost:3000/	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36	8cda50e1-2f3a-4ea9-8554-d8dbdb628316	c7079292-56a2-427b-9cd4-154a61f65968	\N	\N	2026-02-07 16:49:18.00969+00
d56f1400-fa57-4829-b840-404e954c7593	9c5297ee-89af-4f6f-911a-541813232150	/	http://localhost:3000/	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36	8cda50e1-2f3a-4ea9-8554-d8dbdb628316	c7079292-56a2-427b-9cd4-154a61f65968	\N	\N	2026-02-07 16:55:33.253243+00
717f0e6f-1840-4911-b792-cde3c7c3af12	9c5297ee-89af-4f6f-911a-541813232150	/	http://localhost:3000/	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36	8cda50e1-2f3a-4ea9-8554-d8dbdb628316	c7079292-56a2-427b-9cd4-154a61f65968	\N	\N	2026-02-07 16:55:33.270679+00
2ba18558-88e4-40cb-88bd-4df667ccc452	9c5297ee-89af-4f6f-911a-541813232150	/	http://localhost:3000/	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36	8cda50e1-2f3a-4ea9-8554-d8dbdb628316	c7079292-56a2-427b-9cd4-154a61f65968	\N	\N	2026-02-07 17:12:59.389038+00
28eb5888-8323-4679-b006-b4a688914516	9c5297ee-89af-4f6f-911a-541813232150	/	http://localhost:3000/	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36	8cda50e1-2f3a-4ea9-8554-d8dbdb628316	c7079292-56a2-427b-9cd4-154a61f65968	\N	\N	2026-02-07 17:12:59.389709+00
665b1e3c-4184-48ef-a6a8-186155d5b726	9c5297ee-89af-4f6f-911a-541813232150	/	http://localhost:3000/	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36	8cda50e1-2f3a-4ea9-8554-d8dbdb628316	c7079292-56a2-427b-9cd4-154a61f65968	\N	\N	2026-02-07 17:16:41.273828+00
14e4dd11-48ee-4e56-9ecf-d310cc7ce3d5	9c5297ee-89af-4f6f-911a-541813232150	/	http://localhost:3000/	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36	8cda50e1-2f3a-4ea9-8554-d8dbdb628316	c7079292-56a2-427b-9cd4-154a61f65968	\N	\N	2026-02-07 17:16:41.279776+00
b2b08219-2e89-4ec1-be51-7ef3d0ecf58c	9c5297ee-89af-4f6f-911a-541813232150	/	http://localhost:3000/	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36	8cda50e1-2f3a-4ea9-8554-d8dbdb628316	c7079292-56a2-427b-9cd4-154a61f65968	\N	\N	2026-02-07 17:21:19.048657+00
1315bfab-40fc-4155-86d1-b8cc1cbb4706	9c5297ee-89af-4f6f-911a-541813232150	/	http://localhost:3000/	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36	8cda50e1-2f3a-4ea9-8554-d8dbdb628316	c7079292-56a2-427b-9cd4-154a61f65968	\N	\N	2026-02-07 17:23:10.62001+00
7ba6d90a-afe0-454a-9af8-c055c4bd2cb1	9c5297ee-89af-4f6f-911a-541813232150	/	http://localhost:3000/	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36	8cda50e1-2f3a-4ea9-8554-d8dbdb628316	c7079292-56a2-427b-9cd4-154a61f65968	\N	\N	2026-02-07 17:40:39.49674+00
6d8cc5c3-7ce2-4b15-a46f-41923ef89564	9c5297ee-89af-4f6f-911a-541813232150	/	http://localhost:3000/	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36	8cda50e1-2f3a-4ea9-8554-d8dbdb628316	c7079292-56a2-427b-9cd4-154a61f65968	\N	\N	2026-02-07 17:40:39.523251+00
fdbb1388-0b35-4b9d-a79e-d7bfed585b1a	9c5297ee-89af-4f6f-911a-541813232150	/	http://localhost:3000/	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36	8cda50e1-2f3a-4ea9-8554-d8dbdb628316	c7079292-56a2-427b-9cd4-154a61f65968	\N	\N	2026-02-07 18:02:11.157928+00
84ebc666-f3ce-46dd-8a37-28ed0f24f2ca	9c5297ee-89af-4f6f-911a-541813232150	/	http://localhost:3000/	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36	8cda50e1-2f3a-4ea9-8554-d8dbdb628316	c7079292-56a2-427b-9cd4-154a61f65968	\N	\N	2026-02-07 18:02:11.159158+00
69772586-180e-403e-b68a-c78d543afa07	9c5297ee-89af-4f6f-911a-541813232150	/	http://localhost:3000/	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36	8cda50e1-2f3a-4ea9-8554-d8dbdb628316	c7079292-56a2-427b-9cd4-154a61f65968	\N	\N	2026-02-07 18:04:52.189383+00
bf0eeb14-6268-4091-8b4a-831f683fb444	9c5297ee-89af-4f6f-911a-541813232150	/	http://localhost:3000/	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36	8cda50e1-2f3a-4ea9-8554-d8dbdb628316	c7079292-56a2-427b-9cd4-154a61f65968	\N	\N	2026-02-07 18:04:52.198804+00
f584bd31-0ab0-4c46-8e4c-41b7285e7ab0	9c5297ee-89af-4f6f-911a-541813232150	/	http://localhost:3000/	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36	8cda50e1-2f3a-4ea9-8554-d8dbdb628316	c7079292-56a2-427b-9cd4-154a61f65968	\N	\N	2026-02-07 18:11:13.440269+00
755b2440-36ea-47b1-bb4c-4489b00e3b0a	9c5297ee-89af-4f6f-911a-541813232150	/	http://localhost:3000/	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36	8cda50e1-2f3a-4ea9-8554-d8dbdb628316	c7079292-56a2-427b-9cd4-154a61f65968	\N	\N	2026-02-07 18:11:13.557131+00
feaac0fa-feec-48d9-84da-41f934ada6b9	9c5297ee-89af-4f6f-911a-541813232150	/	http://localhost:3000/	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36	8cda50e1-2f3a-4ea9-8554-d8dbdb628316	c7079292-56a2-427b-9cd4-154a61f65968	\N	\N	2026-02-07 18:29:17.359293+00
1345c629-0bca-486e-b57e-b04caea5286c	9c5297ee-89af-4f6f-911a-541813232150	/	http://localhost:3000/	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36	8cda50e1-2f3a-4ea9-8554-d8dbdb628316	c7079292-56a2-427b-9cd4-154a61f65968	\N	\N	2026-02-07 18:29:17.385895+00
0c977347-0e86-4e0b-a46f-0aaa7219abf3	9c5297ee-89af-4f6f-911a-541813232150	/	http://localhost:3000/	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36	8cda50e1-2f3a-4ea9-8554-d8dbdb628316	c7079292-56a2-427b-9cd4-154a61f65968	\N	\N	2026-02-07 18:29:20.738158+00
6ce2792e-e014-460c-8de0-0dea33ecc5f2	9c5297ee-89af-4f6f-911a-541813232150	/	http://localhost:3000/	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36	8cda50e1-2f3a-4ea9-8554-d8dbdb628316	c7079292-56a2-427b-9cd4-154a61f65968	\N	\N	2026-02-07 18:29:20.74164+00
b81cd791-d444-4c06-bdad-6dbcd5399246	9c5297ee-89af-4f6f-911a-541813232150	/	http://localhost:3000/	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36	8cda50e1-2f3a-4ea9-8554-d8dbdb628316	c7079292-56a2-427b-9cd4-154a61f65968	\N	\N	2026-02-07 18:47:41.091627+00
660f8157-51e7-4af2-aaa3-77db4272a0a0	9c5297ee-89af-4f6f-911a-541813232150	/	http://localhost:3000/	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36	8cda50e1-2f3a-4ea9-8554-d8dbdb628316	c7079292-56a2-427b-9cd4-154a61f65968	\N	\N	2026-02-07 18:47:41.091542+00
6cf2bb56-d053-4f88-bb7f-261360a7dd80	9c5297ee-89af-4f6f-911a-541813232150	/	http://localhost:3000/	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36	8cda50e1-2f3a-4ea9-8554-d8dbdb628316	c7079292-56a2-427b-9cd4-154a61f65968	\N	\N	2026-02-07 18:48:28.955443+00
671d6114-694d-4b80-9d35-bddb1dac6672	9c5297ee-89af-4f6f-911a-541813232150	/	http://localhost:3000/	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36	8cda50e1-2f3a-4ea9-8554-d8dbdb628316	c7079292-56a2-427b-9cd4-154a61f65968	\N	\N	2026-02-07 18:48:29.308164+00
d6a9f23c-44cc-433e-987d-4f2324914090	9c5297ee-89af-4f6f-911a-541813232150	/	http://localhost:3000/	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36	8cda50e1-2f3a-4ea9-8554-d8dbdb628316	c7079292-56a2-427b-9cd4-154a61f65968	\N	\N	2026-02-07 19:01:34.020897+00
49069567-abf1-4368-9ef0-9e20833434ed	9c5297ee-89af-4f6f-911a-541813232150	/	http://localhost:3000/	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36	8cda50e1-2f3a-4ea9-8554-d8dbdb628316	c7079292-56a2-427b-9cd4-154a61f65968	\N	\N	2026-02-07 19:01:34.032153+00
03d19bb0-2bb4-4272-ae62-940b328b211f	9c5297ee-89af-4f6f-911a-541813232150	/	http://localhost:3000/	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36	8cda50e1-2f3a-4ea9-8554-d8dbdb628316	c7079292-56a2-427b-9cd4-154a61f65968	\N	\N	2026-02-07 19:09:16.009232+00
a7ec42da-e685-4984-b24c-1168483fffd8	9c5297ee-89af-4f6f-911a-541813232150	/	http://localhost:3000/	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36	8cda50e1-2f3a-4ea9-8554-d8dbdb628316	c7079292-56a2-427b-9cd4-154a61f65968	\N	\N	2026-02-07 19:09:16.031448+00
07890da3-b446-4095-8c73-b517874ca56b	9c5297ee-89af-4f6f-911a-541813232150	/	http://localhost:3000/	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36	8cda50e1-2f3a-4ea9-8554-d8dbdb628316	c7079292-56a2-427b-9cd4-154a61f65968	\N	\N	2026-02-07 19:09:23.226094+00
bc38efb0-e187-4e5a-aed1-b0b0b6a882f6	9c5297ee-89af-4f6f-911a-541813232150	/	http://localhost:3000/	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36	8cda50e1-2f3a-4ea9-8554-d8dbdb628316	c7079292-56a2-427b-9cd4-154a61f65968	\N	\N	2026-02-07 19:09:23.233115+00
5f0fb523-0742-4e06-9449-45c793a28347	9c5297ee-89af-4f6f-911a-541813232150	/	http://localhost:3000/	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36	8cda50e1-2f3a-4ea9-8554-d8dbdb628316	c7079292-56a2-427b-9cd4-154a61f65968	\N	\N	2026-02-07 19:09:26.032789+00
758ffef6-b2dc-471b-976a-b599c6e77e60	9c5297ee-89af-4f6f-911a-541813232150	/	http://localhost:3000/	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36	8cda50e1-2f3a-4ea9-8554-d8dbdb628316	c7079292-56a2-427b-9cd4-154a61f65968	\N	\N	2026-02-07 19:09:26.032929+00
16918d03-37df-4588-aeca-4bd68b031821	9c5297ee-89af-4f6f-911a-541813232150	/	http://localhost:3000/	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36	8cda50e1-2f3a-4ea9-8554-d8dbdb628316	c7079292-56a2-427b-9cd4-154a61f65968	\N	\N	2026-02-07 19:09:31.034155+00
9db1256d-e9af-499d-963e-c12d8b50e442	9c5297ee-89af-4f6f-911a-541813232150	/	http://localhost:3000/	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36	8cda50e1-2f3a-4ea9-8554-d8dbdb628316	c7079292-56a2-427b-9cd4-154a61f65968	\N	\N	2026-02-07 19:09:31.042495+00
678c58e4-96b4-42a2-af79-468ecfd5082a	9c5297ee-89af-4f6f-911a-541813232150	/	http://localhost:3000/	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36	8cda50e1-2f3a-4ea9-8554-d8dbdb628316	c7079292-56a2-427b-9cd4-154a61f65968	\N	\N	2026-02-07 19:13:33.061705+00
cbd9c773-e6fb-4012-9ac5-36d967eaa9d0	9c5297ee-89af-4f6f-911a-541813232150	/	http://localhost:3000/	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36	8cda50e1-2f3a-4ea9-8554-d8dbdb628316	c7079292-56a2-427b-9cd4-154a61f65968	\N	\N	2026-02-07 19:13:33.146476+00
512c0886-6671-42c4-8c48-316c34f7fe93	9c5297ee-89af-4f6f-911a-541813232150	/	http://localhost:3000/	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36	8cda50e1-2f3a-4ea9-8554-d8dbdb628316	c7079292-56a2-427b-9cd4-154a61f65968	\N	\N	2026-02-07 19:15:22.054006+00
83e4335c-ef6a-4ee9-938a-a9bc397275ad	9c5297ee-89af-4f6f-911a-541813232150	/	http://localhost:3000/	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36	8cda50e1-2f3a-4ea9-8554-d8dbdb628316	c7079292-56a2-427b-9cd4-154a61f65968	\N	\N	2026-02-07 19:15:22.074301+00
cea28f8f-2a6c-4278-9da9-f857f786508a	9c5297ee-89af-4f6f-911a-541813232150	/	http://localhost:3000/	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36	8cda50e1-2f3a-4ea9-8554-d8dbdb628316	c7079292-56a2-427b-9cd4-154a61f65968	\N	\N	2026-02-07 19:17:10.989323+00
bfbf0427-3b34-4b89-a871-1e684e53a1d9	9c5297ee-89af-4f6f-911a-541813232150	/	http://localhost:3000/	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36	8cda50e1-2f3a-4ea9-8554-d8dbdb628316	c7079292-56a2-427b-9cd4-154a61f65968	\N	\N	2026-02-07 19:17:10.992404+00
7166278b-ded9-4cb4-9fcc-19a8d377173c	9c5297ee-89af-4f6f-911a-541813232150	/	http://localhost:3000/	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36	8cda50e1-2f3a-4ea9-8554-d8dbdb628316	c7079292-56a2-427b-9cd4-154a61f65968	\N	\N	2026-02-07 19:38:13.316455+00
37f6fb66-406f-498a-86f2-495cfbbcbba3	9c5297ee-89af-4f6f-911a-541813232150	/	http://localhost:3000/	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36	8cda50e1-2f3a-4ea9-8554-d8dbdb628316	c7079292-56a2-427b-9cd4-154a61f65968	\N	\N	2026-02-07 19:38:13.326391+00
22c625a5-a06e-4dfd-858b-85d3d29e3ac3	9c5297ee-89af-4f6f-911a-541813232150	/	http://localhost:3000/	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36	8cda50e1-2f3a-4ea9-8554-d8dbdb628316	c7079292-56a2-427b-9cd4-154a61f65968	\N	\N	2026-02-07 21:29:09.948883+00
a8f50269-5a5a-445e-aeec-e495bac76358	9c5297ee-89af-4f6f-911a-541813232150	/	http://localhost:3000/	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36	8cda50e1-2f3a-4ea9-8554-d8dbdb628316	c7079292-56a2-427b-9cd4-154a61f65968	\N	\N	2026-02-07 21:29:09.95174+00
3f2ae199-b854-4f26-b604-4af949585ac5	9c5297ee-89af-4f6f-911a-541813232150	/	http://localhost:3000/	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36	8cda50e1-2f3a-4ea9-8554-d8dbdb628316	c7079292-56a2-427b-9cd4-154a61f65968	\N	\N	2026-02-08 00:37:43.261396+00
15ed92e5-7417-46bf-90b2-2c2c734a7b0a	9c5297ee-89af-4f6f-911a-541813232150	/	http://localhost:3000/	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36	8cda50e1-2f3a-4ea9-8554-d8dbdb628316	c7079292-56a2-427b-9cd4-154a61f65968	\N	\N	2026-02-08 00:37:43.265858+00
74dbca7e-da08-4da5-96ae-1c9d04bdc40b	9c5297ee-89af-4f6f-911a-541813232150	/	http://localhost:3000/	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36	8cda50e1-2f3a-4ea9-8554-d8dbdb628316	c7079292-56a2-427b-9cd4-154a61f65968	\N	\N	2026-02-08 16:22:33.303382+00
ed53e770-a725-4593-86eb-71ac7c621c71	9c5297ee-89af-4f6f-911a-541813232150	/	http://localhost:3000/	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36	8cda50e1-2f3a-4ea9-8554-d8dbdb628316	c7079292-56a2-427b-9cd4-154a61f65968	\N	\N	2026-02-08 16:22:33.304715+00
6602774f-b765-4aac-a9d4-2eac0edcd9d1	9c5297ee-89af-4f6f-911a-541813232150	/	http://localhost:3000/	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36	8cda50e1-2f3a-4ea9-8554-d8dbdb628316	c7079292-56a2-427b-9cd4-154a61f65968	\N	\N	2026-02-08 17:06:17.721383+00
632b0837-8349-463c-83b5-587c0f519f96	9c5297ee-89af-4f6f-911a-541813232150	/	http://localhost:3000/	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36	8cda50e1-2f3a-4ea9-8554-d8dbdb628316	c7079292-56a2-427b-9cd4-154a61f65968	\N	\N	2026-02-08 17:06:17.726506+00
15c72e2b-efe1-4595-8519-0f16f47736ba	9c5297ee-89af-4f6f-911a-541813232150	/	http://localhost:3000/	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36	8cda50e1-2f3a-4ea9-8554-d8dbdb628316	c7079292-56a2-427b-9cd4-154a61f65968	\N	\N	2026-02-08 17:08:25.582553+00
28f64352-d22b-453a-9d8b-c13aa2cdeaf9	9c5297ee-89af-4f6f-911a-541813232150	/	http://localhost:3000/	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36	8cda50e1-2f3a-4ea9-8554-d8dbdb628316	c7079292-56a2-427b-9cd4-154a61f65968	\N	\N	2026-02-08 17:08:25.622599+00
47a78156-eddc-4d8d-a198-f56a6e18f519	9c5297ee-89af-4f6f-911a-541813232150	/	http://localhost:3000/	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36	8cda50e1-2f3a-4ea9-8554-d8dbdb628316	c7079292-56a2-427b-9cd4-154a61f65968	\N	\N	2026-02-08 17:12:48.079217+00
9eac09a5-90a7-49ac-9cbf-936da2da121d	9c5297ee-89af-4f6f-911a-541813232150	/	http://localhost:3000/	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36	8cda50e1-2f3a-4ea9-8554-d8dbdb628316	c7079292-56a2-427b-9cd4-154a61f65968	\N	\N	2026-02-08 17:12:48.069912+00
bfeed568-68ed-424f-89aa-5481f0209ca3	9c5297ee-89af-4f6f-911a-541813232150	/	http://localhost:3000/	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36	8cda50e1-2f3a-4ea9-8554-d8dbdb628316	c7079292-56a2-427b-9cd4-154a61f65968	\N	\N	2026-02-08 17:21:10.752599+00
92d99cae-ab3b-4233-8c28-cbe4aad7dab8	9c5297ee-89af-4f6f-911a-541813232150	/	http://localhost:3000/	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36	8cda50e1-2f3a-4ea9-8554-d8dbdb628316	c7079292-56a2-427b-9cd4-154a61f65968	\N	\N	2026-02-08 17:21:10.762161+00
4fcfe957-075e-4e01-84dc-dbe9deb26031	9c5297ee-89af-4f6f-911a-541813232150	/	http://localhost:3000/	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36	8cda50e1-2f3a-4ea9-8554-d8dbdb628316	c7079292-56a2-427b-9cd4-154a61f65968	\N	\N	2026-02-08 17:21:21.440651+00
3de4d4c0-b787-405d-86e3-6283e6ff5246	9c5297ee-89af-4f6f-911a-541813232150	/	http://localhost:3000/	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36	8cda50e1-2f3a-4ea9-8554-d8dbdb628316	c7079292-56a2-427b-9cd4-154a61f65968	\N	\N	2026-02-08 17:21:21.444954+00
dfe1b2fe-0f65-464d-9a57-b0db7d55db0c	9c5297ee-89af-4f6f-911a-541813232150	/	http://localhost:3000/	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36	8cda50e1-2f3a-4ea9-8554-d8dbdb628316	c7079292-56a2-427b-9cd4-154a61f65968	\N	\N	2026-02-08 19:04:06.779318+00
85d48f9f-c190-48cf-b06d-79f61a060a79	9c5297ee-89af-4f6f-911a-541813232150	/	http://localhost:3000/	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36	8cda50e1-2f3a-4ea9-8554-d8dbdb628316	c7079292-56a2-427b-9cd4-154a61f65968	\N	\N	2026-02-08 19:04:06.777559+00
fa86505a-88bf-489b-83f1-f489193a9fab	9c5297ee-89af-4f6f-911a-541813232150	/	http://localhost:3000/	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36	8cda50e1-2f3a-4ea9-8554-d8dbdb628316	c7079292-56a2-427b-9cd4-154a61f65968	\N	\N	2026-02-09 02:14:56.233976+00
72874e64-6de5-422a-80ed-75f5e102c840	9c5297ee-89af-4f6f-911a-541813232150	/	http://localhost:3000/	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36	8cda50e1-2f3a-4ea9-8554-d8dbdb628316	c7079292-56a2-427b-9cd4-154a61f65968	\N	\N	2026-02-09 02:14:56.230534+00
9b3dd532-72f2-4fcc-b301-833909d7ae40	9c5297ee-89af-4f6f-911a-541813232150	/	http://localhost:3000/	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36	8cda50e1-2f3a-4ea9-8554-d8dbdb628316	c7079292-56a2-427b-9cd4-154a61f65968	\N	\N	2026-02-09 02:18:11.541141+00
788bf273-b645-4320-97a1-eac53ac0bbab	9c5297ee-89af-4f6f-911a-541813232150	/	http://localhost:3000/	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36	8cda50e1-2f3a-4ea9-8554-d8dbdb628316	c7079292-56a2-427b-9cd4-154a61f65968	\N	\N	2026-02-09 02:18:11.564725+00
e0b75cb3-ecd6-441a-961b-9251afbf6ca2	9c5297ee-89af-4f6f-911a-541813232150	/	http://localhost:3000/	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36	8cda50e1-2f3a-4ea9-8554-d8dbdb628316	c7079292-56a2-427b-9cd4-154a61f65968	\N	\N	2026-02-09 02:23:47.810762+00
ff84a6ab-eef5-4199-82b8-69ed8ee7fd0b	9c5297ee-89af-4f6f-911a-541813232150	/	http://localhost:3000/	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36	8cda50e1-2f3a-4ea9-8554-d8dbdb628316	c7079292-56a2-427b-9cd4-154a61f65968	\N	\N	2026-02-09 02:23:47.811741+00
f826824e-6a7f-43c5-afeb-91f5c22db9e9	9c5297ee-89af-4f6f-911a-541813232150	/	http://localhost:3000/	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36	8cda50e1-2f3a-4ea9-8554-d8dbdb628316	c7079292-56a2-427b-9cd4-154a61f65968	\N	\N	2026-02-09 02:47:09.275804+00
431b6a82-c5fb-458a-8041-e451e6a3ec68	9c5297ee-89af-4f6f-911a-541813232150	/	http://localhost:3000/	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36	8cda50e1-2f3a-4ea9-8554-d8dbdb628316	c7079292-56a2-427b-9cd4-154a61f65968	\N	\N	2026-02-09 02:47:09.303726+00
538386d7-0b7d-4d88-8779-aab6fb2c0365	9c5297ee-89af-4f6f-911a-541813232150	/	http://localhost:3000/	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36	8cda50e1-2f3a-4ea9-8554-d8dbdb628316	c7079292-56a2-427b-9cd4-154a61f65968	\N	\N	2026-02-09 02:47:37.117026+00
3ad185d6-f39a-47cd-a8a1-1e9e2820d256	9c5297ee-89af-4f6f-911a-541813232150	/	http://localhost:3000/	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36	8cda50e1-2f3a-4ea9-8554-d8dbdb628316	c7079292-56a2-427b-9cd4-154a61f65968	\N	\N	2026-02-09 02:47:37.353568+00
d9c0e904-1031-4ba4-aae4-412f9f10ea71	9c5297ee-89af-4f6f-911a-541813232150	/	http://localhost:3000/	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36	8cda50e1-2f3a-4ea9-8554-d8dbdb628316	c7079292-56a2-427b-9cd4-154a61f65968	\N	\N	2026-02-09 02:54:09.28928+00
5d7acec5-915b-4942-9c55-50653fe20cf6	9c5297ee-89af-4f6f-911a-541813232150	/	http://localhost:3000/	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36	8cda50e1-2f3a-4ea9-8554-d8dbdb628316	c7079292-56a2-427b-9cd4-154a61f65968	\N	\N	2026-02-09 02:54:09.297808+00
98fe737f-f9b6-435d-9adc-4e39344da8f0	9c5297ee-89af-4f6f-911a-541813232150	/	http://localhost:3000/	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36	8cda50e1-2f3a-4ea9-8554-d8dbdb628316	c7079292-56a2-427b-9cd4-154a61f65968	\N	\N	2026-02-09 02:54:50.916346+00
b486996d-a26f-49ae-90ed-2c50984005f5	9c5297ee-89af-4f6f-911a-541813232150	/	http://localhost:3000/	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36	8cda50e1-2f3a-4ea9-8554-d8dbdb628316	c7079292-56a2-427b-9cd4-154a61f65968	\N	\N	2026-02-09 02:54:50.942929+00
04f1be8c-f838-4233-9ef8-985ca4137bff	9c5297ee-89af-4f6f-911a-541813232150	/	http://localhost:3000/	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36	8cda50e1-2f3a-4ea9-8554-d8dbdb628316	c7079292-56a2-427b-9cd4-154a61f65968	\N	\N	2026-02-09 03:04:47.31023+00
1206b0c7-34f5-42d3-b8a9-f59e8a00cda3	9c5297ee-89af-4f6f-911a-541813232150	/	http://localhost:3000/	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36	8cda50e1-2f3a-4ea9-8554-d8dbdb628316	c7079292-56a2-427b-9cd4-154a61f65968	\N	\N	2026-02-09 03:04:47.316874+00
432ee8fc-d0e8-45fe-9a5c-25f53f936237	9c5297ee-89af-4f6f-911a-541813232150	/	http://localhost:3000/	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36	8cda50e1-2f3a-4ea9-8554-d8dbdb628316	c7079292-56a2-427b-9cd4-154a61f65968	\N	\N	2026-02-09 03:05:01.982586+00
6cf0be80-b6ad-483b-90c7-f2a5a9338c39	9c5297ee-89af-4f6f-911a-541813232150	/	http://localhost:3000/	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36	8cda50e1-2f3a-4ea9-8554-d8dbdb628316	c7079292-56a2-427b-9cd4-154a61f65968	\N	\N	2026-02-09 03:05:02.047326+00
65abc37c-12af-4383-96ba-ec5649c4ac39	9c5297ee-89af-4f6f-911a-541813232150	/	http://localhost:3000/	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36	8cda50e1-2f3a-4ea9-8554-d8dbdb628316	c7079292-56a2-427b-9cd4-154a61f65968	\N	\N	2026-02-09 03:13:26.070136+00
c4ebe640-7d60-4113-ae6e-68b1d16d8e42	9c5297ee-89af-4f6f-911a-541813232150	/	http://localhost:3000/	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36	8cda50e1-2f3a-4ea9-8554-d8dbdb628316	c7079292-56a2-427b-9cd4-154a61f65968	\N	\N	2026-02-09 03:13:26.077593+00
28aaf136-e7d6-4bc5-810b-be9f8cc22a05	9c5297ee-89af-4f6f-911a-541813232150	/	http://localhost:3000/	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36	8cda50e1-2f3a-4ea9-8554-d8dbdb628316	c7079292-56a2-427b-9cd4-154a61f65968	\N	\N	2026-02-09 03:25:13.080906+00
d980a806-b7d8-44b9-a18d-769cc5c9028a	9c5297ee-89af-4f6f-911a-541813232150	/	http://localhost:3000/	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36	8cda50e1-2f3a-4ea9-8554-d8dbdb628316	c7079292-56a2-427b-9cd4-154a61f65968	\N	\N	2026-02-09 03:25:13.117719+00
f232ce89-4047-40a4-b7ff-d44e69eb15e3	9c5297ee-89af-4f6f-911a-541813232150	/	http://localhost:3000/	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36	8cda50e1-2f3a-4ea9-8554-d8dbdb628316	c7079292-56a2-427b-9cd4-154a61f65968	\N	\N	2026-02-09 03:26:42.779241+00
a7cca182-7cb1-4bcc-93fd-1c1dc89c4a48	9c5297ee-89af-4f6f-911a-541813232150	/	http://localhost:3000/	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36	8cda50e1-2f3a-4ea9-8554-d8dbdb628316	c7079292-56a2-427b-9cd4-154a61f65968	\N	\N	2026-02-09 03:26:43.155273+00
d9e5e365-375f-448a-9145-ab154c177b36	9c5297ee-89af-4f6f-911a-541813232150	/	http://localhost:3000/	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36	8cda50e1-2f3a-4ea9-8554-d8dbdb628316	c7079292-56a2-427b-9cd4-154a61f65968	\N	\N	2026-02-09 13:16:17.504487+00
9e387cae-8293-4cce-9150-c44607a7369e	9c5297ee-89af-4f6f-911a-541813232150	/	http://localhost:3000/	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36	8cda50e1-2f3a-4ea9-8554-d8dbdb628316	c7079292-56a2-427b-9cd4-154a61f65968	\N	\N	2026-02-09 13:16:17.504818+00
\.


--
-- TOC entry 5150 (class 0 OID 106296)
-- Dependencies: 338
-- Data for Name: place_categories; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.place_categories (id, site_id, kind, slug, name_i18n, sort_order, is_active, created_at, updated_at, name, color, parent_id, category_type, description, icon) FROM stdin;
1a369a4c-fe8a-4da8-9322-93926b52c224	9c5297ee-89af-4f6f-911a-541813232150	food	restaurante	{"pt": "Restaurante"}	2	t	2026-02-04 14:48:26.432121+00	2026-02-05 02:13:17.745438+00	Restaurante	#10B981	\N	onde_comer	\N	\N
d79156ce-62b1-488f-ad58-927191455d98	91aac245-fdfa-485f-ad88-d4fa7f70d13d	food	restaurante	{"pt": "Restaurante"}	2	t	2026-02-04 14:48:26.432121+00	2026-02-05 02:13:17.745438+00	Restaurante	#10B981	\N	onde_comer	\N	\N
fea13dbb-e65e-477f-a981-aa34560620ed	9623f594-49ac-4b3f-a84e-19a261338229	food	restaurante	{"pt": "Restaurante"}	2	t	2026-02-04 14:48:26.432121+00	2026-02-05 02:13:17.745438+00	Restaurante	#10B981	\N	onde_comer	\N	\N
bb8ae206-b829-4b3a-b6ab-dc2174d97960	010f3e62-feb2-4a65-8d09-0f698388d26f	food	restaurante	{"pt": "Restaurante"}	2	t	2026-02-04 14:48:26.432121+00	2026-02-05 02:13:17.745438+00	Restaurante	#10B981	\N	onde_comer	\N	\N
7868cfe3-4294-4d96-a602-8c0eba64cf7b	9c5297ee-89af-4f6f-911a-541813232150	attraction	atrativos	{"en": "Attractions", "es": "Atractivos", "pt": "Atrativos"}	10	t	2026-01-27 13:57:14.96763+00	2026-02-05 02:13:17.745438+00	Local	#3B82F6	\N	onde_ir	\N	\N
2d53b94f-757c-4a6f-9c94-dd1a7f8c5bf4	9c5297ee-89af-4f6f-911a-541813232150	attraction	trilhas	{"en": "Hikes", "es": "Senderos", "pt": "Trilhas"}	20	t	2026-01-27 13:57:14.96763+00	2026-02-05 02:13:17.745438+00	Local	#3B82F6	\N	onde_ir	\N	\N
24e8e3cb-0779-4196-aae4-bc156c23ca27	9c5297ee-89af-4f6f-911a-541813232150	attraction	cachoeiras	{"en": "Waterfalls", "es": "Cascadas", "pt": "Cachoeiras"}	30	t	2026-01-27 13:57:14.96763+00	2026-02-05 02:13:17.745438+00	Local	#3B82F6	\N	onde_ir	\N	\N
7f7ccabb-260f-4627-9796-08e5600255d6	9c5297ee-89af-4f6f-911a-541813232150	lodging	hotel-pousada	{"pt": "Hotel/Pousada"}	3	t	2026-02-04 14:48:26.432121+00	2026-02-05 02:13:17.745438+00	Hotel/Pousada	#3B82F6	\N	onde_ficar	\N	\N
8b02f7d9-0900-436e-846f-85a2ab995070	9c5297ee-89af-4f6f-911a-541813232150	service	servico	{"pt": "Serviço"}	4	t	2026-02-04 14:48:26.432121+00	2026-02-05 02:13:17.745438+00	Serviço	#F59E0B	\N	o_que_fazer	\N	\N
279e1200-7a23-4627-8c57-5f19267e209c	9c5297ee-89af-4f6f-911a-541813232150	medical	servico-medico	{"pt": "Serviço Médico"}	5	t	2026-02-04 14:48:26.432121+00	2026-02-05 02:13:17.745438+00	Serviço Médico	#EF4444	\N	guia_medico	\N	\N
962cb217-96c6-44f7-b9ea-50feea8f00b6	91aac245-fdfa-485f-ad88-d4fa7f70d13d	attraction	ponto-turistico	{"pt": "Ponto Turístico"}	1	t	2026-02-04 14:48:26.432121+00	2026-02-05 02:13:17.745438+00	Ponto Turístico	#8B5CF6	\N	onde_ir	\N	\N
8ee372f3-1792-4cb5-a043-7ae1e936ea6d	91aac245-fdfa-485f-ad88-d4fa7f70d13d	lodging	hotel-pousada	{"pt": "Hotel/Pousada"}	3	t	2026-02-04 14:48:26.432121+00	2026-02-05 02:13:17.745438+00	Hotel/Pousada	#3B82F6	\N	onde_ficar	\N	\N
7d456376-aa5c-48a9-ac7f-fcbdcb03a045	91aac245-fdfa-485f-ad88-d4fa7f70d13d	service	servico	{"pt": "Serviço"}	4	t	2026-02-04 14:48:26.432121+00	2026-02-05 02:13:17.745438+00	Serviço	#F59E0B	\N	o_que_fazer	\N	\N
a1a355f7-cd91-4d4d-b201-47868901e611	91aac245-fdfa-485f-ad88-d4fa7f70d13d	medical	servico-medico	{"pt": "Serviço Médico"}	5	t	2026-02-04 14:48:26.432121+00	2026-02-05 02:13:17.745438+00	Serviço Médico	#EF4444	\N	guia_medico	\N	\N
2dfa56ba-8d7d-4665-9c04-6cc2a65b509b	9623f594-49ac-4b3f-a84e-19a261338229	attraction	ponto-turistico	{"pt": "Ponto Turístico"}	1	t	2026-02-04 14:48:26.432121+00	2026-02-05 02:13:17.745438+00	Ponto Turístico	#8B5CF6	\N	onde_ir	\N	\N
44bde3a0-66bc-460f-809d-87b4dc4584da	9623f594-49ac-4b3f-a84e-19a261338229	lodging	hotel-pousada	{"pt": "Hotel/Pousada"}	3	t	2026-02-04 14:48:26.432121+00	2026-02-05 02:13:17.745438+00	Hotel/Pousada	#3B82F6	\N	onde_ficar	\N	\N
4ab28e27-df2b-49ec-af38-7f7bf2310cdd	9623f594-49ac-4b3f-a84e-19a261338229	service	servico	{"pt": "Serviço"}	4	t	2026-02-04 14:48:26.432121+00	2026-02-05 02:13:17.745438+00	Serviço	#F59E0B	\N	o_que_fazer	\N	\N
5a8080fd-2635-4a12-8602-37dcef74212d	9623f594-49ac-4b3f-a84e-19a261338229	medical	servico-medico	{"pt": "Serviço Médico"}	5	t	2026-02-04 14:48:26.432121+00	2026-02-05 02:13:17.745438+00	Serviço Médico	#EF4444	\N	guia_medico	\N	\N
26b1e122-b41e-4d42-9033-59f15521a53f	010f3e62-feb2-4a65-8d09-0f698388d26f	attraction	ponto-turistico	{"pt": "Ponto Turístico"}	1	t	2026-02-04 14:48:26.432121+00	2026-02-05 02:13:17.745438+00	Ponto Turístico	#8B5CF6	\N	onde_ir	\N	\N
ca7cd2da-0809-4ca4-b9ce-6d882530a15b	010f3e62-feb2-4a65-8d09-0f698388d26f	lodging	hotel-pousada	{"pt": "Hotel/Pousada"}	3	t	2026-02-04 14:48:26.432121+00	2026-02-05 02:13:17.745438+00	Hotel/Pousada	#3B82F6	\N	onde_ficar	\N	\N
d42d4021-e949-4154-a5db-183c46123998	010f3e62-feb2-4a65-8d09-0f698388d26f	service	servico	{"pt": "Serviço"}	4	t	2026-02-04 14:48:26.432121+00	2026-02-05 02:13:17.745438+00	Serviço	#F59E0B	\N	o_que_fazer	\N	\N
dbe60597-a0ba-424f-afe0-e125f8fbee54	010f3e62-feb2-4a65-8d09-0f698388d26f	medical	servico-medico	{"pt": "Serviço Médico"}	5	t	2026-02-04 14:48:26.432121+00	2026-02-05 02:13:17.745438+00	Serviço Médico	#EF4444	\N	guia_medico	\N	\N
b3e8e80a-7fc1-4e57-a07d-a6dc2e21fd4c	9c5297ee-89af-4f6f-911a-541813232150	food	restaurantes	{"pt": "Restaurantes"}	1	t	2026-02-05 02:13:17.745438+00	2026-02-05 02:13:17.745438+00	Restaurantes	#F59E0B	\N	onde_comer	\N	\N
519083c8-3a94-4ebd-a715-2e745a6da2d6	9c5297ee-89af-4f6f-911a-541813232150	lodging	pousadas	{"pt": "Pousadas"}	1	t	2026-02-05 02:13:17.745438+00	2026-02-05 02:13:17.745438+00	Pousadas	#3B82F6	\N	onde_ficar	\N	\N
ca565255-375e-4ca1-bee1-3fb3c7fd8be1	9c5297ee-89af-4f6f-911a-541813232150	attraction	morros-e-montanhas	{"pt": "Morros e Montanhas"}	5	t	2026-02-05 02:13:17.745438+00	2026-02-05 02:13:17.745438+00	Morros e Montanhas	#10B981	\N	onde_ir	\N	\N
c40ec3d0-330f-4de5-a955-1e6c19f27322	9c5297ee-89af-4f6f-911a-541813232150	attraction	canions	{"pt": "Canions"}	2	t	2026-02-05 02:13:17.745438+00	2026-02-05 02:13:17.745438+00	Canions	#10B981	\N	onde_ir	\N	\N
950efcf1-9539-44fb-9954-01e4b3253c74	9c5297ee-89af-4f6f-911a-541813232150	medical	hospitais	{"pt": "Hospitais"}	1	t	2026-02-05 02:13:17.745438+00	2026-02-05 02:13:17.745438+00	Hospitais	#EF4444	\N	guia_medico	\N	\N
21d1c089-0bbc-4239-a802-ebf828cf5f28	9c5297ee-89af-4f6f-911a-541813232150	food	churrascarias	{"pt": "Churrascarias"}	4	t	2026-02-05 02:13:17.745438+00	2026-02-05 02:13:17.745438+00	Churrascarias	#F59E0B	\N	onde_comer	\N	\N
e07d58d2-ba08-4ec0-94d6-5b412d7444a7	9c5297ee-89af-4f6f-911a-541813232150	attraction	experiencias-locais	{"pt": "Experiencias Locais"}	5	t	2026-02-05 02:13:17.745438+00	2026-02-05 02:13:17.745438+00	Experiencias Locais	#8B5CF6	\N	o_que_fazer	\N	\N
805ec5c2-b5c7-43e8-8743-658593a2b239	9c5297ee-89af-4f6f-911a-541813232150	food	cafeterias	{"pt": "Cafeterias"}	2	t	2026-02-05 02:13:17.745438+00	2026-02-05 02:13:17.745438+00	Cafeterias	#F59E0B	\N	onde_comer	\N	\N
de456443-2941-4875-8be9-8c1e40dbd6c4	9c5297ee-89af-4f6f-911a-541813232150	attraction	parques-e-lazer	{"pt": "Parques e Lazer"}	6	t	2026-02-05 02:13:17.745438+00	2026-02-05 02:13:17.745438+00	Parques e Lazer	#10B981	\N	onde_ir	\N	\N
fb3a7f20-e3c6-4102-9e48-6da3f3d639e8	9c5297ee-89af-4f6f-911a-541813232150	lodging	campings	{"pt": "Campings"}	5	t	2026-02-05 02:13:17.745438+00	2026-02-05 02:13:17.745438+00	Campings	#3B82F6	\N	onde_ficar	\N	\N
5de6c01d-95e2-4f89-943f-4ff7003d5ecb	9c5297ee-89af-4f6f-911a-541813232150	food	lanches-e-burgers	{"pt": "Lanches e Burgers"}	5	t	2026-02-05 02:13:17.745438+00	2026-02-05 02:13:17.745438+00	Lanches e Burgers	#F59E0B	\N	onde_comer	\N	\N
7a2540a8-fe12-483b-b8a1-46d2e3521a88	9c5297ee-89af-4f6f-911a-541813232150	attraction	passeios-rurais	{"pt": "Passeios Rurais"}	3	t	2026-02-05 02:13:17.745438+00	2026-02-05 02:13:17.745438+00	Passeios Rurais	#8B5CF6	\N	o_que_fazer	\N	\N
fd0afee7-a7e9-4d38-98db-4c9cba531b84	9c5297ee-89af-4f6f-911a-541813232150	medical	clinicas	{"pt": "Clinicas"}	2	t	2026-02-05 02:13:17.745438+00	2026-02-05 02:13:17.745438+00	Clinicas	#EF4444	\N	guia_medico	\N	\N
43226c8d-0091-4f1f-9638-e3ebe3424481	9c5297ee-89af-4f6f-911a-541813232150	food	pizzarias	{"pt": "Pizzarias"}	3	t	2026-02-05 02:13:17.745438+00	2026-02-05 02:13:17.745438+00	Pizzarias	#F59E0B	\N	onde_comer	\N	\N
b7c7bdaf-6090-4e0f-8fd8-43dcdc79962e	9c5297ee-89af-4f6f-911a-541813232150	lodging	chales	{"pt": "Chales"}	2	t	2026-02-05 02:13:17.745438+00	2026-02-05 02:13:17.745438+00	Chales	#3B82F6	\N	onde_ficar	\N	\N
596ea5e3-9d67-4002-849c-6e91f0ce8a40	9c5297ee-89af-4f6f-911a-541813232150	medical	laboratorios	{"pt": "Laboratorios"}	4	t	2026-02-05 02:13:17.745438+00	2026-02-05 02:13:17.745438+00	Laboratorios	#EF4444	\N	guia_medico	\N	\N
d41c76e7-d22a-40a4-8e8c-0c2e87a47277	9c5297ee-89af-4f6f-911a-541813232150	attraction	mirantes	{"pt": "Mirantes"}	3	t	2026-02-05 02:13:17.745438+00	2026-02-05 02:13:17.745438+00	Mirantes	#10B981	\N	onde_ir	\N	\N
6d9ef765-d180-4c96-920c-19c5b245dddd	9c5297ee-89af-4f6f-911a-541813232150	medical	farmacias	{"pt": "Farmacias"}	3	t	2026-02-05 02:13:17.745438+00	2026-02-05 02:13:17.745438+00	Farmacias	#EF4444	\N	guia_medico	\N	\N
466e7462-a743-4c3f-88ad-aa7657f582cf	9c5297ee-89af-4f6f-911a-541813232150	attraction	cultura-e-historia	{"pt": "Cultura e Historia"}	4	t	2026-02-05 02:13:17.745438+00	2026-02-05 02:13:17.745438+00	Cultura e Historia	#8B5CF6	\N	o_que_fazer	\N	\N
3dc6fbb3-01c0-4a0f-bad3-38adc2089e71	9c5297ee-89af-4f6f-911a-541813232150	attraction	aventura-e-ecoturismo	{"pt": "Aventura e Ecoturismo"}	2	t	2026-02-05 02:13:17.745438+00	2026-02-05 02:13:17.745438+00	Aventura e Ecoturismo	#8B5CF6	\N	o_que_fazer	\N	\N
5839d142-a566-4234-b944-7d8f7a6d8b4e	9c5297ee-89af-4f6f-911a-541813232150	medical	odontologia	{"pt": "Odontologia"}	5	t	2026-02-05 02:13:17.745438+00	2026-02-05 02:13:17.745438+00	Odontologia	#EF4444	\N	guia_medico	\N	\N
778da81c-570b-405f-bdac-337125d980e5	9c5297ee-89af-4f6f-911a-541813232150	attraction	grutas-e-cavernas	{"pt": "Grutas e Cavernas"}	4	t	2026-02-05 02:13:17.745438+00	2026-02-05 02:13:17.745438+00	Grutas e Cavernas	#10B981	\N	onde_ir	\N	\N
5597b494-b2eb-432c-a9cb-c4d4a19edee6	9c5297ee-89af-4f6f-911a-541813232150	lodging	casas-de-temporada	{"pt": "Casas de Temporada"}	4	t	2026-02-05 02:13:17.745438+00	2026-02-05 02:13:17.745438+00	Casas de Temporada	#3B82F6	\N	onde_ficar	\N	\N
684dc08c-42f8-43d1-af3e-b4f42b24667a	9c5297ee-89af-4f6f-911a-541813232150	lodging	hoteis	{"pt": "Hoteis"}	3	t	2026-02-05 02:13:17.745438+00	2026-02-05 02:13:17.745438+00	Hoteis	#3B82F6	\N	onde_ficar	\N	\N
3d45aabe-02e3-49e6-9af8-ce82cdcc1ef5	91aac245-fdfa-485f-ad88-d4fa7f70d13d	food	restaurantes	{"pt": "Restaurantes"}	1	t	2026-02-05 02:13:17.745438+00	2026-02-05 02:13:17.745438+00	Restaurantes	#F59E0B	\N	onde_comer	\N	\N
fc28ca92-150d-4dbb-a777-ba1ca305ea57	91aac245-fdfa-485f-ad88-d4fa7f70d13d	lodging	pousadas	{"pt": "Pousadas"}	1	t	2026-02-05 02:13:17.745438+00	2026-02-05 02:13:17.745438+00	Pousadas	#3B82F6	\N	onde_ficar	\N	\N
8506a0e1-6b6e-4908-99d6-c5f641375882	91aac245-fdfa-485f-ad88-d4fa7f70d13d	attraction	morros-e-montanhas	{"pt": "Morros e Montanhas"}	5	t	2026-02-05 02:13:17.745438+00	2026-02-05 02:13:17.745438+00	Morros e Montanhas	#10B981	\N	onde_ir	\N	\N
dba46fe2-6608-444b-8480-dca3ec55021e	91aac245-fdfa-485f-ad88-d4fa7f70d13d	attraction	canions	{"pt": "Canions"}	2	t	2026-02-05 02:13:17.745438+00	2026-02-05 02:13:17.745438+00	Canions	#10B981	\N	onde_ir	\N	\N
8b8b7d40-7888-4a8f-9685-0c099ab5506d	91aac245-fdfa-485f-ad88-d4fa7f70d13d	medical	hospitais	{"pt": "Hospitais"}	1	t	2026-02-05 02:13:17.745438+00	2026-02-05 02:13:17.745438+00	Hospitais	#EF4444	\N	guia_medico	\N	\N
6001053a-1d6f-4135-bafc-66085dfb6c04	91aac245-fdfa-485f-ad88-d4fa7f70d13d	food	churrascarias	{"pt": "Churrascarias"}	4	t	2026-02-05 02:13:17.745438+00	2026-02-05 02:13:17.745438+00	Churrascarias	#F59E0B	\N	onde_comer	\N	\N
a772a4c7-84ee-4995-8920-bd7fbc97fee9	91aac245-fdfa-485f-ad88-d4fa7f70d13d	attraction	experiencias-locais	{"pt": "Experiencias Locais"}	5	t	2026-02-05 02:13:17.745438+00	2026-02-05 02:13:17.745438+00	Experiencias Locais	#8B5CF6	\N	o_que_fazer	\N	\N
9deeb791-85e8-41bc-8b72-426f1238c1b0	91aac245-fdfa-485f-ad88-d4fa7f70d13d	attraction	cachoeiras	{"pt": "Cachoeiras"}	1	t	2026-02-05 02:13:17.745438+00	2026-02-05 02:13:17.745438+00	Cachoeiras	#10B981	\N	onde_ir	\N	\N
3fc96b6f-41b9-4c1a-9e5f-565845ad6042	91aac245-fdfa-485f-ad88-d4fa7f70d13d	food	cafeterias	{"pt": "Cafeterias"}	2	t	2026-02-05 02:13:17.745438+00	2026-02-05 02:13:17.745438+00	Cafeterias	#F59E0B	\N	onde_comer	\N	\N
e3c0b925-4a3c-47f2-9816-914fe9e0ba8d	91aac245-fdfa-485f-ad88-d4fa7f70d13d	attraction	parques-e-lazer	{"pt": "Parques e Lazer"}	6	t	2026-02-05 02:13:17.745438+00	2026-02-05 02:13:17.745438+00	Parques e Lazer	#10B981	\N	onde_ir	\N	\N
d192da37-6fe2-44c5-a446-d3dc3a1b5a55	91aac245-fdfa-485f-ad88-d4fa7f70d13d	lodging	campings	{"pt": "Campings"}	5	t	2026-02-05 02:13:17.745438+00	2026-02-05 02:13:17.745438+00	Campings	#3B82F6	\N	onde_ficar	\N	\N
657c542b-34d7-42da-862a-6fae60f53545	91aac245-fdfa-485f-ad88-d4fa7f70d13d	food	lanches-e-burgers	{"pt": "Lanches e Burgers"}	5	t	2026-02-05 02:13:17.745438+00	2026-02-05 02:13:17.745438+00	Lanches e Burgers	#F59E0B	\N	onde_comer	\N	\N
9cb95a05-40f9-40bd-8c20-e4d764eb6adc	91aac245-fdfa-485f-ad88-d4fa7f70d13d	attraction	passeios-rurais	{"pt": "Passeios Rurais"}	3	t	2026-02-05 02:13:17.745438+00	2026-02-05 02:13:17.745438+00	Passeios Rurais	#8B5CF6	\N	o_que_fazer	\N	\N
c202a41e-2250-448c-b40b-41c1fd8d04df	91aac245-fdfa-485f-ad88-d4fa7f70d13d	medical	clinicas	{"pt": "Clinicas"}	2	t	2026-02-05 02:13:17.745438+00	2026-02-05 02:13:17.745438+00	Clinicas	#EF4444	\N	guia_medico	\N	\N
23185b53-9e3e-4941-91f0-32c75b323aae	91aac245-fdfa-485f-ad88-d4fa7f70d13d	attraction	trilhas	{"pt": "Trilhas"}	1	t	2026-02-05 02:13:17.745438+00	2026-02-05 02:13:17.745438+00	Trilhas	#8B5CF6	\N	o_que_fazer	\N	\N
a379a814-f8d3-4358-beac-7e17616b1246	91aac245-fdfa-485f-ad88-d4fa7f70d13d	food	pizzarias	{"pt": "Pizzarias"}	3	t	2026-02-05 02:13:17.745438+00	2026-02-05 02:13:17.745438+00	Pizzarias	#F59E0B	\N	onde_comer	\N	\N
cfcead4f-04ad-4b39-802f-faeb5ccf8103	91aac245-fdfa-485f-ad88-d4fa7f70d13d	lodging	chales	{"pt": "Chales"}	2	t	2026-02-05 02:13:17.745438+00	2026-02-05 02:13:17.745438+00	Chales	#3B82F6	\N	onde_ficar	\N	\N
71d80b63-63c9-4b03-a27f-6dd9ebdacac3	91aac245-fdfa-485f-ad88-d4fa7f70d13d	medical	laboratorios	{"pt": "Laboratorios"}	4	t	2026-02-05 02:13:17.745438+00	2026-02-05 02:13:17.745438+00	Laboratorios	#EF4444	\N	guia_medico	\N	\N
c73542ee-a018-466b-b565-678e904077f2	91aac245-fdfa-485f-ad88-d4fa7f70d13d	attraction	mirantes	{"pt": "Mirantes"}	3	t	2026-02-05 02:13:17.745438+00	2026-02-05 02:13:17.745438+00	Mirantes	#10B981	\N	onde_ir	\N	\N
46861320-6431-4e79-bf46-39413c9a1fe4	91aac245-fdfa-485f-ad88-d4fa7f70d13d	medical	farmacias	{"pt": "Farmacias"}	3	t	2026-02-05 02:13:17.745438+00	2026-02-05 02:13:17.745438+00	Farmacias	#EF4444	\N	guia_medico	\N	\N
a8531814-ed43-46a2-af60-96c15fec89f6	91aac245-fdfa-485f-ad88-d4fa7f70d13d	attraction	cultura-e-historia	{"pt": "Cultura e Historia"}	4	t	2026-02-05 02:13:17.745438+00	2026-02-05 02:13:17.745438+00	Cultura e Historia	#8B5CF6	\N	o_que_fazer	\N	\N
2cd0fddb-0aca-432e-86e2-4d5107c27f32	010f3e62-feb2-4a65-8d09-0f698388d26f	food	pizzarias	{"pt": "Pizzarias"}	3	t	2026-02-05 02:13:17.745438+00	2026-02-05 02:13:17.745438+00	Pizzarias	#F59E0B	\N	onde_comer	\N	\N
6a2b42e1-be2e-4aa9-bb82-2316fb46e7eb	91aac245-fdfa-485f-ad88-d4fa7f70d13d	attraction	aventura-e-ecoturismo	{"pt": "Aventura e Ecoturismo"}	2	t	2026-02-05 02:13:17.745438+00	2026-02-05 02:13:17.745438+00	Aventura e Ecoturismo	#8B5CF6	\N	o_que_fazer	\N	\N
7bd5955f-bf6f-44f9-b056-2b8d03583cbd	91aac245-fdfa-485f-ad88-d4fa7f70d13d	medical	odontologia	{"pt": "Odontologia"}	5	t	2026-02-05 02:13:17.745438+00	2026-02-05 02:13:17.745438+00	Odontologia	#EF4444	\N	guia_medico	\N	\N
32f7b5ee-e469-4c60-8454-610a4a7fa7a3	91aac245-fdfa-485f-ad88-d4fa7f70d13d	attraction	grutas-e-cavernas	{"pt": "Grutas e Cavernas"}	4	t	2026-02-05 02:13:17.745438+00	2026-02-05 02:13:17.745438+00	Grutas e Cavernas	#10B981	\N	onde_ir	\N	\N
c4a629ab-7f6c-4267-9f43-f8aac1585704	91aac245-fdfa-485f-ad88-d4fa7f70d13d	lodging	casas-de-temporada	{"pt": "Casas de Temporada"}	4	t	2026-02-05 02:13:17.745438+00	2026-02-05 02:13:17.745438+00	Casas de Temporada	#3B82F6	\N	onde_ficar	\N	\N
d6311b61-4f72-42d0-84d3-6096642b6ccd	91aac245-fdfa-485f-ad88-d4fa7f70d13d	lodging	hoteis	{"pt": "Hoteis"}	3	t	2026-02-05 02:13:17.745438+00	2026-02-05 02:13:17.745438+00	Hoteis	#3B82F6	\N	onde_ficar	\N	\N
fc08ba8b-77aa-472a-9461-fde769e8ba44	9623f594-49ac-4b3f-a84e-19a261338229	food	restaurantes	{"pt": "Restaurantes"}	1	t	2026-02-05 02:13:17.745438+00	2026-02-05 02:13:17.745438+00	Restaurantes	#F59E0B	\N	onde_comer	\N	\N
4789bcca-457f-46d7-97b3-e32bfaea65cb	9623f594-49ac-4b3f-a84e-19a261338229	lodging	pousadas	{"pt": "Pousadas"}	1	t	2026-02-05 02:13:17.745438+00	2026-02-05 02:13:17.745438+00	Pousadas	#3B82F6	\N	onde_ficar	\N	\N
48d66dd1-e4b0-4545-8c2b-435d5457ce8f	9623f594-49ac-4b3f-a84e-19a261338229	attraction	morros-e-montanhas	{"pt": "Morros e Montanhas"}	5	t	2026-02-05 02:13:17.745438+00	2026-02-05 02:13:17.745438+00	Morros e Montanhas	#10B981	\N	onde_ir	\N	\N
d68a9b8b-5f66-452f-a866-ad7615f568e4	9623f594-49ac-4b3f-a84e-19a261338229	attraction	canions	{"pt": "Canions"}	2	t	2026-02-05 02:13:17.745438+00	2026-02-05 02:13:17.745438+00	Canions	#10B981	\N	onde_ir	\N	\N
2df4f94b-f3fc-4a96-84ed-a86c2e4a73c2	9623f594-49ac-4b3f-a84e-19a261338229	medical	hospitais	{"pt": "Hospitais"}	1	t	2026-02-05 02:13:17.745438+00	2026-02-05 02:13:17.745438+00	Hospitais	#EF4444	\N	guia_medico	\N	\N
7bd16747-b7a6-4f55-8088-7b12984f7de8	9623f594-49ac-4b3f-a84e-19a261338229	food	churrascarias	{"pt": "Churrascarias"}	4	t	2026-02-05 02:13:17.745438+00	2026-02-05 02:13:17.745438+00	Churrascarias	#F59E0B	\N	onde_comer	\N	\N
5d1355b2-15e7-4e2d-94fc-3cb4e82ebe81	9623f594-49ac-4b3f-a84e-19a261338229	attraction	experiencias-locais	{"pt": "Experiencias Locais"}	5	t	2026-02-05 02:13:17.745438+00	2026-02-05 02:13:17.745438+00	Experiencias Locais	#8B5CF6	\N	o_que_fazer	\N	\N
7919c391-77b8-4494-b968-4e6ef3b70c53	9623f594-49ac-4b3f-a84e-19a261338229	attraction	cachoeiras	{"pt": "Cachoeiras"}	1	t	2026-02-05 02:13:17.745438+00	2026-02-05 02:13:17.745438+00	Cachoeiras	#10B981	\N	onde_ir	\N	\N
7655af93-9973-447e-aeee-a0beaffd2bf2	9623f594-49ac-4b3f-a84e-19a261338229	food	cafeterias	{"pt": "Cafeterias"}	2	t	2026-02-05 02:13:17.745438+00	2026-02-05 02:13:17.745438+00	Cafeterias	#F59E0B	\N	onde_comer	\N	\N
7a4362d4-58f8-4b86-b6cd-9b061fd474eb	9623f594-49ac-4b3f-a84e-19a261338229	attraction	parques-e-lazer	{"pt": "Parques e Lazer"}	6	t	2026-02-05 02:13:17.745438+00	2026-02-05 02:13:17.745438+00	Parques e Lazer	#10B981	\N	onde_ir	\N	\N
d04d7df2-57d6-468b-a12f-348ea43d07be	9623f594-49ac-4b3f-a84e-19a261338229	lodging	campings	{"pt": "Campings"}	5	t	2026-02-05 02:13:17.745438+00	2026-02-05 02:13:17.745438+00	Campings	#3B82F6	\N	onde_ficar	\N	\N
56c3b514-1ca5-4339-96ce-e572149eb488	9623f594-49ac-4b3f-a84e-19a261338229	food	lanches-e-burgers	{"pt": "Lanches e Burgers"}	5	t	2026-02-05 02:13:17.745438+00	2026-02-05 02:13:17.745438+00	Lanches e Burgers	#F59E0B	\N	onde_comer	\N	\N
552ce7cb-364d-437c-ab9a-6f773b40bba6	9623f594-49ac-4b3f-a84e-19a261338229	attraction	passeios-rurais	{"pt": "Passeios Rurais"}	3	t	2026-02-05 02:13:17.745438+00	2026-02-05 02:13:17.745438+00	Passeios Rurais	#8B5CF6	\N	o_que_fazer	\N	\N
5727c5ab-4c49-4234-ba36-350bd86ceb12	9623f594-49ac-4b3f-a84e-19a261338229	medical	clinicas	{"pt": "Clinicas"}	2	t	2026-02-05 02:13:17.745438+00	2026-02-05 02:13:17.745438+00	Clinicas	#EF4444	\N	guia_medico	\N	\N
1a566679-906f-4391-b9ad-27c525fe6d0f	9623f594-49ac-4b3f-a84e-19a261338229	attraction	trilhas	{"pt": "Trilhas"}	1	t	2026-02-05 02:13:17.745438+00	2026-02-05 02:13:17.745438+00	Trilhas	#8B5CF6	\N	o_que_fazer	\N	\N
1132770c-2aaa-4489-bc60-73c68fc45b62	9623f594-49ac-4b3f-a84e-19a261338229	food	pizzarias	{"pt": "Pizzarias"}	3	t	2026-02-05 02:13:17.745438+00	2026-02-05 02:13:17.745438+00	Pizzarias	#F59E0B	\N	onde_comer	\N	\N
b0258e7b-1e11-47fe-9491-00f781653a22	9623f594-49ac-4b3f-a84e-19a261338229	lodging	chales	{"pt": "Chales"}	2	t	2026-02-05 02:13:17.745438+00	2026-02-05 02:13:17.745438+00	Chales	#3B82F6	\N	onde_ficar	\N	\N
99f6ac85-5988-435a-81bd-ccc70447b310	9623f594-49ac-4b3f-a84e-19a261338229	medical	laboratorios	{"pt": "Laboratorios"}	4	t	2026-02-05 02:13:17.745438+00	2026-02-05 02:13:17.745438+00	Laboratorios	#EF4444	\N	guia_medico	\N	\N
f0de729f-4466-4873-9ff1-bbb03f3029fc	9623f594-49ac-4b3f-a84e-19a261338229	attraction	mirantes	{"pt": "Mirantes"}	3	t	2026-02-05 02:13:17.745438+00	2026-02-05 02:13:17.745438+00	Mirantes	#10B981	\N	onde_ir	\N	\N
b2fe304f-3c38-4c41-8de0-2c6cfd0e0b19	9623f594-49ac-4b3f-a84e-19a261338229	medical	farmacias	{"pt": "Farmacias"}	3	t	2026-02-05 02:13:17.745438+00	2026-02-05 02:13:17.745438+00	Farmacias	#EF4444	\N	guia_medico	\N	\N
957d7831-c97f-475d-bb94-8468c5f09b1a	9623f594-49ac-4b3f-a84e-19a261338229	attraction	cultura-e-historia	{"pt": "Cultura e Historia"}	4	t	2026-02-05 02:13:17.745438+00	2026-02-05 02:13:17.745438+00	Cultura e Historia	#8B5CF6	\N	o_que_fazer	\N	\N
7527d2a1-1705-441f-897b-3056a347ddac	9623f594-49ac-4b3f-a84e-19a261338229	attraction	aventura-e-ecoturismo	{"pt": "Aventura e Ecoturismo"}	2	t	2026-02-05 02:13:17.745438+00	2026-02-05 02:13:17.745438+00	Aventura e Ecoturismo	#8B5CF6	\N	o_que_fazer	\N	\N
3df2e339-e2eb-4b9c-9fdd-4166fdeb2900	9623f594-49ac-4b3f-a84e-19a261338229	medical	odontologia	{"pt": "Odontologia"}	5	t	2026-02-05 02:13:17.745438+00	2026-02-05 02:13:17.745438+00	Odontologia	#EF4444	\N	guia_medico	\N	\N
ea6f4b56-2efd-4b7d-a15c-06d21f318943	9623f594-49ac-4b3f-a84e-19a261338229	attraction	grutas-e-cavernas	{"pt": "Grutas e Cavernas"}	4	t	2026-02-05 02:13:17.745438+00	2026-02-05 02:13:17.745438+00	Grutas e Cavernas	#10B981	\N	onde_ir	\N	\N
6076c5cc-95df-4446-9c62-a4e442ef4e8f	9623f594-49ac-4b3f-a84e-19a261338229	lodging	casas-de-temporada	{"pt": "Casas de Temporada"}	4	t	2026-02-05 02:13:17.745438+00	2026-02-05 02:13:17.745438+00	Casas de Temporada	#3B82F6	\N	onde_ficar	\N	\N
233442c7-873b-41c3-b362-fe63a2b6b350	9623f594-49ac-4b3f-a84e-19a261338229	lodging	hoteis	{"pt": "Hoteis"}	3	t	2026-02-05 02:13:17.745438+00	2026-02-05 02:13:17.745438+00	Hoteis	#3B82F6	\N	onde_ficar	\N	\N
5bb0a976-1d3b-4c97-906b-541b93e91cfc	010f3e62-feb2-4a65-8d09-0f698388d26f	food	restaurantes	{"pt": "Restaurantes"}	1	t	2026-02-05 02:13:17.745438+00	2026-02-05 02:13:17.745438+00	Restaurantes	#F59E0B	\N	onde_comer	\N	\N
ff43290d-0866-414d-a388-d59ddcbfa4e3	010f3e62-feb2-4a65-8d09-0f698388d26f	lodging	pousadas	{"pt": "Pousadas"}	1	t	2026-02-05 02:13:17.745438+00	2026-02-05 02:13:17.745438+00	Pousadas	#3B82F6	\N	onde_ficar	\N	\N
9bb1d699-e9d4-4f71-bda0-3f4feeef531d	010f3e62-feb2-4a65-8d09-0f698388d26f	attraction	morros-e-montanhas	{"pt": "Morros e Montanhas"}	5	t	2026-02-05 02:13:17.745438+00	2026-02-05 02:13:17.745438+00	Morros e Montanhas	#10B981	\N	onde_ir	\N	\N
08a4cb0f-9caf-4538-ae97-89f70bde1519	010f3e62-feb2-4a65-8d09-0f698388d26f	attraction	canions	{"pt": "Canions"}	2	t	2026-02-05 02:13:17.745438+00	2026-02-05 02:13:17.745438+00	Canions	#10B981	\N	onde_ir	\N	\N
89e1428b-e3b6-4533-84ba-99d139f78cde	010f3e62-feb2-4a65-8d09-0f698388d26f	medical	hospitais	{"pt": "Hospitais"}	1	t	2026-02-05 02:13:17.745438+00	2026-02-05 02:13:17.745438+00	Hospitais	#EF4444	\N	guia_medico	\N	\N
7be57f5d-4e76-4739-8c0e-9ae83cea4815	010f3e62-feb2-4a65-8d09-0f698388d26f	food	churrascarias	{"pt": "Churrascarias"}	4	t	2026-02-05 02:13:17.745438+00	2026-02-05 02:13:17.745438+00	Churrascarias	#F59E0B	\N	onde_comer	\N	\N
6409b97b-0846-44bd-ae20-4e3409fd60df	010f3e62-feb2-4a65-8d09-0f698388d26f	attraction	experiencias-locais	{"pt": "Experiencias Locais"}	5	t	2026-02-05 02:13:17.745438+00	2026-02-05 02:13:17.745438+00	Experiencias Locais	#8B5CF6	\N	o_que_fazer	\N	\N
01de6b3e-2177-4697-8f74-a5763dc8e36d	010f3e62-feb2-4a65-8d09-0f698388d26f	attraction	cachoeiras	{"pt": "Cachoeiras"}	1	t	2026-02-05 02:13:17.745438+00	2026-02-05 02:13:17.745438+00	Cachoeiras	#10B981	\N	onde_ir	\N	\N
87258e85-839d-4d78-a78b-62be83f8fe7c	010f3e62-feb2-4a65-8d09-0f698388d26f	food	cafeterias	{"pt": "Cafeterias"}	2	t	2026-02-05 02:13:17.745438+00	2026-02-05 02:13:17.745438+00	Cafeterias	#F59E0B	\N	onde_comer	\N	\N
e1dd8d08-e013-47a8-a7ce-e54f9c9a5cc4	010f3e62-feb2-4a65-8d09-0f698388d26f	attraction	parques-e-lazer	{"pt": "Parques e Lazer"}	6	t	2026-02-05 02:13:17.745438+00	2026-02-05 02:13:17.745438+00	Parques e Lazer	#10B981	\N	onde_ir	\N	\N
07173b11-e568-4938-a409-e025a3a3bdea	010f3e62-feb2-4a65-8d09-0f698388d26f	lodging	campings	{"pt": "Campings"}	5	t	2026-02-05 02:13:17.745438+00	2026-02-05 02:13:17.745438+00	Campings	#3B82F6	\N	onde_ficar	\N	\N
25e77e97-776e-4739-8a49-64606e89174f	010f3e62-feb2-4a65-8d09-0f698388d26f	food	lanches-e-burgers	{"pt": "Lanches e Burgers"}	5	t	2026-02-05 02:13:17.745438+00	2026-02-05 02:13:17.745438+00	Lanches e Burgers	#F59E0B	\N	onde_comer	\N	\N
d3907eb8-011c-4147-a46b-276e64db7b92	010f3e62-feb2-4a65-8d09-0f698388d26f	attraction	passeios-rurais	{"pt": "Passeios Rurais"}	3	t	2026-02-05 02:13:17.745438+00	2026-02-05 02:13:17.745438+00	Passeios Rurais	#8B5CF6	\N	o_que_fazer	\N	\N
bcfa5931-3bc8-4a11-906a-8c6da45798a4	010f3e62-feb2-4a65-8d09-0f698388d26f	medical	clinicas	{"pt": "Clinicas"}	2	t	2026-02-05 02:13:17.745438+00	2026-02-05 02:13:17.745438+00	Clinicas	#EF4444	\N	guia_medico	\N	\N
71ce077c-f4ad-4cfe-8d93-f5b3a48d4dcf	010f3e62-feb2-4a65-8d09-0f698388d26f	attraction	trilhas	{"pt": "Trilhas"}	1	t	2026-02-05 02:13:17.745438+00	2026-02-05 02:13:17.745438+00	Trilhas	#8B5CF6	\N	o_que_fazer	\N	\N
ff8b0e48-a1c5-4897-9fdc-235878eab285	010f3e62-feb2-4a65-8d09-0f698388d26f	lodging	chales	{"pt": "Chales"}	2	t	2026-02-05 02:13:17.745438+00	2026-02-05 02:13:17.745438+00	Chales	#3B82F6	\N	onde_ficar	\N	\N
a412be23-41ff-41bf-9e58-975d7b97b69a	010f3e62-feb2-4a65-8d09-0f698388d26f	medical	laboratorios	{"pt": "Laboratorios"}	4	t	2026-02-05 02:13:17.745438+00	2026-02-05 02:13:17.745438+00	Laboratorios	#EF4444	\N	guia_medico	\N	\N
76a704dc-e3d4-41f3-9668-562d18c3fd5a	010f3e62-feb2-4a65-8d09-0f698388d26f	attraction	mirantes	{"pt": "Mirantes"}	3	t	2026-02-05 02:13:17.745438+00	2026-02-05 02:13:17.745438+00	Mirantes	#10B981	\N	onde_ir	\N	\N
b03ee1f5-5c34-4bcd-9239-57e091bff7be	010f3e62-feb2-4a65-8d09-0f698388d26f	medical	farmacias	{"pt": "Farmacias"}	3	t	2026-02-05 02:13:17.745438+00	2026-02-05 02:13:17.745438+00	Farmacias	#EF4444	\N	guia_medico	\N	\N
8fa5ae49-9e6a-46f0-8176-03fa9054a11b	010f3e62-feb2-4a65-8d09-0f698388d26f	attraction	cultura-e-historia	{"pt": "Cultura e Historia"}	4	t	2026-02-05 02:13:17.745438+00	2026-02-05 02:13:17.745438+00	Cultura e Historia	#8B5CF6	\N	o_que_fazer	\N	\N
966a77f3-a4a3-4c2f-8eae-eaad88d488f6	010f3e62-feb2-4a65-8d09-0f698388d26f	attraction	aventura-e-ecoturismo	{"pt": "Aventura e Ecoturismo"}	2	t	2026-02-05 02:13:17.745438+00	2026-02-05 02:13:17.745438+00	Aventura e Ecoturismo	#8B5CF6	\N	o_que_fazer	\N	\N
9fb60691-aff7-4911-85e8-82b7d290c189	010f3e62-feb2-4a65-8d09-0f698388d26f	medical	odontologia	{"pt": "Odontologia"}	5	t	2026-02-05 02:13:17.745438+00	2026-02-05 02:13:17.745438+00	Odontologia	#EF4444	\N	guia_medico	\N	\N
c2e67a66-3eca-47fc-819b-9b4ee1a6ddd0	010f3e62-feb2-4a65-8d09-0f698388d26f	attraction	grutas-e-cavernas	{"pt": "Grutas e Cavernas"}	4	t	2026-02-05 02:13:17.745438+00	2026-02-05 02:13:17.745438+00	Grutas e Cavernas	#10B981	\N	onde_ir	\N	\N
fefda62d-810b-45cd-b8e6-21c8ebd12bb7	010f3e62-feb2-4a65-8d09-0f698388d26f	lodging	casas-de-temporada	{"pt": "Casas de Temporada"}	4	t	2026-02-05 02:13:17.745438+00	2026-02-05 02:13:17.745438+00	Casas de Temporada	#3B82F6	\N	onde_ficar	\N	\N
f82c3ef1-361f-4d69-9315-c3e4a1983402	010f3e62-feb2-4a65-8d09-0f698388d26f	lodging	hoteis	{"pt": "Hoteis"}	3	t	2026-02-05 02:13:17.745438+00	2026-02-05 02:13:17.745438+00	Hoteis	#3B82F6	\N	onde_ficar	\N	\N
\.


--
-- TOC entry 5176 (class 0 OID 115992)
-- Dependencies: 365
-- Data for Name: place_images; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.place_images (id, place_id, url, caption, sort_order, is_primary, created_at) FROM stdin;
d8a599e0-d507-4a68-a265-13251c88fb0a	274d6acc-4874-4ac0-af0b-ac0994db25cf	https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?w=1200&q=80	Foto 1	0	t	2026-02-07 10:00:47.811545+00
87b8c9fc-a126-4596-9dd1-e9c2c93327c8	274d6acc-4874-4ac0-af0b-ac0994db25cf	https://images.unsplash.com/photo-1555396273-367ea4eb4db5?w=1200&q=80	Foto 2	1	f	2026-02-07 10:00:47.811545+00
e4712d61-098f-4207-bc37-fc77eba994aa	274d6acc-4874-4ac0-af0b-ac0994db25cf	https://images.unsplash.com/photo-1514933651103-005eec06c04b?w=1200&q=80	Foto 3	2	f	2026-02-07 10:00:47.811545+00
3a4f3fbd-4f2d-4421-b66e-1243ae8009ab	274d6acc-4874-4ac0-af0b-ac0994db25cf	https://images.unsplash.com/photo-1552566626-52f8b828add9?w=1200&q=80	Foto 4	3	f	2026-02-07 10:00:47.811545+00
b3051c60-fb15-4df7-8dc7-db1cf25bbd26	002bcaa0-fab7-4e58-8b76-388e4597bfdc	https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?w=1200&q=80	Foto 1	0	t	2026-02-07 10:00:47.811545+00
924d0f11-9039-4702-b183-581693ee7c85	002bcaa0-fab7-4e58-8b76-388e4597bfdc	https://images.unsplash.com/photo-1555396273-367ea4eb4db5?w=1200&q=80	Foto 2	1	f	2026-02-07 10:00:47.811545+00
3b78ab84-f16c-4cb3-94f1-5b2f8e81c118	002bcaa0-fab7-4e58-8b76-388e4597bfdc	https://images.unsplash.com/photo-1514933651103-005eec06c04b?w=1200&q=80	Foto 3	2	f	2026-02-07 10:00:47.811545+00
ac3c17f6-95a9-41de-a359-091fb03f5694	002bcaa0-fab7-4e58-8b76-388e4597bfdc	https://images.unsplash.com/photo-1552566626-52f8b828add9?w=1200&q=80	Foto 4	3	f	2026-02-07 10:00:47.811545+00
72038573-f461-4223-a555-57f1ffe8b072	2d6c170e-a265-4d51-9199-7367c9d83934	https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?w=1200&q=80	Foto 1	0	t	2026-02-07 10:00:47.811545+00
5068e2e3-c2a9-4b4f-a846-322e40037e39	2d6c170e-a265-4d51-9199-7367c9d83934	https://images.unsplash.com/photo-1555396273-367ea4eb4db5?w=1200&q=80	Foto 2	1	f	2026-02-07 10:00:47.811545+00
5d807601-39ab-422c-af8a-7319ccd20c85	2d6c170e-a265-4d51-9199-7367c9d83934	https://images.unsplash.com/photo-1514933651103-005eec06c04b?w=1200&q=80	Foto 3	2	f	2026-02-07 10:00:47.811545+00
d7d6f8fa-24a9-4452-8830-565a187eb8e0	2d6c170e-a265-4d51-9199-7367c9d83934	https://images.unsplash.com/photo-1552566626-52f8b828add9?w=1200&q=80	Foto 4	3	f	2026-02-07 10:00:47.811545+00
06695fc9-70e0-4895-a446-c1617ab2d8e7	84935995-ce00-4906-813e-0ddeb8ea8ac2	https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?w=1200&q=80	Foto 1	0	t	2026-02-07 10:00:47.811545+00
fc54654b-3924-46ab-97cc-ce0d369d9913	84935995-ce00-4906-813e-0ddeb8ea8ac2	https://images.unsplash.com/photo-1555396273-367ea4eb4db5?w=1200&q=80	Foto 2	1	f	2026-02-07 10:00:47.811545+00
1bbd4e74-8617-4f2a-bce5-3f9d64cf384b	84935995-ce00-4906-813e-0ddeb8ea8ac2	https://images.unsplash.com/photo-1514933651103-005eec06c04b?w=1200&q=80	Foto 3	2	f	2026-02-07 10:00:47.811545+00
cb5c48f0-7b3f-4039-9eeb-8a4f20f28a93	84935995-ce00-4906-813e-0ddeb8ea8ac2	https://images.unsplash.com/photo-1552566626-52f8b828add9?w=1200&q=80	Foto 4	3	f	2026-02-07 10:00:47.811545+00
6c707653-e77a-4fc5-aaeb-0d952be871b7	ce2043f0-096d-497d-a810-d98637ad4999	https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?w=1200&q=80	Foto 1	0	t	2026-02-07 10:00:47.811545+00
c14ac8ba-7328-4ef9-86fc-69df06107e4d	ce2043f0-096d-497d-a810-d98637ad4999	https://images.unsplash.com/photo-1555396273-367ea4eb4db5?w=1200&q=80	Foto 2	1	f	2026-02-07 10:00:47.811545+00
d9d542a5-c768-4b4c-b9da-9a7fc1b83e3a	ce2043f0-096d-497d-a810-d98637ad4999	https://images.unsplash.com/photo-1514933651103-005eec06c04b?w=1200&q=80	Foto 3	2	f	2026-02-07 10:00:47.811545+00
e2c1e676-c929-4bee-a0c3-688ae71fb1c8	ce2043f0-096d-497d-a810-d98637ad4999	https://images.unsplash.com/photo-1552566626-52f8b828add9?w=1200&q=80	Foto 4	3	f	2026-02-07 10:00:47.811545+00
873fe894-49b8-4f21-b4ce-8245a925b2a2	59a82ee7-1449-430d-9871-3158f3d6355e	https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?w=1200&q=80	Foto 1	0	t	2026-02-07 10:00:47.811545+00
8ed13225-19fb-46aa-913b-dfa27fedf098	59a82ee7-1449-430d-9871-3158f3d6355e	https://images.unsplash.com/photo-1555396273-367ea4eb4db5?w=1200&q=80	Foto 2	1	f	2026-02-07 10:00:47.811545+00
5bbe7659-eef7-4e14-88f0-c29fea4bcddb	59a82ee7-1449-430d-9871-3158f3d6355e	https://images.unsplash.com/photo-1514933651103-005eec06c04b?w=1200&q=80	Foto 3	2	f	2026-02-07 10:00:47.811545+00
9c53bee8-14da-4c4f-b596-6be454c931b6	59a82ee7-1449-430d-9871-3158f3d6355e	https://images.unsplash.com/photo-1552566626-52f8b828add9?w=1200&q=80	Foto 4	3	f	2026-02-07 10:00:47.811545+00
48b5dbaf-f36b-4946-be65-92b6fc53cc46	220759e0-1216-44ea-aa2c-9a1700a40578	https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?w=1200&q=80	Foto 1	0	t	2026-02-07 10:00:47.811545+00
03238112-92ae-4483-b0bb-9258888ef1d7	220759e0-1216-44ea-aa2c-9a1700a40578	https://images.unsplash.com/photo-1555396273-367ea4eb4db5?w=1200&q=80	Foto 2	1	f	2026-02-07 10:00:47.811545+00
39260d76-6640-4384-9b25-41e584f2d573	220759e0-1216-44ea-aa2c-9a1700a40578	https://images.unsplash.com/photo-1514933651103-005eec06c04b?w=1200&q=80	Foto 3	2	f	2026-02-07 10:00:47.811545+00
1bacf25a-3abf-4c67-b1b3-c3480e18875b	220759e0-1216-44ea-aa2c-9a1700a40578	https://images.unsplash.com/photo-1552566626-52f8b828add9?w=1200&q=80	Foto 4	3	f	2026-02-07 10:00:47.811545+00
9a9b1af9-e4f0-4cf0-8472-3e158a682d24	c26acdc7-92b6-4c57-8460-a0b5cbfcf382	https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?w=1200&q=80	Foto 1	0	t	2026-02-07 10:00:47.811545+00
6948e6d5-b1b7-453e-a113-2c9051d9e2f2	c26acdc7-92b6-4c57-8460-a0b5cbfcf382	https://images.unsplash.com/photo-1555396273-367ea4eb4db5?w=1200&q=80	Foto 2	1	f	2026-02-07 10:00:47.811545+00
c67071f2-4017-4ba4-910d-5417340e0138	c26acdc7-92b6-4c57-8460-a0b5cbfcf382	https://images.unsplash.com/photo-1514933651103-005eec06c04b?w=1200&q=80	Foto 3	2	f	2026-02-07 10:00:47.811545+00
dcd25fca-6094-4b73-8f96-77c617a02e62	c26acdc7-92b6-4c57-8460-a0b5cbfcf382	https://images.unsplash.com/photo-1552566626-52f8b828add9?w=1200&q=80	Foto 4	3	f	2026-02-07 10:00:47.811545+00
aa3be049-f9d2-439a-9738-cf7bff638fc6	50c62e8d-62e8-480f-a3d5-b9aac9b3abdd	https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?w=1200&q=80	Foto 1	0	t	2026-02-07 10:00:47.811545+00
9a696f5f-2d1a-429c-9155-4c666b7aef18	50c62e8d-62e8-480f-a3d5-b9aac9b3abdd	https://images.unsplash.com/photo-1555396273-367ea4eb4db5?w=1200&q=80	Foto 2	1	f	2026-02-07 10:00:47.811545+00
378bbd20-10a1-438a-8fea-5ada859b80ff	50c62e8d-62e8-480f-a3d5-b9aac9b3abdd	https://images.unsplash.com/photo-1514933651103-005eec06c04b?w=1200&q=80	Foto 3	2	f	2026-02-07 10:00:47.811545+00
fa29c9dd-99a2-463b-a756-5d4d938871f8	50c62e8d-62e8-480f-a3d5-b9aac9b3abdd	https://images.unsplash.com/photo-1552566626-52f8b828add9?w=1200&q=80	Foto 4	3	f	2026-02-07 10:00:47.811545+00
24005649-232c-437c-bf93-4a86e0a465d2	7e27bc20-7ca9-4b1e-9cd0-004feb337066	https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?w=1200&q=80	Foto 1	0	t	2026-02-07 10:00:47.811545+00
27f0f60b-e29d-44c7-bbf2-46efb50b0bf3	7e27bc20-7ca9-4b1e-9cd0-004feb337066	https://images.unsplash.com/photo-1555396273-367ea4eb4db5?w=1200&q=80	Foto 2	1	f	2026-02-07 10:00:47.811545+00
a49bb334-445d-49f8-a624-8add61e8a22b	7e27bc20-7ca9-4b1e-9cd0-004feb337066	https://images.unsplash.com/photo-1514933651103-005eec06c04b?w=1200&q=80	Foto 3	2	f	2026-02-07 10:00:47.811545+00
f7020b7a-27d6-4bc5-b2d1-b1eee8b4ccb5	7e27bc20-7ca9-4b1e-9cd0-004feb337066	https://images.unsplash.com/photo-1552566626-52f8b828add9?w=1200&q=80	Foto 4	3	f	2026-02-07 10:00:47.811545+00
b4b2522d-2307-4857-ad92-a40b37f8bf20	613199b4-9ae8-47a9-8599-1bb9b18c8493	https://images.unsplash.com/photo-1566073771259-6a8506099945?w=1200&q=80	Foto 1	0	t	2026-02-07 10:00:47.811545+00
f1115897-1f9c-46f3-8eb3-478b324257d6	613199b4-9ae8-47a9-8599-1bb9b18c8493	https://images.unsplash.com/photo-1582719508461-905c673771fd?w=1200&q=80	Foto 2	1	f	2026-02-07 10:00:47.811545+00
01d681a5-45d0-4a76-adc7-3a7499309a5e	613199b4-9ae8-47a9-8599-1bb9b18c8493	https://images.unsplash.com/photo-1520250497591-112f2f40a3f4?w=1200&q=80	Foto 3	2	f	2026-02-07 10:00:47.811545+00
f15d49c9-972c-401d-95a5-1c67d0d95de9	613199b4-9ae8-47a9-8599-1bb9b18c8493	https://images.unsplash.com/photo-1564501049412-61c2a3083791?w=1200&q=80	Foto 4	3	f	2026-02-07 10:00:47.811545+00
176935f8-7f9d-4330-9b39-9e766b7cb086	2d55419a-66fb-4a69-8e2d-786c3a878a5e	https://images.unsplash.com/photo-1566073771259-6a8506099945?w=1200&q=80	Foto 1	0	t	2026-02-07 10:00:47.811545+00
6fb613f4-7919-4293-8dbd-7d49f9477878	2d55419a-66fb-4a69-8e2d-786c3a878a5e	https://images.unsplash.com/photo-1582719508461-905c673771fd?w=1200&q=80	Foto 2	1	f	2026-02-07 10:00:47.811545+00
28fab342-45ac-4b4c-8815-bcc37ac06c6c	2d55419a-66fb-4a69-8e2d-786c3a878a5e	https://images.unsplash.com/photo-1520250497591-112f2f40a3f4?w=1200&q=80	Foto 3	2	f	2026-02-07 10:00:47.811545+00
01822038-2cf7-4a59-82ec-274fc3de7d25	2d55419a-66fb-4a69-8e2d-786c3a878a5e	https://images.unsplash.com/photo-1564501049412-61c2a3083791?w=1200&q=80	Foto 4	3	f	2026-02-07 10:00:47.811545+00
f06081ac-6e06-4f45-8e96-de62bb04d219	3b655560-5417-4c4d-a48a-8e0105254dae	https://images.unsplash.com/photo-1566073771259-6a8506099945?w=1200&q=80	Foto 1	0	t	2026-02-07 10:00:47.811545+00
15a346ff-95da-4e8e-9a15-1107494b4393	3b655560-5417-4c4d-a48a-8e0105254dae	https://images.unsplash.com/photo-1582719508461-905c673771fd?w=1200&q=80	Foto 2	1	f	2026-02-07 10:00:47.811545+00
360020b4-bc37-4838-aafa-8718a3f98337	3b655560-5417-4c4d-a48a-8e0105254dae	https://images.unsplash.com/photo-1520250497591-112f2f40a3f4?w=1200&q=80	Foto 3	2	f	2026-02-07 10:00:47.811545+00
65e027ac-7bac-475f-b43c-cc35e2c32fc8	3b655560-5417-4c4d-a48a-8e0105254dae	https://images.unsplash.com/photo-1564501049412-61c2a3083791?w=1200&q=80	Foto 4	3	f	2026-02-07 10:00:47.811545+00
4b4edb86-60db-4104-a409-305a88994707	b11b62e2-dec8-4712-ac45-992a71dd1630	https://images.unsplash.com/photo-1566073771259-6a8506099945?w=1200&q=80	Foto 1	0	t	2026-02-07 10:00:47.811545+00
78842a80-732e-4fe6-867e-514fb9aeb8d5	b11b62e2-dec8-4712-ac45-992a71dd1630	https://images.unsplash.com/photo-1582719508461-905c673771fd?w=1200&q=80	Foto 2	1	f	2026-02-07 10:00:47.811545+00
4068c4f3-7c92-45c3-8e11-9a7af1063c74	b11b62e2-dec8-4712-ac45-992a71dd1630	https://images.unsplash.com/photo-1520250497591-112f2f40a3f4?w=1200&q=80	Foto 3	2	f	2026-02-07 10:00:47.811545+00
a736b4ec-8176-4480-8dde-9048774014f2	b11b62e2-dec8-4712-ac45-992a71dd1630	https://images.unsplash.com/photo-1564501049412-61c2a3083791?w=1200&q=80	Foto 4	3	f	2026-02-07 10:00:47.811545+00
12c9b5a4-e7e4-473f-a0ea-5e14233c484b	f9733a8f-6630-4d34-906e-aa46b7934966	https://images.unsplash.com/photo-1566073771259-6a8506099945?w=1200&q=80	Foto 1	0	t	2026-02-07 10:00:47.811545+00
f4c21a79-6280-4e9d-8418-259a642083a3	f9733a8f-6630-4d34-906e-aa46b7934966	https://images.unsplash.com/photo-1582719508461-905c673771fd?w=1200&q=80	Foto 2	1	f	2026-02-07 10:00:47.811545+00
7fd0ea55-d00d-4240-8ac5-c58a9e9932ec	f9733a8f-6630-4d34-906e-aa46b7934966	https://images.unsplash.com/photo-1520250497591-112f2f40a3f4?w=1200&q=80	Foto 3	2	f	2026-02-07 10:00:47.811545+00
c92abce2-9a93-4a8f-b1c6-767e99838c63	f9733a8f-6630-4d34-906e-aa46b7934966	https://images.unsplash.com/photo-1564501049412-61c2a3083791?w=1200&q=80	Foto 4	3	f	2026-02-07 10:00:47.811545+00
0e4bcfc9-31f3-4583-b357-e6a548cec84f	5693c4d6-91a2-4575-9e9a-7bf85db8c1b3	https://images.unsplash.com/photo-1566073771259-6a8506099945?w=1200&q=80	Foto 1	0	t	2026-02-07 10:00:47.811545+00
d791159e-1aa5-45d3-91c1-366f0f00a254	5693c4d6-91a2-4575-9e9a-7bf85db8c1b3	https://images.unsplash.com/photo-1582719508461-905c673771fd?w=1200&q=80	Foto 2	1	f	2026-02-07 10:00:47.811545+00
9209120c-c100-444e-914f-278ffd889457	5693c4d6-91a2-4575-9e9a-7bf85db8c1b3	https://images.unsplash.com/photo-1520250497591-112f2f40a3f4?w=1200&q=80	Foto 3	2	f	2026-02-07 10:00:47.811545+00
4bb173e4-31bb-4968-a11e-d6a2b5dc1d5d	5693c4d6-91a2-4575-9e9a-7bf85db8c1b3	https://images.unsplash.com/photo-1564501049412-61c2a3083791?w=1200&q=80	Foto 4	3	f	2026-02-07 10:00:47.811545+00
26212533-0d65-406c-a361-ebba9b0d2c31	4e2e55f1-db37-45c9-bef2-cdc80a3481c0	https://images.unsplash.com/photo-1566073771259-6a8506099945?w=1200&q=80	Foto 1	0	t	2026-02-07 10:00:47.811545+00
485d270d-10a0-4928-87d6-ad9acb82fca7	4e2e55f1-db37-45c9-bef2-cdc80a3481c0	https://images.unsplash.com/photo-1582719508461-905c673771fd?w=1200&q=80	Foto 2	1	f	2026-02-07 10:00:47.811545+00
eb99f7f8-33f0-4a70-a5f3-161663f1afbf	4e2e55f1-db37-45c9-bef2-cdc80a3481c0	https://images.unsplash.com/photo-1520250497591-112f2f40a3f4?w=1200&q=80	Foto 3	2	f	2026-02-07 10:00:47.811545+00
d54daa0e-2409-4ccd-9b8e-4a3b3a2b2511	4e2e55f1-db37-45c9-bef2-cdc80a3481c0	https://images.unsplash.com/photo-1564501049412-61c2a3083791?w=1200&q=80	Foto 4	3	f	2026-02-07 10:00:47.811545+00
c94af5ba-65b4-485d-ac37-e325b41e22a0	9dab304e-4187-4a2c-a67f-0ce5806bb98f	https://images.unsplash.com/photo-1566073771259-6a8506099945?w=1200&q=80	Foto 1	0	t	2026-02-07 10:00:47.811545+00
fff25b6c-96cf-4c75-88f0-17c14dba57e0	9dab304e-4187-4a2c-a67f-0ce5806bb98f	https://images.unsplash.com/photo-1582719508461-905c673771fd?w=1200&q=80	Foto 2	1	f	2026-02-07 10:00:47.811545+00
7e49a5b8-3a50-4b07-aa3e-480ea4f20807	9dab304e-4187-4a2c-a67f-0ce5806bb98f	https://images.unsplash.com/photo-1520250497591-112f2f40a3f4?w=1200&q=80	Foto 3	2	f	2026-02-07 10:00:47.811545+00
9421a512-4463-47b5-874b-9f43cb718641	9dab304e-4187-4a2c-a67f-0ce5806bb98f	https://images.unsplash.com/photo-1564501049412-61c2a3083791?w=1200&q=80	Foto 4	3	f	2026-02-07 10:00:47.811545+00
8c96c9e9-30ea-4212-b5cd-0a4d40699a55	75ee4940-a53f-4369-b3a2-43cb24969911	https://images.unsplash.com/photo-1566073771259-6a8506099945?w=1200&q=80	Foto 1	0	t	2026-02-07 10:00:47.811545+00
fa255519-53e1-4513-a3a7-9f5aa29c6e9e	75ee4940-a53f-4369-b3a2-43cb24969911	https://images.unsplash.com/photo-1582719508461-905c673771fd?w=1200&q=80	Foto 2	1	f	2026-02-07 10:00:47.811545+00
da46acc1-61d4-4823-b266-4328a5a70879	75ee4940-a53f-4369-b3a2-43cb24969911	https://images.unsplash.com/photo-1520250497591-112f2f40a3f4?w=1200&q=80	Foto 3	2	f	2026-02-07 10:00:47.811545+00
d503b623-a4f0-4339-af07-bff52d0d13e9	75ee4940-a53f-4369-b3a2-43cb24969911	https://images.unsplash.com/photo-1564501049412-61c2a3083791?w=1200&q=80	Foto 4	3	f	2026-02-07 10:00:47.811545+00
6cd37aa6-2f39-4b09-898b-4b64fb388bb1	7610048b-a323-4590-a2f6-3615373700a7	https://images.unsplash.com/photo-1566073771259-6a8506099945?w=1200&q=80	Foto 1	0	t	2026-02-07 10:00:47.811545+00
e94465ff-d5b5-4c86-85c8-08806db43cbe	7610048b-a323-4590-a2f6-3615373700a7	https://images.unsplash.com/photo-1582719508461-905c673771fd?w=1200&q=80	Foto 2	1	f	2026-02-07 10:00:47.811545+00
5f8d6b9f-5177-4c90-bec5-edff3dd36a5d	7610048b-a323-4590-a2f6-3615373700a7	https://images.unsplash.com/photo-1520250497591-112f2f40a3f4?w=1200&q=80	Foto 3	2	f	2026-02-07 10:00:47.811545+00
d00e3eab-b74d-4d58-80d0-b7eb2af83090	7610048b-a323-4590-a2f6-3615373700a7	https://images.unsplash.com/photo-1564501049412-61c2a3083791?w=1200&q=80	Foto 4	3	f	2026-02-07 10:00:47.811545+00
9d19ffc7-9b7e-4d9c-88f0-5537df70bc3d	732003c7-a7fd-47a6-8197-eb2113c996be	https://images.unsplash.com/photo-1519494026892-80bbd2d6fd0d?w=1200&q=80	Foto 1	0	t	2026-02-07 10:00:47.811545+00
57a0b400-a6e4-4e80-b828-4bbd44cb7998	732003c7-a7fd-47a6-8197-eb2113c996be	https://images.unsplash.com/photo-1587351021759-3e566b6af7cc?w=1200&q=80	Foto 2	1	f	2026-02-07 10:00:47.811545+00
a6a8fa8d-ce68-4643-892c-a83d53529c5a	732003c7-a7fd-47a6-8197-eb2113c996be	https://images.unsplash.com/photo-1538108149393-fbbd81895907?w=1200&q=80	Foto 3	2	f	2026-02-07 10:00:47.811545+00
6c58c322-35cb-485c-b013-c985394d20de	732003c7-a7fd-47a6-8197-eb2113c996be	https://images.unsplash.com/photo-1584515933487-779824d29309?w=1200&q=80	Foto 4	3	f	2026-02-07 10:00:47.811545+00
ceda36d2-b155-4702-83f7-e42d94f7e32d	bb12175e-7acf-42c6-82f5-8abbca66c627	https://images.unsplash.com/photo-1519494026892-80bbd2d6fd0d?w=1200&q=80	Foto 1	0	t	2026-02-07 10:00:47.811545+00
3dbeaa6e-b057-46ab-9ccb-91c2393a2029	bb12175e-7acf-42c6-82f5-8abbca66c627	https://images.unsplash.com/photo-1587351021759-3e566b6af7cc?w=1200&q=80	Foto 2	1	f	2026-02-07 10:00:47.811545+00
d95bb9d9-907f-4ee4-b30d-3bc88605d916	bb12175e-7acf-42c6-82f5-8abbca66c627	https://images.unsplash.com/photo-1538108149393-fbbd81895907?w=1200&q=80	Foto 3	2	f	2026-02-07 10:00:47.811545+00
6fcb8511-c4ca-46bf-8198-ab1efd9781c0	bb12175e-7acf-42c6-82f5-8abbca66c627	https://images.unsplash.com/photo-1584515933487-779824d29309?w=1200&q=80	Foto 4	3	f	2026-02-07 10:00:47.811545+00
80209bdb-0416-46ef-96bf-89f76ffd3356	08720ce6-2175-4275-8d8b-a40e30440e85	https://images.unsplash.com/photo-1519494026892-80bbd2d6fd0d?w=1200&q=80	Foto 1	0	t	2026-02-07 10:00:47.811545+00
f4d094f5-a320-4cd7-bd35-6ce7f46565ed	08720ce6-2175-4275-8d8b-a40e30440e85	https://images.unsplash.com/photo-1587351021759-3e566b6af7cc?w=1200&q=80	Foto 2	1	f	2026-02-07 10:00:47.811545+00
14000c32-6f71-48c4-9524-251946c87028	08720ce6-2175-4275-8d8b-a40e30440e85	https://images.unsplash.com/photo-1538108149393-fbbd81895907?w=1200&q=80	Foto 3	2	f	2026-02-07 10:00:47.811545+00
b0768ffa-4321-4df3-9e38-68f6f104e785	08720ce6-2175-4275-8d8b-a40e30440e85	https://images.unsplash.com/photo-1584515933487-779824d29309?w=1200&q=80	Foto 4	3	f	2026-02-07 10:00:47.811545+00
76a1d275-319c-4818-a667-a072a9bc2290	b513f95c-b5e1-4d4f-a0a4-c1615c89e0d1	https://images.unsplash.com/photo-1519494026892-80bbd2d6fd0d?w=1200&q=80	Foto 1	0	t	2026-02-07 10:00:47.811545+00
e5076409-e42e-4449-af1b-aed621b24253	b513f95c-b5e1-4d4f-a0a4-c1615c89e0d1	https://images.unsplash.com/photo-1587351021759-3e566b6af7cc?w=1200&q=80	Foto 2	1	f	2026-02-07 10:00:47.811545+00
cee31669-b5f7-4a79-b283-a89b08d8549f	b513f95c-b5e1-4d4f-a0a4-c1615c89e0d1	https://images.unsplash.com/photo-1538108149393-fbbd81895907?w=1200&q=80	Foto 3	2	f	2026-02-07 10:00:47.811545+00
49ab5ccc-d819-468d-95da-e3579cf353df	b513f95c-b5e1-4d4f-a0a4-c1615c89e0d1	https://images.unsplash.com/photo-1584515933487-779824d29309?w=1200&q=80	Foto 4	3	f	2026-02-07 10:00:47.811545+00
c9fdf57a-8910-407e-9c3e-1626ae5fcfda	cb6be0c7-3b5c-464e-97e2-56feb3a3a145	https://images.unsplash.com/photo-1519494026892-80bbd2d6fd0d?w=1200&q=80	Foto 1	0	t	2026-02-07 10:00:47.811545+00
25c584ad-b5a7-4436-971d-558f11a276c7	cb6be0c7-3b5c-464e-97e2-56feb3a3a145	https://images.unsplash.com/photo-1587351021759-3e566b6af7cc?w=1200&q=80	Foto 2	1	f	2026-02-07 10:00:47.811545+00
01c106e1-0a85-4179-adef-5fb5e73b6751	cb6be0c7-3b5c-464e-97e2-56feb3a3a145	https://images.unsplash.com/photo-1538108149393-fbbd81895907?w=1200&q=80	Foto 3	2	f	2026-02-07 10:00:47.811545+00
6497dfb9-ec33-48ae-8ca0-d4f9dfd0a345	cb6be0c7-3b5c-464e-97e2-56feb3a3a145	https://images.unsplash.com/photo-1584515933487-779824d29309?w=1200&q=80	Foto 4	3	f	2026-02-07 10:00:47.811545+00
260b7655-fc16-413b-a83a-848078ece498	35d36cc5-b56d-4f15-a1f3-1a80de31ec58	https://images.unsplash.com/photo-1519494026892-80bbd2d6fd0d?w=1200&q=80	Foto 1	0	t	2026-02-07 10:00:47.811545+00
e6b7b8b5-c6bf-48c7-b017-d88adbcc1607	35d36cc5-b56d-4f15-a1f3-1a80de31ec58	https://images.unsplash.com/photo-1587351021759-3e566b6af7cc?w=1200&q=80	Foto 2	1	f	2026-02-07 10:00:47.811545+00
91695a17-90ad-4304-a17f-4de61f0ef1ab	35d36cc5-b56d-4f15-a1f3-1a80de31ec58	https://images.unsplash.com/photo-1538108149393-fbbd81895907?w=1200&q=80	Foto 3	2	f	2026-02-07 10:00:47.811545+00
e0b0912e-4aa4-4cc6-b05d-df62f5e7ecb2	35d36cc5-b56d-4f15-a1f3-1a80de31ec58	https://images.unsplash.com/photo-1584515933487-779824d29309?w=1200&q=80	Foto 4	3	f	2026-02-07 10:00:47.811545+00
2f3c57bc-120f-4d3a-8e0c-bd1b0217fa22	d23cdc0b-2672-4b6a-9ff1-ec7902493a82	https://images.unsplash.com/photo-1519494026892-80bbd2d6fd0d?w=1200&q=80	Foto 1	0	t	2026-02-07 10:00:47.811545+00
044e19ab-20e6-4380-953c-6e072dff554e	d23cdc0b-2672-4b6a-9ff1-ec7902493a82	https://images.unsplash.com/photo-1587351021759-3e566b6af7cc?w=1200&q=80	Foto 2	1	f	2026-02-07 10:00:47.811545+00
45cb759a-96d2-4596-9a37-ca99f30bd442	d23cdc0b-2672-4b6a-9ff1-ec7902493a82	https://images.unsplash.com/photo-1538108149393-fbbd81895907?w=1200&q=80	Foto 3	2	f	2026-02-07 10:00:47.811545+00
1802c235-e115-4dc2-b238-156eb0a7e662	d23cdc0b-2672-4b6a-9ff1-ec7902493a82	https://images.unsplash.com/photo-1584515933487-779824d29309?w=1200&q=80	Foto 4	3	f	2026-02-07 10:00:47.811545+00
d5ca2f22-98de-42a8-be2d-020eb4efc09d	ab777a4f-86c7-46aa-80f1-5dfe5fd0385a	https://images.unsplash.com/photo-1519494026892-80bbd2d6fd0d?w=1200&q=80	Foto 1	0	t	2026-02-07 10:00:47.811545+00
458a32b4-2b04-4bd2-91c6-4708bdcb759c	ab777a4f-86c7-46aa-80f1-5dfe5fd0385a	https://images.unsplash.com/photo-1587351021759-3e566b6af7cc?w=1200&q=80	Foto 2	1	f	2026-02-07 10:00:47.811545+00
854c1988-79d4-4468-bc32-76c252286e16	ab777a4f-86c7-46aa-80f1-5dfe5fd0385a	https://images.unsplash.com/photo-1538108149393-fbbd81895907?w=1200&q=80	Foto 3	2	f	2026-02-07 10:00:47.811545+00
ead5686d-fb59-4fac-b589-47bc31cce17b	ab777a4f-86c7-46aa-80f1-5dfe5fd0385a	https://images.unsplash.com/photo-1584515933487-779824d29309?w=1200&q=80	Foto 4	3	f	2026-02-07 10:00:47.811545+00
66410f60-68d2-4eeb-a7e1-835f25565a96	1b48504a-321f-4f78-8f0b-6af208905236	https://images.unsplash.com/photo-1519494026892-80bbd2d6fd0d?w=1200&q=80	Foto 1	0	t	2026-02-07 10:00:47.811545+00
4b715d5c-69cc-441a-a8fe-216bcc614cde	1b48504a-321f-4f78-8f0b-6af208905236	https://images.unsplash.com/photo-1587351021759-3e566b6af7cc?w=1200&q=80	Foto 2	1	f	2026-02-07 10:00:47.811545+00
d235e4ee-6820-47b0-9c33-7c619189ec83	1b48504a-321f-4f78-8f0b-6af208905236	https://images.unsplash.com/photo-1538108149393-fbbd81895907?w=1200&q=80	Foto 3	2	f	2026-02-07 10:00:47.811545+00
7d836074-c5be-4d60-bcba-9954521253f7	1b48504a-321f-4f78-8f0b-6af208905236	https://images.unsplash.com/photo-1584515933487-779824d29309?w=1200&q=80	Foto 4	3	f	2026-02-07 10:00:47.811545+00
87d2cc15-5f71-4454-a589-863e428d0bf4	c7d78327-c771-4ec4-a23f-02f5d4e0aed3	https://images.unsplash.com/photo-1519494026892-80bbd2d6fd0d?w=1200&q=80	Foto 1	0	t	2026-02-07 10:00:47.811545+00
3de40f61-55f3-4854-9f05-139061fd2f62	c7d78327-c771-4ec4-a23f-02f5d4e0aed3	https://images.unsplash.com/photo-1587351021759-3e566b6af7cc?w=1200&q=80	Foto 2	1	f	2026-02-07 10:00:47.811545+00
af6b0adc-5dfe-463d-9836-f0ee2458fa62	c7d78327-c771-4ec4-a23f-02f5d4e0aed3	https://images.unsplash.com/photo-1538108149393-fbbd81895907?w=1200&q=80	Foto 3	2	f	2026-02-07 10:00:47.811545+00
92c5783f-5830-4ba3-b775-7fe809f247bf	c7d78327-c771-4ec4-a23f-02f5d4e0aed3	https://images.unsplash.com/photo-1584515933487-779824d29309?w=1200&q=80	Foto 4	3	f	2026-02-07 10:00:47.811545+00
07ac9e00-040b-4ad4-9b8d-51a6b1559561	12bc6a45-4495-4fd3-872d-63aca9d86a8b	https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200&q=80	Foto 1	0	t	2026-02-07 10:00:47.811545+00
b67e4e76-37d4-45b1-b2b4-e256ae46abee	12bc6a45-4495-4fd3-872d-63aca9d86a8b	https://images.unsplash.com/photo-1469474968028-56623f02e42e?w=1200&q=80	Foto 2	1	f	2026-02-07 10:00:47.811545+00
cd34780c-6f52-4287-9f55-13583ee130a1	12bc6a45-4495-4fd3-872d-63aca9d86a8b	https://images.unsplash.com/photo-1447752875215-b2761acb3c5d?w=1200&q=80	Foto 3	2	f	2026-02-07 10:00:47.811545+00
b0eda2d8-e610-40db-83a1-33bf6a711823	12bc6a45-4495-4fd3-872d-63aca9d86a8b	https://images.unsplash.com/photo-1470071459604-3b5ec3a7fe05?w=1200&q=80	Foto 4	3	f	2026-02-07 10:00:47.811545+00
4b0f3219-a4a3-4d9c-8210-8f16cd9c35a9	cf59f52c-4450-49aa-95c0-95f82efe7e6d	https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200&q=80	Foto 1	0	t	2026-02-07 10:00:47.811545+00
1bc5a1f1-19cb-42b1-baeb-d4ecb4dcbddb	cf59f52c-4450-49aa-95c0-95f82efe7e6d	https://images.unsplash.com/photo-1469474968028-56623f02e42e?w=1200&q=80	Foto 2	1	f	2026-02-07 10:00:47.811545+00
13668d6a-ef7d-43b4-aff5-267cb599017e	cf59f52c-4450-49aa-95c0-95f82efe7e6d	https://images.unsplash.com/photo-1447752875215-b2761acb3c5d?w=1200&q=80	Foto 3	2	f	2026-02-07 10:00:47.811545+00
f1d18863-de39-45bd-8024-63b6168ac5cb	cf59f52c-4450-49aa-95c0-95f82efe7e6d	https://images.unsplash.com/photo-1470071459604-3b5ec3a7fe05?w=1200&q=80	Foto 4	3	f	2026-02-07 10:00:47.811545+00
e7ae394a-77b5-455b-a647-e80d2bd3c141	660999b5-e91e-4ec8-9d4e-afd901c805c1	https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200&q=80	Foto 1	0	t	2026-02-07 10:00:47.811545+00
9f7121e6-c725-433e-ad93-b8a10b0ab0ae	660999b5-e91e-4ec8-9d4e-afd901c805c1	https://images.unsplash.com/photo-1469474968028-56623f02e42e?w=1200&q=80	Foto 2	1	f	2026-02-07 10:00:47.811545+00
aeac281f-b662-4383-804f-9e378f4dce04	660999b5-e91e-4ec8-9d4e-afd901c805c1	https://images.unsplash.com/photo-1447752875215-b2761acb3c5d?w=1200&q=80	Foto 3	2	f	2026-02-07 10:00:47.811545+00
4a8e5648-f940-44ed-82cf-8c297405486a	660999b5-e91e-4ec8-9d4e-afd901c805c1	https://images.unsplash.com/photo-1470071459604-3b5ec3a7fe05?w=1200&q=80	Foto 4	3	f	2026-02-07 10:00:47.811545+00
9a7cb8b4-9a89-4828-a8f2-3e1b81bde0a6	e9b8ce0d-59d4-4b68-b8d6-bcfaf725f780	https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200&q=80	Foto 1	0	t	2026-02-07 10:00:47.811545+00
ec1ede18-9328-4f6c-b572-1c3b19c438c8	e9b8ce0d-59d4-4b68-b8d6-bcfaf725f780	https://images.unsplash.com/photo-1469474968028-56623f02e42e?w=1200&q=80	Foto 2	1	f	2026-02-07 10:00:47.811545+00
334ec3b7-d96a-45b5-bd8d-9cefa64dc4ac	e9b8ce0d-59d4-4b68-b8d6-bcfaf725f780	https://images.unsplash.com/photo-1447752875215-b2761acb3c5d?w=1200&q=80	Foto 3	2	f	2026-02-07 10:00:47.811545+00
cb86f5ae-9a42-475d-8fa1-bf00ed8c62c5	e9b8ce0d-59d4-4b68-b8d6-bcfaf725f780	https://images.unsplash.com/photo-1470071459604-3b5ec3a7fe05?w=1200&q=80	Foto 4	3	f	2026-02-07 10:00:47.811545+00
52e18658-e6ca-410a-9caa-9e364b49057d	665616b4-dd7d-48ba-8808-4628eccc09b7	https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200&q=80	Foto 1	0	t	2026-02-07 10:00:47.811545+00
9d4d4695-09e4-4017-9005-6bee8f1e7820	665616b4-dd7d-48ba-8808-4628eccc09b7	https://images.unsplash.com/photo-1469474968028-56623f02e42e?w=1200&q=80	Foto 2	1	f	2026-02-07 10:00:47.811545+00
0e53b7e4-1078-4c15-ba59-a6e8e0d8a73d	665616b4-dd7d-48ba-8808-4628eccc09b7	https://images.unsplash.com/photo-1447752875215-b2761acb3c5d?w=1200&q=80	Foto 3	2	f	2026-02-07 10:00:47.811545+00
c1142ff6-3a20-4a6a-918f-6a8b0c4b7653	665616b4-dd7d-48ba-8808-4628eccc09b7	https://images.unsplash.com/photo-1470071459604-3b5ec3a7fe05?w=1200&q=80	Foto 4	3	f	2026-02-07 10:00:47.811545+00
3d1f9c2c-a96b-4618-b0d4-80c9fdf86f6b	dc4f3668-74cc-4e8d-ac96-8909452bdb8b	https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200&q=80	Foto 1	0	t	2026-02-07 10:00:47.811545+00
690eb4e2-5005-4794-a12a-18779721ec3c	dc4f3668-74cc-4e8d-ac96-8909452bdb8b	https://images.unsplash.com/photo-1469474968028-56623f02e42e?w=1200&q=80	Foto 2	1	f	2026-02-07 10:00:47.811545+00
abd9aa7c-d74c-4ee4-8129-df111ec5aff5	dc4f3668-74cc-4e8d-ac96-8909452bdb8b	https://images.unsplash.com/photo-1447752875215-b2761acb3c5d?w=1200&q=80	Foto 3	2	f	2026-02-07 10:00:47.811545+00
70df7fa4-0ec0-4266-a22f-364ef990ddc6	dc4f3668-74cc-4e8d-ac96-8909452bdb8b	https://images.unsplash.com/photo-1470071459604-3b5ec3a7fe05?w=1200&q=80	Foto 4	3	f	2026-02-07 10:00:47.811545+00
75889563-245f-455e-9e2e-a278828c7353	4debf5ba-0daa-4f1f-a03e-6dc269114b37	https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200&q=80	Foto 1	0	t	2026-02-07 10:00:47.811545+00
e78aaea0-7a0c-446f-802a-6d764cc147d7	4debf5ba-0daa-4f1f-a03e-6dc269114b37	https://images.unsplash.com/photo-1469474968028-56623f02e42e?w=1200&q=80	Foto 2	1	f	2026-02-07 10:00:47.811545+00
9b211da9-c832-4b1f-9667-babc4f5af7e7	4debf5ba-0daa-4f1f-a03e-6dc269114b37	https://images.unsplash.com/photo-1447752875215-b2761acb3c5d?w=1200&q=80	Foto 3	2	f	2026-02-07 10:00:47.811545+00
ec338a62-4891-4f01-b196-34b5ea8c09a0	4debf5ba-0daa-4f1f-a03e-6dc269114b37	https://images.unsplash.com/photo-1470071459604-3b5ec3a7fe05?w=1200&q=80	Foto 4	3	f	2026-02-07 10:00:47.811545+00
3e98b999-f9cb-4623-875a-6645a98dd2a6	4909fa64-b386-41f1-8a21-23c39387fa63	https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200&q=80	Foto 1	0	t	2026-02-07 10:00:47.811545+00
541c5afc-3d8a-4191-b97f-7b73a3f28018	4909fa64-b386-41f1-8a21-23c39387fa63	https://images.unsplash.com/photo-1469474968028-56623f02e42e?w=1200&q=80	Foto 2	1	f	2026-02-07 10:00:47.811545+00
4f1edb24-0abf-413d-8ed4-d35ce7c765c4	4909fa64-b386-41f1-8a21-23c39387fa63	https://images.unsplash.com/photo-1447752875215-b2761acb3c5d?w=1200&q=80	Foto 3	2	f	2026-02-07 10:00:47.811545+00
a10fe201-3d37-42c8-b02b-e6077395511d	4909fa64-b386-41f1-8a21-23c39387fa63	https://images.unsplash.com/photo-1470071459604-3b5ec3a7fe05?w=1200&q=80	Foto 4	3	f	2026-02-07 10:00:47.811545+00
03dca925-f6e3-4071-956f-0e4ab449e59d	04a8d294-b8b3-4b08-89cb-6a217a0e5d4f	https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200&q=80	Foto 1	0	t	2026-02-07 10:00:47.811545+00
62763029-e36e-4d51-a972-31b6a6c482a7	04a8d294-b8b3-4b08-89cb-6a217a0e5d4f	https://images.unsplash.com/photo-1469474968028-56623f02e42e?w=1200&q=80	Foto 2	1	f	2026-02-07 10:00:47.811545+00
cba575a3-ea4e-4084-a66c-d336f35fa921	04a8d294-b8b3-4b08-89cb-6a217a0e5d4f	https://images.unsplash.com/photo-1447752875215-b2761acb3c5d?w=1200&q=80	Foto 3	2	f	2026-02-07 10:00:47.811545+00
7f8489d8-d033-4ab6-9d97-64ac496c8f84	04a8d294-b8b3-4b08-89cb-6a217a0e5d4f	https://images.unsplash.com/photo-1470071459604-3b5ec3a7fe05?w=1200&q=80	Foto 4	3	f	2026-02-07 10:00:47.811545+00
2ee41f87-6ed8-403d-9383-d69d284db2b7	e03ec206-9400-4a03-b77f-979053e06719	https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200&q=80	Foto 1	0	t	2026-02-07 10:00:47.811545+00
9ec38d2e-1885-4e37-9745-6b795f29c32e	e03ec206-9400-4a03-b77f-979053e06719	https://images.unsplash.com/photo-1469474968028-56623f02e42e?w=1200&q=80	Foto 2	1	f	2026-02-07 10:00:47.811545+00
8be2d82f-affa-4def-a8f2-5792d570716d	e03ec206-9400-4a03-b77f-979053e06719	https://images.unsplash.com/photo-1447752875215-b2761acb3c5d?w=1200&q=80	Foto 3	2	f	2026-02-07 10:00:47.811545+00
974c9a07-1787-4823-a07b-a7acb270c7df	e03ec206-9400-4a03-b77f-979053e06719	https://images.unsplash.com/photo-1470071459604-3b5ec3a7fe05?w=1200&q=80	Foto 4	3	f	2026-02-07 10:00:47.811545+00
34d83f58-e8fa-47e9-b4c7-4e480d3a72e7	c17682db-e628-4e80-bc5e-6db614014420	https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200&q=80	Foto 1	0	t	2026-02-07 10:00:47.811545+00
5835b247-de3f-4fdb-a7a4-f30259c5d419	c17682db-e628-4e80-bc5e-6db614014420	https://images.unsplash.com/photo-1469474968028-56623f02e42e?w=1200&q=80	Foto 2	1	f	2026-02-07 10:00:47.811545+00
9e484ced-222e-4c32-8f9c-faf18fb0ac52	c17682db-e628-4e80-bc5e-6db614014420	https://images.unsplash.com/photo-1447752875215-b2761acb3c5d?w=1200&q=80	Foto 3	2	f	2026-02-07 10:00:47.811545+00
2b6dbc72-5de3-4bc4-a2af-74d852741a8d	c17682db-e628-4e80-bc5e-6db614014420	https://images.unsplash.com/photo-1470071459604-3b5ec3a7fe05?w=1200&q=80	Foto 4	3	f	2026-02-07 10:00:47.811545+00
3c8f5dc8-5395-41b0-b568-bbdadd42065c	cd846d92-9235-4c51-9b7d-71151a84fd73	https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200&q=80	Foto 1	0	t	2026-02-07 10:00:47.811545+00
19b734e9-fe4c-43b4-97ff-dbf2a375c90f	cd846d92-9235-4c51-9b7d-71151a84fd73	https://images.unsplash.com/photo-1469474968028-56623f02e42e?w=1200&q=80	Foto 2	1	f	2026-02-07 10:00:47.811545+00
6d1e21db-f172-4e16-9827-962ae1b77e35	cd846d92-9235-4c51-9b7d-71151a84fd73	https://images.unsplash.com/photo-1447752875215-b2761acb3c5d?w=1200&q=80	Foto 3	2	f	2026-02-07 10:00:47.811545+00
fa7ea622-fe00-4586-915a-ee43771ee350	cd846d92-9235-4c51-9b7d-71151a84fd73	https://images.unsplash.com/photo-1470071459604-3b5ec3a7fe05?w=1200&q=80	Foto 4	3	f	2026-02-07 10:00:47.811545+00
464ec6ef-72d5-497e-b367-21c4de8543a3	c33f7e1d-90ec-4aa8-90cf-f379c97deb4b	https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200&q=80	Foto 1	0	t	2026-02-07 10:00:47.811545+00
04d8c209-7f57-4882-96ca-f1e623321599	c33f7e1d-90ec-4aa8-90cf-f379c97deb4b	https://images.unsplash.com/photo-1469474968028-56623f02e42e?w=1200&q=80	Foto 2	1	f	2026-02-07 10:00:47.811545+00
5cf7e7d7-3f9a-4ae8-ac64-4b2a8bd622f9	c33f7e1d-90ec-4aa8-90cf-f379c97deb4b	https://images.unsplash.com/photo-1447752875215-b2761acb3c5d?w=1200&q=80	Foto 3	2	f	2026-02-07 10:00:47.811545+00
fd1de26d-87b8-4cfd-8d07-aa8cd0e44ab5	c33f7e1d-90ec-4aa8-90cf-f379c97deb4b	https://images.unsplash.com/photo-1470071459604-3b5ec3a7fe05?w=1200&q=80	Foto 4	3	f	2026-02-07 10:00:47.811545+00
ff484fc0-f353-4e9e-a048-f6b935194883	5f9d0435-d8a0-49ab-9e3f-5783db51b83c	https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200&q=80	Foto 1	0	t	2026-02-07 10:00:47.811545+00
ed31808b-c44e-445b-b094-db87338480ca	5f9d0435-d8a0-49ab-9e3f-5783db51b83c	https://images.unsplash.com/photo-1469474968028-56623f02e42e?w=1200&q=80	Foto 2	1	f	2026-02-07 10:00:47.811545+00
3d6d0389-aa2a-4da1-a14b-66fabe79261d	5f9d0435-d8a0-49ab-9e3f-5783db51b83c	https://images.unsplash.com/photo-1447752875215-b2761acb3c5d?w=1200&q=80	Foto 3	2	f	2026-02-07 10:00:47.811545+00
b76cdc9b-ba30-4012-a311-49d775f7c0f6	5f9d0435-d8a0-49ab-9e3f-5783db51b83c	https://images.unsplash.com/photo-1470071459604-3b5ec3a7fe05?w=1200&q=80	Foto 4	3	f	2026-02-07 10:00:47.811545+00
99522b5a-e3ff-415a-b1c8-dea779d1ecce	a5ae5030-86b9-4b74-abd0-648321cfb774	https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200&q=80	Foto 1	0	t	2026-02-07 10:00:47.811545+00
fbf9c09e-c887-4e63-8b45-b34fd461a3d0	a5ae5030-86b9-4b74-abd0-648321cfb774	https://images.unsplash.com/photo-1469474968028-56623f02e42e?w=1200&q=80	Foto 2	1	f	2026-02-07 10:00:47.811545+00
c4ec3638-1a85-4a2a-8da0-5d5458062e22	a5ae5030-86b9-4b74-abd0-648321cfb774	https://images.unsplash.com/photo-1447752875215-b2761acb3c5d?w=1200&q=80	Foto 3	2	f	2026-02-07 10:00:47.811545+00
4fce8a66-84a3-41e9-b1ca-a1ee6b89ed10	a5ae5030-86b9-4b74-abd0-648321cfb774	https://images.unsplash.com/photo-1470071459604-3b5ec3a7fe05?w=1200&q=80	Foto 4	3	f	2026-02-07 10:00:47.811545+00
e5133b12-9736-4ac1-a551-c7ef12799151	1380e815-be94-4a2b-bb08-2c54f2955940	https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200&q=80	Foto 1	0	t	2026-02-07 10:00:47.811545+00
64d43d29-eea0-487e-b0fe-a50bfb61725d	1380e815-be94-4a2b-bb08-2c54f2955940	https://images.unsplash.com/photo-1469474968028-56623f02e42e?w=1200&q=80	Foto 2	1	f	2026-02-07 10:00:47.811545+00
6a9ed4a5-dd4b-44dd-8f02-c46aac35ee01	1380e815-be94-4a2b-bb08-2c54f2955940	https://images.unsplash.com/photo-1447752875215-b2761acb3c5d?w=1200&q=80	Foto 3	2	f	2026-02-07 10:00:47.811545+00
8c7fbff3-f3c6-4be7-bbcb-d4953a3d692d	1380e815-be94-4a2b-bb08-2c54f2955940	https://images.unsplash.com/photo-1470071459604-3b5ec3a7fe05?w=1200&q=80	Foto 4	3	f	2026-02-07 10:00:47.811545+00
c853b33b-e117-4181-9207-0f4be13eccf3	bf6f61ce-9b9a-40e0-a4d3-5fba7430d694	https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200&q=80	Foto 1	0	t	2026-02-07 10:00:47.811545+00
6d1fc276-0a8b-4823-9b23-d3bf6534db09	bf6f61ce-9b9a-40e0-a4d3-5fba7430d694	https://images.unsplash.com/photo-1469474968028-56623f02e42e?w=1200&q=80	Foto 2	1	f	2026-02-07 10:00:47.811545+00
eaa2b2a5-ecea-4381-bd83-d8e90433681d	bf6f61ce-9b9a-40e0-a4d3-5fba7430d694	https://images.unsplash.com/photo-1447752875215-b2761acb3c5d?w=1200&q=80	Foto 3	2	f	2026-02-07 10:00:47.811545+00
2d838ff6-eb2d-4151-8de9-e1d6b11fcea8	bf6f61ce-9b9a-40e0-a4d3-5fba7430d694	https://images.unsplash.com/photo-1470071459604-3b5ec3a7fe05?w=1200&q=80	Foto 4	3	f	2026-02-07 10:00:47.811545+00
7b761590-d921-4e7b-94b5-072ada41be7b	4f0853ab-7730-4148-8d2b-be40a01c007d	https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200&q=80	Foto 1	0	t	2026-02-07 10:00:47.811545+00
e16afda7-3379-4bff-bf74-e505b0ffc1fd	4f0853ab-7730-4148-8d2b-be40a01c007d	https://images.unsplash.com/photo-1469474968028-56623f02e42e?w=1200&q=80	Foto 2	1	f	2026-02-07 10:00:47.811545+00
2fa37e28-d51b-4c13-8903-fa27b4351698	4f0853ab-7730-4148-8d2b-be40a01c007d	https://images.unsplash.com/photo-1447752875215-b2761acb3c5d?w=1200&q=80	Foto 3	2	f	2026-02-07 10:00:47.811545+00
f9154b18-5088-4249-9a26-0e1069f2d370	4f0853ab-7730-4148-8d2b-be40a01c007d	https://images.unsplash.com/photo-1470071459604-3b5ec3a7fe05?w=1200&q=80	Foto 4	3	f	2026-02-07 10:00:47.811545+00
\.


--
-- TOC entry 5152 (class 0 OID 106339)
-- Dependencies: 340
-- Data for Name: place_media; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.place_media (id, place_id, kind, url, alt_i18n, sort_order, created_at, updated_at) FROM stdin;
\.


--
-- TOC entry 5151 (class 0 OID 106315)
-- Dependencies: 339
-- Data for Name: places; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.places (id, site_id, kind, status, slug, name_i18n, short_i18n, description_i18n, category_id, phone, whatsapp, email, website, address_line, city, state, postal_code, lat, lng, created_at, updated_at, country, video_url, secondary_category_id, sort_order, meta, category_type, subcategory_id, attributes, is_featured, meta_title, meta_description, curation_status, curated_by, curated_at, data_source, data_verified_at, import_batch_id, tags) FROM stdin;
c35a0703-64e1-42f2-b569-57e272354163	9c5297ee-89af-4f6f-911a-541813232150	attraction	published	morro-da-igreja	{"pt": "Morro da Igreja"}	{"pt": "Ponto mais alto habitado do Sul do Brasil."}	{"pt": "Vista da Pedra Furada e amanhecer unico."}	7868cfe3-4294-4d96-a602-8c0eba64cf7b	\N	\N	\N	\N	Parque Nacional	Urubici	SC	\N	-28.130000	-49.482000	2026-01-27 13:56:47.655831+00	2026-02-07 11:17:59.252581+00	BR	\N	\N	10	{"tags": ["Altitude", "Aventura"], "image_url": "https://images.unsplash.com/photo-1470770903676-69b98201ea1c?auto=format&fit=crop&w=1600&q=80"}	onde_ir	7868cfe3-4294-4d96-a602-8c0eba64cf7b	{}	f	\N	\N	pending	\N	\N	\N	\N	\N	{"[\\"Altitude\\", \\"Aventura\\"]"}
4debf5ba-0daa-4f1f-a03e-6dc269114b37	9c5297ee-89af-4f6f-911a-541813232150	attraction	published	parque-nacional-de-sao-joaquim-urubici-sc	{"pt": "Parque Nacional de São Joaquim"}	\N	\N	\N	\N	\N	\N	\N	Rodovia SC-430, Km 35	Urubici	SC	88650-000	-27.974500	-49.621200	2026-02-07 08:36:23.470513+00	2026-02-07 11:17:59.252581+00	Brasil	\N	\N	0	{"tags": ["parque-nacional", "icmbio", "trilhas"], "enriched": true}	o_que_fazer	\N	{"type": "parque-nacional", "icmbio": true, "entry_fee": "Gratuito"}	f	\N	\N	approved	\N	2026-02-07 10:21:49.392824+00	Wikipedia	\N	e9dc6bb0-b9d3-4d95-a02c-8f54b06dea3b	{"[\\"parque-nacional\\", \\"icmbio\\", \\"trilhas\\"]"}
04a8d294-b8b3-4b08-89cb-6a217a0e5d4f	9c5297ee-89af-4f6f-911a-541813232150	attraction	published	canion-espraiado-urubici-sc	{"pt": "Cânion Espraiado"}	\N	\N	\N	\N	\N	\N	\N	Estrada do Cânion, Km 12	Urubici	SC	88650-000	-28.024500	-49.551200	2026-02-07 08:36:23.470513+00	2026-02-07 11:17:59.252581+00	Brasil	\N	\N	0	{"tags": ["cânion", "espraiado", "geológico"], "enriched": true}	o_que_fazer	\N	{"type": "geológico"}	f	\N	\N	approved	\N	2026-02-07 10:21:49.392824+00	Wikipedia	\N	e9dc6bb0-b9d3-4d95-a02c-8f54b06dea3b	{"[\\"cânion\\", \\"espraiado\\", \\"geológico\\"]"}
9cb79178-1776-42d5-babf-b2cb3b13c851	9c5297ee-89af-4f6f-911a-541813232150	attraction	published	cachoeira-do-avencal	{"en": "Avencal Waterfall", "es": "Cascada do Avencal", "pt": "Cachoeira do Avencal"}	{"en": "A classic photo spot.", "es": "Un clásico para fotos.", "pt": "Cenário clássico para fotos."}	{"en": "One of the best-known waterfalls in the region. Great for families.", "es": "Una de las cascadas más conocidas. Ideal para familias.", "pt": "Uma das cachoeiras mais conhecidas da região. Ideal para visita em família."}	7868cfe3-4294-4d96-a602-8c0eba64cf7b	\N	\N	\N	\N	\N	Urubici	SC	\N	\N	\N	2026-01-27 13:56:47.655831+00	2026-02-07 11:17:59.252581+00	BR	\N	\N	20	{"flags": {"featured": true}}	onde_ir	7868cfe3-4294-4d96-a602-8c0eba64cf7b	{}	f	\N	\N	pending	\N	\N	\N	\N	\N	\N
dee4fab7-93f1-4a08-9a7b-95b12cffa6c2	9c5297ee-89af-4f6f-911a-541813232150	attraction	published	pedra-furada	{"en": "Pedra Furada", "es": "Pedra Furada", "pt": "Pedra Furada"}	{"en": "Iconic natural formation.", "es": "Formación natural emblemática.", "pt": "Formação natural emblemática."}	{"en": "A traditional attraction with a trail and nature experience.", "es": "Un atractivo tradicional, con sendero y experiencia de naturaleza.", "pt": "Atrativo tradicional, com trilha e experiência de natureza."}	7868cfe3-4294-4d96-a602-8c0eba64cf7b	\N	\N	\N	\N	\N	Urubici	SC	\N	\N	\N	2026-01-27 13:56:47.655831+00	2026-02-07 11:17:59.252581+00	BR	\N	\N	30	{"flags": {"featured": false}}	onde_ir	7868cfe3-4294-4d96-a602-8c0eba64cf7b	{}	f	\N	\N	pending	\N	\N	\N	\N	\N	\N
bf6f61ce-9b9a-40e0-a4d3-5fba7430d694	9c5297ee-89af-4f6f-911a-541813232150	attraction	published	morro-do-parapente-urubici-sc	{"pt": "Morro do Parapente"}	\N	\N	\N	\N	\N	\N	\N	Estrada do Morro do Parapente, Km 6	Urubici	SC	88650-000	-28.004500	-49.571200	2026-02-07 08:36:23.470513+00	2026-02-07 11:17:59.252581+00	Brasil	\N	\N	0	{"tags": ["parapente", "asa-delta", "voo"], "enriched": true}	o_que_fazer	\N	{"type": "voo-livre", "activities": ["parapente", "asa-delta"]}	f	\N	\N	approved	\N	2026-02-07 10:21:49.392824+00	Wikipedia	\N	e9dc6bb0-b9d3-4d95-a02c-8f54b06dea3b	{"[\\"parapente\\", \\"asa-delta\\", \\"voo\\"]"}
5a0394bc-3d26-4ead-a582-158635311ec1	9c5297ee-89af-4f6f-911a-541813232150	lodging	published	pousada-vale-neblina	{"pt": "Pousada Vale da Neblina"}	{"pt": "Suites com vista para o vale e lareira interna."}	{"pt": "Hospedagem premium com cafe da manha artesanal."}	\N	\N	\N	\N	\N	Estrada da Serra, km 9	Urubici	SC	\N	-28.015000	-49.592000	2026-02-06 19:22:34.881947+00	2026-02-07 11:17:59.252581+00	BR	\N	\N	0	{"tags": ["Premium", "Vista panoramica"], "image_url": "https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?auto=format&fit=crop&w=1600&q=80"}	\N	\N	{}	f	\N	\N	approved	\N	2026-02-07 10:38:42.527351+00	\N	\N	\N	{"[\\"Premium\\", \\"Vista panoramica\\"]"}
10a84ecd-ddb9-43ab-96e9-3182d563cda9	9c5297ee-89af-4f6f-911a-541813232150	lodging	published	cabanas-serra-azul	{"pt": "Cabanas Serra Azul"}	{"pt": "Cabanas de vidro com deck suspenso."}	{"pt": "Experiencia imersiva com hidromassagem e fogueira."}	\N	\N	\N	\N	\N	Estrada do Morro, km 3	Urubici	SC	\N	-28.009000	-49.579000	2026-02-06 19:22:34.881947+00	2026-02-07 11:17:59.252581+00	BR	\N	\N	0	{"tags": ["Luxo", "Romantico"], "image_url": "https://images.unsplash.com/photo-1445019980597-93fa8acb246c?auto=format&fit=crop&w=1600&q=80"}	\N	\N	{}	f	\N	\N	approved	\N	2026-02-07 10:38:42.527351+00	\N	\N	\N	{"[\\"Luxo\\", \\"Romantico\\"]"}
18a2707e-44f1-4c10-b78d-3610c96bdb07	9c5297ee-89af-4f6f-911a-541813232150	lodging	published	refugio-campos-altos	{"pt": "Refugio Campos Altos"}	{"pt": "Refugio de montanha com vista 360 graus."}	{"pt": "Ideal para trilheiros e amantes de natureza."}	\N	\N	\N	\N	\N	Estrada dos Campos, km 12	Urubici	SC	\N	-28.018000	-49.605000	2026-02-06 19:22:34.881947+00	2026-02-07 11:17:59.252581+00	BR	\N	\N	0	{"tags": ["Aventura", "Natureza"], "image_url": "https://images.unsplash.com/photo-1469474968028-56623f02e42e?auto=format&fit=crop&w=1600&q=80"}	\N	\N	{}	f	\N	\N	approved	\N	2026-02-07 10:38:42.527351+00	\N	\N	\N	{"[\\"Aventura\\", \\"Natureza\\"]"}
5f78fb4c-0ee3-47f9-b0f0-02607f4a0db3	9c5297ee-89af-4f6f-911a-541813232150	lodging	published	hotel-boutique-cascata	{"pt": "Hotel Boutique Cascata"}	{"pt": "Suites exclusivas com spa e piscina aquecida."}	{"pt": "Servicos personalizados e gastronomia autoral."}	\N	\N	\N	\N	\N	Rua das Flores, 210	Urubici	SC	\N	-28.013000	-49.585000	2026-02-06 19:22:34.881947+00	2026-02-07 11:17:59.252581+00	BR	\N	\N	0	{"tags": ["Boutique", "Spa"], "image_url": "https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?auto=format&fit=crop&w=1600&q=80"}	\N	\N	{}	f	\N	\N	approved	\N	2026-02-07 10:38:42.527351+00	\N	\N	\N	{"[\\"Boutique\\", \\"Spa\\"]"}
2d120d4d-3bb5-477b-b30e-a0bdf73b8ca5	9c5297ee-89af-4f6f-911a-541813232150	attraction	published	serra-corvo-branco	{"pt": "Serra do Corvo Branco"}	{"pt": "Corte de rocha com vista monumental."}	{"pt": "Um dos atrativos mais fotografados da serra."}	\N	\N	\N	\N	\N	SC-370, km 1	Urubici	SC	\N	-28.028000	-49.601000	2026-02-06 19:22:34.881947+00	2026-02-07 11:17:59.252581+00	BR	\N	\N	0	{"tags": ["Natureza", "Mirante"], "image_url": "https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?auto=format&fit=crop&w=1600&q=80"}	\N	\N	{}	f	\N	\N	pending	\N	\N	\N	\N	\N	{"[\\"Natureza\\", \\"Mirante\\"]"}
a0c77f42-c490-4c82-901f-8142679d5ad0	9c5297ee-89af-4f6f-911a-541813232150	attraction	published	cascata-avencal	{"pt": "Cascata do Avencal"}	{"pt": "Queda d agua com mirantes e trilhas."}	{"pt": "Parque com tirolesa e plataformas de vidro."}	\N	\N	\N	\N	\N	Estrada do Avencal, km 8	Urubici	SC	\N	-28.005000	-49.583000	2026-02-06 19:22:34.881947+00	2026-02-07 11:17:59.252581+00	BR	\N	\N	0	{"tags": ["Ecoturismo", "Trilhas"], "image_url": "https://images.unsplash.com/photo-1469474968028-56623f02e42e?auto=format&fit=crop&w=1600&q=80"}	\N	\N	{}	f	\N	\N	pending	\N	\N	\N	\N	\N	{"[\\"Ecoturismo\\", \\"Trilhas\\"]"}
0fd0f44b-1fe7-453d-970d-b46ee1d863e7	9c5297ee-89af-4f6f-911a-541813232150	attraction	published	mirante-morro-pedras	{"pt": "Mirante do Morro das Pedras"}	{"pt": "Vista panoramica da serra e vales."}	{"pt": "Ponto ideal para fotografias ao amanhecer."}	\N	\N	\N	\N	\N	Estrada do Mirante, km 2	Urubici	SC	\N	-28.016000	-49.570000	2026-02-06 19:22:34.881947+00	2026-02-07 11:17:59.252581+00	BR	\N	\N	0	{"tags": ["Fotografia", "Mirante"], "image_url": "https://images.unsplash.com/photo-1444703686981-a3abbc4d4fe3?auto=format&fit=crop&w=1600&q=80"}	\N	\N	{}	f	\N	\N	pending	\N	\N	\N	\N	\N	{"[\\"Fotografia\\", \\"Mirante\\"]"}
3820f2e4-bd29-4944-8b83-58708bf9a2fb	9c5297ee-89af-4f6f-911a-541813232150	attraction	published	trilha-canion-espraiado	{"pt": "Trilha do Canyon Espraiado"}	{"pt": "Percurso leve com vista para canions."}	{"pt": "Rota recomendada para familias."}	\N	\N	\N	\N	\N	Estrada Espraiado, km 5	Urubici	SC	\N	-28.022000	-49.610000	2026-02-06 19:22:34.881947+00	2026-02-07 11:17:59.252581+00	BR	\N	\N	0	{"tags": ["Trilhas", "Familia"], "image_url": "https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?auto=format&fit=crop&w=1600&q=80"}	\N	\N	{}	f	\N	\N	pending	\N	\N	\N	\N	\N	{"[\\"Trilhas\\", \\"Familia\\"]"}
74fcd6bd-327c-4ae7-89ae-4468d06c1bf2	9c5297ee-89af-4f6f-911a-541813232150	food	published	bistro-da-serra	{"pt": "Bistro da Serra"}	{"pt": "Menu autoral com ingredientes locais."}	{"pt": "Experiencia gastronomica com carta de vinhos."}	\N	\N	\N	\N	\N	Avenida Central, 155	Urubici	SC	\N	-28.011000	-49.584000	2026-02-06 19:22:34.881947+00	2026-02-07 11:17:59.252581+00	BR	\N	\N	0	{"tags": ["Autorais", "Vinhos"], "image_url": "https://images.unsplash.com/photo-1504674900247-0877df9cc836?auto=format&fit=crop&w=1600&q=80"}	\N	\N	{}	f	\N	\N	approved	\N	2026-02-07 10:38:42.527351+00	\N	\N	\N	{"[\\"Autorais\\", \\"Vinhos\\"]"}
dab6ebb1-5bfe-4e5d-b5a0-10de06921ffa	9c5297ee-89af-4f6f-911a-541813232150	food	published	cafe-montanha	{"pt": "Cafe da Montanha"}	{"pt": "Cafe especial e confeitaria artesanal."}	{"pt": "Ambiente aconchegante com vista para os vales."}	\N	\N	\N	\N	\N	Rua das Hortensias, 80	Urubici	SC	\N	-28.014000	-49.579000	2026-02-06 19:22:34.881947+00	2026-02-07 11:17:59.252581+00	BR	\N	\N	0	{"tags": ["Cafe", "Doces"], "image_url": "https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?auto=format&fit=crop&w=1600&q=80"}	\N	\N	{}	f	\N	\N	approved	\N	2026-02-07 10:38:42.527351+00	\N	\N	\N	{"[\\"Cafe\\", \\"Doces\\"]"}
0d242705-1b84-4bce-b9cc-2c9cce32f3e5	9c5297ee-89af-4f6f-911a-541813232150	food	published	adega-campos	{"pt": "Adega dos Campos"}	{"pt": "Degustacao de vinhos e charcutaria."}	{"pt": "Selecao de vinhos de altitude e queijos locais."}	\N	\N	\N	\N	\N	Estrada do Vinho, km 2	Urubici	SC	\N	-28.017000	-49.593000	2026-02-06 19:22:34.881947+00	2026-02-07 11:17:59.252581+00	BR	\N	\N	0	{"tags": ["Vinhos", "Charcutaria"], "image_url": "https://images.unsplash.com/photo-1470337458703-46ad1756a187?auto=format&fit=crop&w=1600&q=80"}	\N	\N	{}	f	\N	\N	approved	\N	2026-02-07 10:38:42.527351+00	\N	\N	\N	{"[\\"Vinhos\\", \\"Charcutaria\\"]"}
2e7c0638-8329-416c-9002-f6dd41918bc8	9c5297ee-89af-4f6f-911a-541813232150	food	published	truta-das-aguas	{"pt": "Truta das Aguas"}	{"pt": "Especialidade em trutas e grelhados."}	{"pt": "Restaurante com deck sobre o rio."}	\N	\N	\N	\N	\N	Estrada do Rio, km 6	Urubici	SC	\N	-28.020000	-49.590000	2026-02-06 19:22:34.881947+00	2026-02-07 11:17:59.252581+00	BR	\N	\N	0	{"tags": ["Trutas", "Grelhados"], "image_url": "https://images.unsplash.com/photo-1504674900247-0877df9cc836?auto=format&fit=crop&w=1600&q=80"}	\N	\N	{}	f	\N	\N	approved	\N	2026-02-07 10:38:42.527351+00	\N	\N	\N	{"[\\"Trutas\\", \\"Grelhados\\"]"}
11717f6e-81e8-402d-98d5-4a022ee9bb15	9c5297ee-89af-4f6f-911a-541813232150	food	published	cozinha-urbana	{"pt": "Cozinha Urbana"}	{"pt": "Menu contemporaneo com ingredientes da serra."}	{"pt": "Ambiente moderno com bar de drinks."}	\N	\N	\N	\N	\N	Rua do Comercio, 44	Urubici	SC	\N	-28.012000	-49.582000	2026-02-06 19:22:34.881947+00	2026-02-07 11:17:59.252581+00	BR	\N	\N	0	{"tags": ["Contemporaneo", "Drinks"], "image_url": "https://images.unsplash.com/photo-1528605248644-14dd04022da1?auto=format&fit=crop&w=1600&q=80"}	\N	\N	{}	f	\N	\N	approved	\N	2026-02-07 10:38:42.527351+00	\N	\N	\N	{"[\\"Contemporaneo\\", \\"Drinks\\"]"}
b6af7daa-6387-4e3a-9387-89c9eb74da55	9c5297ee-89af-4f6f-911a-541813232150	lodging	published	chales-mirante-vale	{"pt": "Chales Mirante do Vale"}	{"pt": "Chales de madeira com vista para a serra."}	{"pt": "Ambiente aconchegante para familias e casais."}	\N	\N	\N	\N	\N	Estrada do Mirante, km 4	Urubici	SC	\N	-28.005000	-49.571000	2026-02-06 19:22:34.881947+00	2026-02-07 11:17:59.252581+00	BR	\N	\N	0	{"tags": ["Familia", "Conforto"], "image_url": "https://images.unsplash.com/photo-1445019980597-93fa8acb246c?auto=format&fit=crop&w=1600&q=80"}	\N	\N	{}	f	\N	\N	approved	\N	2026-02-07 10:38:42.527351+00	\N	\N	\N	{"[\\"Familia\\", \\"Conforto\\"]"}
c17682db-e628-4e80-bc5e-6db614014420	9c5297ee-89af-4f6f-911a-541813232150	attraction	published	estancia-do-lava-tudo-urubici-sc	{"pt": "Estância do Lava Tudo"}	\N	\N	\N	\N	\N	\N	\N	Estrada da Estância, Km 7	Urubici	SC	88650-000	-28.004500	-49.591200	2026-02-07 08:36:23.470513+00	2026-02-07 11:17:59.252581+00	Brasil	\N	\N	0	{"tags": ["parque", "ecológico", "preservação"], "enriched": true}	o_que_fazer	\N	{"type": "parque-ecológico", "preservation": "ambiental"}	f	\N	\N	approved	\N	2026-02-07 10:21:49.392824+00	Wikipedia	\N	e9dc6bb0-b9d3-4d95-a02c-8f54b06dea3b	{"[\\"parque\\", \\"ecológico\\", \\"preservação\\"]"}
cd846d92-9235-4c51-9b7d-71151a84fd73	9c5297ee-89af-4f6f-911a-541813232150	attraction	published	jardim-secreto-ville-de-france-urubici-sc	{"pt": "Jardim Secreto Ville de France"}	\N	\N	\N	\N	\N	\N	\N	Estrada Ville de France, Km 2	Urubici	SC	88650-000	-27.994500	-49.601200	2026-02-07 08:36:23.470513+00	2026-02-07 11:17:59.252581+00	Brasil	\N	\N	0	{"tags": ["jardim", "temático", "frança"], "enriched": true}	o_que_fazer	\N	{"type": "jardim-temático", "theme": "frança"}	f	\N	\N	approved	\N	2026-02-07 10:21:49.392824+00	Wikipedia	\N	e9dc6bb0-b9d3-4d95-a02c-8f54b06dea3b	{"[\\"jardim\\", \\"temático\\", \\"frança\\"]"}
c33f7e1d-90ec-4aa8-90cf-f379c97deb4b	9c5297ee-89af-4f6f-911a-541813232150	attraction	published	parque-quedas-do-avencal-e-mirante-de-vidro-urubici-sc	{"pt": "Parque Quedas do Avencal e Mirante de Vidro"}	\N	\N	\N	\N	\N	\N	\N	Rodovia SC-439, Km 26	Urubici	SC	88650-000	-28.034500	-49.561200	2026-02-07 08:36:23.470513+00	2026-02-07 11:17:59.252581+00	Brasil	\N	\N	0	{"tags": ["parque", "mirante-vidro", "aventura"], "enriched": true}	o_que_fazer	\N	{"type": "parque", "features": ["cachoeira", "mirante-vidro"], "entry_fee": "R$ 40,00"}	f	\N	\N	approved	\N	2026-02-07 10:21:49.392824+00	Wikipedia	\N	e9dc6bb0-b9d3-4d95-a02c-8f54b06dea3b	{"[\\"parque\\", \\"mirante-vidro\\", \\"aventura\\"]"}
5f9d0435-d8a0-49ab-9e3f-5783db51b83c	9c5297ee-89af-4f6f-911a-541813232150	attraction	published	altos-do-corvo-branco-urubici-sc	{"pt": "Altos do Corvo Branco"}	\N	\N	\N	\N	\N	\N	\N	Estrada do Corvo Branco, Km 18	Urubici	SC	88650-000	-28.024500	-49.561200	2026-02-07 08:36:23.470513+00	2026-02-07 11:17:59.252581+00	Brasil	\N	\N	0	{"tags": ["camping", "altos", "corvo-branco"], "enriched": true}	o_que_fazer	\N	{"type": "camping", "view": "serra-corvo-branco"}	f	\N	\N	approved	\N	2026-02-07 10:21:49.392824+00	Wikipedia	\N	e9dc6bb0-b9d3-4d95-a02c-8f54b06dea3b	{"[\\"camping\\", \\"altos\\", \\"corvo-branco\\"]"}
5693c4d6-91a2-4575-9e9a-7bf85db8c1b3	9c5297ee-89af-4f6f-911a-541813232150	lodging	published	cabanas-do-lago-urubici-sc	{"pt": "Cabanas do Lago"}	\N	{"pt": "Cabanas privativas à beira do lago. Perfeito para casais."}	\N	(49) 3333-6666	\N	\N	\N	Estrada do Lago, 123	Urubici	SC	88650-000	-27.986789	-49.583456	2026-02-07 08:55:16.193766+00	2026-02-07 11:17:59.252581+00	Brasil	\N	\N	0	{"tags": ["cabanas", "romântico"], "enriched": true}	onde_ficar	\N	{"type": "cabana", "amenities": ["vista-lago", "hidromassagem"]}	f	\N	\N	approved	\N	2026-02-07 10:38:42.527351+00	Agente Autônomo	\N	bcefcee8-0993-482b-8825-77fd6b39fd5f	{"[\\"cabanas\\", \\"romântico\\"]"}
4e2e55f1-db37-45c9-bef2-cdc80a3481c0	9c5297ee-89af-4f6f-911a-541813232150	lodging	published	pousada-caminho-das-neves-urubici-sc	{"pt": "Pousada Caminho das Neves"}	\N	{"pt": "Pousada charmosa decorada com tema invernal. Lareira em todos os quartos."}	\N	(49) 3334-7777	\N	\N	\N	Rua XV de Novembro, 345	Urubici	SC	88650-000	-27.992345	-49.587890	2026-02-07 08:55:16.193766+00	2026-02-07 11:17:59.252581+00	Brasil	\N	\N	0	{"tags": ["pousada", "inverno"], "enriched": true}	onde_ficar	\N	{"type": "pousada", "amenities": ["lareira", "decoracao-inverno"]}	f	\N	\N	approved	\N	2026-02-07 10:38:42.527351+00	Agente Autônomo	\N	bcefcee8-0993-482b-8825-77fd6b39fd5f	{"[\\"pousada\\", \\"inverno\\"]"}
002bcaa0-fab7-4e58-8b76-388e4597bfdc	9c5297ee-89af-4f6f-911a-541813232150	food	published	cantinho-da-serra-urubici-sc	{"pt": "Cantinho da Serra"}	\N	{"pt": "Comida caçadora tradicional da Serra Catarinense. Atendimento familiar."}	\N	(49) 3334-7853	\N	\N	\N	Av. São Paulo, 563 - Vila Nova	Urubici	SC	88650-000	-27.985949	-49.587993	2026-02-07 08:55:16.193766+00	2026-02-07 11:17:59.252581+00	Brasil	\N	\N	0	{"tags": ["restaurante", "comida-caçadora"], "enriched": true}	onde_comer	\N	{"cuisine": "Caseira", "price_range": "economic"}	f	\N	\N	approved	\N	2026-02-07 10:38:42.527351+00	Agente Autônomo	\N	0ce344c8-bd92-4b6f-b1ac-29a405b882a3	{"[\\"restaurante\\", \\"comida-caçadora\\"]"}
4f0853ab-7730-4148-8d2b-be40a01c007d	9c5297ee-89af-4f6f-911a-541813232150	attraction	published	cachoeira-rio-dos-bugres-urubici-sc	{"pt": "Cachoeira Rio dos Bugres"}	\N	\N	\N	\N	\N	\N	\N	Estrada Rio dos Bugres, Km 8	Urubici	SC	88650-000	-28.014500	-49.631200	2026-02-07 08:36:23.470513+00	2026-02-07 11:17:59.252581+00	Brasil	\N	\N	0	{"tags": ["cachoeira", "rio-dos-bugres", "mata"], "enriched": true}	o_que_fazer	\N	{"type": "cachoeira", "ecosystem": "mata-atlântica"}	f	\N	\N	approved	\N	2026-02-07 10:21:49.392824+00	Wikipedia	\N	e9dc6bb0-b9d3-4d95-a02c-8f54b06dea3b	{"[\\"cachoeira\\", \\"rio-dos-bugres\\", \\"mata\\"]"}
a5ae5030-86b9-4b74-abd0-648321cfb774	9c5297ee-89af-4f6f-911a-541813232150	attraction	published	rio-sete-quedas-urubici-sc	{"pt": "Rio Sete Quedas"}	\N	\N	\N	\N	\N	\N	\N	Estrada Rio Sete Quedas, Km 10	Urubici	SC	88650-000	-28.004500	-49.611200	2026-02-07 08:36:23.470513+00	2026-02-07 11:17:59.252581+00	Brasil	\N	\N	0	{"tags": ["rio", "sete-quedas", "trilha"], "enriched": true}	o_que_fazer	\N	{"type": "rio", "features": "sete-cachoeiras"}	f	\N	\N	approved	\N	2026-02-07 10:21:49.392824+00	Wikipedia	\N	e9dc6bb0-b9d3-4d95-a02c-8f54b06dea3b	{"[\\"rio\\", \\"sete-quedas\\", \\"trilha\\"]"}
12bc6a45-4495-4fd3-872d-63aca9d86a8b	9c5297ee-89af-4f6f-911a-541813232150	attraction	published	morro-da-igreja-urubici-sc	{"pt": "Morro da Igreja"}	\N	\N	\N	\N	\N	\N	\N	Estrada Morro da Igreja, Km 15	Urubici	SC	88650-000	-28.014700	-49.591700	2026-02-07 08:36:23.470513+00	2026-02-07 11:17:59.252581+00	Brasil	\N	\N	0	{"tags": ["mirante", "1822m", "mais-alto"], "enriched": true}	o_que_fazer	\N	{"type": "mirante", "access": "estrada-de-terra", "altitude": 1822}	f	\N	\N	approved	\N	2026-02-07 10:21:49.392824+00	Wikipedia	\N	e9dc6bb0-b9d3-4d95-a02c-8f54b06dea3b	{"[\\"mirante\\", \\"1822m\\", \\"mais-alto\\"]"}
cf59f52c-4450-49aa-95c0-95f82efe7e6d	9c5297ee-89af-4f6f-911a-541813232150	attraction	published	cascata-veu-de-noiva-urubici-sc	{"pt": "Cascata Véu de Noiva"}	\N	\N	\N	\N	\N	\N	\N	Estrada da Cascata, Km 3	Urubici	SC	88650-000	-28.004500	-49.601200	2026-02-07 08:36:23.470513+00	2026-02-07 11:17:59.252581+00	Brasil	\N	\N	0	{"tags": ["cachoeira", "30m", "véu-de-noiva"], "enriched": true}	o_que_fazer	\N	{"type": "cachoeira", "trail": "curta", "height": "30m"}	f	\N	\N	approved	\N	2026-02-07 10:21:49.392824+00	Wikipedia	\N	e9dc6bb0-b9d3-4d95-a02c-8f54b06dea3b	{"[\\"cachoeira\\", \\"30m\\", \\"véu-de-noiva\\"]"}
660999b5-e91e-4ec8-9d4e-afd901c805c1	9c5297ee-89af-4f6f-911a-541813232150	attraction	published	serra-do-corvo-branco-urubici-sc	{"pt": "Serra do Corvo Branco"}	\N	\N	\N	\N	\N	\N	\N	SC-439, Km 20	Urubici	SC	88650-000	-28.024500	-49.571200	2026-02-07 08:36:23.470513+00	2026-02-07 11:17:59.252581+00	Brasil	\N	\N	0	{"tags": ["serra", "corvo-branco", "treeking"], "enriched": true}	o_que_fazer	\N	{"type": "serra", "altitude": 1400}	f	\N	\N	approved	\N	2026-02-07 10:21:49.392824+00	Wikipedia	\N	e9dc6bb0-b9d3-4d95-a02c-8f54b06dea3b	{"[\\"serra\\", \\"corvo-branco\\", \\"treeking\\"]"}
e9b8ce0d-59d4-4b68-b8d6-bcfaf725f780	9c5297ee-89af-4f6f-911a-541813232150	attraction	published	parque-cascata-do-avencal-urubici-sc	{"pt": "Parque Cascata do Avencal"}	\N	\N	\N	\N	\N	\N	\N	Rodovia SC-439, Km 25	Urubici	SC	88650-000	-28.034500	-49.561200	2026-02-07 08:36:23.470513+00	2026-02-07 11:17:59.252581+00	Brasil	\N	\N	0	{"tags": ["parque", "cachoeira", "avencal"], "enriched": true}	o_que_fazer	\N	{"type": "parque", "amenities": ["quiosques", "banheiros"], "entry_fee": "R$ 30,00"}	f	\N	\N	approved	\N	2026-02-07 10:21:49.392824+00	Wikipedia	\N	e9dc6bb0-b9d3-4d95-a02c-8f54b06dea3b	{"[\\"parque\\", \\"cachoeira\\", \\"avencal\\"]"}
665616b4-dd7d-48ba-8808-4628eccc09b7	9c5297ee-89af-4f6f-911a-541813232150	attraction	published	mirante-refugio-das-araucarias-urubici-sc	{"pt": "Mirante Refúgio das Araucárias"}	\N	\N	\N	\N	\N	\N	\N	Estrada das Araucárias, Km 8	Urubici	SC	88650-000	-27.994500	-49.581200	2026-02-07 08:36:23.470513+00	2026-02-07 11:17:59.252581+00	Brasil	\N	\N	0	{"tags": ["mirante", "araucárias", "pôr-do-sol"], "enriched": true}	o_que_fazer	\N	{"type": "mirante", "best_time": "pôr-do-sol"}	f	\N	\N	approved	\N	2026-02-07 10:21:49.392824+00	Wikipedia	\N	e9dc6bb0-b9d3-4d95-a02c-8f54b06dea3b	{"[\\"mirante\\", \\"araucárias\\", \\"pôr-do-sol\\"]"}
dc4f3668-74cc-4e8d-ac96-8909452bdb8b	9c5297ee-89af-4f6f-911a-541813232150	attraction	published	gruta-nossa-senhora-de-lourdes-urubici-sc	{"pt": "Gruta Nossa Senhora de Lourdes"}	\N	\N	\N	\N	\N	\N	\N	Estrada da Gruta, S/N	Urubici	SC	88650-000	-28.014500	-49.601200	2026-02-07 08:36:23.470513+00	2026-02-07 11:17:59.252581+00	Brasil	\N	\N	0	{"tags": ["gruta", "religioso", "nossa-senhora"], "enriched": true}	o_que_fazer	\N	{"type": "religioso"}	f	\N	\N	approved	\N	2026-02-07 10:21:49.392824+00	Wikipedia	\N	e9dc6bb0-b9d3-4d95-a02c-8f54b06dea3b	{"[\\"gruta\\", \\"religioso\\", \\"nossa-senhora\\"]"}
4909fa64-b386-41f1-8a21-23c39387fa63	9c5297ee-89af-4f6f-911a-541813232150	attraction	published	morro-do-campestre-urubici-sc	{"pt": "Morro do Campestre"}	\N	\N	\N	\N	\N	\N	\N	Estrada do Morro do Campestre, Km 5	Urubici	SC	88650-000	-28.004500	-49.571200	2026-02-07 08:36:23.470513+00	2026-02-07 11:17:59.252581+00	Brasil	\N	\N	0	{"tags": ["morro", "vista-360", "campestre"], "enriched": true}	o_que_fazer	\N	{"type": "morro", "view": "360-graus"}	f	\N	\N	approved	\N	2026-02-07 10:21:49.392824+00	Wikipedia	\N	e9dc6bb0-b9d3-4d95-a02c-8f54b06dea3b	{"[\\"morro\\", \\"vista-360\\", \\"campestre\\"]"}
e03ec206-9400-4a03-b77f-979053e06719	9c5297ee-89af-4f6f-911a-541813232150	attraction	published	sitio-arqueologico-de-urubici-urubici-sc	{"pt": "Sítio Arqueológico de Urubici"}	\N	\N	\N	\N	\N	\N	\N	Estrada do Sítio Arqueológico, S/N	Urubici	SC	88650-000	-28.014500	-49.581200	2026-02-07 08:36:23.470513+00	2026-02-07 11:17:59.252581+00	Brasil	\N	\N	0	{"tags": ["sítio-arqueológico", "pinturas", "pré-história"], "enriched": true}	o_que_fazer	\N	{"type": "pinturas-rupestres"}	f	\N	\N	approved	\N	2026-02-07 10:21:49.392824+00	Wikipedia	\N	e9dc6bb0-b9d3-4d95-a02c-8f54b06dea3b	{"[\\"sítio-arqueológico\\", \\"pinturas\\", \\"pré-história\\"]"}
cb6be0c7-3b5c-464e-97e2-56feb3a3a145	9c5297ee-89af-4f6f-911a-541813232150	service	published	drogaria-nossa-senhora-urubici-sc	{"pt": "Drogaria Nossa Senhora"}	\N	{"pt": "Farmácia tradicional do centro. Funcionamento: 08h às 22h. Aceita todos os convênios."}	\N	(49) 3334-2525	\N	\N	\N	Av. São Paulo, 1456	Urubici	SC	88650-000	-27.984567	-49.588901	2026-02-07 09:10:39.807896+00	2026-02-07 11:17:59.252581+00	Brasil	\N	\N	0	{"tags": ["drogaria", "centro"], "enriched": true}	guia_medico	\N	{"emergency": false, "specialty": "Farmácia"}	f	\N	\N	approved	\N	2026-02-07 10:39:18.002051+00	Agente Autônomo	\N	aaa613a5-8349-4e8c-88bb-df90fefedb20	{"[\\"drogaria\\", \\"centro\\"]"}
9dab304e-4187-4a2c-a67f-0ce5806bb98f	9c5297ee-89af-4f6f-911a-541813232150	lodging	published	hostel-serra-catarinense-urubici-sc	{"pt": "Hostel Serra Catarinense"}	\N	{"pt": "Hostel econômico com ambiente jovem e descontraído."}	\N	(49) 3335-8888	\N	\N	\N	Av. São Paulo, 1123	Urubici	SC	88650-000	-27.978901	-49.579012	2026-02-07 08:55:16.193766+00	2026-02-07 11:17:59.252581+00	Brasil	\N	\N	0	{"tags": ["hostel", "jovem"], "enriched": true}	onde_ficar	\N	{"type": "hostel", "amenities": ["cozinha-compartilhada"]}	f	\N	\N	approved	\N	2026-02-07 10:38:42.527351+00	Agente Autônomo	\N	bcefcee8-0993-482b-8825-77fd6b39fd5f	{"[\\"hostel\\", \\"jovem\\"]"}
35d36cc5-b56d-4f15-a1f3-1a80de31ec58	9c5297ee-89af-4f6f-911a-541813232150	service	published	consultorio-odontologico-central-urubici-sc	{"pt": "Consultório Odontológico Central"}	\N	{"pt": "Dentista geral e especializado. Ortodontia, implantes e tratamentos estéticos."}	\N	(49) 3335-2626	\N	\N	\N	Rua Bento Gonçalves, 1122	Urubici	SC	88650-000	-27.980123	-49.583456	2026-02-07 09:10:39.807896+00	2026-02-07 11:17:59.252581+00	Brasil	\N	\N	0	{"tags": ["dentista", "ortodontia"], "enriched": true}	guia_medico	\N	{"emergency": false, "specialty": "Odontologia"}	f	\N	\N	approved	\N	2026-02-07 10:39:18.002051+00	Agente Autônomo	\N	aaa613a5-8349-4e8c-88bb-df90fefedb20	{"[\\"dentista\\", \\"ortodontia\\"]"}
d23cdc0b-2672-4b6a-9ff1-ec7902493a82	9c5297ee-89af-4f6f-911a-541813232150	service	published	clinica-veterinaria-pet-serra-urubici-sc	{"pt": "Clínica Veterinária Pet Serra"}	\N	{"pt": "Atendimento veterinário completo para cães e gatos. Emergência 24h."}	\N	(49) 3333-2727	\N	\N	\N	Estrada Geral, 345	Urubici	SC	88650-000	-27.991234	-49.586789	2026-02-07 09:10:39.807896+00	2026-02-07 11:17:59.252581+00	Brasil	\N	\N	0	{"tags": ["veterinário", "pets"], "enriched": true}	guia_medico	\N	{"emergency": true, "specialty": "Veterinária"}	f	\N	\N	approved	\N	2026-02-07 10:39:18.002051+00	Agente Autônomo	\N	aaa613a5-8349-4e8c-88bb-df90fefedb20	{"[\\"veterinário\\", \\"pets\\"]"}
ab777a4f-86c7-46aa-80f1-5dfe5fd0385a	9c5297ee-89af-4f6f-911a-541813232150	service	published	laboratorio-de-analises-clinicas-urubici-sc	{"pt": "Laboratório de Análises Clínicas"}	\N	{"pt": "Exames laboratoriais de rotina e especializados. Resultados em 24-48h."}	\N	(49) 3334-2828	\N	\N	\N	Rua Padre Roer, 789	Urubici	SC	88650-000	-27.987654	-49.582345	2026-02-07 09:10:39.807896+00	2026-02-07 11:17:59.252581+00	Brasil	\N	\N	0	{"tags": ["laboratório", "exames"], "enriched": true}	guia_medico	\N	{"emergency": false, "specialty": "Laboratório"}	f	\N	\N	approved	\N	2026-02-07 10:39:18.002051+00	Agente Autônomo	\N	aaa613a5-8349-4e8c-88bb-df90fefedb20	{"[\\"laboratório\\", \\"exames\\"]"}
1b48504a-321f-4f78-8f0b-6af208905236	9c5297ee-89af-4f6f-911a-541813232150	service	published	fisioterapia-e-reabilitacao-urubici-sc	{"pt": "Fisioterapia e Reabilitação"}	\N	{"pt": "Tratamentos de fisioterapia, pilates e reabilitação. Convênios aceitos."}	\N	(49) 3335-2929	\N	\N	\N	Av. Getúlio Vargas, 1023	Urubici	SC	88650-000	-27.983456	-49.580123	2026-02-07 09:10:39.807896+00	2026-02-07 11:17:59.252581+00	Brasil	\N	\N	0	{"tags": ["fisioterapia", "pilates"], "enriched": true}	guia_medico	\N	{"emergency": false, "specialty": "Fisioterapia"}	f	\N	\N	approved	\N	2026-02-07 10:39:18.002051+00	Agente Autônomo	\N	aaa613a5-8349-4e8c-88bb-df90fefedb20	{"[\\"fisioterapia\\", \\"pilates\\"]"}
75ee4940-a53f-4369-b3a2-43cb24969911	9c5297ee-89af-4f6f-911a-541813232150	lodging	published	resort-montanhas-de-urubici-urubici-sc	{"pt": "Resort Montanhas de Urubici"}	\N	{"pt": "Resort all-inclusive com piscina aquecida e atividades."}	\N	(49) 3333-9999	\N	\N	\N	Rodovia SC-439, Km 15	Urubici	SC	88650-000	-27.975678	-49.596789	2026-02-07 08:55:16.193766+00	2026-02-07 11:17:59.252581+00	Brasil	\N	\N	0	{"tags": ["resort", "all-inclusive"], "enriched": true}	onde_ficar	\N	{"type": "resort", "amenities": ["all-inclusive", "piscina"]}	f	\N	\N	approved	\N	2026-02-07 10:38:42.527351+00	Agente Autônomo	\N	bcefcee8-0993-482b-8825-77fd6b39fd5f	{"[\\"resort\\", \\"all-inclusive\\"]"}
7610048b-a323-4590-a2f6-3615373700a7	9c5297ee-89af-4f6f-911a-541813232150	lodging	published	pousada-recanto-da-natureza-urubici-sc	{"pt": "Pousada Recanto da Natureza"}	\N	{"pt": "Pousada familiar com área verde e trilhas particulares."}	\N	(49) 3334-0000	\N	\N	\N	Estrada Geral, 2000 - Lagoa	Urubici	SC	88650-000	-27.989012	-49.582345	2026-02-07 08:55:16.193766+00	2026-02-07 11:17:59.252581+00	Brasil	\N	\N	0	{"tags": ["pousada", "natureza"], "enriched": true}	onde_ficar	\N	{"type": "pousada", "amenities": ["area-verde", "trilhas"]}	f	\N	\N	approved	\N	2026-02-07 10:38:42.527351+00	Agente Autônomo	\N	bcefcee8-0993-482b-8825-77fd6b39fd5f	{"[\\"pousada\\", \\"natureza\\"]"}
2d6c170e-a265-4d51-9199-7367c9d83934	9c5297ee-89af-4f6f-911a-541813232150	food	published	pizzaria-serrana-urubici-sc	{"pt": "Pizzaria Serrana"}	\N	{"pt": "Pizzas artesanais assadas em forno a lenha. Massa fermentação natural."}	\N	(49) 3335-8381	\N	\N	\N	Rua Bento Gonçalves, 77 - São Cristóvão	Urubici	SC	88650-000	-27.976483	-49.581678	2026-02-07 08:55:16.193766+00	2026-02-07 11:17:59.252581+00	Brasil	\N	\N	0	{"tags": ["pizzaria", "forno-a-lenha"], "enriched": true}	onde_comer	\N	{"cuisine": "Pizzaria", "price_range": "medium"}	f	\N	\N	approved	\N	2026-02-07 10:38:42.527351+00	Agente Autônomo	\N	0ce344c8-bd92-4b6f-b1ac-29a405b882a3	{"[\\"pizzaria\\", \\"forno-a-lenha\\"]"}
84935995-ce00-4906-813e-0ddeb8ea8ac2	9c5297ee-89af-4f6f-911a-541813232150	food	published	churrascaria-boi-na-brasa-urubici-sc	{"pt": "Churrascaria Boi na Brasa"}	\N	{"pt": "Carnes nobres grelhadas na brasa. Rodízio completo com saladas."}	\N	(49) 3333-2345	\N	\N	\N	Estrada Morro da Igreja, 1450	Urubici	SC	88650-000	-27.991234	-49.582345	2026-02-07 08:55:16.193766+00	2026-02-07 11:17:59.252581+00	Brasil	\N	\N	0	{"tags": ["churrascaria", "rodízio"], "enriched": true}	onde_comer	\N	{"cuisine": "Churrasco", "price_range": "premium"}	f	\N	\N	approved	\N	2026-02-07 10:38:42.527351+00	Agente Autônomo	\N	0ce344c8-bd92-4b6f-b1ac-29a405b882a3	{"[\\"churrascaria\\", \\"rodízio\\"]"}
274d6acc-4874-4ac0-af0b-ac0994db25cf	9c5297ee-89af-4f6f-911a-541813232150	food	published	restaurante-tematico-casa-da-montanha-urubici-sc	{"pt": "Restaurante Temático Casa da Montanha"}	\N	{"pt": "Culinária regional especializada em truta e pinhão. Ambiente acolhedor com lareira."}	\N	(49) 3333-6612	\N	\N	\N	Rua Irineu Bornhausen, 1089 - Centro	Urubici	SC	88650-000	-27.996944	-49.591700	2026-02-07 08:55:16.193766+00	2026-02-07 11:17:59.252581+00	Brasil	\N	\N	0	{"tags": ["restaurante", "truta", "pinhão"], "enriched": true}	onde_comer	\N	{"cuisine": "Regional", "price_range": "medium"}	f	\N	\N	approved	\N	2026-02-07 10:38:42.527351+00	Agente Autônomo	\N	0ce344c8-bd92-4b6f-b1ac-29a405b882a3	{"[\\"restaurante\\", \\"truta\\", \\"pinhão\\"]"}
1380e815-be94-4a2b-bb08-2c54f2955940	9c5297ee-89af-4f6f-911a-541813232150	attraction	published	cachoeira-papua-urubici-sc	{"pt": "Cachoeira Papuã"}	\N	\N	\N	\N	\N	\N	\N	Estrada Cachoeira Papuã, Km 4	Urubici	SC	88650-000	-28.014500	-49.621200	2026-02-07 08:36:23.470513+00	2026-02-07 11:17:59.252581+00	Brasil	\N	\N	0	{"tags": ["cachoeira", "papuã", "família"], "enriched": true}	o_que_fazer	\N	{"type": "cachoeira", "access": "fácil", "family-friendly": true}	f	\N	\N	approved	\N	2026-02-07 10:21:49.392824+00	Wikipedia	\N	e9dc6bb0-b9d3-4d95-a02c-8f54b06dea3b	{"[\\"cachoeira\\", \\"papuã\\", \\"família\\"]"}
613199b4-9ae8-47a9-8599-1bb9b18c8493	9c5297ee-89af-4f6f-911a-541813232150	lodging	published	pousada-vale-dos-sonhos-urubici-sc	{"pt": "Pousada Vale dos Sonhos"}	\N	{"pt": "Aconchegante pousada com vista para as montanhas. Café da manhã típico colonial."}	\N	(49) 3334-1111	\N	\N	\N	Estrada Morro da Igreja, 2000	Urubici	SC	88650-000	-27.995678	-49.588901	2026-02-07 08:55:16.193766+00	2026-02-07 11:17:59.252581+00	Brasil	\N	\N	0	{"tags": ["pousada", "montanha"], "enriched": true}	onde_ficar	\N	{"type": "pousada", "amenities": ["wi-fi", "café-da-manhã"]}	f	\N	\N	approved	\N	2026-02-07 10:38:42.527351+00	Agente Autônomo	\N	bcefcee8-0993-482b-8825-77fd6b39fd5f	{"[\\"pousada\\", \\"montanha\\"]"}
2d55419a-66fb-4a69-8e2d-786c3a878a5e	9c5297ee-89af-4f6f-911a-541813232150	lodging	published	hotel-fazenda-serra-verde-urubici-sc	{"pt": "Hotel Fazenda Serra Verde"}	\N	{"pt": "Espaçoso hotel fazenda com atividades rurais. Ideal para famílias."}	\N	(49) 3335-2222	\N	\N	\N	Rodovia SC-439, Km 8	Urubici	SC	88650-000	-27.982345	-49.592345	2026-02-07 08:55:16.193766+00	2026-02-07 11:17:59.252581+00	Brasil	\N	\N	0	{"tags": ["hotel-fazenda", "família"], "enriched": true}	onde_ficar	\N	{"type": "hotel", "amenities": ["piscina", "restaurante"]}	f	\N	\N	approved	\N	2026-02-07 10:38:42.527351+00	Agente Autônomo	\N	bcefcee8-0993-482b-8825-77fd6b39fd5f	{"[\\"hotel-fazenda\\", \\"família\\"]"}
ce2043f0-096d-497d-a810-d98637ad4999	9c5297ee-89af-4f6f-911a-541813232150	food	published	restaurante-bela-vista-urubici-sc	{"pt": "Restaurante Bela Vista"}	\N	{"pt": "Vista panorâmica das montanhas. Cozinha contemporânea com toque regional."}	\N	(49) 3334-5678	\N	\N	\N	Rodovia SC-439, Km 12	Urubici	SC	88650-000	-27.981234	-49.595678	2026-02-07 08:55:16.193766+00	2026-02-07 11:17:59.252581+00	Brasil	\N	\N	0	{"tags": ["restaurante", "vista-panorâmica"], "enriched": true}	onde_comer	\N	{"cuisine": "Contemporânea", "price_range": "luxury"}	f	\N	\N	approved	\N	2026-02-07 10:38:42.527351+00	Agente Autônomo	\N	0ce344c8-bd92-4b6f-b1ac-29a405b882a3	{"[\\"restaurante\\", \\"vista-panorâmica\\"]"}
59a82ee7-1449-430d-9871-3158f3d6355e	9c5297ee-89af-4f6f-911a-541813232150	food	published	cafe-colonial-da-serra-urubici-sc	{"pt": "Café Colonial da Serra"}	\N	{"pt": "Café colonial típico alemão com 30+ itens. Reserva necessária."}	\N	(49) 3335-9991	\N	\N	\N	Av. Urubici, 892	Urubici	SC	88650-000	-27.987654	-49.593456	2026-02-07 08:55:16.193766+00	2026-02-07 11:17:59.252581+00	Brasil	\N	\N	0	{"tags": ["café-colonial", "alemão"], "enriched": true}	onde_comer	\N	{"cuisine": "Café Colonial", "price_range": "medium"}	f	\N	\N	approved	\N	2026-02-07 10:38:42.527351+00	Agente Autônomo	\N	0ce344c8-bd92-4b6f-b1ac-29a405b882a3	{"[\\"café-colonial\\", \\"alemão\\"]"}
220759e0-1216-44ea-aa2c-9a1700a40578	9c5297ee-89af-4f6f-911a-541813232150	food	published	lanchonete-central-urubici-sc	{"pt": "Lanchonete Central"}	\N	{"pt": "Xis completo e lanches rápidos. Aberto até tarde."}	\N	(49) 3333-8765	\N	\N	\N	Rua das Araucárias, 234 - Centro	Urubici	SC	88650-000	-27.993456	-49.589012	2026-02-07 08:55:16.193766+00	2026-02-07 11:17:59.252581+00	Brasil	\N	\N	0	{"tags": ["lanchonete", "xis"], "enriched": true}	onde_comer	\N	{"cuisine": "Lanches", "price_range": "economic"}	f	\N	\N	approved	\N	2026-02-07 10:38:42.527351+00	Agente Autônomo	\N	0ce344c8-bd92-4b6f-b1ac-29a405b882a3	{"[\\"lanchonete\\", \\"xis\\"]"}
08720ce6-2175-4275-8d8b-a40e30440e85	9c5297ee-89af-4f6f-911a-541813232150	service	published	clinica-medica-dr-silva-urubici-sc	{"pt": "Clínica Médica Dr. Silva"}	\N	{"pt": "Clínica geral com diversas especialidades. Atendimento por convênio e particular."}	\N	(49) 3335-2121	\N	\N	\N	Av. Beira Rio, 432	Urubici	SC	88650-000	-27.982345	-49.580123	2026-02-07 09:10:39.807896+00	2026-02-07 11:17:59.252581+00	Brasil	\N	\N	0	{"tags": ["clínica", "convênio"], "enriched": true}	guia_medico	\N	{"emergency": false, "specialty": "Clínica Geral"}	f	\N	\N	approved	\N	2026-02-07 10:39:18.002051+00	Agente Autônomo	\N	aaa613a5-8349-4e8c-88bb-df90fefedb20	{"[\\"clínica\\", \\"convênio\\"]"}
b513f95c-b5e1-4d4f-a0a4-c1615c89e0d1	9c5297ee-89af-4f6f-911a-541813232150	service	published	farmacia-sao-joao-urubici-sc	{"pt": "Farmácia São João"}	\N	{"pt": "Farmácia 24 horas com plantão noturno. Delivery de medicamentos disponível."}	\N	(49) 3333-2424	\N	\N	\N	Rua Irineu Bornhausen, 2345	Urubici	SC	88650-000	-27.996789	-49.593456	2026-02-07 09:10:39.807896+00	2026-02-07 11:17:59.252581+00	Brasil	\N	\N	0	{"tags": ["farmácia", "24h"], "enriched": true}	guia_medico	\N	{"emergency": true, "specialty": "Farmácia"}	f	\N	\N	approved	\N	2026-02-07 10:39:18.002051+00	Agente Autônomo	\N	aaa613a5-8349-4e8c-88bb-df90fefedb20	{"[\\"farmácia\\", \\"24h\\"]"}
3b655560-5417-4c4d-a48a-8e0105254dae	9c5297ee-89af-4f6f-911a-541813232150	lodging	published	chales-do-morro-urubici-sc	{"pt": "Chalés do Morro"}	\N	{"pt": "Chalés rústicos com lareira e varanda. Contato direto com a natureza."}	\N	(49) 3333-3333	\N	\N	\N	Rua Padre Roer, 456	Urubici	SC	88650-000	-27.988901	-49.586789	2026-02-07 08:55:16.193766+00	2026-02-07 11:17:59.252581+00	Brasil	\N	\N	0	{"tags": ["chalés", "privacidade"], "enriched": true}	onde_ficar	\N	{"type": "chalé", "amenities": ["lareira", "varanda"]}	f	\N	\N	approved	\N	2026-02-07 10:38:42.527351+00	Agente Autônomo	\N	bcefcee8-0993-482b-8825-77fd6b39fd5f	{"[\\"chalés\\", \\"privacidade\\"]"}
b11b62e2-dec8-4712-ac45-992a71dd1630	9c5297ee-89af-4f6f-911a-541813232150	lodging	published	pousada-das-araucarias-urubici-sc	{"pt": "Pousada das Araucárias"}	\N	{"pt": "Pousada econômica cercada por araucárias centenárias."}	\N	(49) 3334-4444	\N	\N	\N	Av. Getúlio Vargas, 678	Urubici	SC	88650-000	-27.981234	-49.584567	2026-02-07 08:55:16.193766+00	2026-02-07 11:17:59.252581+00	Brasil	\N	\N	0	{"tags": ["pousada", "econômica"], "enriched": true}	onde_ficar	\N	{"type": "pousada", "amenities": ["wi-fi"]}	f	\N	\N	approved	\N	2026-02-07 10:38:42.527351+00	Agente Autônomo	\N	bcefcee8-0993-482b-8825-77fd6b39fd5f	{"[\\"pousada\\", \\"econômica\\"]"}
f9733a8f-6630-4d34-906e-aa46b7934966	9c5297ee-89af-4f6f-911a-541813232150	lodging	published	hotel-colonial-urubici-sc	{"pt": "Hotel Colonial"}	\N	{"pt": "Hotel luxuoso com spa e gastronomia refinada. Vista panorâmica."}	\N	(49) 3335-5555	\N	\N	\N	Rua Buarque de Macedo, 890	Urubici	SC	88650-000	-27.994567	-49.590123	2026-02-07 08:55:16.193766+00	2026-02-07 11:17:59.252581+00	Brasil	\N	\N	0	{"tags": ["hotel", "luxo"], "enriched": true}	onde_ficar	\N	{"type": "hotel", "amenities": ["spa", "luxo"]}	f	\N	\N	approved	\N	2026-02-07 10:38:42.527351+00	Agente Autônomo	\N	bcefcee8-0993-482b-8825-77fd6b39fd5f	{"[\\"hotel\\", \\"luxo\\"]"}
c26acdc7-92b6-4c57-8460-a0b5cbfcf382	9c5297ee-89af-4f6f-911a-541813232150	food	published	restaurante-do-gaucho-urubici-sc	{"pt": "Restaurante do Gaucho"}	\N	{"pt": "Rodízio de carnes sulistas. Espeto corrido e churrasco."}	\N	(49) 3334-4321	\N	\N	\N	Estrada do Corvo Branco, 567	Urubici	SC	88650-000	-27.979012	-49.585678	2026-02-07 08:55:16.193766+00	2026-02-07 11:17:59.252581+00	Brasil	\N	\N	0	{"tags": ["churrascaria", "gaucho"], "enriched": true}	onde_comer	\N	{"cuisine": "Churrasco", "price_range": "medium"}	f	\N	\N	approved	\N	2026-02-07 10:38:42.527351+00	Agente Autônomo	\N	0ce344c8-bd92-4b6f-b1ac-29a405b882a3	{"[\\"churrascaria\\", \\"gaucho\\"]"}
50c62e8d-62e8-480f-a3d5-b9aac9b3abdd	9c5297ee-89af-4f6f-911a-541813232150	food	published	cantina-italiana-urubici-sc	{"pt": "Cantina Italiana"}	\N	{"pt": "Massas artesanais frescas. Molhos caseiros e vinhos selecionados."}	\N	(49) 3335-2468	\N	\N	\N	Rua das Cachoeiras, 789	Urubici	SC	88650-000	-27.984567	-49.580123	2026-02-07 08:55:16.193766+00	2026-02-07 11:17:59.252581+00	Brasil	\N	\N	0	{"tags": ["cantina", "massas"], "enriched": true}	onde_comer	\N	{"cuisine": "Italiana", "price_range": "medium"}	f	\N	\N	approved	\N	2026-02-07 10:38:42.527351+00	Agente Autônomo	\N	0ce344c8-bd92-4b6f-b1ac-29a405b882a3	{"[\\"cantina\\", \\"massas\\"]"}
7e27bc20-7ca9-4b1e-9cd0-004feb337066	9c5297ee-89af-4f6f-911a-541813232150	food	published	peixaria-do-lago-urubici-sc	{"pt": "Peixaria do Lago"}	\N	{"pt": "Truta fresca de criação local. Preparada de diversas formas."}	\N	(49) 3333-1357	\N	\N	\N	Av. Beira Rio, 321	Urubici	SC	88650-000	-27.990123	-49.594567	2026-02-07 08:55:16.193766+00	2026-02-07 11:17:59.252581+00	Brasil	\N	\N	0	{"tags": ["peixaria", "truta"], "enriched": true}	onde_comer	\N	{"cuisine": "Frutos do Mar", "price_range": "medium"}	f	\N	\N	approved	\N	2026-02-07 10:38:42.527351+00	Agente Autônomo	\N	0ce344c8-bd92-4b6f-b1ac-29a405b882a3	{"[\\"peixaria\\", \\"truta\\"]"}
732003c7-a7fd-47a6-8197-eb2113c996be	9c5297ee-89af-4f6f-911a-541813232150	service	published	hospital-sao-francisco-de-assis-urubici-sc	{"pt": "Hospital São Francisco de Assis"}	\N	{"pt": "Hospital geral com pronto atendimento 24h. Equipe completa de médicos e enfermagem."}	\N	(49) 3333-1919	\N	\N	\N	Av. Urubici, 1500	Urubici	SC	88650-000	-27.993456	-49.590567	2026-02-07 09:10:39.807896+00	2026-02-07 11:17:59.252581+00	Brasil	\N	\N	0	{"tags": ["hospital", "24h"], "enriched": true}	guia_medico	\N	{"amenities": ["UTI", "pronto-atendimento"], "emergency": true, "specialty": "Geral"}	f	\N	\N	approved	\N	2026-02-07 10:39:18.002051+00	Agente Autônomo	\N	aaa613a5-8349-4e8c-88bb-df90fefedb20	{"[\\"hospital\\", \\"24h\\"]"}
bb12175e-7acf-42c6-82f5-8abbca66c627	9c5297ee-89af-4f6f-911a-541813232150	service	published	pronto-socorro-municipal-urubici-sc	{"pt": "Pronto Socorro Municipal"}	\N	{"pt": "Atendimento de urgência e emergência 24 horas. Ambulâncias disponíveis."}	\N	(49) 3334-1920	\N	\N	\N	Rua Marechal Deodoro, 800	Urubici	SC	88650-000	-27.988123	-49.585678	2026-02-07 09:10:39.807896+00	2026-02-07 11:17:59.252581+00	Brasil	\N	\N	0	{"tags": ["pronto-socorro", "24h"], "enriched": true}	guia_medico	\N	{"emergency": true, "specialty": "Emergência"}	f	\N	\N	approved	\N	2026-02-07 10:39:18.002051+00	Agente Autônomo	\N	aaa613a5-8349-4e8c-88bb-df90fefedb20	{"[\\"pronto-socorro\\", \\"24h\\"]"}
c7d78327-c771-4ec4-a23f-02f5d4e0aed3	9c5297ee-89af-4f6f-911a-541813232150	service	published	farmacia-de-manipulacao-urubici-sc	{"pt": "Farmácia de Manipulação"}	\N	{"pt": "Medicações manipuladas sob encomenda. Produtos naturais e homeopatia."}	\N	(49) 3333-3030	\N	\N	\N	Rua das Araucárias, 1567	Urubici	SC	88650-000	-27.995678	-49.587890	2026-02-07 09:10:39.807896+00	2026-02-07 11:17:59.252581+00	Brasil	\N	\N	0	{"tags": ["manipulação", "homeopatia"], "enriched": true}	guia_medico	\N	{"emergency": false, "specialty": "Manipulação"}	f	\N	\N	approved	\N	2026-02-07 10:39:18.002051+00	Agente Autônomo	\N	aaa613a5-8349-4e8c-88bb-df90fefedb20	{"[\\"manipulação\\", \\"homeopatia\\"]"}
\.


--
-- TOC entry 5171 (class 0 OID 109927)
-- Dependencies: 359
-- Data for Name: platform_roles; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.platform_roles (user_id, role, created_at, updated_at) FROM stdin;
c7079292-56a2-427b-9cd4-154a61f65968	super_admin	2026-01-30 11:46:00.45605+00	2026-02-01 16:15:08.108009+00
\.


--
-- TOC entry 5157 (class 0 OID 106561)
-- Dependencies: 345
-- Data for Name: post_categories; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.post_categories (id, site_id, slug, name_i18n, sort_order, is_active, created_at, updated_at) FROM stdin;
caa64174-c26b-41d9-99ae-410cb3aabc8d	9c5297ee-89af-4f6f-911a-541813232150	noticias	{"en": "News", "es": "Noticias", "pt": "Notícias"}	10	t	2026-01-27 13:57:14.96763+00	2026-01-27 13:57:14.96763+00
2fba8e5e-c6ed-4705-b0a8-fb1fecf1e67b	9c5297ee-89af-4f6f-911a-541813232150	eventos	{"en": "Events", "es": "Eventos", "pt": "Eventos"}	20	t	2026-01-27 13:57:14.96763+00	2026-01-27 13:57:14.96763+00
2c54c845-40ca-438a-8079-9f64e33db607	9c5297ee-89af-4f6f-911a-541813232150	guias	{"en": "Guides", "es": "Guías", "pt": "Guias"}	30	t	2026-01-27 13:57:14.96763+00	2026-01-27 13:57:14.96763+00
\.


--
-- TOC entry 5159 (class 0 OID 106606)
-- Dependencies: 347
-- Data for Name: post_tag_links; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.post_tag_links (post_id, tag_id) FROM stdin;
\.


--
-- TOC entry 5158 (class 0 OID 106584)
-- Dependencies: 346
-- Data for Name: post_tags; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.post_tags (id, site_id, slug, name_i18n, is_active, created_at, updated_at) FROM stdin;
e089e445-d1fc-45c7-b0cc-37257cccd3d0	9c5297ee-89af-4f6f-911a-541813232150	serra-catarinense	{"en": "Santa Catarina Highlands", "es": "Sierra Catarinense", "pt": "Serra Catarinense"}	t	2026-01-27 13:57:14.96763+00	2026-01-27 13:57:14.96763+00
189ac27e-4433-4b39-87f9-053f347c4c56	9c5297ee-89af-4f6f-911a-541813232150	natureza	{"en": "Nature", "es": "Naturaleza", "pt": "Natureza"}	t	2026-01-27 13:57:14.96763+00	2026-01-27 13:57:14.96763+00
afa95248-ddcd-43ec-84ce-bac6ecc59fb6	9c5297ee-89af-4f6f-911a-541813232150	familia	{"en": "Family", "es": "Familia", "pt": "Família"}	t	2026-01-27 13:57:14.96763+00	2026-01-27 13:57:14.96763+00
\.


--
-- TOC entry 5153 (class 0 OID 106355)
-- Dependencies: 341
-- Data for Name: posts; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.posts (id, site_id, slug, title_i18n, excerpt_i18n, content_i18n, cover_url, status, published_at, created_at, updated_at, kind, author_name, meta) FROM stdin;
facaebde-104e-4d3e-91a4-a0a28a1d22b8	9623f594-49ac-4b3f-a84e-19a261338229	atualizacao-clima-serra	{"en": "Update: mountain weather", "es": "Actualización: clima en la sierra", "pt": "Atualização: clima na Serra"}	{"en": "Check conditions for trails and viewpoints today.", "es": "Consulta las condiciones para senderos y miradores hoy.", "pt": "Confira as condições para trilhas e mirantes hoje."}	{"en": "News content (v1).", "es": "Contenido de noticia (v1).", "pt": "Conteúdo de notícia (v1)."}	\N	published	2026-01-25 14:53:26.727496+00	2026-01-25 14:53:26.727496+00	2026-01-25 14:53:26.727496+00	news	\N	{}
0284cec0-6397-4abe-8add-28a92df29758	9623f594-49ac-4b3f-a84e-19a261338229	roteiro-2-dias-urubici	{"en": "2-day itinerary in Urubici", "es": "Itinerario de 2 días en Urubici", "pt": "Roteiro de 2 dias em Urubici"}	{"en": "A practical plan to enjoy the city.", "es": "Un plan práctico para disfrutar la ciudad.", "pt": "Um plano prático para aproveitar bem a cidade."}	{"en": "Blog content (v1).", "es": "Contenido del blog (v1).", "pt": "Conteúdo do blog (v1)."}	\N	published	2026-01-25 14:53:26.727496+00	2026-01-25 14:53:26.727496+00	2026-01-25 14:53:26.727496+00	blog	\N	{}
7566c622-7701-435d-a025-7783cbb41e12	9c5297ee-89af-4f6f-911a-541813232150	bem-vindo-ao-portal-urubici	{"en": "Welcome to Urubici Portal", "es": "Bienvenido al Portal Urubici", "pt": "Bem-vindo ao Portal Urubici"}	{"en": "The city premium guide — attractions, agenda and news.", "es": "La guía premium de la ciudad — atractivos, agenda y noticias.", "pt": "O guia premium da cidade — atrativos, agenda e notícias."}	{"en": "Your journey starts here: organized info, clean visuals, experience-first.", "es": "Aquí empieza el recorrido: información organizada, visual limpio y foco en la experiencia.", "pt": "Aqui começa a jornada: informação organizada, visual limpo e foco em experiência."}	\N	published	2026-01-27 14:11:07.611982+00	2026-01-27 14:11:07.611982+00	2026-01-27 14:11:07.611982+00	blog	Portal Urubici	{"seo": {"category": "noticias"}}
ce1ccba2-e997-41c1-8cd5-ae87ed262b3e	9c5297ee-89af-4f6f-911a-541813232150	roteiro-3-dias-urubici	{"en": "3-day itinerary in Urubici", "es": "Itinerario de 3 días en Urubici", "pt": "Roteiro de 3 dias em Urubici"}	{"en": "A lean, premium itinerary to enjoy the essentials.", "es": "Un itinerario compacto y premium para disfrutar lo esencial.", "pt": "Um roteiro enxuto e premium para aproveitar o essencial."}	{"en": "Day 1: downtown and viewpoints. Day 2: waterfalls. Day 3: hikes and local food.", "es": "Día 1: centro y miradores. Día 2: cascadas. Día 3: senderos y gastronomía local.", "pt": "Dia 1: centro e mirantes. Dia 2: cachoeiras. Dia 3: trilhas e gastronomia local."}	\N	published	2026-01-27 14:11:07.611982+00	2026-01-27 14:11:07.611982+00	2026-01-27 14:11:07.611982+00	blog	Portal Urubici	{"seo": {"category": "guias"}}
35e72158-223f-4636-ad60-f011ca321efb	9c5297ee-89af-4f6f-911a-541813232150	eventos-e-temporadas	{"en": "Events and seasons in Urubici", "es": "Eventos y temporadas en Urubici", "pt": "Eventos e temporadas em Urubici"}	{"en": "Stay updated on what happens in town.", "es": "Mantente al día con lo que pasa en la ciudad.", "pt": "Fique por dentro do que acontece na cidade."}	{"en": "We update events and key dates so you can plan with confidence.", "es": "Actualizamos eventos y fechas clave para que planifiques con tranquilidad.", "pt": "Atualizamos eventos e datas importantes para você planejar com tranquilidade."}	\N	published	2026-01-27 14:11:07.611982+00	2026-01-27 14:11:07.611982+00	2026-01-27 14:11:07.611982+00	news	Portal Urubici	{"seo": {"category": "eventos"}}
bb24ed0c-4428-4e64-8b9e-dd7a8646b440	9c5297ee-89af-4f6f-911a-541813232150	neve-urubici-julho	{"pt": "Frente fria traz neve leve para Urubici"}	{"pt": "Condicoes favoraveis elevaram o fluxo no Morro da Igreja."}	{"pt": "A semana com temperaturas negativas movimentou pousadas e mirantes."}	https://images.unsplash.com/photo-1489515217757-5fd1be406fef?auto=format&fit=crop&w=1600&q=80	published	2026-02-04 19:22:34.881947+00	2026-02-06 19:22:34.881947+00	2026-02-06 19:22:34.881947+00	news	Equipe Portal Urubici	{"tag": "Clima"}
d4d126ea-b32f-47f1-b29c-3e51632bca7a	9c5297ee-89af-4f6f-911a-541813232150	rota-corvo-branco	{"pt": "Rota panoramica da Serra do Corvo Branco ganha novo mirante"}	{"pt": "Obra amplia a visibilidade e a seguranca dos visitantes."}	{"pt": "Novo deck de observacao oferece vista de 180 graus da serra."}	https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?auto=format&fit=crop&w=1600&q=80	published	2026-02-01 19:22:34.881947+00	2026-02-06 19:22:34.881947+00	2026-02-06 19:22:34.881947+00	news	Redacao Serra	{"tag": "Atrativos"}
10198c39-9fc5-4cb4-935a-38754f6f9b74	9c5297ee-89af-4f6f-911a-541813232150	agenda-inverno-cultural	{"pt": "Agenda cultural de inverno confirma 18 eventos"}	{"pt": "Concertos, feiras e gastronomia ocupam o centro da cidade."}	{"pt": "A programacao oficial acontece de junho a agosto."}	https://images.unsplash.com/photo-1469474968028-56623f02e42e?auto=format&fit=crop&w=1600&q=80	published	2026-01-29 19:22:34.881947+00	2026-02-06 19:22:34.881947+00	2026-02-06 19:22:34.881947+00	news	Cultura Urubici	{"tag": "Eventos"}
cdb65e10-451f-4e9d-b44a-c34caaf52e1d	9c5297ee-89af-4f6f-911a-541813232150	gastronomia-altitude-2026	{"pt": "Cozinha de altitude de Urubici entra no radar nacional"}	{"pt": "Chefs convidados apresentam menus exclusivos de inverno."}	{"pt": "Circuito gastronomico destaca truta, pinhao e vinhos finos."}	https://images.unsplash.com/photo-1504674900247-0877df9cc836?auto=format&fit=crop&w=1600&q=80	published	2026-01-26 19:22:34.881947+00	2026-02-06 19:22:34.881947+00	2026-02-06 19:22:34.881947+00	news	Equipe Gastronomia	{"tag": "Gastronomia"}
31421430-95b2-4e84-988b-b16cefbf46dd	9c5297ee-89af-4f6f-911a-541813232150	turismo-aventura-cresce	{"pt": "Turismo de aventura cresce 22% na Serra Catarinense"}	{"pt": "Operadores registram alta procura por trilhas e cachoeiras."}	{"pt": "A ocupacao de fins de semana segue em alta."}	https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?auto=format&fit=crop&w=1600&q=80	published	2026-01-23 19:22:34.881947+00	2026-02-06 19:22:34.881947+00	2026-02-06 19:22:34.881947+00	news	Observatorio Turistico	{"tag": "Aventura"}
1ccf912c-ce6f-447a-8d0b-f975706eada2	9c5297ee-89af-4f6f-911a-541813232150	mirantes-por-do-sol	{"pt": "Cinco mirantes para por do sol em Urubici"}	{"pt": "Rotas acessiveis para quem busca fotografia e paisagem."}	{"pt": "Selecao inclui mirantes com trilhas leves e vistas amplas."}	https://images.unsplash.com/photo-1470770903676-69b98201ea1c?auto=format&fit=crop&w=1600&q=80	published	2026-01-21 19:22:34.881947+00	2026-02-06 19:22:34.881947+00	2026-02-06 19:22:34.881947+00	news	Guia Local	{"tag": "Roteiros"}
d7ce1b8e-120d-4a13-96d8-9aad407e2b66	9c5297ee-89af-4f6f-911a-541813232150	trilhas-avencal	{"pt": "Trilhas do Avencal recebem sinalizacao inteligente"}	{"pt": "Visitantes agora contam com QR Codes e mapas digitais."}	{"pt": "Projeto melhora orientacao e tempo medio de visita."}	https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?auto=format&fit=crop&w=1600&q=80	published	2026-01-18 19:22:34.881947+00	2026-02-06 19:22:34.881947+00	2026-02-06 19:22:34.881947+00	news	Equipe Ecoturismo	{"tag": "Natureza"}
4e485df1-0dc8-44da-a2b5-c269aa098cff	9c5297ee-89af-4f6f-911a-541813232150	ceu-escuro-observatorio	{"pt": "Urubici ganha rota oficial de ceu escuro"}	{"pt": "Observacao astronomica cresce com novas operacoes noturnas."}	{"pt": "A cidade amplia a oferta de experiencias noturnas seguras."}	https://images.unsplash.com/photo-1444703686981-a3abbc4d4fe3?auto=format&fit=crop&w=1600&q=80	published	2026-01-15 19:22:34.881947+00	2026-02-06 19:22:34.881947+00	2026-02-06 19:22:34.881947+00	news	Equipe Astronomia	{"tag": "Experiencias"}
\.


--
-- TOC entry 5148 (class 0 OID 106266)
-- Dependencies: 336
-- Data for Name: profiles; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.profiles (user_id, display_name, created_at, updated_at) FROM stdin;
\.


--
-- TOC entry 5155 (class 0 OID 106471)
-- Dependencies: 343
-- Data for Name: site_content; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.site_content (id, site_id, slot, title_i18n, subtitle_i18n, body_i18n, primary_media_id, cta_label_i18n, cta_url, payload, is_active, created_at, updated_at) FROM stdin;
a5b128ac-aa6c-4517-ac63-00f79e35036e	9623f594-49ac-4b3f-a84e-19a261338229	home_hero	{"en": "Discover Urubici", "es": "Descubre Urubici", "pt": "Descubra Urubici"}	{"en": "Nature, experiences and hospitality in the mountains.", "es": "Naturaleza, experiencias y hospitalidad en la sierra.", "pt": "Natureza, experiências e hospitalidade na Serra Catarinense."}	\N	\N	\N	\N	{"mode": "curated"}	t	2026-01-25 14:38:43.533346+00	2026-01-25 14:38:43.533346+00
212dfadb-0da4-4dde-800a-fa96c3ac712b	9623f594-49ac-4b3f-a84e-19a261338229	home_city_updates	{"en": "City updates", "es": "Ciudad en actualización", "pt": "Cidade em atualização"}	{"en": "News and important travel notices.", "es": "Noticias y avisos importantes para tu viaje.", "pt": "Notícias e avisos importantes para sua viagem."}	\N	\N	\N	\N	{"mode": "auto", "limit": 6, "source": "news"}	t	2026-01-25 14:49:21.839791+00	2026-01-25 14:49:21.839791+00
d4aa410b-4946-4861-947b-ea0f20f4a4d3	9623f594-49ac-4b3f-a84e-19a261338229	home_inspire	{"en": "Get inspired", "es": "Inspírate", "pt": "Inspire-se"}	{"en": "Curated picks of what to see and do.", "es": "Selecciones de qué ver y vivir aquí.", "pt": "Seleções do que vale a pena ver e viver por aqui."}	\N	\N	\N	\N	{"mode": "curated"}	t	2026-01-25 14:49:21.839791+00	2026-01-25 14:49:21.839791+00
a10a1e31-b818-4755-abe6-1371a4dfb2f5	9623f594-49ac-4b3f-a84e-19a261338229	home_experiences	{"en": "Experiences", "es": "Experiencias", "pt": "Experiências"}	{"en": "Attractions and experiences worth remembering.", "es": "Atractivos y vivencias para recordar.", "pt": "Atrativos e vivências para guardar na memória."}	\N	\N	\N	\N	{"kind": "attraction", "mode": "auto", "limit": 8, "source": "places"}	t	2026-01-25 14:49:21.839791+00	2026-01-25 14:49:21.839791+00
4479d26d-ec2c-44f4-986f-4508c1a5e604	9623f594-49ac-4b3f-a84e-19a261338229	home_where_stay	{"en": "Where to stay", "es": "Dónde alojarse", "pt": "Onde ficar"}	{"en": "Stays for every style.", "es": "Hospedajes para cada estilo.", "pt": "Hospedagens para todos os estilos."}	\N	\N	\N	\N	{"kind": "lodging", "mode": "auto", "limit": 8, "source": "places"}	t	2026-01-25 14:49:21.839791+00	2026-01-25 14:49:21.839791+00
376336f4-1622-4422-8cb7-0e4f7b1e8b72	9623f594-49ac-4b3f-a84e-19a261338229	home_food	{"en": "Highland flavors", "es": "Sabores de la Altura", "pt": "Sabores da Altitude"}	{"en": "Where to eat well in Urubici.", "es": "Dónde comer bien en Urubici.", "pt": "Onde comer bem em Urubici."}	\N	\N	\N	\N	{"kind": "food", "mode": "auto", "limit": 8, "source": "places"}	t	2026-01-25 14:49:21.839791+00	2026-01-25 14:49:21.839791+00
7839850b-3828-4f97-aaa3-31d3e4e19df7	9623f594-49ac-4b3f-a84e-19a261338229	home_agenda	{"en": "Cultural agenda", "es": "Agenda cultural", "pt": "Agenda Cultural"}	{"en": "Events, dates and programming.", "es": "Eventos, fechas y programación.", "pt": "Eventos, datas e programação."}	\N	\N	\N	\N	{"mode": "auto", "limit": 8, "source": "events"}	t	2026-01-25 14:49:21.839791+00	2026-01-25 14:49:21.839791+00
b8dee12e-5316-4855-9adb-356a6a3ada62	9c5297ee-89af-4f6f-911a-541813232150	home_hero	{"en": "Urubici Portal", "es": "Portal Urubici", "pt": "Portal Urubici"}	{"en": "Attractions, stays, food and agenda — with premium standards.", "es": "Atractivos, hospedaje, gastronomía y agenda — con estándar premium.", "pt": "Atrativos, hospedagens, gastronomia e agenda — com padrão premium."}	{"en": "Explore Urubici with organized info, clean visuals and experience-first design.", "es": "Explora Urubici con información organizada, visual limpio y foco en la experiencia.", "pt": "Explore Urubici com informação organizada, visual limpo e foco em experiência."}	\N	{"en": "See attractions", "es": "Ver atractivos", "pt": "Ver atrativos"}	/places	{"badges": ["Serra Catarinense", "Natureza", "Experiências"], "layout": "editorial", "variant": "hero_v1"}	t	2026-01-27 14:15:06.433787+00	2026-01-27 14:24:10.952792+00
29ec3ed5-1639-498c-af26-dc674633a414	9c5297ee-89af-4f6f-911a-541813232150	home_inspire	{"en": "Get inspired", "es": "Inspírate", "pt": "Inspire-se"}	{"en": "Itineraries and quick ideas to plan better.", "es": "Itinerarios e ideas rápidas para planificar mejor.", "pt": "Roteiros e ideias rápidas para planejar melhor."}	{"en": "Editorial content so you can decide with confidence.", "es": "Contenido editorial para decidir con confianza.", "pt": "Conteúdo editorial para você decidir com confiança."}	\N	\N	\N	{"limit": 6, "filter": {"kind": "blog"}, "source": "posts", "variant": "cards"}	t	2026-01-27 14:24:10.952792+00	2026-01-27 14:24:10.952792+00
e6769a98-b54e-4805-8799-ad0c81eb91df	9c5297ee-89af-4f6f-911a-541813232150	home_experiences	{"pt": "Experiencias Imperdiveis"}	{"pt": "Atrativos e rotas que traduzem a serra catarinense."}	\N	\N	{"pt": "Explorar atrativos"}	/#atrativos	{"kind": "attraction", "mode": "auto", "limit": 6, "source": "places"}	t	2026-01-27 14:24:10.952792+00	2026-02-06 19:22:18.472888+00
aaac0140-93d6-4fa9-87e0-6911fa074032	9c5297ee-89af-4f6f-911a-541813232150	home_where_stay	{"pt": "Onde Ficar"}	{"pt": "Hospedagens premium com vista para os vales."}	\N	\N	{"pt": "Ver hospedagens"}	/#hospedagem	{"kind": "lodging", "mode": "auto", "limit": 6, "source": "places"}	t	2026-01-27 14:24:10.952792+00	2026-02-06 19:22:18.472888+00
d0513596-f5ad-4ca8-bd96-b278e7f036e8	9c5297ee-89af-4f6f-911a-541813232150	home_food	{"pt": "Sabores da Altitude"}	{"pt": "Cozinha serrana e experiencias gastronomicas."}	\N	\N	{"pt": "Explorar gastronomia"}	/#gastronomia	{"kind": "food", "mode": "auto", "limit": 6, "source": "places"}	t	2026-01-27 14:24:10.952792+00	2026-02-06 19:22:18.472888+00
5c5c517c-b85c-4c07-8d58-f9a3ffb714cd	9c5297ee-89af-4f6f-911a-541813232150	home_agenda	{"pt": "Agenda Cultural"}	{"pt": "Eventos e experiencias que movimentam a serra."}	\N	\N	{"pt": "Ver agenda"}	/#eventos	{"mode": "auto", "limit": 6, "source": "events"}	t	2026-01-27 14:24:10.952792+00	2026-02-06 19:22:18.472888+00
4f795859-5444-483e-ba92-80e61f0f7db3	9c5297ee-89af-4f6f-911a-541813232150	home_city_updates	{"pt": "Cidade em Atualizacao"}	{"pt": "Noticias oficiais e alertas do destino."}	\N	\N	{"pt": "Ver noticias"}	/#noticias	{"mode": "auto", "limit": 6, "source": "news"}	t	2026-01-27 14:24:10.952792+00	2026-02-06 19:22:18.472888+00
\.


--
-- TOC entry 5149 (class 0 OID 106279)
-- Dependencies: 337
-- Data for Name: site_members; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.site_members (site_id, user_id, role, created_at, updated_at) FROM stdin;
9c5297ee-89af-4f6f-911a-541813232150	c7079292-56a2-427b-9cd4-154a61f65968	owner	2026-02-01 16:21:46.980119+00	2026-02-02 02:21:37.790497+00
010f3e62-feb2-4a65-8d09-0f698388d26f	c7079292-56a2-427b-9cd4-154a61f65968	owner	2026-02-01 16:21:46.980119+00	2026-02-02 02:21:37.790497+00
\.


--
-- TOC entry 5172 (class 0 OID 111306)
-- Dependencies: 360
-- Data for Name: site_metrics; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.site_metrics (id, site_id, total_posts, total_events, total_places, total_media, growth_rate_percent, uptime_percent, last_sync_at, total_visits, total_unique_visitors, calculated_at, created_at, updated_at) FROM stdin;
a4180cde-c384-458b-bc2d-b50094c1fa72	9c5297ee-89af-4f6f-911a-541813232150	3	1	3	0	12.50	99.90	2026-02-02 19:40:32.922984+00	0	0	2026-02-02 19:40:32.922984+00	2026-02-02 19:40:32.922984+00	2026-02-02 19:40:32.922984+00
5d994ac7-75f9-4edd-96a3-247556fb332f	91aac245-fdfa-485f-ad88-d4fa7f70d13d	0	0	0	0	12.50	99.90	2026-02-02 19:40:32.922984+00	0	0	2026-02-02 19:40:32.922984+00	2026-02-02 19:40:32.922984+00	2026-02-02 19:40:32.922984+00
f9a00277-3ca3-4275-9afa-52c31536ed88	9623f594-49ac-4b3f-a84e-19a261338229	2	1	0	0	12.50	99.90	2026-02-02 19:40:32.922984+00	0	0	2026-02-02 19:40:32.922984+00	2026-02-02 19:40:32.922984+00	2026-02-02 19:40:32.922984+00
dfe5d7b9-9529-4994-95ba-1dce7250d41a	010f3e62-feb2-4a65-8d09-0f698388d26f	0	0	0	0	12.50	99.90	2026-02-02 19:40:32.922984+00	0	0	2026-02-02 19:40:32.922984+00	2026-02-02 19:40:32.922984+00	2026-02-02 19:40:32.922984+00
\.


--
-- TOC entry 5147 (class 0 OID 106254)
-- Dependencies: 335
-- Data for Name: sites; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.sites (id, slug, name_i18n, created_at, updated_at, is_active, default_locale, supported_locales, primary_domain, meta, status) FROM stdin;
9c5297ee-89af-4f6f-911a-541813232150	urubici	{"en": "Urubici Connect Portal", "pt": "Portal Urubici"}	2026-01-27 13:36:36.648824+00	2026-01-29 23:31:21.434581+00	t	pt	{pt,en,es}	portal.urubici.com.br	{"seo": {"title": {"en": "Urubici Portal", "es": "Portal Urubici", "pt": "Portal Urubici"}, "description": {"en": "Premium guide to Urubici: attractions, events, news and experiences.", "es": "Guía premium de Urubici: atractivos, eventos, noticias y experiencias.", "pt": "Guia premium de Urubici: atrativos, eventos, notícias e experiências."}}}	published
91aac245-fdfa-485f-ad88-d4fa7f70d13d	portal-connect-admin	{"en": "Portal Connect Admin", "es": "Portal Connect Admin", "pt": "Portal Connect Admin"}	2026-01-26 15:41:04.8582+00	2026-01-30 09:30:38.843688+00	t	pt	{pt,en,es}	\N	{}	archived
9623f594-49ac-4b3f-a84e-19a261338229	portal-urubici	{"en": "Urubici Portal", "es": "Portal Urubici", "pt": "Portal Urubici"}	2026-01-25 14:34:28.248237+00	2026-01-30 09:30:38.843688+00	t	pt	{pt,en,es}	\N	{}	archived
010f3e62-feb2-4a65-8d09-0f698388d26f	sao-joaquim	{"pt": "Portal São Joaquim"}	2026-01-29 19:53:47.647648+00	2026-02-02 18:39:20.212194+00	t	pt	{pt,en,es}	\N	{"seo": {}}	draft
\.


--
-- TOC entry 5161 (class 0 OID 106691)
-- Dependencies: 349
-- Data for Name: user_invitation_sites; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.user_invitation_sites (invitation_id, site_id, portal_role) FROM stdin;
\.


--
-- TOC entry 5160 (class 0 OID 106670)
-- Dependencies: 348
-- Data for Name: user_invitations; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.user_invitations (id, email, invited_by, status, role, token_hash, expires_at, accepted_at, revoked_at, created_at, updated_at, metadata) FROM stdin;
709bb3a3-3802-40b2-9a7f-6e576c70a608	convidado.teste@exemplo.com	c7079292-56a2-427b-9cd4-154a61f65968	pending	editor	hash_fake_apenas_para_teste	2026-02-02 15:48:22.813462+00	\N	\N	2026-01-26 15:48:22.813462+00	2026-01-26 15:48:22.813462+00	{}
\.


--
-- TOC entry 5166 (class 0 OID 106781)
-- Dependencies: 354
-- Data for Name: webhook_deliveries; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.webhook_deliveries (id, webhook_id, site_id, event_type, attempt, status, response_code, latency_ms, error, request_body, response_body, created_at, delivered_at, idempotency_key, next_attempt_at, updated_at) FROM stdin;
\.


--
-- TOC entry 5165 (class 0 OID 106757)
-- Dependencies: 353
-- Data for Name: webhooks; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.webhooks (id, name, site_id, event_type, target_url, secret, is_active, retry_policy, timeout_ms, created_by, created_at, updated_at) FROM stdin;
\.


--
-- TOC entry 5136 (class 0 OID 17109)
-- Dependencies: 320
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: realtime; Owner: -
--

COPY realtime.schema_migrations (version, inserted_at) FROM stdin;
20211116024918	2025-09-30 23:32:02
20211116045059	2025-09-30 23:32:07
20211116050929	2025-09-30 23:32:10
20211116051442	2025-09-30 23:32:13
20211116212300	2025-09-30 23:32:18
20211116213355	2025-09-30 23:32:21
20211116213934	2025-09-30 23:32:24
20211116214523	2025-09-30 23:32:29
20211122062447	2025-09-30 23:32:32
20211124070109	2025-09-30 23:32:35
20211202204204	2025-09-30 23:32:38
20211202204605	2025-09-30 23:32:42
20211210212804	2025-09-30 23:32:52
20211228014915	2025-09-30 23:32:55
20220107221237	2025-09-30 23:32:58
20220228202821	2025-09-30 23:33:02
20220312004840	2025-09-30 23:33:05
20220603231003	2025-09-30 23:33:10
20220603232444	2025-09-30 23:33:14
20220615214548	2025-09-30 23:33:18
20220712093339	2025-09-30 23:33:21
20220908172859	2025-09-30 23:33:24
20220916233421	2025-09-30 23:33:27
20230119133233	2025-09-30 23:33:31
20230128025114	2025-09-30 23:33:35
20230128025212	2025-09-30 23:33:38
20230227211149	2025-09-30 23:33:42
20230228184745	2025-09-30 23:33:45
20230308225145	2025-09-30 23:33:48
20230328144023	2025-09-30 23:33:52
20231018144023	2025-09-30 23:33:56
20231204144023	2025-09-30 23:34:01
20231204144024	2025-09-30 23:34:04
20231204144025	2025-09-30 23:34:07
20240108234812	2025-09-30 23:34:11
20240109165339	2025-09-30 23:34:14
20240227174441	2025-09-30 23:34:20
20240311171622	2025-09-30 23:34:24
20240321100241	2025-09-30 23:34:31
20240401105812	2025-09-30 23:34:40
20240418121054	2025-09-30 23:34:45
20240523004032	2025-09-30 23:34:56
20240618124746	2025-09-30 23:35:00
20240801235015	2025-09-30 23:35:03
20240805133720	2025-09-30 23:35:06
20240827160934	2025-09-30 23:35:09
20240919163303	2025-09-30 23:35:14
20240919163305	2025-09-30 23:35:17
20241019105805	2025-09-30 23:35:20
20241030150047	2025-09-30 23:35:33
20241108114728	2025-09-30 23:35:37
20241121104152	2025-09-30 23:35:40
20241130184212	2025-09-30 23:35:45
20241220035512	2025-09-30 23:35:48
20241220123912	2025-09-30 23:35:51
20241224161212	2025-09-30 23:35:54
20250107150512	2025-09-30 23:35:58
20250110162412	2025-09-30 23:36:01
20250123174212	2025-09-30 23:36:04
20250128220012	2025-09-30 23:36:07
20250506224012	2025-09-30 23:36:10
20250523164012	2025-09-30 23:36:13
20250714121412	2025-09-30 23:36:16
20250905041441	2025-09-30 23:36:20
20251103001201	2025-11-13 13:44:20
20251120212548	2026-02-06 11:37:55
20251120215549	2026-02-06 11:37:56
\.


--
-- TOC entry 5138 (class 0 OID 17131)
-- Dependencies: 323
-- Data for Name: subscription; Type: TABLE DATA; Schema: realtime; Owner: -
--

COPY realtime.subscription (id, subscription_id, entity, filters, claims, created_at, action_filter) FROM stdin;
\.


--
-- TOC entry 5119 (class 0 OID 16546)
-- Dependencies: 300
-- Data for Name: buckets; Type: TABLE DATA; Schema: storage; Owner: -
--

COPY storage.buckets (id, name, owner, created_at, updated_at, public, avif_autodetection, file_size_limit, allowed_mime_types, owner_id, type) FROM stdin;
establishments	establishments	\N	2025-10-01 03:46:18.600418+00	2025-10-01 03:46:18.600418+00	t	f	\N	\N	\N	STANDARD
news	news	\N	2025-10-01 03:46:18.600418+00	2025-10-01 03:46:18.600418+00	t	f	\N	\N	\N	STANDARD
advertisements	advertisements	\N	2025-10-01 03:46:18.600418+00	2025-10-01 03:46:18.600418+00	t	f	\N	\N	\N	STANDARD
\.


--
-- TOC entry 5140 (class 0 OID 20266)
-- Dependencies: 328
-- Data for Name: buckets_analytics; Type: TABLE DATA; Schema: storage; Owner: -
--

COPY storage.buckets_analytics (name, type, format, created_at, updated_at, id, deleted_at) FROM stdin;
\.


--
-- TOC entry 5143 (class 0 OID 52049)
-- Dependencies: 331
-- Data for Name: buckets_vectors; Type: TABLE DATA; Schema: storage; Owner: -
--

COPY storage.buckets_vectors (id, type, created_at, updated_at) FROM stdin;
\.


--
-- TOC entry 5121 (class 0 OID 16588)
-- Dependencies: 302
-- Data for Name: migrations; Type: TABLE DATA; Schema: storage; Owner: -
--

COPY storage.migrations (id, name, hash, executed_at) FROM stdin;
0	create-migrations-table	e18db593bcde2aca2a408c4d1100f6abba2195df	2025-09-30 23:31:48.425911
1	initialmigration	6ab16121fbaa08bbd11b712d05f358f9b555d777	2025-09-30 23:31:48.450509
3	pathtoken-column	2cb1b0004b817b29d5b0a971af16bafeede4b70d	2025-09-30 23:31:48.51287
4	add-migrations-rls	427c5b63fe1c5937495d9c635c263ee7a5905058	2025-09-30 23:31:48.581356
5	add-size-functions	79e081a1455b63666c1294a440f8ad4b1e6a7f84	2025-09-30 23:31:48.58714
7	add-rls-to-buckets	e7e7f86adbc51049f341dfe8d30256c1abca17aa	2025-09-30 23:31:48.599542
8	add-public-to-buckets	fd670db39ed65f9d08b01db09d6202503ca2bab3	2025-09-30 23:31:48.605503
11	add-trigger-to-auto-update-updated_at-column	7425bdb14366d1739fa8a18c83100636d74dcaa2	2025-09-30 23:31:48.623322
12	add-automatic-avif-detection-flag	8e92e1266eb29518b6a4c5313ab8f29dd0d08df9	2025-09-30 23:31:48.640889
13	add-bucket-custom-limits	cce962054138135cd9a8c4bcd531598684b25e7d	2025-09-30 23:31:48.656189
14	use-bytes-for-max-size	941c41b346f9802b411f06f30e972ad4744dad27	2025-09-30 23:31:48.661857
15	add-can-insert-object-function	934146bc38ead475f4ef4b555c524ee5d66799e5	2025-09-30 23:31:48.705877
16	add-version	76debf38d3fd07dcfc747ca49096457d95b1221b	2025-09-30 23:31:48.718382
17	drop-owner-foreign-key	f1cbb288f1b7a4c1eb8c38504b80ae2a0153d101	2025-09-30 23:31:48.724335
18	add_owner_id_column_deprecate_owner	e7a511b379110b08e2f214be852c35414749fe66	2025-09-30 23:31:48.731921
19	alter-default-value-objects-id	02e5e22a78626187e00d173dc45f58fa66a4f043	2025-09-30 23:31:48.740604
20	list-objects-with-delimiter	cd694ae708e51ba82bf012bba00caf4f3b6393b7	2025-09-30 23:31:48.747622
21	s3-multipart-uploads	8c804d4a566c40cd1e4cc5b3725a664a9303657f	2025-09-30 23:31:48.757851
22	s3-multipart-uploads-big-ints	9737dc258d2397953c9953d9b86920b8be0cdb73	2025-09-30 23:31:48.783301
23	optimize-search-function	9d7e604cddc4b56a5422dc68c9313f4a1b6f132c	2025-09-30 23:31:48.801965
24	operation-function	8312e37c2bf9e76bbe841aa5fda889206d2bf8aa	2025-09-30 23:31:48.808598
25	custom-metadata	d974c6057c3db1c1f847afa0e291e6165693b990	2025-09-30 23:31:48.815613
37	add-bucket-name-length-trigger	3944135b4e3e8b22d6d4cbb568fe3b0b51df15c1	2025-10-03 01:38:30.388616
44	vector-bucket-type	99c20c0ffd52bb1ff1f32fb992f3b351e3ef8fb3	2025-11-26 19:05:48.044419
45	vector-buckets	049e27196d77a7cb76497a85afae669d8b230953	2025-11-26 19:05:48.068026
46	buckets-objects-grants	fedeb96d60fefd8e02ab3ded9fbde05632f84aed	2025-11-26 19:05:48.119523
47	iceberg-table-metadata	649df56855c24d8b36dd4cc1aeb8251aa9ad42c2	2025-11-26 19:05:48.122749
49	buckets-objects-grants-postgres	072b1195d0d5a2f888af6b2302a1938dd94b8b3d	2026-01-25 10:58:29.814196
2	storage-schema	f6a1fa2c93cbcd16d4e487b362e45fca157a8dbd	2025-09-30 23:31:48.459596
6	change-column-name-in-get-size	ded78e2f1b5d7e616117897e6443a925965b30d2	2025-09-30 23:31:48.593073
9	fix-search-function	af597a1b590c70519b464a4ab3be54490712796b	2025-09-30 23:31:48.611169
10	search-files-search-function	b595f05e92f7e91211af1bbfe9c6a13bb3391e16	2025-09-30 23:31:48.617335
26	objects-prefixes	215cabcb7f78121892a5a2037a09fedf9a1ae322	2025-10-03 01:38:29.300187
27	search-v2	859ba38092ac96eb3964d83bf53ccc0b141663a6	2025-10-03 01:38:29.447872
28	object-bucket-name-sorting	c73a2b5b5d4041e39705814fd3a1b95502d38ce4	2025-10-03 01:38:30.157138
29	create-prefixes	ad2c1207f76703d11a9f9007f821620017a66c21	2025-10-03 01:38:30.169352
30	update-object-levels	2be814ff05c8252fdfdc7cfb4b7f5c7e17f0bed6	2025-10-03 01:38:30.179206
31	objects-level-index	b40367c14c3440ec75f19bbce2d71e914ddd3da0	2025-10-03 01:38:30.312156
32	backward-compatible-index-on-objects	e0c37182b0f7aee3efd823298fb3c76f1042c0f7	2025-10-03 01:38:30.326902
33	backward-compatible-index-on-prefixes	b480e99ed951e0900f033ec4eb34b5bdcb4e3d49	2025-10-03 01:38:30.338063
34	optimize-search-function-v1	ca80a3dc7bfef894df17108785ce29a7fc8ee456	2025-10-03 01:38:30.341894
35	add-insert-trigger-prefixes	458fe0ffd07ec53f5e3ce9df51bfdf4861929ccc	2025-10-03 01:38:30.355834
36	optimise-existing-functions	6ae5fca6af5c55abe95369cd4f93985d1814ca8f	2025-10-03 01:38:30.367711
38	iceberg-catalog-flag-on-buckets	02716b81ceec9705aed84aa1501657095b32e5c5	2025-10-03 01:38:30.401726
39	add-search-v2-sort-support	6706c5f2928846abee18461279799ad12b279b78	2025-10-03 01:38:30.428881
40	fix-prefix-race-conditions-optimized	7ad69982ae2d372b21f48fc4829ae9752c518f6b	2025-10-03 01:38:30.442284
41	add-object-level-update-trigger	07fcf1a22165849b7a029deed059ffcde08d1ae0	2025-10-03 01:38:30.459794
42	rollback-prefix-triggers	771479077764adc09e2ea2043eb627503c034cd4	2025-10-03 01:38:30.473268
43	fix-object-level	84b35d6caca9d937478ad8a797491f38b8c2979f	2025-10-03 01:38:30.487479
48	iceberg-catalog-ids	e0e8b460c609b9999ccd0df9ad14294613eed939	2025-11-26 19:05:48.125791
50	search-v2-optimised	6323ac4f850aa14e7387eb32102869578b5bd478	2026-02-13 01:38:19.767088
51	index-backward-compatible-search	2ee395d433f76e38bcd3856debaf6e0e5b674011	2026-02-13 01:38:19.862029
52	drop-not-used-indexes-and-functions	5cc44c8696749ac11dd0dc37f2a3802075f3a171	2026-02-13 01:38:19.863944
53	drop-index-lower-name	d0cb18777d9e2a98ebe0bc5cc7a42e57ebe41854	2026-02-13 01:38:19.980634
54	drop-index-object-level	6289e048b1472da17c31a7eba1ded625a6457e67	2026-02-13 01:38:19.984041
55	prevent-direct-deletes	262a4798d5e0f2e7c8970232e03ce8be695d5819	2026-02-13 01:38:19.985925
56	fix-optimized-search-function	cb58526ebc23048049fd5bf2fd148d18b04a2073	2026-02-13 01:38:19.996094
\.


--
-- TOC entry 5120 (class 0 OID 16561)
-- Dependencies: 301
-- Data for Name: objects; Type: TABLE DATA; Schema: storage; Owner: -
--

COPY storage.objects (id, bucket_id, name, owner, created_at, updated_at, last_accessed_at, metadata, version, owner_id, user_metadata) FROM stdin;
\.


--
-- TOC entry 5134 (class 0 OID 17057)
-- Dependencies: 318
-- Data for Name: s3_multipart_uploads; Type: TABLE DATA; Schema: storage; Owner: -
--

COPY storage.s3_multipart_uploads (id, in_progress_size, upload_signature, bucket_id, key, version, owner_id, created_at, user_metadata) FROM stdin;
\.


--
-- TOC entry 5135 (class 0 OID 17071)
-- Dependencies: 319
-- Data for Name: s3_multipart_uploads_parts; Type: TABLE DATA; Schema: storage; Owner: -
--

COPY storage.s3_multipart_uploads_parts (id, upload_id, size, part_number, bucket_id, key, etag, owner_id, version, created_at) FROM stdin;
\.


--
-- TOC entry 5144 (class 0 OID 52059)
-- Dependencies: 332
-- Data for Name: vector_indexes; Type: TABLE DATA; Schema: storage; Owner: -
--

COPY storage.vector_indexes (id, name, bucket_id, data_type, dimension, distance_metric, metadata_configuration, created_at, updated_at) FROM stdin;
\.


--
-- TOC entry 5139 (class 0 OID 17293)
-- Dependencies: 327
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: supabase_migrations; Owner: -
--

COPY supabase_migrations.schema_migrations (version, statements, name, created_by, idempotency_key, rollback) FROM stdin;
20260207000000	{"-- Migration: Add KPI Tracking Tables\r\n-- Created: 2026-02-07\r\n-- Purpose: Add tables for portal traffic and ad performance tracking\r\n\r\n-- ============================================================================\r\n-- TABLE 1: page_views - Portal Traffic Tracking\r\n-- ============================================================================\r\nCREATE TABLE IF NOT EXISTS public.page_views (\r\n    id uuid DEFAULT gen_random_uuid() PRIMARY KEY,\r\n    site_id uuid NOT NULL REFERENCES public.sites(id) ON DELETE CASCADE,\r\n    page_path text NOT NULL,\r\n    referrer text,\r\n    user_agent text,\r\n    session_id uuid NOT NULL,\r\n    user_id uuid REFERENCES auth.users(id) ON DELETE SET NULL,\r\n    ip_hash text,\r\n    country_code text,\r\n    created_at timestamptz DEFAULT now() NOT NULL\r\n)","-- Indexes for performance\r\nCREATE INDEX IF NOT EXISTS idx_page_views_site_created \r\n    ON public.page_views(site_id, created_at DESC)","CREATE INDEX IF NOT EXISTS idx_page_views_session \r\n    ON public.page_views(session_id)","CREATE INDEX IF NOT EXISTS idx_page_views_created \r\n    ON public.page_views(created_at DESC)","-- Comments\r\nCOMMENT ON TABLE public.page_views IS 'Tracks page views for portal traffic analytics'","COMMENT ON COLUMN public.page_views.session_id IS 'Browser session identifier (generated client-side)'","COMMENT ON COLUMN public.page_views.ip_hash IS 'Hashed IP address for privacy compliance (LGPD)'","-- ============================================================================\r\n-- TABLE 2: ad_impressions - Ad Display Tracking\r\n-- ============================================================================\r\nCREATE TABLE IF NOT EXISTS public.ad_impressions (\r\n    id uuid DEFAULT gen_random_uuid() PRIMARY KEY,\r\n    site_id uuid NOT NULL REFERENCES public.sites(id) ON DELETE CASCADE,\r\n    campaign_id uuid NOT NULL REFERENCES public.ads_campaigns(id) ON DELETE CASCADE,\r\n    creative_id uuid NOT NULL REFERENCES public.ads_creatives(id) ON DELETE CASCADE,\r\n    slot_id uuid NOT NULL REFERENCES public.ads_slots(id) ON DELETE CASCADE,\r\n    session_id uuid NOT NULL,\r\n    page_path text NOT NULL,\r\n    viewport_visible boolean DEFAULT false NOT NULL,\r\n    created_at timestamptz DEFAULT now() NOT NULL\r\n)","-- Indexes for performance\r\nCREATE INDEX IF NOT EXISTS idx_ad_impressions_campaign \r\n    ON public.ad_impressions(campaign_id, created_at DESC)","CREATE INDEX IF NOT EXISTS idx_ad_impressions_site \r\n    ON public.ad_impressions(site_id, created_at DESC)","CREATE INDEX IF NOT EXISTS idx_ad_impressions_creative \r\n    ON public.ad_impressions(creative_id, created_at DESC)","CREATE INDEX IF NOT EXISTS idx_ad_impressions_session \r\n    ON public.ad_impressions(session_id)","-- Comments\r\nCOMMENT ON TABLE public.ad_impressions IS 'Tracks ad impressions for performance analytics'","COMMENT ON COLUMN public.ad_impressions.viewport_visible IS 'True if ad was visible in viewport (Intersection Observer)'","-- ============================================================================\r\n-- TABLE 3: ad_clicks - Ad Click Tracking\r\n-- ============================================================================\r\nCREATE TABLE IF NOT EXISTS public.ad_clicks (\r\n    id uuid DEFAULT gen_random_uuid() PRIMARY KEY,\r\n    impression_id uuid REFERENCES public.ad_impressions(id) ON DELETE SET NULL,\r\n    campaign_id uuid NOT NULL REFERENCES public.ads_campaigns(id) ON DELETE CASCADE,\r\n    creative_id uuid NOT NULL REFERENCES public.ads_creatives(id) ON DELETE CASCADE,\r\n    session_id uuid NOT NULL,\r\n    created_at timestamptz DEFAULT now() NOT NULL\r\n)","-- Indexes for performance\r\nCREATE INDEX IF NOT EXISTS idx_ad_clicks_campaign \r\n    ON public.ad_clicks(campaign_id, created_at DESC)","CREATE INDEX IF NOT EXISTS idx_ad_clicks_impression \r\n    ON public.ad_clicks(impression_id)","CREATE INDEX IF NOT EXISTS idx_ad_clicks_creative \r\n    ON public.ad_clicks(creative_id, created_at DESC)","-- Comments\r\nCOMMENT ON TABLE public.ad_clicks IS 'Tracks ad clicks for CTR calculation'","COMMENT ON COLUMN public.ad_clicks.impression_id IS 'Links click to specific impression (may be null if impression not tracked)'","-- ============================================================================\r\n-- VIEW 1: portal_kpis_summary - Portal Traffic Metrics\r\n-- ============================================================================\r\nCREATE OR REPLACE VIEW public.portal_kpis_summary AS\r\nSELECT \r\n    site_id,\r\n    COUNT(*) as total_views,\r\n    COUNT(DISTINCT session_id) as unique_visitors,\r\n    COUNT(DISTINCT DATE(created_at)) as days_active,\r\n    ROUND(COUNT(*)::numeric / NULLIF(COUNT(DISTINCT session_id), 0), 2) as pages_per_session,\r\n    MIN(created_at) as first_view,\r\n    MAX(created_at) as last_view\r\nFROM public.page_views\r\nWHERE created_at >= now() - interval '30 days'\r\nGROUP BY site_id","COMMENT ON VIEW public.portal_kpis_summary IS 'Aggregated portal traffic metrics for last 30 days'","-- ============================================================================\r\n-- VIEW 2: ad_campaign_performance - Ad Performance Metrics\r\n-- ============================================================================\r\nCREATE OR REPLACE VIEW public.ad_campaign_performance AS\r\nSELECT \r\n    c.id as campaign_id,\r\n    c.site_id,\r\n    c.advertiser_id,\r\n    c.slot_id,\r\n    c.status as campaign_status,\r\n    a.name as advertiser_name,\r\n    s.placement as slot_name,\r\n    s.key as slot_key,\r\n    COUNT(DISTINCT i.id) as impressions,\r\n    COUNT(DISTINCT CASE WHEN i.viewport_visible THEN i.id END) as visible_impressions,\r\n    COUNT(DISTINCT cl.id) as clicks,\r\n    ROUND(\r\n        (COUNT(DISTINCT cl.id)::numeric / NULLIF(COUNT(DISTINCT i.id), 0) * 100), \r\n        2\r\n    ) as ctr_percent,\r\n    COUNT(DISTINCT i.session_id) as unique_viewers,\r\n    c.price_cents,\r\n    c.currency,\r\n    c.starts_at,\r\n    c.ends_at\r\nFROM public.ads_campaigns c\r\nLEFT JOIN public.ads_advertisers a ON c.advertiser_id = a.id\r\nLEFT JOIN public.ads_slots s ON c.slot_id = s.id\r\nLEFT JOIN public.ad_impressions i ON c.id = i.campaign_id \r\n    AND i.created_at >= c.starts_at \r\n    AND i.created_at < c.ends_at\r\nLEFT JOIN public.ad_clicks cl ON c.id = cl.campaign_id \r\n    AND cl.created_at >= c.starts_at \r\n    AND cl.created_at < c.ends_at\r\nGROUP BY \r\n    c.id, c.site_id, c.advertiser_id, c.slot_id, c.status,\r\n    a.name, s.placement, s.key, c.price_cents, c.currency, \r\n    c.starts_at, c.ends_at","COMMENT ON VIEW public.ad_campaign_performance IS 'Aggregated ad campaign performance metrics with CTR calculation'","-- ============================================================================\r\n-- RLS Policies\r\n-- ============================================================================\r\n\r\n-- Enable RLS\r\nALTER TABLE public.page_views ENABLE ROW LEVEL SECURITY","ALTER TABLE public.ad_impressions ENABLE ROW LEVEL SECURITY","ALTER TABLE public.ad_clicks ENABLE ROW LEVEL SECURITY","-- page_views policies\r\nCREATE POLICY \\"Allow insert for authenticated users\\" \r\n    ON public.page_views FOR INSERT \r\n    TO authenticated \r\n    WITH CHECK (true)","CREATE POLICY \\"Allow insert for anon users\\" \r\n    ON public.page_views FOR INSERT \r\n    TO anon \r\n    WITH CHECK (true)","CREATE POLICY \\"Allow select for site members\\" \r\n    ON public.page_views FOR SELECT \r\n    TO authenticated \r\n    USING (\r\n        EXISTS (\r\n            SELECT 1 FROM public.site_members \r\n            WHERE site_members.site_id = page_views.site_id \r\n            AND site_members.user_id = auth.uid()\r\n        )\r\n    )","-- ad_impressions policies\r\nCREATE POLICY \\"Allow insert for authenticated users\\" \r\n    ON public.ad_impressions FOR INSERT \r\n    TO authenticated \r\n    WITH CHECK (true)","CREATE POLICY \\"Allow insert for anon users\\" \r\n    ON public.ad_impressions FOR INSERT \r\n    TO anon \r\n    WITH CHECK (true)","CREATE POLICY \\"Allow select for site members\\" \r\n    ON public.ad_impressions FOR SELECT \r\n    TO authenticated \r\n    USING (\r\n        EXISTS (\r\n            SELECT 1 FROM public.site_members \r\n            WHERE site_members.site_id = ad_impressions.site_id \r\n            AND site_members.user_id = auth.uid()\r\n        )\r\n    )","-- ad_clicks policies\r\nCREATE POLICY \\"Allow insert for authenticated users\\" \r\n    ON public.ad_clicks FOR INSERT \r\n    TO authenticated \r\n    WITH CHECK (true)","CREATE POLICY \\"Allow insert for anon users\\" \r\n    ON public.ad_clicks FOR INSERT \r\n    TO anon \r\n    WITH CHECK (true)","CREATE POLICY \\"Allow select for site members\\" \r\n    ON public.ad_clicks FOR SELECT \r\n    TO authenticated \r\n    USING (\r\n        EXISTS (\r\n            SELECT 1 FROM public.ads_campaigns \r\n            JOIN public.site_members ON site_members.site_id = ads_campaigns.site_id\r\n            WHERE ads_campaigns.id = ad_clicks.campaign_id \r\n            AND site_members.user_id = auth.uid()\r\n        )\r\n    )"}	add_kpi_tracking_tables	\N	\N	\N
\.


--
-- TOC entry 5145 (class 0 OID 61240)
-- Dependencies: 333
-- Data for Name: seed_files; Type: TABLE DATA; Schema: supabase_migrations; Owner: -
--

COPY supabase_migrations.seed_files (path, hash) FROM stdin;
\.


--
-- TOC entry 4089 (class 0 OID 16658)
-- Dependencies: 303
-- Data for Name: secrets; Type: TABLE DATA; Schema: vault; Owner: -
--

COPY vault.secrets (id, name, description, secret, key_id, nonce, created_at, updated_at) FROM stdin;
\.


--
-- TOC entry 5254 (class 0 OID 0)
-- Dependencies: 295
-- Name: refresh_tokens_id_seq; Type: SEQUENCE SET; Schema: auth; Owner: -
--

SELECT pg_catalog.setval('auth.refresh_tokens_id_seq', 169, true);


--
-- TOC entry 5255 (class 0 OID 0)
-- Dependencies: 350
-- Name: audit_logs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.audit_logs_id_seq', 1, false);


--
-- TOC entry 5256 (class 0 OID 0)
-- Dependencies: 322
-- Name: subscription_id_seq; Type: SEQUENCE SET; Schema: realtime; Owner: -
--

SELECT pg_catalog.setval('realtime.subscription_id_seq', 1, false);


--
-- TOC entry 4423 (class 2606 OID 16827)
-- Name: mfa_amr_claims amr_id_pk; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.mfa_amr_claims
    ADD CONSTRAINT amr_id_pk PRIMARY KEY (id);


--
-- TOC entry 4379 (class 2606 OID 16531)
-- Name: audit_log_entries audit_log_entries_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.audit_log_entries
    ADD CONSTRAINT audit_log_entries_pkey PRIMARY KEY (id);


--
-- TOC entry 4446 (class 2606 OID 16933)
-- Name: flow_state flow_state_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.flow_state
    ADD CONSTRAINT flow_state_pkey PRIMARY KEY (id);


--
-- TOC entry 4401 (class 2606 OID 16951)
-- Name: identities identities_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.identities
    ADD CONSTRAINT identities_pkey PRIMARY KEY (id);


--
-- TOC entry 4403 (class 2606 OID 16961)
-- Name: identities identities_provider_id_provider_unique; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.identities
    ADD CONSTRAINT identities_provider_id_provider_unique UNIQUE (provider_id, provider);


--
-- TOC entry 4377 (class 2606 OID 16524)
-- Name: instances instances_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.instances
    ADD CONSTRAINT instances_pkey PRIMARY KEY (id);


--
-- TOC entry 4425 (class 2606 OID 16820)
-- Name: mfa_amr_claims mfa_amr_claims_session_id_authentication_method_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.mfa_amr_claims
    ADD CONSTRAINT mfa_amr_claims_session_id_authentication_method_pkey UNIQUE (session_id, authentication_method);


--
-- TOC entry 4421 (class 2606 OID 16808)
-- Name: mfa_challenges mfa_challenges_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.mfa_challenges
    ADD CONSTRAINT mfa_challenges_pkey PRIMARY KEY (id);


--
-- TOC entry 4413 (class 2606 OID 17001)
-- Name: mfa_factors mfa_factors_last_challenged_at_key; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.mfa_factors
    ADD CONSTRAINT mfa_factors_last_challenged_at_key UNIQUE (last_challenged_at);


--
-- TOC entry 4415 (class 2606 OID 16795)
-- Name: mfa_factors mfa_factors_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.mfa_factors
    ADD CONSTRAINT mfa_factors_pkey PRIMARY KEY (id);


--
-- TOC entry 4480 (class 2606 OID 32650)
-- Name: oauth_authorizations oauth_authorizations_authorization_code_key; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.oauth_authorizations
    ADD CONSTRAINT oauth_authorizations_authorization_code_key UNIQUE (authorization_code);


--
-- TOC entry 4482 (class 2606 OID 32648)
-- Name: oauth_authorizations oauth_authorizations_authorization_id_key; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.oauth_authorizations
    ADD CONSTRAINT oauth_authorizations_authorization_id_key UNIQUE (authorization_id);


--
-- TOC entry 4484 (class 2606 OID 32646)
-- Name: oauth_authorizations oauth_authorizations_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.oauth_authorizations
    ADD CONSTRAINT oauth_authorizations_pkey PRIMARY KEY (id);


--
-- TOC entry 4501 (class 2606 OID 66774)
-- Name: oauth_client_states oauth_client_states_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.oauth_client_states
    ADD CONSTRAINT oauth_client_states_pkey PRIMARY KEY (id);


--
-- TOC entry 4456 (class 2606 OID 17020)
-- Name: oauth_clients oauth_clients_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.oauth_clients
    ADD CONSTRAINT oauth_clients_pkey PRIMARY KEY (id);


--
-- TOC entry 4488 (class 2606 OID 32672)
-- Name: oauth_consents oauth_consents_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.oauth_consents
    ADD CONSTRAINT oauth_consents_pkey PRIMARY KEY (id);


--
-- TOC entry 4490 (class 2606 OID 32674)
-- Name: oauth_consents oauth_consents_user_client_unique; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.oauth_consents
    ADD CONSTRAINT oauth_consents_user_client_unique UNIQUE (user_id, client_id);


--
-- TOC entry 4450 (class 2606 OID 16986)
-- Name: one_time_tokens one_time_tokens_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.one_time_tokens
    ADD CONSTRAINT one_time_tokens_pkey PRIMARY KEY (id);


--
-- TOC entry 4371 (class 2606 OID 16514)
-- Name: refresh_tokens refresh_tokens_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.refresh_tokens
    ADD CONSTRAINT refresh_tokens_pkey PRIMARY KEY (id);


--
-- TOC entry 4374 (class 2606 OID 16738)
-- Name: refresh_tokens refresh_tokens_token_unique; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.refresh_tokens
    ADD CONSTRAINT refresh_tokens_token_unique UNIQUE (token);


--
-- TOC entry 4435 (class 2606 OID 16867)
-- Name: saml_providers saml_providers_entity_id_key; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.saml_providers
    ADD CONSTRAINT saml_providers_entity_id_key UNIQUE (entity_id);


--
-- TOC entry 4437 (class 2606 OID 16865)
-- Name: saml_providers saml_providers_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.saml_providers
    ADD CONSTRAINT saml_providers_pkey PRIMARY KEY (id);


--
-- TOC entry 4442 (class 2606 OID 16881)
-- Name: saml_relay_states saml_relay_states_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.saml_relay_states
    ADD CONSTRAINT saml_relay_states_pkey PRIMARY KEY (id);


--
-- TOC entry 4382 (class 2606 OID 16537)
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- TOC entry 4408 (class 2606 OID 16759)
-- Name: sessions sessions_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.sessions
    ADD CONSTRAINT sessions_pkey PRIMARY KEY (id);


--
-- TOC entry 4432 (class 2606 OID 16848)
-- Name: sso_domains sso_domains_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.sso_domains
    ADD CONSTRAINT sso_domains_pkey PRIMARY KEY (id);


--
-- TOC entry 4427 (class 2606 OID 16839)
-- Name: sso_providers sso_providers_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.sso_providers
    ADD CONSTRAINT sso_providers_pkey PRIMARY KEY (id);


--
-- TOC entry 4364 (class 2606 OID 16921)
-- Name: users users_phone_key; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.users
    ADD CONSTRAINT users_phone_key UNIQUE (phone);


--
-- TOC entry 4366 (class 2606 OID 16501)
-- Name: users users_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- TOC entry 4679 (class 2606 OID 116086)
-- Name: ad_clicks ad_clicks_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ad_clicks
    ADD CONSTRAINT ad_clicks_pkey PRIMARY KEY (id);


--
-- TOC entry 4673 (class 2606 OID 116055)
-- Name: ad_impressions ad_impressions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ad_impressions
    ADD CONSTRAINT ad_impressions_pkey PRIMARY KEY (id);


--
-- TOC entry 4614 (class 2606 OID 109132)
-- Name: ads_advertisers ads_advertisers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ads_advertisers
    ADD CONSTRAINT ads_advertisers_pkey PRIMARY KEY (id);


--
-- TOC entry 4616 (class 2606 OID 109134)
-- Name: ads_advertisers ads_advertisers_site_name_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ads_advertisers
    ADD CONSTRAINT ads_advertisers_site_name_uniq UNIQUE (site_id, name);


--
-- TOC entry 4626 (class 2606 OID 109871)
-- Name: ads_campaigns ads_campaigns_no_overlap_excl; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ads_campaigns
    ADD CONSTRAINT ads_campaigns_no_overlap_excl EXCLUDE USING gist (site_id WITH =, slot_id WITH =, tstzrange(starts_at, ends_at, '[)'::text) WITH &&) WHERE ((status = 'active'::public.ads_campaign_status));


--
-- TOC entry 5257 (class 0 OID 0)
-- Dependencies: 4626
-- Name: CONSTRAINT ads_campaigns_no_overlap_excl ON ads_campaigns; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON CONSTRAINT ads_campaigns_no_overlap_excl ON public.ads_campaigns IS 'Ensures exclusive slot booking: prevents multiple active campaigns from overlapping on the same slot within the same site';


--
-- TOC entry 4628 (class 2606 OID 109173)
-- Name: ads_campaigns ads_campaigns_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ads_campaigns
    ADD CONSTRAINT ads_campaigns_pkey PRIMARY KEY (id);


--
-- TOC entry 4635 (class 2606 OID 109200)
-- Name: ads_creatives ads_creatives_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ads_creatives
    ADD CONSTRAINT ads_creatives_pkey PRIMARY KEY (id);


--
-- TOC entry 4620 (class 2606 OID 109151)
-- Name: ads_slots ads_slots_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ads_slots
    ADD CONSTRAINT ads_slots_pkey PRIMARY KEY (id);


--
-- TOC entry 4622 (class 2606 OID 109153)
-- Name: ads_slots ads_slots_site_key_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ads_slots
    ADD CONSTRAINT ads_slots_site_key_uniq UNIQUE (site_id, key);


--
-- TOC entry 4590 (class 2606 OID 106744)
-- Name: api_keys api_keys_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.api_keys
    ADD CONSTRAINT api_keys_pkey PRIMARY KEY (id);


--
-- TOC entry 4592 (class 2606 OID 106874)
-- Name: api_keys api_keys_site_name_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.api_keys
    ADD CONSTRAINT api_keys_site_name_uniq UNIQUE (site_id, name);


--
-- TOC entry 4585 (class 2606 OID 106719)
-- Name: audit_logs audit_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.audit_logs
    ADD CONSTRAINT audit_logs_pkey PRIMARY KEY (id);


--
-- TOC entry 4651 (class 2606 OID 112477)
-- Name: event_categories event_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.event_categories
    ADD CONSTRAINT event_categories_pkey PRIMARY KEY (id);


--
-- TOC entry 4552 (class 2606 OID 106545)
-- Name: events events_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.events
    ADD CONSTRAINT events_pkey PRIMARY KEY (id);


--
-- TOC entry 4554 (class 2606 OID 106547)
-- Name: events events_site_id_slug_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.events
    ADD CONSTRAINT events_site_id_slug_key UNIQUE (site_id, slug);


--
-- TOC entry 4658 (class 2606 OID 114755)
-- Name: hero_banners hero_banners_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.hero_banners
    ADD CONSTRAINT hero_banners_pkey PRIMARY KEY (id);


--
-- TOC entry 4663 (class 2606 OID 115939)
-- Name: import_batches import_batches_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.import_batches
    ADD CONSTRAINT import_batches_pkey PRIMARY KEY (id);


--
-- TOC entry 4545 (class 2606 OID 106448)
-- Name: media media_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.media
    ADD CONSTRAINT media_pkey PRIMARY KEY (id);


--
-- TOC entry 4671 (class 2606 OID 116032)
-- Name: page_views page_views_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.page_views
    ADD CONSTRAINT page_views_pkey PRIMARY KEY (id);


--
-- TOC entry 4514 (class 2606 OID 106307)
-- Name: place_categories place_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.place_categories
    ADD CONSTRAINT place_categories_pkey PRIMARY KEY (id);


--
-- TOC entry 4516 (class 2606 OID 106309)
-- Name: place_categories place_categories_site_id_kind_slug_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.place_categories
    ADD CONSTRAINT place_categories_site_id_kind_slug_key UNIQUE (site_id, kind, slug);


--
-- TOC entry 4666 (class 2606 OID 116002)
-- Name: place_images place_images_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.place_images
    ADD CONSTRAINT place_images_pkey PRIMARY KEY (id);


--
-- TOC entry 4533 (class 2606 OID 106349)
-- Name: place_media place_media_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.place_media
    ADD CONSTRAINT place_media_pkey PRIMARY KEY (id);


--
-- TOC entry 4529 (class 2606 OID 106326)
-- Name: places places_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.places
    ADD CONSTRAINT places_pkey PRIMARY KEY (id);


--
-- TOC entry 4531 (class 2606 OID 106328)
-- Name: places places_site_id_kind_slug_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.places
    ADD CONSTRAINT places_site_id_kind_slug_key UNIQUE (site_id, kind, slug);


--
-- TOC entry 4642 (class 2606 OID 109933)
-- Name: platform_roles platform_roles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.platform_roles
    ADD CONSTRAINT platform_roles_pkey PRIMARY KEY (user_id);


--
-- TOC entry 4561 (class 2606 OID 106573)
-- Name: post_categories post_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.post_categories
    ADD CONSTRAINT post_categories_pkey PRIMARY KEY (id);


--
-- TOC entry 4563 (class 2606 OID 106575)
-- Name: post_categories post_categories_site_id_slug_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.post_categories
    ADD CONSTRAINT post_categories_site_id_slug_key UNIQUE (site_id, slug);


--
-- TOC entry 4570 (class 2606 OID 106610)
-- Name: post_tag_links post_tag_links_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.post_tag_links
    ADD CONSTRAINT post_tag_links_pkey PRIMARY KEY (post_id, tag_id);


--
-- TOC entry 4565 (class 2606 OID 106595)
-- Name: post_tags post_tags_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.post_tags
    ADD CONSTRAINT post_tags_pkey PRIMARY KEY (id);


--
-- TOC entry 4567 (class 2606 OID 106597)
-- Name: post_tags post_tags_site_id_slug_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.post_tags
    ADD CONSTRAINT post_tags_site_id_slug_key UNIQUE (site_id, slug);


--
-- TOC entry 4539 (class 2606 OID 106366)
-- Name: posts posts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.posts
    ADD CONSTRAINT posts_pkey PRIMARY KEY (id);


--
-- TOC entry 4541 (class 2606 OID 106368)
-- Name: posts posts_site_id_slug_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.posts
    ADD CONSTRAINT posts_site_id_slug_key UNIQUE (site_id, slug);


--
-- TOC entry 4507 (class 2606 OID 106273)
-- Name: profiles profiles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.profiles
    ADD CONSTRAINT profiles_pkey PRIMARY KEY (user_id);


--
-- TOC entry 4548 (class 2606 OID 106481)
-- Name: site_content site_content_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.site_content
    ADD CONSTRAINT site_content_pkey PRIMARY KEY (id);


--
-- TOC entry 4550 (class 2606 OID 106483)
-- Name: site_content site_content_site_id_slot_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.site_content
    ADD CONSTRAINT site_content_site_id_slot_key UNIQUE (site_id, slot);


--
-- TOC entry 4509 (class 2606 OID 106285)
-- Name: site_members site_members_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.site_members
    ADD CONSTRAINT site_members_pkey PRIMARY KEY (site_id, user_id);


--
-- TOC entry 4647 (class 2606 OID 111323)
-- Name: site_metrics site_metrics_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.site_metrics
    ADD CONSTRAINT site_metrics_pkey PRIMARY KEY (id);


--
-- TOC entry 4649 (class 2606 OID 111325)
-- Name: site_metrics site_metrics_site_id_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.site_metrics
    ADD CONSTRAINT site_metrics_site_id_unique UNIQUE (site_id);


--
-- TOC entry 4503 (class 2606 OID 106263)
-- Name: sites sites_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sites
    ADD CONSTRAINT sites_pkey PRIMARY KEY (id);


--
-- TOC entry 4505 (class 2606 OID 106265)
-- Name: sites sites_slug_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sites
    ADD CONSTRAINT sites_slug_key UNIQUE (slug);


--
-- TOC entry 4580 (class 2606 OID 106696)
-- Name: user_invitation_sites user_invitation_sites_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_invitation_sites
    ADD CONSTRAINT user_invitation_sites_pkey PRIMARY KEY (invitation_id, site_id);


--
-- TOC entry 4575 (class 2606 OID 106683)
-- Name: user_invitations user_invitations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_invitations
    ADD CONSTRAINT user_invitations_pkey PRIMARY KEY (id);


--
-- TOC entry 4577 (class 2606 OID 106867)
-- Name: user_invitations user_invitations_token_hash_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_invitations
    ADD CONSTRAINT user_invitations_token_hash_uniq UNIQUE (token_hash);


--
-- TOC entry 4609 (class 2606 OID 106886)
-- Name: webhook_deliveries webhook_deliveries_idem_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.webhook_deliveries
    ADD CONSTRAINT webhook_deliveries_idem_uniq UNIQUE (webhook_id, idempotency_key);


--
-- TOC entry 4611 (class 2606 OID 106791)
-- Name: webhook_deliveries webhook_deliveries_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.webhook_deliveries
    ADD CONSTRAINT webhook_deliveries_pkey PRIMARY KEY (id);


--
-- TOC entry 4601 (class 2606 OID 106769)
-- Name: webhooks webhooks_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.webhooks
    ADD CONSTRAINT webhooks_pkey PRIMARY KEY (id);


--
-- TOC entry 4603 (class 2606 OID 106881)
-- Name: webhooks webhooks_site_name_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.webhooks
    ADD CONSTRAINT webhooks_site_name_uniq UNIQUE (site_id, name);


--
-- TOC entry 4470 (class 2606 OID 17289)
-- Name: messages messages_pkey; Type: CONSTRAINT; Schema: realtime; Owner: -
--

ALTER TABLE ONLY realtime.messages
    ADD CONSTRAINT messages_pkey PRIMARY KEY (id, inserted_at);


--
-- TOC entry 4466 (class 2606 OID 17139)
-- Name: subscription pk_subscription; Type: CONSTRAINT; Schema: realtime; Owner: -
--

ALTER TABLE ONLY realtime.subscription
    ADD CONSTRAINT pk_subscription PRIMARY KEY (id);


--
-- TOC entry 4463 (class 2606 OID 17113)
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: realtime; Owner: -
--

ALTER TABLE ONLY realtime.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- TOC entry 4476 (class 2606 OID 52082)
-- Name: buckets_analytics buckets_analytics_pkey; Type: CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.buckets_analytics
    ADD CONSTRAINT buckets_analytics_pkey PRIMARY KEY (id);


--
-- TOC entry 4385 (class 2606 OID 16554)
-- Name: buckets buckets_pkey; Type: CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.buckets
    ADD CONSTRAINT buckets_pkey PRIMARY KEY (id);


--
-- TOC entry 4493 (class 2606 OID 52058)
-- Name: buckets_vectors buckets_vectors_pkey; Type: CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.buckets_vectors
    ADD CONSTRAINT buckets_vectors_pkey PRIMARY KEY (id);


--
-- TOC entry 4393 (class 2606 OID 16595)
-- Name: migrations migrations_name_key; Type: CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.migrations
    ADD CONSTRAINT migrations_name_key UNIQUE (name);


--
-- TOC entry 4395 (class 2606 OID 16593)
-- Name: migrations migrations_pkey; Type: CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.migrations
    ADD CONSTRAINT migrations_pkey PRIMARY KEY (id);


--
-- TOC entry 4391 (class 2606 OID 16571)
-- Name: objects objects_pkey; Type: CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.objects
    ADD CONSTRAINT objects_pkey PRIMARY KEY (id);


--
-- TOC entry 4461 (class 2606 OID 17080)
-- Name: s3_multipart_uploads_parts s3_multipart_uploads_parts_pkey; Type: CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.s3_multipart_uploads_parts
    ADD CONSTRAINT s3_multipart_uploads_parts_pkey PRIMARY KEY (id);


--
-- TOC entry 4459 (class 2606 OID 17065)
-- Name: s3_multipart_uploads s3_multipart_uploads_pkey; Type: CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.s3_multipart_uploads
    ADD CONSTRAINT s3_multipart_uploads_pkey PRIMARY KEY (id);


--
-- TOC entry 4496 (class 2606 OID 52068)
-- Name: vector_indexes vector_indexes_pkey; Type: CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.vector_indexes
    ADD CONSTRAINT vector_indexes_pkey PRIMARY KEY (id);


--
-- TOC entry 4472 (class 2606 OID 17301)
-- Name: schema_migrations schema_migrations_idempotency_key_key; Type: CONSTRAINT; Schema: supabase_migrations; Owner: -
--

ALTER TABLE ONLY supabase_migrations.schema_migrations
    ADD CONSTRAINT schema_migrations_idempotency_key_key UNIQUE (idempotency_key);


--
-- TOC entry 4474 (class 2606 OID 17299)
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: supabase_migrations; Owner: -
--

ALTER TABLE ONLY supabase_migrations.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- TOC entry 4498 (class 2606 OID 61246)
-- Name: seed_files seed_files_pkey; Type: CONSTRAINT; Schema: supabase_migrations; Owner: -
--

ALTER TABLE ONLY supabase_migrations.seed_files
    ADD CONSTRAINT seed_files_pkey PRIMARY KEY (path);


--
-- TOC entry 4380 (class 1259 OID 16532)
-- Name: audit_logs_instance_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX audit_logs_instance_id_idx ON auth.audit_log_entries USING btree (instance_id);


--
-- TOC entry 4354 (class 1259 OID 16748)
-- Name: confirmation_token_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX confirmation_token_idx ON auth.users USING btree (confirmation_token) WHERE ((confirmation_token)::text !~ '^[0-9 ]*$'::text);


--
-- TOC entry 4355 (class 1259 OID 16750)
-- Name: email_change_token_current_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX email_change_token_current_idx ON auth.users USING btree (email_change_token_current) WHERE ((email_change_token_current)::text !~ '^[0-9 ]*$'::text);


--
-- TOC entry 4356 (class 1259 OID 16751)
-- Name: email_change_token_new_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX email_change_token_new_idx ON auth.users USING btree (email_change_token_new) WHERE ((email_change_token_new)::text !~ '^[0-9 ]*$'::text);


--
-- TOC entry 4411 (class 1259 OID 16829)
-- Name: factor_id_created_at_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX factor_id_created_at_idx ON auth.mfa_factors USING btree (user_id, created_at);


--
-- TOC entry 4444 (class 1259 OID 16937)
-- Name: flow_state_created_at_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX flow_state_created_at_idx ON auth.flow_state USING btree (created_at DESC);


--
-- TOC entry 4399 (class 1259 OID 16917)
-- Name: identities_email_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX identities_email_idx ON auth.identities USING btree (email text_pattern_ops);


--
-- TOC entry 5258 (class 0 OID 0)
-- Dependencies: 4399
-- Name: INDEX identities_email_idx; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON INDEX auth.identities_email_idx IS 'Auth: Ensures indexed queries on the email column';


--
-- TOC entry 4404 (class 1259 OID 16745)
-- Name: identities_user_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX identities_user_id_idx ON auth.identities USING btree (user_id);


--
-- TOC entry 4447 (class 1259 OID 16934)
-- Name: idx_auth_code; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX idx_auth_code ON auth.flow_state USING btree (auth_code);


--
-- TOC entry 4499 (class 1259 OID 66775)
-- Name: idx_oauth_client_states_created_at; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX idx_oauth_client_states_created_at ON auth.oauth_client_states USING btree (created_at);


--
-- TOC entry 4448 (class 1259 OID 16935)
-- Name: idx_user_id_auth_method; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX idx_user_id_auth_method ON auth.flow_state USING btree (user_id, authentication_method);


--
-- TOC entry 4419 (class 1259 OID 16940)
-- Name: mfa_challenge_created_at_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX mfa_challenge_created_at_idx ON auth.mfa_challenges USING btree (created_at DESC);


--
-- TOC entry 4416 (class 1259 OID 16801)
-- Name: mfa_factors_user_friendly_name_unique; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX mfa_factors_user_friendly_name_unique ON auth.mfa_factors USING btree (friendly_name, user_id) WHERE (TRIM(BOTH FROM friendly_name) <> ''::text);


--
-- TOC entry 4417 (class 1259 OID 16946)
-- Name: mfa_factors_user_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX mfa_factors_user_id_idx ON auth.mfa_factors USING btree (user_id);


--
-- TOC entry 4478 (class 1259 OID 32661)
-- Name: oauth_auth_pending_exp_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX oauth_auth_pending_exp_idx ON auth.oauth_authorizations USING btree (expires_at) WHERE (status = 'pending'::auth.oauth_authorization_status);


--
-- TOC entry 4454 (class 1259 OID 17024)
-- Name: oauth_clients_deleted_at_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX oauth_clients_deleted_at_idx ON auth.oauth_clients USING btree (deleted_at);


--
-- TOC entry 4485 (class 1259 OID 32687)
-- Name: oauth_consents_active_client_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX oauth_consents_active_client_idx ON auth.oauth_consents USING btree (client_id) WHERE (revoked_at IS NULL);


--
-- TOC entry 4486 (class 1259 OID 32685)
-- Name: oauth_consents_active_user_client_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX oauth_consents_active_user_client_idx ON auth.oauth_consents USING btree (user_id, client_id) WHERE (revoked_at IS NULL);


--
-- TOC entry 4491 (class 1259 OID 32686)
-- Name: oauth_consents_user_order_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX oauth_consents_user_order_idx ON auth.oauth_consents USING btree (user_id, granted_at DESC);


--
-- TOC entry 4451 (class 1259 OID 16993)
-- Name: one_time_tokens_relates_to_hash_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX one_time_tokens_relates_to_hash_idx ON auth.one_time_tokens USING hash (relates_to);


--
-- TOC entry 4452 (class 1259 OID 16992)
-- Name: one_time_tokens_token_hash_hash_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX one_time_tokens_token_hash_hash_idx ON auth.one_time_tokens USING hash (token_hash);


--
-- TOC entry 4453 (class 1259 OID 16994)
-- Name: one_time_tokens_user_id_token_type_key; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX one_time_tokens_user_id_token_type_key ON auth.one_time_tokens USING btree (user_id, token_type);


--
-- TOC entry 4357 (class 1259 OID 16752)
-- Name: reauthentication_token_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX reauthentication_token_idx ON auth.users USING btree (reauthentication_token) WHERE ((reauthentication_token)::text !~ '^[0-9 ]*$'::text);


--
-- TOC entry 4358 (class 1259 OID 16749)
-- Name: recovery_token_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX recovery_token_idx ON auth.users USING btree (recovery_token) WHERE ((recovery_token)::text !~ '^[0-9 ]*$'::text);


--
-- TOC entry 4367 (class 1259 OID 16515)
-- Name: refresh_tokens_instance_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX refresh_tokens_instance_id_idx ON auth.refresh_tokens USING btree (instance_id);


--
-- TOC entry 4368 (class 1259 OID 16516)
-- Name: refresh_tokens_instance_id_user_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX refresh_tokens_instance_id_user_id_idx ON auth.refresh_tokens USING btree (instance_id, user_id);


--
-- TOC entry 4369 (class 1259 OID 16744)
-- Name: refresh_tokens_parent_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX refresh_tokens_parent_idx ON auth.refresh_tokens USING btree (parent);


--
-- TOC entry 4372 (class 1259 OID 16831)
-- Name: refresh_tokens_session_id_revoked_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX refresh_tokens_session_id_revoked_idx ON auth.refresh_tokens USING btree (session_id, revoked);


--
-- TOC entry 4375 (class 1259 OID 16936)
-- Name: refresh_tokens_updated_at_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX refresh_tokens_updated_at_idx ON auth.refresh_tokens USING btree (updated_at DESC);


--
-- TOC entry 4438 (class 1259 OID 16873)
-- Name: saml_providers_sso_provider_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX saml_providers_sso_provider_id_idx ON auth.saml_providers USING btree (sso_provider_id);


--
-- TOC entry 4439 (class 1259 OID 16938)
-- Name: saml_relay_states_created_at_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX saml_relay_states_created_at_idx ON auth.saml_relay_states USING btree (created_at DESC);


--
-- TOC entry 4440 (class 1259 OID 16888)
-- Name: saml_relay_states_for_email_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX saml_relay_states_for_email_idx ON auth.saml_relay_states USING btree (for_email);


--
-- TOC entry 4443 (class 1259 OID 16887)
-- Name: saml_relay_states_sso_provider_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX saml_relay_states_sso_provider_id_idx ON auth.saml_relay_states USING btree (sso_provider_id);


--
-- TOC entry 4405 (class 1259 OID 16939)
-- Name: sessions_not_after_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX sessions_not_after_idx ON auth.sessions USING btree (not_after DESC);


--
-- TOC entry 4406 (class 1259 OID 32699)
-- Name: sessions_oauth_client_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX sessions_oauth_client_id_idx ON auth.sessions USING btree (oauth_client_id);


--
-- TOC entry 4409 (class 1259 OID 16830)
-- Name: sessions_user_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX sessions_user_id_idx ON auth.sessions USING btree (user_id);


--
-- TOC entry 4430 (class 1259 OID 16855)
-- Name: sso_domains_domain_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX sso_domains_domain_idx ON auth.sso_domains USING btree (lower(domain));


--
-- TOC entry 4433 (class 1259 OID 16854)
-- Name: sso_domains_sso_provider_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX sso_domains_sso_provider_id_idx ON auth.sso_domains USING btree (sso_provider_id);


--
-- TOC entry 4428 (class 1259 OID 16840)
-- Name: sso_providers_resource_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX sso_providers_resource_id_idx ON auth.sso_providers USING btree (lower(resource_id));


--
-- TOC entry 4429 (class 1259 OID 17002)
-- Name: sso_providers_resource_id_pattern_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX sso_providers_resource_id_pattern_idx ON auth.sso_providers USING btree (resource_id text_pattern_ops);


--
-- TOC entry 4418 (class 1259 OID 16999)
-- Name: unique_phone_factor_per_user; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX unique_phone_factor_per_user ON auth.mfa_factors USING btree (user_id, phone);


--
-- TOC entry 4410 (class 1259 OID 16828)
-- Name: user_id_created_at_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX user_id_created_at_idx ON auth.sessions USING btree (user_id, created_at);


--
-- TOC entry 4359 (class 1259 OID 16908)
-- Name: users_email_partial_key; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX users_email_partial_key ON auth.users USING btree (email) WHERE (is_sso_user = false);


--
-- TOC entry 5259 (class 0 OID 0)
-- Dependencies: 4359
-- Name: INDEX users_email_partial_key; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON INDEX auth.users_email_partial_key IS 'Auth: A partial unique index that applies only when is_sso_user is false';


--
-- TOC entry 4360 (class 1259 OID 16746)
-- Name: users_instance_id_email_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX users_instance_id_email_idx ON auth.users USING btree (instance_id, lower((email)::text));


--
-- TOC entry 4361 (class 1259 OID 16505)
-- Name: users_instance_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX users_instance_id_idx ON auth.users USING btree (instance_id);


--
-- TOC entry 4362 (class 1259 OID 16963)
-- Name: users_is_anonymous_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX users_is_anonymous_idx ON auth.users USING btree (is_anonymous);


--
-- TOC entry 4588 (class 1259 OID 106756)
-- Name: api_keys_active_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX api_keys_active_idx ON public.api_keys USING btree (is_active);


--
-- TOC entry 4581 (class 1259 OID 106732)
-- Name: audit_logs_actor_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX audit_logs_actor_idx ON public.audit_logs USING btree (actor_user_id);


--
-- TOC entry 4582 (class 1259 OID 106733)
-- Name: audit_logs_category_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX audit_logs_category_idx ON public.audit_logs USING btree (category);


--
-- TOC entry 4583 (class 1259 OID 106730)
-- Name: audit_logs_occurred_at_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX audit_logs_occurred_at_idx ON public.audit_logs USING btree (occurred_at DESC);


--
-- TOC entry 4586 (class 1259 OID 106731)
-- Name: audit_logs_site_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX audit_logs_site_idx ON public.audit_logs USING btree (site_id);


--
-- TOC entry 4655 (class 1259 OID 114767)
-- Name: hero_banners_active_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX hero_banners_active_idx ON public.hero_banners USING btree (is_active);


--
-- TOC entry 4656 (class 1259 OID 114768)
-- Name: hero_banners_kind_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX hero_banners_kind_idx ON public.hero_banners USING btree (kind);


--
-- TOC entry 4659 (class 1259 OID 114766)
-- Name: hero_banners_site_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX hero_banners_site_id_idx ON public.hero_banners USING btree (site_id);


--
-- TOC entry 4660 (class 1259 OID 114769)
-- Name: hero_banners_sort_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX hero_banners_sort_idx ON public.hero_banners USING btree (sort_order);


--
-- TOC entry 4680 (class 1259 OID 116102)
-- Name: idx_ad_clicks_campaign; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_ad_clicks_campaign ON public.ad_clicks USING btree (campaign_id, created_at DESC);


--
-- TOC entry 4681 (class 1259 OID 116104)
-- Name: idx_ad_clicks_creative; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_ad_clicks_creative ON public.ad_clicks USING btree (creative_id, created_at DESC);


--
-- TOC entry 4682 (class 1259 OID 116103)
-- Name: idx_ad_clicks_impression; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_ad_clicks_impression ON public.ad_clicks USING btree (impression_id);


--
-- TOC entry 4674 (class 1259 OID 116076)
-- Name: idx_ad_impressions_campaign; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_ad_impressions_campaign ON public.ad_impressions USING btree (campaign_id, created_at DESC);


--
-- TOC entry 4675 (class 1259 OID 116078)
-- Name: idx_ad_impressions_creative; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_ad_impressions_creative ON public.ad_impressions USING btree (creative_id, created_at DESC);


--
-- TOC entry 4676 (class 1259 OID 116079)
-- Name: idx_ad_impressions_session; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_ad_impressions_session ON public.ad_impressions USING btree (session_id);


--
-- TOC entry 4677 (class 1259 OID 116077)
-- Name: idx_ad_impressions_site; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_ad_impressions_site ON public.ad_impressions USING btree (site_id, created_at DESC);


--
-- TOC entry 4617 (class 1259 OID 109211)
-- Name: idx_ads_advertisers_site_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_ads_advertisers_site_id ON public.ads_advertisers USING btree (site_id);


--
-- TOC entry 4618 (class 1259 OID 109212)
-- Name: idx_ads_advertisers_site_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_ads_advertisers_site_status ON public.ads_advertisers USING btree (site_id, status);


--
-- TOC entry 4629 (class 1259 OID 109874)
-- Name: idx_ads_campaigns_advertiser; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_ads_campaigns_advertiser ON public.ads_campaigns USING btree (advertiser_id);


--
-- TOC entry 4630 (class 1259 OID 111301)
-- Name: idx_ads_campaigns_site_dates; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_ads_campaigns_site_dates ON public.ads_campaigns USING btree (site_id, starts_at, ends_at, status);


--
-- TOC entry 4631 (class 1259 OID 109215)
-- Name: idx_ads_campaigns_site_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_ads_campaigns_site_id ON public.ads_campaigns USING btree (site_id);


--
-- TOC entry 4632 (class 1259 OID 109872)
-- Name: idx_ads_campaigns_site_slot_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_ads_campaigns_site_slot_status ON public.ads_campaigns USING btree (site_id, slot_id, status);


--
-- TOC entry 4633 (class 1259 OID 109216)
-- Name: idx_ads_campaigns_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_ads_campaigns_status ON public.ads_campaigns USING btree (status);


--
-- TOC entry 4636 (class 1259 OID 109218)
-- Name: idx_ads_creatives_campaign_active; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_ads_creatives_campaign_active ON public.ads_creatives USING btree (campaign_id, is_active);


--
-- TOC entry 4637 (class 1259 OID 109217)
-- Name: idx_ads_creatives_campaign_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_ads_creatives_campaign_id ON public.ads_creatives USING btree (campaign_id);


--
-- TOC entry 4638 (class 1259 OID 109876)
-- Name: idx_ads_creatives_media; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_ads_creatives_media ON public.ads_creatives USING btree (media_id) WHERE (media_id IS NOT NULL);


--
-- TOC entry 4639 (class 1259 OID 109897)
-- Name: idx_ads_creatives_one_active_per_campaign; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX idx_ads_creatives_one_active_per_campaign ON public.ads_creatives USING btree (campaign_id) WHERE (is_active = true);


--
-- TOC entry 5260 (class 0 OID 0)
-- Dependencies: 4639
-- Name: INDEX idx_ads_creatives_one_active_per_campaign; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON INDEX public.idx_ads_creatives_one_active_per_campaign IS 'Enforces that each campaign can have at most one active creative at a time.';


--
-- TOC entry 4623 (class 1259 OID 109214)
-- Name: idx_ads_slots_site_active; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_ads_slots_site_active ON public.ads_slots USING btree (site_id, is_active);


--
-- TOC entry 4624 (class 1259 OID 109213)
-- Name: idx_ads_slots_site_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_ads_slots_site_id ON public.ads_slots USING btree (site_id);


--
-- TOC entry 4593 (class 1259 OID 111298)
-- Name: idx_api_keys_created_by; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_api_keys_created_by ON public.api_keys USING btree (created_by) WHERE (created_by IS NOT NULL);


--
-- TOC entry 4594 (class 1259 OID 106871)
-- Name: idx_api_keys_site_active; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_api_keys_site_active ON public.api_keys USING btree (site_id, is_active);


--
-- TOC entry 4595 (class 1259 OID 106870)
-- Name: idx_api_keys_site_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_api_keys_site_id ON public.api_keys USING btree (site_id);


--
-- TOC entry 4596 (class 1259 OID 106872)
-- Name: idx_api_keys_site_last_used; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_api_keys_site_last_used ON public.api_keys USING btree (site_id, last_used_at DESC);


--
-- TOC entry 4587 (class 1259 OID 106851)
-- Name: idx_audit_logs_site_occurred; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_audit_logs_site_occurred ON public.audit_logs USING btree (site_id, occurred_at DESC);


--
-- TOC entry 4652 (class 1259 OID 112485)
-- Name: idx_event_categories_is_active; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_event_categories_is_active ON public.event_categories USING btree (is_active) WHERE (is_active = true);


--
-- TOC entry 4653 (class 1259 OID 112483)
-- Name: idx_event_categories_site_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_event_categories_site_id ON public.event_categories USING btree (site_id);


--
-- TOC entry 4654 (class 1259 OID 112484)
-- Name: idx_event_categories_sort_order; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_event_categories_sort_order ON public.event_categories USING btree (sort_order);


--
-- TOC entry 4555 (class 1259 OID 111297)
-- Name: idx_events_category; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_events_category ON public.events USING btree (category_id) WHERE (category_id IS NOT NULL);


--
-- TOC entry 4556 (class 1259 OID 112464)
-- Name: idx_events_cover_url; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_events_cover_url ON public.events USING btree (cover_url) WHERE (cover_url IS NOT NULL);


--
-- TOC entry 4557 (class 1259 OID 111293)
-- Name: idx_events_published; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_events_published ON public.events USING btree (site_id, start_at) WHERE (status = 'published'::public.event_status);


--
-- TOC entry 4558 (class 1259 OID 106844)
-- Name: idx_events_site_start_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_events_site_start_at ON public.events USING btree (site_id, start_at);


--
-- TOC entry 4559 (class 1259 OID 106843)
-- Name: idx_events_site_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_events_site_status ON public.events USING btree (site_id, status);


--
-- TOC entry 4661 (class 1259 OID 115945)
-- Name: idx_import_batches_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_import_batches_status ON public.import_batches USING btree (created_at DESC);


--
-- TOC entry 4542 (class 1259 OID 111295)
-- Name: idx_media_active; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_media_active ON public.media USING btree (site_id, owner_type, owner_id) WHERE (is_active = true);


--
-- TOC entry 4543 (class 1259 OID 106454)
-- Name: idx_media_site_owner; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_media_site_owner ON public.media USING btree (site_id, owner_type, owner_id);


--
-- TOC entry 4667 (class 1259 OID 116045)
-- Name: idx_page_views_created; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_page_views_created ON public.page_views USING btree (created_at DESC);


--
-- TOC entry 4668 (class 1259 OID 116044)
-- Name: idx_page_views_session; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_page_views_session ON public.page_views USING btree (session_id);


--
-- TOC entry 4669 (class 1259 OID 116043)
-- Name: idx_page_views_site_created; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_page_views_site_created ON public.page_views USING btree (site_id, created_at DESC);


--
-- TOC entry 4510 (class 1259 OID 113627)
-- Name: idx_place_categories_category_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_place_categories_category_type ON public.place_categories USING btree (category_type);


--
-- TOC entry 4511 (class 1259 OID 113626)
-- Name: idx_place_categories_parent_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_place_categories_parent_id ON public.place_categories USING btree (parent_id);


--
-- TOC entry 4512 (class 1259 OID 113628)
-- Name: idx_place_categories_slug; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_place_categories_slug ON public.place_categories USING btree (site_id, slug) WHERE (slug IS NOT NULL);


--
-- TOC entry 4664 (class 1259 OID 116008)
-- Name: idx_place_images_place_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_place_images_place_id ON public.place_images USING btree (place_id);


--
-- TOC entry 4517 (class 1259 OID 113629)
-- Name: idx_places_category_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_places_category_type ON public.places USING btree (category_type);


--
-- TOC entry 4518 (class 1259 OID 115905)
-- Name: idx_places_curation; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_places_curation ON public.places USING btree (curation_status, kind, updated_at);


--
-- TOC entry 4519 (class 1259 OID 115906)
-- Name: idx_places_import_batch; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_places_import_batch ON public.places USING btree (import_batch_id);


--
-- TOC entry 4520 (class 1259 OID 113632)
-- Name: idx_places_is_featured; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_places_is_featured ON public.places USING btree (is_featured) WHERE (is_featured = true);


--
-- TOC entry 4521 (class 1259 OID 111292)
-- Name: idx_places_published; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_places_published ON public.places USING btree (site_id, kind) WHERE (status = 'published'::public.place_status);


--
-- TOC entry 4522 (class 1259 OID 111296)
-- Name: idx_places_secondary_category; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_places_secondary_category ON public.places USING btree (secondary_category_id) WHERE (secondary_category_id IS NOT NULL);


--
-- TOC entry 4523 (class 1259 OID 106842)
-- Name: idx_places_site_kind; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_places_site_kind ON public.places USING btree (site_id, kind);


--
-- TOC entry 4524 (class 1259 OID 106850)
-- Name: idx_places_site_sort_order; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_places_site_sort_order ON public.places USING btree (site_id, sort_order);


--
-- TOC entry 4525 (class 1259 OID 106841)
-- Name: idx_places_site_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_places_site_status ON public.places USING btree (site_id, status);


--
-- TOC entry 4526 (class 1259 OID 113631)
-- Name: idx_places_slug; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_places_slug ON public.places USING btree (site_id, slug) WHERE (slug IS NOT NULL);


--
-- TOC entry 4527 (class 1259 OID 113630)
-- Name: idx_places_subcategory_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_places_subcategory_id ON public.places USING btree (subcategory_id);


--
-- TOC entry 4640 (class 1259 OID 109944)
-- Name: idx_platform_roles_role; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_platform_roles_role ON public.platform_roles USING btree (role);


--
-- TOC entry 4568 (class 1259 OID 111300)
-- Name: idx_post_tag_links_tag; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_post_tag_links_tag ON public.post_tag_links USING btree (tag_id);


--
-- TOC entry 4534 (class 1259 OID 111294)
-- Name: idx_posts_published; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_posts_published ON public.posts USING btree (site_id, published_at) WHERE (status = 'published'::public.place_status);


--
-- TOC entry 4535 (class 1259 OID 106839)
-- Name: idx_posts_site_kind; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_posts_site_kind ON public.posts USING btree (site_id, kind);


--
-- TOC entry 4536 (class 1259 OID 106840)
-- Name: idx_posts_site_published_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_posts_site_published_at ON public.posts USING btree (site_id, published_at);


--
-- TOC entry 4537 (class 1259 OID 106838)
-- Name: idx_posts_site_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_posts_site_status ON public.posts USING btree (site_id, status);


--
-- TOC entry 4546 (class 1259 OID 106845)
-- Name: idx_site_content_site_slot; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_site_content_site_slot ON public.site_content USING btree (site_id, slot);


--
-- TOC entry 4644 (class 1259 OID 111332)
-- Name: idx_site_metrics_calculated_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_site_metrics_calculated_at ON public.site_metrics USING btree (calculated_at);


--
-- TOC entry 4645 (class 1259 OID 111331)
-- Name: idx_site_metrics_site_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_site_metrics_site_id ON public.site_metrics USING btree (site_id);


--
-- TOC entry 4578 (class 1259 OID 106861)
-- Name: idx_user_invitation_sites_site; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_user_invitation_sites_site ON public.user_invitation_sites USING btree (site_id);


--
-- TOC entry 4571 (class 1259 OID 106859)
-- Name: idx_user_invitations_email; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_user_invitations_email ON public.user_invitations USING btree (email);


--
-- TOC entry 4572 (class 1259 OID 106860)
-- Name: idx_user_invitations_expires_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_user_invitations_expires_at ON public.user_invitations USING btree (expires_at);


--
-- TOC entry 4604 (class 1259 OID 106889)
-- Name: idx_webhook_deliveries_site_created; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_webhook_deliveries_site_created ON public.webhook_deliveries USING btree (site_id, created_at DESC);


--
-- TOC entry 4605 (class 1259 OID 106890)
-- Name: idx_webhook_deliveries_status_next; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_webhook_deliveries_status_next ON public.webhook_deliveries USING btree (status, next_attempt_at);


--
-- TOC entry 4606 (class 1259 OID 106891)
-- Name: idx_webhook_deliveries_webhook_created; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_webhook_deliveries_webhook_created ON public.webhook_deliveries USING btree (webhook_id, created_at DESC);


--
-- TOC entry 4597 (class 1259 OID 111299)
-- Name: idx_webhooks_created_by; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_webhooks_created_by ON public.webhooks USING btree (created_by) WHERE (created_by IS NOT NULL);


--
-- TOC entry 4598 (class 1259 OID 106878)
-- Name: idx_webhooks_site_active; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_webhooks_site_active ON public.webhooks USING btree (site_id, is_active);


--
-- TOC entry 4599 (class 1259 OID 106879)
-- Name: idx_webhooks_site_event; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_webhooks_site_event ON public.webhooks USING btree (site_id, event_type);


--
-- TOC entry 4643 (class 1259 OID 111103)
-- Name: platform_roles_user_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX platform_roles_user_id_idx ON public.platform_roles USING btree (user_id);


--
-- TOC entry 4573 (class 1259 OID 106689)
-- Name: user_invitations_email_pending_ux; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX user_invitations_email_pending_ux ON public.user_invitations USING btree (email) WHERE (status = 'pending'::public.invitation_status);


--
-- TOC entry 4607 (class 1259 OID 106803)
-- Name: webhook_deliveries_created_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX webhook_deliveries_created_idx ON public.webhook_deliveries USING btree (created_at DESC);


--
-- TOC entry 4612 (class 1259 OID 106802)
-- Name: webhook_deliveries_webhook_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX webhook_deliveries_webhook_idx ON public.webhook_deliveries USING btree (webhook_id);


--
-- TOC entry 4464 (class 1259 OID 17290)
-- Name: ix_realtime_subscription_entity; Type: INDEX; Schema: realtime; Owner: -
--

CREATE INDEX ix_realtime_subscription_entity ON realtime.subscription USING btree (entity);


--
-- TOC entry 4468 (class 1259 OID 17291)
-- Name: messages_inserted_at_topic_index; Type: INDEX; Schema: realtime; Owner: -
--

CREATE INDEX messages_inserted_at_topic_index ON ONLY realtime.messages USING btree (inserted_at DESC, topic) WHERE ((extension = 'broadcast'::text) AND (private IS TRUE));


--
-- TOC entry 4467 (class 1259 OID 114740)
-- Name: subscription_subscription_id_entity_filters_action_filter_key; Type: INDEX; Schema: realtime; Owner: -
--

CREATE UNIQUE INDEX subscription_subscription_id_entity_filters_action_filter_key ON realtime.subscription USING btree (subscription_id, entity, filters, action_filter);


--
-- TOC entry 4383 (class 1259 OID 16560)
-- Name: bname; Type: INDEX; Schema: storage; Owner: -
--

CREATE UNIQUE INDEX bname ON storage.buckets USING btree (name);


--
-- TOC entry 4386 (class 1259 OID 16582)
-- Name: bucketid_objname; Type: INDEX; Schema: storage; Owner: -
--

CREATE UNIQUE INDEX bucketid_objname ON storage.objects USING btree (bucket_id, name);


--
-- TOC entry 4477 (class 1259 OID 52083)
-- Name: buckets_analytics_unique_name_idx; Type: INDEX; Schema: storage; Owner: -
--

CREATE UNIQUE INDEX buckets_analytics_unique_name_idx ON storage.buckets_analytics USING btree (name) WHERE (deleted_at IS NULL);


--
-- TOC entry 4457 (class 1259 OID 17091)
-- Name: idx_multipart_uploads_list; Type: INDEX; Schema: storage; Owner: -
--

CREATE INDEX idx_multipart_uploads_list ON storage.s3_multipart_uploads USING btree (bucket_id, key, created_at);


--
-- TOC entry 4387 (class 1259 OID 17056)
-- Name: idx_objects_bucket_id_name; Type: INDEX; Schema: storage; Owner: -
--

CREATE INDEX idx_objects_bucket_id_name ON storage.objects USING btree (bucket_id, name COLLATE "C");


--
-- TOC entry 4388 (class 1259 OID 118340)
-- Name: idx_objects_bucket_id_name_lower; Type: INDEX; Schema: storage; Owner: -
--

CREATE INDEX idx_objects_bucket_id_name_lower ON storage.objects USING btree (bucket_id, lower(name) COLLATE "C");


--
-- TOC entry 4389 (class 1259 OID 16583)
-- Name: name_prefix_search; Type: INDEX; Schema: storage; Owner: -
--

CREATE INDEX name_prefix_search ON storage.objects USING btree (name text_pattern_ops);


--
-- TOC entry 4494 (class 1259 OID 52074)
-- Name: vector_indexes_name_bucket_id_idx; Type: INDEX; Schema: storage; Owner: -
--

CREATE UNIQUE INDEX vector_indexes_name_bucket_id_idx ON storage.vector_indexes USING btree (name, bucket_id);


--
-- TOC entry 4786 (class 2620 OID 114770)
-- Name: hero_banners hero_banners_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER hero_banners_updated_at BEFORE UPDATE ON public.hero_banners FOR EACH ROW EXECUTE FUNCTION public.touch_updated_at();


--
-- TOC entry 4784 (class 2620 OID 111105)
-- Name: platform_roles platform_roles_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER platform_roles_updated_at BEFORE UPDATE ON public.platform_roles FOR EACH ROW EXECUTE FUNCTION public.touch_updated_at();


--
-- TOC entry 4785 (class 2620 OID 111334)
-- Name: site_metrics site_metrics_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER site_metrics_updated_at BEFORE UPDATE ON public.site_metrics FOR EACH ROW EXECUTE FUNCTION public.update_site_metrics_updated_at();


--
-- TOC entry 4780 (class 2620 OID 109877)
-- Name: ads_advertisers trg_ads_advertisers_updated; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trg_ads_advertisers_updated BEFORE UPDATE ON public.ads_advertisers FOR EACH ROW EXECUTE FUNCTION public.touch_updated_at();


--
-- TOC entry 4782 (class 2620 OID 109879)
-- Name: ads_campaigns trg_ads_campaigns_updated; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trg_ads_campaigns_updated BEFORE UPDATE ON public.ads_campaigns FOR EACH ROW EXECUTE FUNCTION public.touch_updated_at();


--
-- TOC entry 4783 (class 2620 OID 109880)
-- Name: ads_creatives trg_ads_creatives_updated; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trg_ads_creatives_updated BEFORE UPDATE ON public.ads_creatives FOR EACH ROW EXECUTE FUNCTION public.touch_updated_at();


--
-- TOC entry 4781 (class 2620 OID 109878)
-- Name: ads_slots trg_ads_slots_updated; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trg_ads_slots_updated BEFORE UPDATE ON public.ads_slots FOR EACH ROW EXECUTE FUNCTION public.touch_updated_at();


--
-- TOC entry 4774 (class 2620 OID 106558)
-- Name: events trg_events_updated; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trg_events_updated BEFORE UPDATE ON public.events FOR EACH ROW EXECUTE FUNCTION public.touch_updated_at();


--
-- TOC entry 4772 (class 2620 OID 106455)
-- Name: media trg_media_updated; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trg_media_updated BEFORE UPDATE ON public.media FOR EACH ROW EXECUTE FUNCTION public.touch_updated_at();


--
-- TOC entry 4768 (class 2620 OID 111285)
-- Name: place_categories trg_place_categories_updated; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trg_place_categories_updated BEFORE UPDATE ON public.place_categories FOR EACH ROW EXECUTE FUNCTION public.touch_updated_at();


--
-- TOC entry 4770 (class 2620 OID 111287)
-- Name: place_media trg_place_media_updated; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trg_place_media_updated BEFORE UPDATE ON public.place_media FOR EACH ROW EXECUTE FUNCTION public.touch_updated_at();


--
-- TOC entry 4769 (class 2620 OID 106375)
-- Name: places trg_places_updated; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trg_places_updated BEFORE UPDATE ON public.places FOR EACH ROW EXECUTE FUNCTION public.touch_updated_at();


--
-- TOC entry 4775 (class 2620 OID 106581)
-- Name: post_categories trg_post_categories_updated; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trg_post_categories_updated BEFORE UPDATE ON public.post_categories FOR EACH ROW EXECUTE FUNCTION public.touch_updated_at();


--
-- TOC entry 4776 (class 2620 OID 106603)
-- Name: post_tags trg_post_tags_updated; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trg_post_tags_updated BEFORE UPDATE ON public.post_tags FOR EACH ROW EXECUTE FUNCTION public.touch_updated_at();


--
-- TOC entry 4771 (class 2620 OID 106376)
-- Name: posts trg_posts_updated; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trg_posts_updated BEFORE UPDATE ON public.posts FOR EACH ROW EXECUTE FUNCTION public.touch_updated_at();


--
-- TOC entry 4766 (class 2620 OID 111289)
-- Name: profiles trg_profiles_updated; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trg_profiles_updated BEFORE UPDATE ON public.profiles FOR EACH ROW EXECUTE FUNCTION public.touch_updated_at();


--
-- TOC entry 4773 (class 2620 OID 106494)
-- Name: site_content trg_site_content_updated; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trg_site_content_updated BEFORE UPDATE ON public.site_content FOR EACH ROW EXECUTE FUNCTION public.touch_updated_at();


--
-- TOC entry 4767 (class 2620 OID 109917)
-- Name: site_members trg_site_members_updated; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trg_site_members_updated BEFORE UPDATE ON public.site_members FOR EACH ROW EXECUTE FUNCTION public.touch_updated_at();


--
-- TOC entry 4765 (class 2620 OID 106669)
-- Name: sites trg_sites_touch_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trg_sites_touch_updated_at BEFORE UPDATE ON public.sites FOR EACH ROW EXECUTE FUNCTION public.touch_updated_at();


--
-- TOC entry 4777 (class 2620 OID 106690)
-- Name: user_invitations trg_user_invitations_touch_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trg_user_invitations_touch_updated_at BEFORE UPDATE ON public.user_invitations FOR EACH ROW EXECUTE FUNCTION public.touch_updated_at();


--
-- TOC entry 4779 (class 2620 OID 106883)
-- Name: webhook_deliveries trg_webhook_deliveries_updated; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trg_webhook_deliveries_updated BEFORE UPDATE ON public.webhook_deliveries FOR EACH ROW EXECUTE FUNCTION public.touch_updated_at();


--
-- TOC entry 4778 (class 2620 OID 106780)
-- Name: webhooks trg_webhooks_touch_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trg_webhooks_touch_updated_at BEFORE UPDATE ON public.webhooks FOR EACH ROW EXECUTE FUNCTION public.touch_updated_at();


--
-- TOC entry 4764 (class 2620 OID 17144)
-- Name: subscription tr_check_filters; Type: TRIGGER; Schema: realtime; Owner: -
--

CREATE TRIGGER tr_check_filters BEFORE INSERT OR UPDATE ON realtime.subscription FOR EACH ROW EXECUTE FUNCTION realtime.subscription_check_filters();


--
-- TOC entry 4760 (class 2620 OID 20258)
-- Name: buckets enforce_bucket_name_length_trigger; Type: TRIGGER; Schema: storage; Owner: -
--

CREATE TRIGGER enforce_bucket_name_length_trigger BEFORE INSERT OR UPDATE OF name ON storage.buckets FOR EACH ROW EXECUTE FUNCTION storage.enforce_bucket_name_length();


--
-- TOC entry 4761 (class 2620 OID 118342)
-- Name: buckets protect_buckets_delete; Type: TRIGGER; Schema: storage; Owner: -
--

CREATE TRIGGER protect_buckets_delete BEFORE DELETE ON storage.buckets FOR EACH STATEMENT EXECUTE FUNCTION storage.protect_delete();


--
-- TOC entry 4762 (class 2620 OID 118343)
-- Name: objects protect_objects_delete; Type: TRIGGER; Schema: storage; Owner: -
--

CREATE TRIGGER protect_objects_delete BEFORE DELETE ON storage.objects FOR EACH STATEMENT EXECUTE FUNCTION storage.protect_delete();


--
-- TOC entry 4763 (class 2620 OID 17044)
-- Name: objects update_objects_updated_at; Type: TRIGGER; Schema: storage; Owner: -
--

CREATE TRIGGER update_objects_updated_at BEFORE UPDATE ON storage.objects FOR EACH ROW EXECUTE FUNCTION storage.update_updated_at_column();


--
-- TOC entry 4685 (class 2606 OID 16732)
-- Name: identities identities_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.identities
    ADD CONSTRAINT identities_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- TOC entry 4690 (class 2606 OID 16821)
-- Name: mfa_amr_claims mfa_amr_claims_session_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.mfa_amr_claims
    ADD CONSTRAINT mfa_amr_claims_session_id_fkey FOREIGN KEY (session_id) REFERENCES auth.sessions(id) ON DELETE CASCADE;


--
-- TOC entry 4689 (class 2606 OID 16809)
-- Name: mfa_challenges mfa_challenges_auth_factor_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.mfa_challenges
    ADD CONSTRAINT mfa_challenges_auth_factor_id_fkey FOREIGN KEY (factor_id) REFERENCES auth.mfa_factors(id) ON DELETE CASCADE;


--
-- TOC entry 4688 (class 2606 OID 16796)
-- Name: mfa_factors mfa_factors_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.mfa_factors
    ADD CONSTRAINT mfa_factors_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- TOC entry 4699 (class 2606 OID 32651)
-- Name: oauth_authorizations oauth_authorizations_client_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.oauth_authorizations
    ADD CONSTRAINT oauth_authorizations_client_id_fkey FOREIGN KEY (client_id) REFERENCES auth.oauth_clients(id) ON DELETE CASCADE;


--
-- TOC entry 4700 (class 2606 OID 32656)
-- Name: oauth_authorizations oauth_authorizations_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.oauth_authorizations
    ADD CONSTRAINT oauth_authorizations_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- TOC entry 4701 (class 2606 OID 32680)
-- Name: oauth_consents oauth_consents_client_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.oauth_consents
    ADD CONSTRAINT oauth_consents_client_id_fkey FOREIGN KEY (client_id) REFERENCES auth.oauth_clients(id) ON DELETE CASCADE;


--
-- TOC entry 4702 (class 2606 OID 32675)
-- Name: oauth_consents oauth_consents_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.oauth_consents
    ADD CONSTRAINT oauth_consents_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- TOC entry 4695 (class 2606 OID 16987)
-- Name: one_time_tokens one_time_tokens_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.one_time_tokens
    ADD CONSTRAINT one_time_tokens_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- TOC entry 4683 (class 2606 OID 16765)
-- Name: refresh_tokens refresh_tokens_session_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.refresh_tokens
    ADD CONSTRAINT refresh_tokens_session_id_fkey FOREIGN KEY (session_id) REFERENCES auth.sessions(id) ON DELETE CASCADE;


--
-- TOC entry 4692 (class 2606 OID 16868)
-- Name: saml_providers saml_providers_sso_provider_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.saml_providers
    ADD CONSTRAINT saml_providers_sso_provider_id_fkey FOREIGN KEY (sso_provider_id) REFERENCES auth.sso_providers(id) ON DELETE CASCADE;


--
-- TOC entry 4693 (class 2606 OID 16941)
-- Name: saml_relay_states saml_relay_states_flow_state_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.saml_relay_states
    ADD CONSTRAINT saml_relay_states_flow_state_id_fkey FOREIGN KEY (flow_state_id) REFERENCES auth.flow_state(id) ON DELETE CASCADE;


--
-- TOC entry 4694 (class 2606 OID 16882)
-- Name: saml_relay_states saml_relay_states_sso_provider_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.saml_relay_states
    ADD CONSTRAINT saml_relay_states_sso_provider_id_fkey FOREIGN KEY (sso_provider_id) REFERENCES auth.sso_providers(id) ON DELETE CASCADE;


--
-- TOC entry 4686 (class 2606 OID 32694)
-- Name: sessions sessions_oauth_client_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.sessions
    ADD CONSTRAINT sessions_oauth_client_id_fkey FOREIGN KEY (oauth_client_id) REFERENCES auth.oauth_clients(id) ON DELETE CASCADE;


--
-- TOC entry 4687 (class 2606 OID 16760)
-- Name: sessions sessions_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.sessions
    ADD CONSTRAINT sessions_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- TOC entry 4691 (class 2606 OID 16849)
-- Name: sso_domains sso_domains_sso_provider_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.sso_domains
    ADD CONSTRAINT sso_domains_sso_provider_id_fkey FOREIGN KEY (sso_provider_id) REFERENCES auth.sso_providers(id) ON DELETE CASCADE;


--
-- TOC entry 4757 (class 2606 OID 116092)
-- Name: ad_clicks ad_clicks_campaign_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ad_clicks
    ADD CONSTRAINT ad_clicks_campaign_id_fkey FOREIGN KEY (campaign_id) REFERENCES public.ads_campaigns(id) ON DELETE CASCADE;


--
-- TOC entry 4758 (class 2606 OID 116097)
-- Name: ad_clicks ad_clicks_creative_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ad_clicks
    ADD CONSTRAINT ad_clicks_creative_id_fkey FOREIGN KEY (creative_id) REFERENCES public.ads_creatives(id) ON DELETE CASCADE;


--
-- TOC entry 4759 (class 2606 OID 116087)
-- Name: ad_clicks ad_clicks_impression_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ad_clicks
    ADD CONSTRAINT ad_clicks_impression_id_fkey FOREIGN KEY (impression_id) REFERENCES public.ad_impressions(id) ON DELETE SET NULL;


--
-- TOC entry 4753 (class 2606 OID 116061)
-- Name: ad_impressions ad_impressions_campaign_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ad_impressions
    ADD CONSTRAINT ad_impressions_campaign_id_fkey FOREIGN KEY (campaign_id) REFERENCES public.ads_campaigns(id) ON DELETE CASCADE;


--
-- TOC entry 4754 (class 2606 OID 116066)
-- Name: ad_impressions ad_impressions_creative_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ad_impressions
    ADD CONSTRAINT ad_impressions_creative_id_fkey FOREIGN KEY (creative_id) REFERENCES public.ads_creatives(id) ON DELETE CASCADE;


--
-- TOC entry 4755 (class 2606 OID 116056)
-- Name: ad_impressions ad_impressions_site_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ad_impressions
    ADD CONSTRAINT ad_impressions_site_id_fkey FOREIGN KEY (site_id) REFERENCES public.sites(id) ON DELETE CASCADE;


--
-- TOC entry 4756 (class 2606 OID 116071)
-- Name: ad_impressions ad_impressions_slot_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ad_impressions
    ADD CONSTRAINT ad_impressions_slot_id_fkey FOREIGN KEY (slot_id) REFERENCES public.ads_slots(id) ON DELETE CASCADE;


--
-- TOC entry 4737 (class 2606 OID 109135)
-- Name: ads_advertisers ads_advertisers_site_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ads_advertisers
    ADD CONSTRAINT ads_advertisers_site_id_fkey FOREIGN KEY (site_id) REFERENCES public.sites(id) ON DELETE CASCADE;


--
-- TOC entry 4739 (class 2606 OID 109179)
-- Name: ads_campaigns ads_campaigns_advertiser_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ads_campaigns
    ADD CONSTRAINT ads_campaigns_advertiser_id_fkey FOREIGN KEY (advertiser_id) REFERENCES public.ads_advertisers(id) ON DELETE CASCADE;


--
-- TOC entry 4740 (class 2606 OID 109174)
-- Name: ads_campaigns ads_campaigns_site_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ads_campaigns
    ADD CONSTRAINT ads_campaigns_site_id_fkey FOREIGN KEY (site_id) REFERENCES public.sites(id) ON DELETE CASCADE;


--
-- TOC entry 4741 (class 2606 OID 109184)
-- Name: ads_campaigns ads_campaigns_slot_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ads_campaigns
    ADD CONSTRAINT ads_campaigns_slot_id_fkey FOREIGN KEY (slot_id) REFERENCES public.ads_slots(id) ON DELETE RESTRICT;


--
-- TOC entry 4742 (class 2606 OID 109201)
-- Name: ads_creatives ads_creatives_campaign_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ads_creatives
    ADD CONSTRAINT ads_creatives_campaign_id_fkey FOREIGN KEY (campaign_id) REFERENCES public.ads_campaigns(id) ON DELETE CASCADE;


--
-- TOC entry 4743 (class 2606 OID 109206)
-- Name: ads_creatives ads_creatives_media_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ads_creatives
    ADD CONSTRAINT ads_creatives_media_id_fkey FOREIGN KEY (media_id) REFERENCES public.media(id) ON DELETE SET NULL;


--
-- TOC entry 4738 (class 2606 OID 109154)
-- Name: ads_slots ads_slots_site_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ads_slots
    ADD CONSTRAINT ads_slots_site_id_fkey FOREIGN KEY (site_id) REFERENCES public.sites(id) ON DELETE CASCADE;


--
-- TOC entry 4731 (class 2606 OID 106750)
-- Name: api_keys api_keys_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.api_keys
    ADD CONSTRAINT api_keys_created_by_fkey FOREIGN KEY (created_by) REFERENCES auth.users(id) ON DELETE SET NULL;


--
-- TOC entry 4732 (class 2606 OID 106745)
-- Name: api_keys api_keys_site_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.api_keys
    ADD CONSTRAINT api_keys_site_id_fkey FOREIGN KEY (site_id) REFERENCES public.sites(id) ON DELETE CASCADE;


--
-- TOC entry 4729 (class 2606 OID 106720)
-- Name: audit_logs audit_logs_actor_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.audit_logs
    ADD CONSTRAINT audit_logs_actor_user_id_fkey FOREIGN KEY (actor_user_id) REFERENCES auth.users(id) ON DELETE SET NULL;


--
-- TOC entry 4730 (class 2606 OID 106725)
-- Name: audit_logs audit_logs_site_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.audit_logs
    ADD CONSTRAINT audit_logs_site_id_fkey FOREIGN KEY (site_id) REFERENCES public.sites(id) ON DELETE SET NULL;


--
-- TOC entry 4746 (class 2606 OID 112478)
-- Name: event_categories event_categories_site_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.event_categories
    ADD CONSTRAINT event_categories_site_id_fkey FOREIGN KEY (site_id) REFERENCES public.sites(id) ON DELETE CASCADE;


--
-- TOC entry 4719 (class 2606 OID 111279)
-- Name: events events_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.events
    ADD CONSTRAINT events_category_id_fkey FOREIGN KEY (category_id) REFERENCES public.place_categories(id) ON DELETE SET NULL;


--
-- TOC entry 4720 (class 2606 OID 106553)
-- Name: events events_primary_media_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.events
    ADD CONSTRAINT events_primary_media_id_fkey FOREIGN KEY (primary_media_id) REFERENCES public.media(id) ON DELETE SET NULL;


--
-- TOC entry 4721 (class 2606 OID 106548)
-- Name: events events_site_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.events
    ADD CONSTRAINT events_site_id_fkey FOREIGN KEY (site_id) REFERENCES public.sites(id) ON DELETE CASCADE;


--
-- TOC entry 4747 (class 2606 OID 114761)
-- Name: hero_banners hero_banners_primary_media_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.hero_banners
    ADD CONSTRAINT hero_banners_primary_media_id_fkey FOREIGN KEY (primary_media_id) REFERENCES public.media(id) ON DELETE SET NULL;


--
-- TOC entry 4748 (class 2606 OID 114756)
-- Name: hero_banners hero_banners_site_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.hero_banners
    ADD CONSTRAINT hero_banners_site_id_fkey FOREIGN KEY (site_id) REFERENCES public.sites(id) ON DELETE CASCADE;


--
-- TOC entry 4749 (class 2606 OID 115940)
-- Name: import_batches import_batches_imported_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.import_batches
    ADD CONSTRAINT import_batches_imported_by_fkey FOREIGN KEY (imported_by) REFERENCES auth.users(id);


--
-- TOC entry 4716 (class 2606 OID 106449)
-- Name: media media_site_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.media
    ADD CONSTRAINT media_site_id_fkey FOREIGN KEY (site_id) REFERENCES public.sites(id) ON DELETE CASCADE;


--
-- TOC entry 4751 (class 2606 OID 116033)
-- Name: page_views page_views_site_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.page_views
    ADD CONSTRAINT page_views_site_id_fkey FOREIGN KEY (site_id) REFERENCES public.sites(id) ON DELETE CASCADE;


--
-- TOC entry 4752 (class 2606 OID 116038)
-- Name: page_views page_views_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.page_views
    ADD CONSTRAINT page_views_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE SET NULL;


--
-- TOC entry 4707 (class 2606 OID 113612)
-- Name: place_categories place_categories_parent_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.place_categories
    ADD CONSTRAINT place_categories_parent_id_fkey FOREIGN KEY (parent_id) REFERENCES public.place_categories(id) ON DELETE SET NULL;


--
-- TOC entry 4708 (class 2606 OID 106310)
-- Name: place_categories place_categories_site_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.place_categories
    ADD CONSTRAINT place_categories_site_id_fkey FOREIGN KEY (site_id) REFERENCES public.sites(id) ON DELETE CASCADE;


--
-- TOC entry 4750 (class 2606 OID 116003)
-- Name: place_images place_images_place_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.place_images
    ADD CONSTRAINT place_images_place_id_fkey FOREIGN KEY (place_id) REFERENCES public.places(id) ON DELETE CASCADE;


--
-- TOC entry 4714 (class 2606 OID 106350)
-- Name: place_media place_media_place_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.place_media
    ADD CONSTRAINT place_media_place_id_fkey FOREIGN KEY (place_id) REFERENCES public.places(id) ON DELETE CASCADE;


--
-- TOC entry 4709 (class 2606 OID 106334)
-- Name: places places_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.places
    ADD CONSTRAINT places_category_id_fkey FOREIGN KEY (category_id) REFERENCES public.place_categories(id) ON DELETE SET NULL;


--
-- TOC entry 4710 (class 2606 OID 115900)
-- Name: places places_curated_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.places
    ADD CONSTRAINT places_curated_by_fkey FOREIGN KEY (curated_by) REFERENCES auth.users(id);


--
-- TOC entry 4711 (class 2606 OID 111274)
-- Name: places places_secondary_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.places
    ADD CONSTRAINT places_secondary_category_id_fkey FOREIGN KEY (secondary_category_id) REFERENCES public.place_categories(id) ON DELETE SET NULL;


--
-- TOC entry 4712 (class 2606 OID 106329)
-- Name: places places_site_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.places
    ADD CONSTRAINT places_site_id_fkey FOREIGN KEY (site_id) REFERENCES public.sites(id) ON DELETE CASCADE;


--
-- TOC entry 4713 (class 2606 OID 113621)
-- Name: places places_subcategory_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.places
    ADD CONSTRAINT places_subcategory_id_fkey FOREIGN KEY (subcategory_id) REFERENCES public.place_categories(id) ON DELETE SET NULL;


--
-- TOC entry 4744 (class 2606 OID 109934)
-- Name: platform_roles platform_roles_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.platform_roles
    ADD CONSTRAINT platform_roles_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- TOC entry 4722 (class 2606 OID 106576)
-- Name: post_categories post_categories_site_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.post_categories
    ADD CONSTRAINT post_categories_site_id_fkey FOREIGN KEY (site_id) REFERENCES public.sites(id) ON DELETE CASCADE;


--
-- TOC entry 4724 (class 2606 OID 106611)
-- Name: post_tag_links post_tag_links_post_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.post_tag_links
    ADD CONSTRAINT post_tag_links_post_id_fkey FOREIGN KEY (post_id) REFERENCES public.posts(id) ON DELETE CASCADE;


--
-- TOC entry 4725 (class 2606 OID 106616)
-- Name: post_tag_links post_tag_links_tag_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.post_tag_links
    ADD CONSTRAINT post_tag_links_tag_id_fkey FOREIGN KEY (tag_id) REFERENCES public.post_tags(id) ON DELETE CASCADE;


--
-- TOC entry 4723 (class 2606 OID 106598)
-- Name: post_tags post_tags_site_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.post_tags
    ADD CONSTRAINT post_tags_site_id_fkey FOREIGN KEY (site_id) REFERENCES public.sites(id) ON DELETE CASCADE;


--
-- TOC entry 4715 (class 2606 OID 106369)
-- Name: posts posts_site_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.posts
    ADD CONSTRAINT posts_site_id_fkey FOREIGN KEY (site_id) REFERENCES public.sites(id) ON DELETE CASCADE;


--
-- TOC entry 4704 (class 2606 OID 106274)
-- Name: profiles profiles_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.profiles
    ADD CONSTRAINT profiles_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- TOC entry 4717 (class 2606 OID 106489)
-- Name: site_content site_content_primary_media_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.site_content
    ADD CONSTRAINT site_content_primary_media_id_fkey FOREIGN KEY (primary_media_id) REFERENCES public.media(id) ON DELETE SET NULL;


--
-- TOC entry 4718 (class 2606 OID 106484)
-- Name: site_content site_content_site_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.site_content
    ADD CONSTRAINT site_content_site_id_fkey FOREIGN KEY (site_id) REFERENCES public.sites(id) ON DELETE CASCADE;


--
-- TOC entry 4705 (class 2606 OID 106286)
-- Name: site_members site_members_site_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.site_members
    ADD CONSTRAINT site_members_site_id_fkey FOREIGN KEY (site_id) REFERENCES public.sites(id) ON DELETE CASCADE;


--
-- TOC entry 4706 (class 2606 OID 106291)
-- Name: site_members site_members_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.site_members
    ADD CONSTRAINT site_members_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- TOC entry 4745 (class 2606 OID 111326)
-- Name: site_metrics site_metrics_site_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.site_metrics
    ADD CONSTRAINT site_metrics_site_id_fkey FOREIGN KEY (site_id) REFERENCES public.sites(id) ON DELETE CASCADE;


--
-- TOC entry 4727 (class 2606 OID 106697)
-- Name: user_invitation_sites user_invitation_sites_invitation_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_invitation_sites
    ADD CONSTRAINT user_invitation_sites_invitation_id_fkey FOREIGN KEY (invitation_id) REFERENCES public.user_invitations(id) ON DELETE CASCADE;


--
-- TOC entry 4728 (class 2606 OID 106702)
-- Name: user_invitation_sites user_invitation_sites_site_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_invitation_sites
    ADD CONSTRAINT user_invitation_sites_site_id_fkey FOREIGN KEY (site_id) REFERENCES public.sites(id) ON DELETE CASCADE;


--
-- TOC entry 4726 (class 2606 OID 106684)
-- Name: user_invitations user_invitations_invited_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_invitations
    ADD CONSTRAINT user_invitations_invited_by_fkey FOREIGN KEY (invited_by) REFERENCES auth.users(id) ON DELETE RESTRICT;


--
-- TOC entry 4735 (class 2606 OID 106797)
-- Name: webhook_deliveries webhook_deliveries_site_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.webhook_deliveries
    ADD CONSTRAINT webhook_deliveries_site_id_fkey FOREIGN KEY (site_id) REFERENCES public.sites(id) ON DELETE SET NULL;


--
-- TOC entry 4736 (class 2606 OID 106792)
-- Name: webhook_deliveries webhook_deliveries_webhook_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.webhook_deliveries
    ADD CONSTRAINT webhook_deliveries_webhook_id_fkey FOREIGN KEY (webhook_id) REFERENCES public.webhooks(id) ON DELETE CASCADE;


--
-- TOC entry 4733 (class 2606 OID 106775)
-- Name: webhooks webhooks_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.webhooks
    ADD CONSTRAINT webhooks_created_by_fkey FOREIGN KEY (created_by) REFERENCES auth.users(id) ON DELETE SET NULL;


--
-- TOC entry 4734 (class 2606 OID 106770)
-- Name: webhooks webhooks_site_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.webhooks
    ADD CONSTRAINT webhooks_site_id_fkey FOREIGN KEY (site_id) REFERENCES public.sites(id) ON DELETE CASCADE;


--
-- TOC entry 4684 (class 2606 OID 16572)
-- Name: objects objects_bucketId_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.objects
    ADD CONSTRAINT "objects_bucketId_fkey" FOREIGN KEY (bucket_id) REFERENCES storage.buckets(id);


--
-- TOC entry 4696 (class 2606 OID 17066)
-- Name: s3_multipart_uploads s3_multipart_uploads_bucket_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.s3_multipart_uploads
    ADD CONSTRAINT s3_multipart_uploads_bucket_id_fkey FOREIGN KEY (bucket_id) REFERENCES storage.buckets(id);


--
-- TOC entry 4697 (class 2606 OID 17086)
-- Name: s3_multipart_uploads_parts s3_multipart_uploads_parts_bucket_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.s3_multipart_uploads_parts
    ADD CONSTRAINT s3_multipart_uploads_parts_bucket_id_fkey FOREIGN KEY (bucket_id) REFERENCES storage.buckets(id);


--
-- TOC entry 4698 (class 2606 OID 17081)
-- Name: s3_multipart_uploads_parts s3_multipart_uploads_parts_upload_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.s3_multipart_uploads_parts
    ADD CONSTRAINT s3_multipart_uploads_parts_upload_id_fkey FOREIGN KEY (upload_id) REFERENCES storage.s3_multipart_uploads(id) ON DELETE CASCADE;


--
-- TOC entry 4703 (class 2606 OID 52069)
-- Name: vector_indexes vector_indexes_bucket_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.vector_indexes
    ADD CONSTRAINT vector_indexes_bucket_id_fkey FOREIGN KEY (bucket_id) REFERENCES storage.buckets_vectors(id);


--
-- TOC entry 4941 (class 0 OID 16525)
-- Dependencies: 298
-- Name: audit_log_entries; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.audit_log_entries ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4955 (class 0 OID 16927)
-- Dependencies: 315
-- Name: flow_state; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.flow_state ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4946 (class 0 OID 16725)
-- Dependencies: 306
-- Name: identities; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.identities ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4940 (class 0 OID 16518)
-- Dependencies: 297
-- Name: instances; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.instances ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4950 (class 0 OID 16814)
-- Dependencies: 310
-- Name: mfa_amr_claims; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.mfa_amr_claims ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4949 (class 0 OID 16802)
-- Dependencies: 309
-- Name: mfa_challenges; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.mfa_challenges ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4948 (class 0 OID 16789)
-- Dependencies: 308
-- Name: mfa_factors; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.mfa_factors ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4956 (class 0 OID 16977)
-- Dependencies: 316
-- Name: one_time_tokens; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.one_time_tokens ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4939 (class 0 OID 16507)
-- Dependencies: 296
-- Name: refresh_tokens; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.refresh_tokens ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4953 (class 0 OID 16856)
-- Dependencies: 313
-- Name: saml_providers; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.saml_providers ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4954 (class 0 OID 16874)
-- Dependencies: 314
-- Name: saml_relay_states; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.saml_relay_states ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4942 (class 0 OID 16533)
-- Dependencies: 299
-- Name: schema_migrations; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.schema_migrations ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4947 (class 0 OID 16755)
-- Dependencies: 307
-- Name: sessions; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.sessions ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4952 (class 0 OID 16841)
-- Dependencies: 312
-- Name: sso_domains; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.sso_domains ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4951 (class 0 OID 16832)
-- Dependencies: 311
-- Name: sso_providers; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.sso_providers ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4938 (class 0 OID 16495)
-- Dependencies: 294
-- Name: users; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.users ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 5024 (class 3256 OID 116122)
-- Name: ad_clicks Allow insert for anon users; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Allow insert for anon users" ON public.ad_clicks FOR INSERT TO anon WITH CHECK (true);


--
-- TOC entry 5009 (class 3256 OID 116119)
-- Name: ad_impressions Allow insert for anon users; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Allow insert for anon users" ON public.ad_impressions FOR INSERT TO anon WITH CHECK (true);


--
-- TOC entry 5111 (class 3256 OID 116116)
-- Name: page_views Allow insert for anon users; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Allow insert for anon users" ON public.page_views FOR INSERT TO anon WITH CHECK (true);


--
-- TOC entry 5023 (class 3256 OID 116121)
-- Name: ad_clicks Allow insert for authenticated users; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Allow insert for authenticated users" ON public.ad_clicks FOR INSERT TO authenticated WITH CHECK (true);


--
-- TOC entry 5008 (class 3256 OID 116118)
-- Name: ad_impressions Allow insert for authenticated users; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Allow insert for authenticated users" ON public.ad_impressions FOR INSERT TO authenticated WITH CHECK (true);


--
-- TOC entry 5110 (class 3256 OID 116115)
-- Name: page_views Allow insert for authenticated users; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Allow insert for authenticated users" ON public.page_views FOR INSERT TO authenticated WITH CHECK (true);


--
-- TOC entry 5041 (class 3256 OID 116123)
-- Name: ad_clicks Allow select for site members; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Allow select for site members" ON public.ad_clicks FOR SELECT TO authenticated USING ((EXISTS ( SELECT 1
   FROM (public.ads_campaigns
     JOIN public.site_members ON ((site_members.site_id = ads_campaigns.site_id)))
  WHERE ((ads_campaigns.id = ad_clicks.campaign_id) AND (site_members.user_id = auth.uid())))));


--
-- TOC entry 5010 (class 3256 OID 116120)
-- Name: ad_impressions Allow select for site members; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Allow select for site members" ON public.ad_impressions FOR SELECT TO authenticated USING ((EXISTS ( SELECT 1
   FROM public.site_members
  WHERE ((site_members.site_id = ad_impressions.site_id) AND (site_members.user_id = auth.uid())))));


--
-- TOC entry 5007 (class 3256 OID 116117)
-- Name: page_views Allow select for site members; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Allow select for site members" ON public.page_views FOR SELECT TO authenticated USING ((EXISTS ( SELECT 1
   FROM public.site_members
  WHERE ((site_members.site_id = page_views.site_id) AND (site_members.user_id = auth.uid())))));


--
-- TOC entry 4993 (class 3256 OID 112486)
-- Name: event_categories Anyone can view active event categories; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Anyone can view active event categories" ON public.event_categories FOR SELECT USING ((is_active = true));


--
-- TOC entry 4995 (class 3256 OID 112488)
-- Name: event_categories Connect admins can manage event categories; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Connect admins can manage event categories" ON public.event_categories USING ((EXISTS ( SELECT 1
   FROM public.platform_roles
  WHERE ((platform_roles.user_id = auth.uid()) AND (platform_roles.role = 'connect_admin'::public.platform_role)))));


--
-- TOC entry 5006 (class 3256 OID 112490)
-- Name: event_categories Site admins can manage event categories; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Site admins can manage event categories" ON public.event_categories USING ((EXISTS ( SELECT 1
   FROM public.site_members
  WHERE ((site_members.site_id = event_categories.site_id) AND (site_members.user_id = auth.uid()) AND (site_members.role = ANY (ARRAY['admin'::public.member_role, 'editor'::public.member_role]))))));


--
-- TOC entry 4994 (class 3256 OID 112487)
-- Name: event_categories Super admins can manage all event categories; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Super admins can manage all event categories" ON public.event_categories USING ((EXISTS ( SELECT 1
   FROM public.platform_roles
  WHERE ((platform_roles.user_id = auth.uid()) AND (platform_roles.role = 'super_admin'::public.platform_role)))));


--
-- TOC entry 4996 (class 3256 OID 112489)
-- Name: event_categories User admins can manage event categories for their sites; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "User admins can manage event categories for their sites" ON public.event_categories USING ((EXISTS ( SELECT 1
   FROM public.platform_roles
  WHERE ((platform_roles.user_id = auth.uid()) AND (platform_roles.role = 'user_admin'::public.platform_role)))));


--
-- TOC entry 4992 (class 0 OID 116080)
-- Dependencies: 368
-- Name: ad_clicks; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.ad_clicks ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4991 (class 0 OID 116046)
-- Dependencies: 367
-- Name: ad_impressions; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.ad_impressions ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4982 (class 0 OID 109121)
-- Dependencies: 355
-- Name: ads_advertisers; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.ads_advertisers ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 5046 (class 3256 OID 109881)
-- Name: ads_advertisers ads_advertisers_editor_crud; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY ads_advertisers_editor_crud ON public.ads_advertisers TO authenticated USING (public.is_site_member(site_id, ARRAY['owner'::public.member_role, 'admin'::public.member_role, 'editor'::public.member_role])) WITH CHECK (public.is_site_member(site_id, ARRAY['owner'::public.member_role, 'admin'::public.member_role, 'editor'::public.member_role]));


--
-- TOC entry 5261 (class 0 OID 0)
-- Dependencies: 5046
-- Name: POLICY ads_advertisers_editor_crud ON ads_advertisers; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON POLICY ads_advertisers_editor_crud ON public.ads_advertisers IS 'Allows owners, admins, and editors to manage advertisers for their sites';


--
-- TOC entry 5088 (class 3256 OID 111176)
-- Name: ads_advertisers ads_advertisers_member_read; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY ads_advertisers_member_read ON public.ads_advertisers FOR SELECT TO authenticated USING ((EXISTS ( SELECT 1
   FROM public.site_members sm
  WHERE ((sm.site_id = ads_advertisers.site_id) AND (sm.user_id = auth.uid())))));


--
-- TOC entry 5089 (class 3256 OID 111177)
-- Name: ads_advertisers ads_advertisers_member_write; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY ads_advertisers_member_write ON public.ads_advertisers TO authenticated USING ((EXISTS ( SELECT 1
   FROM public.site_members sm
  WHERE ((sm.site_id = ads_advertisers.site_id) AND (sm.user_id = auth.uid()) AND (sm.role = ANY (ARRAY['owner'::public.member_role, 'admin'::public.member_role])))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM public.site_members sm
  WHERE ((sm.site_id = ads_advertisers.site_id) AND (sm.user_id = auth.uid()) AND (sm.role = ANY (ARRAY['owner'::public.member_role, 'admin'::public.member_role]))))));


--
-- TOC entry 5069 (class 3256 OID 115888)
-- Name: ads_advertisers ads_advertisers_public_read; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY ads_advertisers_public_read ON public.ads_advertisers FOR SELECT TO authenticated, anon USING (true);


--
-- TOC entry 4984 (class 0 OID 109159)
-- Dependencies: 357
-- Name: ads_campaigns; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.ads_campaigns ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 5048 (class 3256 OID 109883)
-- Name: ads_campaigns ads_campaigns_editor_crud; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY ads_campaigns_editor_crud ON public.ads_campaigns TO authenticated USING (public.is_site_member(site_id, ARRAY['owner'::public.member_role, 'admin'::public.member_role, 'editor'::public.member_role])) WITH CHECK (public.is_site_member(site_id, ARRAY['owner'::public.member_role, 'admin'::public.member_role, 'editor'::public.member_role]));


--
-- TOC entry 5262 (class 0 OID 0)
-- Dependencies: 5048
-- Name: POLICY ads_campaigns_editor_crud ON ads_campaigns; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON POLICY ads_campaigns_editor_crud ON public.ads_campaigns IS 'Allows owners, admins, and editors to manage campaigns for their sites';


--
-- TOC entry 5090 (class 3256 OID 111179)
-- Name: ads_campaigns ads_campaigns_member_read; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY ads_campaigns_member_read ON public.ads_campaigns FOR SELECT TO authenticated USING ((EXISTS ( SELECT 1
   FROM public.site_members sm
  WHERE ((sm.site_id = ads_campaigns.site_id) AND (sm.user_id = auth.uid())))));


--
-- TOC entry 5091 (class 3256 OID 111180)
-- Name: ads_campaigns ads_campaigns_member_write; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY ads_campaigns_member_write ON public.ads_campaigns TO authenticated USING ((EXISTS ( SELECT 1
   FROM public.site_members sm
  WHERE ((sm.site_id = ads_campaigns.site_id) AND (sm.user_id = auth.uid()) AND (sm.role = ANY (ARRAY['owner'::public.member_role, 'admin'::public.member_role])))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM public.site_members sm
  WHERE ((sm.site_id = ads_campaigns.site_id) AND (sm.user_id = auth.uid()) AND (sm.role = ANY (ARRAY['owner'::public.member_role, 'admin'::public.member_role]))))));


--
-- TOC entry 5067 (class 3256 OID 115886)
-- Name: ads_campaigns ads_campaigns_public_read; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY ads_campaigns_public_read ON public.ads_campaigns FOR SELECT TO authenticated, anon USING (((status = 'active'::public.ads_campaign_status) AND ((starts_at IS NULL) OR (starts_at <= now())) AND ((ends_at IS NULL) OR (ends_at >= now()))));


--
-- TOC entry 4985 (class 0 OID 109189)
-- Dependencies: 358
-- Name: ads_creatives; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.ads_creatives ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 5057 (class 3256 OID 109884)
-- Name: ads_creatives ads_creatives_editor_crud; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY ads_creatives_editor_crud ON public.ads_creatives TO authenticated USING ((EXISTS ( SELECT 1
   FROM public.ads_campaigns c
  WHERE ((c.id = ads_creatives.campaign_id) AND public.is_site_member(c.site_id, ARRAY['owner'::public.member_role, 'admin'::public.member_role, 'editor'::public.member_role]))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM public.ads_campaigns c
  WHERE ((c.id = ads_creatives.campaign_id) AND public.is_site_member(c.site_id, ARRAY['owner'::public.member_role, 'admin'::public.member_role, 'editor'::public.member_role])))));


--
-- TOC entry 5263 (class 0 OID 0)
-- Dependencies: 5057
-- Name: POLICY ads_creatives_editor_crud ON ads_creatives; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON POLICY ads_creatives_editor_crud ON public.ads_creatives IS 'Allows owners, admins, and editors to manage creatives for campaigns on their sites';


--
-- TOC entry 5092 (class 3256 OID 111182)
-- Name: ads_creatives ads_creatives_member_read; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY ads_creatives_member_read ON public.ads_creatives FOR SELECT TO authenticated USING ((EXISTS ( SELECT 1
   FROM public.ads_campaigns c
  WHERE ((c.id = ads_creatives.campaign_id) AND (EXISTS ( SELECT 1
           FROM public.site_members sm
          WHERE ((sm.site_id = c.site_id) AND (sm.user_id = auth.uid()))))))));


--
-- TOC entry 5093 (class 3256 OID 111183)
-- Name: ads_creatives ads_creatives_member_write; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY ads_creatives_member_write ON public.ads_creatives TO authenticated USING ((EXISTS ( SELECT 1
   FROM public.ads_campaigns c
  WHERE ((c.id = ads_creatives.campaign_id) AND (EXISTS ( SELECT 1
           FROM public.site_members sm
          WHERE ((sm.site_id = c.site_id) AND (sm.user_id = auth.uid()) AND (sm.role = ANY (ARRAY['owner'::public.member_role, 'admin'::public.member_role]))))))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM public.ads_campaigns c
  WHERE ((c.id = ads_creatives.campaign_id) AND (EXISTS ( SELECT 1
           FROM public.site_members sm
          WHERE ((sm.site_id = c.site_id) AND (sm.user_id = auth.uid()) AND (sm.role = ANY (ARRAY['owner'::public.member_role, 'admin'::public.member_role])))))))));


--
-- TOC entry 5068 (class 3256 OID 115887)
-- Name: ads_creatives ads_creatives_public_read; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY ads_creatives_public_read ON public.ads_creatives FOR SELECT TO authenticated, anon USING ((is_active = true));


--
-- TOC entry 4983 (class 0 OID 109140)
-- Dependencies: 356
-- Name: ads_slots; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.ads_slots ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 5047 (class 3256 OID 109882)
-- Name: ads_slots ads_slots_editor_crud; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY ads_slots_editor_crud ON public.ads_slots TO authenticated USING (public.is_site_member(site_id, ARRAY['owner'::public.member_role, 'admin'::public.member_role, 'editor'::public.member_role])) WITH CHECK (public.is_site_member(site_id, ARRAY['owner'::public.member_role, 'admin'::public.member_role, 'editor'::public.member_role]));


--
-- TOC entry 5264 (class 0 OID 0)
-- Dependencies: 5047
-- Name: POLICY ads_slots_editor_crud ON ads_slots; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON POLICY ads_slots_editor_crud ON public.ads_slots IS 'Allows owners, admins, and editors to manage advertising slots for their sites';


--
-- TOC entry 5094 (class 3256 OID 111185)
-- Name: ads_slots ads_slots_member_read; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY ads_slots_member_read ON public.ads_slots FOR SELECT TO authenticated USING ((EXISTS ( SELECT 1
   FROM public.site_members sm
  WHERE ((sm.site_id = ads_slots.site_id) AND (sm.user_id = auth.uid())))));


--
-- TOC entry 5095 (class 3256 OID 111186)
-- Name: ads_slots ads_slots_member_write; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY ads_slots_member_write ON public.ads_slots TO authenticated USING ((EXISTS ( SELECT 1
   FROM public.site_members sm
  WHERE ((sm.site_id = ads_slots.site_id) AND (sm.user_id = auth.uid()) AND (sm.role = ANY (ARRAY['owner'::public.member_role, 'admin'::public.member_role])))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM public.site_members sm
  WHERE ((sm.site_id = ads_slots.site_id) AND (sm.user_id = auth.uid()) AND (sm.role = ANY (ARRAY['owner'::public.member_role, 'admin'::public.member_role]))))));


--
-- TOC entry 5066 (class 3256 OID 115885)
-- Name: ads_slots ads_slots_public_read; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY ads_slots_public_read ON public.ads_slots FOR SELECT TO authenticated, anon USING ((is_active = true));


--
-- TOC entry 4979 (class 0 OID 106734)
-- Dependencies: 352
-- Name: api_keys; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.api_keys ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 5071 (class 3256 OID 106868)
-- Name: api_keys api_keys_admin_read; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY api_keys_admin_read ON public.api_keys FOR SELECT TO authenticated USING (public.is_site_member(site_id, ARRAY['owner'::public.member_role, 'admin'::public.member_role]));


--
-- TOC entry 5070 (class 3256 OID 111142)
-- Name: api_keys api_keys_own; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY api_keys_own ON public.api_keys TO authenticated USING (((created_by = auth.uid()) OR (EXISTS ( SELECT 1
   FROM public.site_members sm
  WHERE ((sm.site_id = api_keys.site_id) AND (sm.user_id = auth.uid()) AND (sm.role = ANY (ARRAY['owner'::public.member_role, 'admin'::public.member_role]))))))) WITH CHECK (((created_by = auth.uid()) OR (EXISTS ( SELECT 1
   FROM public.site_members sm
  WHERE ((sm.site_id = api_keys.site_id) AND (sm.user_id = auth.uid()) AND (sm.role = ANY (ARRAY['owner'::public.member_role, 'admin'::public.member_role])))))));


--
-- TOC entry 5072 (class 3256 OID 106869)
-- Name: api_keys api_keys_service_write; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY api_keys_service_write ON public.api_keys TO service_role USING (true) WITH CHECK (true);


--
-- TOC entry 4978 (class 0 OID 106708)
-- Dependencies: 351
-- Name: audit_logs; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.audit_logs ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4999 (class 3256 OID 111144)
-- Name: audit_logs audit_logs_own_read; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY audit_logs_own_read ON public.audit_logs FOR SELECT TO authenticated USING (((actor_user_id = auth.uid()) OR public.is_connect_admin()));


--
-- TOC entry 5064 (class 3256 OID 106855)
-- Name: audit_logs audit_logs_service_insert; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY audit_logs_service_insert ON public.audit_logs FOR INSERT TO service_role WITH CHECK (true);


--
-- TOC entry 4988 (class 0 OID 112465)
-- Dependencies: 362
-- Name: event_categories; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.event_categories ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4972 (class 0 OID 106533)
-- Dependencies: 344
-- Name: events; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.events ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 5045 (class 3256 OID 106560)
-- Name: events events_editor_crud; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY events_editor_crud ON public.events TO authenticated USING (public.is_site_member(site_id, ARRAY['owner'::public.member_role, 'admin'::public.member_role, 'editor'::public.member_role])) WITH CHECK (public.is_site_member(site_id, ARRAY['owner'::public.member_role, 'admin'::public.member_role, 'editor'::public.member_role]));


--
-- TOC entry 5078 (class 3256 OID 111159)
-- Name: events events_member_read; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY events_member_read ON public.events FOR SELECT TO authenticated USING (((status = 'published'::public.event_status) OR (EXISTS ( SELECT 1
   FROM public.site_members sm
  WHERE ((sm.site_id = events.site_id) AND (sm.user_id = auth.uid()))))));


--
-- TOC entry 5079 (class 3256 OID 111160)
-- Name: events events_member_write; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY events_member_write ON public.events TO authenticated USING ((EXISTS ( SELECT 1
   FROM public.site_members sm
  WHERE ((sm.site_id = events.site_id) AND (sm.user_id = auth.uid()) AND (sm.role = ANY (ARRAY['owner'::public.member_role, 'admin'::public.member_role, 'editor'::public.member_role])))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM public.site_members sm
  WHERE ((sm.site_id = events.site_id) AND (sm.user_id = auth.uid()) AND (sm.role = ANY (ARRAY['owner'::public.member_role, 'admin'::public.member_role, 'editor'::public.member_role]))))));


--
-- TOC entry 5044 (class 3256 OID 106559)
-- Name: events events_public_read_published; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY events_public_read_published ON public.events FOR SELECT USING ((status = 'published'::public.event_status));


--
-- TOC entry 4989 (class 0 OID 114742)
-- Dependencies: 363
-- Name: hero_banners; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.hero_banners ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 5025 (class 3256 OID 114772)
-- Name: hero_banners hero_banners_member_write; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY hero_banners_member_write ON public.hero_banners TO authenticated USING ((EXISTS ( SELECT 1
   FROM public.site_members sm
  WHERE ((sm.site_id = hero_banners.site_id) AND (sm.user_id = auth.uid()) AND (sm.role = ANY (ARRAY['owner'::public.member_role, 'admin'::public.member_role, 'editor'::public.member_role])))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM public.site_members sm
  WHERE ((sm.site_id = hero_banners.site_id) AND (sm.user_id = auth.uid()) AND (sm.role = ANY (ARRAY['owner'::public.member_role, 'admin'::public.member_role, 'editor'::public.member_role]))))));


--
-- TOC entry 5065 (class 3256 OID 115884)
-- Name: hero_banners hero_banners_public_read; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY hero_banners_public_read ON public.hero_banners FOR SELECT TO authenticated, anon USING (((is_active = true) AND ((starts_at IS NULL) OR (starts_at <= now())) AND ((ends_at IS NULL) OR (ends_at >= now()))));


--
-- TOC entry 4970 (class 0 OID 106435)
-- Dependencies: 342
-- Name: media; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.media ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 5029 (class 3256 OID 106515)
-- Name: media media_editor_crud; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY media_editor_crud ON public.media TO authenticated USING (public.is_site_member(site_id, ARRAY['owner'::public.member_role, 'admin'::public.member_role, 'editor'::public.member_role])) WITH CHECK (public.is_site_member(site_id, ARRAY['owner'::public.member_role, 'admin'::public.member_role, 'editor'::public.member_role]));


--
-- TOC entry 5082 (class 3256 OID 111165)
-- Name: media media_member_read; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY media_member_read ON public.media FOR SELECT TO authenticated USING ((EXISTS ( SELECT 1
   FROM public.site_members sm
  WHERE ((sm.site_id = media.site_id) AND (sm.user_id = auth.uid())))));


--
-- TOC entry 5083 (class 3256 OID 111166)
-- Name: media media_member_write; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY media_member_write ON public.media TO authenticated USING ((EXISTS ( SELECT 1
   FROM public.site_members sm
  WHERE ((sm.site_id = media.site_id) AND (sm.user_id = auth.uid()) AND (sm.role = ANY (ARRAY['owner'::public.member_role, 'admin'::public.member_role, 'editor'::public.member_role])))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM public.site_members sm
  WHERE ((sm.site_id = media.site_id) AND (sm.user_id = auth.uid()) AND (sm.role = ANY (ARRAY['owner'::public.member_role, 'admin'::public.member_role, 'editor'::public.member_role]))))));


--
-- TOC entry 5028 (class 3256 OID 106514)
-- Name: media media_public_read_active; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY media_public_read_active ON public.media FOR SELECT USING ((is_active = true));


--
-- TOC entry 4990 (class 0 OID 116024)
-- Dependencies: 366
-- Name: page_views; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.page_views ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4966 (class 0 OID 106296)
-- Dependencies: 338
-- Name: place_categories; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.place_categories ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 5033 (class 3256 OID 106519)
-- Name: place_categories place_categories_editor_crud; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY place_categories_editor_crud ON public.place_categories TO authenticated USING (public.is_site_member(site_id, ARRAY['owner'::public.member_role, 'admin'::public.member_role, 'editor'::public.member_role])) WITH CHECK (public.is_site_member(site_id, ARRAY['owner'::public.member_role, 'admin'::public.member_role, 'editor'::public.member_role]));


--
-- TOC entry 5086 (class 3256 OID 111172)
-- Name: place_categories place_categories_member_all; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY place_categories_member_all ON public.place_categories TO authenticated USING ((EXISTS ( SELECT 1
   FROM public.site_members sm
  WHERE ((sm.site_id = place_categories.site_id) AND (sm.user_id = auth.uid()) AND (sm.role = ANY (ARRAY['owner'::public.member_role, 'admin'::public.member_role, 'editor'::public.member_role])))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM public.site_members sm
  WHERE ((sm.site_id = place_categories.site_id) AND (sm.user_id = auth.uid()) AND (sm.role = ANY (ARRAY['owner'::public.member_role, 'admin'::public.member_role, 'editor'::public.member_role]))))));


--
-- TOC entry 5032 (class 3256 OID 106518)
-- Name: place_categories place_categories_public_read_active; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY place_categories_public_read_active ON public.place_categories FOR SELECT USING ((is_active = true));


--
-- TOC entry 4968 (class 0 OID 106339)
-- Dependencies: 340
-- Name: place_media; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.place_media ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 5038 (class 3256 OID 106523)
-- Name: place_media place_media_editor_crud; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY place_media_editor_crud ON public.place_media TO authenticated USING ((EXISTS ( SELECT 1
   FROM public.places p
  WHERE ((p.id = place_media.place_id) AND public.is_site_member(p.site_id, ARRAY['owner'::public.member_role, 'admin'::public.member_role, 'editor'::public.member_role]))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM public.places p
  WHERE ((p.id = place_media.place_id) AND public.is_site_member(p.site_id, ARRAY['owner'::public.member_role, 'admin'::public.member_role, 'editor'::public.member_role])))));


--
-- TOC entry 5037 (class 3256 OID 106522)
-- Name: place_media place_media_public_read_when_place_published; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY place_media_public_read_when_place_published ON public.place_media FOR SELECT USING ((EXISTS ( SELECT 1
   FROM public.places p
  WHERE ((p.id = place_media.place_id) AND (p.status = 'published'::public.place_status)))));


--
-- TOC entry 4967 (class 0 OID 106315)
-- Dependencies: 339
-- Name: places; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.places ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 5036 (class 3256 OID 106521)
-- Name: places places_editor_crud; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY places_editor_crud ON public.places TO authenticated USING (public.is_site_member(site_id, ARRAY['owner'::public.member_role, 'admin'::public.member_role, 'editor'::public.member_role])) WITH CHECK (public.is_site_member(site_id, ARRAY['owner'::public.member_role, 'admin'::public.member_role, 'editor'::public.member_role]));


--
-- TOC entry 5080 (class 3256 OID 111162)
-- Name: places places_member_read; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY places_member_read ON public.places FOR SELECT TO authenticated USING (((status = 'published'::public.place_status) OR (EXISTS ( SELECT 1
   FROM public.site_members sm
  WHERE ((sm.site_id = places.site_id) AND (sm.user_id = auth.uid()))))));


--
-- TOC entry 5081 (class 3256 OID 111163)
-- Name: places places_member_write; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY places_member_write ON public.places TO authenticated USING ((EXISTS ( SELECT 1
   FROM public.site_members sm
  WHERE ((sm.site_id = places.site_id) AND (sm.user_id = auth.uid()) AND (sm.role = ANY (ARRAY['owner'::public.member_role, 'admin'::public.member_role, 'editor'::public.member_role])))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM public.site_members sm
  WHERE ((sm.site_id = places.site_id) AND (sm.user_id = auth.uid()) AND (sm.role = ANY (ARRAY['owner'::public.member_role, 'admin'::public.member_role, 'editor'::public.member_role]))))));


--
-- TOC entry 5034 (class 3256 OID 106520)
-- Name: places places_public_read_published; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY places_public_read_published ON public.places FOR SELECT USING ((status = 'published'::public.place_status));


--
-- TOC entry 4986 (class 0 OID 109927)
-- Dependencies: 359
-- Name: platform_roles; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.platform_roles ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 5101 (class 3256 OID 111305)
-- Name: platform_roles platform_roles_access; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY platform_roles_access ON public.platform_roles TO authenticated USING (((user_id = auth.uid()) OR public.is_connect_admin() OR public.is_super_admin())) WITH CHECK (public.is_super_admin());


--
-- TOC entry 4973 (class 0 OID 106561)
-- Dependencies: 345
-- Name: post_categories; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.post_categories ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 5052 (class 3256 OID 106583)
-- Name: post_categories post_categories_editor_crud; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY post_categories_editor_crud ON public.post_categories TO authenticated USING (public.is_site_member(site_id, ARRAY['owner'::public.member_role, 'admin'::public.member_role, 'editor'::public.member_role])) WITH CHECK (public.is_site_member(site_id, ARRAY['owner'::public.member_role, 'admin'::public.member_role, 'editor'::public.member_role]));


--
-- TOC entry 5084 (class 3256 OID 111168)
-- Name: post_categories post_categories_member_all; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY post_categories_member_all ON public.post_categories TO authenticated USING ((EXISTS ( SELECT 1
   FROM public.site_members sm
  WHERE ((sm.site_id = post_categories.site_id) AND (sm.user_id = auth.uid()) AND (sm.role = ANY (ARRAY['owner'::public.member_role, 'admin'::public.member_role, 'editor'::public.member_role])))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM public.site_members sm
  WHERE ((sm.site_id = post_categories.site_id) AND (sm.user_id = auth.uid()) AND (sm.role = ANY (ARRAY['owner'::public.member_role, 'admin'::public.member_role, 'editor'::public.member_role]))))));


--
-- TOC entry 5051 (class 3256 OID 106582)
-- Name: post_categories post_categories_public_read_active; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY post_categories_public_read_active ON public.post_categories FOR SELECT USING ((is_active = true));


--
-- TOC entry 4975 (class 0 OID 106606)
-- Dependencies: 347
-- Name: post_tag_links; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.post_tag_links ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 5056 (class 3256 OID 106622)
-- Name: post_tag_links post_tag_links_editor_crud; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY post_tag_links_editor_crud ON public.post_tag_links TO authenticated USING ((EXISTS ( SELECT 1
   FROM public.posts p
  WHERE ((p.id = post_tag_links.post_id) AND public.is_site_member(p.site_id, ARRAY['owner'::public.member_role, 'admin'::public.member_role, 'editor'::public.member_role]))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM public.posts p
  WHERE ((p.id = post_tag_links.post_id) AND public.is_site_member(p.site_id, ARRAY['owner'::public.member_role, 'admin'::public.member_role, 'editor'::public.member_role])))));


--
-- TOC entry 5055 (class 3256 OID 106621)
-- Name: post_tag_links post_tag_links_public_read_when_post_published; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY post_tag_links_public_read_when_post_published ON public.post_tag_links FOR SELECT USING ((EXISTS ( SELECT 1
   FROM public.posts p
  WHERE ((p.id = post_tag_links.post_id) AND (p.status = 'published'::public.place_status)))));


--
-- TOC entry 4974 (class 0 OID 106584)
-- Dependencies: 346
-- Name: post_tags; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.post_tags ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 5054 (class 3256 OID 106605)
-- Name: post_tags post_tags_editor_crud; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY post_tags_editor_crud ON public.post_tags TO authenticated USING (public.is_site_member(site_id, ARRAY['owner'::public.member_role, 'admin'::public.member_role, 'editor'::public.member_role])) WITH CHECK (public.is_site_member(site_id, ARRAY['owner'::public.member_role, 'admin'::public.member_role, 'editor'::public.member_role]));


--
-- TOC entry 5085 (class 3256 OID 111170)
-- Name: post_tags post_tags_member_all; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY post_tags_member_all ON public.post_tags TO authenticated USING ((EXISTS ( SELECT 1
   FROM public.site_members sm
  WHERE ((sm.site_id = post_tags.site_id) AND (sm.user_id = auth.uid()) AND (sm.role = ANY (ARRAY['owner'::public.member_role, 'admin'::public.member_role, 'editor'::public.member_role])))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM public.site_members sm
  WHERE ((sm.site_id = post_tags.site_id) AND (sm.user_id = auth.uid()) AND (sm.role = ANY (ARRAY['owner'::public.member_role, 'admin'::public.member_role, 'editor'::public.member_role]))))));


--
-- TOC entry 5053 (class 3256 OID 106604)
-- Name: post_tags post_tags_public_read_active; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY post_tags_public_read_active ON public.post_tags FOR SELECT USING ((is_active = true));


--
-- TOC entry 4969 (class 0 OID 106355)
-- Dependencies: 341
-- Name: posts; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.posts ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 5031 (class 3256 OID 106517)
-- Name: posts posts_editor_crud; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY posts_editor_crud ON public.posts TO authenticated USING (public.is_site_member(site_id, ARRAY['owner'::public.member_role, 'admin'::public.member_role, 'editor'::public.member_role])) WITH CHECK (public.is_site_member(site_id, ARRAY['owner'::public.member_role, 'admin'::public.member_role, 'editor'::public.member_role]));


--
-- TOC entry 5076 (class 3256 OID 111156)
-- Name: posts posts_member_read; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY posts_member_read ON public.posts FOR SELECT TO authenticated USING (((status = 'published'::public.place_status) OR (EXISTS ( SELECT 1
   FROM public.site_members sm
  WHERE ((sm.site_id = posts.site_id) AND (sm.user_id = auth.uid()))))));


--
-- TOC entry 5077 (class 3256 OID 111157)
-- Name: posts posts_member_write; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY posts_member_write ON public.posts TO authenticated USING ((EXISTS ( SELECT 1
   FROM public.site_members sm
  WHERE ((sm.site_id = posts.site_id) AND (sm.user_id = auth.uid()) AND (sm.role = ANY (ARRAY['owner'::public.member_role, 'admin'::public.member_role, 'editor'::public.member_role])))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM public.site_members sm
  WHERE ((sm.site_id = posts.site_id) AND (sm.user_id = auth.uid()) AND (sm.role = ANY (ARRAY['owner'::public.member_role, 'admin'::public.member_role, 'editor'::public.member_role]))))));


--
-- TOC entry 5030 (class 3256 OID 106516)
-- Name: posts posts_public_read_published; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY posts_public_read_published ON public.posts FOR SELECT USING ((status = 'published'::public.place_status));


--
-- TOC entry 4964 (class 0 OID 106266)
-- Dependencies: 336
-- Name: profiles; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 5096 (class 3256 OID 111239)
-- Name: profiles profiles_own; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY profiles_own ON public.profiles TO authenticated USING ((user_id = auth.uid())) WITH CHECK ((user_id = auth.uid()));


--
-- TOC entry 5062 (class 3256 OID 115882)
-- Name: sites public read sites; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "public read sites" ON public.sites FOR SELECT TO authenticated, anon USING ((is_active = true));


--
-- TOC entry 4971 (class 0 OID 106471)
-- Dependencies: 343
-- Name: site_content; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.site_content ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 5027 (class 3256 OID 106513)
-- Name: site_content site_content_editor_crud; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY site_content_editor_crud ON public.site_content TO authenticated USING (public.is_site_member(site_id, ARRAY['owner'::public.member_role, 'admin'::public.member_role, 'editor'::public.member_role])) WITH CHECK (public.is_site_member(site_id, ARRAY['owner'::public.member_role, 'admin'::public.member_role, 'editor'::public.member_role]));


--
-- TOC entry 5087 (class 3256 OID 111174)
-- Name: site_content site_content_member_all; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY site_content_member_all ON public.site_content TO authenticated USING ((EXISTS ( SELECT 1
   FROM public.site_members sm
  WHERE ((sm.site_id = site_content.site_id) AND (sm.user_id = auth.uid()) AND (sm.role = ANY (ARRAY['owner'::public.member_role, 'admin'::public.member_role, 'editor'::public.member_role])))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM public.site_members sm
  WHERE ((sm.site_id = site_content.site_id) AND (sm.user_id = auth.uid()) AND (sm.role = ANY (ARRAY['owner'::public.member_role, 'admin'::public.member_role, 'editor'::public.member_role]))))));


--
-- TOC entry 5063 (class 3256 OID 111099)
-- Name: site_content site_content_public_read; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY site_content_public_read ON public.site_content FOR SELECT TO authenticated, anon USING ((is_active = true));


--
-- TOC entry 5026 (class 3256 OID 106512)
-- Name: site_content site_content_public_read_active; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY site_content_public_read_active ON public.site_content FOR SELECT USING ((is_active = true));


--
-- TOC entry 4965 (class 0 OID 106279)
-- Dependencies: 337
-- Name: site_members; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.site_members ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 5100 (class 3256 OID 111273)
-- Name: site_members site_members_delete; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY site_members_delete ON public.site_members FOR DELETE TO authenticated USING (public.is_site_member_no_rls(site_id, ARRAY['owner'::public.member_role, 'admin'::public.member_role]));


--
-- TOC entry 5098 (class 3256 OID 111271)
-- Name: site_members site_members_insert; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY site_members_insert ON public.site_members FOR INSERT TO authenticated WITH CHECK (public.is_site_member_no_rls(site_id, ARRAY['owner'::public.member_role, 'admin'::public.member_role]));


--
-- TOC entry 5097 (class 3256 OID 111270)
-- Name: site_members site_members_select; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY site_members_select ON public.site_members FOR SELECT TO authenticated USING (public.is_site_member_no_rls(site_id, ARRAY['owner'::public.member_role, 'admin'::public.member_role, 'editor'::public.member_role, 'viewer'::public.member_role]));


--
-- TOC entry 5099 (class 3256 OID 111272)
-- Name: site_members site_members_update; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY site_members_update ON public.site_members FOR UPDATE TO authenticated USING (public.is_site_member_no_rls(site_id, ARRAY['owner'::public.member_role, 'admin'::public.member_role])) WITH CHECK (public.is_site_member_no_rls(site_id, ARRAY['owner'::public.member_role, 'admin'::public.member_role]));


--
-- TOC entry 4987 (class 0 OID 111306)
-- Dependencies: 360
-- Name: site_metrics; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.site_metrics ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 5102 (class 3256 OID 111335)
-- Name: site_metrics site_metrics_select; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY site_metrics_select ON public.site_metrics FOR SELECT TO authenticated USING (((EXISTS ( SELECT 1
   FROM public.site_members sm
  WHERE ((sm.site_id = site_metrics.site_id) AND (sm.user_id = auth.uid())))) OR public.is_super_admin() OR public.is_connect_admin()));


--
-- TOC entry 4963 (class 0 OID 106254)
-- Dependencies: 335
-- Name: sites; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.sites ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 5075 (class 3256 OID 111149)
-- Name: sites sites_admin_all; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY sites_admin_all ON public.sites TO authenticated USING ((public.is_super_admin() OR public.is_connect_admin())) WITH CHECK ((public.is_super_admin() OR public.is_connect_admin()));


--
-- TOC entry 5061 (class 3256 OID 109976)
-- Name: sites sites_delete; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY sites_delete ON public.sites FOR DELETE TO authenticated USING (public.is_super_admin());


--
-- TOC entry 5060 (class 3256 OID 109975)
-- Name: sites sites_insert; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY sites_insert ON public.sites FOR INSERT TO authenticated WITH CHECK (public.is_connect_admin());


--
-- TOC entry 5073 (class 3256 OID 111146)
-- Name: sites sites_member_read; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY sites_member_read ON public.sites FOR SELECT TO authenticated USING ((EXISTS ( SELECT 1
   FROM public.site_members sm
  WHERE ((sm.site_id = sites.id) AND (sm.user_id = auth.uid())))));


--
-- TOC entry 5074 (class 3256 OID 111147)
-- Name: sites sites_member_write; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY sites_member_write ON public.sites FOR UPDATE TO authenticated USING ((EXISTS ( SELECT 1
   FROM public.site_members sm
  WHERE ((sm.site_id = sites.id) AND (sm.user_id = auth.uid()) AND (sm.role = ANY (ARRAY['owner'::public.member_role, 'admin'::public.member_role])))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM public.site_members sm
  WHERE ((sm.site_id = sites.id) AND (sm.user_id = auth.uid()) AND (sm.role = ANY (ARRAY['owner'::public.member_role, 'admin'::public.member_role]))))));


--
-- TOC entry 5039 (class 3256 OID 114774)
-- Name: sites sites_public_read; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY sites_public_read ON public.sites FOR SELECT TO anon USING (((status = 'published'::public.site_status) AND (is_active = true)));


--
-- TOC entry 5058 (class 3256 OID 109972)
-- Name: sites sites_read; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY sites_read ON public.sites FOR SELECT TO authenticated USING ((public.is_connect_admin() OR (EXISTS ( SELECT 1
   FROM public.site_members
  WHERE ((site_members.site_id = sites.id) AND (site_members.user_id = auth.uid()))))));


--
-- TOC entry 5040 (class 3256 OID 106894)
-- Name: sites sites_service_write; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY sites_service_write ON public.sites TO service_role USING (true) WITH CHECK (true);


--
-- TOC entry 5059 (class 3256 OID 109973)
-- Name: sites sites_update; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY sites_update ON public.sites FOR UPDATE TO authenticated USING ((public.is_connect_admin() OR (EXISTS ( SELECT 1
   FROM public.site_members
  WHERE ((site_members.site_id = sites.id) AND (site_members.user_id = auth.uid()) AND (site_members.role = ANY (ARRAY['owner'::public.member_role, 'admin'::public.member_role]))))))) WITH CHECK ((public.is_connect_admin() OR (EXISTS ( SELECT 1
   FROM public.site_members
  WHERE ((site_members.site_id = sites.id) AND (site_members.user_id = auth.uid()) AND (site_members.role = ANY (ARRAY['owner'::public.member_role, 'admin'::public.member_role])))))));


--
-- TOC entry 4977 (class 0 OID 106691)
-- Dependencies: 349
-- Name: user_invitation_sites; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.user_invitation_sites ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 5106 (class 3256 OID 111356)
-- Name: user_invitation_sites user_invitation_sites_delete; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY user_invitation_sites_delete ON public.user_invitation_sites FOR DELETE TO authenticated USING (((EXISTS ( SELECT 1
   FROM public.user_invitations ui
  WHERE ((ui.id = user_invitation_sites.invitation_id) AND (ui.invited_by = auth.uid())))) OR public.is_super_admin() OR public.is_connect_admin()));


--
-- TOC entry 5104 (class 3256 OID 111354)
-- Name: user_invitation_sites user_invitation_sites_insert; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY user_invitation_sites_insert ON public.user_invitation_sites FOR INSERT TO authenticated WITH CHECK (((EXISTS ( SELECT 1
   FROM public.user_invitations ui
  WHERE ((ui.id = user_invitation_sites.invitation_id) AND (ui.invited_by = auth.uid())))) OR public.is_super_admin() OR public.is_connect_admin()));


--
-- TOC entry 5103 (class 3256 OID 111353)
-- Name: user_invitation_sites user_invitation_sites_select; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY user_invitation_sites_select ON public.user_invitation_sites FOR SELECT TO authenticated USING (((EXISTS ( SELECT 1
   FROM public.user_invitations ui
  WHERE ((ui.id = user_invitation_sites.invitation_id) AND (ui.email = (auth.jwt() ->> 'email'::text))))) OR (EXISTS ( SELECT 1
   FROM public.user_invitations ui
  WHERE ((ui.id = user_invitation_sites.invitation_id) AND (ui.invited_by = auth.uid())))) OR public.is_super_admin() OR public.is_connect_admin()));


--
-- TOC entry 5105 (class 3256 OID 111355)
-- Name: user_invitation_sites user_invitation_sites_update; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY user_invitation_sites_update ON public.user_invitation_sites FOR UPDATE TO authenticated USING ((public.is_super_admin() OR public.is_connect_admin())) WITH CHECK ((public.is_super_admin() OR public.is_connect_admin()));


--
-- TOC entry 4976 (class 0 OID 106670)
-- Dependencies: 348
-- Name: user_invitations; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.user_invitations ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 5108 (class 3256 OID 111358)
-- Name: user_invitations user_invitations_insert; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY user_invitations_insert ON public.user_invitations FOR INSERT TO authenticated WITH CHECK (((invited_by = auth.uid()) OR public.is_super_admin() OR public.is_connect_admin()));


--
-- TOC entry 5107 (class 3256 OID 111357)
-- Name: user_invitations user_invitations_select; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY user_invitations_select ON public.user_invitations FOR SELECT TO authenticated USING (((email = (auth.jwt() ->> 'email'::text)) OR (invited_by = auth.uid()) OR public.is_super_admin() OR public.is_connect_admin()));


--
-- TOC entry 5109 (class 3256 OID 111359)
-- Name: user_invitations user_invitations_update; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY user_invitations_update ON public.user_invitations FOR UPDATE TO authenticated USING (((email = (auth.jwt() ->> 'email'::text)) OR (invited_by = auth.uid()) OR public.is_super_admin() OR public.is_connect_admin())) WITH CHECK (((email = (auth.jwt() ->> 'email'::text)) OR (invited_by = auth.uid()) OR public.is_super_admin() OR public.is_connect_admin()));


--
-- TOC entry 4981 (class 0 OID 106781)
-- Dependencies: 354
-- Name: webhook_deliveries; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.webhook_deliveries ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 5004 (class 3256 OID 106887)
-- Name: webhook_deliveries webhook_deliveries_admin_read; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY webhook_deliveries_admin_read ON public.webhook_deliveries FOR SELECT TO authenticated USING (public.is_site_member(site_id, ARRAY['owner'::public.member_role, 'admin'::public.member_role]));


--
-- TOC entry 5005 (class 3256 OID 106888)
-- Name: webhook_deliveries webhook_deliveries_service_write; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY webhook_deliveries_service_write ON public.webhook_deliveries TO service_role USING (true) WITH CHECK (true);


--
-- TOC entry 4980 (class 0 OID 106757)
-- Dependencies: 353
-- Name: webhooks; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.webhooks ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4997 (class 3256 OID 106876)
-- Name: webhooks webhooks_admin_read; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY webhooks_admin_read ON public.webhooks FOR SELECT TO authenticated USING (public.is_site_member(site_id, ARRAY['owner'::public.member_role, 'admin'::public.member_role]));


--
-- TOC entry 4998 (class 3256 OID 106877)
-- Name: webhooks webhooks_service_write; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY webhooks_service_write ON public.webhooks TO service_role USING (true) WITH CHECK (true);


--
-- TOC entry 4959 (class 0 OID 17275)
-- Dependencies: 326
-- Name: messages; Type: ROW SECURITY; Schema: realtime; Owner: -
--

ALTER TABLE realtime.messages ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 5019 (class 3256 OID 17483)
-- Name: objects Advertisement images are publicly accessible; Type: POLICY; Schema: storage; Owner: -
--

CREATE POLICY "Advertisement images are publicly accessible" ON storage.objects FOR SELECT USING ((bucket_id = 'advertisements'::text));


--
-- TOC entry 5050 (class 3256 OID 19929)
-- Name: objects Advertisements bucket is publicly readable; Type: POLICY; Schema: storage; Owner: -
--

CREATE POLICY "Advertisements bucket is publicly readable" ON storage.objects FOR SELECT USING ((bucket_id = 'advertisements'::text));


--
-- TOC entry 5022 (class 3256 OID 17486)
-- Name: objects Authenticated users can delete advertisement images; Type: POLICY; Schema: storage; Owner: -
--

CREATE POLICY "Authenticated users can delete advertisement images" ON storage.objects FOR DELETE USING (((bucket_id = 'advertisements'::text) AND (auth.role() = 'authenticated'::text)));


--
-- TOC entry 5014 (class 3256 OID 17478)
-- Name: objects Authenticated users can delete establishment images; Type: POLICY; Schema: storage; Owner: -
--

CREATE POLICY "Authenticated users can delete establishment images" ON storage.objects FOR DELETE USING (((bucket_id = 'establishments'::text) AND (auth.role() = 'authenticated'::text)));


--
-- TOC entry 5018 (class 3256 OID 17482)
-- Name: objects Authenticated users can delete news images; Type: POLICY; Schema: storage; Owner: -
--

CREATE POLICY "Authenticated users can delete news images" ON storage.objects FOR DELETE USING (((bucket_id = 'news'::text) AND (auth.role() = 'authenticated'::text)));


--
-- TOC entry 5021 (class 3256 OID 17485)
-- Name: objects Authenticated users can update advertisement images; Type: POLICY; Schema: storage; Owner: -
--

CREATE POLICY "Authenticated users can update advertisement images" ON storage.objects FOR UPDATE USING (((bucket_id = 'advertisements'::text) AND (auth.role() = 'authenticated'::text)));


--
-- TOC entry 5013 (class 3256 OID 17477)
-- Name: objects Authenticated users can update establishment images; Type: POLICY; Schema: storage; Owner: -
--

CREATE POLICY "Authenticated users can update establishment images" ON storage.objects FOR UPDATE USING (((bucket_id = 'establishments'::text) AND (auth.role() = 'authenticated'::text)));


--
-- TOC entry 5017 (class 3256 OID 17481)
-- Name: objects Authenticated users can update news images; Type: POLICY; Schema: storage; Owner: -
--

CREATE POLICY "Authenticated users can update news images" ON storage.objects FOR UPDATE USING (((bucket_id = 'news'::text) AND (auth.role() = 'authenticated'::text)));


--
-- TOC entry 5020 (class 3256 OID 17484)
-- Name: objects Authenticated users can upload advertisement images; Type: POLICY; Schema: storage; Owner: -
--

CREATE POLICY "Authenticated users can upload advertisement images" ON storage.objects FOR INSERT WITH CHECK (((bucket_id = 'advertisements'::text) AND (auth.role() = 'authenticated'::text)));


--
-- TOC entry 5012 (class 3256 OID 17476)
-- Name: objects Authenticated users can upload establishment images; Type: POLICY; Schema: storage; Owner: -
--

CREATE POLICY "Authenticated users can upload establishment images" ON storage.objects FOR INSERT WITH CHECK (((bucket_id = 'establishments'::text) AND (auth.role() = 'authenticated'::text)));


--
-- TOC entry 5016 (class 3256 OID 17480)
-- Name: objects Authenticated users can upload news images; Type: POLICY; Schema: storage; Owner: -
--

CREATE POLICY "Authenticated users can upload news images" ON storage.objects FOR INSERT WITH CHECK (((bucket_id = 'news'::text) AND (auth.role() = 'authenticated'::text)));


--
-- TOC entry 5042 (class 3256 OID 19926)
-- Name: objects Authenticated users can upload to establishments; Type: POLICY; Schema: storage; Owner: -
--

CREATE POLICY "Authenticated users can upload to establishments" ON storage.objects FOR INSERT WITH CHECK (((bucket_id = 'establishments'::text) AND (auth.role() = 'authenticated'::text)));


--
-- TOC entry 5049 (class 3256 OID 19928)
-- Name: objects Authenticated users can upload to news; Type: POLICY; Schema: storage; Owner: -
--

CREATE POLICY "Authenticated users can upload to news" ON storage.objects FOR INSERT WITH CHECK (((bucket_id = 'news'::text) AND (auth.role() = 'authenticated'::text)));


--
-- TOC entry 5035 (class 3256 OID 19925)
-- Name: objects Establishments bucket is publicly readable; Type: POLICY; Schema: storage; Owner: -
--

CREATE POLICY "Establishments bucket is publicly readable" ON storage.objects FOR SELECT USING ((bucket_id = 'establishments'::text));


--
-- TOC entry 5011 (class 3256 OID 17475)
-- Name: objects Establishments images are publicly accessible; Type: POLICY; Schema: storage; Owner: -
--

CREATE POLICY "Establishments images are publicly accessible" ON storage.objects FOR SELECT USING ((bucket_id = 'establishments'::text));


--
-- TOC entry 5043 (class 3256 OID 19927)
-- Name: objects News bucket is publicly readable; Type: POLICY; Schema: storage; Owner: -
--

CREATE POLICY "News bucket is publicly readable" ON storage.objects FOR SELECT USING ((bucket_id = 'news'::text));


--
-- TOC entry 5015 (class 3256 OID 17479)
-- Name: objects News images are publicly accessible; Type: POLICY; Schema: storage; Owner: -
--

CREATE POLICY "News images are publicly accessible" ON storage.objects FOR SELECT USING ((bucket_id = 'news'::text));


--
-- TOC entry 4943 (class 0 OID 16546)
-- Dependencies: 300
-- Name: buckets; Type: ROW SECURITY; Schema: storage; Owner: -
--

ALTER TABLE storage.buckets ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4960 (class 0 OID 20266)
-- Dependencies: 328
-- Name: buckets_analytics; Type: ROW SECURITY; Schema: storage; Owner: -
--

ALTER TABLE storage.buckets_analytics ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4961 (class 0 OID 52049)
-- Dependencies: 331
-- Name: buckets_vectors; Type: ROW SECURITY; Schema: storage; Owner: -
--

ALTER TABLE storage.buckets_vectors ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4945 (class 0 OID 16588)
-- Dependencies: 302
-- Name: migrations; Type: ROW SECURITY; Schema: storage; Owner: -
--

ALTER TABLE storage.migrations ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4944 (class 0 OID 16561)
-- Dependencies: 301
-- Name: objects; Type: ROW SECURITY; Schema: storage; Owner: -
--

ALTER TABLE storage.objects ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 5000 (class 3256 OID 106383)
-- Name: objects portal_public_read; Type: POLICY; Schema: storage; Owner: -
--

CREATE POLICY portal_public_read ON storage.objects FOR SELECT USING ((bucket_id = 'portal'::text));


--
-- TOC entry 5003 (class 3256 OID 106386)
-- Name: objects portal_site_scoped_delete; Type: POLICY; Schema: storage; Owner: -
--

CREATE POLICY portal_site_scoped_delete ON storage.objects FOR DELETE TO authenticated USING (((bucket_id = 'portal'::text) AND (split_part(name, '/'::text, 1) = 'sites'::text) AND public.can_write_site_slug(split_part(name, '/'::text, 2))));


--
-- TOC entry 5001 (class 3256 OID 106384)
-- Name: objects portal_site_scoped_insert; Type: POLICY; Schema: storage; Owner: -
--

CREATE POLICY portal_site_scoped_insert ON storage.objects FOR INSERT TO authenticated WITH CHECK (((bucket_id = 'portal'::text) AND (split_part(name, '/'::text, 1) = 'sites'::text) AND public.can_write_site_slug(split_part(name, '/'::text, 2))));


--
-- TOC entry 5002 (class 3256 OID 106385)
-- Name: objects portal_site_scoped_update; Type: POLICY; Schema: storage; Owner: -
--

CREATE POLICY portal_site_scoped_update ON storage.objects FOR UPDATE TO authenticated USING (((bucket_id = 'portal'::text) AND (split_part(name, '/'::text, 1) = 'sites'::text) AND public.can_write_site_slug(split_part(name, '/'::text, 2)))) WITH CHECK (((bucket_id = 'portal'::text) AND (split_part(name, '/'::text, 1) = 'sites'::text) AND public.can_write_site_slug(split_part(name, '/'::text, 2))));


--
-- TOC entry 4957 (class 0 OID 17057)
-- Dependencies: 318
-- Name: s3_multipart_uploads; Type: ROW SECURITY; Schema: storage; Owner: -
--

ALTER TABLE storage.s3_multipart_uploads ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4958 (class 0 OID 17071)
-- Dependencies: 319
-- Name: s3_multipart_uploads_parts; Type: ROW SECURITY; Schema: storage; Owner: -
--

ALTER TABLE storage.s3_multipart_uploads_parts ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4962 (class 0 OID 52059)
-- Dependencies: 332
-- Name: vector_indexes; Type: ROW SECURITY; Schema: storage; Owner: -
--

ALTER TABLE storage.vector_indexes ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 5112 (class 6104 OID 16426)
-- Name: supabase_realtime; Type: PUBLICATION; Schema: -; Owner: -
--

CREATE PUBLICATION supabase_realtime WITH (publish = 'insert, update, delete, truncate');


--
-- TOC entry 4082 (class 3466 OID 16621)
-- Name: issue_graphql_placeholder; Type: EVENT TRIGGER; Schema: -; Owner: -
--

CREATE EVENT TRIGGER issue_graphql_placeholder ON sql_drop
         WHEN TAG IN ('DROP EXTENSION')
   EXECUTE FUNCTION extensions.set_graphql_placeholder();


--
-- TOC entry 4087 (class 3466 OID 16700)
-- Name: issue_pg_cron_access; Type: EVENT TRIGGER; Schema: -; Owner: -
--

CREATE EVENT TRIGGER issue_pg_cron_access ON ddl_command_end
         WHEN TAG IN ('CREATE EXTENSION')
   EXECUTE FUNCTION extensions.grant_pg_cron_access();


--
-- TOC entry 4081 (class 3466 OID 16619)
-- Name: issue_pg_graphql_access; Type: EVENT TRIGGER; Schema: -; Owner: -
--

CREATE EVENT TRIGGER issue_pg_graphql_access ON ddl_command_end
         WHEN TAG IN ('CREATE FUNCTION')
   EXECUTE FUNCTION extensions.grant_pg_graphql_access();


--
-- TOC entry 4088 (class 3466 OID 16703)
-- Name: issue_pg_net_access; Type: EVENT TRIGGER; Schema: -; Owner: -
--

CREATE EVENT TRIGGER issue_pg_net_access ON ddl_command_end
         WHEN TAG IN ('CREATE EXTENSION')
   EXECUTE FUNCTION extensions.grant_pg_net_access();


--
-- TOC entry 4083 (class 3466 OID 16622)
-- Name: pgrst_ddl_watch; Type: EVENT TRIGGER; Schema: -; Owner: -
--

CREATE EVENT TRIGGER pgrst_ddl_watch ON ddl_command_end
   EXECUTE FUNCTION extensions.pgrst_ddl_watch();


--
-- TOC entry 4084 (class 3466 OID 16623)
-- Name: pgrst_drop_watch; Type: EVENT TRIGGER; Schema: -; Owner: -
--

CREATE EVENT TRIGGER pgrst_drop_watch ON sql_drop
   EXECUTE FUNCTION extensions.pgrst_drop_watch();


-- Completed on 2026-02-15 18:59:38

--
-- PostgreSQL database dump complete
--

\unrestrict mZnlKEmm1e2xFNaH2YZWb5CkqM1nFi4OhxsyadGwq1CDvf6SfFgaVkOEXlz5xIk

