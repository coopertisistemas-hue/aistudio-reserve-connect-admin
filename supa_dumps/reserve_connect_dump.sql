--
-- PostgreSQL database dump
--

\restrict ikcJNqAfsqTuCtHW9JkbU02Yx5zgO9KfFqbglFBlXQxUTR6bbJVlhGsZA00lXl9

-- Dumped from database version 17.6
-- Dumped by pg_dump version 18.1

-- Started on 2026-02-15 18:57:52

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
-- TOC entry 17 (class 2615 OID 16494)
-- Name: auth; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA auth;


--
-- TOC entry 12 (class 2615 OID 16388)
-- Name: extensions; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA extensions;


--
-- TOC entry 16 (class 2615 OID 16624)
-- Name: graphql; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA graphql;


--
-- TOC entry 15 (class 2615 OID 16613)
-- Name: graphql_public; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA graphql_public;


--
-- TOC entry 11 (class 2615 OID 16386)
-- Name: pgbouncer; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA pgbouncer;


--
-- TOC entry 9 (class 2615 OID 16605)
-- Name: realtime; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA realtime;


--
-- TOC entry 19 (class 2615 OID 48167)
-- Name: reserve; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA reserve;


--
-- TOC entry 4568 (class 0 OID 0)
-- Dependencies: 19
-- Name: SCHEMA reserve; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON SCHEMA reserve IS 'Reserve Connect application schema - Distribution layer for property bookings';


--
-- TOC entry 18 (class 2615 OID 16542)
-- Name: storage; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA storage;


--
-- TOC entry 13 (class 2615 OID 22977)
-- Name: supabase_migrations; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA supabase_migrations;


--
-- TOC entry 14 (class 2615 OID 16653)
-- Name: vault; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA vault;


--
-- TOC entry 6 (class 3079 OID 16689)
-- Name: pg_graphql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_graphql WITH SCHEMA graphql;


--
-- TOC entry 4569 (class 0 OID 0)
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
-- TOC entry 4570 (class 0 OID 0)
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
-- TOC entry 4571 (class 0 OID 0)
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
-- TOC entry 4572 (class 0 OID 0)
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
-- TOC entry 4573 (class 0 OID 0)
-- Dependencies: 3
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


--
-- TOC entry 1095 (class 1247 OID 16784)
-- Name: aal_level; Type: TYPE; Schema: auth; Owner: -
--

CREATE TYPE auth.aal_level AS ENUM (
    'aal1',
    'aal2',
    'aal3'
);


--
-- TOC entry 1119 (class 1247 OID 16925)
-- Name: code_challenge_method; Type: TYPE; Schema: auth; Owner: -
--

CREATE TYPE auth.code_challenge_method AS ENUM (
    's256',
    'plain'
);


--
-- TOC entry 1092 (class 1247 OID 16778)
-- Name: factor_status; Type: TYPE; Schema: auth; Owner: -
--

CREATE TYPE auth.factor_status AS ENUM (
    'unverified',
    'verified'
);


--
-- TOC entry 1089 (class 1247 OID 16773)
-- Name: factor_type; Type: TYPE; Schema: auth; Owner: -
--

CREATE TYPE auth.factor_type AS ENUM (
    'totp',
    'webauthn',
    'phone'
);


--
-- TOC entry 1137 (class 1247 OID 17028)
-- Name: oauth_authorization_status; Type: TYPE; Schema: auth; Owner: -
--

CREATE TYPE auth.oauth_authorization_status AS ENUM (
    'pending',
    'approved',
    'denied',
    'expired'
);


--
-- TOC entry 1149 (class 1247 OID 17101)
-- Name: oauth_client_type; Type: TYPE; Schema: auth; Owner: -
--

CREATE TYPE auth.oauth_client_type AS ENUM (
    'public',
    'confidential'
);


--
-- TOC entry 1131 (class 1247 OID 17006)
-- Name: oauth_registration_type; Type: TYPE; Schema: auth; Owner: -
--

CREATE TYPE auth.oauth_registration_type AS ENUM (
    'dynamic',
    'manual'
);


--
-- TOC entry 1140 (class 1247 OID 17038)
-- Name: oauth_response_type; Type: TYPE; Schema: auth; Owner: -
--

CREATE TYPE auth.oauth_response_type AS ENUM (
    'code'
);


--
-- TOC entry 1125 (class 1247 OID 16967)
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
-- TOC entry 1189 (class 1247 OID 17316)
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
-- TOC entry 1179 (class 1247 OID 17276)
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
-- TOC entry 1182 (class 1247 OID 17291)
-- Name: user_defined_filter; Type: TYPE; Schema: realtime; Owner: -
--

CREATE TYPE realtime.user_defined_filter AS (
	column_name text,
	op realtime.equality_op,
	value text
);


--
-- TOC entry 1195 (class 1247 OID 17359)
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
-- TOC entry 1192 (class 1247 OID 17329)
-- Name: wal_rls; Type: TYPE; Schema: realtime; Owner: -
--

CREATE TYPE realtime.wal_rls AS (
	wal jsonb,
	is_rls_enabled boolean,
	subscription_ids uuid[],
	errors text[]
);


--
-- TOC entry 1248 (class 1247 OID 48226)
-- Name: event_severity; Type: TYPE; Schema: reserve; Owner: -
--

CREATE TYPE reserve.event_severity AS ENUM (
    'info',
    'warning',
    'error',
    'critical'
);


--
-- TOC entry 4574 (class 0 OID 0)
-- Dependencies: 1248
-- Name: TYPE event_severity; Type: COMMENT; Schema: reserve; Owner: -
--

COMMENT ON TYPE reserve.event_severity IS 'Event importance level';


--
-- TOC entry 1251 (class 1247 OID 48236)
-- Name: funnel_stage; Type: TYPE; Schema: reserve; Owner: -
--

CREATE TYPE reserve.funnel_stage AS ENUM (
    'page_view',
    'search',
    'view_item',
    'lead',
    'checkout',
    'purchase',
    'abandon'
);


--
-- TOC entry 4575 (class 0 OID 0)
-- Dependencies: 1251
-- Name: TYPE funnel_stage; Type: COMMENT; Schema: reserve; Owner: -
--

COMMENT ON TYPE reserve.funnel_stage IS 'Conversion funnel tracking stages';


--
-- TOC entry 1239 (class 1247 OID 48194)
-- Name: payment_status; Type: TYPE; Schema: reserve; Owner: -
--

CREATE TYPE reserve.payment_status AS ENUM (
    'pending',
    'partial',
    'paid',
    'refunded',
    'failed'
);


--
-- TOC entry 4576 (class 0 OID 0)
-- Dependencies: 1239
-- Name: TYPE payment_status; Type: COMMENT; Schema: reserve; Owner: -
--

COMMENT ON TYPE reserve.payment_status IS 'Payment state tracking';


--
-- TOC entry 1236 (class 1247 OID 48182)
-- Name: reservation_source; Type: TYPE; Schema: reserve; Owner: -
--

CREATE TYPE reserve.reservation_source AS ENUM (
    'direct',
    'booking_com',
    'airbnb',
    'expedia',
    'other_ota'
);


--
-- TOC entry 4577 (class 0 OID 0)
-- Dependencies: 1236
-- Name: TYPE reservation_source; Type: COMMENT; Schema: reserve; Owner: -
--

COMMENT ON TYPE reserve.reservation_source IS 'Channel/source of booking';


--
-- TOC entry 1233 (class 1247 OID 48169)
-- Name: reservation_status; Type: TYPE; Schema: reserve; Owner: -
--

CREATE TYPE reserve.reservation_status AS ENUM (
    'pending',
    'confirmed',
    'checked_in',
    'checked_out',
    'cancelled',
    'no_show'
);


--
-- TOC entry 4578 (class 0 OID 0)
-- Dependencies: 1233
-- Name: TYPE reservation_status; Type: COMMENT; Schema: reserve; Owner: -
--

COMMENT ON TYPE reserve.reservation_status IS 'Lifecycle states for reservations';


--
-- TOC entry 1245 (class 1247 OID 48218)
-- Name: sync_direction; Type: TYPE; Schema: reserve; Owner: -
--

CREATE TYPE reserve.sync_direction AS ENUM (
    'push_to_host',
    'pull_from_host',
    'bidirectional'
);


--
-- TOC entry 4579 (class 0 OID 0)
-- Dependencies: 1245
-- Name: TYPE sync_direction; Type: COMMENT; Schema: reserve; Owner: -
--

COMMENT ON TYPE reserve.sync_direction IS 'Data flow direction for sync operations';


--
-- TOC entry 1242 (class 1247 OID 48206)
-- Name: sync_status; Type: TYPE; Schema: reserve; Owner: -
--

CREATE TYPE reserve.sync_status AS ENUM (
    'pending',
    'in_progress',
    'completed',
    'failed',
    'retrying'
);


--
-- TOC entry 4580 (class 0 OID 0)
-- Dependencies: 1242
-- Name: TYPE sync_status; Type: COMMENT; Schema: reserve; Owner: -
--

COMMENT ON TYPE reserve.sync_status IS 'Sync job execution status';


--
-- TOC entry 1173 (class 1247 OID 17241)
-- Name: buckettype; Type: TYPE; Schema: storage; Owner: -
--

CREATE TYPE storage.buckettype AS ENUM (
    'STANDARD',
    'ANALYTICS',
    'VECTOR'
);


--
-- TOC entry 368 (class 1255 OID 16540)
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
-- TOC entry 4581 (class 0 OID 0)
-- Dependencies: 368
-- Name: FUNCTION email(); Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON FUNCTION auth.email() IS 'Deprecated. Use auth.jwt() -> ''email'' instead.';


--
-- TOC entry 387 (class 1255 OID 16755)
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
-- TOC entry 367 (class 1255 OID 16539)
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
-- TOC entry 4582 (class 0 OID 0)
-- Dependencies: 367
-- Name: FUNCTION role(); Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON FUNCTION auth.role() IS 'Deprecated. Use auth.jwt() -> ''role'' instead.';


--
-- TOC entry 366 (class 1255 OID 16538)
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
-- TOC entry 4583 (class 0 OID 0)
-- Dependencies: 366
-- Name: FUNCTION uid(); Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON FUNCTION auth.uid() IS 'Deprecated. Use auth.jwt() -> ''sub'' instead.';


--
-- TOC entry 369 (class 1255 OID 16597)
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
-- TOC entry 4584 (class 0 OID 0)
-- Dependencies: 369
-- Name: FUNCTION grant_pg_cron_access(); Type: COMMENT; Schema: extensions; Owner: -
--

COMMENT ON FUNCTION extensions.grant_pg_cron_access() IS 'Grants access to pg_cron';


--
-- TOC entry 373 (class 1255 OID 16618)
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
-- TOC entry 4585 (class 0 OID 0)
-- Dependencies: 373
-- Name: FUNCTION grant_pg_graphql_access(); Type: COMMENT; Schema: extensions; Owner: -
--

COMMENT ON FUNCTION extensions.grant_pg_graphql_access() IS 'Grants access to pg_graphql';


--
-- TOC entry 370 (class 1255 OID 16599)
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
-- TOC entry 4586 (class 0 OID 0)
-- Dependencies: 370
-- Name: FUNCTION grant_pg_net_access(); Type: COMMENT; Schema: extensions; Owner: -
--

COMMENT ON FUNCTION extensions.grant_pg_net_access() IS 'Grants access to pg_net';


--
-- TOC entry 371 (class 1255 OID 16609)
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
-- TOC entry 372 (class 1255 OID 16610)
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
-- TOC entry 374 (class 1255 OID 16620)
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
-- TOC entry 4587 (class 0 OID 0)
-- Dependencies: 374
-- Name: FUNCTION set_graphql_placeholder(); Type: COMMENT; Schema: extensions; Owner: -
--

COMMENT ON FUNCTION extensions.set_graphql_placeholder() IS 'Reintroduces placeholder function for graphql_public.graphql';


--
-- TOC entry 316 (class 1255 OID 16387)
-- Name: get_auth(text); Type: FUNCTION; Schema: pgbouncer; Owner: -
--

CREATE FUNCTION pgbouncer.get_auth(p_usename text) RETURNS TABLE(username text, password text)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $_$
begin
    raise debug 'PgBouncer auth request: %', p_usename;

    return query
    select 
        rolname::text, 
        case when rolvaliduntil < now() 
            then null 
            else rolpassword::text 
        end 
    from pg_authid 
    where rolname=$1 and rolcanlogin;
end;
$_$;


--
-- TOC entry 432 (class 1255 OID 50062)
-- Name: get_properties_by_city(text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.get_properties_by_city(p_city_code text) RETURNS TABLE(property_id uuid, host_property_id uuid, city_code character varying, name character varying, slug character varying, address character varying, lat numeric, lng numeric, primary_image_url text, updated_at timestamp with time zone)
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        ppv.property_id,
        ppv.host_property_id,
        ppv.city_code,
        ppv.name,
        ppv.slug,
        ppv.address,
        ppv.lat,
        ppv.lng,
        ppv.primary_image_url,
        ppv.updated_at
    FROM public.published_properties_view ppv
    WHERE ppv.city_code = p_city_code
    ORDER BY ppv.name;
END;
$$;


--
-- TOC entry 4588 (class 0 OID 0)
-- Dependencies: 432
-- Name: FUNCTION get_properties_by_city(p_city_code text); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION public.get_properties_by_city(p_city_code text) IS 'Public function to get properties by city code';


--
-- TOC entry 431 (class 1255 OID 50061)
-- Name: get_published_cities(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.get_published_cities() RETURNS TABLE(city_id uuid, city_code character varying, city_name character varying, state_province character varying, country character varying, timezone character varying, currency character varying, properties_count bigint, updated_at timestamp with time zone)
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        pcv.city_id,
        pcv.city_code,
        pcv.city_name,
        pcv.state_province,
        pcv.country,
        pcv.timezone,
        pcv.currency,
        pcv.properties_count,
        pcv.updated_at
    FROM public.published_cities_view pcv
    ORDER BY pcv.city_name;
END;
$$;


--
-- TOC entry 4589 (class 0 OID 0)
-- Dependencies: 431
-- Name: FUNCTION get_published_cities(); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION public.get_published_cities() IS 'Public function to get all active cities with property counts';


--
-- TOC entry 433 (class 1255 OID 50063)
-- Name: get_room_types_by_property(uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.get_room_types_by_property(p_property_id uuid) RETURNS TABLE(unit_id uuid, host_unit_id uuid, host_property_id uuid, property_id uuid, unit_type character varying, name character varying, capacity integer, amenities jsonb, images jsonb, status boolean, updated_at timestamp with time zone)
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        puv.unit_id,
        puv.host_unit_id,
        puv.host_property_id,
        puv.property_id,
        puv.unit_type,
        puv.name,
        puv.capacity,
        puv.amenities,
        puv.images,
        puv.status,
        puv.updated_at
    FROM public.published_units_view puv
    WHERE puv.property_id = p_property_id
    ORDER BY puv.name;
END;
$$;


--
-- TOC entry 4590 (class 0 OID 0)
-- Dependencies: 433
-- Name: FUNCTION get_room_types_by_property(p_property_id uuid); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION public.get_room_types_by_property(p_property_id uuid) IS 'Public function to get room types by property ID';


--
-- TOC entry 409 (class 1255 OID 17352)
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
-- TOC entry 415 (class 1255 OID 17432)
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
-- TOC entry 411 (class 1255 OID 17364)
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
-- TOC entry 407 (class 1255 OID 17313)
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
-- TOC entry 406 (class 1255 OID 17308)
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
-- TOC entry 410 (class 1255 OID 17360)
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
-- TOC entry 412 (class 1255 OID 17372)
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
-- TOC entry 405 (class 1255 OID 17307)
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
-- TOC entry 414 (class 1255 OID 17431)
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
-- TOC entry 404 (class 1255 OID 17305)
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
-- TOC entry 408 (class 1255 OID 17341)
-- Name: to_regrole(text); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime.to_regrole(role_name text) RETURNS regrole
    LANGUAGE sql IMMUTABLE
    AS $$ select role_name::regrole $$;


--
-- TOC entry 413 (class 1255 OID 17425)
-- Name: topic(); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime.topic() RETURNS text
    LANGUAGE sql STABLE
    AS $$
select nullif(current_setting('realtime.topic', true), '')::text;
$$;


--
-- TOC entry 421 (class 1255 OID 48699)
-- Name: calculate_reservation_nights(); Type: FUNCTION; Schema: reserve; Owner: -
--

CREATE FUNCTION reserve.calculate_reservation_nights() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.nights = NEW.check_out - NEW.check_in;
    RETURN NEW;
END;
$$;


--
-- TOC entry 424 (class 1255 OID 48713)
-- Name: check_availability(uuid, uuid, date, date, integer); Type: FUNCTION; Schema: reserve; Owner: -
--

CREATE FUNCTION reserve.check_availability(p_unit_id uuid, p_rate_plan_id uuid, p_check_in date, p_check_out date, p_guests integer DEFAULT 1) RETURNS TABLE(date date, is_available boolean, base_price numeric, discounted_price numeric)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        ac.date,
        ac.is_available AND NOT ac.is_blocked AND ac.allotment > ac.bookings_count,
        ac.base_price,
        ac.discounted_price
    FROM reserve.availability_calendar ac
    WHERE ac.unit_id = p_unit_id
        AND ac.rate_plan_id = p_rate_plan_id
        AND ac.date >= p_check_in
        AND ac.date < p_check_out
    ORDER BY ac.date;
END;
$$;


--
-- TOC entry 429 (class 1255 OID 48788)
-- Name: emit_search_event(uuid, text, text, date, date, integer, integer, uuid, uuid, integer); Type: FUNCTION; Schema: reserve; Owner: -
--

CREATE FUNCTION reserve.emit_search_event(p_correlation_id uuid, p_actor_id text, p_city_code text, p_check_in date, p_check_out date, p_guests integer, p_results_count integer, p_property_id uuid DEFAULT NULL::uuid, p_room_type_id uuid DEFAULT NULL::uuid, p_duration_ms integer DEFAULT 0) RETURNS uuid
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    v_event_id UUID;
BEGIN
    INSERT INTO reserve.events (
        event_name,
        event_version,
        severity,
        actor_type,
        actor_id,
        entity_type,
        entity_id,
        payload,
        correlation_id,
        metadata,
        created_at
    ) VALUES (
        'reserve.search.performed',
        '1.0',
        'info',
        'edge_function',
        p_actor_id,
        'search',
        p_correlation_id,
        jsonb_build_object(
            'city_code', p_city_code,
            'check_in', p_check_in,
            'check_out', p_check_out,
            'guests', p_guests,
            'nights', (p_check_out - p_check_in),
            'results_count', p_results_count,
            'filters', jsonb_build_object(
                'property_id', p_property_id,
                'room_type_id', p_room_type_id
            ),
            'duration_ms', p_duration_ms
        ),
        p_correlation_id,
        '{}',
        NOW()
    )
    RETURNING id INTO v_event_id;
    
    RETURN v_event_id;
END;
$$;


--
-- TOC entry 4591 (class 0 OID 0)
-- Dependencies: 429
-- Name: FUNCTION emit_search_event(p_correlation_id uuid, p_actor_id text, p_city_code text, p_check_in date, p_check_out date, p_guests integer, p_results_count integer, p_property_id uuid, p_room_type_id uuid, p_duration_ms integer); Type: COMMENT; Schema: reserve; Owner: -
--

COMMENT ON FUNCTION reserve.emit_search_event(p_correlation_id uuid, p_actor_id text, p_city_code text, p_check_in date, p_check_out date, p_guests integer, p_results_count integer, p_property_id uuid, p_room_type_id uuid, p_duration_ms integer) IS 'Emits a search event to the event bus for downstream processing';


--
-- TOC entry 423 (class 1255 OID 48712)
-- Name: generate_confirmation_code(); Type: FUNCTION; Schema: reserve; Owner: -
--

CREATE FUNCTION reserve.generate_confirmation_code() RETURNS character varying
    LANGUAGE plpgsql
    AS $$
DECLARE
    code VARCHAR(50);
    exists_check BOOLEAN;
BEGIN
    LOOP
        code := 'RES-' || TO_CHAR(NOW(), 'YYYY') || '-' || UPPER(SUBSTRING(MD5(RANDOM()::TEXT), 1, 6));
        SELECT EXISTS(SELECT 1 FROM reserve.reservations WHERE confirmation_code = code) INTO exists_check;
        EXIT WHEN NOT exists_check;
    END LOOP;
    RETURN code;
END;
$$;


--
-- TOC entry 427 (class 1255 OID 48776)
-- Name: get_search_config(text); Type: FUNCTION; Schema: reserve; Owner: -
--

CREATE FUNCTION reserve.get_search_config(p_key text) RETURNS jsonb
    LANGUAGE plpgsql STABLE SECURITY DEFINER
    AS $$
DECLARE
    v_value JSONB;
BEGIN
    SELECT config_value INTO v_value
    FROM reserve.search_config
    WHERE config_key = p_key;
    
    RETURN COALESCE(v_value, 'null'::JSONB);
END;
$$;


--
-- TOC entry 4592 (class 0 OID 0)
-- Dependencies: 427
-- Name: FUNCTION get_search_config(p_key text); Type: COMMENT; Schema: reserve; Owner: -
--

COMMENT ON FUNCTION reserve.get_search_config(p_key text) IS 'Retrieves search configuration by key';


--
-- TOC entry 425 (class 1255 OID 48747)
-- Name: get_sync_summary(uuid); Type: FUNCTION; Schema: reserve; Owner: -
--

CREATE FUNCTION reserve.get_sync_summary(p_job_id uuid) RETURNS TABLE(total_records integer, inserted integer, updated integer, skipped integer, failed integer, orphaned integer, duration_ms integer)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
  RETURN QUERY
  SELECT 
    sj.records_processed as total_records,
    sj.records_inserted as inserted,
    sj.records_updated as updated,
    (SELECT COUNT(*)::INTEGER FROM reserve.sync_logs 
     WHERE sync_job_id = p_job_id AND action = 'skip') as skipped,
    sj.records_failed as failed,
    COALESCE((sj.metadata ->> 'orphaned_count')::INTEGER, 0) as orphaned,
    sj.latency_ms as duration_ms
  FROM reserve.sync_jobs sj
  WHERE sj.id = p_job_id;
END;
$$;


--
-- TOC entry 4593 (class 0 OID 0)
-- Dependencies: 425
-- Name: FUNCTION get_sync_summary(p_job_id uuid); Type: COMMENT; Schema: reserve; Owner: -
--

COMMENT ON FUNCTION reserve.get_sync_summary(p_job_id uuid) IS 'Returns a summary of sync job results for monitoring dashboards';


--
-- TOC entry 428 (class 1255 OID 48787)
-- Name: record_search_funnel(text, text, text, date, date, integer, uuid, jsonb, integer); Type: FUNCTION; Schema: reserve; Owner: -
--

CREATE FUNCTION reserve.record_search_funnel(p_session_id text, p_visitor_id text, p_city_code text, p_check_in date, p_check_out date, p_guests integer, p_property_id uuid DEFAULT NULL::uuid, p_search_params jsonb DEFAULT '{}'::jsonb, p_results_count integer DEFAULT 0) RETURNS uuid
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    v_event_id UUID;
    v_city_id UUID;
BEGIN
    -- Get city_id from code
    SELECT id INTO v_city_id 
    FROM reserve.cities 
    WHERE code = p_city_code;
    
    INSERT INTO reserve.funnel_events (
        session_id,
        visitor_id,
        stage,
        event_name,
        city_id,
        property_id,
        search_params,
        metadata,
        created_at
    ) VALUES (
        p_session_id,
        p_visitor_id,
        'search',
        'availability_search',
        v_city_id,
        p_property_id,
        jsonb_build_object(
            'city_code', p_city_code,
            'check_in', p_check_in,
            'check_out', p_check_out,
            'guests', p_guests,
            'nights', (p_check_out - p_check_in),
            'filters', p_search_params
        ),
        jsonb_build_object(
            'results_count', p_results_count,
            'has_filters', (p_property_id IS NOT NULL OR p_search_params != '{}')
        ),
        NOW()
    )
    RETURNING id INTO v_event_id;
    
    RETURN v_event_id;
END;
$$;


--
-- TOC entry 4594 (class 0 OID 0)
-- Dependencies: 428
-- Name: FUNCTION record_search_funnel(p_session_id text, p_visitor_id text, p_city_code text, p_check_in date, p_check_out date, p_guests integer, p_property_id uuid, p_search_params jsonb, p_results_count integer); Type: COMMENT; Schema: reserve; Owner: -
--

COMMENT ON FUNCTION reserve.record_search_funnel(p_session_id text, p_visitor_id text, p_city_code text, p_check_in date, p_check_out date, p_guests integer, p_property_id uuid, p_search_params jsonb, p_results_count integer) IS 'Records a search event in the funnel tracking table';


--
-- TOC entry 426 (class 1255 OID 48748)
-- Name: retry_sync_job(uuid); Type: FUNCTION; Schema: reserve; Owner: -
--

CREATE FUNCTION reserve.retry_sync_job(p_job_id uuid) RETURNS uuid
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
  v_new_job_id UUID;
  v_job_record RECORD;
BEGIN
  -- Get original job details
  SELECT * INTO v_job_record
  FROM reserve.sync_jobs
  WHERE id = p_job_id AND status = 'failed';
  
  IF NOT FOUND THEN
    RAISE EXCEPTION 'Job not found or not in failed status';
  END IF;
  
  -- Create new job as copy
  INSERT INTO reserve.sync_jobs (
    job_name,
    job_type,
    direction,
    property_id,
    city_id,
    status,
    priority,
    max_retries,
    metadata
  ) VALUES (
    v_job_record.job_name || '_retry_' || (v_job_record.retry_count + 1),
    v_job_record.job_type,
    v_job_record.direction,
    v_job_record.property_id,
    v_job_record.city_id,
    'pending',
    v_job_record.priority - 1, -- Higher priority on retry
    v_job_record.max_retries,
    jsonb_set(
      v_job_record.metadata,
      '{retried_from}',
      to_jsonb(p_job_id)
    )
  )
  RETURNING id INTO v_new_job_id;
  
  RETURN v_new_job_id;
END;
$$;


--
-- TOC entry 4595 (class 0 OID 0)
-- Dependencies: 426
-- Name: FUNCTION retry_sync_job(p_job_id uuid); Type: COMMENT; Schema: reserve; Owner: -
--

COMMENT ON FUNCTION reserve.retry_sync_job(p_job_id uuid) IS 'Creates a new sync job based on a failed job for retry purposes';


--
-- TOC entry 420 (class 1255 OID 48689)
-- Name: set_updated_at(); Type: FUNCTION; Schema: reserve; Owner: -
--

CREATE FUNCTION reserve.set_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$;


--
-- TOC entry 422 (class 1255 OID 48701)
-- Name: soft_delete_property(); Type: FUNCTION; Schema: reserve; Owner: -
--

CREATE FUNCTION reserve.soft_delete_property() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Archive related records logic can go here
    RETURN OLD;
END;
$$;


--
-- TOC entry 430 (class 1255 OID 48789)
-- Name: validate_search_params(text, date, date, integer, uuid); Type: FUNCTION; Schema: reserve; Owner: -
--

CREATE FUNCTION reserve.validate_search_params(p_city_code text, p_check_in date, p_check_out date, p_guests integer, p_property_id uuid DEFAULT NULL::uuid) RETURNS TABLE(is_valid boolean, error_message text, nights integer, city_exists boolean)
    LANGUAGE plpgsql STABLE SECURITY DEFINER
    AS $$
DECLARE
    v_nights INTEGER;
    v_city_exists BOOLEAN;
    v_min_nights INTEGER;
    v_max_nights INTEGER;
BEGIN
    -- Get config values
    v_min_nights := (reserve.get_search_config('min_nights'))::TEXT::INTEGER;
    v_max_nights := (reserve.get_search_config('max_nights'))::TEXT::INTEGER;
    
    -- Check if city exists
    SELECT EXISTS(
        SELECT 1 FROM reserve.cities WHERE code = p_city_code AND is_active = true
    ) INTO v_city_exists;
    
    -- Calculate nights
    v_nights := p_check_out - p_check_in;
    
    -- Validation logic
    IF NOT v_city_exists THEN
        RETURN QUERY SELECT false, 'Invalid or inactive city code: ' || p_city_code, 0, false;
        RETURN;
    END IF;
    
    IF p_check_in >= p_check_out THEN
        RETURN QUERY SELECT false, 'Check-out must be after check-in', 0, true;
        RETURN;
    END IF;
    
    IF p_check_in < CURRENT_DATE THEN
        RETURN QUERY SELECT false, 'Check-in cannot be in the past', 0, true;
        RETURN;
    END IF;
    
    IF v_nights < v_min_nights THEN
        RETURN QUERY SELECT false, 
            format('Minimum stay is %s nights', v_min_nights), 
            v_nights, 
            true;
        RETURN;
    END IF;
    
    IF v_nights > v_max_nights THEN
        RETURN QUERY SELECT false, 
            format('Maximum stay is %s nights', v_max_nights), 
            v_nights, 
            true;
        RETURN;
    END IF;
    
    IF p_guests < 1 THEN
        RETURN QUERY SELECT false, 'At least 1 guest required', v_nights, true;
        RETURN;
    END IF;
    
    -- Check if property exists when specified
    IF p_property_id IS NOT NULL THEN
        IF NOT EXISTS(
            SELECT 1 FROM reserve.properties_map 
            WHERE id = p_property_id AND is_active = true AND is_published = true
        ) THEN
            RETURN QUERY SELECT false, 'Property not found or not available', v_nights, true;
            RETURN;
        END IF;
    END IF;
    
    RETURN QUERY SELECT true, NULL::TEXT, v_nights, true;
END;
$$;


--
-- TOC entry 4596 (class 0 OID 0)
-- Dependencies: 430
-- Name: FUNCTION validate_search_params(p_city_code text, p_check_in date, p_check_out date, p_guests integer, p_property_id uuid); Type: COMMENT; Schema: reserve; Owner: -
--

COMMENT ON FUNCTION reserve.validate_search_params(p_city_code text, p_check_in date, p_check_out date, p_guests integer, p_property_id uuid) IS 'Validates search parameters and returns validation result with calculated nights';


--
-- TOC entry 393 (class 1255 OID 17145)
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
-- TOC entry 403 (class 1255 OID 17259)
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
-- TOC entry 401 (class 1255 OID 17238)
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
-- TOC entry 390 (class 1255 OID 17119)
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
-- TOC entry 389 (class 1255 OID 17118)
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
-- TOC entry 388 (class 1255 OID 17117)
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
-- TOC entry 416 (class 1255 OID 47590)
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
-- TOC entry 396 (class 1255 OID 17201)
-- Name: get_level(text); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.get_level(name text) RETURNS integer
    LANGUAGE sql IMMUTABLE STRICT
    AS $$
SELECT array_length(string_to_array("name", '/'), 1);
$$;


--
-- TOC entry 397 (class 1255 OID 17217)
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
-- TOC entry 398 (class 1255 OID 17218)
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
-- TOC entry 400 (class 1255 OID 17236)
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
-- TOC entry 394 (class 1255 OID 17184)
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
-- TOC entry 417 (class 1255 OID 47591)
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
-- TOC entry 395 (class 1255 OID 17200)
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
-- TOC entry 419 (class 1255 OID 47596)
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
-- TOC entry 391 (class 1255 OID 17134)
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
-- TOC entry 418 (class 1255 OID 47594)
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
-- TOC entry 399 (class 1255 OID 17234)
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
-- TOC entry 402 (class 1255 OID 17257)
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
-- TOC entry 392 (class 1255 OID 17135)
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


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 238 (class 1259 OID 16525)
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
-- TOC entry 4597 (class 0 OID 0)
-- Dependencies: 238
-- Name: TABLE audit_log_entries; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.audit_log_entries IS 'Auth: Audit trail for user actions.';


--
-- TOC entry 255 (class 1259 OID 16929)
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
-- TOC entry 4598 (class 0 OID 0)
-- Dependencies: 255
-- Name: TABLE flow_state; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.flow_state IS 'Stores metadata for all OAuth/SSO login flows';


--
-- TOC entry 246 (class 1259 OID 16727)
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
-- TOC entry 4599 (class 0 OID 0)
-- Dependencies: 246
-- Name: TABLE identities; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.identities IS 'Auth: Stores identities associated to a user.';


--
-- TOC entry 4600 (class 0 OID 0)
-- Dependencies: 246
-- Name: COLUMN identities.email; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON COLUMN auth.identities.email IS 'Auth: Email is a generated column that references the optional email property in the identity_data';


--
-- TOC entry 237 (class 1259 OID 16518)
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
-- TOC entry 4601 (class 0 OID 0)
-- Dependencies: 237
-- Name: TABLE instances; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.instances IS 'Auth: Manages users across multiple sites.';


--
-- TOC entry 250 (class 1259 OID 16816)
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
-- TOC entry 4602 (class 0 OID 0)
-- Dependencies: 250
-- Name: TABLE mfa_amr_claims; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.mfa_amr_claims IS 'auth: stores authenticator method reference claims for multi factor authentication';


--
-- TOC entry 249 (class 1259 OID 16804)
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
-- TOC entry 4603 (class 0 OID 0)
-- Dependencies: 249
-- Name: TABLE mfa_challenges; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.mfa_challenges IS 'auth: stores metadata about challenge requests made';


--
-- TOC entry 248 (class 1259 OID 16791)
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
-- TOC entry 4604 (class 0 OID 0)
-- Dependencies: 248
-- Name: TABLE mfa_factors; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.mfa_factors IS 'auth: stores metadata about factors';


--
-- TOC entry 4605 (class 0 OID 0)
-- Dependencies: 248
-- Name: COLUMN mfa_factors.last_webauthn_challenge_data; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON COLUMN auth.mfa_factors.last_webauthn_challenge_data IS 'Stores the latest WebAuthn challenge data including attestation/assertion for customer verification';


--
-- TOC entry 258 (class 1259 OID 17041)
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
-- TOC entry 273 (class 1259 OID 39398)
-- Name: oauth_client_states; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.oauth_client_states (
    id uuid NOT NULL,
    provider_type text NOT NULL,
    code_verifier text,
    created_at timestamp with time zone NOT NULL
);


--
-- TOC entry 4606 (class 0 OID 0)
-- Dependencies: 273
-- Name: TABLE oauth_client_states; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.oauth_client_states IS 'Stores OAuth states for third-party provider authentication flows where Supabase acts as the OAuth client.';


--
-- TOC entry 257 (class 1259 OID 17011)
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
-- TOC entry 259 (class 1259 OID 17074)
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
-- TOC entry 256 (class 1259 OID 16979)
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
-- TOC entry 236 (class 1259 OID 16507)
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
-- TOC entry 4607 (class 0 OID 0)
-- Dependencies: 236
-- Name: TABLE refresh_tokens; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.refresh_tokens IS 'Auth: Store of tokens used to refresh JWT tokens once they expire.';


--
-- TOC entry 235 (class 1259 OID 16506)
-- Name: refresh_tokens_id_seq; Type: SEQUENCE; Schema: auth; Owner: -
--

CREATE SEQUENCE auth.refresh_tokens_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4608 (class 0 OID 0)
-- Dependencies: 235
-- Name: refresh_tokens_id_seq; Type: SEQUENCE OWNED BY; Schema: auth; Owner: -
--

ALTER SEQUENCE auth.refresh_tokens_id_seq OWNED BY auth.refresh_tokens.id;


--
-- TOC entry 253 (class 1259 OID 16858)
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
-- TOC entry 4609 (class 0 OID 0)
-- Dependencies: 253
-- Name: TABLE saml_providers; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.saml_providers IS 'Auth: Manages SAML Identity Provider connections.';


--
-- TOC entry 254 (class 1259 OID 16876)
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
-- TOC entry 4610 (class 0 OID 0)
-- Dependencies: 254
-- Name: TABLE saml_relay_states; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.saml_relay_states IS 'Auth: Contains SAML Relay State information for each Service Provider initiated login.';


--
-- TOC entry 239 (class 1259 OID 16533)
-- Name: schema_migrations; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.schema_migrations (
    version character varying(255) NOT NULL
);


--
-- TOC entry 4611 (class 0 OID 0)
-- Dependencies: 239
-- Name: TABLE schema_migrations; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.schema_migrations IS 'Auth: Manages updates to the auth system.';


--
-- TOC entry 247 (class 1259 OID 16757)
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
-- TOC entry 4612 (class 0 OID 0)
-- Dependencies: 247
-- Name: TABLE sessions; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.sessions IS 'Auth: Stores session data associated to a user.';


--
-- TOC entry 4613 (class 0 OID 0)
-- Dependencies: 247
-- Name: COLUMN sessions.not_after; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON COLUMN auth.sessions.not_after IS 'Auth: Not after is a nullable column that contains a timestamp after which the session should be regarded as expired.';


--
-- TOC entry 4614 (class 0 OID 0)
-- Dependencies: 247
-- Name: COLUMN sessions.refresh_token_hmac_key; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON COLUMN auth.sessions.refresh_token_hmac_key IS 'Holds a HMAC-SHA256 key used to sign refresh tokens for this session.';


--
-- TOC entry 4615 (class 0 OID 0)
-- Dependencies: 247
-- Name: COLUMN sessions.refresh_token_counter; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON COLUMN auth.sessions.refresh_token_counter IS 'Holds the ID (counter) of the last issued refresh token.';


--
-- TOC entry 252 (class 1259 OID 16843)
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
-- TOC entry 4616 (class 0 OID 0)
-- Dependencies: 252
-- Name: TABLE sso_domains; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.sso_domains IS 'Auth: Manages SSO email address domain mapping to an SSO Identity Provider.';


--
-- TOC entry 251 (class 1259 OID 16834)
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
-- TOC entry 4617 (class 0 OID 0)
-- Dependencies: 251
-- Name: TABLE sso_providers; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.sso_providers IS 'Auth: Manages SSO identity provider information; see saml_providers for SAML.';


--
-- TOC entry 4618 (class 0 OID 0)
-- Dependencies: 251
-- Name: COLUMN sso_providers.resource_id; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON COLUMN auth.sso_providers.resource_id IS 'Auth: Uniquely identifies a SSO provider according to a user-chosen resource ID (case insensitive), useful in infrastructure as code.';


--
-- TOC entry 234 (class 1259 OID 16495)
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
-- TOC entry 4619 (class 0 OID 0)
-- Dependencies: 234
-- Name: TABLE users; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.users IS 'Auth: Stores user login data within a secure schema.';


--
-- TOC entry 4620 (class 0 OID 0)
-- Dependencies: 234
-- Name: COLUMN users.is_sso_user; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON COLUMN auth.users.is_sso_user IS 'Auth: Set this column to true when the account comes from SSO. These accounts can have duplicate emails.';


--
-- TOC entry 275 (class 1259 OID 48251)
-- Name: cities; Type: TABLE; Schema: reserve; Owner: -
--

CREATE TABLE reserve.cities (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    code character varying(10) NOT NULL,
    name character varying(100) NOT NULL,
    state_province character varying(100),
    country character varying(100) DEFAULT 'Brazil'::character varying NOT NULL,
    timezone character varying(50) DEFAULT 'America/Sao_Paulo'::character varying NOT NULL,
    currency character varying(3) DEFAULT 'BRL'::character varying NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    metadata jsonb DEFAULT '{}'::jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);

ALTER TABLE ONLY reserve.cities FORCE ROW LEVEL SECURITY;


--
-- TOC entry 4621 (class 0 OID 0)
-- Dependencies: 275
-- Name: TABLE cities; Type: COMMENT; Schema: reserve; Owner: -
--

COMMENT ON TABLE reserve.cities IS 'Multi-city support for Reserve Connect - Pilot: Urubici';


--
-- TOC entry 4622 (class 0 OID 0)
-- Dependencies: 275
-- Name: COLUMN cities.code; Type: COMMENT; Schema: reserve; Owner: -
--

COMMENT ON COLUMN reserve.cities.code IS 'Unique city identifier (e.g., URB, SAO)';


--
-- TOC entry 276 (class 1259 OID 48270)
-- Name: properties_map; Type: TABLE; Schema: reserve; Owner: -
--

CREATE TABLE reserve.properties_map (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    host_property_id uuid NOT NULL,
    city_id uuid NOT NULL,
    name character varying(200) NOT NULL,
    slug character varying(200) NOT NULL,
    description text,
    property_type character varying(50),
    address_line_1 character varying(255),
    address_line_2 character varying(255),
    city character varying(100),
    state_province character varying(100),
    postal_code character varying(20),
    country character varying(100) DEFAULT 'Brazil'::character varying,
    latitude numeric(10,8),
    longitude numeric(11,8),
    phone character varying(50),
    email character varying(255),
    website character varying(500),
    amenities_cached jsonb DEFAULT '[]'::jsonb,
    images_cached jsonb DEFAULT '[]'::jsonb,
    rating_cached numeric(2,1),
    review_count_cached integer DEFAULT 0,
    host_last_synced_at timestamp with time zone,
    host_data_hash character varying(64),
    is_active boolean DEFAULT true NOT NULL,
    is_published boolean DEFAULT false NOT NULL,
    deleted_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT valid_coordinates CHECK ((((latitude IS NULL) OR ((latitude >= ('-90'::integer)::numeric) AND (latitude <= (90)::numeric))) AND ((longitude IS NULL) OR ((longitude >= ('-180'::integer)::numeric) AND (longitude <= (180)::numeric))))),
    CONSTRAINT valid_rating CHECK (((rating_cached IS NULL) OR ((rating_cached >= (0)::numeric) AND (rating_cached <= (5)::numeric))))
);

ALTER TABLE ONLY reserve.properties_map FORCE ROW LEVEL SECURITY;


--
-- TOC entry 4623 (class 0 OID 0)
-- Dependencies: 276
-- Name: TABLE properties_map; Type: COMMENT; Schema: reserve; Owner: -
--

COMMENT ON TABLE reserve.properties_map IS 'Maps Host Connect properties to Reserve Connect - minimal cached fields only';


--
-- TOC entry 4624 (class 0 OID 0)
-- Dependencies: 276
-- Name: COLUMN properties_map.host_property_id; Type: COMMENT; Schema: reserve; Owner: -
--

COMMENT ON COLUMN reserve.properties_map.host_property_id IS 'Reference to Host Connect property ID (source of truth)';


--
-- TOC entry 4625 (class 0 OID 0)
-- Dependencies: 276
-- Name: COLUMN properties_map.host_last_synced_at; Type: COMMENT; Schema: reserve; Owner: -
--

COMMENT ON COLUMN reserve.properties_map.host_last_synced_at IS 'Last successful sync from Host Connect';


--
-- TOC entry 4626 (class 0 OID 0)
-- Dependencies: 276
-- Name: COLUMN properties_map.host_data_hash; Type: COMMENT; Schema: reserve; Owner: -
--

COMMENT ON COLUMN reserve.properties_map.host_data_hash IS 'SHA-256 hash of source data for change detection';


--
-- TOC entry 277 (class 1259 OID 48301)
-- Name: unit_map; Type: TABLE; Schema: reserve; Owner: -
--

CREATE TABLE reserve.unit_map (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    host_unit_id uuid NOT NULL,
    property_id uuid NOT NULL,
    name character varying(200) NOT NULL,
    slug character varying(200) NOT NULL,
    unit_type character varying(50),
    description text,
    max_occupancy integer DEFAULT 2 NOT NULL,
    base_capacity integer DEFAULT 2 NOT NULL,
    amenities_cached jsonb DEFAULT '[]'::jsonb,
    images_cached jsonb DEFAULT '[]'::jsonb,
    size_sqm integer,
    bed_configuration jsonb DEFAULT '[]'::jsonb,
    host_last_synced_at timestamp with time zone,
    host_data_hash character varying(64),
    is_active boolean DEFAULT true NOT NULL,
    deleted_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    host_property_id uuid,
    CONSTRAINT valid_occupancy CHECK (((max_occupancy >= base_capacity) AND (base_capacity > 0)))
);

ALTER TABLE ONLY reserve.unit_map FORCE ROW LEVEL SECURITY;


--
-- TOC entry 4627 (class 0 OID 0)
-- Dependencies: 277
-- Name: TABLE unit_map; Type: COMMENT; Schema: reserve; Owner: -
--

COMMENT ON TABLE reserve.unit_map IS 'Maps Host Connect units/rooms to Reserve Connect';


--
-- TOC entry 4628 (class 0 OID 0)
-- Dependencies: 277
-- Name: COLUMN unit_map.host_unit_id; Type: COMMENT; Schema: reserve; Owner: -
--

COMMENT ON COLUMN reserve.unit_map.host_unit_id IS 'Reference to Host Connect unit ID (source of truth)';


--
-- TOC entry 4629 (class 0 OID 0)
-- Dependencies: 277
-- Name: COLUMN unit_map.host_property_id; Type: COMMENT; Schema: reserve; Owner: -
--

COMMENT ON COLUMN reserve.unit_map.host_property_id IS 'Reference to Host Connect property ID for linking room types to properties during sync';


--
-- TOC entry 298 (class 1259 OID 50103)
-- Name: active_room_types_view; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.active_room_types_view AS
 SELECT um.id,
    um.host_unit_id AS host_room_type_id,
    um.host_property_id,
    um.property_id,
    pm.name AS property_name,
    pm.slug AS property_slug,
    pm.city_id,
    c.code AS city_code,
    um.name AS room_type_name,
    um.slug AS room_type_slug,
    um.max_occupancy,
    um.base_capacity,
    um.amenities_cached,
    um.images_cached,
    um.size_sqm
   FROM ((reserve.unit_map um
     JOIN reserve.properties_map pm ON ((um.property_id = pm.id)))
     JOIN reserve.cities c ON ((pm.city_id = c.id)))
  WHERE ((um.is_active = true) AND (um.deleted_at IS NULL) AND (pm.is_active = true) AND (pm.is_published = true) AND (pm.deleted_at IS NULL) AND (c.is_active = true));


--
-- TOC entry 4630 (class 0 OID 0)
-- Dependencies: 298
-- Name: VIEW active_room_types_view; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON VIEW public.active_room_types_view IS 'Active room types for search_availability Edge Function';


--
-- TOC entry 299 (class 1259 OID 50108)
-- Name: cities; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.cities AS
 SELECT id,
    code,
    name,
    state_province,
    country,
    timezone,
    currency,
    is_active,
    metadata,
    created_at,
    updated_at
   FROM reserve.cities;


--
-- TOC entry 4631 (class 0 OID 0)
-- Dependencies: 299
-- Name: VIEW cities; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON VIEW public.cities IS 'Proxy view to reserve.cities for Edge Function compatibility';


--
-- TOC entry 284 (class 1259 OID 48534)
-- Name: events; Type: TABLE; Schema: reserve; Owner: -
--

CREATE TABLE reserve.events (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    event_name character varying(100) NOT NULL,
    event_version character varying(10) DEFAULT '1.0'::character varying NOT NULL,
    severity reserve.event_severity DEFAULT 'info'::reserve.event_severity NOT NULL,
    actor_type character varying(50) NOT NULL,
    actor_id character varying(255),
    entity_type character varying(50) NOT NULL,
    entity_id uuid NOT NULL,
    payload jsonb DEFAULT '{}'::jsonb NOT NULL,
    payload_schema character varying(100),
    processed_at timestamp with time zone,
    processor_id character varying(100),
    error_message text,
    retry_count integer DEFAULT 0 NOT NULL,
    correlation_id uuid,
    causation_id uuid,
    metadata jsonb DEFAULT '{}'::jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);

ALTER TABLE ONLY reserve.events FORCE ROW LEVEL SECURITY;


--
-- TOC entry 4632 (class 0 OID 0)
-- Dependencies: 284
-- Name: TABLE events; Type: COMMENT; Schema: reserve; Owner: -
--

COMMENT ON TABLE reserve.events IS 'Internal event bus for decoupled processing - reservation events, sync events, etc.';


--
-- TOC entry 4633 (class 0 OID 0)
-- Dependencies: 284
-- Name: COLUMN events.correlation_id; Type: COMMENT; Schema: reserve; Owner: -
--

COMMENT ON COLUMN reserve.events.correlation_id IS 'Groups related events together';


--
-- TOC entry 4634 (class 0 OID 0)
-- Dependencies: 284
-- Name: COLUMN events.causation_id; Type: COMMENT; Schema: reserve; Owner: -
--

COMMENT ON COLUMN reserve.events.causation_id IS 'References the event that caused this event';


--
-- TOC entry 304 (class 1259 OID 50130)
-- Name: events; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.events AS
 SELECT id,
    event_name,
    event_version,
    severity,
    actor_type,
    actor_id,
    entity_type,
    entity_id,
    payload,
    payload_schema,
    processed_at,
    processor_id,
    error_message,
    retry_count,
    correlation_id,
    causation_id,
    metadata,
    created_at
   FROM reserve.events;


--
-- TOC entry 4635 (class 0 OID 0)
-- Dependencies: 304
-- Name: VIEW events; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON VIEW public.events IS 'Proxy view to reserve.events for Edge Function compatibility';


--
-- TOC entry 300 (class 1259 OID 50112)
-- Name: properties_map; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.properties_map AS
 SELECT id,
    host_property_id,
    city_id,
    name,
    slug,
    description,
    property_type,
    address_line_1,
    address_line_2,
    city,
    state_province,
    postal_code,
    country,
    latitude,
    longitude,
    phone,
    email,
    website,
    amenities_cached,
    images_cached,
    rating_cached,
    review_count_cached,
    host_last_synced_at,
    host_data_hash,
    is_active,
    is_published,
    deleted_at,
    created_at,
    updated_at
   FROM reserve.properties_map;


--
-- TOC entry 4636 (class 0 OID 0)
-- Dependencies: 300
-- Name: VIEW properties_map; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON VIEW public.properties_map IS 'Proxy view to reserve.properties_map for Edge Function compatibility';


--
-- TOC entry 295 (class 1259 OID 50088)
-- Name: published_cities_view; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.published_cities_view AS
 SELECT id AS city_id,
    code AS city_code,
    name AS city_name,
    state_province,
    country,
    timezone,
    currency,
    ( SELECT count(*) AS count
           FROM reserve.properties_map pm
          WHERE ((pm.city_id = c.id) AND (pm.is_active = true) AND (pm.is_published = true) AND (pm.deleted_at IS NULL))) AS properties_count,
    updated_at
   FROM reserve.cities c
  WHERE (is_active = true);


--
-- TOC entry 4637 (class 0 OID 0)
-- Dependencies: 295
-- Name: VIEW published_cities_view; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON VIEW public.published_cities_view IS 'Public read-only view of active cities with property counts';


--
-- TOC entry 296 (class 1259 OID 50093)
-- Name: published_properties_view; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.published_properties_view AS
 SELECT pm.id AS property_id,
    pm.host_property_id,
    c.code AS city_code,
    pm.name,
    pm.slug,
    pm.address_line_1 AS address,
    pm.latitude AS lat,
    pm.longitude AS lng,
        CASE
            WHEN ((pm.images_cached IS NOT NULL) AND (jsonb_array_length(pm.images_cached) > 0)) THEN ((pm.images_cached -> 0) ->> 'url'::text)
            ELSE NULL::text
        END AS primary_image_url,
    pm.updated_at
   FROM (reserve.properties_map pm
     JOIN reserve.cities c ON ((pm.city_id = c.id)))
  WHERE ((pm.is_active = true) AND (pm.is_published = true) AND (pm.deleted_at IS NULL) AND (c.is_active = true));


--
-- TOC entry 4638 (class 0 OID 0)
-- Dependencies: 296
-- Name: VIEW published_properties_view; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON VIEW public.published_properties_view IS 'Public read-only view of published properties';


--
-- TOC entry 297 (class 1259 OID 50098)
-- Name: published_units_view; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.published_units_view AS
 SELECT um.id AS unit_id,
    um.host_unit_id,
    um.host_property_id,
    um.property_id,
    um.unit_type,
    um.name,
    um.max_occupancy AS capacity,
    um.amenities_cached AS amenities,
    um.images_cached AS images,
    um.is_active AS status,
    um.updated_at
   FROM ((reserve.unit_map um
     JOIN reserve.properties_map pm ON ((um.property_id = pm.id)))
     JOIN reserve.cities c ON ((pm.city_id = c.id)))
  WHERE ((um.is_active = true) AND (um.deleted_at IS NULL) AND (pm.is_active = true) AND (pm.is_published = true) AND (pm.deleted_at IS NULL) AND (c.is_active = true));


--
-- TOC entry 4639 (class 0 OID 0)
-- Dependencies: 297
-- Name: VIEW published_units_view; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON VIEW public.published_units_view IS 'Public read-only view of active room types/units';


--
-- TOC entry 282 (class 1259 OID 48484)
-- Name: sync_jobs; Type: TABLE; Schema: reserve; Owner: -
--

CREATE TABLE reserve.sync_jobs (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    job_name character varying(100) NOT NULL,
    job_type character varying(50) NOT NULL,
    direction reserve.sync_direction NOT NULL,
    property_id uuid,
    city_id uuid,
    date_from date,
    date_to date,
    status reserve.sync_status DEFAULT 'pending'::reserve.sync_status NOT NULL,
    priority integer DEFAULT 5 NOT NULL,
    started_at timestamp with time zone,
    completed_at timestamp with time zone,
    failed_at timestamp with time zone,
    error_message text,
    error_details jsonb,
    retry_count integer DEFAULT 0 NOT NULL,
    max_retries integer DEFAULT 3 NOT NULL,
    records_processed integer,
    records_inserted integer,
    records_updated integer,
    records_failed integer,
    latency_ms integer,
    source_payload_hash character varying(64),
    target_payload_hash character varying(64),
    metadata jsonb DEFAULT '{}'::jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);

ALTER TABLE ONLY reserve.sync_jobs FORCE ROW LEVEL SECURITY;


--
-- TOC entry 4640 (class 0 OID 0)
-- Dependencies: 282
-- Name: TABLE sync_jobs; Type: COMMENT; Schema: reserve; Owner: -
--

COMMENT ON TABLE reserve.sync_jobs IS 'Idempotent sync operations - tracks all data synchronization with Host Connect';


--
-- TOC entry 4641 (class 0 OID 0)
-- Dependencies: 282
-- Name: COLUMN sync_jobs.latency_ms; Type: COMMENT; Schema: reserve; Owner: -
--

COMMENT ON COLUMN reserve.sync_jobs.latency_ms IS 'Total sync operation duration in milliseconds';


--
-- TOC entry 4642 (class 0 OID 0)
-- Dependencies: 282
-- Name: COLUMN sync_jobs.source_payload_hash; Type: COMMENT; Schema: reserve; Owner: -
--

COMMENT ON COLUMN reserve.sync_jobs.source_payload_hash IS 'SHA-256 of incoming data payload for idempotency';


--
-- TOC entry 302 (class 1259 OID 50121)
-- Name: sync_jobs; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.sync_jobs AS
 SELECT id,
    job_name,
    job_type,
    direction,
    property_id,
    city_id,
    date_from,
    date_to,
    status,
    priority,
    started_at,
    completed_at,
    failed_at,
    error_message,
    error_details,
    retry_count,
    max_retries,
    records_processed,
    records_inserted,
    records_updated,
    records_failed,
    latency_ms,
    source_payload_hash,
    target_payload_hash,
    metadata,
    created_at,
    updated_at
   FROM reserve.sync_jobs;


--
-- TOC entry 4643 (class 0 OID 0)
-- Dependencies: 302
-- Name: VIEW sync_jobs; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON VIEW public.sync_jobs IS 'Proxy view to reserve.sync_jobs for Edge Function compatibility';


--
-- TOC entry 283 (class 1259 OID 48515)
-- Name: sync_logs; Type: TABLE; Schema: reserve; Owner: -
--

CREATE TABLE reserve.sync_logs (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    sync_job_id uuid,
    log_level character varying(20) DEFAULT 'info'::character varying NOT NULL,
    message text NOT NULL,
    details jsonb,
    record_id uuid,
    record_type character varying(50),
    action character varying(50),
    created_at timestamp with time zone DEFAULT now() NOT NULL
);

ALTER TABLE ONLY reserve.sync_logs FORCE ROW LEVEL SECURITY;


--
-- TOC entry 4644 (class 0 OID 0)
-- Dependencies: 283
-- Name: TABLE sync_logs; Type: COMMENT; Schema: reserve; Owner: -
--

COMMENT ON TABLE reserve.sync_logs IS 'Detailed logging for sync operations - debugging and audit trail';


--
-- TOC entry 303 (class 1259 OID 50126)
-- Name: sync_logs; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.sync_logs AS
 SELECT id,
    sync_job_id,
    log_level,
    message,
    details,
    record_id,
    record_type,
    action,
    created_at
   FROM reserve.sync_logs;


--
-- TOC entry 4645 (class 0 OID 0)
-- Dependencies: 303
-- Name: VIEW sync_logs; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON VIEW public.sync_logs IS 'Proxy view to reserve.sync_logs for Edge Function compatibility';


--
-- TOC entry 301 (class 1259 OID 50117)
-- Name: unit_map; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.unit_map AS
 SELECT id,
    host_unit_id,
    property_id,
    name,
    slug,
    unit_type,
    description,
    max_occupancy,
    base_capacity,
    amenities_cached,
    images_cached,
    size_sqm,
    bed_configuration,
    host_last_synced_at,
    host_data_hash,
    is_active,
    deleted_at,
    created_at,
    updated_at,
    host_property_id
   FROM reserve.unit_map;


--
-- TOC entry 4646 (class 0 OID 0)
-- Dependencies: 301
-- Name: VIEW unit_map; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON VIEW public.unit_map IS 'Proxy view to reserve.unit_map for Edge Function compatibility';


--
-- TOC entry 269 (class 1259 OID 17435)
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
-- TOC entry 260 (class 1259 OID 17112)
-- Name: schema_migrations; Type: TABLE; Schema: realtime; Owner: -
--

CREATE TABLE realtime.schema_migrations (
    version bigint NOT NULL,
    inserted_at timestamp(0) without time zone
);


--
-- TOC entry 266 (class 1259 OID 17293)
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
-- TOC entry 265 (class 1259 OID 17292)
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
-- TOC entry 288 (class 1259 OID 48702)
-- Name: active_properties_view; Type: VIEW; Schema: reserve; Owner: -
--

CREATE VIEW reserve.active_properties_view AS
SELECT
    NULL::uuid AS id,
    NULL::uuid AS host_property_id,
    NULL::character varying(200) AS name,
    NULL::character varying(200) AS slug,
    NULL::uuid AS city_id,
    NULL::character varying(100) AS city_name,
    NULL::character varying(50) AS property_type,
    NULL::numeric(10,8) AS latitude,
    NULL::numeric(11,8) AS longitude,
    NULL::numeric(2,1) AS rating_cached,
    NULL::integer AS review_count_cached,
    NULL::boolean AS is_active,
    NULL::boolean AS is_published,
    NULL::timestamp with time zone AS created_at,
    NULL::bigint AS unit_count,
    NULL::bigint AS rate_plan_count;


--
-- TOC entry 293 (class 1259 OID 48777)
-- Name: published_properties_view; Type: VIEW; Schema: reserve; Owner: -
--

CREATE VIEW reserve.published_properties_view AS
 SELECT pm.id,
    pm.host_property_id,
    pm.city_id,
    c.code AS city_code,
    c.name AS city_name,
    pm.name,
    pm.slug,
    pm.description,
    pm.property_type,
    pm.address_line_1,
    pm.city AS property_city,
    pm.latitude,
    pm.longitude,
    pm.phone,
    pm.email,
    pm.amenities_cached,
    pm.images_cached,
    pm.rating_cached,
    pm.review_count_cached
   FROM (reserve.properties_map pm
     JOIN reserve.cities c ON ((pm.city_id = c.id)))
  WHERE ((pm.is_active = true) AND (pm.is_published = true) AND (pm.deleted_at IS NULL));


--
-- TOC entry 4647 (class 0 OID 0)
-- Dependencies: 293
-- Name: VIEW published_properties_view; Type: COMMENT; Schema: reserve; Owner: -
--

COMMENT ON VIEW reserve.published_properties_view IS 'Optimized view for availability search - only published, active properties';


--
-- TOC entry 294 (class 1259 OID 48782)
-- Name: active_room_types_view; Type: VIEW; Schema: reserve; Owner: -
--

CREATE VIEW reserve.active_room_types_view AS
 SELECT um.id,
    um.host_unit_id,
    um.host_property_id,
    um.property_id,
    pm.name AS property_name,
    pm.slug AS property_slug,
    pm.city_id,
    pm.city_code,
    um.name AS room_type_name,
    um.slug AS room_type_slug,
    um.max_occupancy,
    um.base_capacity,
    um.amenities_cached,
    um.images_cached,
    um.size_sqm
   FROM (reserve.unit_map um
     JOIN reserve.published_properties_view pm ON ((um.property_id = pm.id)))
  WHERE (((um.unit_type)::text = 'room_type'::text) AND (um.is_active = true) AND (um.deleted_at IS NULL));


--
-- TOC entry 4648 (class 0 OID 0)
-- Dependencies: 294
-- Name: VIEW active_room_types_view; Type: COMMENT; Schema: reserve; Owner: -
--

COMMENT ON VIEW reserve.active_room_types_view IS 'Active room types joined with published property details for search';


--
-- TOC entry 285 (class 1259 OID 48556)
-- Name: audit_logs; Type: TABLE; Schema: reserve; Owner: -
--

CREATE TABLE reserve.audit_logs (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    actor_type character varying(50) NOT NULL,
    actor_id character varying(255),
    actor_email character varying(255),
    action character varying(50) NOT NULL,
    resource_type character varying(50) NOT NULL,
    resource_id uuid,
    before_data jsonb,
    after_data jsonb,
    changed_fields jsonb,
    ip_address inet,
    user_agent text,
    request_id character varying(100),
    session_id character varying(100),
    metadata jsonb DEFAULT '{}'::jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);

ALTER TABLE ONLY reserve.audit_logs FORCE ROW LEVEL SECURITY;


--
-- TOC entry 4649 (class 0 OID 0)
-- Dependencies: 285
-- Name: TABLE audit_logs; Type: COMMENT; Schema: reserve; Owner: -
--

COMMENT ON TABLE reserve.audit_logs IS 'Comprehensive audit trail - who changed what and when';


--
-- TOC entry 4650 (class 0 OID 0)
-- Dependencies: 285
-- Name: COLUMN audit_logs.changed_fields; Type: COMMENT; Schema: reserve; Owner: -
--

COMMENT ON COLUMN reserve.audit_logs.changed_fields IS 'JSON array of field names that were modified';


--
-- TOC entry 279 (class 1259 OID 48358)
-- Name: availability_calendar; Type: TABLE; Schema: reserve; Owner: -
--

CREATE TABLE reserve.availability_calendar (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    unit_id uuid NOT NULL,
    rate_plan_id uuid NOT NULL,
    date date NOT NULL,
    is_available boolean DEFAULT true NOT NULL,
    is_blocked boolean DEFAULT false NOT NULL,
    block_reason character varying(100),
    min_stay_override integer,
    base_price numeric(12,2) NOT NULL,
    discounted_price numeric(12,2),
    currency character varying(3) DEFAULT 'BRL'::character varying NOT NULL,
    allotment integer DEFAULT 1 NOT NULL,
    bookings_count integer DEFAULT 0 NOT NULL,
    host_last_synced_at timestamp with time zone,
    host_data_hash character varying(64),
    source_system character varying(50) DEFAULT 'reserve'::character varying,
    metadata jsonb DEFAULT '{}'::jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT valid_allotment CHECK ((allotment >= 0)),
    CONSTRAINT valid_bookings CHECK (((bookings_count >= 0) AND (bookings_count <= allotment))),
    CONSTRAINT valid_discounted_price CHECK (((discounted_price IS NULL) OR (discounted_price >= (0)::numeric))),
    CONSTRAINT valid_min_stay CHECK (((min_stay_override IS NULL) OR (min_stay_override >= 1))),
    CONSTRAINT valid_price CHECK ((base_price >= (0)::numeric))
);

ALTER TABLE ONLY reserve.availability_calendar FORCE ROW LEVEL SECURITY;


--
-- TOC entry 4651 (class 0 OID 0)
-- Dependencies: 279
-- Name: TABLE availability_calendar; Type: COMMENT; Schema: reserve; Owner: -
--

COMMENT ON TABLE reserve.availability_calendar IS 'Per unit/rate_plan/date availability and pricing - main operational table';


--
-- TOC entry 4652 (class 0 OID 0)
-- Dependencies: 279
-- Name: COLUMN availability_calendar.allotment; Type: COMMENT; Schema: reserve; Owner: -
--

COMMENT ON COLUMN reserve.availability_calendar.allotment IS 'Number of rooms/units available for this date';


--
-- TOC entry 4653 (class 0 OID 0)
-- Dependencies: 279
-- Name: COLUMN availability_calendar.bookings_count; Type: COMMENT; Schema: reserve; Owner: -
--

COMMENT ON COLUMN reserve.availability_calendar.bookings_count IS 'Current confirmed bookings for this slot';


--
-- TOC entry 286 (class 1259 OID 48573)
-- Name: funnel_events; Type: TABLE; Schema: reserve; Owner: -
--

CREATE TABLE reserve.funnel_events (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    session_id character varying(100) NOT NULL,
    visitor_id character varying(100) NOT NULL,
    stage reserve.funnel_stage NOT NULL,
    event_name character varying(100),
    city_id uuid,
    property_id uuid,
    unit_id uuid,
    search_params jsonb,
    utm_source character varying(100),
    utm_medium character varying(100),
    utm_campaign character varying(200),
    utm_content character varying(200),
    referrer character varying(500),
    landing_page character varying(500),
    user_agent text,
    device_type character varying(50),
    browser character varying(50),
    os character varying(50),
    ip_address inet,
    country character varying(100),
    conversion_value numeric(12,2),
    conversion_currency character varying(3),
    reservation_id uuid,
    time_on_page_seconds integer,
    scroll_depth_percent integer,
    metadata jsonb DEFAULT '{}'::jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);

ALTER TABLE ONLY reserve.funnel_events FORCE ROW LEVEL SECURITY;


--
-- TOC entry 4654 (class 0 OID 0)
-- Dependencies: 286
-- Name: TABLE funnel_events; Type: COMMENT; Schema: reserve; Owner: -
--

COMMENT ON TABLE reserve.funnel_events IS 'Conversion funnel tracking - from page view to purchase';


--
-- TOC entry 4655 (class 0 OID 0)
-- Dependencies: 286
-- Name: COLUMN funnel_events.visitor_id; Type: COMMENT; Schema: reserve; Owner: -
--

COMMENT ON COLUMN reserve.funnel_events.visitor_id IS 'Anonymous visitor identifier (persistent across sessions)';


--
-- TOC entry 4656 (class 0 OID 0)
-- Dependencies: 286
-- Name: COLUMN funnel_events.metadata; Type: COMMENT; Schema: reserve; Owner: -
--

COMMENT ON COLUMN reserve.funnel_events.metadata IS 'JSON: ab_test_variant, pricing_shown, etc.';


--
-- TOC entry 287 (class 1259 OID 48611)
-- Name: kpi_daily_snapshots; Type: TABLE; Schema: reserve; Owner: -
--

CREATE TABLE reserve.kpi_daily_snapshots (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    snapshot_date date NOT NULL,
    city_id uuid,
    property_id uuid,
    revenue_total numeric(12,2) DEFAULT 0 NOT NULL,
    revenue_direct numeric(12,2) DEFAULT 0 NOT NULL,
    revenue_ota numeric(12,2) DEFAULT 0 NOT NULL,
    adr numeric(10,2),
    revpar numeric(10,2),
    rooms_total integer DEFAULT 0 NOT NULL,
    rooms_available integer DEFAULT 0 NOT NULL,
    rooms_sold integer DEFAULT 0 NOT NULL,
    occupancy_rate numeric(5,4),
    bookings_total integer DEFAULT 0 NOT NULL,
    bookings_direct integer DEFAULT 0 NOT NULL,
    bookings_ota integer DEFAULT 0 NOT NULL,
    cancellations integer DEFAULT 0 NOT NULL,
    no_shows integer DEFAULT 0 NOT NULL,
    nights_sold integer DEFAULT 0 NOT NULL,
    avg_lead_time_days numeric(5,1),
    avg_length_of_stay numeric(4,1),
    sync_jobs_completed integer DEFAULT 0 NOT NULL,
    sync_jobs_failed integer DEFAULT 0 NOT NULL,
    avg_sync_latency_ms integer,
    api_requests_count integer DEFAULT 0 NOT NULL,
    error_rate numeric(5,4),
    ad_spend numeric(12,2) DEFAULT 0 NOT NULL,
    ad_impressions integer DEFAULT 0 NOT NULL,
    ad_clicks integer DEFAULT 0 NOT NULL,
    ad_conversions integer DEFAULT 0 NOT NULL,
    cac numeric(10,2),
    roas numeric(5,2),
    page_views integer DEFAULT 0 NOT NULL,
    searches integer DEFAULT 0 NOT NULL,
    property_views integer DEFAULT 0 NOT NULL,
    checkout_starts integer DEFAULT 0 NOT NULL,
    checkout_completions integer DEFAULT 0 NOT NULL,
    conversion_rate numeric(5,4),
    metadata jsonb DEFAULT '{}'::jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT valid_conversion CHECK (((conversion_rate IS NULL) OR ((conversion_rate >= (0)::numeric) AND (conversion_rate <= (1)::numeric)))),
    CONSTRAINT valid_occupancy CHECK (((occupancy_rate IS NULL) OR ((occupancy_rate >= (0)::numeric) AND (occupancy_rate <= (1)::numeric))))
);

ALTER TABLE ONLY reserve.kpi_daily_snapshots FORCE ROW LEVEL SECURITY;


--
-- TOC entry 4657 (class 0 OID 0)
-- Dependencies: 287
-- Name: TABLE kpi_daily_snapshots; Type: COMMENT; Schema: reserve; Owner: -
--

COMMENT ON TABLE reserve.kpi_daily_snapshots IS 'Daily aggregated KPIs - revenue, occupancy, ADR, RevPAR, ops, ads';


--
-- TOC entry 4658 (class 0 OID 0)
-- Dependencies: 287
-- Name: COLUMN kpi_daily_snapshots.adr; Type: COMMENT; Schema: reserve; Owner: -
--

COMMENT ON COLUMN reserve.kpi_daily_snapshots.adr IS 'Average Daily Rate = revenue / nights sold';


--
-- TOC entry 4659 (class 0 OID 0)
-- Dependencies: 287
-- Name: COLUMN kpi_daily_snapshots.revpar; Type: COMMENT; Schema: reserve; Owner: -
--

COMMENT ON COLUMN reserve.kpi_daily_snapshots.revpar IS 'Revenue per Available Room = revenue / rooms available';


--
-- TOC entry 4660 (class 0 OID 0)
-- Dependencies: 287
-- Name: COLUMN kpi_daily_snapshots.cac; Type: COMMENT; Schema: reserve; Owner: -
--

COMMENT ON COLUMN reserve.kpi_daily_snapshots.cac IS 'Customer Acquisition Cost = ad_spend / bookings from ads';


--
-- TOC entry 4661 (class 0 OID 0)
-- Dependencies: 287
-- Name: COLUMN kpi_daily_snapshots.roas; Type: COMMENT; Schema: reserve; Owner: -
--

COMMENT ON COLUMN reserve.kpi_daily_snapshots.roas IS 'Return on Ad Spend = revenue from ads / ad_spend';


--
-- TOC entry 278 (class 1259 OID 48329)
-- Name: rate_plans; Type: TABLE; Schema: reserve; Owner: -
--

CREATE TABLE reserve.rate_plans (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    property_id uuid NOT NULL,
    host_rate_plan_id uuid,
    name character varying(200) NOT NULL,
    code character varying(50),
    description text,
    is_default boolean DEFAULT false NOT NULL,
    channels_enabled jsonb DEFAULT '["direct"]'::jsonb,
    min_stay_nights integer DEFAULT 1,
    max_stay_nights integer,
    advance_booking_days integer,
    cancellation_policy_code character varying(50),
    metadata jsonb DEFAULT '{}'::jsonb,
    is_active boolean DEFAULT true NOT NULL,
    deleted_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT valid_advance CHECK (((advance_booking_days IS NULL) OR (advance_booking_days >= 0))),
    CONSTRAINT valid_stay_range CHECK (((max_stay_nights IS NULL) OR (max_stay_nights >= min_stay_nights)))
);

ALTER TABLE ONLY reserve.rate_plans FORCE ROW LEVEL SECURITY;


--
-- TOC entry 4662 (class 0 OID 0)
-- Dependencies: 278
-- Name: TABLE rate_plans; Type: COMMENT; Schema: reserve; Owner: -
--

COMMENT ON TABLE reserve.rate_plans IS 'Rate plans per property - channel-ready configuration';


--
-- TOC entry 4663 (class 0 OID 0)
-- Dependencies: 278
-- Name: COLUMN rate_plans.channels_enabled; Type: COMMENT; Schema: reserve; Owner: -
--

COMMENT ON COLUMN reserve.rate_plans.channels_enabled IS 'JSON array of channels this rate plan applies to';


--
-- TOC entry 281 (class 1259 OID 48423)
-- Name: reservations; Type: TABLE; Schema: reserve; Owner: -
--

CREATE TABLE reserve.reservations (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    traveler_id uuid,
    property_id uuid NOT NULL,
    unit_id uuid NOT NULL,
    rate_plan_id uuid NOT NULL,
    confirmation_code character varying(50) NOT NULL,
    source reserve.reservation_source DEFAULT 'direct'::reserve.reservation_source NOT NULL,
    ota_booking_id character varying(100),
    ota_guest_name character varying(200),
    ota_guest_email character varying(255),
    check_in date NOT NULL,
    check_out date NOT NULL,
    nights integer NOT NULL,
    guests_adults integer DEFAULT 1 NOT NULL,
    guests_children integer DEFAULT 0 NOT NULL,
    guests_infants integer DEFAULT 0 NOT NULL,
    status reserve.reservation_status DEFAULT 'pending'::reserve.reservation_status NOT NULL,
    payment_status reserve.payment_status DEFAULT 'pending'::reserve.payment_status NOT NULL,
    currency character varying(3) DEFAULT 'BRL'::character varying NOT NULL,
    subtotal numeric(12,2) NOT NULL,
    taxes numeric(12,2) DEFAULT 0 NOT NULL,
    fees numeric(12,2) DEFAULT 0 NOT NULL,
    discount_amount numeric(12,2) DEFAULT 0 NOT NULL,
    total_amount numeric(12,2) NOT NULL,
    amount_paid numeric(12,2) DEFAULT 0 NOT NULL,
    guest_first_name character varying(100),
    guest_last_name character varying(100),
    guest_email character varying(255),
    guest_phone character varying(50),
    special_requests text,
    metadata jsonb DEFAULT '{}'::jsonb,
    booked_at timestamp with time zone DEFAULT now() NOT NULL,
    cancelled_at timestamp with time zone,
    cancellation_reason text,
    checked_in_at timestamp with time zone,
    checked_out_at timestamp with time zone,
    deleted_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT valid_amount_paid CHECK (((amount_paid >= (0)::numeric) AND (amount_paid <= total_amount))),
    CONSTRAINT valid_dates CHECK ((check_out > check_in)),
    CONSTRAINT valid_guests CHECK (((guests_adults >= 1) AND (guests_children >= 0) AND (guests_infants >= 0))),
    CONSTRAINT valid_nights CHECK ((nights = (check_out - check_in))),
    CONSTRAINT valid_total CHECK ((total_amount >= (0)::numeric))
);

ALTER TABLE ONLY reserve.reservations FORCE ROW LEVEL SECURITY;


--
-- TOC entry 4664 (class 0 OID 0)
-- Dependencies: 281
-- Name: TABLE reservations; Type: COMMENT; Schema: reserve; Owner: -
--

COMMENT ON TABLE reserve.reservations IS 'All reservations - direct bookings and OTA imports';


--
-- TOC entry 4665 (class 0 OID 0)
-- Dependencies: 281
-- Name: COLUMN reservations.confirmation_code; Type: COMMENT; Schema: reserve; Owner: -
--

COMMENT ON COLUMN reserve.reservations.confirmation_code IS 'Unique booking reference (e.g., RES-2026-ABC123)';


--
-- TOC entry 4666 (class 0 OID 0)
-- Dependencies: 281
-- Name: COLUMN reservations.ota_booking_id; Type: COMMENT; Schema: reserve; Owner: -
--

COMMENT ON COLUMN reserve.reservations.ota_booking_id IS 'External booking reference from OTA';


--
-- TOC entry 4667 (class 0 OID 0)
-- Dependencies: 281
-- Name: COLUMN reservations.metadata; Type: COMMENT; Schema: reserve; Owner: -
--

COMMENT ON COLUMN reserve.reservations.metadata IS 'JSON: payment_details, ota_fees, commission, etc.';


--
-- TOC entry 292 (class 1259 OID 48760)
-- Name: search_config; Type: TABLE; Schema: reserve; Owner: -
--

CREATE TABLE reserve.search_config (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    config_key character varying(100) NOT NULL,
    config_value jsonb NOT NULL,
    description text,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_by uuid
);


--
-- TOC entry 4668 (class 0 OID 0)
-- Dependencies: 292
-- Name: TABLE search_config; Type: COMMENT; Schema: reserve; Owner: -
--

COMMENT ON TABLE reserve.search_config IS 'Configuration for availability search behavior';


--
-- TOC entry 291 (class 1259 OID 48754)
-- Name: sync_failures_view; Type: VIEW; Schema: reserve; Owner: -
--

CREATE VIEW reserve.sync_failures_view AS
 SELECT sl.sync_job_id,
    sj.job_name,
    sj.job_type,
    sl.record_id,
    sl.record_type,
    sl.message AS error_message,
    sl.details AS error_details,
    sl.created_at AS failed_at
   FROM (reserve.sync_logs sl
     JOIN reserve.sync_jobs sj ON ((sl.sync_job_id = sj.id)))
  WHERE (((sl.log_level)::text = 'error'::text) AND (sl.created_at > (now() - '24:00:00'::interval)))
  ORDER BY sl.created_at DESC;


--
-- TOC entry 4669 (class 0 OID 0)
-- Dependencies: 291
-- Name: VIEW sync_failures_view; Type: COMMENT; Schema: reserve; Owner: -
--

COMMENT ON VIEW reserve.sync_failures_view IS 'View of recent sync failures for monitoring and alerting';


--
-- TOC entry 290 (class 1259 OID 48749)
-- Name: sync_jobs_recent_view; Type: VIEW; Schema: reserve; Owner: -
--

CREATE VIEW reserve.sync_jobs_recent_view AS
 SELECT sj.id,
    sj.job_name,
    sj.job_type,
    sj.direction,
    sj.status,
    sj.records_processed,
    sj.records_inserted,
    sj.records_updated,
    sj.records_failed,
    sj.latency_ms,
    sj.started_at,
    sj.completed_at,
    sj.created_at,
    (sj.metadata ->> 'correlation_id'::text) AS correlation_id,
    p.name AS property_name,
    c.name AS city_name
   FROM ((reserve.sync_jobs sj
     LEFT JOIN reserve.properties_map p ON ((sj.property_id = p.id)))
     LEFT JOIN reserve.cities c ON ((sj.city_id = c.id)))
  WHERE (sj.created_at > (now() - '7 days'::interval))
  ORDER BY sj.created_at DESC;


--
-- TOC entry 4670 (class 0 OID 0)
-- Dependencies: 290
-- Name: VIEW sync_jobs_recent_view; Type: COMMENT; Schema: reserve; Owner: -
--

COMMENT ON VIEW reserve.sync_jobs_recent_view IS 'Dashboard view of recent sync jobs with related property/city info';


--
-- TOC entry 280 (class 1259 OID 48398)
-- Name: travelers; Type: TABLE; Schema: reserve; Owner: -
--

CREATE TABLE reserve.travelers (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    auth_user_id uuid,
    email character varying(255) NOT NULL,
    first_name character varying(100),
    last_name character varying(100),
    phone character varying(50),
    phone_country_code character varying(5),
    date_of_birth date,
    nationality character varying(100),
    document_type character varying(50),
    document_number character varying(100),
    address_line_1 character varying(255),
    address_line_2 character varying(255),
    city character varying(100),
    state_province character varying(100),
    postal_code character varying(20),
    country character varying(100),
    preferences jsonb DEFAULT '{}'::jsonb,
    marketing_consent boolean DEFAULT false NOT NULL,
    marketing_consent_at timestamp with time zone,
    is_verified boolean DEFAULT false NOT NULL,
    verification_method character varying(50),
    verified_at timestamp with time zone,
    deleted_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT valid_email CHECK (((email)::text ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'::text))
);

ALTER TABLE ONLY reserve.travelers FORCE ROW LEVEL SECURITY;


--
-- TOC entry 4671 (class 0 OID 0)
-- Dependencies: 280
-- Name: TABLE travelers; Type: COMMENT; Schema: reserve; Owner: -
--

COMMENT ON TABLE reserve.travelers IS 'Traveler accounts - linked to auth.users when registered';


--
-- TOC entry 4672 (class 0 OID 0)
-- Dependencies: 280
-- Name: COLUMN travelers.auth_user_id; Type: COMMENT; Schema: reserve; Owner: -
--

COMMENT ON COLUMN reserve.travelers.auth_user_id IS 'Link to Supabase auth.users (nullable for guest bookings)';


--
-- TOC entry 4673 (class 0 OID 0)
-- Dependencies: 280
-- Name: COLUMN travelers.preferences; Type: COMMENT; Schema: reserve; Owner: -
--

COMMENT ON COLUMN reserve.travelers.preferences IS 'JSON: room_preferences, dietary_restrictions, etc.';


--
-- TOC entry 289 (class 1259 OID 48707)
-- Name: upcoming_reservations_view; Type: VIEW; Schema: reserve; Owner: -
--

CREATE VIEW reserve.upcoming_reservations_view AS
 SELECT r.id,
    r.confirmation_code,
    r.traveler_id,
    (((t.first_name)::text || ' '::text) || (t.last_name)::text) AS traveler_name,
    t.email AS traveler_email,
    r.property_id,
    p.name AS property_name,
    r.unit_id,
    u.name AS unit_name,
    r.check_in,
    r.check_out,
    r.nights,
    r.guests_adults,
    r.guests_children,
    r.status,
    r.payment_status,
    r.total_amount,
    r.currency,
    r.source,
    r.booked_at
   FROM (((reserve.reservations r
     LEFT JOIN reserve.travelers t ON ((r.traveler_id = t.id)))
     JOIN reserve.properties_map p ON ((r.property_id = p.id)))
     JOIN reserve.unit_map u ON ((r.unit_id = u.id)))
  WHERE ((r.check_in >= CURRENT_DATE) AND (r.status = ANY (ARRAY['confirmed'::reserve.reservation_status, 'checked_in'::reserve.reservation_status, 'pending'::reserve.reservation_status])))
  ORDER BY r.check_in;


--
-- TOC entry 240 (class 1259 OID 16546)
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
-- TOC entry 4674 (class 0 OID 0)
-- Dependencies: 240
-- Name: COLUMN buckets.owner; Type: COMMENT; Schema: storage; Owner: -
--

COMMENT ON COLUMN storage.buckets.owner IS 'Field is deprecated, use owner_id instead';


--
-- TOC entry 263 (class 1259 OID 17246)
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
-- TOC entry 271 (class 1259 OID 31171)
-- Name: buckets_vectors; Type: TABLE; Schema: storage; Owner: -
--

CREATE TABLE storage.buckets_vectors (
    id text NOT NULL,
    type storage.buckettype DEFAULT 'VECTOR'::storage.buckettype NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- TOC entry 242 (class 1259 OID 16588)
-- Name: migrations; Type: TABLE; Schema: storage; Owner: -
--

CREATE TABLE storage.migrations (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    hash character varying(40) NOT NULL,
    executed_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- TOC entry 241 (class 1259 OID 16561)
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
-- TOC entry 4675 (class 0 OID 0)
-- Dependencies: 241
-- Name: COLUMN objects.owner; Type: COMMENT; Schema: storage; Owner: -
--

COMMENT ON COLUMN storage.objects.owner IS 'Field is deprecated, use owner_id instead';


--
-- TOC entry 261 (class 1259 OID 17149)
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
-- TOC entry 262 (class 1259 OID 17163)
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
-- TOC entry 272 (class 1259 OID 31181)
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
-- TOC entry 270 (class 1259 OID 22978)
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
-- TOC entry 274 (class 1259 OID 48160)
-- Name: seed_files; Type: TABLE; Schema: supabase_migrations; Owner: -
--

CREATE TABLE supabase_migrations.seed_files (
    path text NOT NULL,
    hash text NOT NULL
);


--
-- TOC entry 3718 (class 2604 OID 16510)
-- Name: refresh_tokens id; Type: DEFAULT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.refresh_tokens ALTER COLUMN id SET DEFAULT nextval('auth.refresh_tokens_id_seq'::regclass);


--
-- TOC entry 4519 (class 0 OID 16525)
-- Dependencies: 238
-- Data for Name: audit_log_entries; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.audit_log_entries (instance_id, id, payload, created_at, ip_address) FROM stdin;
\.


--
-- TOC entry 4533 (class 0 OID 16929)
-- Dependencies: 255
-- Data for Name: flow_state; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.flow_state (id, user_id, auth_code, code_challenge_method, code_challenge, provider_type, provider_access_token, provider_refresh_token, created_at, updated_at, authentication_method, auth_code_issued_at, invite_token, referrer, oauth_client_state_id, linking_target_id, email_optional) FROM stdin;
\.


--
-- TOC entry 4524 (class 0 OID 16727)
-- Dependencies: 246
-- Data for Name: identities; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.identities (provider_id, user_id, identity_data, provider, last_sign_in_at, created_at, updated_at, id) FROM stdin;
\.


--
-- TOC entry 4518 (class 0 OID 16518)
-- Dependencies: 237
-- Data for Name: instances; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.instances (id, uuid, raw_base_config, created_at, updated_at) FROM stdin;
\.


--
-- TOC entry 4528 (class 0 OID 16816)
-- Dependencies: 250
-- Data for Name: mfa_amr_claims; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.mfa_amr_claims (session_id, created_at, updated_at, authentication_method, id) FROM stdin;
\.


--
-- TOC entry 4527 (class 0 OID 16804)
-- Dependencies: 249
-- Data for Name: mfa_challenges; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.mfa_challenges (id, factor_id, created_at, verified_at, ip_address, otp_code, web_authn_session_data) FROM stdin;
\.


--
-- TOC entry 4526 (class 0 OID 16791)
-- Dependencies: 248
-- Data for Name: mfa_factors; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.mfa_factors (id, user_id, friendly_name, factor_type, status, created_at, updated_at, secret, phone, last_challenged_at, web_authn_credential, web_authn_aaguid, last_webauthn_challenge_data) FROM stdin;
\.


--
-- TOC entry 4536 (class 0 OID 17041)
-- Dependencies: 258
-- Data for Name: oauth_authorizations; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.oauth_authorizations (id, authorization_id, client_id, user_id, redirect_uri, scope, state, resource, code_challenge, code_challenge_method, response_type, status, authorization_code, created_at, expires_at, approved_at, nonce) FROM stdin;
\.


--
-- TOC entry 4547 (class 0 OID 39398)
-- Dependencies: 273
-- Data for Name: oauth_client_states; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.oauth_client_states (id, provider_type, code_verifier, created_at) FROM stdin;
\.


--
-- TOC entry 4535 (class 0 OID 17011)
-- Dependencies: 257
-- Data for Name: oauth_clients; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.oauth_clients (id, client_secret_hash, registration_type, redirect_uris, grant_types, client_name, client_uri, logo_uri, created_at, updated_at, deleted_at, client_type, token_endpoint_auth_method) FROM stdin;
\.


--
-- TOC entry 4537 (class 0 OID 17074)
-- Dependencies: 259
-- Data for Name: oauth_consents; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.oauth_consents (id, user_id, client_id, scopes, granted_at, revoked_at) FROM stdin;
\.


--
-- TOC entry 4534 (class 0 OID 16979)
-- Dependencies: 256
-- Data for Name: one_time_tokens; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.one_time_tokens (id, user_id, token_type, token_hash, relates_to, created_at, updated_at) FROM stdin;
\.


--
-- TOC entry 4517 (class 0 OID 16507)
-- Dependencies: 236
-- Data for Name: refresh_tokens; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.refresh_tokens (instance_id, id, token, user_id, revoked, created_at, updated_at, parent, session_id) FROM stdin;
\.


--
-- TOC entry 4531 (class 0 OID 16858)
-- Dependencies: 253
-- Data for Name: saml_providers; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.saml_providers (id, sso_provider_id, entity_id, metadata_xml, metadata_url, attribute_mapping, created_at, updated_at, name_id_format) FROM stdin;
\.


--
-- TOC entry 4532 (class 0 OID 16876)
-- Dependencies: 254
-- Data for Name: saml_relay_states; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.saml_relay_states (id, sso_provider_id, request_id, for_email, redirect_to, created_at, updated_at, flow_state_id) FROM stdin;
\.


--
-- TOC entry 4520 (class 0 OID 16533)
-- Dependencies: 239
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
-- TOC entry 4525 (class 0 OID 16757)
-- Dependencies: 247
-- Data for Name: sessions; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.sessions (id, user_id, created_at, updated_at, factor_id, aal, not_after, refreshed_at, user_agent, ip, tag, oauth_client_id, refresh_token_hmac_key, refresh_token_counter, scopes) FROM stdin;
\.


--
-- TOC entry 4530 (class 0 OID 16843)
-- Dependencies: 252
-- Data for Name: sso_domains; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.sso_domains (id, sso_provider_id, domain, created_at, updated_at) FROM stdin;
\.


--
-- TOC entry 4529 (class 0 OID 16834)
-- Dependencies: 251
-- Data for Name: sso_providers; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.sso_providers (id, resource_id, created_at, updated_at, disabled) FROM stdin;
\.


--
-- TOC entry 4515 (class 0 OID 16495)
-- Dependencies: 234
-- Data for Name: users; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.users (instance_id, id, aud, role, email, encrypted_password, email_confirmed_at, invited_at, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user, deleted_at, is_anonymous) FROM stdin;
\.


--
-- TOC entry 4538 (class 0 OID 17112)
-- Dependencies: 260
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: realtime; Owner: -
--

COPY realtime.schema_migrations (version, inserted_at) FROM stdin;
20211116024918	2025-10-16 02:42:49
20211116045059	2025-10-16 02:42:53
20211116050929	2025-10-16 02:42:57
20211116051442	2025-10-16 02:43:00
20211116212300	2025-10-16 02:43:04
20211116213355	2025-10-16 02:43:07
20211116213934	2025-10-16 02:43:11
20211116214523	2025-10-16 02:43:15
20211122062447	2025-10-16 02:43:19
20211124070109	2025-10-16 02:43:22
20211202204204	2025-10-16 02:43:25
20211202204605	2025-10-16 02:43:29
20211210212804	2025-10-16 02:43:40
20211228014915	2025-10-16 02:43:43
20220107221237	2025-10-16 02:43:46
20220228202821	2025-10-16 02:43:50
20220312004840	2025-10-16 02:43:53
20220603231003	2025-10-16 02:43:58
20220603232444	2025-10-16 02:44:02
20220615214548	2025-10-16 02:44:06
20220712093339	2025-10-16 02:44:09
20220908172859	2025-10-16 02:44:12
20220916233421	2025-10-16 02:44:16
20230119133233	2025-10-16 02:44:19
20230128025114	2025-10-16 02:44:24
20230128025212	2025-10-16 02:44:27
20230227211149	2025-10-16 02:44:30
20230228184745	2025-10-16 02:44:34
20230308225145	2025-10-16 02:44:37
20230328144023	2025-10-16 02:44:40
20231018144023	2025-10-16 02:44:44
20231204144023	2025-10-16 02:44:49
20231204144024	2025-10-16 02:44:53
20231204144025	2025-10-16 02:44:56
20240108234812	2025-10-16 02:44:59
20240109165339	2025-10-16 02:45:02
20240227174441	2025-10-16 02:45:08
20240311171622	2025-10-16 02:45:13
20240321100241	2025-10-16 02:45:20
20240401105812	2025-10-16 02:45:29
20240418121054	2025-10-16 02:45:34
20240523004032	2025-10-16 02:45:46
20240618124746	2025-10-16 02:45:49
20240801235015	2025-10-16 02:45:52
20240805133720	2025-10-16 02:45:55
20240827160934	2025-10-16 02:45:59
20240919163303	2025-10-16 02:46:03
20240919163305	2025-10-16 02:46:07
20241019105805	2025-10-16 02:46:10
20241030150047	2025-10-16 02:46:22
20241108114728	2025-10-16 02:46:27
20241121104152	2025-10-16 02:46:30
20241130184212	2025-10-16 02:46:34
20241220035512	2025-10-16 02:46:37
20241220123912	2025-10-16 02:46:41
20241224161212	2025-10-16 02:46:44
20250107150512	2025-10-16 02:46:47
20250110162412	2025-10-16 02:46:51
20250123174212	2025-10-16 02:46:54
20250128220012	2025-10-16 02:46:57
20250506224012	2025-10-16 02:47:00
20250523164012	2025-10-16 02:47:03
20250714121412	2025-10-16 02:47:06
20250905041441	2025-10-16 02:47:10
20251103001201	2025-11-26 11:44:37
20251120212548	2026-02-13 11:20:14
20251120215549	2026-02-13 11:20:15
\.


--
-- TOC entry 4543 (class 0 OID 17293)
-- Dependencies: 266
-- Data for Name: subscription; Type: TABLE DATA; Schema: realtime; Owner: -
--

COPY realtime.subscription (id, subscription_id, entity, filters, claims, created_at, action_filter) FROM stdin;
\.


--
-- TOC entry 4559 (class 0 OID 48556)
-- Dependencies: 285
-- Data for Name: audit_logs; Type: TABLE DATA; Schema: reserve; Owner: -
--

COPY reserve.audit_logs (id, actor_type, actor_id, actor_email, action, resource_type, resource_id, before_data, after_data, changed_fields, ip_address, user_agent, request_id, session_id, metadata, created_at) FROM stdin;
\.


--
-- TOC entry 4553 (class 0 OID 48358)
-- Dependencies: 279
-- Data for Name: availability_calendar; Type: TABLE DATA; Schema: reserve; Owner: -
--

COPY reserve.availability_calendar (id, unit_id, rate_plan_id, date, is_available, is_blocked, block_reason, min_stay_override, base_price, discounted_price, currency, allotment, bookings_count, host_last_synced_at, host_data_hash, source_system, metadata, created_at, updated_at) FROM stdin;
\.


--
-- TOC entry 4549 (class 0 OID 48251)
-- Dependencies: 275
-- Data for Name: cities; Type: TABLE DATA; Schema: reserve; Owner: -
--

COPY reserve.cities (id, code, name, state_province, country, timezone, currency, is_active, metadata, created_at, updated_at) FROM stdin;
d43195ef-4c43-49ce-94bf-110dc24c7062	URB	Urubici	Santa Catarina	Brazil	America/Sao_Paulo	BRL	t	{}	2026-02-13 21:13:40.892948+00	2026-02-13 21:13:40.892948+00
\.


--
-- TOC entry 4558 (class 0 OID 48534)
-- Dependencies: 284
-- Data for Name: events; Type: TABLE DATA; Schema: reserve; Owner: -
--

COPY reserve.events (id, event_name, event_version, severity, actor_type, actor_id, entity_type, entity_id, payload, payload_schema, processed_at, processor_id, error_message, retry_count, correlation_id, causation_id, metadata, created_at) FROM stdin;
562ffa0d-7a1d-47fc-8bd2-1843f6e2c8a2	host.property.synced	1.0	info	edge_function	sync_host_properties	property	d085883f-3e0d-4920-a4cd-fb22ae03b57a	{"action": "insert", "sync_job_id": "d26d87ef-d50e-483c-8818-0c3e500e8d4f", "property_name": "Urubici Park Hotel (Seed)", "host_property_id": "11111111-1111-1111-1111-111111111111"}	\N	\N	\N	\N	0	65a701da-d2db-426f-8cff-c7c25347b184	\N	{}	2026-02-14 12:26:02.417+00
36197766-e27a-4db8-9021-5bc56c3268a2	host.properties.sync.completed	1.0	info	edge_function	sync_host_properties	sync_job	d26d87ef-d50e-483c-8818-0c3e500e8d4f	{"stats": {"failed": 0, "skipped": 0, "updated": 0, "inserted": 1, "processed": 1}, "duration_ms": 1831, "sync_job_id": "d26d87ef-d50e-483c-8818-0c3e500e8d4f"}	\N	\N	\N	\N	0	65a701da-d2db-426f-8cff-c7c25347b184	\N	{}	2026-02-14 12:26:02.506+00
2aeada0e-2023-468a-891b-03b17f672697	host.room_type.synced	1.0	info	edge_function	sync_host_room_types	unit	ad0633de-1690-40ab-9e9a-5836118db2ff	{"action": "insert", "property_id": "d085883f-3e0d-4920-a4cd-fb22ae03b57a", "sync_job_id": "994c11c2-7250-4322-b207-63414f9c1f94", "room_type_name": "Standard (Seed)", "host_property_id": "11111111-1111-1111-1111-111111111111", "host_room_type_id": "22222222-2222-2222-2222-222222222222"}	\N	\N	\N	\N	0	8ef557f2-a5e5-426a-8c30-950b1d482d08	\N	{}	2026-02-14 12:26:13.897+00
3e6fe186-6f1c-4038-8ec6-ceb74532c3be	host.room_type.synced	1.0	info	edge_function	sync_host_room_types	unit	37db6027-626c-4312-adb5-3fb7c2a29ba3	{"action": "insert", "property_id": "d085883f-3e0d-4920-a4cd-fb22ae03b57a", "sync_job_id": "994c11c2-7250-4322-b207-63414f9c1f94", "room_type_name": "Deluxe (Seed)", "host_property_id": "11111111-1111-1111-1111-111111111111", "host_room_type_id": "33333333-3333-3333-3333-333333333333"}	\N	\N	\N	\N	0	8ef557f2-a5e5-426a-8c30-950b1d482d08	\N	{}	2026-02-14 12:26:14.009+00
ea16eefb-f17f-461d-a372-fd7de29ad566	host.room_types.sync.completed	1.0	info	edge_function	sync_host_room_types	sync_job	994c11c2-7250-4322-b207-63414f9c1f94	{"stats": {"failed": 0, "skipped": 0, "updated": 0, "inserted": 2, "orphaned": 0, "processed": 2}, "duration_ms": 426, "sync_job_id": "994c11c2-7250-4322-b207-63414f9c1f94"}	\N	\N	\N	\N	0	8ef557f2-a5e5-426a-8c30-950b1d482d08	\N	{}	2026-02-14 12:26:14.06+00
d7416f00-e93d-44c6-be6d-03abe4f0fd42	host.properties.sync.completed	1.0	info	edge_function	sync_host_properties	sync_job	2ee53150-fbd3-4000-8d25-9e1200cd166b	{"stats": {"failed": 0, "skipped": 1, "updated": 0, "inserted": 0, "processed": 1}, "duration_ms": 299, "sync_job_id": "2ee53150-fbd3-4000-8d25-9e1200cd166b"}	\N	\N	\N	\N	0	36750c54-c1c6-4ea3-9234-8269d88a7d95	\N	{}	2026-02-14 12:28:50.634+00
0b095f84-db20-4af6-bc5a-9b5dabc49a76	host.room_types.sync.completed	1.0	info	edge_function	sync_host_room_types	sync_job	7f305503-7d78-4d23-88ca-803dcaf367ff	{"stats": {"failed": 0, "skipped": 2, "updated": 0, "inserted": 0, "orphaned": 0, "processed": 2}, "duration_ms": 383, "sync_job_id": "7f305503-7d78-4d23-88ca-803dcaf367ff"}	\N	\N	\N	\N	0	79a27a81-9855-40c6-a7a0-815ab81be9e5	\N	{}	2026-02-14 12:28:51.416+00
fb42cb3b-053a-4e7a-98b2-a6950313a84a	host.properties.sync.completed	1.0	info	edge_function	sync_host_properties	sync_job	8917ea0f-fd96-46ec-9171-2aa9e51b7926	{"stats": {"failed": 0, "skipped": 1, "updated": 0, "inserted": 0, "processed": 1}, "duration_ms": 2094, "sync_job_id": "8917ea0f-fd96-46ec-9171-2aa9e51b7926"}	\N	\N	\N	\N	0	f62f6fd2-9c1a-4a6b-8c0d-077223ddbe31	\N	{}	2026-02-14 15:41:21.318+00
10221f06-9fef-4dbf-834d-bc440df96eb4	host.room_types.sync.completed	1.0	info	edge_function	sync_host_room_types	sync_job	dd8264a7-2d28-4a98-a54d-0c8728c3f9cc	{"stats": {"failed": 0, "skipped": 2, "updated": 0, "inserted": 0, "orphaned": 0, "processed": 2}, "duration_ms": 320, "sync_job_id": "dd8264a7-2d28-4a98-a54d-0c8728c3f9cc"}	\N	\N	\N	\N	0	3cbe458c-c6ac-4b97-8ada-ef0447437b50	\N	{}	2026-02-14 15:41:23.661+00
bece02ff-4f01-4eeb-877e-3c7a723ef535	host.properties.sync.completed	1.0	info	edge_function	sync_host_properties	sync_job	b412d5f8-64d1-4e11-8a25-9260b2091a57	{"stats": {"failed": 0, "skipped": 1, "updated": 0, "inserted": 0, "processed": 1}, "duration_ms": 393, "sync_job_id": "b412d5f8-64d1-4e11-8a25-9260b2091a57"}	\N	\N	\N	\N	0	d2ae2179-0532-4155-b857-eee10b83f25f	\N	{}	2026-02-14 15:42:20.561+00
1bf0d88d-ffe7-4fe7-b5b9-7c1fa0d75ac7	host.room_types.sync.completed	1.0	info	edge_function	sync_host_room_types	sync_job	6cbd63a2-a031-4d3f-ab5b-272e0debd90d	{"stats": {"failed": 0, "skipped": 2, "updated": 0, "inserted": 0, "orphaned": 0, "processed": 2}, "duration_ms": 386, "sync_job_id": "6cbd63a2-a031-4d3f-ab5b-272e0debd90d"}	\N	\N	\N	\N	0	8a3f3efa-9fd3-452e-be44-d2c72020594b	\N	{}	2026-02-14 15:42:21.338+00
edf81839-c883-4a59-a475-ebd7d553e8da	host.properties.sync.completed	1.0	info	edge_function	sync_host_properties	sync_job	2329001e-25d4-4dcc-aba9-6ab1bb617343	{"stats": {"failed": 0, "skipped": 1, "updated": 0, "inserted": 0, "processed": 1}, "duration_ms": 1296, "sync_job_id": "2329001e-25d4-4dcc-aba9-6ab1bb617343"}	\N	\N	\N	\N	0	43d0e79d-35fc-4314-b357-0945d10c49de	\N	{}	2026-02-14 16:27:22.245+00
8477d1a4-a204-4f2c-afa4-db0f226e0dfa	host.room_types.sync.completed	1.0	info	edge_function	sync_host_room_types	sync_job	4930a703-4442-4f62-a8fd-a9128cc7d980	{"stats": {"failed": 0, "skipped": 2, "updated": 0, "inserted": 0, "orphaned": 0, "processed": 2}, "duration_ms": 354, "sync_job_id": "4930a703-4442-4f62-a8fd-a9128cc7d980"}	\N	\N	\N	\N	0	83617fea-f29b-46d3-b955-ea22283a6b8f	\N	{}	2026-02-14 16:27:23.029+00
2341ee12-b6b6-42e8-af15-8e1f32ce462f	host.properties.sync.completed	1.0	info	edge_function	sync_host_properties	sync_job	ecda27b6-18b2-47d8-b4d5-32ab1fb24e0b	{"stats": {"failed": 0, "skipped": 1, "updated": 0, "inserted": 0, "processed": 1}, "duration_ms": 696, "sync_job_id": "ecda27b6-18b2-47d8-b4d5-32ab1fb24e0b"}	\N	\N	\N	\N	0	8edc4c95-3f2e-49df-8780-99a6fc79f461	\N	{}	2026-02-14 16:29:31.522+00
13f1f734-2f52-4076-81dc-5489a96aa716	host.room_types.sync.completed	1.0	info	edge_function	sync_host_room_types	sync_job	63589645-5b66-485d-b682-a859ae786c32	{"stats": {"failed": 0, "skipped": 2, "updated": 0, "inserted": 0, "orphaned": 0, "processed": 2}, "duration_ms": 346, "sync_job_id": "63589645-5b66-485d-b682-a859ae786c32"}	\N	\N	\N	\N	0	b3662c0f-24cc-496f-86a0-c33361f26ba8	\N	{}	2026-02-14 16:29:32.201+00
1e532daa-1adb-4ddd-8d7b-b95e1b67196b	host.properties.sync.completed	1.0	info	edge_function	sync_host_properties	sync_job	7feafded-091d-46a7-93d2-8885fc187d95	{"stats": {"failed": 0, "skipped": 1, "updated": 0, "inserted": 0, "processed": 1}, "duration_ms": 627, "sync_job_id": "7feafded-091d-46a7-93d2-8885fc187d95"}	\N	\N	\N	\N	0	f8d01de9-101c-4fc7-b731-6dad56b30658	\N	{}	2026-02-14 16:32:12.807+00
b4f304c0-e210-4f58-a19f-a07deee0deb2	host.room_types.sync.completed	1.0	info	edge_function	sync_host_room_types	sync_job	a7696f47-a304-4492-81e6-2e3e7b914c3b	{"stats": {"failed": 0, "skipped": 2, "updated": 0, "inserted": 0, "orphaned": 0, "processed": 2}, "duration_ms": 331, "sync_job_id": "a7696f47-a304-4492-81e6-2e3e7b914c3b"}	\N	\N	\N	\N	0	671d5f21-8e0b-4b90-8933-3ead601c5c1a	\N	{}	2026-02-14 16:32:13.489+00
7c51c576-ddbc-4535-bcce-ebd6c0b3cfbd	host.properties.sync.completed	1.0	info	edge_function	sync_host_properties	sync_job	87e518a4-1f7a-4203-b5cd-c8d83d248de0	{"stats": {"failed": 0, "skipped": 1, "updated": 0, "inserted": 0, "processed": 1}, "duration_ms": 878, "sync_job_id": "87e518a4-1f7a-4203-b5cd-c8d83d248de0"}	\N	\N	\N	\N	0	234a15f8-1c19-48ba-bc3c-0166fbf5020f	\N	{}	2026-02-14 16:33:09.527+00
f4a9c43b-da9a-4c68-84fc-da8680d718cb	host.room_types.sync.completed	1.0	info	edge_function	sync_host_room_types	sync_job	44888e22-8762-4a11-9b6a-294fff7fe63d	{"stats": {"failed": 0, "skipped": 2, "updated": 0, "inserted": 0, "orphaned": 0, "processed": 2}, "duration_ms": 337, "sync_job_id": "44888e22-8762-4a11-9b6a-294fff7fe63d"}	\N	\N	\N	\N	0	96a1ee84-0a53-44c1-97d0-5c9f68bef5d4	\N	{}	2026-02-14 16:33:10.298+00
49eef1d8-931b-4a94-b26b-22af7465e782	host.properties.sync.completed	1.0	info	edge_function	sync_host_properties	sync_job	31894fa9-4aa2-4edf-90d8-8c410d9a08ab	{"stats": {"failed": 0, "skipped": 1, "updated": 0, "inserted": 0, "processed": 1}, "duration_ms": 276, "sync_job_id": "31894fa9-4aa2-4edf-90d8-8c410d9a08ab"}	\N	\N	\N	\N	0	5cf77428-8015-4838-b4bf-e992dcc2a4b1	\N	{}	2026-02-14 16:36:50.352+00
3ef6eca3-1fa7-48f0-be79-d634be38652d	host.room_types.sync.completed	1.0	info	edge_function	sync_host_room_types	sync_job	842e8df6-a8cb-4bac-b6d6-a38d9ca2d90a	{"stats": {"failed": 0, "skipped": 2, "updated": 0, "inserted": 0, "orphaned": 0, "processed": 2}, "duration_ms": 363, "sync_job_id": "842e8df6-a8cb-4bac-b6d6-a38d9ca2d90a"}	\N	\N	\N	\N	0	0b1e0b13-a26a-4158-9c01-f89ca0b3ab03	\N	{}	2026-02-14 16:36:51.112+00
f687258e-b24d-44e8-9c17-f6adc3f9d970	host.properties.sync.completed	1.0	info	edge_function	sync_host_properties	sync_job	757b517f-2430-4f6a-98fd-55b50ce181dd	{"stats": {"failed": 0, "skipped": 1, "updated": 0, "inserted": 0, "processed": 1}, "duration_ms": 295, "sync_job_id": "757b517f-2430-4f6a-98fd-55b50ce181dd"}	\N	\N	\N	\N	0	66797678-b1c0-4b3e-9787-bb756bf8d928	\N	{}	2026-02-14 16:40:12.756+00
2723f93a-61a9-48c8-bd87-505229a78644	host.room_types.sync.completed	1.0	info	edge_function	sync_host_room_types	sync_job	4d8ea7c0-5dd4-4aa4-91a5-2c456b7cdce6	{"stats": {"failed": 0, "skipped": 2, "updated": 0, "inserted": 0, "orphaned": 0, "processed": 2}, "duration_ms": 416, "sync_job_id": "4d8ea7c0-5dd4-4aa4-91a5-2c456b7cdce6"}	\N	\N	\N	\N	0	334994e5-602d-4ca4-b7ae-38f6ca27388b	\N	{}	2026-02-14 16:40:13.536+00
357ea686-2263-4a38-bc82-9073c2e0a225	host.properties.sync.completed	1.0	info	edge_function	sync_host_properties	sync_job	c845b851-0f9e-46f8-948a-d147ed27828b	{"stats": {"failed": 0, "skipped": 1, "updated": 0, "inserted": 0, "processed": 1}, "duration_ms": 1049, "sync_job_id": "c845b851-0f9e-46f8-948a-d147ed27828b"}	\N	\N	\N	\N	0	b41a1792-e62d-475b-9d70-d643de0a4bb9	\N	{}	2026-02-14 16:53:03.121+00
1591223d-eb8f-4a71-985d-ff0a2cbf2a83	host.room_types.sync.completed	1.0	info	edge_function	sync_host_room_types	sync_job	70668a10-ce6f-468f-9053-a048774251b1	{"stats": {"failed": 0, "skipped": 2, "updated": 0, "inserted": 0, "orphaned": 0, "processed": 2}, "duration_ms": 492, "sync_job_id": "70668a10-ce6f-468f-9053-a048774251b1"}	\N	\N	\N	\N	0	f2dadb68-59ee-455f-b7b1-d9855e73c1de	\N	{}	2026-02-14 16:53:06.523+00
\.


--
-- TOC entry 4560 (class 0 OID 48573)
-- Dependencies: 286
-- Data for Name: funnel_events; Type: TABLE DATA; Schema: reserve; Owner: -
--

COPY reserve.funnel_events (id, session_id, visitor_id, stage, event_name, city_id, property_id, unit_id, search_params, utm_source, utm_medium, utm_campaign, utm_content, referrer, landing_page, user_agent, device_type, browser, os, ip_address, country, conversion_value, conversion_currency, reservation_id, time_on_page_seconds, scroll_depth_percent, metadata, created_at) FROM stdin;
\.


--
-- TOC entry 4561 (class 0 OID 48611)
-- Dependencies: 287
-- Data for Name: kpi_daily_snapshots; Type: TABLE DATA; Schema: reserve; Owner: -
--

COPY reserve.kpi_daily_snapshots (id, snapshot_date, city_id, property_id, revenue_total, revenue_direct, revenue_ota, adr, revpar, rooms_total, rooms_available, rooms_sold, occupancy_rate, bookings_total, bookings_direct, bookings_ota, cancellations, no_shows, nights_sold, avg_lead_time_days, avg_length_of_stay, sync_jobs_completed, sync_jobs_failed, avg_sync_latency_ms, api_requests_count, error_rate, ad_spend, ad_impressions, ad_clicks, ad_conversions, cac, roas, page_views, searches, property_views, checkout_starts, checkout_completions, conversion_rate, metadata, created_at, updated_at) FROM stdin;
\.


--
-- TOC entry 4550 (class 0 OID 48270)
-- Dependencies: 276
-- Data for Name: properties_map; Type: TABLE DATA; Schema: reserve; Owner: -
--

COPY reserve.properties_map (id, host_property_id, city_id, name, slug, description, property_type, address_line_1, address_line_2, city, state_province, postal_code, country, latitude, longitude, phone, email, website, amenities_cached, images_cached, rating_cached, review_count_cached, host_last_synced_at, host_data_hash, is_active, is_published, deleted_at, created_at, updated_at) FROM stdin;
d085883f-3e0d-4920-a4cd-fb22ae03b57a	11111111-1111-1111-1111-111111111111	d43195ef-4c43-49ce-94bf-110dc24c7062	Urubici Park Hotel (Seed)	urubici-park-hotel-seed-11111111	Seed de testes para validar sync Host → Reserve e search_availability.	\N	\N	\N	Urubici	\N	88650-000	BR	\N	\N	(49) 99999-9999	seed@urubiciparkhotel.com	\N	[]	[]	\N	0	2026-02-14 12:26:02.333+00	c5e46bc8bab1c880d1115a2ede7fa203a6e2f880e1346adf597d62d96506f227	t	t	\N	2026-02-14 12:26:02.349401+00	2026-02-14 12:28:07.039336+00
\.


--
-- TOC entry 4552 (class 0 OID 48329)
-- Dependencies: 278
-- Data for Name: rate_plans; Type: TABLE DATA; Schema: reserve; Owner: -
--

COPY reserve.rate_plans (id, property_id, host_rate_plan_id, name, code, description, is_default, channels_enabled, min_stay_nights, max_stay_nights, advance_booking_days, cancellation_policy_code, metadata, is_active, deleted_at, created_at, updated_at) FROM stdin;
\.


--
-- TOC entry 4555 (class 0 OID 48423)
-- Dependencies: 281
-- Data for Name: reservations; Type: TABLE DATA; Schema: reserve; Owner: -
--

COPY reserve.reservations (id, traveler_id, property_id, unit_id, rate_plan_id, confirmation_code, source, ota_booking_id, ota_guest_name, ota_guest_email, check_in, check_out, nights, guests_adults, guests_children, guests_infants, status, payment_status, currency, subtotal, taxes, fees, discount_amount, total_amount, amount_paid, guest_first_name, guest_last_name, guest_email, guest_phone, special_requests, metadata, booked_at, cancelled_at, cancellation_reason, checked_in_at, checked_out_at, deleted_at, created_at, updated_at) FROM stdin;
\.


--
-- TOC entry 4562 (class 0 OID 48760)
-- Dependencies: 292
-- Data for Name: search_config; Type: TABLE DATA; Schema: reserve; Owner: -
--

COPY reserve.search_config (id, config_key, config_value, description, updated_at, updated_by) FROM stdin;
d32ef149-0c33-485a-bac9-69d0748be301	room_active_statuses	["active", "available", "clean", "ready"]	Room statuses considered available for booking	2026-02-13 21:14:36.224126+00	\N
d03765f5-e3af-48cd-bfbf-12a6b510b0e9	booking_active_statuses	["confirmed", "checked_in", "pending"]	Booking statuses that block availability	2026-02-13 21:14:36.224126+00	\N
a917dda3-f7cb-4ccb-85ce-db8ac9babed2	pricing_rule_active_statuses	["active", "published"]	Pricing rule statuses to apply	2026-02-13 21:14:36.224126+00	\N
b103f4d3-4cac-44ee-b400-4ca44ba05de1	default_page_size	20	Default number of results per page	2026-02-13 21:14:36.224126+00	\N
5467b893-4fe3-4537-b71a-f27182e3b50e	max_page_size	100	Maximum results per page allowed	2026-02-13 21:14:36.224126+00	\N
43abfd9b-a5ab-439d-a135-a2a942672779	max_nights	365	Maximum nights allowed per search	2026-02-13 21:14:36.224126+00	\N
af0774ff-29ca-445c-8950-ee7c69ebfe5a	min_nights	1	Minimum nights required	2026-02-13 21:14:36.224126+00	\N
\.


--
-- TOC entry 4556 (class 0 OID 48484)
-- Dependencies: 282
-- Data for Name: sync_jobs; Type: TABLE DATA; Schema: reserve; Owner: -
--

COPY reserve.sync_jobs (id, job_name, job_type, direction, property_id, city_id, date_from, date_to, status, priority, started_at, completed_at, failed_at, error_message, error_details, retry_count, max_retries, records_processed, records_inserted, records_updated, records_failed, latency_ms, source_payload_hash, target_payload_hash, metadata, created_at, updated_at) FROM stdin;
d26d87ef-d50e-483c-8818-0c3e500e8d4f	sync_all_properties	properties	pull_from_host	\N	\N	\N	\N	completed	5	2026-02-14 12:26:00.678+00	2026-02-14 12:26:02.456+00	\N	\N	\N	0	3	1	1	0	0	1781	\N	\N	{"page_size": 100, "correlation_id": "65a701da-d2db-426f-8cff-c7c25347b184"}	2026-02-14 12:26:01.006025+00	2026-02-14 12:26:02.475275+00
994c11c2-7250-4322-b207-63414f9c1f94	sync_all_room_types	room_types	pull_from_host	\N	\N	\N	\N	completed	5	2026-02-14 12:26:13.637+00	2026-02-14 12:26:14.033+00	\N	\N	\N	0	3	2	2	0	0	399	\N	\N	{"page_size": 100, "correlation_id": "8ef557f2-a5e5-426a-8c30-950b1d482d08"}	2026-02-14 12:26:13.706661+00	2026-02-14 12:26:14.047903+00
2ee53150-fbd3-4000-8d25-9e1200cd166b	sync_all_properties	properties	pull_from_host	\N	\N	\N	\N	completed	5	2026-02-14 12:28:50.34+00	2026-02-14 12:28:50.6+00	\N	\N	\N	0	3	1	0	0	0	266	\N	\N	{"page_size": 100, "correlation_id": "36750c54-c1c6-4ea3-9234-8269d88a7d95"}	2026-02-14 12:28:50.429199+00	2026-02-14 12:28:50.623312+00
7f305503-7d78-4d23-88ca-803dcaf367ff	sync_all_room_types	room_types	pull_from_host	\N	\N	\N	\N	completed	5	2026-02-14 12:28:51.035+00	2026-02-14 12:28:51.386+00	\N	\N	\N	0	3	2	0	0	0	353	\N	\N	{"page_size": 100, "correlation_id": "79a27a81-9855-40c6-a7a0-815ab81be9e5"}	2026-02-14 12:28:51.116542+00	2026-02-14 12:28:51.402753+00
8917ea0f-fd96-46ec-9171-2aa9e51b7926	sync_all_properties	properties	pull_from_host	\N	\N	\N	\N	completed	5	2026-02-14 15:41:19.225+00	2026-02-14 15:41:21.272+00	\N	\N	\N	0	3	1	0	0	0	2048	\N	\N	{"page_size": 100, "correlation_id": "f62f6fd2-9c1a-4a6b-8c0d-077223ddbe31"}	2026-02-14 15:41:19.885739+00	2026-02-14 15:41:21.291557+00
dd8264a7-2d28-4a98-a54d-0c8728c3f9cc	sync_all_room_types	room_types	pull_from_host	\N	\N	\N	\N	completed	5	2026-02-14 15:41:23.344+00	2026-02-14 15:41:23.635+00	\N	\N	\N	0	3	2	0	0	0	294	\N	\N	{"page_size": 100, "correlation_id": "3cbe458c-c6ac-4b97-8ada-ef0447437b50"}	2026-02-14 15:41:23.385489+00	2026-02-14 15:41:23.650311+00
b412d5f8-64d1-4e11-8a25-9260b2091a57	sync_all_properties	properties	pull_from_host	\N	\N	\N	\N	completed	5	2026-02-14 15:42:20.169+00	2026-02-14 15:42:20.526+00	\N	\N	\N	0	3	1	0	0	0	359	\N	\N	{"page_size": 100, "correlation_id": "d2ae2179-0532-4155-b857-eee10b83f25f"}	2026-02-14 15:42:20.307779+00	2026-02-14 15:42:20.550395+00
6cbd63a2-a031-4d3f-ab5b-272e0debd90d	sync_all_room_types	room_types	pull_from_host	\N	\N	\N	\N	completed	5	2026-02-14 15:42:20.954+00	2026-02-14 15:42:21.31+00	\N	\N	\N	0	3	2	0	0	0	358	\N	\N	{"page_size": 100, "correlation_id": "8a3f3efa-9fd3-452e-be44-d2c72020594b"}	2026-02-14 15:42:21.043011+00	2026-02-14 15:42:21.328928+00
2329001e-25d4-4dcc-aba9-6ab1bb617343	sync_all_properties	properties	pull_from_host	\N	\N	\N	\N	completed	5	2026-02-14 16:27:20.951+00	2026-02-14 16:27:22.216+00	\N	\N	\N	0	3	1	0	0	0	1268	\N	\N	{"page_size": 100, "correlation_id": "43d0e79d-35fc-4314-b357-0945d10c49de"}	2026-02-14 16:27:21.331906+00	2026-02-14 16:27:22.232152+00
4930a703-4442-4f62-a8fd-a9128cc7d980	sync_all_room_types	room_types	pull_from_host	\N	\N	\N	\N	completed	5	2026-02-14 16:27:22.678+00	2026-02-14 16:27:23.005+00	\N	\N	\N	0	3	2	0	0	0	330	\N	\N	{"page_size": 100, "correlation_id": "83617fea-f29b-46d3-b955-ea22283a6b8f"}	2026-02-14 16:27:22.754783+00	2026-02-14 16:27:23.020406+00
ecda27b6-18b2-47d8-b4d5-32ab1fb24e0b	sync_all_properties	properties	pull_from_host	\N	\N	\N	\N	completed	5	2026-02-14 16:29:30.829+00	2026-02-14 16:29:31.49+00	\N	\N	\N	0	3	1	0	0	0	664	\N	\N	{"page_size": 100, "correlation_id": "8edc4c95-3f2e-49df-8780-99a6fc79f461"}	2026-02-14 16:29:31.030981+00	2026-02-14 16:29:31.509169+00
63589645-5b66-485d-b682-a859ae786c32	sync_all_room_types	room_types	pull_from_host	\N	\N	\N	\N	completed	5	2026-02-14 16:29:31.857+00	2026-02-14 16:29:32.172+00	\N	\N	\N	0	3	2	0	0	0	317	\N	\N	{"page_size": 100, "correlation_id": "b3662c0f-24cc-496f-86a0-c33361f26ba8"}	2026-02-14 16:29:31.936613+00	2026-02-14 16:29:32.19406+00
7feafded-091d-46a7-93d2-8885fc187d95	sync_all_properties	properties	pull_from_host	\N	\N	\N	\N	completed	5	2026-02-14 16:32:12.183+00	2026-02-14 16:32:12.781+00	\N	\N	\N	0	3	1	0	0	0	601	\N	\N	{"page_size": 100, "correlation_id": "f8d01de9-101c-4fc7-b731-6dad56b30658"}	2026-02-14 16:32:12.233472+00	2026-02-14 16:32:12.798611+00
a7696f47-a304-4492-81e6-2e3e7b914c3b	sync_all_room_types	room_types	pull_from_host	\N	\N	\N	\N	completed	5	2026-02-14 16:32:13.159+00	2026-02-14 16:32:13.462+00	\N	\N	\N	0	3	2	0	0	0	304	\N	\N	{"page_size": 100, "correlation_id": "671d5f21-8e0b-4b90-8933-3ead601c5c1a"}	2026-02-14 16:32:13.194809+00	2026-02-14 16:32:13.478494+00
87e518a4-1f7a-4203-b5cd-c8d83d248de0	sync_all_properties	properties	pull_from_host	\N	\N	\N	\N	completed	5	2026-02-14 16:33:08.651+00	2026-02-14 16:33:09.47+00	\N	\N	\N	0	3	1	0	0	0	821	\N	\N	{"page_size": 100, "correlation_id": "234a15f8-1c19-48ba-bc3c-0166fbf5020f"}	2026-02-14 16:33:09.085921+00	2026-02-14 16:33:09.51137+00
44888e22-8762-4a11-9b6a-294fff7fe63d	sync_all_room_types	room_types	pull_from_host	\N	\N	\N	\N	completed	5	2026-02-14 16:33:09.964+00	2026-02-14 16:33:10.268+00	\N	\N	\N	0	3	2	0	0	0	307	\N	\N	{"page_size": 100, "correlation_id": "96a1ee84-0a53-44c1-97d0-5c9f68bef5d4"}	2026-02-14 16:33:10.004029+00	2026-02-14 16:33:10.289671+00
31894fa9-4aa2-4edf-90d8-8c410d9a08ab	sync_all_properties	properties	pull_from_host	\N	\N	\N	\N	completed	5	2026-02-14 16:36:50.078+00	2026-02-14 16:36:50.321+00	\N	\N	\N	0	3	1	0	0	0	245	\N	\N	{"page_size": 100, "correlation_id": "5cf77428-8015-4838-b4bf-e992dcc2a4b1"}	2026-02-14 16:36:50.14518+00	2026-02-14 16:36:50.343701+00
842e8df6-a8cb-4bac-b6d6-a38d9ca2d90a	sync_all_room_types	room_types	pull_from_host	\N	\N	\N	\N	completed	5	2026-02-14 16:36:50.751+00	2026-02-14 16:36:51.085+00	\N	\N	\N	0	3	2	0	0	0	336	\N	\N	{"page_size": 100, "correlation_id": "0b1e0b13-a26a-4158-9c01-f89ca0b3ab03"}	2026-02-14 16:36:50.833517+00	2026-02-14 16:36:51.103616+00
757b517f-2430-4f6a-98fd-55b50ce181dd	sync_all_properties	properties	pull_from_host	\N	\N	\N	\N	completed	5	2026-02-14 16:40:12.466+00	2026-02-14 16:40:12.725+00	\N	\N	\N	0	3	1	0	0	0	264	\N	\N	{"page_size": 100, "correlation_id": "66797678-b1c0-4b3e-9787-bb756bf8d928"}	2026-02-14 16:40:12.514413+00	2026-02-14 16:40:12.746068+00
4d8ea7c0-5dd4-4aa4-91a5-2c456b7cdce6	sync_all_room_types	room_types	pull_from_host	\N	\N	\N	\N	completed	5	2026-02-14 16:40:13.122+00	2026-02-14 16:40:13.504+00	\N	\N	\N	0	3	2	0	0	0	385	\N	\N	{"page_size": 100, "correlation_id": "334994e5-602d-4ca4-b7ae-38f6ca27388b"}	2026-02-14 16:40:13.198793+00	2026-02-14 16:40:13.525835+00
c845b851-0f9e-46f8-948a-d147ed27828b	sync_all_properties	properties	pull_from_host	\N	\N	\N	\N	completed	5	2026-02-14 16:53:02.075+00	2026-02-14 16:53:03.071+00	\N	\N	\N	0	3	1	0	0	0	999	\N	\N	{"page_size": 100, "correlation_id": "b41a1792-e62d-475b-9d70-d643de0a4bb9"}	2026-02-14 16:53:02.181516+00	2026-02-14 16:53:03.104757+00
70668a10-ce6f-468f-9053-a048774251b1	sync_all_room_types	room_types	pull_from_host	\N	\N	\N	\N	completed	5	2026-02-14 16:53:06.034+00	2026-02-14 16:53:06.481+00	\N	\N	\N	0	3	2	0	0	0	450	\N	\N	{"page_size": 100, "correlation_id": "f2dadb68-59ee-455f-b7b1-d9855e73c1de"}	2026-02-14 16:53:06.086834+00	2026-02-14 16:53:06.507184+00
\.


--
-- TOC entry 4557 (class 0 OID 48515)
-- Dependencies: 283
-- Data for Name: sync_logs; Type: TABLE DATA; Schema: reserve; Owner: -
--

COPY reserve.sync_logs (id, sync_job_id, log_level, message, details, record_id, record_type, action, created_at) FROM stdin;
4d44e1f2-362f-436e-b455-95210ee0f013	d26d87ef-d50e-483c-8818-0c3e500e8d4f	info	Inserted property 11111111-1111-1111-1111-111111111111	\N	d085883f-3e0d-4920-a4cd-fb22ae03b57a	property	insert	2026-02-14 12:26:02.39254+00
0c2f9998-9eab-4da6-add0-d87ec589e88a	994c11c2-7250-4322-b207-63414f9c1f94	info	Inserted room type 22222222-2222-2222-2222-222222222222	\N	ad0633de-1690-40ab-9e9a-5836118db2ff	room_type	insert	2026-02-14 12:26:13.885888+00
2da50a91-2a1b-463b-841c-702c3a021a97	994c11c2-7250-4322-b207-63414f9c1f94	info	Inserted room type 33333333-3333-3333-3333-333333333333	\N	37db6027-626c-4312-adb5-3fb7c2a29ba3	room_type	insert	2026-02-14 12:26:13.9996+00
e474d036-ebc0-4ef5-ad1c-a145894e39d6	2ee53150-fbd3-4000-8d25-9e1200cd166b	debug	Property 11111111-1111-1111-1111-111111111111 unchanged, skipping	\N	d085883f-3e0d-4920-a4cd-fb22ae03b57a	property	skip	2026-02-14 12:28:50.58999+00
79178b69-91be-4695-8b57-605a8874e422	7f305503-7d78-4d23-88ca-803dcaf367ff	debug	Room type 22222222-2222-2222-2222-222222222222 unchanged, skipping	\N	ad0633de-1690-40ab-9e9a-5836118db2ff	room_type	skip	2026-02-14 12:28:51.311347+00
c478e0b0-bbf2-4dc4-a386-cb50c002cc43	7f305503-7d78-4d23-88ca-803dcaf367ff	debug	Room type 33333333-3333-3333-3333-333333333333 unchanged, skipping	\N	37db6027-626c-4312-adb5-3fb7c2a29ba3	room_type	skip	2026-02-14 12:28:51.375056+00
80d3280b-611c-4c8d-80d2-b16ad4e9c4af	8917ea0f-fd96-46ec-9171-2aa9e51b7926	debug	Property 11111111-1111-1111-1111-111111111111 unchanged, skipping	\N	d085883f-3e0d-4920-a4cd-fb22ae03b57a	property	skip	2026-02-14 15:41:21.239069+00
76cff987-2ac4-4b8f-8643-2e07ab4aeb60	dd8264a7-2d28-4a98-a54d-0c8728c3f9cc	debug	Room type 22222222-2222-2222-2222-222222222222 unchanged, skipping	\N	ad0633de-1690-40ab-9e9a-5836118db2ff	room_type	skip	2026-02-14 15:41:23.570778+00
5b95d126-0d8a-42e7-9855-83c7f23dac89	dd8264a7-2d28-4a98-a54d-0c8728c3f9cc	debug	Room type 33333333-3333-3333-3333-333333333333 unchanged, skipping	\N	37db6027-626c-4312-adb5-3fb7c2a29ba3	room_type	skip	2026-02-14 15:41:23.624713+00
6589a770-1b7e-4391-99b3-024bb255e5a0	b412d5f8-64d1-4e11-8a25-9260b2091a57	debug	Property 11111111-1111-1111-1111-111111111111 unchanged, skipping	\N	d085883f-3e0d-4920-a4cd-fb22ae03b57a	property	skip	2026-02-14 15:42:20.497538+00
b738a835-c899-4704-9b8e-3c7f69568544	6cbd63a2-a031-4d3f-ab5b-272e0debd90d	debug	Room type 22222222-2222-2222-2222-222222222222 unchanged, skipping	\N	ad0633de-1690-40ab-9e9a-5836118db2ff	room_type	skip	2026-02-14 15:42:21.234527+00
2104ee4b-f2d3-4009-95a2-1bddadd75079	6cbd63a2-a031-4d3f-ab5b-272e0debd90d	debug	Room type 33333333-3333-3333-3333-333333333333 unchanged, skipping	\N	37db6027-626c-4312-adb5-3fb7c2a29ba3	room_type	skip	2026-02-14 15:42:21.298724+00
b8995add-3790-404b-9120-72c829c0730a	2329001e-25d4-4dcc-aba9-6ab1bb617343	debug	Property 11111111-1111-1111-1111-111111111111 unchanged, skipping	\N	d085883f-3e0d-4920-a4cd-fb22ae03b57a	property	skip	2026-02-14 16:27:22.202801+00
fd20207f-2ac4-4ed9-b40e-764ce035dc39	4930a703-4442-4f62-a8fd-a9128cc7d980	debug	Room type 22222222-2222-2222-2222-222222222222 unchanged, skipping	\N	ad0633de-1690-40ab-9e9a-5836118db2ff	room_type	skip	2026-02-14 16:27:22.943315+00
23c523af-fd0f-4d07-b434-70ee8c701eca	4930a703-4442-4f62-a8fd-a9128cc7d980	debug	Room type 33333333-3333-3333-3333-333333333333 unchanged, skipping	\N	37db6027-626c-4312-adb5-3fb7c2a29ba3	room_type	skip	2026-02-14 16:27:22.998322+00
676bd61a-2a85-47a1-aae7-7541543143e1	ecda27b6-18b2-47d8-b4d5-32ab1fb24e0b	debug	Property 11111111-1111-1111-1111-111111111111 unchanged, skipping	\N	d085883f-3e0d-4920-a4cd-fb22ae03b57a	property	skip	2026-02-14 16:29:31.475675+00
673608d1-0258-45da-b921-e75cab00cd18	63589645-5b66-485d-b682-a859ae786c32	debug	Room type 22222222-2222-2222-2222-222222222222 unchanged, skipping	\N	ad0633de-1690-40ab-9e9a-5836118db2ff	room_type	skip	2026-02-14 16:29:32.113748+00
65d9ff24-602c-4af8-a166-b992b89332a9	63589645-5b66-485d-b682-a859ae786c32	debug	Room type 33333333-3333-3333-3333-333333333333 unchanged, skipping	\N	37db6027-626c-4312-adb5-3fb7c2a29ba3	room_type	skip	2026-02-14 16:29:32.159645+00
e957329e-6b11-41b0-b6b5-8826a4b6c47e	7feafded-091d-46a7-93d2-8885fc187d95	debug	Property 11111111-1111-1111-1111-111111111111 unchanged, skipping	\N	d085883f-3e0d-4920-a4cd-fb22ae03b57a	property	skip	2026-02-14 16:32:12.772341+00
12aadd14-9c18-4f68-b419-f6e58659cb0d	a7696f47-a304-4492-81e6-2e3e7b914c3b	debug	Room type 22222222-2222-2222-2222-222222222222 unchanged, skipping	\N	ad0633de-1690-40ab-9e9a-5836118db2ff	room_type	skip	2026-02-14 16:32:13.401542+00
340ab263-f950-404f-9832-f99d9caf669f	a7696f47-a304-4492-81e6-2e3e7b914c3b	debug	Room type 33333333-3333-3333-3333-333333333333 unchanged, skipping	\N	37db6027-626c-4312-adb5-3fb7c2a29ba3	room_type	skip	2026-02-14 16:32:13.454158+00
45ca05b9-d60e-4a16-80ea-7ece14630a4a	87e518a4-1f7a-4203-b5cd-c8d83d248de0	debug	Property 11111111-1111-1111-1111-111111111111 unchanged, skipping	\N	d085883f-3e0d-4920-a4cd-fb22ae03b57a	property	skip	2026-02-14 16:33:09.45079+00
92eed37f-b814-4c50-b5ef-002c3b5103a6	44888e22-8762-4a11-9b6a-294fff7fe63d	debug	Room type 22222222-2222-2222-2222-222222222222 unchanged, skipping	\N	ad0633de-1690-40ab-9e9a-5836118db2ff	room_type	skip	2026-02-14 16:33:10.174177+00
9a99e946-7c4e-4577-8920-c9036c90a796	44888e22-8762-4a11-9b6a-294fff7fe63d	debug	Room type 33333333-3333-3333-3333-333333333333 unchanged, skipping	\N	37db6027-626c-4312-adb5-3fb7c2a29ba3	room_type	skip	2026-02-14 16:33:10.251979+00
d02a9415-eaeb-406d-8a09-12f1440d43d2	31894fa9-4aa2-4edf-90d8-8c410d9a08ab	debug	Property 11111111-1111-1111-1111-111111111111 unchanged, skipping	\N	d085883f-3e0d-4920-a4cd-fb22ae03b57a	property	skip	2026-02-14 16:36:50.311841+00
c0ed02a7-325a-4ddc-9f71-8471ea02eb19	842e8df6-a8cb-4bac-b6d6-a38d9ca2d90a	debug	Room type 22222222-2222-2222-2222-222222222222 unchanged, skipping	\N	ad0633de-1690-40ab-9e9a-5836118db2ff	room_type	skip	2026-02-14 16:36:51.020045+00
60ca52d3-36f5-4353-9e2c-0d6e85832fbc	842e8df6-a8cb-4bac-b6d6-a38d9ca2d90a	debug	Room type 33333333-3333-3333-3333-333333333333 unchanged, skipping	\N	37db6027-626c-4312-adb5-3fb7c2a29ba3	room_type	skip	2026-02-14 16:36:51.07644+00
73d7ddae-c48c-4ffd-b5b1-272a8dd699fd	757b517f-2430-4f6a-98fd-55b50ce181dd	debug	Property 11111111-1111-1111-1111-111111111111 unchanged, skipping	\N	d085883f-3e0d-4920-a4cd-fb22ae03b57a	property	skip	2026-02-14 16:40:12.717811+00
f70612d1-53da-4bd7-b4d1-a1bf24f8c1a7	4d8ea7c0-5dd4-4aa4-91a5-2c456b7cdce6	debug	Room type 22222222-2222-2222-2222-222222222222 unchanged, skipping	\N	ad0633de-1690-40ab-9e9a-5836118db2ff	room_type	skip	2026-02-14 16:40:13.431096+00
e898471c-7c83-4268-8439-c998b0e3a1c3	4d8ea7c0-5dd4-4aa4-91a5-2c456b7cdce6	debug	Room type 33333333-3333-3333-3333-333333333333 unchanged, skipping	\N	37db6027-626c-4312-adb5-3fb7c2a29ba3	room_type	skip	2026-02-14 16:40:13.486808+00
6c6e5dbe-403c-4759-9ec3-a729c1096cb3	c845b851-0f9e-46f8-948a-d147ed27828b	debug	Property 11111111-1111-1111-1111-111111111111 unchanged, skipping	\N	d085883f-3e0d-4920-a4cd-fb22ae03b57a	property	skip	2026-02-14 16:53:03.062774+00
112da4c2-11fa-4e11-9a7a-a600d3a50428	70668a10-ce6f-468f-9053-a048774251b1	debug	Room type 22222222-2222-2222-2222-222222222222 unchanged, skipping	\N	ad0633de-1690-40ab-9e9a-5836118db2ff	room_type	skip	2026-02-14 16:53:06.402492+00
e1b8fed3-2177-4725-aa0d-b4f3276c041e	70668a10-ce6f-468f-9053-a048774251b1	debug	Room type 33333333-3333-3333-3333-333333333333 unchanged, skipping	\N	37db6027-626c-4312-adb5-3fb7c2a29ba3	room_type	skip	2026-02-14 16:53:06.4745+00
\.


--
-- TOC entry 4554 (class 0 OID 48398)
-- Dependencies: 280
-- Data for Name: travelers; Type: TABLE DATA; Schema: reserve; Owner: -
--

COPY reserve.travelers (id, auth_user_id, email, first_name, last_name, phone, phone_country_code, date_of_birth, nationality, document_type, document_number, address_line_1, address_line_2, city, state_province, postal_code, country, preferences, marketing_consent, marketing_consent_at, is_verified, verification_method, verified_at, deleted_at, created_at, updated_at) FROM stdin;
\.


--
-- TOC entry 4551 (class 0 OID 48301)
-- Dependencies: 277
-- Data for Name: unit_map; Type: TABLE DATA; Schema: reserve; Owner: -
--

COPY reserve.unit_map (id, host_unit_id, property_id, name, slug, unit_type, description, max_occupancy, base_capacity, amenities_cached, images_cached, size_sqm, bed_configuration, host_last_synced_at, host_data_hash, is_active, deleted_at, created_at, updated_at, host_property_id) FROM stdin;
ad0633de-1690-40ab-9e9a-5836118db2ff	22222222-2222-2222-2222-222222222222	d085883f-3e0d-4920-a4cd-fb22ae03b57a	Standard (Seed)	standard-seed-22222222	room_type	Quarto standard para testes.	2	2	[]	[]	\N	[]	2026-02-14 12:26:13.842+00	48952e98fb79750a30af562b352102a44f2995722fd1b6192009426323c423e3	t	\N	2026-02-14 12:26:13.854236+00	2026-02-14 12:26:13.854236+00	11111111-1111-1111-1111-111111111111
37db6027-626c-4312-adb5-3fb7c2a29ba3	33333333-3333-3333-3333-333333333333	d085883f-3e0d-4920-a4cd-fb22ae03b57a	Deluxe (Seed)	deluxe-seed-33333333	room_type	Quarto deluxe para testes.	2	2	[]	[]	\N	[]	2026-02-14 12:26:13.942+00	d3ca965673d56ded339e4d5f9795c656ffc5e8951fe8355104a10437781d1be9	t	\N	2026-02-14 12:26:13.963292+00	2026-02-14 12:26:13.963292+00	11111111-1111-1111-1111-111111111111
\.


--
-- TOC entry 4521 (class 0 OID 16546)
-- Dependencies: 240
-- Data for Name: buckets; Type: TABLE DATA; Schema: storage; Owner: -
--

COPY storage.buckets (id, name, owner, created_at, updated_at, public, avif_autodetection, file_size_limit, allowed_mime_types, owner_id, type) FROM stdin;
website-assets	website-assets	\N	2025-10-16 18:13:56.642649+00	2025-10-16 18:13:56.642649+00	t	f	6291456	{image/jpeg,image/png,image/webp,image/gif}	\N	STANDARD
product-images	product-images	\N	2025-11-26 12:06:40.489265+00	2025-11-26 12:06:40.489265+00	t	f	\N	\N	\N	STANDARD
public-assets	public-assets	\N	2026-02-14 16:52:32.633965+00	2026-02-14 16:52:32.633965+00	t	f	\N	\N	\N	STANDARD
property-photos	property-photos	\N	2026-02-14 16:52:32.633965+00	2026-02-14 16:52:32.633965+00	f	f	\N	\N	\N	STANDARD
unit-photos	unit-photos	\N	2026-02-14 16:52:32.633965+00	2026-02-14 16:52:32.633965+00	f	f	\N	\N	\N	STANDARD
\.


--
-- TOC entry 4541 (class 0 OID 17246)
-- Dependencies: 263
-- Data for Name: buckets_analytics; Type: TABLE DATA; Schema: storage; Owner: -
--

COPY storage.buckets_analytics (name, type, format, created_at, updated_at, id, deleted_at) FROM stdin;
\.


--
-- TOC entry 4545 (class 0 OID 31171)
-- Dependencies: 271
-- Data for Name: buckets_vectors; Type: TABLE DATA; Schema: storage; Owner: -
--

COPY storage.buckets_vectors (id, type, created_at, updated_at) FROM stdin;
\.


--
-- TOC entry 4523 (class 0 OID 16588)
-- Dependencies: 242
-- Data for Name: migrations; Type: TABLE DATA; Schema: storage; Owner: -
--

COPY storage.migrations (id, name, hash, executed_at) FROM stdin;
0	create-migrations-table	e18db593bcde2aca2a408c4d1100f6abba2195df	2025-10-16 02:42:44.410542
1	initialmigration	6ab16121fbaa08bbd11b712d05f358f9b555d777	2025-10-16 02:42:44.419766
3	pathtoken-column	2cb1b0004b817b29d5b0a971af16bafeede4b70d	2025-10-16 02:42:44.455222
4	add-migrations-rls	427c5b63fe1c5937495d9c635c263ee7a5905058	2025-10-16 02:42:44.505097
5	add-size-functions	79e081a1455b63666c1294a440f8ad4b1e6a7f84	2025-10-16 02:42:44.512433
7	add-rls-to-buckets	e7e7f86adbc51049f341dfe8d30256c1abca17aa	2025-10-16 02:42:44.529343
8	add-public-to-buckets	fd670db39ed65f9d08b01db09d6202503ca2bab3	2025-10-16 02:42:44.536548
11	add-trigger-to-auto-update-updated_at-column	7425bdb14366d1739fa8a18c83100636d74dcaa2	2025-10-16 02:42:44.577731
12	add-automatic-avif-detection-flag	8e92e1266eb29518b6a4c5313ab8f29dd0d08df9	2025-10-16 02:42:44.5885
13	add-bucket-custom-limits	cce962054138135cd9a8c4bcd531598684b25e7d	2025-10-16 02:42:44.596426
14	use-bytes-for-max-size	941c41b346f9802b411f06f30e972ad4744dad27	2025-10-16 02:42:44.604075
15	add-can-insert-object-function	934146bc38ead475f4ef4b555c524ee5d66799e5	2025-10-16 02:42:44.62977
16	add-version	76debf38d3fd07dcfc747ca49096457d95b1221b	2025-10-16 02:42:44.63716
17	drop-owner-foreign-key	f1cbb288f1b7a4c1eb8c38504b80ae2a0153d101	2025-10-16 02:42:44.644506
18	add_owner_id_column_deprecate_owner	e7a511b379110b08e2f214be852c35414749fe66	2025-10-16 02:42:44.652424
19	alter-default-value-objects-id	02e5e22a78626187e00d173dc45f58fa66a4f043	2025-10-16 02:42:44.661413
20	list-objects-with-delimiter	cd694ae708e51ba82bf012bba00caf4f3b6393b7	2025-10-16 02:42:44.671575
21	s3-multipart-uploads	8c804d4a566c40cd1e4cc5b3725a664a9303657f	2025-10-16 02:42:44.68562
22	s3-multipart-uploads-big-ints	9737dc258d2397953c9953d9b86920b8be0cdb73	2025-10-16 02:42:44.70276
23	optimize-search-function	9d7e604cddc4b56a5422dc68c9313f4a1b6f132c	2025-10-16 02:42:44.716218
24	operation-function	8312e37c2bf9e76bbe841aa5fda889206d2bf8aa	2025-10-16 02:42:44.723878
25	custom-metadata	d974c6057c3db1c1f847afa0e291e6165693b990	2025-10-16 02:42:44.731495
37	add-bucket-name-length-trigger	3944135b4e3e8b22d6d4cbb568fe3b0b51df15c1	2025-10-16 02:42:44.83652
44	vector-bucket-type	99c20c0ffd52bb1ff1f32fb992f3b351e3ef8fb3	2025-11-26 11:42:50.580744
45	vector-buckets	049e27196d77a7cb76497a85afae669d8b230953	2025-11-26 11:42:50.608825
46	buckets-objects-grants	fedeb96d60fefd8e02ab3ded9fbde05632f84aed	2025-11-26 11:42:50.68223
47	iceberg-table-metadata	649df56855c24d8b36dd4cc1aeb8251aa9ad42c2	2025-11-26 11:42:50.68934
49	buckets-objects-grants-postgres	072b1195d0d5a2f888af6b2302a1938dd94b8b3d	2026-01-03 19:24:22.071783
2	storage-schema	f6a1fa2c93cbcd16d4e487b362e45fca157a8dbd	2025-10-16 02:42:44.429798
6	change-column-name-in-get-size	ded78e2f1b5d7e616117897e6443a925965b30d2	2025-10-16 02:42:44.521949
9	fix-search-function	af597a1b590c70519b464a4ab3be54490712796b	2025-10-16 02:42:44.544109
10	search-files-search-function	b595f05e92f7e91211af1bbfe9c6a13bb3391e16	2025-10-16 02:42:44.568868
26	objects-prefixes	215cabcb7f78121892a5a2037a09fedf9a1ae322	2025-10-16 02:42:44.73892
27	search-v2	859ba38092ac96eb3964d83bf53ccc0b141663a6	2025-10-16 02:42:44.753841
28	object-bucket-name-sorting	c73a2b5b5d4041e39705814fd3a1b95502d38ce4	2025-10-16 02:42:44.767349
29	create-prefixes	ad2c1207f76703d11a9f9007f821620017a66c21	2025-10-16 02:42:44.774657
30	update-object-levels	2be814ff05c8252fdfdc7cfb4b7f5c7e17f0bed6	2025-10-16 02:42:44.781623
31	objects-level-index	b40367c14c3440ec75f19bbce2d71e914ddd3da0	2025-10-16 02:42:44.790136
32	backward-compatible-index-on-objects	e0c37182b0f7aee3efd823298fb3c76f1042c0f7	2025-10-16 02:42:44.798751
33	backward-compatible-index-on-prefixes	b480e99ed951e0900f033ec4eb34b5bdcb4e3d49	2025-10-16 02:42:44.807301
34	optimize-search-function-v1	ca80a3dc7bfef894df17108785ce29a7fc8ee456	2025-10-16 02:42:44.809891
35	add-insert-trigger-prefixes	458fe0ffd07ec53f5e3ce9df51bfdf4861929ccc	2025-10-16 02:42:44.819066
36	optimise-existing-functions	6ae5fca6af5c55abe95369cd4f93985d1814ca8f	2025-10-16 02:42:44.826499
38	iceberg-catalog-flag-on-buckets	02716b81ceec9705aed84aa1501657095b32e5c5	2025-10-16 02:42:44.845072
39	add-search-v2-sort-support	6706c5f2928846abee18461279799ad12b279b78	2025-10-16 02:42:44.856817
40	fix-prefix-race-conditions-optimized	7ad69982ae2d372b21f48fc4829ae9752c518f6b	2025-10-16 02:42:44.864709
41	add-object-level-update-trigger	07fcf1a22165849b7a029deed059ffcde08d1ae0	2025-10-16 02:42:44.876161
42	rollback-prefix-triggers	771479077764adc09e2ea2043eb627503c034cd4	2025-10-16 02:42:44.884578
43	fix-object-level	84b35d6caca9d937478ad8a797491f38b8c2979f	2025-10-16 02:42:44.894094
48	iceberg-catalog-ids	e0e8b460c609b9999ccd0df9ad14294613eed939	2025-11-26 11:42:50.696753
50	search-v2-optimised	6323ac4f850aa14e7387eb32102869578b5bd478	2026-02-13 01:48:21.803814
51	index-backward-compatible-search	2ee395d433f76e38bcd3856debaf6e0e5b674011	2026-02-13 01:48:21.897912
52	drop-not-used-indexes-and-functions	5cc44c8696749ac11dd0dc37f2a3802075f3a171	2026-02-13 01:48:21.901766
53	drop-index-lower-name	d0cb18777d9e2a98ebe0bc5cc7a42e57ebe41854	2026-02-13 01:48:21.96682
54	drop-index-object-level	6289e048b1472da17c31a7eba1ded625a6457e67	2026-02-13 01:48:21.969941
55	prevent-direct-deletes	262a4798d5e0f2e7c8970232e03ce8be695d5819	2026-02-13 01:48:21.971584
56	fix-optimized-search-function	cb58526ebc23048049fd5bf2fd148d18b04a2073	2026-02-13 01:48:21.981847
\.


--
-- TOC entry 4522 (class 0 OID 16561)
-- Dependencies: 241
-- Data for Name: objects; Type: TABLE DATA; Schema: storage; Owner: -
--

COPY storage.objects (id, bucket_id, name, owner, created_at, updated_at, last_accessed_at, metadata, version, owner_id, user_metadata) FROM stdin;
c1ea1305-2bda-4282-8968-eea113a436e0	website-assets	ReserveConnect Logotipo.png	\N	2025-10-16 18:14:46.014744+00	2025-10-16 18:14:46.014744+00	2025-10-16 18:14:46.014744+00	{"eTag": "\\"b83779e91547189acc62260caa98295e-1\\"", "size": 924548, "mimetype": "image/png", "cacheControl": "max-age=3600", "lastModified": "2025-10-16T18:14:46.000Z", "contentLength": 924548, "httpStatusCode": 200}	793dbaa4-460e-40c9-9ba3-e6cd72d09859	\N	\N
\.


--
-- TOC entry 4539 (class 0 OID 17149)
-- Dependencies: 261
-- Data for Name: s3_multipart_uploads; Type: TABLE DATA; Schema: storage; Owner: -
--

COPY storage.s3_multipart_uploads (id, in_progress_size, upload_signature, bucket_id, key, version, owner_id, created_at, user_metadata) FROM stdin;
\.


--
-- TOC entry 4540 (class 0 OID 17163)
-- Dependencies: 262
-- Data for Name: s3_multipart_uploads_parts; Type: TABLE DATA; Schema: storage; Owner: -
--

COPY storage.s3_multipart_uploads_parts (id, upload_id, size, part_number, bucket_id, key, etag, owner_id, version, created_at) FROM stdin;
\.


--
-- TOC entry 4546 (class 0 OID 31181)
-- Dependencies: 272
-- Data for Name: vector_indexes; Type: TABLE DATA; Schema: storage; Owner: -
--

COPY storage.vector_indexes (id, name, bucket_id, data_type, dimension, distance_metric, metadata_configuration, created_at, updated_at) FROM stdin;
\.


--
-- TOC entry 4544 (class 0 OID 22978)
-- Dependencies: 270
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: supabase_migrations; Owner: -
--

COPY supabase_migrations.schema_migrations (version, statements, name, created_by, idempotency_key, rollback) FROM stdin;
20251027200246	{"-- ============================================\n-- FASE 1: Sistema de Autenticação e Perfis\n-- ============================================\n\n-- 1. Criar ENUM para roles de usuário\nCREATE TYPE public.app_role AS ENUM ('user', 'host', 'admin');\n\n-- 2. Tabela de Perfis de Usuário\nCREATE TABLE public.profiles (\n  id uuid PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,\n  full_name text NOT NULL,\n  phone text,\n  avatar_url text,\n  cpf text UNIQUE,\n  date_of_birth date,\n  created_at timestamptz DEFAULT now() NOT NULL,\n  updated_at timestamptz DEFAULT now() NOT NULL\n);\n\n-- 3. Tabela de Roles (SEPARADA por segurança - previne escalação de privilégios)\nCREATE TABLE public.user_roles (\n  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),\n  user_id uuid REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,\n  role app_role NOT NULL DEFAULT 'user',\n  created_at timestamptz DEFAULT now() NOT NULL,\n  UNIQUE(user_id, role)\n);\n\n-- 4. Índices para performance\nCREATE INDEX idx_profiles_cpf ON public.profiles(cpf);\nCREATE INDEX idx_user_roles_user_id ON public.user_roles(user_id);\nCREATE INDEX idx_user_roles_role ON public.user_roles(role);\n\n-- 5. Função Security Definer para verificar roles (previne recursão em RLS)\nCREATE OR REPLACE FUNCTION public.has_role(_user_id uuid, _role app_role)\nRETURNS boolean\nLANGUAGE sql\nSTABLE\nSECURITY DEFINER\nSET search_path = public\nAS $$\n  SELECT EXISTS (\n    SELECT 1 FROM public.user_roles\n    WHERE user_id = _user_id AND role = _role\n  )\n$$;\n\n-- 6. RLS Policies para Profiles\nALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;\n\nCREATE POLICY \\"Users can view their own profile\\"\n  ON public.profiles FOR SELECT\n  USING (auth.uid() = id);\n\nCREATE POLICY \\"Users can update their own profile\\"\n  ON public.profiles FOR UPDATE\n  USING (auth.uid() = id);\n\nCREATE POLICY \\"Users can insert their own profile\\"\n  ON public.profiles FOR INSERT\n  WITH CHECK (auth.uid() = id);\n\n-- 7. RLS Policies para User Roles\nALTER TABLE public.user_roles ENABLE ROW LEVEL SECURITY;\n\nCREATE POLICY \\"Users can view their own roles\\"\n  ON public.user_roles FOR SELECT\n  USING (auth.uid() = user_id);\n\nCREATE POLICY \\"Admins can view all roles\\"\n  ON public.user_roles FOR SELECT\n  USING (public.has_role(auth.uid(), 'admin'));\n\nCREATE POLICY \\"Admins can manage roles\\"\n  ON public.user_roles FOR ALL\n  USING (public.has_role(auth.uid(), 'admin'));\n\n-- 8. Função para atualizar updated_at automaticamente\nCREATE OR REPLACE FUNCTION public.handle_updated_at()\nRETURNS trigger\nLANGUAGE plpgsql\nSECURITY DEFINER\nSET search_path = public\nAS $$\nBEGIN\n  NEW.updated_at = now();\n  RETURN NEW;\nEND;\n$$;\n\n-- 9. Trigger para updated_at em profiles\nCREATE TRIGGER set_updated_at_profiles\n  BEFORE UPDATE ON public.profiles\n  FOR EACH ROW\n  EXECUTE FUNCTION public.handle_updated_at();\n\n-- 10. Função para criar profile e role automaticamente ao criar usuário\nCREATE OR REPLACE FUNCTION public.handle_new_user()\nRETURNS trigger\nLANGUAGE plpgsql\nSECURITY DEFINER\nSET search_path = public\nAS $$\nBEGIN\n  -- Inserir profile\n  INSERT INTO public.profiles (id, full_name)\n  VALUES (\n    NEW.id,\n    COALESCE(NEW.raw_user_meta_data->>'full_name', split_part(NEW.email, '@', 1))\n  );\n  \n  -- Atribuir role 'user' por padrão\n  INSERT INTO public.user_roles (user_id, role)\n  VALUES (NEW.id, 'user');\n  \n  RETURN NEW;\nEND;\n$$;\n\n-- 11. Trigger para criar profile ao registrar usuário\nCREATE TRIGGER on_auth_user_created\n  AFTER INSERT ON auth.users\n  FOR EACH ROW\n  EXECUTE FUNCTION public.handle_new_user();"}		urubiciconnect@gmail.com	\N	\N
20251027201652	{"-- Create booking status enum\nCREATE TYPE public.booking_status AS ENUM ('pending', 'confirmed', 'cancelled', 'completed');\n\n-- Create bookings table\nCREATE TABLE public.bookings (\n  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),\n  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,\n  property_id TEXT NOT NULL,\n  guest_first_name TEXT NOT NULL,\n  guest_last_name TEXT NOT NULL,\n  guest_email TEXT NOT NULL,\n  check_in DATE NOT NULL,\n  check_out DATE NOT NULL,\n  guests INTEGER NOT NULL DEFAULT 1,\n  total_price DECIMAL(10,2) NOT NULL,\n  status booking_status NOT NULL DEFAULT 'pending',\n  booking_code TEXT UNIQUE NOT NULL,\n  created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),\n  updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now()\n);\n\n-- Enable RLS\nALTER TABLE public.bookings ENABLE ROW LEVEL SECURITY;\n\n-- RLS Policies\nCREATE POLICY \\"Users can view their own bookings\\"\n  ON public.bookings\n  FOR SELECT\n  USING (auth.uid() = user_id);\n\nCREATE POLICY \\"Users can create their own bookings\\"\n  ON public.bookings\n  FOR INSERT\n  WITH CHECK (auth.uid() = user_id);\n\nCREATE POLICY \\"Users can update their own bookings\\"\n  ON public.bookings\n  FOR UPDATE\n  USING (auth.uid() = user_id);\n\nCREATE POLICY \\"Admins can view all bookings\\"\n  ON public.bookings\n  FOR SELECT\n  USING (has_role(auth.uid(), 'admin'));\n\nCREATE POLICY \\"Admins can manage all bookings\\"\n  ON public.bookings\n  FOR ALL\n  USING (has_role(auth.uid(), 'admin'));\n\n-- Indexes for better performance\nCREATE INDEX idx_bookings_user_id ON public.bookings(user_id);\nCREATE INDEX idx_bookings_property_id ON public.bookings(property_id);\nCREATE INDEX idx_bookings_check_in ON public.bookings(check_in);\nCREATE INDEX idx_bookings_check_out ON public.bookings(check_out);\nCREATE INDEX idx_bookings_status ON public.bookings(status);\nCREATE INDEX idx_bookings_booking_code ON public.bookings(booking_code);\n\n-- Function to generate unique booking code\nCREATE OR REPLACE FUNCTION public.generate_booking_code()\nRETURNS TEXT\nLANGUAGE plpgsql\nSECURITY DEFINER\nSET search_path = public\nAS $$\nDECLARE\n  code TEXT;\n  exists_code BOOLEAN;\nBEGIN\n  LOOP\n    -- Generate code: RC + 8 random uppercase letters and numbers\n    code := 'RC' || upper(substring(md5(random()::text) from 1 for 8));\n    \n    -- Check if code already exists\n    SELECT EXISTS(SELECT 1 FROM public.bookings WHERE booking_code = code) INTO exists_code;\n    \n    -- Exit loop if code is unique\n    EXIT WHEN NOT exists_code;\n  END LOOP;\n  \n  RETURN code;\nEND;\n$$;\n\n-- Trigger to auto-generate booking code before insert\nCREATE OR REPLACE FUNCTION public.handle_new_booking()\nRETURNS TRIGGER\nLANGUAGE plpgsql\nSECURITY DEFINER\nSET search_path = public\nAS $$\nBEGIN\n  IF NEW.booking_code IS NULL OR NEW.booking_code = '' THEN\n    NEW.booking_code := generate_booking_code();\n  END IF;\n  RETURN NEW;\nEND;\n$$;\n\nCREATE TRIGGER set_booking_code\n  BEFORE INSERT ON public.bookings\n  FOR EACH ROW\n  EXECUTE FUNCTION public.handle_new_booking();\n\n-- Trigger for updated_at\nCREATE TRIGGER handle_bookings_updated_at\n  BEFORE UPDATE ON public.bookings\n  FOR EACH ROW\n  EXECUTE FUNCTION public.handle_updated_at();"}		urubiciconnect@gmail.com	\N	\N
20251126120640	{"-- ================================================\n-- SPRINT 0 - FUNDAÇÃO: Database Migration\n-- ================================================\n\n-- 1. CREATE ENUMS\n-- ================================================\n\n-- Order status enum\nCREATE TYPE public.order_status AS ENUM (\n  'pending',\n  'confirmed',\n  'preparing',\n  'ready',\n  'out_for_delivery',\n  'delivered',\n  'cancelled'\n);\n\n-- Payment method enum\nCREATE TYPE public.payment_method AS ENUM (\n  'cash',\n  'pix',\n  'card_local',\n  'card_online'\n);\n\n-- Plan code enum\nCREATE TYPE public.plan_code AS ENUM (\n  'basic_free',\n  'premium'\n);\n\n-- Subscription status enum\nCREATE TYPE public.subscription_status AS ENUM (\n  'trial',\n  'active',\n  'past_due',\n  'canceled',\n  'incomplete'\n);\n\n-- 2. CREATE CORE TABLES\n-- ================================================\n\n-- Organizations/Establishments\nCREATE TABLE public.orgs (\n  id UUID NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,\n  name TEXT NOT NULL,\n  slug TEXT NOT NULL UNIQUE,\n  logo_url TEXT,\n  phone TEXT,\n  email TEXT,\n  address TEXT,\n  city TEXT,\n  state TEXT,\n  postal_code TEXT,\n  whatsapp_number TEXT,\n  whatsapp_enabled BOOLEAN NOT NULL DEFAULT false,\n  google_business_id TEXT,\n  is_active BOOLEAN NOT NULL DEFAULT true,\n  created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),\n  updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now()\n);\n\n-- User organizations relationship (multi-tenant)\nCREATE TABLE public.user_orgs (\n  id UUID NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,\n  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,\n  org_id UUID NOT NULL REFERENCES public.orgs(id) ON DELETE CASCADE,\n  role public.app_role NOT NULL DEFAULT 'user',\n  created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),\n  UNIQUE(user_id, org_id)\n);\n\n-- Subscription plans\nCREATE TABLE public.plans (\n  id UUID NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,\n  name TEXT NOT NULL,\n  code public.plan_code NOT NULL UNIQUE,\n  price_cents INTEGER NOT NULL DEFAULT 0,\n  description TEXT,\n  max_products INTEGER,\n  max_orders_month INTEGER,\n  features JSONB,\n  is_active BOOLEAN NOT NULL DEFAULT true,\n  created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),\n  updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now()\n);\n\n-- Organization subscriptions\nCREATE TABLE public.subscriptions (\n  id UUID NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,\n  org_id UUID NOT NULL REFERENCES public.orgs(id) ON DELETE CASCADE,\n  plan_id UUID NOT NULL REFERENCES public.plans(id),\n  status public.subscription_status NOT NULL DEFAULT 'trial',\n  current_period_start TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),\n  current_period_end TIMESTAMP WITH TIME ZONE,\n  cancel_at TIMESTAMP WITH TIME ZONE,\n  canceled_at TIMESTAMP WITH TIME ZONE,\n  stripe_subscription_id TEXT,\n  created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),\n  updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now()\n);\n\n-- Product categories\nCREATE TABLE public.categories (\n  id UUID NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,\n  org_id UUID NOT NULL REFERENCES public.orgs(id) ON DELETE CASCADE,\n  name TEXT NOT NULL,\n  description TEXT,\n  display_order INTEGER NOT NULL DEFAULT 0,\n  is_active BOOLEAN NOT NULL DEFAULT true,\n  created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),\n  updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now()\n);\n\n-- Products/Menu items\nCREATE TABLE public.products (\n  id UUID NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,\n  org_id UUID NOT NULL REFERENCES public.orgs(id) ON DELETE CASCADE,\n  category_id UUID REFERENCES public.categories(id) ON DELETE SET NULL,\n  name TEXT NOT NULL,\n  description TEXT,\n  price_cents INTEGER NOT NULL,\n  image_url TEXT,\n  preparation_time_minutes INTEGER,\n  is_available BOOLEAN NOT NULL DEFAULT true,\n  display_order INTEGER NOT NULL DEFAULT 0,\n  created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),\n  updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now()\n);\n\n-- Delivery zones\nCREATE TABLE public.delivery_zones (\n  id UUID NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,\n  org_id UUID NOT NULL REFERENCES public.orgs(id) ON DELETE CASCADE,\n  name TEXT NOT NULL,\n  neighborhoods TEXT[] NOT NULL DEFAULT '{}',\n  delivery_fee_cents INTEGER NOT NULL DEFAULT 0,\n  minimum_order_cents INTEGER NOT NULL DEFAULT 0,\n  estimated_time_minutes INTEGER NOT NULL DEFAULT 30,\n  is_active BOOLEAN NOT NULL DEFAULT true,\n  created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),\n  updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now()\n);\n\n-- Orders\nCREATE TABLE public.orders (\n  id UUID NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,\n  org_id UUID NOT NULL REFERENCES public.orgs(id) ON DELETE CASCADE,\n  order_number TEXT NOT NULL,\n  customer_name TEXT NOT NULL,\n  customer_phone TEXT NOT NULL,\n  customer_email TEXT,\n  delivery_address TEXT NOT NULL,\n  delivery_neighborhood TEXT NOT NULL,\n  delivery_zone_id UUID REFERENCES public.delivery_zones(id),\n  delivery_fee_cents INTEGER NOT NULL DEFAULT 0,\n  subtotal_cents INTEGER NOT NULL,\n  total_cents INTEGER NOT NULL,\n  payment_method public.payment_method NOT NULL,\n  status public.order_status NOT NULL DEFAULT 'pending',\n  notes TEXT,\n  estimated_delivery_time TIMESTAMP WITH TIME ZONE,\n  delivered_at TIMESTAMP WITH TIME ZONE,\n  created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),\n  updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),\n  UNIQUE(org_id, order_number)\n);\n\n-- Order items\nCREATE TABLE public.order_items (\n  id UUID NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,\n  order_id UUID NOT NULL REFERENCES public.orders(id) ON DELETE CASCADE,\n  product_id UUID REFERENCES public.products(id) ON DELETE SET NULL,\n  product_name TEXT NOT NULL,\n  product_price_cents INTEGER NOT NULL,\n  quantity INTEGER NOT NULL DEFAULT 1,\n  notes TEXT,\n  created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now()\n);\n\n-- Organization invites\nCREATE TABLE public.invites (\n  id UUID NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,\n  org_id UUID NOT NULL REFERENCES public.orgs(id) ON DELETE CASCADE,\n  email TEXT NOT NULL,\n  role public.app_role NOT NULL DEFAULT 'user',\n  invited_by UUID NOT NULL REFERENCES auth.users(id),\n  token TEXT NOT NULL UNIQUE,\n  expires_at TIMESTAMP WITH TIME ZONE NOT NULL,\n  accepted_at TIMESTAMP WITH TIME ZONE,\n  created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now()\n);\n\n-- Admin claim logs\nCREATE TABLE public.admin_claim_logs (\n  id UUID NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,\n  org_id UUID NOT NULL REFERENCES public.orgs(id) ON DELETE CASCADE,\n  user_id UUID NOT NULL REFERENCES auth.users(id),\n  claim_token TEXT NOT NULL UNIQUE,\n  stripe_session_id TEXT,\n  status TEXT NOT NULL DEFAULT 'pending',\n  amount_cents INTEGER,\n  claimed_at TIMESTAMP WITH TIME ZONE,\n  expires_at TIMESTAMP WITH TIME ZONE NOT NULL,\n  created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now()\n);\n\n-- Usage counters\nCREATE TABLE public.usage_counters (\n  id UUID NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,\n  org_id UUID NOT NULL REFERENCES public.orgs(id) ON DELETE CASCADE,\n  month DATE NOT NULL,\n  orders_count INTEGER NOT NULL DEFAULT 0,\n  products_count INTEGER NOT NULL DEFAULT 0,\n  created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),\n  updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),\n  UNIQUE(org_id, month)\n);\n\n-- 3. CREATE RPC FUNCTIONS\n-- ================================================\n\n-- Generate sequential order number for organization\nCREATE OR REPLACE FUNCTION public.generate_order_number(p_org_id UUID)\nRETURNS TEXT\nLANGUAGE plpgsql\nSECURITY DEFINER\nSET search_path = public\nAS $$\nDECLARE\n  v_count INTEGER;\n  v_number TEXT;\nBEGIN\n  -- Get count of orders for this org\n  SELECT COUNT(*) INTO v_count\n  FROM public.orders\n  WHERE org_id = p_org_id;\n  \n  -- Generate number: #0001, #0002, etc\n  v_number := '#' || LPAD((v_count + 1)::TEXT, 4, '0');\n  \n  RETURN v_number;\nEND;\n$$;\n\n-- Check if user is member of organization\nCREATE OR REPLACE FUNCTION public.is_org_member(_org_id UUID, _user_id UUID)\nRETURNS BOOLEAN\nLANGUAGE sql\nSTABLE\nSECURITY DEFINER\nSET search_path = public\nAS $$\n  SELECT EXISTS (\n    SELECT 1\n    FROM public.user_orgs\n    WHERE org_id = _org_id\n      AND user_id = _user_id\n  );\n$$;\n\n-- Get user role in organization\nCREATE OR REPLACE FUNCTION public.get_user_role(_org_id UUID, _user_id UUID)\nRETURNS public.app_role\nLANGUAGE sql\nSTABLE\nSECURITY DEFINER\nSET search_path = public\nAS $$\n  SELECT role\n  FROM public.user_orgs\n  WHERE org_id = _org_id\n    AND user_id = _user_id\n  LIMIT 1;\n$$;\n\n-- Check if user has specific role in organization\nCREATE OR REPLACE FUNCTION public.has_role_in_org(_org_id UUID, _role public.app_role, _user_id UUID)\nRETURNS BOOLEAN\nLANGUAGE sql\nSTABLE\nSECURITY DEFINER\nSET search_path = public\nAS $$\n  SELECT EXISTS (\n    SELECT 1\n    FROM public.user_orgs\n    WHERE org_id = _org_id\n      AND user_id = _user_id\n      AND role = _role\n  );\n$$;\n\n-- 4. CREATE INDEXES FOR PERFORMANCE\n-- ================================================\n\nCREATE INDEX idx_user_orgs_user_id ON public.user_orgs(user_id);\nCREATE INDEX idx_user_orgs_org_id ON public.user_orgs(org_id);\nCREATE INDEX idx_products_org_id ON public.products(org_id);\nCREATE INDEX idx_products_category_id ON public.products(category_id);\nCREATE INDEX idx_categories_org_id ON public.categories(org_id);\nCREATE INDEX idx_orders_org_id ON public.orders(org_id);\nCREATE INDEX idx_orders_status ON public.orders(status);\nCREATE INDEX idx_orders_created_at ON public.orders(created_at DESC);\nCREATE INDEX idx_order_items_order_id ON public.order_items(order_id);\nCREATE INDEX idx_delivery_zones_org_id ON public.delivery_zones(org_id);\nCREATE INDEX idx_subscriptions_org_id ON public.subscriptions(org_id);\n\n-- 5. CREATE TRIGGERS\n-- ================================================\n\n-- Trigger for updated_at on orgs\nCREATE TRIGGER update_orgs_updated_at\n  BEFORE UPDATE ON public.orgs\n  FOR EACH ROW\n  EXECUTE FUNCTION public.handle_updated_at();\n\n-- Trigger for updated_at on plans\nCREATE TRIGGER update_plans_updated_at\n  BEFORE UPDATE ON public.plans\n  FOR EACH ROW\n  EXECUTE FUNCTION public.handle_updated_at();\n\n-- Trigger for updated_at on subscriptions\nCREATE TRIGGER update_subscriptions_updated_at\n  BEFORE UPDATE ON public.subscriptions\n  FOR EACH ROW\n  EXECUTE FUNCTION public.handle_updated_at();\n\n-- Trigger for updated_at on categories\nCREATE TRIGGER update_categories_updated_at\n  BEFORE UPDATE ON public.categories\n  FOR EACH ROW\n  EXECUTE FUNCTION public.handle_updated_at();\n\n-- Trigger for updated_at on products\nCREATE TRIGGER update_products_updated_at\n  BEFORE UPDATE ON public.products\n  FOR EACH ROW\n  EXECUTE FUNCTION public.handle_updated_at();\n\n-- Trigger for updated_at on orders\nCREATE TRIGGER update_orders_updated_at\n  BEFORE UPDATE ON public.orders\n  FOR EACH ROW\n  EXECUTE FUNCTION public.handle_updated_at();\n\n-- Trigger for updated_at on usage_counters\nCREATE TRIGGER update_usage_counters_updated_at\n  BEFORE UPDATE ON public.usage_counters\n  FOR EACH ROW\n  EXECUTE FUNCTION public.handle_updated_at();\n\n-- 6. ENABLE ROW LEVEL SECURITY\n-- ================================================\n\nALTER TABLE public.orgs ENABLE ROW LEVEL SECURITY;\nALTER TABLE public.user_orgs ENABLE ROW LEVEL SECURITY;\nALTER TABLE public.plans ENABLE ROW LEVEL SECURITY;\nALTER TABLE public.subscriptions ENABLE ROW LEVEL SECURITY;\nALTER TABLE public.categories ENABLE ROW LEVEL SECURITY;\nALTER TABLE public.products ENABLE ROW LEVEL SECURITY;\nALTER TABLE public.delivery_zones ENABLE ROW LEVEL SECURITY;\nALTER TABLE public.orders ENABLE ROW LEVEL SECURITY;\nALTER TABLE public.order_items ENABLE ROW LEVEL SECURITY;\nALTER TABLE public.invites ENABLE ROW LEVEL SECURITY;\nALTER TABLE public.admin_claim_logs ENABLE ROW LEVEL SECURITY;\nALTER TABLE public.usage_counters ENABLE ROW LEVEL SECURITY;\n\n-- 7. CREATE RLS POLICIES\n-- ================================================\n\n-- ORGS POLICIES\nCREATE POLICY \\"Users can view their orgs\\"\n  ON public.orgs FOR SELECT\n  TO authenticated\n  USING (\n    EXISTS (\n      SELECT 1 FROM public.user_orgs\n      WHERE user_orgs.org_id = orgs.id\n        AND user_orgs.user_id = auth.uid()\n    )\n  );\n\nCREATE POLICY \\"Admins can update their org\\"\n  ON public.orgs FOR UPDATE\n  TO authenticated\n  USING (\n    EXISTS (\n      SELECT 1 FROM public.user_orgs\n      WHERE user_orgs.org_id = orgs.id\n        AND user_orgs.user_id = auth.uid()\n        AND user_orgs.role = 'admin'\n    )\n  );\n\nCREATE POLICY \\"Users can create orgs\\"\n  ON public.orgs FOR INSERT\n  TO authenticated\n  WITH CHECK (true);\n\n-- USER_ORGS POLICIES\nCREATE POLICY \\"Users can view their org memberships\\"\n  ON public.user_orgs FOR SELECT\n  TO authenticated\n  USING (user_id = auth.uid());\n\nCREATE POLICY \\"Admins can manage org members\\"\n  ON public.user_orgs FOR ALL\n  TO authenticated\n  USING (\n    EXISTS (\n      SELECT 1 FROM public.user_orgs uo\n      WHERE uo.org_id = user_orgs.org_id\n        AND uo.user_id = auth.uid()\n        AND uo.role = 'admin'\n    )\n  );\n\nCREATE POLICY \\"Users can insert their own membership\\"\n  ON public.user_orgs FOR INSERT\n  TO authenticated\n  WITH CHECK (user_id = auth.uid());\n\n-- PLANS POLICIES\nCREATE POLICY \\"Anyone can view active plans\\"\n  ON public.plans FOR SELECT\n  TO authenticated\n  USING (is_active = true);\n\n-- SUBSCRIPTIONS POLICIES\nCREATE POLICY \\"Org members can view their subscription\\"\n  ON public.subscriptions FOR SELECT\n  TO authenticated\n  USING (public.is_org_member(org_id, auth.uid()));\n\nCREATE POLICY \\"Admins can manage subscription\\"\n  ON public.subscriptions FOR ALL\n  TO authenticated\n  USING (public.has_role_in_org(org_id, 'admin', auth.uid()));\n\n-- CATEGORIES POLICIES\nCREATE POLICY \\"Public can view active categories\\"\n  ON public.categories FOR SELECT\n  USING (is_active = true);\n\nCREATE POLICY \\"Org members can manage categories\\"\n  ON public.categories FOR ALL\n  TO authenticated\n  USING (public.is_org_member(org_id, auth.uid()));\n\n-- PRODUCTS POLICIES\nCREATE POLICY \\"Public can view available products\\"\n  ON public.products FOR SELECT\n  USING (is_available = true);\n\nCREATE POLICY \\"Org members can manage products\\"\n  ON public.products FOR ALL\n  TO authenticated\n  USING (public.is_org_member(org_id, auth.uid()));\n\n-- DELIVERY_ZONES POLICIES\nCREATE POLICY \\"Public can view active delivery zones\\"\n  ON public.delivery_zones FOR SELECT\n  USING (is_active = true);\n\nCREATE POLICY \\"Org members can manage delivery zones\\"\n  ON public.delivery_zones FOR ALL\n  TO authenticated\n  USING (public.is_org_member(org_id, auth.uid()));\n\n-- ORDERS POLICIES\nCREATE POLICY \\"Anyone can create orders\\"\n  ON public.orders FOR INSERT\n  WITH CHECK (true);\n\nCREATE POLICY \\"Org members can view their orders\\"\n  ON public.orders FOR SELECT\n  TO authenticated\n  USING (public.is_org_member(org_id, auth.uid()));\n\nCREATE POLICY \\"Org members can update orders\\"\n  ON public.orders FOR UPDATE\n  TO authenticated\n  USING (public.is_org_member(org_id, auth.uid()));\n\n-- ORDER_ITEMS POLICIES\nCREATE POLICY \\"Users can view order items\\"\n  ON public.order_items FOR SELECT\n  TO authenticated\n  USING (\n    EXISTS (\n      SELECT 1 FROM public.orders\n      WHERE orders.id = order_items.order_id\n        AND public.is_org_member(orders.org_id, auth.uid())\n    )\n  );\n\nCREATE POLICY \\"Anyone can insert order items\\"\n  ON public.order_items FOR INSERT\n  WITH CHECK (true);\n\n-- INVITES POLICIES\nCREATE POLICY \\"Org members can view invites\\"\n  ON public.invites FOR SELECT\n  TO authenticated\n  USING (public.is_org_member(org_id, auth.uid()));\n\nCREATE POLICY \\"Admins can manage invites\\"\n  ON public.invites FOR ALL\n  TO authenticated\n  USING (public.has_role_in_org(org_id, 'admin', auth.uid()));\n\n-- ADMIN_CLAIM_LOGS POLICIES\nCREATE POLICY \\"Users can view their claim logs\\"\n  ON public.admin_claim_logs FOR SELECT\n  TO authenticated\n  USING (user_id = auth.uid());\n\nCREATE POLICY \\"Users can create claim logs\\"\n  ON public.admin_claim_logs FOR INSERT\n  TO authenticated\n  WITH CHECK (user_id = auth.uid());\n\nCREATE POLICY \\"Users can update their claim logs\\"\n  ON public.admin_claim_logs FOR UPDATE\n  TO authenticated\n  USING (user_id = auth.uid());\n\n-- USAGE_COUNTERS POLICIES\nCREATE POLICY \\"Org members can view usage counters\\"\n  ON public.usage_counters FOR SELECT\n  TO authenticated\n  USING (public.is_org_member(org_id, auth.uid()));\n\n-- 8. CREATE STORAGE BUCKET FOR PRODUCT IMAGES\n-- ================================================\n\nINSERT INTO storage.buckets (id, name, public)\nVALUES ('product-images', 'product-images', true)\nON CONFLICT (id) DO NOTHING;\n\n-- Storage policies for product images\nCREATE POLICY \\"Public can view product images\\"\n  ON storage.objects FOR SELECT\n  USING (bucket_id = 'product-images');\n\nCREATE POLICY \\"Authenticated users can upload product images\\"\n  ON storage.objects FOR INSERT\n  TO authenticated\n  WITH CHECK (bucket_id = 'product-images');\n\nCREATE POLICY \\"Users can update their org product images\\"\n  ON storage.objects FOR UPDATE\n  TO authenticated\n  USING (bucket_id = 'product-images');\n\nCREATE POLICY \\"Users can delete their org product images\\"\n  ON storage.objects FOR DELETE\n  TO authenticated\n  USING (bucket_id = 'product-images');\n\n-- 9. SEED INITIAL DATA\n-- ================================================\n\n-- Insert default plans\nINSERT INTO public.plans (name, code, price_cents, description, max_products, max_orders_month)\nVALUES\n  ('Básico Gratuito', 'basic_free', 0, 'Plano inicial com funcionalidades básicas', 20, 100),\n  ('Premium', 'premium', 9990, 'Plano completo com todas as funcionalidades', NULL, NULL)\nON CONFLICT (code) DO NOTHING;"}		urubiciconnect@gmail.com	\N	\N
20251126123722	{"-- Create table for WhatsApp/Evolution API settings per organization\nCREATE TABLE public.whatsapp_settings (\n  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),\n  org_id UUID NOT NULL REFERENCES public.orgs(id) ON DELETE CASCADE,\n  evolution_api_url TEXT NOT NULL,\n  evolution_api_key TEXT NOT NULL,\n  instance_name TEXT NOT NULL,\n  is_active BOOLEAN NOT NULL DEFAULT true,\n  send_on_confirmed BOOLEAN NOT NULL DEFAULT true,\n  send_on_preparing BOOLEAN NOT NULL DEFAULT false,\n  send_on_ready BOOLEAN NOT NULL DEFAULT true,\n  send_on_out_for_delivery BOOLEAN NOT NULL DEFAULT true,\n  send_on_delivered BOOLEAN NOT NULL DEFAULT true,\n  created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),\n  updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),\n  UNIQUE(org_id)\n);\n\n-- Enable RLS\nALTER TABLE public.whatsapp_settings ENABLE ROW LEVEL SECURITY;\n\n-- Admins can manage their org's WhatsApp settings\nCREATE POLICY \\"Admins can manage whatsapp settings\\"\nON public.whatsapp_settings\nFOR ALL\nUSING (has_role_in_org(org_id, 'admin'::app_role, auth.uid()));\n\n-- Org members can view their org's WhatsApp settings\nCREATE POLICY \\"Org members can view whatsapp settings\\"\nON public.whatsapp_settings\nFOR SELECT\nUSING (is_org_member(org_id, auth.uid()));\n\n-- Trigger for updated_at\nCREATE TRIGGER update_whatsapp_settings_updated_at\nBEFORE UPDATE ON public.whatsapp_settings\nFOR EACH ROW\nEXECUTE FUNCTION public.handle_updated_at();"}		urubiciconnect@gmail.com	\N	\N
20251126125316	{"-- Create platform Stripe configuration table\nCREATE TABLE IF NOT EXISTS public.stripe_config (\n  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),\n  stripe_secret_key text NOT NULL,\n  stripe_publishable_key text NOT NULL,\n  webhook_secret text,\n  is_active boolean NOT NULL DEFAULT true,\n  created_at timestamp with time zone NOT NULL DEFAULT now(),\n  updated_at timestamp with time zone NOT NULL DEFAULT now()\n);\n\n-- Enable RLS\nALTER TABLE public.stripe_config ENABLE ROW LEVEL SECURITY;\n\n-- Only platform admins can manage Stripe configuration\nCREATE POLICY \\"Only platform admins can manage stripe config\\"\nON public.stripe_config\nFOR ALL\nTO authenticated\nUSING (has_role(auth.uid(), 'admin'::app_role))\nWITH CHECK (has_role(auth.uid(), 'admin'::app_role));\n\n-- Trigger for updated_at\nCREATE TRIGGER set_stripe_config_updated_at\n  BEFORE UPDATE ON public.stripe_config\n  FOR EACH ROW\n  EXECUTE FUNCTION handle_updated_at();"}		urubiciconnect@gmail.com	\N	\N
20251126131515	{"-- Create enum for transaction types\nCREATE TYPE transaction_type AS ENUM ('income', 'expense');\n\n-- Create enum for transaction categories\nCREATE TYPE transaction_category AS ENUM (\n  'sale', 'delivery_fee', 'tip',\n  'rent', 'utilities', 'salary', 'supplies', 'marketing', 'maintenance', 'taxes', 'other'\n);\n\n-- Create enum for payment status\nCREATE TYPE payment_status AS ENUM ('pending', 'paid', 'overdue', 'cancelled');\n\n-- Create financial_transactions table\nCREATE TABLE public.financial_transactions (\n  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),\n  org_id UUID NOT NULL REFERENCES public.orgs(id) ON DELETE CASCADE,\n  type transaction_type NOT NULL,\n  category transaction_category NOT NULL,\n  amount_cents INTEGER NOT NULL,\n  description TEXT NOT NULL,\n  transaction_date DATE NOT NULL DEFAULT CURRENT_DATE,\n  due_date DATE,\n  paid_date DATE,\n  status payment_status NOT NULL DEFAULT 'pending',\n  order_id UUID REFERENCES public.orders(id) ON DELETE SET NULL,\n  notes TEXT,\n  created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),\n  updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),\n  created_by UUID REFERENCES auth.users(id) ON DELETE SET NULL\n);\n\n-- Create indexes for better performance\nCREATE INDEX idx_financial_transactions_org_id ON public.financial_transactions(org_id);\nCREATE INDEX idx_financial_transactions_type ON public.financial_transactions(type);\nCREATE INDEX idx_financial_transactions_status ON public.financial_transactions(status);\nCREATE INDEX idx_financial_transactions_date ON public.financial_transactions(transaction_date);\nCREATE INDEX idx_financial_transactions_order_id ON public.financial_transactions(order_id);\n\n-- Enable RLS\nALTER TABLE public.financial_transactions ENABLE ROW LEVEL SECURITY;\n\n-- RLS Policies for financial_transactions\nCREATE POLICY \\"Org members can view their transactions\\"\n  ON public.financial_transactions\n  FOR SELECT\n  USING (is_org_member(org_id, auth.uid()));\n\nCREATE POLICY \\"Org admins can manage transactions\\"\n  ON public.financial_transactions\n  FOR ALL\n  USING (has_role_in_org(org_id, 'admin', auth.uid()));\n\n-- Create trigger for updated_at\nCREATE TRIGGER update_financial_transactions_updated_at\n  BEFORE UPDATE ON public.financial_transactions\n  FOR EACH ROW\n  EXECUTE FUNCTION public.handle_updated_at();\n\n-- Create function to automatically create income transaction from orders\nCREATE OR REPLACE FUNCTION public.create_income_from_order()\nRETURNS TRIGGER\nLANGUAGE plpgsql\nSECURITY DEFINER\nSET search_path = public\nAS $$\nBEGIN\n  -- Only create transaction when order is delivered\n  IF NEW.status = 'delivered' AND (OLD.status IS NULL OR OLD.status != 'delivered') THEN\n    INSERT INTO public.financial_transactions (\n      org_id,\n      type,\n      category,\n      amount_cents,\n      description,\n      transaction_date,\n      status,\n      paid_date,\n      order_id\n    ) VALUES (\n      NEW.org_id,\n      'income',\n      'sale',\n      NEW.total_cents,\n      'Venda - Pedido ' || NEW.order_number,\n      CURRENT_DATE,\n      'paid',\n      CURRENT_DATE,\n      NEW.id\n    );\n  END IF;\n  RETURN NEW;\nEND;\n$$;\n\n-- Create trigger to auto-create income from delivered orders\nCREATE TRIGGER create_income_from_delivered_order\n  AFTER UPDATE ON public.orders\n  FOR EACH ROW\n  EXECUTE FUNCTION public.create_income_from_order();"}		urubiciconnect@gmail.com	\N	\N
20251126134207	{"-- Create google_business_settings table to store Google My Business configuration per org\nCREATE TABLE IF NOT EXISTS public.google_business_settings (\n  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),\n  org_id UUID NOT NULL REFERENCES public.orgs(id) ON DELETE CASCADE,\n  place_id TEXT NOT NULL,\n  business_name TEXT NOT NULL,\n  review_url TEXT NOT NULL,\n  is_active BOOLEAN NOT NULL DEFAULT true,\n  auto_request_reviews BOOLEAN NOT NULL DEFAULT true,\n  request_delay_hours INTEGER NOT NULL DEFAULT 24,\n  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),\n  updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),\n  UNIQUE(org_id)\n);\n\n-- Create review_requests table to track review requests sent to customers\nCREATE TABLE IF NOT EXISTS public.review_requests (\n  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),\n  org_id UUID NOT NULL REFERENCES public.orgs(id) ON DELETE CASCADE,\n  order_id UUID NOT NULL REFERENCES public.orders(id) ON DELETE CASCADE,\n  customer_name TEXT NOT NULL,\n  customer_phone TEXT NOT NULL,\n  customer_email TEXT,\n  review_url TEXT NOT NULL,\n  status TEXT NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'sent', 'failed', 'reviewed')),\n  sent_at TIMESTAMPTZ,\n  reviewed_at TIMESTAMPTZ,\n  send_method TEXT CHECK (send_method IN ('whatsapp', 'email', 'sms')),\n  error_message TEXT,\n  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),\n  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()\n);\n\n-- Enable RLS\nALTER TABLE public.google_business_settings ENABLE ROW LEVEL SECURITY;\nALTER TABLE public.review_requests ENABLE ROW LEVEL SECURITY;\n\n-- RLS Policies for google_business_settings\nCREATE POLICY \\"Org admins can manage google business settings\\"\n  ON public.google_business_settings\n  FOR ALL\n  USING (has_role_in_org(org_id, 'admin'::app_role, auth.uid()));\n\nCREATE POLICY \\"Org members can view google business settings\\"\n  ON public.google_business_settings\n  FOR SELECT\n  USING (is_org_member(org_id, auth.uid()));\n\n-- RLS Policies for review_requests\nCREATE POLICY \\"Org members can view review requests\\"\n  ON public.review_requests\n  FOR SELECT\n  USING (is_org_member(org_id, auth.uid()));\n\nCREATE POLICY \\"Org admins can manage review requests\\"\n  ON public.review_requests\n  FOR ALL\n  USING (has_role_in_org(org_id, 'admin'::app_role, auth.uid()));\n\n-- Indexes for better performance\nCREATE INDEX idx_review_requests_org_id ON public.review_requests(org_id);\nCREATE INDEX idx_review_requests_order_id ON public.review_requests(order_id);\nCREATE INDEX idx_review_requests_status ON public.review_requests(status);\nCREATE INDEX idx_review_requests_created_at ON public.review_requests(created_at);\n\n-- Trigger for updated_at\nCREATE TRIGGER update_google_business_settings_updated_at\n  BEFORE UPDATE ON public.google_business_settings\n  FOR EACH ROW\n  EXECUTE FUNCTION public.handle_updated_at();\n\nCREATE TRIGGER update_review_requests_updated_at\n  BEFORE UPDATE ON public.review_requests\n  FOR EACH ROW\n  EXECUTE FUNCTION public.handle_updated_at();"}		urubiciconnect@gmail.com	\N	\N
20251126135004	{"-- Create api_keys table to manage external API access per organization\nCREATE TABLE IF NOT EXISTS public.api_keys (\n  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),\n  org_id UUID NOT NULL REFERENCES public.orgs(id) ON DELETE CASCADE,\n  key_name TEXT NOT NULL,\n  api_key TEXT NOT NULL UNIQUE,\n  is_active BOOLEAN NOT NULL DEFAULT true,\n  last_used_at TIMESTAMPTZ,\n  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),\n  updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),\n  UNIQUE(org_id, key_name)\n);\n\n-- Enable RLS\nALTER TABLE public.api_keys ENABLE ROW LEVEL SECURITY;\n\n-- RLS Policies for api_keys\nCREATE POLICY \\"Org admins can manage api keys\\"\n  ON public.api_keys\n  FOR ALL\n  USING (has_role_in_org(org_id, 'admin'::app_role, auth.uid()));\n\nCREATE POLICY \\"Org members can view api keys\\"\n  ON public.api_keys\n  FOR SELECT\n  USING (is_org_member(org_id, auth.uid()));\n\n-- Index for performance\nCREATE INDEX idx_api_keys_org_id ON public.api_keys(org_id);\nCREATE INDEX idx_api_keys_key ON public.api_keys(api_key) WHERE is_active = true;\n\n-- Trigger for updated_at\nCREATE TRIGGER update_api_keys_updated_at\n  BEFORE UPDATE ON public.api_keys\n  FOR EACH ROW\n  EXECUTE FUNCTION public.handle_updated_at();\n\n-- Function to generate secure API key\nCREATE OR REPLACE FUNCTION public.generate_api_key()\nRETURNS TEXT\nLANGUAGE plpgsql\nSECURITY DEFINER\nSET search_path = public\nAS $$\nDECLARE\n  key TEXT;\nBEGIN\n  -- Generate a secure random API key: rdk_ prefix + 32 random characters\n  key := 'rdk_' || encode(gen_random_bytes(24), 'base64');\n  -- Remove any special characters that might cause issues\n  key := replace(replace(replace(key, '/', ''), '+', ''), '=', '');\n  RETURN key;\nEND;\n$$;"}		urubiciconnect@gmail.com	\N	\N
20260213000001	{"-- ============================================\n-- RESERVE CONNECT - DATABASE RESET & MVP SCHEMA\n-- Date: 2026-02-12\n-- Author: Senior Fullstack Engineer\n-- Target: Supabase PostgreSQL 15+\n-- ============================================\n\n-- ============================================\n-- TASK A: RESET - Drop All Application Objects\n-- ============================================\n-- WARNING: This will permanently delete all application data\n-- Safe to run in Supabase SQL Editor - excludes system schemas\n\nDO $$\nDECLARE\n    r RECORD;\n    schema_name TEXT := 'public';\nBEGIN\n    RAISE NOTICE 'Starting Reserve Connect database reset...';\n    \n    -- Drop all tables in public schema\n    FOR r IN \n        SELECT tablename \n        FROM pg_tables \n        WHERE schemaname = schema_name\n    LOOP\n        EXECUTE format('DROP TABLE IF EXISTS %I.%I CASCADE', schema_name, r.tablename);\n        RAISE NOTICE 'Dropped table: %.%', schema_name, r.tablename;\n    END LOOP;\n    \n    -- Drop all views in public schema\n    FOR r IN \n        SELECT viewname \n        FROM pg_views \n        WHERE schemaname = schema_name\n    LOOP\n        EXECUTE format('DROP VIEW IF EXISTS %I.%I CASCADE', schema_name, r.viewname);\n        RAISE NOTICE 'Dropped view: %.%', schema_name, r.viewname;\n    END LOOP;\n    \n    -- Drop all materialized views in public schema\n    FOR r IN \n        SELECT matviewname \n        FROM pg_matviews \n        WHERE schemaname = schema_name\n    LOOP\n        EXECUTE format('DROP MATERIALIZED VIEW IF EXISTS %I.%I CASCADE', schema_name, r.matviewname);\n        RAISE NOTICE 'Dropped materialized view: %.%', schema_name, r.matviewname;\n    END LOOP;\n    \n    -- Drop all sequences in public schema (excluding system sequences)\n    FOR r IN \n        SELECT sequencename \n        FROM pg_sequences \n        WHERE schemaname = schema_name\n    LOOP\n        EXECUTE format('DROP SEQUENCE IF EXISTS %I.%I CASCADE', schema_name, r.sequencename);\n        RAISE NOTICE 'Dropped sequence: %.%', schema_name, r.sequencename;\n    END LOOP;\n    \n    -- Drop all functions in public schema\n    FOR r IN \n        SELECT proname, pg_get_function_identity_arguments(oid) as args\n        FROM pg_proc \n        WHERE pronamespace = schema_name::regnamespace\n        AND proname NOT LIKE 'pg_%'\n    LOOP\n        EXECUTE format('DROP FUNCTION IF EXISTS %I.%I(%s) CASCADE', schema_name, r.proname, r.args);\n        RAISE NOTICE 'Dropped function: %.%', schema_name, r.proname;\n    END LOOP;\n    \n    -- Drop all types in public schema (excluding system types)\n    FOR r IN \n        SELECT typname \n        FROM pg_type \n        WHERE typnamespace = schema_name::regnamespace\n        AND typtype IN ('c', 'e') -- composite and enum types only\n        AND typname NOT LIKE 'pg_%'\n        AND typname NOT LIKE 'hstore%'\n    LOOP\n        EXECUTE format('DROP TYPE IF EXISTS %I.%I CASCADE', schema_name, r.typname);\n        RAISE NOTICE 'Dropped type: %.%', schema_name, r.typname;\n    END LOOP;\n    \n    -- Drop reserve schema if exists\n    DROP SCHEMA IF EXISTS reserve CASCADE;\n    RAISE NOTICE 'Dropped schema: reserve';\n    \n    RAISE NOTICE 'Reset complete. All application objects removed.';\nEND $$","-- ============================================\n-- TASK B: CREATE RESERVE SCHEMA (MVP v1)\n-- ============================================\n\n-- Create reserve schema\nCREATE SCHEMA reserve","COMMENT ON SCHEMA reserve IS 'Reserve Connect application schema - Distribution layer for property bookings'","-- ============================================\n-- ENUMERATION TYPES\n-- ============================================\n\nCREATE TYPE reserve.reservation_status AS ENUM (\n    'pending',\n    'confirmed',\n    'checked_in',\n    'checked_out',\n    'cancelled',\n    'no_show'\n)","CREATE TYPE reserve.reservation_source AS ENUM (\n    'direct',\n    'booking_com',\n    'airbnb',\n    'expedia',\n    'other_ota'\n)","CREATE TYPE reserve.payment_status AS ENUM (\n    'pending',\n    'partial',\n    'paid',\n    'refunded',\n    'failed'\n)","CREATE TYPE reserve.sync_status AS ENUM (\n    'pending',\n    'in_progress',\n    'completed',\n    'failed',\n    'retrying'\n)","CREATE TYPE reserve.sync_direction AS ENUM (\n    'push_to_host',\n    'pull_from_host',\n    'bidirectional'\n)","CREATE TYPE reserve.event_severity AS ENUM (\n    'info',\n    'warning',\n    'error',\n    'critical'\n)","CREATE TYPE reserve.funnel_stage AS ENUM (\n    'page_view',\n    'search',\n    'view_item',\n    'lead',\n    'checkout',\n    'purchase',\n    'abandon'\n)","COMMENT ON TYPE reserve.reservation_status IS 'Lifecycle states for reservations'","COMMENT ON TYPE reserve.reservation_source IS 'Channel/source of booking'","COMMENT ON TYPE reserve.payment_status IS 'Payment state tracking'","COMMENT ON TYPE reserve.sync_status IS 'Sync job execution status'","COMMENT ON TYPE reserve.sync_direction IS 'Data flow direction for sync operations'","COMMENT ON TYPE reserve.event_severity IS 'Event importance level'","COMMENT ON TYPE reserve.funnel_stage IS 'Conversion funnel tracking stages'","-- ============================================\n-- 1. CITIES TABLE (Multi-city ready)\n-- ============================================\n\nCREATE TABLE reserve.cities (\n    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),\n    code VARCHAR(10) UNIQUE NOT NULL,\n    name VARCHAR(100) NOT NULL,\n    state_province VARCHAR(100),\n    country VARCHAR(100) NOT NULL DEFAULT 'Brazil',\n    timezone VARCHAR(50) NOT NULL DEFAULT 'America/Sao_Paulo',\n    currency VARCHAR(3) NOT NULL DEFAULT 'BRL',\n    is_active BOOLEAN NOT NULL DEFAULT true,\n    metadata JSONB DEFAULT '{}',\n    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),\n    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()\n)","CREATE INDEX idx_cities_code ON reserve.cities(code)","CREATE INDEX idx_cities_active ON reserve.cities(is_active) WHERE is_active = true","COMMENT ON TABLE reserve.cities IS 'Multi-city support for Reserve Connect - Pilot: Urubici'","COMMENT ON COLUMN reserve.cities.code IS 'Unique city identifier (e.g., URB, SAO)'","-- Insert pilot city: Urubici\nINSERT INTO reserve.cities (code, name, state_province, timezone) \nVALUES ('URB', 'Urubici', 'Santa Catarina', 'America/Sao_Paulo')","-- ============================================\n-- 2. PROPERTIES_MAP TABLE\n-- ============================================\n\nCREATE TABLE reserve.properties_map (\n    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),\n    host_property_id UUID NOT NULL,\n    city_id UUID NOT NULL REFERENCES reserve.cities(id),\n    name VARCHAR(200) NOT NULL,\n    slug VARCHAR(200) UNIQUE NOT NULL,\n    description TEXT,\n    property_type VARCHAR(50), -- hotel, pousada, hostel, etc.\n    address_line_1 VARCHAR(255),\n    address_line_2 VARCHAR(255),\n    city VARCHAR(100),\n    state_province VARCHAR(100),\n    postal_code VARCHAR(20),\n    country VARCHAR(100) DEFAULT 'Brazil',\n    latitude DECIMAL(10, 8),\n    longitude DECIMAL(11, 8),\n    phone VARCHAR(50),\n    email VARCHAR(255),\n    website VARCHAR(500),\n    -- Cached fields (minimal, from Host Connect)\n    amenities_cached JSONB DEFAULT '[]',\n    images_cached JSONB DEFAULT '[]',\n    rating_cached DECIMAL(2, 1),\n    review_count_cached INTEGER DEFAULT 0,\n    -- Sync metadata\n    host_last_synced_at TIMESTAMPTZ,\n    host_data_hash VARCHAR(64),\n    is_active BOOLEAN NOT NULL DEFAULT true,\n    is_published BOOLEAN NOT NULL DEFAULT false,\n    deleted_at TIMESTAMPTZ,\n    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),\n    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),\n    \n    CONSTRAINT valid_coordinates CHECK (\n        (latitude IS NULL OR (latitude >= -90 AND latitude <= 90)) AND\n        (longitude IS NULL OR (longitude >= -180 AND longitude <= 180))\n    ),\n    CONSTRAINT valid_rating CHECK (rating_cached IS NULL OR (rating_cached >= 0 AND rating_cached <= 5))\n)","CREATE INDEX idx_properties_map_host_id ON reserve.properties_map(host_property_id)","CREATE INDEX idx_properties_map_city ON reserve.properties_map(city_id)","CREATE INDEX idx_properties_map_slug ON reserve.properties_map(slug)","CREATE INDEX idx_properties_map_active ON reserve.properties_map(is_active, is_published) WHERE is_active = true AND is_published = true","CREATE INDEX idx_properties_map_location ON reserve.properties_map(latitude, longitude) WHERE latitude IS NOT NULL AND longitude IS NOT NULL","CREATE INDEX idx_properties_map_geo ON reserve.properties_map USING GIST (\n    point(longitude, latitude)\n) WHERE latitude IS NOT NULL AND longitude IS NOT NULL","COMMENT ON TABLE reserve.properties_map IS 'Maps Host Connect properties to Reserve Connect - minimal cached fields only'","COMMENT ON COLUMN reserve.properties_map.host_property_id IS 'Reference to Host Connect property ID (source of truth)'","COMMENT ON COLUMN reserve.properties_map.host_last_synced_at IS 'Last successful sync from Host Connect'","COMMENT ON COLUMN reserve.properties_map.host_data_hash IS 'SHA-256 hash of source data for change detection'","-- ============================================\n-- 3. UNIT_MAP TABLE\n-- ============================================\n\nCREATE TABLE reserve.unit_map (\n    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),\n    host_unit_id UUID NOT NULL,\n    property_id UUID NOT NULL REFERENCES reserve.properties_map(id) ON DELETE CASCADE,\n    name VARCHAR(200) NOT NULL,\n    slug VARCHAR(200) NOT NULL,\n    unit_type VARCHAR(50), -- room, suite, chalet, cabin, etc.\n    description TEXT,\n    max_occupancy INTEGER NOT NULL DEFAULT 2,\n    base_capacity INTEGER NOT NULL DEFAULT 2,\n    -- Cached fields (minimal)\n    amenities_cached JSONB DEFAULT '[]',\n    images_cached JSONB DEFAULT '[]',\n    size_sqm INTEGER,\n    bed_configuration JSONB DEFAULT '[]',\n    -- Sync metadata\n    host_last_synced_at TIMESTAMPTZ,\n    host_data_hash VARCHAR(64),\n    is_active BOOLEAN NOT NULL DEFAULT true,\n    deleted_at TIMESTAMPTZ,\n    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),\n    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),\n    \n    CONSTRAINT valid_occupancy CHECK (max_occupancy >= base_capacity AND base_capacity > 0),\n    CONSTRAINT unique_unit_slug_per_property UNIQUE (property_id, slug)\n)","CREATE INDEX idx_unit_map_host_id ON reserve.unit_map(host_unit_id)","CREATE INDEX idx_unit_map_property ON reserve.unit_map(property_id)","CREATE INDEX idx_unit_map_active ON reserve.unit_map(is_active) WHERE is_active = true","CREATE INDEX idx_unit_map_occupancy ON reserve.unit_map(max_occupancy, base_capacity) WHERE is_active = true","COMMENT ON TABLE reserve.unit_map IS 'Maps Host Connect units/rooms to Reserve Connect'","COMMENT ON COLUMN reserve.unit_map.host_unit_id IS 'Reference to Host Connect unit ID (source of truth)'","-- ============================================\n-- 4. RATE_PLANS TABLE\n-- ============================================\n\nCREATE TABLE reserve.rate_plans (\n    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),\n    property_id UUID NOT NULL REFERENCES reserve.properties_map(id) ON DELETE CASCADE,\n    host_rate_plan_id UUID,\n    name VARCHAR(200) NOT NULL,\n    code VARCHAR(50),\n    description TEXT,\n    is_default BOOLEAN NOT NULL DEFAULT false,\n    -- Channel configuration\n    channels_enabled JSONB DEFAULT '[\\"direct\\"]', -- array of reservation_source values\n    -- Pricing rules\n    min_stay_nights INTEGER DEFAULT 1,\n    max_stay_nights INTEGER,\n    advance_booking_days INTEGER, -- min days in advance\n    -- Cancellation policy (reference, actual terms in metadata)\n    cancellation_policy_code VARCHAR(50),\n    -- Metadata\n    metadata JSONB DEFAULT '{}',\n    is_active BOOLEAN NOT NULL DEFAULT true,\n    deleted_at TIMESTAMPTZ,\n    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),\n    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),\n    \n    CONSTRAINT valid_stay_range CHECK (max_stay_nights IS NULL OR max_stay_nights >= min_stay_nights),\n    CONSTRAINT valid_advance CHECK (advance_booking_days IS NULL OR advance_booking_days >= 0),\n    CONSTRAINT unique_default_rate_plan UNIQUE (property_id, is_default) DEFERRABLE INITIALLY DEFERRED\n)","CREATE INDEX idx_rate_plans_property ON reserve.rate_plans(property_id)","CREATE INDEX idx_rate_plans_active ON reserve.rate_plans(is_active) WHERE is_active = true","CREATE INDEX idx_rate_plans_channels ON reserve.rate_plans USING GIN (channels_enabled)","CREATE INDEX idx_rate_plans_host_id ON reserve.rate_plans(host_rate_plan_id) WHERE host_rate_plan_id IS NOT NULL","COMMENT ON TABLE reserve.rate_plans IS 'Rate plans per property - channel-ready configuration'","COMMENT ON COLUMN reserve.rate_plans.channels_enabled IS 'JSON array of channels this rate plan applies to'","-- ============================================\n-- 5. AVAILABILITY_CALENDAR TABLE\n-- ============================================\n\nCREATE TABLE reserve.availability_calendar (\n    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),\n    unit_id UUID NOT NULL REFERENCES reserve.unit_map(id) ON DELETE CASCADE,\n    rate_plan_id UUID NOT NULL REFERENCES reserve.rate_plans(id) ON DELETE CASCADE,\n    date DATE NOT NULL,\n    -- Availability\n    is_available BOOLEAN NOT NULL DEFAULT true,\n    is_blocked BOOLEAN NOT NULL DEFAULT false, -- manual block/maintenance\n    block_reason VARCHAR(100),\n    min_stay_override INTEGER,\n    -- Pricing\n    base_price DECIMAL(12, 2) NOT NULL,\n    discounted_price DECIMAL(12, 2),\n    currency VARCHAR(3) NOT NULL DEFAULT 'BRL',\n    -- Inventory\n    allotment INTEGER NOT NULL DEFAULT 1, -- rooms available\n    bookings_count INTEGER NOT NULL DEFAULT 0,\n    -- Sync metadata\n    host_last_synced_at TIMESTAMPTZ,\n    host_data_hash VARCHAR(64),\n    source_system VARCHAR(50) DEFAULT 'reserve', -- reserve, host, ota\n    metadata JSONB DEFAULT '{}',\n    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),\n    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),\n    \n    CONSTRAINT unique_unit_rate_date UNIQUE (unit_id, rate_plan_id, date),\n    CONSTRAINT valid_price CHECK (base_price >= 0),\n    CONSTRAINT valid_discounted_price CHECK (discounted_price IS NULL OR discounted_price >= 0),\n    CONSTRAINT valid_allotment CHECK (allotment >= 0),\n    CONSTRAINT valid_bookings CHECK (bookings_count >= 0 AND bookings_count <= allotment),\n    CONSTRAINT valid_min_stay CHECK (min_stay_override IS NULL OR min_stay_override >= 1)\n)","CREATE INDEX idx_availability_unit ON reserve.availability_calendar(unit_id)","CREATE INDEX idx_availability_rate_plan ON reserve.availability_calendar(rate_plan_id)","CREATE INDEX idx_availability_date ON reserve.availability_calendar(date)","CREATE INDEX idx_availability_date_range ON reserve.availability_calendar(date, is_available, is_blocked) \n    WHERE is_available = true AND is_blocked = false","CREATE INDEX idx_availability_unit_date ON reserve.availability_calendar(unit_id, date)","CREATE INDEX idx_availability_search ON reserve.availability_calendar(unit_id, date, is_available, is_blocked, base_price) \n    WHERE is_available = true AND is_blocked = false","COMMENT ON TABLE reserve.availability_calendar IS 'Per unit/rate_plan/date availability and pricing - main operational table'","COMMENT ON COLUMN reserve.availability_calendar.allotment IS 'Number of rooms/units available for this date'","COMMENT ON COLUMN reserve.availability_calendar.bookings_count IS 'Current confirmed bookings for this slot'","-- ============================================\n-- 6. TRAVELERS TABLE\n-- ============================================\n\nCREATE TABLE reserve.travelers (\n    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),\n    auth_user_id UUID REFERENCES auth.users(id) ON DELETE SET NULL,\n    -- Profile\n    email VARCHAR(255) NOT NULL,\n    first_name VARCHAR(100),\n    last_name VARCHAR(100),\n    phone VARCHAR(50),\n    phone_country_code VARCHAR(5),\n    date_of_birth DATE,\n    nationality VARCHAR(100),\n    document_type VARCHAR(50), -- passport, cpf, rg, etc.\n    document_number VARCHAR(100),\n    -- Address\n    address_line_1 VARCHAR(255),\n    address_line_2 VARCHAR(255),\n    city VARCHAR(100),\n    state_province VARCHAR(100),\n    postal_code VARCHAR(20),\n    country VARCHAR(100),\n    -- Preferences\n    preferences JSONB DEFAULT '{}',\n    marketing_consent BOOLEAN NOT NULL DEFAULT false,\n    marketing_consent_at TIMESTAMPTZ,\n    -- Security\n    is_verified BOOLEAN NOT NULL DEFAULT false,\n    verification_method VARCHAR(50),\n    verified_at TIMESTAMPTZ,\n    deleted_at TIMESTAMPTZ,\n    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),\n    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),\n    \n    CONSTRAINT valid_email CHECK (email ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\\\.[A-Za-z]{2,}$')\n)","CREATE INDEX idx_travelers_auth ON reserve.travelers(auth_user_id) WHERE auth_user_id IS NOT NULL","CREATE INDEX idx_travelers_email ON reserve.travelers(email)","CREATE UNIQUE INDEX idx_travelers_unique_email ON reserve.travelers(email) WHERE deleted_at IS NULL","CREATE INDEX idx_travelers_phone ON reserve.travelers(phone) WHERE phone IS NOT NULL","CREATE INDEX idx_travelers_name ON reserve.travelers(last_name, first_name) WHERE deleted_at IS NULL","CREATE INDEX idx_travelers_verified ON reserve.travelers(is_verified) WHERE is_verified = true","COMMENT ON TABLE reserve.travelers IS 'Traveler accounts - linked to auth.users when registered'","COMMENT ON COLUMN reserve.travelers.auth_user_id IS 'Link to Supabase auth.users (nullable for guest bookings)'","COMMENT ON COLUMN reserve.travelers.preferences IS 'JSON: room_preferences, dietary_restrictions, etc.'","-- ============================================\n-- 7. RESERVATIONS TABLE\n-- ============================================\n\nCREATE TABLE reserve.reservations (\n    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),\n    -- References\n    traveler_id UUID REFERENCES reserve.travelers(id) ON DELETE SET NULL,\n    property_id UUID NOT NULL REFERENCES reserve.properties_map(id),\n    unit_id UUID NOT NULL REFERENCES reserve.unit_map(id),\n    rate_plan_id UUID NOT NULL REFERENCES reserve.rate_plans(id),\n    -- Booking details\n    confirmation_code VARCHAR(50) UNIQUE NOT NULL,\n    source reserve.reservation_source NOT NULL DEFAULT 'direct',\n    ota_booking_id VARCHAR(100),\n    ota_guest_name VARCHAR(200),\n    ota_guest_email VARCHAR(255),\n    -- Dates\n    check_in DATE NOT NULL,\n    check_out DATE NOT NULL,\n    nights INTEGER NOT NULL,\n    guests_adults INTEGER NOT NULL DEFAULT 1,\n    guests_children INTEGER NOT NULL DEFAULT 0,\n    guests_infants INTEGER NOT NULL DEFAULT 0,\n    -- Status\n    status reserve.reservation_status NOT NULL DEFAULT 'pending',\n    payment_status reserve.payment_status NOT NULL DEFAULT 'pending',\n    -- Pricing\n    currency VARCHAR(3) NOT NULL DEFAULT 'BRL',\n    subtotal DECIMAL(12, 2) NOT NULL,\n    taxes DECIMAL(12, 2) NOT NULL DEFAULT 0,\n    fees DECIMAL(12, 2) NOT NULL DEFAULT 0,\n    discount_amount DECIMAL(12, 2) NOT NULL DEFAULT 0,\n    total_amount DECIMAL(12, 2) NOT NULL,\n    amount_paid DECIMAL(12, 2) NOT NULL DEFAULT 0,\n    -- Guest info (snapshot at booking)\n    guest_first_name VARCHAR(100),\n    guest_last_name VARCHAR(100),\n    guest_email VARCHAR(255),\n    guest_phone VARCHAR(50),\n    special_requests TEXT,\n    -- Metadata\n    metadata JSONB DEFAULT '{}',\n    -- Audit\n    booked_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),\n    cancelled_at TIMESTAMPTZ,\n    cancellation_reason TEXT,\n    checked_in_at TIMESTAMPTZ,\n    checked_out_at TIMESTAMPTZ,\n    deleted_at TIMESTAMPTZ,\n    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),\n    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),\n    \n    CONSTRAINT valid_dates CHECK (check_out > check_in),\n    CONSTRAINT valid_nights CHECK (nights = (check_out - check_in)),\n    CONSTRAINT valid_guests CHECK (guests_adults >= 1 AND guests_children >= 0 AND guests_infants >= 0),\n    CONSTRAINT valid_total CHECK (total_amount >= 0),\n    CONSTRAINT valid_amount_paid CHECK (amount_paid >= 0 AND amount_paid <= total_amount)\n)","CREATE INDEX idx_reservations_traveler ON reserve.reservations(traveler_id) WHERE traveler_id IS NOT NULL","CREATE INDEX idx_reservations_property ON reserve.reservations(property_id)","CREATE INDEX idx_reservations_unit ON reserve.reservations(unit_id)","CREATE INDEX idx_reservations_dates ON reserve.reservations(check_in, check_out)","CREATE INDEX idx_reservations_checkin ON reserve.reservations(check_in) WHERE status IN ('confirmed', 'checked_in')","CREATE INDEX idx_reservations_status ON reserve.reservations(status)","CREATE INDEX idx_reservations_source ON reserve.reservations(source)","CREATE INDEX idx_reservations_confirmation ON reserve.reservations(confirmation_code)","CREATE INDEX idx_reservations_ota ON reserve.reservations(ota_booking_id) WHERE ota_booking_id IS NOT NULL","CREATE INDEX idx_reservations_booked_at ON reserve.reservations(booked_at DESC)","CREATE INDEX idx_reservations_active ON reserve.reservations(property_id, check_in, check_out, status) \n    WHERE status IN ('pending', 'confirmed', 'checked_in')","COMMENT ON TABLE reserve.reservations IS 'All reservations - direct bookings and OTA imports'","COMMENT ON COLUMN reserve.reservations.confirmation_code IS 'Unique booking reference (e.g., RES-2026-ABC123)'","COMMENT ON COLUMN reserve.reservations.ota_booking_id IS 'External booking reference from OTA'","COMMENT ON COLUMN reserve.reservations.metadata IS 'JSON: payment_details, ota_fees, commission, etc.'","-- ============================================\n-- 8. SYNC_JOBS TABLE\n-- ============================================\n\nCREATE TABLE reserve.sync_jobs (\n    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),\n    job_name VARCHAR(100) NOT NULL,\n    job_type VARCHAR(50) NOT NULL, -- availability, properties, reservations, etc.\n    direction reserve.sync_direction NOT NULL,\n    -- Scope\n    property_id UUID REFERENCES reserve.properties_map(id),\n    city_id UUID REFERENCES reserve.cities(id),\n    date_from DATE,\n    date_to DATE,\n    -- Execution\n    status reserve.sync_status NOT NULL DEFAULT 'pending',\n    priority INTEGER NOT NULL DEFAULT 5, -- 1-10, lower is higher priority\n    started_at TIMESTAMPTZ,\n    completed_at TIMESTAMPTZ,\n    failed_at TIMESTAMPTZ,\n    error_message TEXT,\n    error_details JSONB,\n    retry_count INTEGER NOT NULL DEFAULT 0,\n    max_retries INTEGER NOT NULL DEFAULT 3,\n    -- Performance\n    records_processed INTEGER,\n    records_inserted INTEGER,\n    records_updated INTEGER,\n    records_failed INTEGER,\n    latency_ms INTEGER,\n    -- Source data tracking\n    source_payload_hash VARCHAR(64),\n    target_payload_hash VARCHAR(64),\n    -- Metadata\n    metadata JSONB DEFAULT '{}',\n    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),\n    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()\n)","CREATE INDEX idx_sync_jobs_status ON reserve.sync_jobs(status)","CREATE INDEX idx_sync_jobs_type ON reserve.sync_jobs(job_type)","CREATE INDEX idx_sync_jobs_property ON reserve.sync_jobs(property_id) WHERE property_id IS NOT NULL","CREATE INDEX idx_sync_jobs_pending ON reserve.sync_jobs(status, priority, created_at) \n    WHERE status IN ('pending', 'retrying')","CREATE INDEX idx_sync_jobs_created ON reserve.sync_jobs(created_at DESC)","CREATE INDEX idx_sync_jobs_dates ON reserve.sync_jobs(date_from, date_to) WHERE date_from IS NOT NULL","COMMENT ON TABLE reserve.sync_jobs IS 'Idempotent sync operations - tracks all data synchronization with Host Connect'","COMMENT ON COLUMN reserve.sync_jobs.source_payload_hash IS 'SHA-256 of incoming data payload for idempotency'","COMMENT ON COLUMN reserve.sync_jobs.latency_ms IS 'Total sync operation duration in milliseconds'","-- ============================================\n-- 9. SYNC_LOGS TABLE\n-- ============================================\n\nCREATE TABLE reserve.sync_logs (\n    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),\n    sync_job_id UUID REFERENCES reserve.sync_jobs(id) ON DELETE CASCADE,\n    log_level VARCHAR(20) NOT NULL DEFAULT 'info', -- debug, info, warning, error\n    message TEXT NOT NULL,\n    details JSONB,\n    record_id UUID, -- specific record affected\n    record_type VARCHAR(50), -- table name\n    action VARCHAR(50), -- insert, update, delete, skip\n    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()\n)","CREATE INDEX idx_sync_logs_job ON reserve.sync_logs(sync_job_id)","CREATE INDEX idx_sync_logs_level ON reserve.sync_logs(log_level)","CREATE INDEX idx_sync_logs_created ON reserve.sync_logs(created_at DESC)","CREATE INDEX idx_sync_logs_record ON reserve.sync_logs(record_type, record_id) WHERE record_id IS NOT NULL","COMMENT ON TABLE reserve.sync_logs IS 'Detailed logging for sync operations - debugging and audit trail'","-- ============================================\n-- 10. EVENTS TABLE (Internal Event Bus)\n-- ============================================\n\nCREATE TABLE reserve.events (\n    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),\n    event_name VARCHAR(100) NOT NULL,\n    event_version VARCHAR(10) NOT NULL DEFAULT '1.0',\n    severity reserve.event_severity NOT NULL DEFAULT 'info',\n    -- Actor\n    actor_type VARCHAR(50) NOT NULL, -- user, system, ota, edge_function\n    actor_id VARCHAR(255), -- user_id, system_name, etc.\n    -- Entity\n    entity_type VARCHAR(50) NOT NULL, -- reservation, property, traveler, etc.\n    entity_id UUID NOT NULL,\n    -- Payload\n    payload JSONB NOT NULL DEFAULT '{}',\n    payload_schema VARCHAR(100),\n    -- Processing\n    processed_at TIMESTAMPTZ,\n    processor_id VARCHAR(100),\n    error_message TEXT,\n    retry_count INTEGER NOT NULL DEFAULT 0,\n    -- Metadata\n    correlation_id UUID, -- links related events\n    causation_id UUID, -- parent event that caused this\n    metadata JSONB DEFAULT '{}',\n    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()\n)","CREATE INDEX idx_events_name ON reserve.events(event_name)","CREATE INDEX idx_events_entity ON reserve.events(entity_type, entity_id)","CREATE INDEX idx_events_actor ON reserve.events(actor_type, actor_id) WHERE actor_id IS NOT NULL","CREATE INDEX idx_events_severity ON reserve.events(severity)","CREATE INDEX idx_events_created ON reserve.events(created_at DESC)","CREATE INDEX idx_events_correlation ON reserve.events(correlation_id) WHERE correlation_id IS NOT NULL","CREATE INDEX idx_events_unprocessed ON reserve.events(processed_at) WHERE processed_at IS NULL","CREATE INDEX idx_events_payload ON reserve.events USING GIN (payload jsonb_path_ops)","COMMENT ON TABLE reserve.events IS 'Internal event bus for decoupled processing - reservation events, sync events, etc.'","COMMENT ON COLUMN reserve.events.correlation_id IS 'Groups related events together'","COMMENT ON COLUMN reserve.events.causation_id IS 'References the event that caused this event'","-- ============================================\n-- 11. AUDIT_LOGS TABLE\n-- ============================================\n\nCREATE TABLE reserve.audit_logs (\n    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),\n    -- Who\n    actor_type VARCHAR(50) NOT NULL, -- user, api_key, system, edge_function\n    actor_id VARCHAR(255),\n    actor_email VARCHAR(255),\n    -- What\n    action VARCHAR(50) NOT NULL, -- create, update, delete, login, sync, etc.\n    resource_type VARCHAR(50) NOT NULL, -- table name or resource type\n    resource_id UUID,\n    -- Change tracking\n    before_data JSONB,\n    after_data JSONB,\n    changed_fields JSONB, -- array of field names that changed\n    -- Context\n    ip_address INET,\n    user_agent TEXT,\n    request_id VARCHAR(100),\n    session_id VARCHAR(100),\n    -- Metadata\n    metadata JSONB DEFAULT '{}',\n    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()\n)","CREATE INDEX idx_audit_logs_resource ON reserve.audit_logs(resource_type, resource_id) WHERE resource_id IS NOT NULL","CREATE INDEX idx_audit_logs_actor ON reserve.audit_logs(actor_type, actor_id) WHERE actor_id IS NOT NULL","CREATE INDEX idx_audit_logs_action ON reserve.audit_logs(action)","CREATE INDEX idx_audit_logs_created ON reserve.audit_logs(created_at DESC)","CREATE INDEX idx_audit_logs_request ON reserve.audit_logs(request_id) WHERE request_id IS NOT NULL","CREATE INDEX idx_audit_logs_before ON reserve.audit_logs USING GIN (before_data jsonb_path_ops)","CREATE INDEX idx_audit_logs_after ON reserve.audit_logs USING GIN (after_data jsonb_path_ops)","COMMENT ON TABLE reserve.audit_logs IS 'Comprehensive audit trail - who changed what and when'","COMMENT ON COLUMN reserve.audit_logs.changed_fields IS 'JSON array of field names that were modified'","-- ============================================\n-- 12. FUNNEL_EVENTS TABLE\n-- ============================================\n\nCREATE TABLE reserve.funnel_events (\n    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),\n    -- Session tracking\n    session_id VARCHAR(100) NOT NULL,\n    visitor_id VARCHAR(100) NOT NULL,\n    -- Event\n    stage reserve.funnel_stage NOT NULL,\n    event_name VARCHAR(100),\n    -- Context\n    city_id UUID REFERENCES reserve.cities(id),\n    property_id UUID REFERENCES reserve.properties_map(id),\n    unit_id UUID REFERENCES reserve.unit_map(id),\n    search_params JSONB, -- stored search criteria\n    -- Attribution\n    utm_source VARCHAR(100),\n    utm_medium VARCHAR(100),\n    utm_campaign VARCHAR(200),\n    utm_content VARCHAR(200),\n    referrer VARCHAR(500),\n    landing_page VARCHAR(500),\n    -- Device/Environment\n    user_agent TEXT,\n    device_type VARCHAR(50), -- mobile, tablet, desktop\n    browser VARCHAR(50),\n    os VARCHAR(50),\n    ip_address INET,\n    country VARCHAR(100),\n    -- Conversion\n    conversion_value DECIMAL(12, 2),\n    conversion_currency VARCHAR(3),\n    reservation_id UUID REFERENCES reserve.reservations(id),\n    -- Timing\n    time_on_page_seconds INTEGER,\n    scroll_depth_percent INTEGER,\n    -- Metadata\n    metadata JSONB DEFAULT '{}',\n    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()\n)","CREATE INDEX idx_funnel_events_session ON reserve.funnel_events(session_id)","CREATE INDEX idx_funnel_events_visitor ON reserve.funnel_events(visitor_id)","CREATE INDEX idx_funnel_events_stage ON reserve.funnel_events(stage)","CREATE INDEX idx_funnel_events_property ON reserve.funnel_events(property_id) WHERE property_id IS NOT NULL","CREATE INDEX idx_funnel_events_city ON reserve.funnel_events(city_id) WHERE city_id IS NOT NULL","CREATE INDEX idx_funnel_events_created ON reserve.funnel_events(created_at DESC)","CREATE INDEX idx_funnel_events_utm ON reserve.funnel_events(utm_source, utm_medium) WHERE utm_source IS NOT NULL","CREATE INDEX idx_funnel_events_reservation ON reserve.funnel_events(reservation_id) WHERE reservation_id IS NOT NULL","COMMENT ON TABLE reserve.funnel_events IS 'Conversion funnel tracking - from page view to purchase'","COMMENT ON COLUMN reserve.funnel_events.visitor_id IS 'Anonymous visitor identifier (persistent across sessions)'","COMMENT ON COLUMN reserve.funnel_events.metadata IS 'JSON: ab_test_variant, pricing_shown, etc.'","-- ============================================\n-- 13. KPI_DAILY_SNAPSHOTS TABLE\n-- ============================================\n\nCREATE TABLE reserve.kpi_daily_snapshots (\n    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),\n    snapshot_date DATE NOT NULL,\n    city_id UUID REFERENCES reserve.cities(id),\n    property_id UUID REFERENCES reserve.properties_map(id),\n    -- Revenue metrics\n    revenue_total DECIMAL(12, 2) NOT NULL DEFAULT 0,\n    revenue_direct DECIMAL(12, 2) NOT NULL DEFAULT 0,\n    revenue_ota DECIMAL(12, 2) NOT NULL DEFAULT 0,\n    adr DECIMAL(10, 2), -- Average Daily Rate\n    revpar DECIMAL(10, 2), -- Revenue per Available Room\n    -- Occupancy metrics\n    rooms_total INTEGER NOT NULL DEFAULT 0,\n    rooms_available INTEGER NOT NULL DEFAULT 0,\n    rooms_sold INTEGER NOT NULL DEFAULT 0,\n    occupancy_rate DECIMAL(5, 4), -- 0.00 to 1.00\n    -- Booking metrics\n    bookings_total INTEGER NOT NULL DEFAULT 0,\n    bookings_direct INTEGER NOT NULL DEFAULT 0,\n    bookings_ota INTEGER NOT NULL DEFAULT 0,\n    cancellations INTEGER NOT NULL DEFAULT 0,\n    no_shows INTEGER NOT NULL DEFAULT 0,\n    nights_sold INTEGER NOT NULL DEFAULT 0,\n    avg_lead_time_days DECIMAL(5, 1),\n    avg_length_of_stay DECIMAL(4, 1),\n    -- Operational metrics\n    sync_jobs_completed INTEGER NOT NULL DEFAULT 0,\n    sync_jobs_failed INTEGER NOT NULL DEFAULT 0,\n    avg_sync_latency_ms INTEGER,\n    api_requests_count INTEGER NOT NULL DEFAULT 0,\n    error_rate DECIMAL(5, 4),\n    -- Marketing/Ads metrics\n    ad_spend DECIMAL(12, 2) NOT NULL DEFAULT 0,\n    ad_impressions INTEGER NOT NULL DEFAULT 0,\n    ad_clicks INTEGER NOT NULL DEFAULT 0,\n    ad_conversions INTEGER NOT NULL DEFAULT 0,\n    cac DECIMAL(10, 2), -- Customer Acquisition Cost\n    roas DECIMAL(5, 2), -- Return on Ad Spend\n    -- Funnel metrics\n    page_views INTEGER NOT NULL DEFAULT 0,\n    searches INTEGER NOT NULL DEFAULT 0,\n    property_views INTEGER NOT NULL DEFAULT 0,\n    checkout_starts INTEGER NOT NULL DEFAULT 0,\n    checkout_completions INTEGER NOT NULL DEFAULT 0,\n    conversion_rate DECIMAL(5, 4),\n    -- Metadata\n    metadata JSONB DEFAULT '{}',\n    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),\n    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),\n    \n    CONSTRAINT unique_daily_snapshot UNIQUE (snapshot_date, city_id, property_id),\n    CONSTRAINT valid_occupancy CHECK (occupancy_rate IS NULL OR (occupancy_rate >= 0 AND occupancy_rate <= 1)),\n    CONSTRAINT valid_conversion CHECK (conversion_rate IS NULL OR (conversion_rate >= 0 AND conversion_rate <= 1))\n)","CREATE INDEX idx_kpi_snapshots_date ON reserve.kpi_daily_snapshots(snapshot_date)","CREATE INDEX idx_kpi_snapshots_city ON reserve.kpi_daily_snapshots(city_id) WHERE city_id IS NOT NULL","CREATE INDEX idx_kpi_snapshots_property ON reserve.kpi_daily_snapshots(property_id) WHERE property_id IS NOT NULL","CREATE INDEX idx_kpi_snapshots_range ON reserve.kpi_daily_snapshots(snapshot_date, city_id, property_id)","COMMENT ON TABLE reserve.kpi_daily_snapshots IS 'Daily aggregated KPIs - revenue, occupancy, ADR, RevPAR, ops, ads'","COMMENT ON COLUMN reserve.kpi_daily_snapshots.adr IS 'Average Daily Rate = revenue / nights sold'","COMMENT ON COLUMN reserve.kpi_daily_snapshots.revpar IS 'Revenue per Available Room = revenue / rooms available'","COMMENT ON COLUMN reserve.kpi_daily_snapshots.cac IS 'Customer Acquisition Cost = ad_spend / bookings from ads'","COMMENT ON COLUMN reserve.kpi_daily_snapshots.roas IS 'Return on Ad Spend = revenue from ads / ad_spend'","-- ============================================\n-- ROW LEVEL SECURITY (RLS) POLICIES\n-- ============================================\n\n-- Enable RLS on all tables\nALTER TABLE reserve.cities ENABLE ROW LEVEL SECURITY","ALTER TABLE reserve.properties_map ENABLE ROW LEVEL SECURITY","ALTER TABLE reserve.unit_map ENABLE ROW LEVEL SECURITY","ALTER TABLE reserve.rate_plans ENABLE ROW LEVEL SECURITY","ALTER TABLE reserve.availability_calendar ENABLE ROW LEVEL SECURITY","ALTER TABLE reserve.travelers ENABLE ROW LEVEL SECURITY","ALTER TABLE reserve.reservations ENABLE ROW LEVEL SECURITY","ALTER TABLE reserve.sync_jobs ENABLE ROW LEVEL SECURITY","ALTER TABLE reserve.sync_logs ENABLE ROW LEVEL SECURITY","ALTER TABLE reserve.events ENABLE ROW LEVEL SECURITY","ALTER TABLE reserve.audit_logs ENABLE ROW LEVEL SECURITY","ALTER TABLE reserve.funnel_events ENABLE ROW LEVEL SECURITY","ALTER TABLE reserve.kpi_daily_snapshots ENABLE ROW LEVEL SECURITY","-- ============================================\n-- SERVICE ROLE / EDGE FUNCTION POLICIES\n-- ============================================\n\n-- Service role can do everything on all tables\nCREATE POLICY service_role_all_cities ON reserve.cities\n    FOR ALL TO service_role USING (true) WITH CHECK (true)","CREATE POLICY service_role_all_properties ON reserve.properties_map\n    FOR ALL TO service_role USING (true) WITH CHECK (true)","CREATE POLICY service_role_all_units ON reserve.unit_map\n    FOR ALL TO service_role USING (true) WITH CHECK (true)","CREATE POLICY service_role_all_rate_plans ON reserve.rate_plans\n    FOR ALL TO service_role USING (true) WITH CHECK (true)","CREATE POLICY service_role_all_availability ON reserve.availability_calendar\n    FOR ALL TO service_role USING (true) WITH CHECK (true)","CREATE POLICY service_role_all_travelers ON reserve.travelers\n    FOR ALL TO service_role USING (true) WITH CHECK (true)","CREATE POLICY service_role_all_reservations ON reserve.reservations\n    FOR ALL TO service_role USING (true) WITH CHECK (true)","CREATE POLICY service_role_all_sync_jobs ON reserve.sync_jobs\n    FOR ALL TO service_role USING (true) WITH CHECK (true)","CREATE POLICY service_role_all_sync_logs ON reserve.sync_logs\n    FOR ALL TO service_role USING (true) WITH CHECK (true)","CREATE POLICY service_role_all_events ON reserve.events\n    FOR ALL TO service_role USING (true) WITH CHECK (true)","CREATE POLICY service_role_all_audit_logs ON reserve.audit_logs\n    FOR ALL TO service_role USING (true) WITH CHECK (true)","CREATE POLICY service_role_all_funnel ON reserve.funnel_events\n    FOR ALL TO service_role USING (true) WITH CHECK (true)","CREATE POLICY service_role_all_kpi ON reserve.kpi_daily_snapshots\n    FOR ALL TO service_role USING (true) WITH CHECK (true)","-- ============================================\n-- ANONYMOUS / PUBLIC READ POLICIES\n-- ============================================\n\n-- Public can read published properties, cities, rate plans, availability\nCREATE POLICY public_read_cities ON reserve.cities\n    FOR SELECT TO anon USING (is_active = true)","CREATE POLICY public_read_properties ON reserve.properties_map\n    FOR SELECT TO anon USING (is_active = true AND is_published = true AND deleted_at IS NULL)","CREATE POLICY public_read_units ON reserve.unit_map\n    FOR SELECT TO anon USING (is_active = true AND deleted_at IS NULL)","CREATE POLICY public_read_rate_plans ON reserve.rate_plans\n    FOR SELECT TO anon USING (is_active = true AND deleted_at IS NULL)","CREATE POLICY public_read_availability ON reserve.availability_calendar\n    FOR SELECT TO anon USING (is_available = true AND is_blocked = false)","-- ============================================\n-- AUTHENTICATED TRAVELER POLICIES\n-- ============================================\n\n-- Travelers can read and update their own profile\nCREATE POLICY traveler_own_profile ON reserve.travelers\n    FOR ALL TO authenticated\n    USING (auth_user_id = auth.uid())\n    WITH CHECK (auth_user_id = auth.uid())","-- Travelers can read their own reservations\nCREATE POLICY traveler_own_reservations ON reserve.reservations\n    FOR SELECT TO authenticated\n    USING (traveler_id IN (\n        SELECT id FROM reserve.travelers WHERE auth_user_id = auth.uid()\n    ))","-- Travelers can create new reservations (booking process)\nCREATE POLICY traveler_create_reservation ON reserve.reservations\n    FOR INSERT TO authenticated\n    WITH CHECK (traveler_id IN (\n        SELECT id FROM reserve.travelers WHERE auth_user_id = auth.uid()\n    ))","-- Travelers can update their own reservations (cancellations, modifications)\nCREATE POLICY traveler_update_reservation ON reserve.reservations\n    FOR UPDATE TO authenticated\n    USING (traveler_id IN (\n        SELECT id FROM reserve.travelers WHERE auth_user_id = auth.uid()\n    ))\n    WITH CHECK (traveler_id IN (\n        SELECT id FROM reserve.travelers WHERE auth_user_id = auth.uid()\n    ))","-- ============================================\n-- ADMIN ROLE POLICIES (Placeholder Structure)\n-- ============================================\n-- NOTE: Admin role implementation requires:\n-- 1. Creating custom claims in auth.users.raw_user_meta_data\n-- 2. OR using a separate admin_users table\n-- 3. OR using Supabase custom claims (recommended)\n\n-- Example structure for when admin roles are added:\n/*\nCREATE POLICY admin_all_cities ON reserve.cities\n    FOR ALL TO authenticated\n    USING (auth.jwt() ->> 'role' = 'admin')\n    WITH CHECK (auth.jwt() ->> 'role' = 'admin');\n\nCREATE POLICY admin_all_properties ON reserve.properties_map\n    FOR ALL TO authenticated\n    USING (auth.jwt() ->> 'role' = 'admin')\n    WITH CHECK (auth.jwt() ->> 'role' = 'admin');\n\n-- ... repeat for all tables\n*/\n\n-- ============================================\n-- SYNC OPERATIONS ACCESS\n-- ============================================\n\n-- Edge functions (authenticated) can manage sync operations\nCREATE POLICY edge_function_sync_jobs ON reserve.sync_jobs\n    FOR ALL TO authenticated\n    USING (auth.jwt() ->> 'app_role' = 'sync_worker')\n    WITH CHECK (auth.jwt() ->> 'app_role' = 'sync_worker')","CREATE POLICY edge_function_sync_logs ON reserve.sync_logs\n    FOR ALL TO authenticated\n    USING (auth.jwt() ->> 'app_role' = 'sync_worker')\n    WITH CHECK (auth.jwt() ->> 'app_role' = 'sync_worker')","-- ============================================\n-- TRIGGERS & AUTOMATION\n-- ============================================\n\n-- Auto-update updated_at timestamps\nCREATE OR REPLACE FUNCTION reserve.set_updated_at()\nRETURNS TRIGGER AS $$\nBEGIN\n    NEW.updated_at = NOW();\n    RETURN NEW;\nEND;\n$$ LANGUAGE plpgsql","-- Apply to all tables with updated_at\nCREATE TRIGGER set_updated_at BEFORE UPDATE ON reserve.cities\n    FOR EACH ROW EXECUTE FUNCTION reserve.set_updated_at()","CREATE TRIGGER set_updated_at BEFORE UPDATE ON reserve.properties_map\n    FOR EACH ROW EXECUTE FUNCTION reserve.set_updated_at()","CREATE TRIGGER set_updated_at BEFORE UPDATE ON reserve.unit_map\n    FOR EACH ROW EXECUTE FUNCTION reserve.set_updated_at()","CREATE TRIGGER set_updated_at BEFORE UPDATE ON reserve.rate_plans\n    FOR EACH ROW EXECUTE FUNCTION reserve.set_updated_at()","CREATE TRIGGER set_updated_at BEFORE UPDATE ON reserve.availability_calendar\n    FOR EACH ROW EXECUTE FUNCTION reserve.set_updated_at()","CREATE TRIGGER set_updated_at BEFORE UPDATE ON reserve.travelers\n    FOR EACH ROW EXECUTE FUNCTION reserve.set_updated_at()","CREATE TRIGGER set_updated_at BEFORE UPDATE ON reserve.reservations\n    FOR EACH ROW EXECUTE FUNCTION reserve.set_updated_at()","CREATE TRIGGER set_updated_at BEFORE UPDATE ON reserve.sync_jobs\n    FOR EACH ROW EXECUTE FUNCTION reserve.set_updated_at()","CREATE TRIGGER set_updated_at BEFORE UPDATE ON reserve.kpi_daily_snapshots\n    FOR EACH ROW EXECUTE FUNCTION reserve.set_updated_at()","-- Auto-calculate nights on reservation insert/update\nCREATE OR REPLACE FUNCTION reserve.calculate_reservation_nights()\nRETURNS TRIGGER AS $$\nBEGIN\n    NEW.nights = NEW.check_out - NEW.check_in;\n    RETURN NEW;\nEND;\n$$ LANGUAGE plpgsql","CREATE TRIGGER calculate_nights BEFORE INSERT OR UPDATE OF check_in, check_out ON reserve.reservations\n    FOR EACH ROW EXECUTE FUNCTION reserve.calculate_reservation_nights()","-- Soft delete handling (optional - can be implemented in application layer)\nCREATE OR REPLACE FUNCTION reserve.soft_delete_property()\nRETURNS TRIGGER AS $$\nBEGIN\n    -- Archive related records logic can go here\n    RETURN OLD;\nEND;\n$$ LANGUAGE plpgsql","-- ============================================\n-- VIEWS & HELPER FUNCTIONS\n-- ============================================\n\n-- View: Active properties with availability summary\nCREATE VIEW reserve.active_properties_view AS\nSELECT \n    p.id,\n    p.host_property_id,\n    p.name,\n    p.slug,\n    p.city_id,\n    c.name as city_name,\n    p.property_type,\n    p.latitude,\n    p.longitude,\n    p.rating_cached,\n    p.review_count_cached,\n    p.is_active,\n    p.is_published,\n    p.created_at,\n    COUNT(DISTINCT u.id) as unit_count,\n    COUNT(DISTINCT rp.id) as rate_plan_count\nFROM reserve.properties_map p\nJOIN reserve.cities c ON p.city_id = c.id\nLEFT JOIN reserve.unit_map u ON p.id = u.property_id AND u.is_active = true AND u.deleted_at IS NULL\nLEFT JOIN reserve.rate_plans rp ON p.id = rp.property_id AND rp.is_active = true AND rp.deleted_at IS NULL\nWHERE p.is_active = true AND p.deleted_at IS NULL\nGROUP BY p.id, c.name","-- View: Upcoming reservations (for dashboard)\nCREATE VIEW reserve.upcoming_reservations_view AS\nSELECT \n    r.id,\n    r.confirmation_code,\n    r.traveler_id,\n    t.first_name || ' ' || t.last_name as traveler_name,\n    t.email as traveler_email,\n    r.property_id,\n    p.name as property_name,\n    r.unit_id,\n    u.name as unit_name,\n    r.check_in,\n    r.check_out,\n    r.nights,\n    r.guests_adults,\n    r.guests_children,\n    r.status,\n    r.payment_status,\n    r.total_amount,\n    r.currency,\n    r.source,\n    r.booked_at\nFROM reserve.reservations r\nLEFT JOIN reserve.travelers t ON r.traveler_id = t.id\nJOIN reserve.properties_map p ON r.property_id = p.id\nJOIN reserve.unit_map u ON r.unit_id = u.id\nWHERE r.check_in >= CURRENT_DATE\n    AND r.status IN ('confirmed', 'checked_in', 'pending')\nORDER BY r.check_in ASC","-- Function: Generate confirmation code\nCREATE OR REPLACE FUNCTION reserve.generate_confirmation_code()\nRETURNS VARCHAR(50) AS $$\nDECLARE\n    code VARCHAR(50);\n    exists_check BOOLEAN;\nBEGIN\n    LOOP\n        code := 'RES-' || TO_CHAR(NOW(), 'YYYY') || '-' || UPPER(SUBSTRING(MD5(RANDOM()::TEXT), 1, 6));\n        SELECT EXISTS(SELECT 1 FROM reserve.reservations WHERE confirmation_code = code) INTO exists_check;\n        EXIT WHEN NOT exists_check;\n    END LOOP;\n    RETURN code;\nEND;\n$$ LANGUAGE plpgsql","-- Function: Check availability for date range\nCREATE OR REPLACE FUNCTION reserve.check_availability(\n    p_unit_id UUID,\n    p_rate_plan_id UUID,\n    p_check_in DATE,\n    p_check_out DATE,\n    p_guests INTEGER DEFAULT 1\n)\nRETURNS TABLE (\n    date DATE,\n    is_available BOOLEAN,\n    base_price DECIMAL(12, 2),\n    discounted_price DECIMAL(12, 2)\n) AS $$\nBEGIN\n    RETURN QUERY\n    SELECT \n        ac.date,\n        ac.is_available AND NOT ac.is_blocked AND ac.allotment > ac.bookings_count,\n        ac.base_price,\n        ac.discounted_price\n    FROM reserve.availability_calendar ac\n    WHERE ac.unit_id = p_unit_id\n        AND ac.rate_plan_id = p_rate_plan_id\n        AND ac.date >= p_check_in\n        AND ac.date < p_check_out\n    ORDER BY ac.date;\nEND;\n$$ LANGUAGE plpgsql","-- ============================================\n-- MIGRATION COMPLETION\n-- ============================================\n\nDO $$\nBEGIN\n    RAISE NOTICE '========================================';\n    RAISE NOTICE 'RESERVE CONNECT SCHEMA CREATED SUCCESSFULLY';\n    RAISE NOTICE '========================================';\n    RAISE NOTICE 'Schema: reserve';\n    RAISE NOTICE 'Tables: 13';\n    RAISE NOTICE 'Pilot City: Urubici (URB)';\n    RAISE NOTICE 'RLS: Enabled on all tables';\n    RAISE NOTICE '========================================';\nEND $$"}	reserve_connect_reset_and_schema	\N	\N	\N
20260213000002	{"-- ============================================\n-- RESERVE CONNECT - SYNC SUPPORT SCHEMA\n-- Additional constraints and indexes for Host Connect sync\n-- ============================================\n\n-- ============================================\n-- UNIT_MAP ENHANCEMENTS\n-- ============================================\n\n-- Add host_property_id column to link room types to host properties\n-- This is needed for the sync process to link room types to their parent property\nALTER TABLE reserve.unit_map \nADD COLUMN IF NOT EXISTS host_property_id UUID","COMMENT ON COLUMN reserve.unit_map.host_property_id IS \n'Reference to Host Connect property ID for linking room types to properties during sync'","-- Add index on host_property_id for faster property-based lookups\nCREATE INDEX IF NOT EXISTS idx_unit_map_host_property \nON reserve.unit_map(host_property_id)","COMMENT ON INDEX reserve.idx_unit_map_host_property IS \n'Allows efficient lookup of units by host property ID during sync operations'","-- Add index on unit_type for filtering by room type category\nCREATE INDEX IF NOT EXISTS idx_unit_map_type \nON reserve.unit_map(unit_type) \nWHERE unit_type IS NOT NULL","-- Add composite index for property + unit lookups\nCREATE INDEX IF NOT EXISTS idx_unit_map_property_unit \nON reserve.unit_map(property_id, host_unit_id)","-- ============================================\n-- PROPERTIES_MAP ENHANCEMENTS\n-- ============================================\n\n-- Add partial index for active properties only (optimization)\nCREATE INDEX IF NOT EXISTS idx_properties_map_active_host \nON reserve.properties_map(host_property_id, is_active) \nWHERE is_active = true AND deleted_at IS NULL","COMMENT ON INDEX reserve.idx_properties_map_active_host IS \n'Optimizes sync lookups for active properties by host ID'","-- ============================================\n-- SYNC_JOBS ENHANCEMENTS\n-- ============================================\n\n-- Add index for querying by correlation_id\nCREATE INDEX IF NOT EXISTS idx_sync_jobs_correlation \nON reserve.sync_jobs USING GIN ((metadata -> 'correlation_id'))","COMMENT ON INDEX reserve.idx_sync_jobs_correlation IS \n'Enables querying sync jobs by correlation ID for distributed tracing'","-- Add index for failed jobs that need retry\nCREATE INDEX IF NOT EXISTS idx_sync_jobs_retry \nON reserve.sync_jobs(status, retry_count, updated_at) \nWHERE status IN ('failed', 'retrying') AND retry_count < max_retries","-- ============================================\n-- SYNC_LOGS ENHANCEMENTS\n-- ============================================\n\n-- Add index for action type filtering\nCREATE INDEX IF NOT EXISTS idx_sync_logs_action \nON reserve.sync_logs(action) \nWHERE action IN ('insert', 'update', 'delete')","COMMENT ON INDEX reserve.idx_sync_logs_action IS \n'Optimizes queries for specific sync actions'","-- ============================================\n-- EVENTS ENHANCEMENTS\n-- ============================================\n\n-- Add index for unprocessed events with priority\nCREATE INDEX IF NOT EXISTS idx_events_unprocessed_priority \nON reserve.events(created_at, severity) \nWHERE processed_at IS NULL","COMMENT ON INDEX reserve.idx_events_unprocessed_priority IS \n'Optimizes event processor queries for unprocessed events'","-- ============================================\n-- HELPER FUNCTIONS FOR SYNC\n-- ============================================\n\n-- Function: Get sync status summary\nCREATE OR REPLACE FUNCTION reserve.get_sync_summary(\n  p_job_id UUID\n)\nRETURNS TABLE (\n  total_records INTEGER,\n  inserted INTEGER,\n  updated INTEGER,\n  skipped INTEGER,\n  failed INTEGER,\n  orphaned INTEGER,\n  duration_ms INTEGER\n) AS $$\nBEGIN\n  RETURN QUERY\n  SELECT \n    sj.records_processed as total_records,\n    sj.records_inserted as inserted,\n    sj.records_updated as updated,\n    (SELECT COUNT(*)::INTEGER FROM reserve.sync_logs \n     WHERE sync_job_id = p_job_id AND action = 'skip') as skipped,\n    sj.records_failed as failed,\n    COALESCE((sj.metadata ->> 'orphaned_count')::INTEGER, 0) as orphaned,\n    sj.latency_ms as duration_ms\n  FROM reserve.sync_jobs sj\n  WHERE sj.id = p_job_id;\nEND;\n$$ LANGUAGE plpgsql SECURITY DEFINER","COMMENT ON FUNCTION reserve.get_sync_summary IS \n'Returns a summary of sync job results for monitoring dashboards'","-- Function: Retry failed sync job\nCREATE OR REPLACE FUNCTION reserve.retry_sync_job(\n  p_job_id UUID\n)\nRETURNS UUID AS $$\nDECLARE\n  v_new_job_id UUID;\n  v_job_record RECORD;\nBEGIN\n  -- Get original job details\n  SELECT * INTO v_job_record\n  FROM reserve.sync_jobs\n  WHERE id = p_job_id AND status = 'failed';\n  \n  IF NOT FOUND THEN\n    RAISE EXCEPTION 'Job not found or not in failed status';\n  END IF;\n  \n  -- Create new job as copy\n  INSERT INTO reserve.sync_jobs (\n    job_name,\n    job_type,\n    direction,\n    property_id,\n    city_id,\n    status,\n    priority,\n    max_retries,\n    metadata\n  ) VALUES (\n    v_job_record.job_name || '_retry_' || (v_job_record.retry_count + 1),\n    v_job_record.job_type,\n    v_job_record.direction,\n    v_job_record.property_id,\n    v_job_record.city_id,\n    'pending',\n    v_job_record.priority - 1, -- Higher priority on retry\n    v_job_record.max_retries,\n    jsonb_set(\n      v_job_record.metadata,\n      '{retried_from}',\n      to_jsonb(p_job_id)\n    )\n  )\n  RETURNING id INTO v_new_job_id;\n  \n  RETURN v_new_job_id;\nEND;\n$$ LANGUAGE plpgsql SECURITY DEFINER","COMMENT ON FUNCTION reserve.retry_sync_job IS \n'Creates a new sync job based on a failed job for retry purposes'","-- ============================================\n-- VIEWS FOR SYNC MONITORING\n-- ============================================\n\n-- View: Recent sync jobs with stats\nCREATE OR REPLACE VIEW reserve.sync_jobs_recent_view AS\nSELECT \n  sj.id,\n  sj.job_name,\n  sj.job_type,\n  sj.direction,\n  sj.status,\n  sj.records_processed,\n  sj.records_inserted,\n  sj.records_updated,\n  sj.records_failed,\n  sj.latency_ms,\n  sj.started_at,\n  sj.completed_at,\n  sj.created_at,\n  sj.metadata ->> 'correlation_id' as correlation_id,\n  p.name as property_name,\n  c.name as city_name\nFROM reserve.sync_jobs sj\nLEFT JOIN reserve.properties_map p ON sj.property_id = p.id\nLEFT JOIN reserve.cities c ON sj.city_id = c.id\nWHERE sj.created_at > NOW() - INTERVAL '7 days'\nORDER BY sj.created_at DESC","COMMENT ON VIEW reserve.sync_jobs_recent_view IS \n'Dashboard view of recent sync jobs with related property/city info'","-- View: Failed sync items requiring attention\nCREATE OR REPLACE VIEW reserve.sync_failures_view AS\nSELECT \n  sl.sync_job_id,\n  sj.job_name,\n  sj.job_type,\n  sl.record_id,\n  sl.record_type,\n  sl.message as error_message,\n  sl.details as error_details,\n  sl.created_at as failed_at\nFROM reserve.sync_logs sl\nJOIN reserve.sync_jobs sj ON sl.sync_job_id = sj.id\nWHERE sl.log_level = 'error'\n  AND sl.created_at > NOW() - INTERVAL '24 hours'\nORDER BY sl.created_at DESC","COMMENT ON VIEW reserve.sync_failures_view IS \n'View of recent sync failures for monitoring and alerting'","-- ============================================\n-- GRANT PERMISSIONS\n-- ============================================\n\n-- Grant execute on helper functions to service_role\nGRANT EXECUTE ON FUNCTION reserve.get_sync_summary TO service_role","GRANT EXECUTE ON FUNCTION reserve.retry_sync_job TO service_role","-- Grant select on views to authenticated users (for admin dashboards)\nGRANT SELECT ON reserve.sync_jobs_recent_view TO authenticated","GRANT SELECT ON reserve.sync_failures_view TO authenticated","-- Note: Views use the underlying table's RLS policies\n-- The base tables (sync_jobs, sync_logs) already have RLS enabled from migration 001"}	sync_support_schema	\N	\N	\N
20260213000003	{"-- ============================================\n-- RESERVE CONNECT - AVAILABILITY SEARCH SUPPORT\n-- SQL Helpers for efficient availability queries\n-- ============================================\n\n-- ============================================\n-- CONFIGURATION TABLE\n-- ============================================\n\nCREATE TABLE IF NOT EXISTS reserve.search_config (\n    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),\n    config_key VARCHAR(100) UNIQUE NOT NULL,\n    config_value JSONB NOT NULL,\n    description TEXT,\n    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),\n    updated_by UUID REFERENCES auth.users(id)\n)","-- Insert default configurations\nINSERT INTO reserve.search_config (config_key, config_value, description)\nVALUES \n    ('room_active_statuses', '[\\"active\\", \\"available\\", \\"clean\\", \\"ready\\"]', 'Room statuses considered available for booking'),\n    ('booking_active_statuses', '[\\"confirmed\\", \\"checked_in\\", \\"pending\\"]', 'Booking statuses that block availability'),\n    ('pricing_rule_active_statuses', '[\\"active\\", \\"published\\"]', 'Pricing rule statuses to apply'),\n    ('default_page_size', '20', 'Default number of results per page'),\n    ('max_page_size', '100', 'Maximum results per page allowed'),\n    ('max_nights', '365', 'Maximum nights allowed per search'),\n    ('min_nights', '1', 'Minimum nights required')\nON CONFLICT (config_key) DO NOTHING","COMMENT ON TABLE reserve.search_config IS 'Configuration for availability search behavior'","-- ============================================\n-- HELPER FUNCTION: Get Search Configuration\n-- ============================================\n\nCREATE OR REPLACE FUNCTION reserve.get_search_config(p_key TEXT)\nRETURNS JSONB AS $$\nDECLARE\n    v_value JSONB;\nBEGIN\n    SELECT config_value INTO v_value\n    FROM reserve.search_config\n    WHERE config_key = p_key;\n    \n    RETURN COALESCE(v_value, 'null'::JSONB);\nEND;\n$$ LANGUAGE plpgsql STABLE SECURITY DEFINER","COMMENT ON FUNCTION reserve.get_search_config IS 'Retrieves search configuration by key'","-- ============================================\n-- VIEW: Published Properties with City\n-- ============================================\n\nCREATE OR REPLACE VIEW reserve.published_properties_view AS\nSELECT \n    pm.id,\n    pm.host_property_id,\n    pm.city_id,\n    c.code as city_code,\n    c.name as city_name,\n    pm.name,\n    pm.slug,\n    pm.description,\n    pm.property_type,\n    pm.address_line_1,\n    pm.city as property_city,\n    pm.latitude,\n    pm.longitude,\n    pm.phone,\n    pm.email,\n    pm.amenities_cached,\n    pm.images_cached,\n    pm.rating_cached,\n    pm.review_count_cached\nFROM reserve.properties_map pm\nJOIN reserve.cities c ON pm.city_id = c.id\nWHERE pm.is_active = true \n  AND pm.is_published = true \n  AND pm.deleted_at IS NULL","COMMENT ON VIEW reserve.published_properties_view IS \n'Optimized view for availability search - only published, active properties'","-- ============================================\n-- VIEW: Active Room Types with Property Info\n-- ============================================\n\nCREATE OR REPLACE VIEW reserve.active_room_types_view AS\nSELECT \n    um.id,\n    um.host_unit_id,\n    um.host_property_id,\n    um.property_id,\n    pm.name as property_name,\n    pm.slug as property_slug,\n    pm.city_id,\n    pm.city_code,\n    um.name as room_type_name,\n    um.slug as room_type_slug,\n    um.max_occupancy,\n    um.base_capacity,\n    um.amenities_cached,\n    um.images_cached,\n    um.size_sqm\nFROM reserve.unit_map um\nJOIN reserve.published_properties_view pm ON um.property_id = pm.id\nWHERE um.unit_type = 'room_type'\n  AND um.is_active = true \n  AND um.deleted_at IS NULL","COMMENT ON VIEW reserve.active_room_types_view IS \n'Active room types joined with published property details for search'","-- ============================================\n-- FUNCTION: Record Search Funnel Event\n-- ============================================\n\nCREATE OR REPLACE FUNCTION reserve.record_search_funnel(\n    p_session_id TEXT,\n    p_visitor_id TEXT,\n    p_city_code TEXT,\n    p_check_in DATE,\n    p_check_out DATE,\n    p_guests INTEGER,\n    p_property_id UUID DEFAULT NULL,\n    p_search_params JSONB DEFAULT '{}',\n    p_results_count INTEGER DEFAULT 0\n)\nRETURNS UUID AS $$\nDECLARE\n    v_event_id UUID;\n    v_city_id UUID;\nBEGIN\n    -- Get city_id from code\n    SELECT id INTO v_city_id \n    FROM reserve.cities \n    WHERE code = p_city_code;\n    \n    INSERT INTO reserve.funnel_events (\n        session_id,\n        visitor_id,\n        stage,\n        event_name,\n        city_id,\n        property_id,\n        search_params,\n        metadata,\n        created_at\n    ) VALUES (\n        p_session_id,\n        p_visitor_id,\n        'search',\n        'availability_search',\n        v_city_id,\n        p_property_id,\n        jsonb_build_object(\n            'city_code', p_city_code,\n            'check_in', p_check_in,\n            'check_out', p_check_out,\n            'guests', p_guests,\n            'nights', (p_check_out - p_check_in),\n            'filters', p_search_params\n        ),\n        jsonb_build_object(\n            'results_count', p_results_count,\n            'has_filters', (p_property_id IS NOT NULL OR p_search_params != '{}')\n        ),\n        NOW()\n    )\n    RETURNING id INTO v_event_id;\n    \n    RETURN v_event_id;\nEND;\n$$ LANGUAGE plpgsql SECURITY DEFINER","COMMENT ON FUNCTION reserve.record_search_funnel IS \n'Records a search event in the funnel tracking table'","-- ============================================\n-- FUNCTION: Emit Search Event\n-- ============================================\n\nCREATE OR REPLACE FUNCTION reserve.emit_search_event(\n    p_correlation_id UUID,\n    p_actor_id TEXT,\n    p_city_code TEXT,\n    p_check_in DATE,\n    p_check_out DATE,\n    p_guests INTEGER,\n    p_results_count INTEGER,\n    p_property_id UUID DEFAULT NULL,\n    p_room_type_id UUID DEFAULT NULL,\n    p_duration_ms INTEGER DEFAULT 0\n)\nRETURNS UUID AS $$\nDECLARE\n    v_event_id UUID;\nBEGIN\n    INSERT INTO reserve.events (\n        event_name,\n        event_version,\n        severity,\n        actor_type,\n        actor_id,\n        entity_type,\n        entity_id,\n        payload,\n        correlation_id,\n        metadata,\n        created_at\n    ) VALUES (\n        'reserve.search.performed',\n        '1.0',\n        'info',\n        'edge_function',\n        p_actor_id,\n        'search',\n        p_correlation_id,\n        jsonb_build_object(\n            'city_code', p_city_code,\n            'check_in', p_check_in,\n            'check_out', p_check_out,\n            'guests', p_guests,\n            'nights', (p_check_out - p_check_in),\n            'results_count', p_results_count,\n            'filters', jsonb_build_object(\n                'property_id', p_property_id,\n                'room_type_id', p_room_type_id\n            ),\n            'duration_ms', p_duration_ms\n        ),\n        p_correlation_id,\n        '{}',\n        NOW()\n    )\n    RETURNING id INTO v_event_id;\n    \n    RETURN v_event_id;\nEND;\n$$ LANGUAGE plpgsql SECURITY DEFINER","COMMENT ON FUNCTION reserve.emit_search_event IS \n'Emits a search event to the event bus for downstream processing'","-- ============================================\n-- FUNCTION: Validate Search Parameters\n-- ============================================\n\nCREATE OR REPLACE FUNCTION reserve.validate_search_params(\n    p_city_code TEXT,\n    p_check_in DATE,\n    p_check_out DATE,\n    p_guests INTEGER,\n    p_property_id UUID DEFAULT NULL\n)\nRETURNS TABLE (\n    is_valid BOOLEAN,\n    error_message TEXT,\n    nights INTEGER,\n    city_exists BOOLEAN\n) AS $$\nDECLARE\n    v_nights INTEGER;\n    v_city_exists BOOLEAN;\n    v_min_nights INTEGER;\n    v_max_nights INTEGER;\nBEGIN\n    -- Get config values\n    v_min_nights := (reserve.get_search_config('min_nights'))::TEXT::INTEGER;\n    v_max_nights := (reserve.get_search_config('max_nights'))::TEXT::INTEGER;\n    \n    -- Check if city exists\n    SELECT EXISTS(\n        SELECT 1 FROM reserve.cities WHERE code = p_city_code AND is_active = true\n    ) INTO v_city_exists;\n    \n    -- Calculate nights\n    v_nights := p_check_out - p_check_in;\n    \n    -- Validation logic\n    IF NOT v_city_exists THEN\n        RETURN QUERY SELECT false, 'Invalid or inactive city code: ' || p_city_code, 0, false;\n        RETURN;\n    END IF;\n    \n    IF p_check_in >= p_check_out THEN\n        RETURN QUERY SELECT false, 'Check-out must be after check-in', 0, true;\n        RETURN;\n    END IF;\n    \n    IF p_check_in < CURRENT_DATE THEN\n        RETURN QUERY SELECT false, 'Check-in cannot be in the past', 0, true;\n        RETURN;\n    END IF;\n    \n    IF v_nights < v_min_nights THEN\n        RETURN QUERY SELECT false, \n            format('Minimum stay is %s nights', v_min_nights), \n            v_nights, \n            true;\n        RETURN;\n    END IF;\n    \n    IF v_nights > v_max_nights THEN\n        RETURN QUERY SELECT false, \n            format('Maximum stay is %s nights', v_max_nights), \n            v_nights, \n            true;\n        RETURN;\n    END IF;\n    \n    IF p_guests < 1 THEN\n        RETURN QUERY SELECT false, 'At least 1 guest required', v_nights, true;\n        RETURN;\n    END IF;\n    \n    -- Check if property exists when specified\n    IF p_property_id IS NOT NULL THEN\n        IF NOT EXISTS(\n            SELECT 1 FROM reserve.properties_map \n            WHERE id = p_property_id AND is_active = true AND is_published = true\n        ) THEN\n            RETURN QUERY SELECT false, 'Property not found or not available', v_nights, true;\n            RETURN;\n        END IF;\n    END IF;\n    \n    RETURN QUERY SELECT true, NULL::TEXT, v_nights, true;\nEND;\n$$ LANGUAGE plpgsql STABLE SECURITY DEFINER","COMMENT ON FUNCTION reserve.validate_search_params IS \n'Validates search parameters and returns validation result with calculated nights'","-- ============================================\n-- INDEXES FOR SEARCH PERFORMANCE\n-- ============================================\n\n-- Composite index for property + unit lookups (used heavily in search)\nCREATE INDEX IF NOT EXISTS idx_unit_map_search \nON reserve.unit_map(property_id, unit_type, is_active, deleted_at) \nWHERE unit_type = 'room_type' AND is_active = true AND deleted_at IS NULL","COMMENT ON INDEX reserve.idx_unit_map_search IS \n'Optimizes availability search queries by property and unit type'","-- Index for guest capacity filtering\nCREATE INDEX IF NOT EXISTS idx_unit_map_capacity \nON reserve.unit_map(max_occupancy, base_capacity) \nWHERE is_active = true AND deleted_at IS NULL","COMMENT ON INDEX reserve.idx_unit_map_capacity IS \n'Supports filtering room types by guest capacity'","-- Index for funnel events by session (analytics queries)\nCREATE INDEX IF NOT EXISTS idx_funnel_events_search \nON reserve.funnel_events(session_id, created_at DESC) \nWHERE stage = 'search'","COMMENT ON INDEX reserve.idx_funnel_events_search IS \n'Optimizes funnel analysis for search events'","-- ============================================\n-- GRANT PERMISSIONS\n-- ============================================\n\n-- Service role can execute all functions\nGRANT EXECUTE ON FUNCTION reserve.get_search_config TO service_role","GRANT EXECUTE ON FUNCTION reserve.record_search_funnel TO service_role","GRANT EXECUTE ON FUNCTION reserve.emit_search_event TO service_role","GRANT EXECUTE ON FUNCTION reserve.validate_search_params TO service_role","GRANT SELECT ON reserve.search_config TO service_role","GRANT SELECT ON reserve.published_properties_view TO service_role","GRANT SELECT ON reserve.active_room_types_view TO service_role","-- Allow edge function role (authenticated with specific claim)\nGRANT EXECUTE ON FUNCTION reserve.record_search_funnel TO authenticated","GRANT EXECUTE ON FUNCTION reserve.emit_search_event TO authenticated","GRANT EXECUTE ON FUNCTION reserve.validate_search_params TO authenticated","GRANT SELECT ON reserve.search_config TO authenticated","GRANT SELECT ON reserve.published_properties_view TO authenticated","GRANT SELECT ON reserve.active_room_types_view TO authenticated","GRANT INSERT ON reserve.funnel_events TO authenticated","GRANT INSERT ON reserve.events TO authenticated","-- Public can read published properties and active room types\nGRANT SELECT ON reserve.published_properties_view TO anon","GRANT SELECT ON reserve.active_room_types_view TO anon","-- ============================================\n-- RLS POLICIES FOR SEARCH CONFIG\n-- ============================================\n\nALTER TABLE reserve.search_config ENABLE ROW LEVEL SECURITY","CREATE POLICY service_role_search_config ON reserve.search_config\n    FOR ALL TO service_role USING (true) WITH CHECK (true)","CREATE POLICY public_read_search_config ON reserve.search_config\n    FOR SELECT TO anon USING (true)"}	availability_search_support	\N	\N	\N
20260213000004	{"-- Fix permissions for service_role on reserve schema\nGRANT USAGE ON SCHEMA reserve TO service_role","GRANT ALL ON ALL TABLES IN SCHEMA reserve TO service_role","GRANT ALL ON ALL SEQUENCES IN SCHEMA reserve TO service_role","GRANT ALL ON ALL FUNCTIONS IN SCHEMA reserve TO service_role","-- Ensure future tables also get permissions\nALTER DEFAULT PRIVILEGES IN SCHEMA reserve GRANT ALL ON TABLES TO service_role","ALTER DEFAULT PRIVILEGES IN SCHEMA reserve GRANT ALL ON SEQUENCES TO service_role","ALTER DEFAULT PRIVILEGES IN SCHEMA reserve GRANT ALL ON FUNCTIONS TO service_role"}	fix_permissions	\N	\N	\N
20260213000005	{"-- Drop existing public tables if they exist (from previous failed attempts)\nDROP TABLE IF EXISTS public.sync_jobs CASCADE","DROP TABLE IF EXISTS public.sync_logs CASCADE","DROP TABLE IF EXISTS public.events CASCADE","DROP TABLE IF EXISTS public.properties_map CASCADE","DROP TABLE IF EXISTS public.unit_map CASCADE","DROP TABLE IF EXISTS public.cities CASCADE","-- Create views in public schema as workaround for Edge Function schema access\nCREATE OR REPLACE VIEW public.cities AS\nSELECT * FROM reserve.cities","COMMENT ON VIEW public.cities IS 'Proxy view to reserve.cities for Edge Function access'","CREATE OR REPLACE VIEW public.properties_map AS\nSELECT * FROM reserve.properties_map","COMMENT ON VIEW public.properties_map IS 'Proxy view to reserve.properties_map for Edge Function access'","CREATE OR REPLACE VIEW public.unit_map AS\nSELECT * FROM reserve.unit_map","COMMENT ON VIEW public.unit_map IS 'Proxy view to reserve.unit_map for Edge Function access'","CREATE OR REPLACE VIEW public.sync_jobs AS\nSELECT * FROM reserve.sync_jobs","COMMENT ON VIEW public.sync_jobs IS 'Proxy view to reserve.sync_jobs for Edge Function access'","CREATE OR REPLACE VIEW public.sync_logs AS\nSELECT * FROM reserve.sync_logs","COMMENT ON VIEW public.sync_logs IS 'Proxy view to reserve.sync_logs for Edge Function access'","CREATE OR REPLACE VIEW public.events AS\nSELECT * FROM reserve.events","COMMENT ON VIEW public.events IS 'Proxy view to reserve.events for Edge Function access'","-- Grant permissions on views to service_role\nGRANT SELECT, INSERT, UPDATE ON public.cities TO service_role","GRANT SELECT, INSERT, UPDATE ON public.properties_map TO service_role","GRANT SELECT, INSERT, UPDATE ON public.unit_map TO service_role","GRANT SELECT, INSERT, UPDATE ON public.sync_jobs TO service_role","GRANT SELECT, INSERT ON public.sync_logs TO service_role","GRANT SELECT, INSERT ON public.events TO service_role","-- Grant usage on reserve schema sequences for inserts\nGRANT USAGE ON ALL SEQUENCES IN SCHEMA reserve TO service_role"}	create_public_views	\N	\N	\N
20260213000006	{"-- Create views needed by search_availability Edge Function\nCREATE OR REPLACE VIEW public.active_room_types_view AS\nSELECT \n    um.id,\n    um.host_unit_id,\n    um.host_property_id,\n    um.property_id,\n    pm.name as property_name,\n    pm.slug as property_slug,\n    pm.city_id,\n    c.code as city_code,\n    um.name as room_type_name,\n    um.slug as room_type_slug,\n    um.max_occupancy,\n    um.base_capacity,\n    um.amenities_cached,\n    um.images_cached,\n    um.size_sqm\nFROM reserve.unit_map um\nJOIN reserve.properties_map pm ON um.property_id = pm.id\nJOIN reserve.cities c ON pm.city_id = c.id\nWHERE um.unit_type = 'room_type'\n  AND um.is_active = true \n  AND um.deleted_at IS NULL\n  AND pm.is_active = true \n  AND pm.is_published = true \n  AND pm.deleted_at IS NULL","COMMENT ON VIEW public.active_room_types_view IS 'Active room types for search availability (proxy to reserve schema)'","CREATE OR REPLACE VIEW public.published_properties_view AS\nSELECT \n    pm.id,\n    pm.host_property_id,\n    pm.city_id,\n    c.code as city_code,\n    c.name as city_name,\n    pm.name,\n    pm.slug,\n    pm.description,\n    pm.property_type,\n    pm.address_line_1,\n    pm.city as property_city,\n    pm.latitude,\n    pm.longitude,\n    pm.phone,\n    pm.email,\n    pm.amenities_cached,\n    pm.images_cached,\n    pm.rating_cached,\n    pm.review_count_cached\nFROM reserve.properties_map pm\nJOIN reserve.cities c ON pm.city_id = c.id\nWHERE pm.is_active = true \n  AND pm.is_published = true \n  AND pm.deleted_at IS NULL","COMMENT ON VIEW public.published_properties_view IS 'Published properties for search (proxy to reserve schema)'","-- Grant permissions\nGRANT SELECT ON public.active_room_types_view TO anon","GRANT SELECT ON public.active_room_types_view TO authenticated","GRANT SELECT ON public.active_room_types_view TO service_role","GRANT SELECT ON public.published_properties_view TO anon","GRANT SELECT ON public.published_properties_view TO authenticated","GRANT SELECT ON public.published_properties_view TO service_role"}	search_views	\N	\N	\N
20260213000007	{"-- ============================================\n-- RESERVE CONNECT - SEARCH AVAILABILITY FIX\n-- SQL patch for reserve.sync_jobs (if needed)\n-- No changes needed for Host pricing_rules - those are in Host schema\n-- ============================================\n\n-- Note: The date_from/date_to columns in reserve.sync_jobs are for sync job date ranges\n-- These are different from Host pricing_rules.start_date/end_date\n-- No migration needed for this file\n\n-- The Edge Function code has been updated to use:\n-- - pricing_rules.start_date (not date_from)\n-- - pricing_rules.end_date (not date_to)\n-- - Case-insensitive status filtering for 'active'\n\n-- Verify the sync_jobs table has correct columns:\n-- SELECT column_name FROM information_schema.columns \n-- WHERE table_schema = 'reserve' AND table_name = 'sync_jobs'"}	search_availability_fix	\N	\N	\N
20260214000001	{"-- ============================================\n-- RESERVE CONNECT - PRODUCTION READINESS MIGRATION\n-- Date: 2026-02-14\n-- Purpose: Public views, RLS hardening, grants for production\n-- ============================================\n\n-- ============================================\n-- PART 1: DROP EXISTING PUBLIC VIEWS (clean slate)\n-- ============================================\nDROP VIEW IF EXISTS public.published_cities_view CASCADE","DROP VIEW IF EXISTS public.published_properties_view CASCADE","DROP VIEW IF EXISTS public.published_units_view CASCADE","DROP VIEW IF EXISTS public.active_room_types_view CASCADE","-- Drop existing proxy views if any\nDROP VIEW IF EXISTS public.properties_map CASCADE","DROP VIEW IF EXISTS public.unit_map CASCADE","DROP VIEW IF EXISTS public.sync_jobs CASCADE","DROP VIEW IF EXISTS public.sync_logs CASCADE","DROP VIEW IF EXISTS public.events CASCADE","DROP VIEW IF EXISTS public.cities CASCADE","-- ============================================\n-- PART 2: PUBLIC READ-ONLY VIEWS FOR WEBSITE\n-- ============================================\n\n-- View 1: Published Cities\nCREATE OR REPLACE VIEW public.published_cities_view AS\nSELECT \n    c.id as city_id,\n    c.code as city_code,\n    c.name as city_name,\n    c.state_province,\n    c.country,\n    c.timezone,\n    c.currency,\n    (SELECT COUNT(*) \n     FROM reserve.properties_map pm \n     WHERE pm.city_id = c.id \n       AND pm.is_active = true \n       AND pm.is_published = true \n       AND pm.deleted_at IS NULL) as properties_count,\n    c.updated_at\nFROM reserve.cities c\nWHERE c.is_active = true","COMMENT ON VIEW public.published_cities_view IS 'Public read-only view of active cities with property counts'","-- View 2: Published Properties\nCREATE OR REPLACE VIEW public.published_properties_view AS\nSELECT \n    pm.id as property_id,\n    pm.host_property_id,\n    c.code as city_code,\n    pm.name,\n    pm.slug,\n    pm.address_line_1 as address,\n    pm.latitude as lat,\n    pm.longitude as lng,\n    CASE \n        WHEN pm.images_cached IS NOT NULL AND jsonb_array_length(pm.images_cached) > 0\n        THEN pm.images_cached->0->>'url'\n        ELSE NULL\n    END as primary_image_url,\n    pm.updated_at\nFROM reserve.properties_map pm\nJOIN reserve.cities c ON pm.city_id = c.id\nWHERE pm.is_active = true \n  AND pm.is_published = true \n  AND pm.deleted_at IS NULL\n  AND c.is_active = true","COMMENT ON VIEW public.published_properties_view IS 'Public read-only view of published properties'","-- View 3: Published Units (Room Types)\nCREATE OR REPLACE VIEW public.published_units_view AS\nSELECT \n    um.id as unit_id,\n    um.host_unit_id,\n    um.host_property_id,\n    um.property_id,\n    um.unit_type,\n    um.name,\n    um.max_occupancy as capacity,\n    um.amenities_cached as amenities,\n    um.images_cached as images,\n    um.is_active as status,\n    um.updated_at\nFROM reserve.unit_map um\nJOIN reserve.properties_map pm ON um.property_id = pm.id\nJOIN reserve.cities c ON pm.city_id = c.id\nWHERE um.is_active = true \n  AND um.deleted_at IS NULL\n  AND pm.is_active = true \n  AND pm.is_published = true \n  AND pm.deleted_at IS NULL\n  AND c.is_active = true","COMMENT ON VIEW public.published_units_view IS 'Public read-only view of active room types/units'","-- View 4: Active Room Types (for search_availability Edge Function)\nCREATE OR REPLACE VIEW public.active_room_types_view AS\nSELECT \n    um.id,\n    um.host_unit_id as host_room_type_id,\n    um.host_property_id,\n    um.property_id,\n    pm.name as property_name,\n    pm.slug as property_slug,\n    pm.city_id,\n    c.code as city_code,\n    um.name as room_type_name,\n    um.slug as room_type_slug,\n    um.max_occupancy,\n    um.base_capacity,\n    um.amenities_cached as amenities_cached,\n    um.images_cached as images_cached,\n    um.size_sqm\nFROM reserve.unit_map um\nJOIN reserve.properties_map pm ON um.property_id = pm.id\nJOIN reserve.cities c ON pm.city_id = c.id\nWHERE um.is_active = true \n  AND um.deleted_at IS NULL\n  AND pm.is_active = true \n  AND pm.is_published = true \n  AND pm.deleted_at IS NULL\n  AND c.is_active = true","COMMENT ON VIEW public.active_room_types_view IS 'Active room types for search_availability Edge Function'","-- ============================================\n-- PART 3: PROXY VIEWS FOR EDGE FUNCTIONS (schema cache compatibility)\n-- ============================================\n\nCREATE OR REPLACE VIEW public.cities AS SELECT * FROM reserve.cities","CREATE OR REPLACE VIEW public.properties_map AS SELECT * FROM reserve.properties_map","CREATE OR REPLACE VIEW public.unit_map AS SELECT * FROM reserve.unit_map","CREATE OR REPLACE VIEW public.sync_jobs AS SELECT * FROM reserve.sync_jobs","CREATE OR REPLACE VIEW public.sync_logs AS SELECT * FROM reserve.sync_logs","CREATE OR REPLACE VIEW public.events AS SELECT * FROM reserve.events","COMMENT ON VIEW public.cities IS 'Proxy view to reserve.cities for Edge Function compatibility'","COMMENT ON VIEW public.properties_map IS 'Proxy view to reserve.properties_map for Edge Function compatibility'","COMMENT ON VIEW public.unit_map IS 'Proxy view to reserve.unit_map for Edge Function compatibility'","COMMENT ON VIEW public.sync_jobs IS 'Proxy view to reserve.sync_jobs for Edge Function compatibility'","COMMENT ON VIEW public.sync_logs IS 'Proxy view to reserve.sync_logs for Edge Function compatibility'","COMMENT ON VIEW public.events IS 'Proxy view to reserve.events for Edge Function compatibility'","-- ============================================\n-- PART 4: PUBLIC HELPER FUNCTIONS\n-- ============================================\n\n-- Function 1: Get published cities\nCREATE OR REPLACE FUNCTION public.get_published_cities()\nRETURNS TABLE (\n    city_id UUID,\n    city_code VARCHAR(10),\n    city_name VARCHAR(100),\n    state_province VARCHAR(100),\n    country VARCHAR(100),\n    timezone VARCHAR(50),\n    currency VARCHAR(3),\n    properties_count BIGINT,\n    updated_at TIMESTAMPTZ\n) \nSECURITY DEFINER\nSET search_path = public\nAS $$\nBEGIN\n    RETURN QUERY\n    SELECT \n        pcv.city_id,\n        pcv.city_code,\n        pcv.city_name,\n        pcv.state_province,\n        pcv.country,\n        pcv.timezone,\n        pcv.currency,\n        pcv.properties_count,\n        pcv.updated_at\n    FROM public.published_cities_view pcv\n    ORDER BY pcv.city_name;\nEND;\n$$ LANGUAGE plpgsql","COMMENT ON FUNCTION public.get_published_cities() IS 'Public function to get all active cities with property counts'","-- Function 2: Get properties by city\nCREATE OR REPLACE FUNCTION public.get_properties_by_city(p_city_code TEXT)\nRETURNS TABLE (\n    property_id UUID,\n    host_property_id UUID,\n    city_code VARCHAR(10),\n    name VARCHAR(200),\n    slug VARCHAR(200),\n    address VARCHAR(255),\n    lat DECIMAL(10, 8),\n    lng DECIMAL(11, 8),\n    primary_image_url TEXT,\n    updated_at TIMESTAMPTZ\n)\nSECURITY DEFINER\nSET search_path = public\nAS $$\nBEGIN\n    RETURN QUERY\n    SELECT \n        ppv.property_id,\n        ppv.host_property_id,\n        ppv.city_code,\n        ppv.name,\n        ppv.slug,\n        ppv.address,\n        ppv.lat,\n        ppv.lng,\n        ppv.primary_image_url,\n        ppv.updated_at\n    FROM public.published_properties_view ppv\n    WHERE ppv.city_code = p_city_code\n    ORDER BY ppv.name;\nEND;\n$$ LANGUAGE plpgsql","COMMENT ON FUNCTION public.get_properties_by_city(TEXT) IS 'Public function to get properties by city code'","-- Function 3: Get room types by property\nCREATE OR REPLACE FUNCTION public.get_room_types_by_property(p_property_id UUID)\nRETURNS TABLE (\n    unit_id UUID,\n    host_unit_id UUID,\n    host_property_id UUID,\n    property_id UUID,\n    unit_type VARCHAR(50),\n    name VARCHAR(200),\n    capacity INTEGER,\n    amenities JSONB,\n    images JSONB,\n    status BOOLEAN,\n    updated_at TIMESTAMPTZ\n)\nSECURITY DEFINER\nSET search_path = public\nAS $$\nBEGIN\n    RETURN QUERY\n    SELECT \n        puv.unit_id,\n        puv.host_unit_id,\n        puv.host_property_id,\n        puv.property_id,\n        puv.unit_type,\n        puv.name,\n        puv.capacity,\n        puv.amenities,\n        puv.images,\n        puv.status,\n        puv.updated_at\n    FROM public.published_units_view puv\n    WHERE puv.property_id = p_property_id\n    ORDER BY puv.name;\nEND;\n$$ LANGUAGE plpgsql","COMMENT ON FUNCTION public.get_room_types_by_property(UUID) IS 'Public function to get room types by property ID'","-- ============================================\n-- PART 5: RLS HARDENING\n-- ============================================\n\n-- Enable RLS on all reserve tables\nALTER TABLE IF EXISTS reserve.cities FORCE ROW LEVEL SECURITY","ALTER TABLE IF EXISTS reserve.properties_map FORCE ROW LEVEL SECURITY","ALTER TABLE IF EXISTS reserve.unit_map FORCE ROW LEVEL SECURITY","ALTER TABLE IF EXISTS reserve.rate_plans FORCE ROW LEVEL SECURITY","ALTER TABLE IF EXISTS reserve.availability_calendar FORCE ROW LEVEL SECURITY","ALTER TABLE IF EXISTS reserve.travelers FORCE ROW LEVEL SECURITY","ALTER TABLE IF EXISTS reserve.reservations FORCE ROW LEVEL SECURITY","ALTER TABLE IF EXISTS reserve.sync_jobs FORCE ROW LEVEL SECURITY","ALTER TABLE IF EXISTS reserve.sync_logs FORCE ROW LEVEL SECURITY","ALTER TABLE IF EXISTS reserve.events FORCE ROW LEVEL SECURITY","ALTER TABLE IF EXISTS reserve.audit_logs FORCE ROW LEVEL SECURITY","ALTER TABLE IF EXISTS reserve.funnel_events FORCE ROW LEVEL SECURITY","ALTER TABLE IF EXISTS reserve.kpi_daily_snapshots FORCE ROW LEVEL SECURITY","-- Enable RLS on tables underlying proxy views\nALTER TABLE reserve.cities ENABLE ROW LEVEL SECURITY","ALTER TABLE reserve.properties_map ENABLE ROW LEVEL SECURITY","ALTER TABLE reserve.unit_map ENABLE ROW LEVEL SECURITY","ALTER TABLE reserve.sync_jobs ENABLE ROW LEVEL SECURITY","ALTER TABLE reserve.sync_logs ENABLE ROW LEVEL SECURITY","ALTER TABLE reserve.events ENABLE ROW LEVEL SECURITY","-- ============================================\n-- PART 6: SERVICE ROLE POLICIES (Edge Functions)\n-- ============================================\n\n-- Drop existing policies to avoid conflicts\nDROP POLICY IF EXISTS service_role_all_cities ON reserve.cities","DROP POLICY IF EXISTS service_role_all_properties ON reserve.properties_map","DROP POLICY IF EXISTS service_role_all_units ON reserve.unit_map","DROP POLICY IF EXISTS service_role_all_rate_plans ON reserve.rate_plans","DROP POLICY IF EXISTS service_role_all_availability ON reserve.availability_calendar","DROP POLICY IF EXISTS service_role_all_travelers ON reserve.travelers","DROP POLICY IF EXISTS service_role_all_reservations ON reserve.reservations","DROP POLICY IF EXISTS service_role_all_sync_jobs ON reserve.sync_jobs","DROP POLICY IF EXISTS service_role_all_sync_logs ON reserve.sync_logs","DROP POLICY IF EXISTS service_role_all_events ON reserve.events","DROP POLICY IF EXISTS service_role_all_audit_logs ON reserve.audit_logs","DROP POLICY IF EXISTS service_role_all_funnel ON reserve.funnel_events","DROP POLICY IF EXISTS service_role_all_kpi ON reserve.kpi_daily_snapshots","-- Create service_role policies\nCREATE POLICY service_role_all_cities ON reserve.cities FOR ALL TO service_role USING (true) WITH CHECK (true)","CREATE POLICY service_role_all_properties ON reserve.properties_map FOR ALL TO service_role USING (true) WITH CHECK (true)","CREATE POLICY service_role_all_units ON reserve.unit_map FOR ALL TO service_role USING (true) WITH CHECK (true)","CREATE POLICY service_role_all_rate_plans ON reserve.rate_plans FOR ALL TO service_role USING (true) WITH CHECK (true)","CREATE POLICY service_role_all_availability ON reserve.availability_calendar FOR ALL TO service_role USING (true) WITH CHECK (true)","CREATE POLICY service_role_all_travelers ON reserve.travelers FOR ALL TO service_role USING (true) WITH CHECK (true)","CREATE POLICY service_role_all_reservations ON reserve.reservations FOR ALL TO service_role USING (true) WITH CHECK (true)","CREATE POLICY service_role_all_sync_jobs ON reserve.sync_jobs FOR ALL TO service_role USING (true) WITH CHECK (true)","CREATE POLICY service_role_all_sync_logs ON reserve.sync_logs FOR ALL TO service_role USING (true) WITH CHECK (true)","CREATE POLICY service_role_all_events ON reserve.events FOR ALL TO service_role USING (true) WITH CHECK (true)","CREATE POLICY service_role_all_audit_logs ON reserve.audit_logs FOR ALL TO service_role USING (true) WITH CHECK (true)","CREATE POLICY service_role_all_funnel ON reserve.funnel_events FOR ALL TO service_role USING (true) WITH CHECK (true)","CREATE POLICY service_role_all_kpi ON reserve.kpi_daily_snapshots FOR ALL TO service_role USING (true) WITH CHECK (true)","-- ============================================\n-- PART 7: PUBLIC (ANON) POLICIES\n-- ============================================\n\n-- Drop existing public policies\nDROP POLICY IF EXISTS public_read_cities ON reserve.cities","DROP POLICY IF EXISTS public_read_properties ON reserve.properties_map","DROP POLICY IF EXISTS public_read_units ON reserve.unit_map","-- Public can only read active/published data\nCREATE POLICY public_read_cities ON reserve.cities\n    FOR SELECT TO anon USING (is_active = true)","CREATE POLICY public_read_properties ON reserve.properties_map\n    FOR SELECT TO anon USING (is_active = true AND is_published = true AND deleted_at IS NULL)","CREATE POLICY public_read_units ON reserve.unit_map\n    FOR SELECT TO anon USING (is_active = true AND deleted_at IS NULL)","-- ============================================\n-- PART 8: GRANTS\n-- ============================================\n\n-- Grant usage on schemas\nGRANT USAGE ON SCHEMA reserve TO service_role","GRANT USAGE ON SCHEMA reserve TO authenticated","GRANT USAGE ON SCHEMA public TO anon","GRANT USAGE ON SCHEMA public TO authenticated","GRANT USAGE ON SCHEMA public TO service_role","-- Grant on public views to anon (public website)\nGRANT SELECT ON public.published_cities_view TO anon","GRANT SELECT ON public.published_properties_view TO anon","GRANT SELECT ON public.published_units_view TO anon","GRANT SELECT ON public.active_room_types_view TO anon","-- Grant on public views to authenticated\nGRANT SELECT ON public.published_cities_view TO authenticated","GRANT SELECT ON public.published_properties_view TO authenticated","GRANT SELECT ON public.published_units_view TO authenticated","GRANT SELECT ON public.active_room_types_view TO authenticated","-- Grant on proxy views to service_role (Edge Functions)\nGRANT SELECT, INSERT, UPDATE ON public.cities TO service_role","GRANT SELECT, INSERT, UPDATE ON public.properties_map TO service_role","GRANT SELECT, INSERT, UPDATE ON public.unit_map TO service_role","GRANT SELECT, INSERT ON public.sync_jobs TO service_role","GRANT SELECT, INSERT ON public.sync_logs TO service_role","GRANT SELECT, INSERT ON public.events TO service_role","-- Grant execute on helper functions\nGRANT EXECUTE ON FUNCTION public.get_published_cities() TO anon","GRANT EXECUTE ON FUNCTION public.get_published_cities() TO authenticated","GRANT EXECUTE ON FUNCTION public.get_properties_by_city(TEXT) TO anon","GRANT EXECUTE ON FUNCTION public.get_properties_by_city(TEXT) TO authenticated","GRANT EXECUTE ON FUNCTION public.get_room_types_by_property(UUID) TO anon","GRANT EXECUTE ON FUNCTION public.get_room_types_by_property(UUID) TO authenticated","-- Grant full access to reserve schema for service_role\nGRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA reserve TO service_role","GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA reserve TO service_role","GRANT ALL PRIVILEGES ON ALL FUNCTIONS IN SCHEMA reserve TO service_role","-- Set default privileges for future objects\nALTER DEFAULT PRIVILEGES IN SCHEMA reserve GRANT ALL ON TABLES TO service_role","ALTER DEFAULT PRIVILEGES IN SCHEMA reserve GRANT ALL ON SEQUENCES TO service_role","ALTER DEFAULT PRIVILEGES IN SCHEMA reserve GRANT ALL ON FUNCTIONS TO service_role","-- ============================================\n-- PART 9: PERFORMANCE INDEXES\n-- ============================================\n\n-- Index for properties by city, published status\nCREATE INDEX IF NOT EXISTS idx_properties_map_city_published \nON reserve.properties_map(city_id, is_published, is_active) \nWHERE is_published = true AND is_active = true AND deleted_at IS NULL","-- Index for units by host_property_id\nCREATE INDEX IF NOT EXISTS idx_unit_map_host_property_unit \nON reserve.unit_map(host_property_id, unit_type, is_active, max_occupancy) \nWHERE is_active = true AND deleted_at IS NULL","-- Index for sync_jobs by status and date\nCREATE INDEX IF NOT EXISTS idx_sync_jobs_status_created \nON reserve.sync_jobs(status, created_at DESC)","-- Index for sync_logs by action and date\nCREATE INDEX IF NOT EXISTS idx_sync_logs_action_created \nON reserve.sync_logs(action, created_at DESC)","-- Index for events by processed status\nCREATE INDEX IF NOT EXISTS idx_events_unprocessed \nON reserve.events(created_at) \nWHERE processed_at IS NULL","-- Index for properties slug lookups\nCREATE INDEX IF NOT EXISTS idx_properties_map_slug_lookup \nON reserve.properties_map(slug, is_published, is_active) \nWHERE is_published = true AND is_active = true AND deleted_at IS NULL","-- Index for units by property\nCREATE INDEX IF NOT EXISTS idx_unit_map_property_active \nON reserve.unit_map(property_id, is_active, deleted_at) \nWHERE is_active = true AND deleted_at IS NULL","-- ============================================\n-- MIGRATION COMPLETION\n-- ============================================\n\nDO $$\nBEGIN\n    RAISE NOTICE '========================================';\n    RAISE NOTICE 'PRODUCTION READINESS MIGRATION COMPLETE';\n    RAISE NOTICE '========================================';\n    RAISE NOTICE 'Public Views: 4 created';\n    RAISE NOTICE 'Proxy Views: 6 created';\n    RAISE NOTICE 'Helper Functions: 3 created';\n    RAISE NOTICE 'RLS: Enabled on all reserve tables';\n    RAISE NOTICE 'Grants: Configured for anon, authenticated, service_role';\n    RAISE NOTICE 'Indexes: 8 created/verified';\n    RAISE NOTICE '========================================';\nEND $$"}	production_readiness_public_views	\N	\N	\N
20260214000002	{"-- ============================================\n-- RESERVE CONNECT - FINAL PRODUCTION MIGRATION\n-- Date: 2026-02-14\n-- Purpose: Complete production setup with security, performance, storage\n-- ============================================\n\n-- ============================================\n-- PART 1: ENSURE RESERVE SCHEMA TABLES EXIST\n-- ============================================\n\n-- Cities table\nCREATE TABLE IF NOT EXISTS reserve.cities (\n    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),\n    code VARCHAR(10) UNIQUE NOT NULL,\n    name VARCHAR(100) NOT NULL,\n    state_province VARCHAR(100),\n    country VARCHAR(100) NOT NULL DEFAULT 'Brazil',\n    timezone VARCHAR(50) NOT NULL DEFAULT 'America/Sao_Paulo',\n    currency VARCHAR(3) NOT NULL DEFAULT 'BRL',\n    is_active BOOLEAN NOT NULL DEFAULT true,\n    metadata JSONB DEFAULT '{}',\n    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),\n    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()\n)","-- Properties map table\nCREATE TABLE IF NOT EXISTS reserve.properties_map (\n    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),\n    host_property_id UUID NOT NULL,\n    city_id UUID NOT NULL REFERENCES reserve.cities(id),\n    name VARCHAR(200) NOT NULL,\n    slug VARCHAR(200) UNIQUE NOT NULL,\n    description TEXT,\n    property_type VARCHAR(50),\n    address_line_1 VARCHAR(255),\n    address_line_2 VARCHAR(255),\n    city VARCHAR(100),\n    state_province VARCHAR(100),\n    postal_code VARCHAR(20),\n    country VARCHAR(100) DEFAULT 'Brazil',\n    latitude DECIMAL(10, 8),\n    longitude DECIMAL(11, 8),\n    phone VARCHAR(50),\n    email VARCHAR(255),\n    website VARCHAR(500),\n    amenities_cached JSONB DEFAULT '[]',\n    images_cached JSONB DEFAULT '[]',\n    rating_cached DECIMAL(2, 1),\n    review_count_cached INTEGER DEFAULT 0,\n    host_last_synced_at TIMESTAMPTZ,\n    host_data_hash VARCHAR(64),\n    is_active BOOLEAN NOT NULL DEFAULT true,\n    is_published BOOLEAN NOT NULL DEFAULT false,\n    deleted_at TIMESTAMPTZ,\n    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),\n    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),\n    CONSTRAINT valid_coordinates CHECK (\n        (latitude IS NULL OR (latitude >= -90 AND latitude <= 90)) AND\n        (longitude IS NULL OR (longitude >= -180 AND longitude <= 180))\n    ),\n    CONSTRAINT valid_rating CHECK (rating_cached IS NULL OR (rating_cached >= 0 AND rating_cached <= 5))\n)","-- Unit map table\nCREATE TABLE IF NOT EXISTS reserve.unit_map (\n    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),\n    host_unit_id UUID NOT NULL,\n    property_id UUID NOT NULL REFERENCES reserve.properties_map(id) ON DELETE CASCADE,\n    host_property_id UUID,\n    name VARCHAR(200) NOT NULL,\n    slug VARCHAR(200) NOT NULL,\n    unit_type VARCHAR(50),\n    description TEXT,\n    max_occupancy INTEGER NOT NULL DEFAULT 2,\n    base_capacity INTEGER NOT NULL DEFAULT 2,\n    amenities_cached JSONB DEFAULT '[]',\n    images_cached JSONB DEFAULT '[]',\n    size_sqm INTEGER,\n    bed_configuration JSONB DEFAULT '[]',\n    host_last_synced_at TIMESTAMPTZ,\n    host_data_hash VARCHAR(64),\n    is_active BOOLEAN NOT NULL DEFAULT true,\n    deleted_at TIMESTAMPTZ,\n    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),\n    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),\n    CONSTRAINT valid_occupancy CHECK (max_occupancy >= base_capacity AND base_capacity > 0),\n    CONSTRAINT unique_unit_slug_per_property UNIQUE (property_id, slug)\n)","-- Sync jobs table\nCREATE TABLE IF NOT EXISTS reserve.sync_jobs (\n    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),\n    job_name VARCHAR(100) NOT NULL,\n    job_type VARCHAR(50) NOT NULL,\n    direction VARCHAR(50) NOT NULL DEFAULT 'pull_from_host',\n    property_id UUID REFERENCES reserve.properties_map(id),\n    city_id UUID REFERENCES reserve.cities(id),\n    date_from DATE,\n    date_to DATE,\n    status VARCHAR(50) NOT NULL DEFAULT 'pending',\n    priority INTEGER NOT NULL DEFAULT 5,\n    started_at TIMESTAMPTZ,\n    completed_at TIMESTAMPTZ,\n    failed_at TIMESTAMPTZ,\n    error_message TEXT,\n    error_details JSONB,\n    retry_count INTEGER NOT NULL DEFAULT 0,\n    max_retries INTEGER NOT NULL DEFAULT 3,\n    records_processed INTEGER,\n    records_inserted INTEGER,\n    records_updated INTEGER,\n    records_failed INTEGER,\n    latency_ms INTEGER,\n    source_payload_hash VARCHAR(64),\n    target_payload_hash VARCHAR(64),\n    metadata JSONB DEFAULT '{}',\n    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),\n    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()\n)","-- Sync logs table\nCREATE TABLE IF NOT EXISTS reserve.sync_logs (\n    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),\n    sync_job_id UUID REFERENCES reserve.sync_jobs(id) ON DELETE CASCADE,\n    log_level VARCHAR(20) NOT NULL DEFAULT 'info',\n    message TEXT NOT NULL,\n    details JSONB,\n    record_id UUID,\n    record_type VARCHAR(50),\n    action VARCHAR(50),\n    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()\n)","-- Events table\nCREATE TABLE IF NOT EXISTS reserve.events (\n    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),\n    event_name VARCHAR(100) NOT NULL,\n    event_version VARCHAR(10) NOT NULL DEFAULT '1.0',\n    severity VARCHAR(20) NOT NULL DEFAULT 'info',\n    actor_type VARCHAR(50) NOT NULL,\n    actor_id VARCHAR(255),\n    entity_type VARCHAR(50) NOT NULL,\n    entity_id UUID NOT NULL,\n    payload JSONB NOT NULL DEFAULT '{}',\n    payload_schema VARCHAR(100),\n    processed_at TIMESTAMPTZ,\n    processor_id VARCHAR(100),\n    error_message TEXT,\n    retry_count INTEGER NOT NULL DEFAULT 0,\n    correlation_id UUID,\n    causation_id UUID,\n    metadata JSONB DEFAULT '{}',\n    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()\n)","-- Insert pilot city if not exists\nINSERT INTO reserve.cities (code, name, state_province, timezone) \nVALUES ('URB', 'Urubici', 'Santa Catarina', 'America/Sao_Paulo')\nON CONFLICT (code) DO NOTHING","-- ============================================\n-- PART 2: PERFORMANCE INDEXES\n-- ============================================\n\n-- Cities indexes\nCREATE INDEX IF NOT EXISTS idx_cities_code ON reserve.cities(code)","CREATE INDEX IF NOT EXISTS idx_cities_active ON reserve.cities(is_active) WHERE is_active = true","-- Properties map indexes\nCREATE INDEX IF NOT EXISTS idx_properties_map_host_id ON reserve.properties_map(host_property_id)","CREATE INDEX IF NOT EXISTS idx_properties_map_city ON reserve.properties_map(city_id)","CREATE INDEX IF NOT EXISTS idx_properties_map_slug ON reserve.properties_map(slug)","CREATE INDEX IF NOT EXISTS idx_properties_map_active_published ON reserve.properties_map(is_active, is_published, deleted_at) \n    WHERE is_active = true AND is_published = true AND deleted_at IS NULL","CREATE INDEX IF NOT EXISTS idx_properties_map_city_published ON reserve.properties_map(city_id, is_published, is_active) \n    WHERE is_published = true AND is_active = true AND deleted_at IS NULL","-- Unit map indexes\nCREATE INDEX IF NOT EXISTS idx_unit_map_host_id ON reserve.unit_map(host_unit_id)","CREATE INDEX IF NOT EXISTS idx_unit_map_property ON reserve.unit_map(property_id)","CREATE INDEX IF NOT EXISTS idx_unit_map_host_property ON reserve.unit_map(host_property_id)","CREATE INDEX IF NOT EXISTS idx_unit_map_active ON reserve.unit_map(is_active, deleted_at) \n    WHERE is_active = true AND deleted_at IS NULL","CREATE INDEX IF NOT EXISTS idx_unit_map_host_property_unit ON reserve.unit_map(host_property_id, unit_type, is_active, max_occupancy) \n    WHERE is_active = true AND deleted_at IS NULL","CREATE INDEX IF NOT EXISTS idx_unit_map_property_active ON reserve.unit_map(property_id, is_active, deleted_at) \n    WHERE is_active = true AND deleted_at IS NULL","-- Sync jobs indexes\nCREATE INDEX IF NOT EXISTS idx_sync_jobs_status ON reserve.sync_jobs(status)","CREATE INDEX IF NOT EXISTS idx_sync_jobs_type ON reserve.sync_jobs(job_type)","CREATE INDEX IF NOT EXISTS idx_sync_jobs_property ON reserve.sync_jobs(property_id) WHERE property_id IS NOT NULL","CREATE INDEX IF NOT EXISTS idx_sync_jobs_pending ON reserve.sync_jobs(status, priority, created_at) \n    WHERE status IN ('pending', 'retrying')","CREATE INDEX IF NOT EXISTS idx_sync_jobs_created ON reserve.sync_jobs(created_at DESC)","CREATE INDEX IF NOT EXISTS idx_sync_jobs_status_created ON reserve.sync_jobs(status, created_at DESC)","-- Sync logs indexes\nCREATE INDEX IF NOT EXISTS idx_sync_logs_job ON reserve.sync_logs(sync_job_id)","CREATE INDEX IF NOT EXISTS idx_sync_logs_level ON reserve.sync_logs(log_level)","CREATE INDEX IF NOT EXISTS idx_sync_logs_created ON reserve.sync_logs(created_at DESC)","CREATE INDEX IF NOT EXISTS idx_sync_logs_action_created ON reserve.sync_logs(action, created_at DESC)","CREATE INDEX IF NOT EXISTS idx_sync_logs_record ON reserve.sync_logs(record_type, record_id) WHERE record_id IS NOT NULL","-- Events indexes\nCREATE INDEX IF NOT EXISTS idx_events_name ON reserve.events(event_name)","CREATE INDEX IF NOT EXISTS idx_events_entity ON reserve.events(entity_type, entity_id)","CREATE INDEX IF NOT EXISTS idx_events_actor ON reserve.events(actor_type, actor_id) WHERE actor_id IS NOT NULL","CREATE INDEX IF NOT EXISTS idx_events_severity ON reserve.events(severity)","CREATE INDEX IF NOT EXISTS idx_events_created ON reserve.events(created_at DESC)","CREATE INDEX IF NOT EXISTS idx_events_correlation ON reserve.events(correlation_id) WHERE correlation_id IS NOT NULL","CREATE INDEX IF NOT EXISTS idx_events_unprocessed ON reserve.events(created_at) WHERE processed_at IS NULL","-- ============================================\n-- PART 3: PUBLIC VIEWS\n-- ============================================\n\n-- Drop existing views\nDROP VIEW IF EXISTS public.published_cities_view CASCADE","DROP VIEW IF EXISTS public.published_properties_view CASCADE","DROP VIEW IF EXISTS public.published_units_view CASCADE","DROP VIEW IF EXISTS public.active_room_types_view CASCADE","DROP VIEW IF EXISTS public.properties_map CASCADE","DROP VIEW IF EXISTS public.unit_map CASCADE","DROP VIEW IF EXISTS public.sync_jobs CASCADE","DROP VIEW IF EXISTS public.sync_logs CASCADE","DROP VIEW IF EXISTS public.events CASCADE","DROP VIEW IF EXISTS public.cities CASCADE","-- Published Cities View\nCREATE OR REPLACE VIEW public.published_cities_view AS\nSELECT \n    c.id as city_id,\n    c.code as city_code,\n    c.name as city_name,\n    c.state_province,\n    c.country,\n    c.timezone,\n    c.currency,\n    (SELECT COUNT(*) \n     FROM reserve.properties_map pm \n     WHERE pm.city_id = c.id \n       AND pm.is_active = true \n       AND pm.is_published = true \n       AND pm.deleted_at IS NULL) as properties_count,\n    c.updated_at\nFROM reserve.cities c\nWHERE c.is_active = true","COMMENT ON VIEW public.published_cities_view IS 'Public read-only view of active cities with property counts'","-- Published Properties View\nCREATE OR REPLACE VIEW public.published_properties_view AS\nSELECT \n    pm.id as property_id,\n    pm.host_property_id,\n    c.code as city_code,\n    pm.name,\n    pm.slug,\n    pm.address_line_1 as address,\n    pm.latitude as lat,\n    pm.longitude as lng,\n    CASE \n        WHEN pm.images_cached IS NOT NULL AND jsonb_array_length(pm.images_cached) > 0\n        THEN pm.images_cached->0->>'url'\n        ELSE NULL\n    END as primary_image_url,\n    pm.updated_at\nFROM reserve.properties_map pm\nJOIN reserve.cities c ON pm.city_id = c.id\nWHERE pm.is_active = true \n  AND pm.is_published = true \n  AND pm.deleted_at IS NULL\n  AND c.is_active = true","COMMENT ON VIEW public.published_properties_view IS 'Public read-only view of published properties'","-- Published Units View\nCREATE OR REPLACE VIEW public.published_units_view AS\nSELECT \n    um.id as unit_id,\n    um.host_unit_id,\n    um.host_property_id,\n    um.property_id,\n    um.unit_type,\n    um.name,\n    um.max_occupancy as capacity,\n    um.amenities_cached as amenities,\n    um.images_cached as images,\n    um.is_active as status,\n    um.updated_at\nFROM reserve.unit_map um\nJOIN reserve.properties_map pm ON um.property_id = pm.id\nJOIN reserve.cities c ON pm.city_id = c.id\nWHERE um.is_active = true \n  AND um.deleted_at IS NULL\n  AND pm.is_active = true \n  AND pm.is_published = true \n  AND pm.deleted_at IS NULL\n  AND c.is_active = true","COMMENT ON VIEW public.published_units_view IS 'Public read-only view of active room types/units'","-- Active Room Types View (for search_availability)\nCREATE OR REPLACE VIEW public.active_room_types_view AS\nSELECT \n    um.id,\n    um.host_unit_id as host_room_type_id,\n    um.host_property_id,\n    um.property_id,\n    pm.name as property_name,\n    pm.slug as property_slug,\n    pm.city_id,\n    c.code as city_code,\n    um.name as room_type_name,\n    um.slug as room_type_slug,\n    um.max_occupancy,\n    um.base_capacity,\n    um.amenities_cached as amenities_cached,\n    um.images_cached as images_cached,\n    um.size_sqm\nFROM reserve.unit_map um\nJOIN reserve.properties_map pm ON um.property_id = pm.id\nJOIN reserve.cities c ON pm.city_id = c.id\nWHERE um.is_active = true \n  AND um.deleted_at IS NULL\n  AND pm.is_active = true \n  AND pm.is_published = true \n  AND pm.deleted_at IS NULL\n  AND c.is_active = true","COMMENT ON VIEW public.active_room_types_view IS 'Active room types for search_availability Edge Function'","-- Proxy views for Edge Functions\nCREATE OR REPLACE VIEW public.cities AS SELECT * FROM reserve.cities","CREATE OR REPLACE VIEW public.properties_map AS SELECT * FROM reserve.properties_map","CREATE OR REPLACE VIEW public.unit_map AS SELECT * FROM reserve.unit_map","CREATE OR REPLACE VIEW public.sync_jobs AS SELECT * FROM reserve.sync_jobs","CREATE OR REPLACE VIEW public.sync_logs AS SELECT * FROM reserve.sync_logs","CREATE OR REPLACE VIEW public.events AS SELECT * FROM reserve.events","COMMENT ON VIEW public.cities IS 'Proxy view to reserve.cities for Edge Function compatibility'","COMMENT ON VIEW public.properties_map IS 'Proxy view to reserve.properties_map for Edge Function compatibility'","COMMENT ON VIEW public.unit_map IS 'Proxy view to reserve.unit_map for Edge Function compatibility'","COMMENT ON VIEW public.sync_jobs IS 'Proxy view to reserve.sync_jobs for Edge Function compatibility'","COMMENT ON VIEW public.sync_logs IS 'Proxy view to reserve.sync_logs for Edge Function compatibility'","COMMENT ON VIEW public.events IS 'Proxy view to reserve.events for Edge Function compatibility'","-- ============================================\n-- PART 4: PUBLIC HELPER FUNCTIONS\n-- ============================================\n\n-- Function 1: Get published cities\nCREATE OR REPLACE FUNCTION public.get_published_cities()\nRETURNS TABLE (\n    city_id UUID,\n    city_code VARCHAR(10),\n    city_name VARCHAR(100),\n    state_province VARCHAR(100),\n    country VARCHAR(100),\n    timezone VARCHAR(50),\n    currency VARCHAR(3),\n    properties_count BIGINT,\n    updated_at TIMESTAMPTZ\n) \nSECURITY DEFINER\nSET search_path = public\nAS $$\nBEGIN\n    RETURN QUERY\n    SELECT \n        pcv.city_id,\n        pcv.city_code,\n        pcv.city_name,\n        pcv.state_province,\n        pcv.country,\n        pcv.timezone,\n        pcv.currency,\n        pcv.properties_count,\n        pcv.updated_at\n    FROM public.published_cities_view pcv\n    ORDER BY pcv.city_name;\nEND;\n$$ LANGUAGE plpgsql","COMMENT ON FUNCTION public.get_published_cities() IS 'Public function to get all active cities with property counts'","-- Function 2: Get properties by city\nCREATE OR REPLACE FUNCTION public.get_properties_by_city(p_city_code TEXT)\nRETURNS TABLE (\n    property_id UUID,\n    host_property_id UUID,\n    city_code VARCHAR(10),\n    name VARCHAR(200),\n    slug VARCHAR(200),\n    address VARCHAR(255),\n    lat DECIMAL(10, 8),\n    lng DECIMAL(11, 8),\n    primary_image_url TEXT,\n    updated_at TIMESTAMPTZ\n)\nSECURITY DEFINER\nSET search_path = public\nAS $$\nBEGIN\n    RETURN QUERY\n    SELECT \n        ppv.property_id,\n        ppv.host_property_id,\n        ppv.city_code,\n        ppv.name,\n        ppv.slug,\n        ppv.address,\n        ppv.lat,\n        ppv.lng,\n        ppv.primary_image_url,\n        ppv.updated_at\n    FROM public.published_properties_view ppv\n    WHERE ppv.city_code = p_city_code\n    ORDER BY ppv.name;\nEND;\n$$ LANGUAGE plpgsql","COMMENT ON FUNCTION public.get_properties_by_city(TEXT) IS 'Public function to get properties by city code'","-- Function 3: Get room types by property\nCREATE OR REPLACE FUNCTION public.get_room_types_by_property(p_property_id UUID)\nRETURNS TABLE (\n    unit_id UUID,\n    host_unit_id UUID,\n    host_property_id UUID,\n    property_id UUID,\n    unit_type VARCHAR(50),\n    name VARCHAR(200),\n    capacity INTEGER,\n    amenities JSONB,\n    images JSONB,\n    status BOOLEAN,\n    updated_at TIMESTAMPTZ\n)\nSECURITY DEFINER\nSET search_path = public\nAS $$\nBEGIN\n    RETURN QUERY\n    SELECT \n        puv.unit_id,\n        puv.host_unit_id,\n        puv.host_property_id,\n        puv.property_id,\n        puv.unit_type,\n        puv.name,\n        puv.capacity,\n        puv.amenities,\n        puv.images,\n        puv.status,\n        puv.updated_at\n    FROM public.published_units_view puv\n    WHERE puv.property_id = p_property_id\n    ORDER BY puv.name;\nEND;\n$$ LANGUAGE plpgsql","COMMENT ON FUNCTION public.get_room_types_by_property(UUID) IS 'Public function to get room types by property ID'","-- ============================================\n-- PART 5: SECURITY HARDENING - RLS\n-- ============================================\n\n-- Enable RLS on all reserve tables\nALTER TABLE IF EXISTS reserve.cities ENABLE ROW LEVEL SECURITY","ALTER TABLE IF EXISTS reserve.properties_map ENABLE ROW LEVEL SECURITY","ALTER TABLE IF EXISTS reserve.unit_map ENABLE ROW LEVEL SECURITY","ALTER TABLE IF EXISTS reserve.sync_jobs ENABLE ROW LEVEL SECURITY","ALTER TABLE IF EXISTS reserve.sync_logs ENABLE ROW LEVEL SECURITY","ALTER TABLE IF EXISTS reserve.events ENABLE ROW LEVEL SECURITY","-- Force RLS\nALTER TABLE IF EXISTS reserve.cities FORCE ROW LEVEL SECURITY","ALTER TABLE IF EXISTS reserve.properties_map FORCE ROW LEVEL SECURITY","ALTER TABLE IF EXISTS reserve.unit_map FORCE ROW LEVEL SECURITY","ALTER TABLE IF EXISTS reserve.sync_jobs FORCE ROW LEVEL SECURITY","ALTER TABLE IF EXISTS reserve.sync_logs FORCE ROW LEVEL SECURITY","ALTER TABLE IF EXISTS reserve.events FORCE ROW LEVEL SECURITY","-- ============================================\n-- PART 6: SECURITY POLICIES\n-- ============================================\n\n-- Drop existing policies\nDROP POLICY IF EXISTS service_role_all_cities ON reserve.cities","DROP POLICY IF EXISTS service_role_all_properties ON reserve.properties_map","DROP POLICY IF EXISTS service_role_all_units ON reserve.unit_map","DROP POLICY IF EXISTS service_role_all_sync_jobs ON reserve.sync_jobs","DROP POLICY IF EXISTS service_role_all_sync_logs ON reserve.sync_logs","DROP POLICY IF EXISTS service_role_all_events ON reserve.events","DROP POLICY IF EXISTS public_read_cities ON reserve.cities","DROP POLICY IF EXISTS public_read_properties ON reserve.properties_map","DROP POLICY IF EXISTS public_read_units ON reserve.unit_map","-- Service role policies (Edge Functions)\nCREATE POLICY service_role_all_cities ON reserve.cities FOR ALL TO service_role USING (true) WITH CHECK (true)","CREATE POLICY service_role_all_properties ON reserve.properties_map FOR ALL TO service_role USING (true) WITH CHECK (true)","CREATE POLICY service_role_all_units ON reserve.unit_map FOR ALL TO service_role USING (true) WITH CHECK (true)","CREATE POLICY service_role_all_sync_jobs ON reserve.sync_jobs FOR ALL TO service_role USING (true) WITH CHECK (true)","CREATE POLICY service_role_all_sync_logs ON reserve.sync_logs FOR ALL TO service_role USING (true) WITH CHECK (true)","CREATE POLICY service_role_all_events ON reserve.events FOR ALL TO service_role USING (true) WITH CHECK (true)","-- Public policies (read-only, filtered)\nCREATE POLICY public_read_cities ON reserve.cities FOR SELECT TO anon USING (is_active = true)","CREATE POLICY public_read_properties ON reserve.properties_map FOR SELECT TO anon USING (is_active = true AND is_published = true AND deleted_at IS NULL)","CREATE POLICY public_read_units ON reserve.unit_map FOR SELECT TO anon USING (is_active = true AND deleted_at IS NULL)","-- ============================================\n-- PART 7: GRANTS\n-- ============================================\n\n-- Revoke all from anon on reserve schema\nREVOKE ALL ON ALL TABLES IN SCHEMA reserve FROM anon","REVOKE ALL ON ALL SEQUENCES IN SCHEMA reserve FROM anon","REVOKE ALL ON ALL FUNCTIONS IN SCHEMA reserve FROM anon","-- Revoke all from authenticated on reserve schema (they use public views)\nREVOKE ALL ON ALL TABLES IN SCHEMA reserve FROM authenticated","-- Grant usage on schemas\nGRANT USAGE ON SCHEMA reserve TO service_role","GRANT USAGE ON SCHEMA reserve TO authenticated","GRANT USAGE ON SCHEMA public TO anon","GRANT USAGE ON SCHEMA public TO authenticated","GRANT USAGE ON SCHEMA public TO service_role","-- Grant on public views to anon (public website)\nGRANT SELECT ON public.published_cities_view TO anon","GRANT SELECT ON public.published_properties_view TO anon","GRANT SELECT ON public.published_units_view TO anon","GRANT SELECT ON public.active_room_types_view TO anon","-- Grant on public views to authenticated\nGRANT SELECT ON public.published_cities_view TO authenticated","GRANT SELECT ON public.published_properties_view TO authenticated","GRANT SELECT ON public.published_units_view TO authenticated","GRANT SELECT ON public.active_room_types_view TO authenticated","-- Grant on proxy views to service_role (Edge Functions)\nGRANT SELECT, INSERT, UPDATE ON public.cities TO service_role","GRANT SELECT, INSERT, UPDATE ON public.properties_map TO service_role","GRANT SELECT, INSERT, UPDATE ON public.unit_map TO service_role","GRANT SELECT, INSERT ON public.sync_jobs TO service_role","GRANT SELECT, INSERT ON public.sync_logs TO service_role","GRANT SELECT, INSERT ON public.events TO service_role","-- Grant execute on helper functions\nGRANT EXECUTE ON FUNCTION public.get_published_cities() TO anon","GRANT EXECUTE ON FUNCTION public.get_published_cities() TO authenticated","GRANT EXECUTE ON FUNCTION public.get_properties_by_city(TEXT) TO anon","GRANT EXECUTE ON FUNCTION public.get_properties_by_city(TEXT) TO authenticated","GRANT EXECUTE ON FUNCTION public.get_room_types_by_property(UUID) TO anon","GRANT EXECUTE ON FUNCTION public.get_room_types_by_property(UUID) TO authenticated","-- Grant full access to reserve schema for service_role\nGRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA reserve TO service_role","GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA reserve TO service_role","GRANT ALL PRIVILEGES ON ALL FUNCTIONS IN SCHEMA reserve TO service_role","-- Set default privileges for future objects\nALTER DEFAULT PRIVILEGES IN SCHEMA reserve GRANT ALL ON TABLES TO service_role","ALTER DEFAULT PRIVILEGES IN SCHEMA reserve GRANT ALL ON SEQUENCES TO service_role","ALTER DEFAULT PRIVILEGES IN SCHEMA reserve GRANT ALL ON FUNCTIONS TO service_role","-- ============================================\n-- PART 8: STORAGE BUCKETS\n-- ============================================\n\n-- Create storage buckets\nINSERT INTO storage.buckets (id, name, public)\nVALUES \n    ('public-assets', 'public-assets', true),\n    ('property-photos', 'property-photos', false),\n    ('unit-photos', 'unit-photos', false)\nON CONFLICT (id) DO NOTHING","-- Storage policies for public-assets (public read)\nDROP POLICY IF EXISTS \\"Public assets are publicly accessible\\" ON storage.objects","CREATE POLICY \\"Public assets are publicly accessible\\"\nON storage.objects FOR SELECT\nUSING (bucket_id = 'public-assets')","-- Storage policies for property-photos (signed URLs only)\nDROP POLICY IF EXISTS \\"Property photos accessible via service role\\" ON storage.objects","CREATE POLICY \\"Property photos accessible via service role\\"\nON storage.objects FOR ALL\nTO service_role\nUSING (bucket_id = 'property-photos')","-- Storage policies for unit-photos (signed URLs only)\nDROP POLICY IF EXISTS \\"Unit photos accessible via service role\\" ON storage.objects","CREATE POLICY \\"Unit photos accessible via service role\\"\nON storage.objects FOR ALL\nTO service_role\nUSING (bucket_id = 'unit-photos')","-- ============================================\n-- MIGRATION COMPLETION\n-- ============================================\n\nDO $$\nBEGIN\n    RAISE NOTICE '========================================';\n    RAISE NOTICE 'FINAL PRODUCTION MIGRATION COMPLETE';\n    RAISE NOTICE '========================================';\n    RAISE NOTICE 'Tables: Created/verified';\n    RAISE NOTICE 'Indexes: 18 created/verified';\n    RAISE NOTICE 'Public Views: 4 created';\n    RAISE NOTICE 'Proxy Views: 6 created';\n    RAISE NOTICE 'Helper Functions: 3 created';\n    RAISE NOTICE 'RLS: FORCE enabled on all tables';\n    RAISE NOTICE 'Storage Buckets: 3 created';\n    RAISE NOTICE '========================================';\nEND $$"}	final_production_setup	\N	\N	\N
\.


--
-- TOC entry 4548 (class 0 OID 48160)
-- Dependencies: 274
-- Data for Name: seed_files; Type: TABLE DATA; Schema: supabase_migrations; Owner: -
--

COPY supabase_migrations.seed_files (path, hash) FROM stdin;
\.


--
-- TOC entry 3708 (class 0 OID 16658)
-- Dependencies: 243
-- Data for Name: secrets; Type: TABLE DATA; Schema: vault; Owner: -
--

COPY vault.secrets (id, name, description, secret, key_id, nonce, created_at, updated_at) FROM stdin;
\.


--
-- TOC entry 4676 (class 0 OID 0)
-- Dependencies: 235
-- Name: refresh_tokens_id_seq; Type: SEQUENCE SET; Schema: auth; Owner: -
--

SELECT pg_catalog.setval('auth.refresh_tokens_id_seq', 1, false);


--
-- TOC entry 4677 (class 0 OID 0)
-- Dependencies: 265
-- Name: subscription_id_seq; Type: SEQUENCE SET; Schema: realtime; Owner: -
--

SELECT pg_catalog.setval('realtime.subscription_id_seq', 1, false);


--
-- TOC entry 4005 (class 2606 OID 16829)
-- Name: mfa_amr_claims amr_id_pk; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.mfa_amr_claims
    ADD CONSTRAINT amr_id_pk PRIMARY KEY (id);


--
-- TOC entry 3961 (class 2606 OID 16531)
-- Name: audit_log_entries audit_log_entries_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.audit_log_entries
    ADD CONSTRAINT audit_log_entries_pkey PRIMARY KEY (id);


--
-- TOC entry 4028 (class 2606 OID 16935)
-- Name: flow_state flow_state_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.flow_state
    ADD CONSTRAINT flow_state_pkey PRIMARY KEY (id);


--
-- TOC entry 3983 (class 2606 OID 16953)
-- Name: identities identities_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.identities
    ADD CONSTRAINT identities_pkey PRIMARY KEY (id);


--
-- TOC entry 3985 (class 2606 OID 16963)
-- Name: identities identities_provider_id_provider_unique; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.identities
    ADD CONSTRAINT identities_provider_id_provider_unique UNIQUE (provider_id, provider);


--
-- TOC entry 3959 (class 2606 OID 16524)
-- Name: instances instances_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.instances
    ADD CONSTRAINT instances_pkey PRIMARY KEY (id);


--
-- TOC entry 4007 (class 2606 OID 16822)
-- Name: mfa_amr_claims mfa_amr_claims_session_id_authentication_method_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.mfa_amr_claims
    ADD CONSTRAINT mfa_amr_claims_session_id_authentication_method_pkey UNIQUE (session_id, authentication_method);


--
-- TOC entry 4003 (class 2606 OID 16810)
-- Name: mfa_challenges mfa_challenges_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.mfa_challenges
    ADD CONSTRAINT mfa_challenges_pkey PRIMARY KEY (id);


--
-- TOC entry 3995 (class 2606 OID 17003)
-- Name: mfa_factors mfa_factors_last_challenged_at_key; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.mfa_factors
    ADD CONSTRAINT mfa_factors_last_challenged_at_key UNIQUE (last_challenged_at);


--
-- TOC entry 3997 (class 2606 OID 16797)
-- Name: mfa_factors mfa_factors_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.mfa_factors
    ADD CONSTRAINT mfa_factors_pkey PRIMARY KEY (id);


--
-- TOC entry 4041 (class 2606 OID 17062)
-- Name: oauth_authorizations oauth_authorizations_authorization_code_key; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.oauth_authorizations
    ADD CONSTRAINT oauth_authorizations_authorization_code_key UNIQUE (authorization_code);


--
-- TOC entry 4043 (class 2606 OID 17060)
-- Name: oauth_authorizations oauth_authorizations_authorization_id_key; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.oauth_authorizations
    ADD CONSTRAINT oauth_authorizations_authorization_id_key UNIQUE (authorization_id);


--
-- TOC entry 4045 (class 2606 OID 17058)
-- Name: oauth_authorizations oauth_authorizations_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.oauth_authorizations
    ADD CONSTRAINT oauth_authorizations_pkey PRIMARY KEY (id);


--
-- TOC entry 4081 (class 2606 OID 39404)
-- Name: oauth_client_states oauth_client_states_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.oauth_client_states
    ADD CONSTRAINT oauth_client_states_pkey PRIMARY KEY (id);


--
-- TOC entry 4038 (class 2606 OID 17022)
-- Name: oauth_clients oauth_clients_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.oauth_clients
    ADD CONSTRAINT oauth_clients_pkey PRIMARY KEY (id);


--
-- TOC entry 4049 (class 2606 OID 17084)
-- Name: oauth_consents oauth_consents_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.oauth_consents
    ADD CONSTRAINT oauth_consents_pkey PRIMARY KEY (id);


--
-- TOC entry 4051 (class 2606 OID 17086)
-- Name: oauth_consents oauth_consents_user_client_unique; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.oauth_consents
    ADD CONSTRAINT oauth_consents_user_client_unique UNIQUE (user_id, client_id);


--
-- TOC entry 4032 (class 2606 OID 16988)
-- Name: one_time_tokens one_time_tokens_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.one_time_tokens
    ADD CONSTRAINT one_time_tokens_pkey PRIMARY KEY (id);


--
-- TOC entry 3953 (class 2606 OID 16514)
-- Name: refresh_tokens refresh_tokens_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.refresh_tokens
    ADD CONSTRAINT refresh_tokens_pkey PRIMARY KEY (id);


--
-- TOC entry 3956 (class 2606 OID 16740)
-- Name: refresh_tokens refresh_tokens_token_unique; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.refresh_tokens
    ADD CONSTRAINT refresh_tokens_token_unique UNIQUE (token);


--
-- TOC entry 4017 (class 2606 OID 16869)
-- Name: saml_providers saml_providers_entity_id_key; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.saml_providers
    ADD CONSTRAINT saml_providers_entity_id_key UNIQUE (entity_id);


--
-- TOC entry 4019 (class 2606 OID 16867)
-- Name: saml_providers saml_providers_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.saml_providers
    ADD CONSTRAINT saml_providers_pkey PRIMARY KEY (id);


--
-- TOC entry 4024 (class 2606 OID 16883)
-- Name: saml_relay_states saml_relay_states_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.saml_relay_states
    ADD CONSTRAINT saml_relay_states_pkey PRIMARY KEY (id);


--
-- TOC entry 3964 (class 2606 OID 16537)
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- TOC entry 3990 (class 2606 OID 16761)
-- Name: sessions sessions_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.sessions
    ADD CONSTRAINT sessions_pkey PRIMARY KEY (id);


--
-- TOC entry 4014 (class 2606 OID 16850)
-- Name: sso_domains sso_domains_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.sso_domains
    ADD CONSTRAINT sso_domains_pkey PRIMARY KEY (id);


--
-- TOC entry 4009 (class 2606 OID 16841)
-- Name: sso_providers sso_providers_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.sso_providers
    ADD CONSTRAINT sso_providers_pkey PRIMARY KEY (id);


--
-- TOC entry 3946 (class 2606 OID 16923)
-- Name: users users_phone_key; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.users
    ADD CONSTRAINT users_phone_key UNIQUE (phone);


--
-- TOC entry 3948 (class 2606 OID 16501)
-- Name: users users_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- TOC entry 4069 (class 2606 OID 17449)
-- Name: messages messages_pkey; Type: CONSTRAINT; Schema: realtime; Owner: -
--

ALTER TABLE ONLY realtime.messages
    ADD CONSTRAINT messages_pkey PRIMARY KEY (id, inserted_at);


--
-- TOC entry 4065 (class 2606 OID 17301)
-- Name: subscription pk_subscription; Type: CONSTRAINT; Schema: realtime; Owner: -
--

ALTER TABLE ONLY realtime.subscription
    ADD CONSTRAINT pk_subscription PRIMARY KEY (id);


--
-- TOC entry 4054 (class 2606 OID 17116)
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: realtime; Owner: -
--

ALTER TABLE ONLY realtime.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- TOC entry 4191 (class 2606 OID 48565)
-- Name: audit_logs audit_logs_pkey; Type: CONSTRAINT; Schema: reserve; Owner: -
--

ALTER TABLE ONLY reserve.audit_logs
    ADD CONSTRAINT audit_logs_pkey PRIMARY KEY (id);


--
-- TOC entry 4128 (class 2606 OID 48379)
-- Name: availability_calendar availability_calendar_pkey; Type: CONSTRAINT; Schema: reserve; Owner: -
--

ALTER TABLE ONLY reserve.availability_calendar
    ADD CONSTRAINT availability_calendar_pkey PRIMARY KEY (id);


--
-- TOC entry 4085 (class 2606 OID 48267)
-- Name: cities cities_code_key; Type: CONSTRAINT; Schema: reserve; Owner: -
--

ALTER TABLE ONLY reserve.cities
    ADD CONSTRAINT cities_code_key UNIQUE (code);


--
-- TOC entry 4087 (class 2606 OID 48265)
-- Name: cities cities_pkey; Type: CONSTRAINT; Schema: reserve; Owner: -
--

ALTER TABLE ONLY reserve.cities
    ADD CONSTRAINT cities_pkey PRIMARY KEY (id);


--
-- TOC entry 4180 (class 2606 OID 48547)
-- Name: events events_pkey; Type: CONSTRAINT; Schema: reserve; Owner: -
--

ALTER TABLE ONLY reserve.events
    ADD CONSTRAINT events_pkey PRIMARY KEY (id);


--
-- TOC entry 4200 (class 2606 OID 48582)
-- Name: funnel_events funnel_events_pkey; Type: CONSTRAINT; Schema: reserve; Owner: -
--

ALTER TABLE ONLY reserve.funnel_events
    ADD CONSTRAINT funnel_events_pkey PRIMARY KEY (id);


--
-- TOC entry 4215 (class 2606 OID 48647)
-- Name: kpi_daily_snapshots kpi_daily_snapshots_pkey; Type: CONSTRAINT; Schema: reserve; Owner: -
--

ALTER TABLE ONLY reserve.kpi_daily_snapshots
    ADD CONSTRAINT kpi_daily_snapshots_pkey PRIMARY KEY (id);


--
-- TOC entry 4101 (class 2606 OID 48287)
-- Name: properties_map properties_map_pkey; Type: CONSTRAINT; Schema: reserve; Owner: -
--

ALTER TABLE ONLY reserve.properties_map
    ADD CONSTRAINT properties_map_pkey PRIMARY KEY (id);


--
-- TOC entry 4103 (class 2606 OID 48289)
-- Name: properties_map properties_map_slug_key; Type: CONSTRAINT; Schema: reserve; Owner: -
--

ALTER TABLE ONLY reserve.properties_map
    ADD CONSTRAINT properties_map_slug_key UNIQUE (slug);


--
-- TOC entry 4124 (class 2606 OID 48345)
-- Name: rate_plans rate_plans_pkey; Type: CONSTRAINT; Schema: reserve; Owner: -
--

ALTER TABLE ONLY reserve.rate_plans
    ADD CONSTRAINT rate_plans_pkey PRIMARY KEY (id);


--
-- TOC entry 4157 (class 2606 OID 48452)
-- Name: reservations reservations_confirmation_code_key; Type: CONSTRAINT; Schema: reserve; Owner: -
--

ALTER TABLE ONLY reserve.reservations
    ADD CONSTRAINT reservations_confirmation_code_key UNIQUE (confirmation_code);


--
-- TOC entry 4159 (class 2606 OID 48450)
-- Name: reservations reservations_pkey; Type: CONSTRAINT; Schema: reserve; Owner: -
--

ALTER TABLE ONLY reserve.reservations
    ADD CONSTRAINT reservations_pkey PRIMARY KEY (id);


--
-- TOC entry 4219 (class 2606 OID 48770)
-- Name: search_config search_config_config_key_key; Type: CONSTRAINT; Schema: reserve; Owner: -
--

ALTER TABLE ONLY reserve.search_config
    ADD CONSTRAINT search_config_config_key_key UNIQUE (config_key);


--
-- TOC entry 4221 (class 2606 OID 48768)
-- Name: search_config search_config_pkey; Type: CONSTRAINT; Schema: reserve; Owner: -
--

ALTER TABLE ONLY reserve.search_config
    ADD CONSTRAINT search_config_pkey PRIMARY KEY (id);


--
-- TOC entry 4170 (class 2606 OID 48498)
-- Name: sync_jobs sync_jobs_pkey; Type: CONSTRAINT; Schema: reserve; Owner: -
--

ALTER TABLE ONLY reserve.sync_jobs
    ADD CONSTRAINT sync_jobs_pkey PRIMARY KEY (id);


--
-- TOC entry 4178 (class 2606 OID 48524)
-- Name: sync_logs sync_logs_pkey; Type: CONSTRAINT; Schema: reserve; Owner: -
--

ALTER TABLE ONLY reserve.sync_logs
    ADD CONSTRAINT sync_logs_pkey PRIMARY KEY (id);


--
-- TOC entry 4144 (class 2606 OID 48411)
-- Name: travelers travelers_pkey; Type: CONSTRAINT; Schema: reserve; Owner: -
--

ALTER TABLE ONLY reserve.travelers
    ADD CONSTRAINT travelers_pkey PRIMARY KEY (id);


--
-- TOC entry 4217 (class 2606 OID 48649)
-- Name: kpi_daily_snapshots unique_daily_snapshot; Type: CONSTRAINT; Schema: reserve; Owner: -
--

ALTER TABLE ONLY reserve.kpi_daily_snapshots
    ADD CONSTRAINT unique_daily_snapshot UNIQUE (snapshot_date, city_id, property_id);


--
-- TOC entry 4126 (class 2606 OID 48347)
-- Name: rate_plans unique_default_rate_plan; Type: CONSTRAINT; Schema: reserve; Owner: -
--

ALTER TABLE ONLY reserve.rate_plans
    ADD CONSTRAINT unique_default_rate_plan UNIQUE (property_id, is_default) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4136 (class 2606 OID 48381)
-- Name: availability_calendar unique_unit_rate_date; Type: CONSTRAINT; Schema: reserve; Owner: -
--

ALTER TABLE ONLY reserve.availability_calendar
    ADD CONSTRAINT unique_unit_rate_date UNIQUE (unit_id, rate_plan_id, date);


--
-- TOC entry 4116 (class 2606 OID 48319)
-- Name: unit_map unique_unit_slug_per_property; Type: CONSTRAINT; Schema: reserve; Owner: -
--

ALTER TABLE ONLY reserve.unit_map
    ADD CONSTRAINT unique_unit_slug_per_property UNIQUE (property_id, slug);


--
-- TOC entry 4118 (class 2606 OID 48317)
-- Name: unit_map unit_map_pkey; Type: CONSTRAINT; Schema: reserve; Owner: -
--

ALTER TABLE ONLY reserve.unit_map
    ADD CONSTRAINT unit_map_pkey PRIMARY KEY (id);


--
-- TOC entry 4061 (class 2606 OID 31204)
-- Name: buckets_analytics buckets_analytics_pkey; Type: CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.buckets_analytics
    ADD CONSTRAINT buckets_analytics_pkey PRIMARY KEY (id);


--
-- TOC entry 3967 (class 2606 OID 16554)
-- Name: buckets buckets_pkey; Type: CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.buckets
    ADD CONSTRAINT buckets_pkey PRIMARY KEY (id);


--
-- TOC entry 4075 (class 2606 OID 31180)
-- Name: buckets_vectors buckets_vectors_pkey; Type: CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.buckets_vectors
    ADD CONSTRAINT buckets_vectors_pkey PRIMARY KEY (id);


--
-- TOC entry 3975 (class 2606 OID 16595)
-- Name: migrations migrations_name_key; Type: CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.migrations
    ADD CONSTRAINT migrations_name_key UNIQUE (name);


--
-- TOC entry 3977 (class 2606 OID 16593)
-- Name: migrations migrations_pkey; Type: CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.migrations
    ADD CONSTRAINT migrations_pkey PRIMARY KEY (id);


--
-- TOC entry 3973 (class 2606 OID 16571)
-- Name: objects objects_pkey; Type: CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.objects
    ADD CONSTRAINT objects_pkey PRIMARY KEY (id);


--
-- TOC entry 4059 (class 2606 OID 17172)
-- Name: s3_multipart_uploads_parts s3_multipart_uploads_parts_pkey; Type: CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.s3_multipart_uploads_parts
    ADD CONSTRAINT s3_multipart_uploads_parts_pkey PRIMARY KEY (id);


--
-- TOC entry 4057 (class 2606 OID 17157)
-- Name: s3_multipart_uploads s3_multipart_uploads_pkey; Type: CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.s3_multipart_uploads
    ADD CONSTRAINT s3_multipart_uploads_pkey PRIMARY KEY (id);


--
-- TOC entry 4078 (class 2606 OID 31190)
-- Name: vector_indexes vector_indexes_pkey; Type: CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.vector_indexes
    ADD CONSTRAINT vector_indexes_pkey PRIMARY KEY (id);


--
-- TOC entry 4071 (class 2606 OID 22986)
-- Name: schema_migrations schema_migrations_idempotency_key_key; Type: CONSTRAINT; Schema: supabase_migrations; Owner: -
--

ALTER TABLE ONLY supabase_migrations.schema_migrations
    ADD CONSTRAINT schema_migrations_idempotency_key_key UNIQUE (idempotency_key);


--
-- TOC entry 4073 (class 2606 OID 22984)
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: supabase_migrations; Owner: -
--

ALTER TABLE ONLY supabase_migrations.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- TOC entry 4083 (class 2606 OID 48166)
-- Name: seed_files seed_files_pkey; Type: CONSTRAINT; Schema: supabase_migrations; Owner: -
--

ALTER TABLE ONLY supabase_migrations.seed_files
    ADD CONSTRAINT seed_files_pkey PRIMARY KEY (path);


--
-- TOC entry 3962 (class 1259 OID 16532)
-- Name: audit_logs_instance_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX audit_logs_instance_id_idx ON auth.audit_log_entries USING btree (instance_id);


--
-- TOC entry 3936 (class 1259 OID 16750)
-- Name: confirmation_token_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX confirmation_token_idx ON auth.users USING btree (confirmation_token) WHERE ((confirmation_token)::text !~ '^[0-9 ]*$'::text);


--
-- TOC entry 3937 (class 1259 OID 16752)
-- Name: email_change_token_current_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX email_change_token_current_idx ON auth.users USING btree (email_change_token_current) WHERE ((email_change_token_current)::text !~ '^[0-9 ]*$'::text);


--
-- TOC entry 3938 (class 1259 OID 16753)
-- Name: email_change_token_new_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX email_change_token_new_idx ON auth.users USING btree (email_change_token_new) WHERE ((email_change_token_new)::text !~ '^[0-9 ]*$'::text);


--
-- TOC entry 3993 (class 1259 OID 16831)
-- Name: factor_id_created_at_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX factor_id_created_at_idx ON auth.mfa_factors USING btree (user_id, created_at);


--
-- TOC entry 4026 (class 1259 OID 16939)
-- Name: flow_state_created_at_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX flow_state_created_at_idx ON auth.flow_state USING btree (created_at DESC);


--
-- TOC entry 3981 (class 1259 OID 16919)
-- Name: identities_email_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX identities_email_idx ON auth.identities USING btree (email text_pattern_ops);


--
-- TOC entry 4678 (class 0 OID 0)
-- Dependencies: 3981
-- Name: INDEX identities_email_idx; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON INDEX auth.identities_email_idx IS 'Auth: Ensures indexed queries on the email column';


--
-- TOC entry 3986 (class 1259 OID 16747)
-- Name: identities_user_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX identities_user_id_idx ON auth.identities USING btree (user_id);


--
-- TOC entry 4029 (class 1259 OID 16936)
-- Name: idx_auth_code; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX idx_auth_code ON auth.flow_state USING btree (auth_code);


--
-- TOC entry 4079 (class 1259 OID 39405)
-- Name: idx_oauth_client_states_created_at; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX idx_oauth_client_states_created_at ON auth.oauth_client_states USING btree (created_at);


--
-- TOC entry 4030 (class 1259 OID 16937)
-- Name: idx_user_id_auth_method; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX idx_user_id_auth_method ON auth.flow_state USING btree (user_id, authentication_method);


--
-- TOC entry 4001 (class 1259 OID 16942)
-- Name: mfa_challenge_created_at_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX mfa_challenge_created_at_idx ON auth.mfa_challenges USING btree (created_at DESC);


--
-- TOC entry 3998 (class 1259 OID 16803)
-- Name: mfa_factors_user_friendly_name_unique; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX mfa_factors_user_friendly_name_unique ON auth.mfa_factors USING btree (friendly_name, user_id) WHERE (TRIM(BOTH FROM friendly_name) <> ''::text);


--
-- TOC entry 3999 (class 1259 OID 16948)
-- Name: mfa_factors_user_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX mfa_factors_user_id_idx ON auth.mfa_factors USING btree (user_id);


--
-- TOC entry 4039 (class 1259 OID 17073)
-- Name: oauth_auth_pending_exp_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX oauth_auth_pending_exp_idx ON auth.oauth_authorizations USING btree (expires_at) WHERE (status = 'pending'::auth.oauth_authorization_status);


--
-- TOC entry 4036 (class 1259 OID 17026)
-- Name: oauth_clients_deleted_at_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX oauth_clients_deleted_at_idx ON auth.oauth_clients USING btree (deleted_at);


--
-- TOC entry 4046 (class 1259 OID 17099)
-- Name: oauth_consents_active_client_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX oauth_consents_active_client_idx ON auth.oauth_consents USING btree (client_id) WHERE (revoked_at IS NULL);


--
-- TOC entry 4047 (class 1259 OID 17097)
-- Name: oauth_consents_active_user_client_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX oauth_consents_active_user_client_idx ON auth.oauth_consents USING btree (user_id, client_id) WHERE (revoked_at IS NULL);


--
-- TOC entry 4052 (class 1259 OID 17098)
-- Name: oauth_consents_user_order_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX oauth_consents_user_order_idx ON auth.oauth_consents USING btree (user_id, granted_at DESC);


--
-- TOC entry 4033 (class 1259 OID 16995)
-- Name: one_time_tokens_relates_to_hash_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX one_time_tokens_relates_to_hash_idx ON auth.one_time_tokens USING hash (relates_to);


--
-- TOC entry 4034 (class 1259 OID 16994)
-- Name: one_time_tokens_token_hash_hash_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX one_time_tokens_token_hash_hash_idx ON auth.one_time_tokens USING hash (token_hash);


--
-- TOC entry 4035 (class 1259 OID 16996)
-- Name: one_time_tokens_user_id_token_type_key; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX one_time_tokens_user_id_token_type_key ON auth.one_time_tokens USING btree (user_id, token_type);


--
-- TOC entry 3939 (class 1259 OID 16754)
-- Name: reauthentication_token_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX reauthentication_token_idx ON auth.users USING btree (reauthentication_token) WHERE ((reauthentication_token)::text !~ '^[0-9 ]*$'::text);


--
-- TOC entry 3940 (class 1259 OID 16751)
-- Name: recovery_token_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX recovery_token_idx ON auth.users USING btree (recovery_token) WHERE ((recovery_token)::text !~ '^[0-9 ]*$'::text);


--
-- TOC entry 3949 (class 1259 OID 16515)
-- Name: refresh_tokens_instance_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX refresh_tokens_instance_id_idx ON auth.refresh_tokens USING btree (instance_id);


--
-- TOC entry 3950 (class 1259 OID 16516)
-- Name: refresh_tokens_instance_id_user_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX refresh_tokens_instance_id_user_id_idx ON auth.refresh_tokens USING btree (instance_id, user_id);


--
-- TOC entry 3951 (class 1259 OID 16746)
-- Name: refresh_tokens_parent_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX refresh_tokens_parent_idx ON auth.refresh_tokens USING btree (parent);


--
-- TOC entry 3954 (class 1259 OID 16833)
-- Name: refresh_tokens_session_id_revoked_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX refresh_tokens_session_id_revoked_idx ON auth.refresh_tokens USING btree (session_id, revoked);


--
-- TOC entry 3957 (class 1259 OID 16938)
-- Name: refresh_tokens_updated_at_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX refresh_tokens_updated_at_idx ON auth.refresh_tokens USING btree (updated_at DESC);


--
-- TOC entry 4020 (class 1259 OID 16875)
-- Name: saml_providers_sso_provider_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX saml_providers_sso_provider_id_idx ON auth.saml_providers USING btree (sso_provider_id);


--
-- TOC entry 4021 (class 1259 OID 16940)
-- Name: saml_relay_states_created_at_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX saml_relay_states_created_at_idx ON auth.saml_relay_states USING btree (created_at DESC);


--
-- TOC entry 4022 (class 1259 OID 16890)
-- Name: saml_relay_states_for_email_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX saml_relay_states_for_email_idx ON auth.saml_relay_states USING btree (for_email);


--
-- TOC entry 4025 (class 1259 OID 16889)
-- Name: saml_relay_states_sso_provider_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX saml_relay_states_sso_provider_id_idx ON auth.saml_relay_states USING btree (sso_provider_id);


--
-- TOC entry 3987 (class 1259 OID 16941)
-- Name: sessions_not_after_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX sessions_not_after_idx ON auth.sessions USING btree (not_after DESC);


--
-- TOC entry 3988 (class 1259 OID 17111)
-- Name: sessions_oauth_client_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX sessions_oauth_client_id_idx ON auth.sessions USING btree (oauth_client_id);


--
-- TOC entry 3991 (class 1259 OID 16832)
-- Name: sessions_user_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX sessions_user_id_idx ON auth.sessions USING btree (user_id);


--
-- TOC entry 4012 (class 1259 OID 16857)
-- Name: sso_domains_domain_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX sso_domains_domain_idx ON auth.sso_domains USING btree (lower(domain));


--
-- TOC entry 4015 (class 1259 OID 16856)
-- Name: sso_domains_sso_provider_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX sso_domains_sso_provider_id_idx ON auth.sso_domains USING btree (sso_provider_id);


--
-- TOC entry 4010 (class 1259 OID 16842)
-- Name: sso_providers_resource_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX sso_providers_resource_id_idx ON auth.sso_providers USING btree (lower(resource_id));


--
-- TOC entry 4011 (class 1259 OID 17004)
-- Name: sso_providers_resource_id_pattern_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX sso_providers_resource_id_pattern_idx ON auth.sso_providers USING btree (resource_id text_pattern_ops);


--
-- TOC entry 4000 (class 1259 OID 17001)
-- Name: unique_phone_factor_per_user; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX unique_phone_factor_per_user ON auth.mfa_factors USING btree (user_id, phone);


--
-- TOC entry 3992 (class 1259 OID 16830)
-- Name: user_id_created_at_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX user_id_created_at_idx ON auth.sessions USING btree (user_id, created_at);


--
-- TOC entry 3941 (class 1259 OID 16910)
-- Name: users_email_partial_key; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX users_email_partial_key ON auth.users USING btree (email) WHERE (is_sso_user = false);


--
-- TOC entry 4679 (class 0 OID 0)
-- Dependencies: 3941
-- Name: INDEX users_email_partial_key; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON INDEX auth.users_email_partial_key IS 'Auth: A partial unique index that applies only when is_sso_user is false';


--
-- TOC entry 3942 (class 1259 OID 16748)
-- Name: users_instance_id_email_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX users_instance_id_email_idx ON auth.users USING btree (instance_id, lower((email)::text));


--
-- TOC entry 3943 (class 1259 OID 16505)
-- Name: users_instance_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX users_instance_id_idx ON auth.users USING btree (instance_id);


--
-- TOC entry 3944 (class 1259 OID 16965)
-- Name: users_is_anonymous_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX users_is_anonymous_idx ON auth.users USING btree (is_anonymous);


--
-- TOC entry 4063 (class 1259 OID 17450)
-- Name: ix_realtime_subscription_entity; Type: INDEX; Schema: realtime; Owner: -
--

CREATE INDEX ix_realtime_subscription_entity ON realtime.subscription USING btree (entity);


--
-- TOC entry 4067 (class 1259 OID 17451)
-- Name: messages_inserted_at_topic_index; Type: INDEX; Schema: realtime; Owner: -
--

CREATE INDEX messages_inserted_at_topic_index ON ONLY realtime.messages USING btree (inserted_at DESC, topic) WHERE ((extension = 'broadcast'::text) AND (private IS TRUE));


--
-- TOC entry 4066 (class 1259 OID 48156)
-- Name: subscription_subscription_id_entity_filters_action_filter_key; Type: INDEX; Schema: realtime; Owner: -
--

CREATE UNIQUE INDEX subscription_subscription_id_entity_filters_action_filter_key ON realtime.subscription USING btree (subscription_id, entity, filters, action_filter);


--
-- TOC entry 4192 (class 1259 OID 48568)
-- Name: idx_audit_logs_action; Type: INDEX; Schema: reserve; Owner: -
--

CREATE INDEX idx_audit_logs_action ON reserve.audit_logs USING btree (action);


--
-- TOC entry 4193 (class 1259 OID 48567)
-- Name: idx_audit_logs_actor; Type: INDEX; Schema: reserve; Owner: -
--

CREATE INDEX idx_audit_logs_actor ON reserve.audit_logs USING btree (actor_type, actor_id) WHERE (actor_id IS NOT NULL);


--
-- TOC entry 4194 (class 1259 OID 48572)
-- Name: idx_audit_logs_after; Type: INDEX; Schema: reserve; Owner: -
--

CREATE INDEX idx_audit_logs_after ON reserve.audit_logs USING gin (after_data jsonb_path_ops);


--
-- TOC entry 4195 (class 1259 OID 48571)
-- Name: idx_audit_logs_before; Type: INDEX; Schema: reserve; Owner: -
--

CREATE INDEX idx_audit_logs_before ON reserve.audit_logs USING gin (before_data jsonb_path_ops);


--
-- TOC entry 4196 (class 1259 OID 48569)
-- Name: idx_audit_logs_created; Type: INDEX; Schema: reserve; Owner: -
--

CREATE INDEX idx_audit_logs_created ON reserve.audit_logs USING btree (created_at DESC);


--
-- TOC entry 4197 (class 1259 OID 48570)
-- Name: idx_audit_logs_request; Type: INDEX; Schema: reserve; Owner: -
--

CREATE INDEX idx_audit_logs_request ON reserve.audit_logs USING btree (request_id) WHERE (request_id IS NOT NULL);


--
-- TOC entry 4198 (class 1259 OID 48566)
-- Name: idx_audit_logs_resource; Type: INDEX; Schema: reserve; Owner: -
--

CREATE INDEX idx_audit_logs_resource ON reserve.audit_logs USING btree (resource_type, resource_id) WHERE (resource_id IS NOT NULL);


--
-- TOC entry 4129 (class 1259 OID 48394)
-- Name: idx_availability_date; Type: INDEX; Schema: reserve; Owner: -
--

CREATE INDEX idx_availability_date ON reserve.availability_calendar USING btree (date);


--
-- TOC entry 4130 (class 1259 OID 48395)
-- Name: idx_availability_date_range; Type: INDEX; Schema: reserve; Owner: -
--

CREATE INDEX idx_availability_date_range ON reserve.availability_calendar USING btree (date, is_available, is_blocked) WHERE ((is_available = true) AND (is_blocked = false));


--
-- TOC entry 4131 (class 1259 OID 48393)
-- Name: idx_availability_rate_plan; Type: INDEX; Schema: reserve; Owner: -
--

CREATE INDEX idx_availability_rate_plan ON reserve.availability_calendar USING btree (rate_plan_id);


--
-- TOC entry 4132 (class 1259 OID 48397)
-- Name: idx_availability_search; Type: INDEX; Schema: reserve; Owner: -
--

CREATE INDEX idx_availability_search ON reserve.availability_calendar USING btree (unit_id, date, is_available, is_blocked, base_price) WHERE ((is_available = true) AND (is_blocked = false));


--
-- TOC entry 4133 (class 1259 OID 48392)
-- Name: idx_availability_unit; Type: INDEX; Schema: reserve; Owner: -
--

CREATE INDEX idx_availability_unit ON reserve.availability_calendar USING btree (unit_id);


--
-- TOC entry 4134 (class 1259 OID 48396)
-- Name: idx_availability_unit_date; Type: INDEX; Schema: reserve; Owner: -
--

CREATE INDEX idx_availability_unit_date ON reserve.availability_calendar USING btree (unit_id, date);


--
-- TOC entry 4088 (class 1259 OID 48269)
-- Name: idx_cities_active; Type: INDEX; Schema: reserve; Owner: -
--

CREATE INDEX idx_cities_active ON reserve.cities USING btree (is_active) WHERE (is_active = true);


--
-- TOC entry 4089 (class 1259 OID 48268)
-- Name: idx_cities_code; Type: INDEX; Schema: reserve; Owner: -
--

CREATE INDEX idx_cities_code ON reserve.cities USING btree (code);


--
-- TOC entry 4181 (class 1259 OID 48550)
-- Name: idx_events_actor; Type: INDEX; Schema: reserve; Owner: -
--

CREATE INDEX idx_events_actor ON reserve.events USING btree (actor_type, actor_id) WHERE (actor_id IS NOT NULL);


--
-- TOC entry 4182 (class 1259 OID 48553)
-- Name: idx_events_correlation; Type: INDEX; Schema: reserve; Owner: -
--

CREATE INDEX idx_events_correlation ON reserve.events USING btree (correlation_id) WHERE (correlation_id IS NOT NULL);


--
-- TOC entry 4183 (class 1259 OID 48552)
-- Name: idx_events_created; Type: INDEX; Schema: reserve; Owner: -
--

CREATE INDEX idx_events_created ON reserve.events USING btree (created_at DESC);


--
-- TOC entry 4184 (class 1259 OID 48549)
-- Name: idx_events_entity; Type: INDEX; Schema: reserve; Owner: -
--

CREATE INDEX idx_events_entity ON reserve.events USING btree (entity_type, entity_id);


--
-- TOC entry 4185 (class 1259 OID 48548)
-- Name: idx_events_name; Type: INDEX; Schema: reserve; Owner: -
--

CREATE INDEX idx_events_name ON reserve.events USING btree (event_name);


--
-- TOC entry 4186 (class 1259 OID 48555)
-- Name: idx_events_payload; Type: INDEX; Schema: reserve; Owner: -
--

CREATE INDEX idx_events_payload ON reserve.events USING gin (payload jsonb_path_ops);


--
-- TOC entry 4187 (class 1259 OID 48551)
-- Name: idx_events_severity; Type: INDEX; Schema: reserve; Owner: -
--

CREATE INDEX idx_events_severity ON reserve.events USING btree (severity);


--
-- TOC entry 4188 (class 1259 OID 48554)
-- Name: idx_events_unprocessed; Type: INDEX; Schema: reserve; Owner: -
--

CREATE INDEX idx_events_unprocessed ON reserve.events USING btree (processed_at) WHERE (processed_at IS NULL);


--
-- TOC entry 4189 (class 1259 OID 48746)
-- Name: idx_events_unprocessed_priority; Type: INDEX; Schema: reserve; Owner: -
--

CREATE INDEX idx_events_unprocessed_priority ON reserve.events USING btree (created_at, severity) WHERE (processed_at IS NULL);


--
-- TOC entry 4680 (class 0 OID 0)
-- Dependencies: 4189
-- Name: INDEX idx_events_unprocessed_priority; Type: COMMENT; Schema: reserve; Owner: -
--

COMMENT ON INDEX reserve.idx_events_unprocessed_priority IS 'Optimizes event processor queries for unprocessed events';


--
-- TOC entry 4201 (class 1259 OID 48607)
-- Name: idx_funnel_events_city; Type: INDEX; Schema: reserve; Owner: -
--

CREATE INDEX idx_funnel_events_city ON reserve.funnel_events USING btree (city_id) WHERE (city_id IS NOT NULL);


--
-- TOC entry 4202 (class 1259 OID 48608)
-- Name: idx_funnel_events_created; Type: INDEX; Schema: reserve; Owner: -
--

CREATE INDEX idx_funnel_events_created ON reserve.funnel_events USING btree (created_at DESC);


--
-- TOC entry 4203 (class 1259 OID 48606)
-- Name: idx_funnel_events_property; Type: INDEX; Schema: reserve; Owner: -
--

CREATE INDEX idx_funnel_events_property ON reserve.funnel_events USING btree (property_id) WHERE (property_id IS NOT NULL);


--
-- TOC entry 4204 (class 1259 OID 48610)
-- Name: idx_funnel_events_reservation; Type: INDEX; Schema: reserve; Owner: -
--

CREATE INDEX idx_funnel_events_reservation ON reserve.funnel_events USING btree (reservation_id) WHERE (reservation_id IS NOT NULL);


--
-- TOC entry 4205 (class 1259 OID 48792)
-- Name: idx_funnel_events_search; Type: INDEX; Schema: reserve; Owner: -
--

CREATE INDEX idx_funnel_events_search ON reserve.funnel_events USING btree (session_id, created_at DESC) WHERE (stage = 'search'::reserve.funnel_stage);


--
-- TOC entry 4681 (class 0 OID 0)
-- Dependencies: 4205
-- Name: INDEX idx_funnel_events_search; Type: COMMENT; Schema: reserve; Owner: -
--

COMMENT ON INDEX reserve.idx_funnel_events_search IS 'Optimizes funnel analysis for search events';


--
-- TOC entry 4206 (class 1259 OID 48603)
-- Name: idx_funnel_events_session; Type: INDEX; Schema: reserve; Owner: -
--

CREATE INDEX idx_funnel_events_session ON reserve.funnel_events USING btree (session_id);


--
-- TOC entry 4207 (class 1259 OID 48605)
-- Name: idx_funnel_events_stage; Type: INDEX; Schema: reserve; Owner: -
--

CREATE INDEX idx_funnel_events_stage ON reserve.funnel_events USING btree (stage);


--
-- TOC entry 4208 (class 1259 OID 48609)
-- Name: idx_funnel_events_utm; Type: INDEX; Schema: reserve; Owner: -
--

CREATE INDEX idx_funnel_events_utm ON reserve.funnel_events USING btree (utm_source, utm_medium) WHERE (utm_source IS NOT NULL);


--
-- TOC entry 4209 (class 1259 OID 48604)
-- Name: idx_funnel_events_visitor; Type: INDEX; Schema: reserve; Owner: -
--

CREATE INDEX idx_funnel_events_visitor ON reserve.funnel_events USING btree (visitor_id);


--
-- TOC entry 4210 (class 1259 OID 48661)
-- Name: idx_kpi_snapshots_city; Type: INDEX; Schema: reserve; Owner: -
--

CREATE INDEX idx_kpi_snapshots_city ON reserve.kpi_daily_snapshots USING btree (city_id) WHERE (city_id IS NOT NULL);


--
-- TOC entry 4211 (class 1259 OID 48660)
-- Name: idx_kpi_snapshots_date; Type: INDEX; Schema: reserve; Owner: -
--

CREATE INDEX idx_kpi_snapshots_date ON reserve.kpi_daily_snapshots USING btree (snapshot_date);


--
-- TOC entry 4212 (class 1259 OID 48662)
-- Name: idx_kpi_snapshots_property; Type: INDEX; Schema: reserve; Owner: -
--

CREATE INDEX idx_kpi_snapshots_property ON reserve.kpi_daily_snapshots USING btree (property_id) WHERE (property_id IS NOT NULL);


--
-- TOC entry 4213 (class 1259 OID 48663)
-- Name: idx_kpi_snapshots_range; Type: INDEX; Schema: reserve; Owner: -
--

CREATE INDEX idx_kpi_snapshots_range ON reserve.kpi_daily_snapshots USING btree (snapshot_date, city_id, property_id);


--
-- TOC entry 4090 (class 1259 OID 48298)
-- Name: idx_properties_map_active; Type: INDEX; Schema: reserve; Owner: -
--

CREATE INDEX idx_properties_map_active ON reserve.properties_map USING btree (is_active, is_published) WHERE ((is_active = true) AND (is_published = true));


--
-- TOC entry 4091 (class 1259 OID 48742)
-- Name: idx_properties_map_active_host; Type: INDEX; Schema: reserve; Owner: -
--

CREATE INDEX idx_properties_map_active_host ON reserve.properties_map USING btree (host_property_id, is_active) WHERE ((is_active = true) AND (deleted_at IS NULL));


--
-- TOC entry 4682 (class 0 OID 0)
-- Dependencies: 4091
-- Name: INDEX idx_properties_map_active_host; Type: COMMENT; Schema: reserve; Owner: -
--

COMMENT ON INDEX reserve.idx_properties_map_active_host IS 'Optimizes sync lookups for active properties by host ID';


--
-- TOC entry 4092 (class 1259 OID 50087)
-- Name: idx_properties_map_active_published; Type: INDEX; Schema: reserve; Owner: -
--

CREATE INDEX idx_properties_map_active_published ON reserve.properties_map USING btree (is_active, is_published, deleted_at) WHERE ((is_active = true) AND (is_published = true) AND (deleted_at IS NULL));


--
-- TOC entry 4093 (class 1259 OID 48296)
-- Name: idx_properties_map_city; Type: INDEX; Schema: reserve; Owner: -
--

CREATE INDEX idx_properties_map_city ON reserve.properties_map USING btree (city_id);


--
-- TOC entry 4094 (class 1259 OID 50080)
-- Name: idx_properties_map_city_published; Type: INDEX; Schema: reserve; Owner: -
--

CREATE INDEX idx_properties_map_city_published ON reserve.properties_map USING btree (city_id, is_published, is_active) WHERE ((is_published = true) AND (is_active = true) AND (deleted_at IS NULL));


--
-- TOC entry 4095 (class 1259 OID 48300)
-- Name: idx_properties_map_geo; Type: INDEX; Schema: reserve; Owner: -
--

CREATE INDEX idx_properties_map_geo ON reserve.properties_map USING gist (point((longitude)::double precision, (latitude)::double precision)) WHERE ((latitude IS NOT NULL) AND (longitude IS NOT NULL));


--
-- TOC entry 4096 (class 1259 OID 48295)
-- Name: idx_properties_map_host_id; Type: INDEX; Schema: reserve; Owner: -
--

CREATE INDEX idx_properties_map_host_id ON reserve.properties_map USING btree (host_property_id);


--
-- TOC entry 4097 (class 1259 OID 48299)
-- Name: idx_properties_map_location; Type: INDEX; Schema: reserve; Owner: -
--

CREATE INDEX idx_properties_map_location ON reserve.properties_map USING btree (latitude, longitude) WHERE ((latitude IS NOT NULL) AND (longitude IS NOT NULL));


--
-- TOC entry 4098 (class 1259 OID 48297)
-- Name: idx_properties_map_slug; Type: INDEX; Schema: reserve; Owner: -
--

CREATE INDEX idx_properties_map_slug ON reserve.properties_map USING btree (slug);


--
-- TOC entry 4099 (class 1259 OID 50084)
-- Name: idx_properties_map_slug_lookup; Type: INDEX; Schema: reserve; Owner: -
--

CREATE INDEX idx_properties_map_slug_lookup ON reserve.properties_map USING btree (slug, is_published, is_active) WHERE ((is_published = true) AND (is_active = true) AND (deleted_at IS NULL));


--
-- TOC entry 4119 (class 1259 OID 48355)
-- Name: idx_rate_plans_active; Type: INDEX; Schema: reserve; Owner: -
--

CREATE INDEX idx_rate_plans_active ON reserve.rate_plans USING btree (is_active) WHERE (is_active = true);


--
-- TOC entry 4120 (class 1259 OID 48356)
-- Name: idx_rate_plans_channels; Type: INDEX; Schema: reserve; Owner: -
--

CREATE INDEX idx_rate_plans_channels ON reserve.rate_plans USING gin (channels_enabled);


--
-- TOC entry 4121 (class 1259 OID 48357)
-- Name: idx_rate_plans_host_id; Type: INDEX; Schema: reserve; Owner: -
--

CREATE INDEX idx_rate_plans_host_id ON reserve.rate_plans USING btree (host_rate_plan_id) WHERE (host_rate_plan_id IS NOT NULL);


--
-- TOC entry 4122 (class 1259 OID 48354)
-- Name: idx_rate_plans_property; Type: INDEX; Schema: reserve; Owner: -
--

CREATE INDEX idx_rate_plans_property ON reserve.rate_plans USING btree (property_id);


--
-- TOC entry 4145 (class 1259 OID 48483)
-- Name: idx_reservations_active; Type: INDEX; Schema: reserve; Owner: -
--

CREATE INDEX idx_reservations_active ON reserve.reservations USING btree (property_id, check_in, check_out, status) WHERE (status = ANY (ARRAY['pending'::reserve.reservation_status, 'confirmed'::reserve.reservation_status, 'checked_in'::reserve.reservation_status]));


--
-- TOC entry 4146 (class 1259 OID 48482)
-- Name: idx_reservations_booked_at; Type: INDEX; Schema: reserve; Owner: -
--

CREATE INDEX idx_reservations_booked_at ON reserve.reservations USING btree (booked_at DESC);


--
-- TOC entry 4147 (class 1259 OID 48477)
-- Name: idx_reservations_checkin; Type: INDEX; Schema: reserve; Owner: -
--

CREATE INDEX idx_reservations_checkin ON reserve.reservations USING btree (check_in) WHERE (status = ANY (ARRAY['confirmed'::reserve.reservation_status, 'checked_in'::reserve.reservation_status]));


--
-- TOC entry 4148 (class 1259 OID 48480)
-- Name: idx_reservations_confirmation; Type: INDEX; Schema: reserve; Owner: -
--

CREATE INDEX idx_reservations_confirmation ON reserve.reservations USING btree (confirmation_code);


--
-- TOC entry 4149 (class 1259 OID 48476)
-- Name: idx_reservations_dates; Type: INDEX; Schema: reserve; Owner: -
--

CREATE INDEX idx_reservations_dates ON reserve.reservations USING btree (check_in, check_out);


--
-- TOC entry 4150 (class 1259 OID 48481)
-- Name: idx_reservations_ota; Type: INDEX; Schema: reserve; Owner: -
--

CREATE INDEX idx_reservations_ota ON reserve.reservations USING btree (ota_booking_id) WHERE (ota_booking_id IS NOT NULL);


--
-- TOC entry 4151 (class 1259 OID 48474)
-- Name: idx_reservations_property; Type: INDEX; Schema: reserve; Owner: -
--

CREATE INDEX idx_reservations_property ON reserve.reservations USING btree (property_id);


--
-- TOC entry 4152 (class 1259 OID 48479)
-- Name: idx_reservations_source; Type: INDEX; Schema: reserve; Owner: -
--

CREATE INDEX idx_reservations_source ON reserve.reservations USING btree (source);


--
-- TOC entry 4153 (class 1259 OID 48478)
-- Name: idx_reservations_status; Type: INDEX; Schema: reserve; Owner: -
--

CREATE INDEX idx_reservations_status ON reserve.reservations USING btree (status);


--
-- TOC entry 4154 (class 1259 OID 48473)
-- Name: idx_reservations_traveler; Type: INDEX; Schema: reserve; Owner: -
--

CREATE INDEX idx_reservations_traveler ON reserve.reservations USING btree (traveler_id) WHERE (traveler_id IS NOT NULL);


--
-- TOC entry 4155 (class 1259 OID 48475)
-- Name: idx_reservations_unit; Type: INDEX; Schema: reserve; Owner: -
--

CREATE INDEX idx_reservations_unit ON reserve.reservations USING btree (unit_id);


--
-- TOC entry 4160 (class 1259 OID 48743)
-- Name: idx_sync_jobs_correlation; Type: INDEX; Schema: reserve; Owner: -
--

CREATE INDEX idx_sync_jobs_correlation ON reserve.sync_jobs USING gin (((metadata -> 'correlation_id'::text)));


--
-- TOC entry 4683 (class 0 OID 0)
-- Dependencies: 4160
-- Name: INDEX idx_sync_jobs_correlation; Type: COMMENT; Schema: reserve; Owner: -
--

COMMENT ON INDEX reserve.idx_sync_jobs_correlation IS 'Enables querying sync jobs by correlation ID for distributed tracing';


--
-- TOC entry 4161 (class 1259 OID 48513)
-- Name: idx_sync_jobs_created; Type: INDEX; Schema: reserve; Owner: -
--

CREATE INDEX idx_sync_jobs_created ON reserve.sync_jobs USING btree (created_at DESC);


--
-- TOC entry 4162 (class 1259 OID 48514)
-- Name: idx_sync_jobs_dates; Type: INDEX; Schema: reserve; Owner: -
--

CREATE INDEX idx_sync_jobs_dates ON reserve.sync_jobs USING btree (date_from, date_to) WHERE (date_from IS NOT NULL);


--
-- TOC entry 4163 (class 1259 OID 48512)
-- Name: idx_sync_jobs_pending; Type: INDEX; Schema: reserve; Owner: -
--

CREATE INDEX idx_sync_jobs_pending ON reserve.sync_jobs USING btree (status, priority, created_at) WHERE (status = ANY (ARRAY['pending'::reserve.sync_status, 'retrying'::reserve.sync_status]));


--
-- TOC entry 4164 (class 1259 OID 48511)
-- Name: idx_sync_jobs_property; Type: INDEX; Schema: reserve; Owner: -
--

CREATE INDEX idx_sync_jobs_property ON reserve.sync_jobs USING btree (property_id) WHERE (property_id IS NOT NULL);


--
-- TOC entry 4165 (class 1259 OID 48744)
-- Name: idx_sync_jobs_retry; Type: INDEX; Schema: reserve; Owner: -
--

CREATE INDEX idx_sync_jobs_retry ON reserve.sync_jobs USING btree (status, retry_count, updated_at) WHERE ((status = ANY (ARRAY['failed'::reserve.sync_status, 'retrying'::reserve.sync_status])) AND (retry_count < max_retries));


--
-- TOC entry 4166 (class 1259 OID 48509)
-- Name: idx_sync_jobs_status; Type: INDEX; Schema: reserve; Owner: -
--

CREATE INDEX idx_sync_jobs_status ON reserve.sync_jobs USING btree (status);


--
-- TOC entry 4167 (class 1259 OID 50082)
-- Name: idx_sync_jobs_status_created; Type: INDEX; Schema: reserve; Owner: -
--

CREATE INDEX idx_sync_jobs_status_created ON reserve.sync_jobs USING btree (status, created_at DESC);


--
-- TOC entry 4168 (class 1259 OID 48510)
-- Name: idx_sync_jobs_type; Type: INDEX; Schema: reserve; Owner: -
--

CREATE INDEX idx_sync_jobs_type ON reserve.sync_jobs USING btree (job_type);


--
-- TOC entry 4171 (class 1259 OID 48745)
-- Name: idx_sync_logs_action; Type: INDEX; Schema: reserve; Owner: -
--

CREATE INDEX idx_sync_logs_action ON reserve.sync_logs USING btree (action) WHERE ((action)::text = ANY ((ARRAY['insert'::character varying, 'update'::character varying, 'delete'::character varying])::text[]));


--
-- TOC entry 4684 (class 0 OID 0)
-- Dependencies: 4171
-- Name: INDEX idx_sync_logs_action; Type: COMMENT; Schema: reserve; Owner: -
--

COMMENT ON INDEX reserve.idx_sync_logs_action IS 'Optimizes queries for specific sync actions';


--
-- TOC entry 4172 (class 1259 OID 50083)
-- Name: idx_sync_logs_action_created; Type: INDEX; Schema: reserve; Owner: -
--

CREATE INDEX idx_sync_logs_action_created ON reserve.sync_logs USING btree (action, created_at DESC);


--
-- TOC entry 4173 (class 1259 OID 48532)
-- Name: idx_sync_logs_created; Type: INDEX; Schema: reserve; Owner: -
--

CREATE INDEX idx_sync_logs_created ON reserve.sync_logs USING btree (created_at DESC);


--
-- TOC entry 4174 (class 1259 OID 48530)
-- Name: idx_sync_logs_job; Type: INDEX; Schema: reserve; Owner: -
--

CREATE INDEX idx_sync_logs_job ON reserve.sync_logs USING btree (sync_job_id);


--
-- TOC entry 4175 (class 1259 OID 48531)
-- Name: idx_sync_logs_level; Type: INDEX; Schema: reserve; Owner: -
--

CREATE INDEX idx_sync_logs_level ON reserve.sync_logs USING btree (log_level);


--
-- TOC entry 4176 (class 1259 OID 48533)
-- Name: idx_sync_logs_record; Type: INDEX; Schema: reserve; Owner: -
--

CREATE INDEX idx_sync_logs_record ON reserve.sync_logs USING btree (record_type, record_id) WHERE (record_id IS NOT NULL);


--
-- TOC entry 4137 (class 1259 OID 48417)
-- Name: idx_travelers_auth; Type: INDEX; Schema: reserve; Owner: -
--

CREATE INDEX idx_travelers_auth ON reserve.travelers USING btree (auth_user_id) WHERE (auth_user_id IS NOT NULL);


--
-- TOC entry 4138 (class 1259 OID 48418)
-- Name: idx_travelers_email; Type: INDEX; Schema: reserve; Owner: -
--

CREATE INDEX idx_travelers_email ON reserve.travelers USING btree (email);


--
-- TOC entry 4139 (class 1259 OID 48421)
-- Name: idx_travelers_name; Type: INDEX; Schema: reserve; Owner: -
--

CREATE INDEX idx_travelers_name ON reserve.travelers USING btree (last_name, first_name) WHERE (deleted_at IS NULL);


--
-- TOC entry 4140 (class 1259 OID 48420)
-- Name: idx_travelers_phone; Type: INDEX; Schema: reserve; Owner: -
--

CREATE INDEX idx_travelers_phone ON reserve.travelers USING btree (phone) WHERE (phone IS NOT NULL);


--
-- TOC entry 4141 (class 1259 OID 48419)
-- Name: idx_travelers_unique_email; Type: INDEX; Schema: reserve; Owner: -
--

CREATE UNIQUE INDEX idx_travelers_unique_email ON reserve.travelers USING btree (email) WHERE (deleted_at IS NULL);


--
-- TOC entry 4142 (class 1259 OID 48422)
-- Name: idx_travelers_verified; Type: INDEX; Schema: reserve; Owner: -
--

CREATE INDEX idx_travelers_verified ON reserve.travelers USING btree (is_verified) WHERE (is_verified = true);


--
-- TOC entry 4104 (class 1259 OID 48327)
-- Name: idx_unit_map_active; Type: INDEX; Schema: reserve; Owner: -
--

CREATE INDEX idx_unit_map_active ON reserve.unit_map USING btree (is_active) WHERE (is_active = true);


--
-- TOC entry 4105 (class 1259 OID 48791)
-- Name: idx_unit_map_capacity; Type: INDEX; Schema: reserve; Owner: -
--

CREATE INDEX idx_unit_map_capacity ON reserve.unit_map USING btree (max_occupancy, base_capacity) WHERE ((is_active = true) AND (deleted_at IS NULL));


--
-- TOC entry 4685 (class 0 OID 0)
-- Dependencies: 4105
-- Name: INDEX idx_unit_map_capacity; Type: COMMENT; Schema: reserve; Owner: -
--

COMMENT ON INDEX reserve.idx_unit_map_capacity IS 'Supports filtering room types by guest capacity';


--
-- TOC entry 4106 (class 1259 OID 48325)
-- Name: idx_unit_map_host_id; Type: INDEX; Schema: reserve; Owner: -
--

CREATE INDEX idx_unit_map_host_id ON reserve.unit_map USING btree (host_unit_id);


--
-- TOC entry 4107 (class 1259 OID 48739)
-- Name: idx_unit_map_host_property; Type: INDEX; Schema: reserve; Owner: -
--

CREATE INDEX idx_unit_map_host_property ON reserve.unit_map USING btree (host_property_id);


--
-- TOC entry 4686 (class 0 OID 0)
-- Dependencies: 4107
-- Name: INDEX idx_unit_map_host_property; Type: COMMENT; Schema: reserve; Owner: -
--

COMMENT ON INDEX reserve.idx_unit_map_host_property IS 'Allows efficient lookup of units by host property ID during sync operations';


--
-- TOC entry 4108 (class 1259 OID 50081)
-- Name: idx_unit_map_host_property_unit; Type: INDEX; Schema: reserve; Owner: -
--

CREATE INDEX idx_unit_map_host_property_unit ON reserve.unit_map USING btree (host_property_id, unit_type, is_active, max_occupancy) WHERE ((is_active = true) AND (deleted_at IS NULL));


--
-- TOC entry 4109 (class 1259 OID 48328)
-- Name: idx_unit_map_occupancy; Type: INDEX; Schema: reserve; Owner: -
--

CREATE INDEX idx_unit_map_occupancy ON reserve.unit_map USING btree (max_occupancy, base_capacity) WHERE (is_active = true);


--
-- TOC entry 4110 (class 1259 OID 48326)
-- Name: idx_unit_map_property; Type: INDEX; Schema: reserve; Owner: -
--

CREATE INDEX idx_unit_map_property ON reserve.unit_map USING btree (property_id);


--
-- TOC entry 4111 (class 1259 OID 50085)
-- Name: idx_unit_map_property_active; Type: INDEX; Schema: reserve; Owner: -
--

CREATE INDEX idx_unit_map_property_active ON reserve.unit_map USING btree (property_id, is_active, deleted_at) WHERE ((is_active = true) AND (deleted_at IS NULL));


--
-- TOC entry 4112 (class 1259 OID 48741)
-- Name: idx_unit_map_property_unit; Type: INDEX; Schema: reserve; Owner: -
--

CREATE INDEX idx_unit_map_property_unit ON reserve.unit_map USING btree (property_id, host_unit_id);


--
-- TOC entry 4113 (class 1259 OID 48790)
-- Name: idx_unit_map_search; Type: INDEX; Schema: reserve; Owner: -
--

CREATE INDEX idx_unit_map_search ON reserve.unit_map USING btree (property_id, unit_type, is_active, deleted_at) WHERE (((unit_type)::text = 'room_type'::text) AND (is_active = true) AND (deleted_at IS NULL));


--
-- TOC entry 4687 (class 0 OID 0)
-- Dependencies: 4113
-- Name: INDEX idx_unit_map_search; Type: COMMENT; Schema: reserve; Owner: -
--

COMMENT ON INDEX reserve.idx_unit_map_search IS 'Optimizes availability search queries by property and unit type';


--
-- TOC entry 4114 (class 1259 OID 48740)
-- Name: idx_unit_map_type; Type: INDEX; Schema: reserve; Owner: -
--

CREATE INDEX idx_unit_map_type ON reserve.unit_map USING btree (unit_type) WHERE (unit_type IS NOT NULL);


--
-- TOC entry 3965 (class 1259 OID 16560)
-- Name: bname; Type: INDEX; Schema: storage; Owner: -
--

CREATE UNIQUE INDEX bname ON storage.buckets USING btree (name);


--
-- TOC entry 3968 (class 1259 OID 16582)
-- Name: bucketid_objname; Type: INDEX; Schema: storage; Owner: -
--

CREATE UNIQUE INDEX bucketid_objname ON storage.objects USING btree (bucket_id, name);


--
-- TOC entry 4062 (class 1259 OID 31205)
-- Name: buckets_analytics_unique_name_idx; Type: INDEX; Schema: storage; Owner: -
--

CREATE UNIQUE INDEX buckets_analytics_unique_name_idx ON storage.buckets_analytics USING btree (name) WHERE (deleted_at IS NULL);


--
-- TOC entry 4055 (class 1259 OID 17183)
-- Name: idx_multipart_uploads_list; Type: INDEX; Schema: storage; Owner: -
--

CREATE INDEX idx_multipart_uploads_list ON storage.s3_multipart_uploads USING btree (bucket_id, key, created_at);


--
-- TOC entry 3969 (class 1259 OID 17148)
-- Name: idx_objects_bucket_id_name; Type: INDEX; Schema: storage; Owner: -
--

CREATE INDEX idx_objects_bucket_id_name ON storage.objects USING btree (bucket_id, name COLLATE "C");


--
-- TOC entry 3970 (class 1259 OID 47595)
-- Name: idx_objects_bucket_id_name_lower; Type: INDEX; Schema: storage; Owner: -
--

CREATE INDEX idx_objects_bucket_id_name_lower ON storage.objects USING btree (bucket_id, lower(name) COLLATE "C");


--
-- TOC entry 3971 (class 1259 OID 16583)
-- Name: name_prefix_search; Type: INDEX; Schema: storage; Owner: -
--

CREATE INDEX name_prefix_search ON storage.objects USING btree (name text_pattern_ops);


--
-- TOC entry 4076 (class 1259 OID 31196)
-- Name: vector_indexes_name_bucket_id_idx; Type: INDEX; Schema: storage; Owner: -
--

CREATE UNIQUE INDEX vector_indexes_name_bucket_id_idx ON storage.vector_indexes USING btree (name, bucket_id);


--
-- TOC entry 4426 (class 2618 OID 48705)
-- Name: active_properties_view _RETURN; Type: RULE; Schema: reserve; Owner: -
--

CREATE OR REPLACE VIEW reserve.active_properties_view AS
 SELECT p.id,
    p.host_property_id,
    p.name,
    p.slug,
    p.city_id,
    c.name AS city_name,
    p.property_type,
    p.latitude,
    p.longitude,
    p.rating_cached,
    p.review_count_cached,
    p.is_active,
    p.is_published,
    p.created_at,
    count(DISTINCT u.id) AS unit_count,
    count(DISTINCT rp.id) AS rate_plan_count
   FROM (((reserve.properties_map p
     JOIN reserve.cities c ON ((p.city_id = c.id)))
     LEFT JOIN reserve.unit_map u ON (((p.id = u.property_id) AND (u.is_active = true) AND (u.deleted_at IS NULL))))
     LEFT JOIN reserve.rate_plans rp ON (((p.id = rp.property_id) AND (rp.is_active = true) AND (rp.deleted_at IS NULL))))
  WHERE ((p.is_active = true) AND (p.deleted_at IS NULL))
  GROUP BY p.id, c.name;


--
-- TOC entry 4267 (class 2620 OID 17306)
-- Name: subscription tr_check_filters; Type: TRIGGER; Schema: realtime; Owner: -
--

CREATE TRIGGER tr_check_filters BEFORE INSERT OR UPDATE ON realtime.subscription FOR EACH ROW EXECUTE FUNCTION realtime.subscription_check_filters();


--
-- TOC entry 4274 (class 2620 OID 48700)
-- Name: reservations calculate_nights; Type: TRIGGER; Schema: reserve; Owner: -
--

CREATE TRIGGER calculate_nights BEFORE INSERT OR UPDATE OF check_in, check_out ON reserve.reservations FOR EACH ROW EXECUTE FUNCTION reserve.calculate_reservation_nights();


--
-- TOC entry 4272 (class 2620 OID 48694)
-- Name: availability_calendar set_updated_at; Type: TRIGGER; Schema: reserve; Owner: -
--

CREATE TRIGGER set_updated_at BEFORE UPDATE ON reserve.availability_calendar FOR EACH ROW EXECUTE FUNCTION reserve.set_updated_at();


--
-- TOC entry 4268 (class 2620 OID 48690)
-- Name: cities set_updated_at; Type: TRIGGER; Schema: reserve; Owner: -
--

CREATE TRIGGER set_updated_at BEFORE UPDATE ON reserve.cities FOR EACH ROW EXECUTE FUNCTION reserve.set_updated_at();


--
-- TOC entry 4277 (class 2620 OID 48698)
-- Name: kpi_daily_snapshots set_updated_at; Type: TRIGGER; Schema: reserve; Owner: -
--

CREATE TRIGGER set_updated_at BEFORE UPDATE ON reserve.kpi_daily_snapshots FOR EACH ROW EXECUTE FUNCTION reserve.set_updated_at();


--
-- TOC entry 4269 (class 2620 OID 48691)
-- Name: properties_map set_updated_at; Type: TRIGGER; Schema: reserve; Owner: -
--

CREATE TRIGGER set_updated_at BEFORE UPDATE ON reserve.properties_map FOR EACH ROW EXECUTE FUNCTION reserve.set_updated_at();


--
-- TOC entry 4271 (class 2620 OID 48693)
-- Name: rate_plans set_updated_at; Type: TRIGGER; Schema: reserve; Owner: -
--

CREATE TRIGGER set_updated_at BEFORE UPDATE ON reserve.rate_plans FOR EACH ROW EXECUTE FUNCTION reserve.set_updated_at();


--
-- TOC entry 4275 (class 2620 OID 48696)
-- Name: reservations set_updated_at; Type: TRIGGER; Schema: reserve; Owner: -
--

CREATE TRIGGER set_updated_at BEFORE UPDATE ON reserve.reservations FOR EACH ROW EXECUTE FUNCTION reserve.set_updated_at();


--
-- TOC entry 4276 (class 2620 OID 48697)
-- Name: sync_jobs set_updated_at; Type: TRIGGER; Schema: reserve; Owner: -
--

CREATE TRIGGER set_updated_at BEFORE UPDATE ON reserve.sync_jobs FOR EACH ROW EXECUTE FUNCTION reserve.set_updated_at();


--
-- TOC entry 4273 (class 2620 OID 48695)
-- Name: travelers set_updated_at; Type: TRIGGER; Schema: reserve; Owner: -
--

CREATE TRIGGER set_updated_at BEFORE UPDATE ON reserve.travelers FOR EACH ROW EXECUTE FUNCTION reserve.set_updated_at();


--
-- TOC entry 4270 (class 2620 OID 48692)
-- Name: unit_map set_updated_at; Type: TRIGGER; Schema: reserve; Owner: -
--

CREATE TRIGGER set_updated_at BEFORE UPDATE ON reserve.unit_map FOR EACH ROW EXECUTE FUNCTION reserve.set_updated_at();


--
-- TOC entry 4263 (class 2620 OID 17239)
-- Name: buckets enforce_bucket_name_length_trigger; Type: TRIGGER; Schema: storage; Owner: -
--

CREATE TRIGGER enforce_bucket_name_length_trigger BEFORE INSERT OR UPDATE OF name ON storage.buckets FOR EACH ROW EXECUTE FUNCTION storage.enforce_bucket_name_length();


--
-- TOC entry 4264 (class 2620 OID 47597)
-- Name: buckets protect_buckets_delete; Type: TRIGGER; Schema: storage; Owner: -
--

CREATE TRIGGER protect_buckets_delete BEFORE DELETE ON storage.buckets FOR EACH STATEMENT EXECUTE FUNCTION storage.protect_delete();


--
-- TOC entry 4265 (class 2620 OID 47598)
-- Name: objects protect_objects_delete; Type: TRIGGER; Schema: storage; Owner: -
--

CREATE TRIGGER protect_objects_delete BEFORE DELETE ON storage.objects FOR EACH STATEMENT EXECUTE FUNCTION storage.protect_delete();


--
-- TOC entry 4266 (class 2620 OID 17136)
-- Name: objects update_objects_updated_at; Type: TRIGGER; Schema: storage; Owner: -
--

CREATE TRIGGER update_objects_updated_at BEFORE UPDATE ON storage.objects FOR EACH ROW EXECUTE FUNCTION storage.update_updated_at_column();


--
-- TOC entry 4224 (class 2606 OID 16734)
-- Name: identities identities_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.identities
    ADD CONSTRAINT identities_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- TOC entry 4229 (class 2606 OID 16823)
-- Name: mfa_amr_claims mfa_amr_claims_session_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.mfa_amr_claims
    ADD CONSTRAINT mfa_amr_claims_session_id_fkey FOREIGN KEY (session_id) REFERENCES auth.sessions(id) ON DELETE CASCADE;


--
-- TOC entry 4228 (class 2606 OID 16811)
-- Name: mfa_challenges mfa_challenges_auth_factor_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.mfa_challenges
    ADD CONSTRAINT mfa_challenges_auth_factor_id_fkey FOREIGN KEY (factor_id) REFERENCES auth.mfa_factors(id) ON DELETE CASCADE;


--
-- TOC entry 4227 (class 2606 OID 16798)
-- Name: mfa_factors mfa_factors_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.mfa_factors
    ADD CONSTRAINT mfa_factors_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- TOC entry 4235 (class 2606 OID 17063)
-- Name: oauth_authorizations oauth_authorizations_client_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.oauth_authorizations
    ADD CONSTRAINT oauth_authorizations_client_id_fkey FOREIGN KEY (client_id) REFERENCES auth.oauth_clients(id) ON DELETE CASCADE;


--
-- TOC entry 4236 (class 2606 OID 17068)
-- Name: oauth_authorizations oauth_authorizations_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.oauth_authorizations
    ADD CONSTRAINT oauth_authorizations_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- TOC entry 4237 (class 2606 OID 17092)
-- Name: oauth_consents oauth_consents_client_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.oauth_consents
    ADD CONSTRAINT oauth_consents_client_id_fkey FOREIGN KEY (client_id) REFERENCES auth.oauth_clients(id) ON DELETE CASCADE;


--
-- TOC entry 4238 (class 2606 OID 17087)
-- Name: oauth_consents oauth_consents_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.oauth_consents
    ADD CONSTRAINT oauth_consents_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- TOC entry 4234 (class 2606 OID 16989)
-- Name: one_time_tokens one_time_tokens_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.one_time_tokens
    ADD CONSTRAINT one_time_tokens_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- TOC entry 4222 (class 2606 OID 16767)
-- Name: refresh_tokens refresh_tokens_session_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.refresh_tokens
    ADD CONSTRAINT refresh_tokens_session_id_fkey FOREIGN KEY (session_id) REFERENCES auth.sessions(id) ON DELETE CASCADE;


--
-- TOC entry 4231 (class 2606 OID 16870)
-- Name: saml_providers saml_providers_sso_provider_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.saml_providers
    ADD CONSTRAINT saml_providers_sso_provider_id_fkey FOREIGN KEY (sso_provider_id) REFERENCES auth.sso_providers(id) ON DELETE CASCADE;


--
-- TOC entry 4232 (class 2606 OID 16943)
-- Name: saml_relay_states saml_relay_states_flow_state_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.saml_relay_states
    ADD CONSTRAINT saml_relay_states_flow_state_id_fkey FOREIGN KEY (flow_state_id) REFERENCES auth.flow_state(id) ON DELETE CASCADE;


--
-- TOC entry 4233 (class 2606 OID 16884)
-- Name: saml_relay_states saml_relay_states_sso_provider_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.saml_relay_states
    ADD CONSTRAINT saml_relay_states_sso_provider_id_fkey FOREIGN KEY (sso_provider_id) REFERENCES auth.sso_providers(id) ON DELETE CASCADE;


--
-- TOC entry 4225 (class 2606 OID 17106)
-- Name: sessions sessions_oauth_client_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.sessions
    ADD CONSTRAINT sessions_oauth_client_id_fkey FOREIGN KEY (oauth_client_id) REFERENCES auth.oauth_clients(id) ON DELETE CASCADE;


--
-- TOC entry 4226 (class 2606 OID 16762)
-- Name: sessions sessions_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.sessions
    ADD CONSTRAINT sessions_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- TOC entry 4230 (class 2606 OID 16851)
-- Name: sso_domains sso_domains_sso_provider_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.sso_domains
    ADD CONSTRAINT sso_domains_sso_provider_id_fkey FOREIGN KEY (sso_provider_id) REFERENCES auth.sso_providers(id) ON DELETE CASCADE;


--
-- TOC entry 4246 (class 2606 OID 48387)
-- Name: availability_calendar availability_calendar_rate_plan_id_fkey; Type: FK CONSTRAINT; Schema: reserve; Owner: -
--

ALTER TABLE ONLY reserve.availability_calendar
    ADD CONSTRAINT availability_calendar_rate_plan_id_fkey FOREIGN KEY (rate_plan_id) REFERENCES reserve.rate_plans(id) ON DELETE CASCADE;


--
-- TOC entry 4247 (class 2606 OID 48382)
-- Name: availability_calendar availability_calendar_unit_id_fkey; Type: FK CONSTRAINT; Schema: reserve; Owner: -
--

ALTER TABLE ONLY reserve.availability_calendar
    ADD CONSTRAINT availability_calendar_unit_id_fkey FOREIGN KEY (unit_id) REFERENCES reserve.unit_map(id) ON DELETE CASCADE;


--
-- TOC entry 4256 (class 2606 OID 48583)
-- Name: funnel_events funnel_events_city_id_fkey; Type: FK CONSTRAINT; Schema: reserve; Owner: -
--

ALTER TABLE ONLY reserve.funnel_events
    ADD CONSTRAINT funnel_events_city_id_fkey FOREIGN KEY (city_id) REFERENCES reserve.cities(id);


--
-- TOC entry 4257 (class 2606 OID 48588)
-- Name: funnel_events funnel_events_property_id_fkey; Type: FK CONSTRAINT; Schema: reserve; Owner: -
--

ALTER TABLE ONLY reserve.funnel_events
    ADD CONSTRAINT funnel_events_property_id_fkey FOREIGN KEY (property_id) REFERENCES reserve.properties_map(id);


--
-- TOC entry 4258 (class 2606 OID 48598)
-- Name: funnel_events funnel_events_reservation_id_fkey; Type: FK CONSTRAINT; Schema: reserve; Owner: -
--

ALTER TABLE ONLY reserve.funnel_events
    ADD CONSTRAINT funnel_events_reservation_id_fkey FOREIGN KEY (reservation_id) REFERENCES reserve.reservations(id);


--
-- TOC entry 4259 (class 2606 OID 48593)
-- Name: funnel_events funnel_events_unit_id_fkey; Type: FK CONSTRAINT; Schema: reserve; Owner: -
--

ALTER TABLE ONLY reserve.funnel_events
    ADD CONSTRAINT funnel_events_unit_id_fkey FOREIGN KEY (unit_id) REFERENCES reserve.unit_map(id);


--
-- TOC entry 4260 (class 2606 OID 48650)
-- Name: kpi_daily_snapshots kpi_daily_snapshots_city_id_fkey; Type: FK CONSTRAINT; Schema: reserve; Owner: -
--

ALTER TABLE ONLY reserve.kpi_daily_snapshots
    ADD CONSTRAINT kpi_daily_snapshots_city_id_fkey FOREIGN KEY (city_id) REFERENCES reserve.cities(id);


--
-- TOC entry 4261 (class 2606 OID 48655)
-- Name: kpi_daily_snapshots kpi_daily_snapshots_property_id_fkey; Type: FK CONSTRAINT; Schema: reserve; Owner: -
--

ALTER TABLE ONLY reserve.kpi_daily_snapshots
    ADD CONSTRAINT kpi_daily_snapshots_property_id_fkey FOREIGN KEY (property_id) REFERENCES reserve.properties_map(id);


--
-- TOC entry 4243 (class 2606 OID 48290)
-- Name: properties_map properties_map_city_id_fkey; Type: FK CONSTRAINT; Schema: reserve; Owner: -
--

ALTER TABLE ONLY reserve.properties_map
    ADD CONSTRAINT properties_map_city_id_fkey FOREIGN KEY (city_id) REFERENCES reserve.cities(id);


--
-- TOC entry 4245 (class 2606 OID 48349)
-- Name: rate_plans rate_plans_property_id_fkey; Type: FK CONSTRAINT; Schema: reserve; Owner: -
--

ALTER TABLE ONLY reserve.rate_plans
    ADD CONSTRAINT rate_plans_property_id_fkey FOREIGN KEY (property_id) REFERENCES reserve.properties_map(id) ON DELETE CASCADE;


--
-- TOC entry 4249 (class 2606 OID 48458)
-- Name: reservations reservations_property_id_fkey; Type: FK CONSTRAINT; Schema: reserve; Owner: -
--

ALTER TABLE ONLY reserve.reservations
    ADD CONSTRAINT reservations_property_id_fkey FOREIGN KEY (property_id) REFERENCES reserve.properties_map(id);


--
-- TOC entry 4250 (class 2606 OID 48468)
-- Name: reservations reservations_rate_plan_id_fkey; Type: FK CONSTRAINT; Schema: reserve; Owner: -
--

ALTER TABLE ONLY reserve.reservations
    ADD CONSTRAINT reservations_rate_plan_id_fkey FOREIGN KEY (rate_plan_id) REFERENCES reserve.rate_plans(id);


--
-- TOC entry 4251 (class 2606 OID 48453)
-- Name: reservations reservations_traveler_id_fkey; Type: FK CONSTRAINT; Schema: reserve; Owner: -
--

ALTER TABLE ONLY reserve.reservations
    ADD CONSTRAINT reservations_traveler_id_fkey FOREIGN KEY (traveler_id) REFERENCES reserve.travelers(id) ON DELETE SET NULL;


--
-- TOC entry 4252 (class 2606 OID 48463)
-- Name: reservations reservations_unit_id_fkey; Type: FK CONSTRAINT; Schema: reserve; Owner: -
--

ALTER TABLE ONLY reserve.reservations
    ADD CONSTRAINT reservations_unit_id_fkey FOREIGN KEY (unit_id) REFERENCES reserve.unit_map(id);


--
-- TOC entry 4262 (class 2606 OID 48771)
-- Name: search_config search_config_updated_by_fkey; Type: FK CONSTRAINT; Schema: reserve; Owner: -
--

ALTER TABLE ONLY reserve.search_config
    ADD CONSTRAINT search_config_updated_by_fkey FOREIGN KEY (updated_by) REFERENCES auth.users(id);


--
-- TOC entry 4253 (class 2606 OID 48504)
-- Name: sync_jobs sync_jobs_city_id_fkey; Type: FK CONSTRAINT; Schema: reserve; Owner: -
--

ALTER TABLE ONLY reserve.sync_jobs
    ADD CONSTRAINT sync_jobs_city_id_fkey FOREIGN KEY (city_id) REFERENCES reserve.cities(id);


--
-- TOC entry 4254 (class 2606 OID 48499)
-- Name: sync_jobs sync_jobs_property_id_fkey; Type: FK CONSTRAINT; Schema: reserve; Owner: -
--

ALTER TABLE ONLY reserve.sync_jobs
    ADD CONSTRAINT sync_jobs_property_id_fkey FOREIGN KEY (property_id) REFERENCES reserve.properties_map(id);


--
-- TOC entry 4255 (class 2606 OID 48525)
-- Name: sync_logs sync_logs_sync_job_id_fkey; Type: FK CONSTRAINT; Schema: reserve; Owner: -
--

ALTER TABLE ONLY reserve.sync_logs
    ADD CONSTRAINT sync_logs_sync_job_id_fkey FOREIGN KEY (sync_job_id) REFERENCES reserve.sync_jobs(id) ON DELETE CASCADE;


--
-- TOC entry 4248 (class 2606 OID 48412)
-- Name: travelers travelers_auth_user_id_fkey; Type: FK CONSTRAINT; Schema: reserve; Owner: -
--

ALTER TABLE ONLY reserve.travelers
    ADD CONSTRAINT travelers_auth_user_id_fkey FOREIGN KEY (auth_user_id) REFERENCES auth.users(id) ON DELETE SET NULL;


--
-- TOC entry 4244 (class 2606 OID 48320)
-- Name: unit_map unit_map_property_id_fkey; Type: FK CONSTRAINT; Schema: reserve; Owner: -
--

ALTER TABLE ONLY reserve.unit_map
    ADD CONSTRAINT unit_map_property_id_fkey FOREIGN KEY (property_id) REFERENCES reserve.properties_map(id) ON DELETE CASCADE;


--
-- TOC entry 4223 (class 2606 OID 16572)
-- Name: objects objects_bucketId_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.objects
    ADD CONSTRAINT "objects_bucketId_fkey" FOREIGN KEY (bucket_id) REFERENCES storage.buckets(id);


--
-- TOC entry 4239 (class 2606 OID 17158)
-- Name: s3_multipart_uploads s3_multipart_uploads_bucket_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.s3_multipart_uploads
    ADD CONSTRAINT s3_multipart_uploads_bucket_id_fkey FOREIGN KEY (bucket_id) REFERENCES storage.buckets(id);


--
-- TOC entry 4240 (class 2606 OID 17178)
-- Name: s3_multipart_uploads_parts s3_multipart_uploads_parts_bucket_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.s3_multipart_uploads_parts
    ADD CONSTRAINT s3_multipart_uploads_parts_bucket_id_fkey FOREIGN KEY (bucket_id) REFERENCES storage.buckets(id);


--
-- TOC entry 4241 (class 2606 OID 17173)
-- Name: s3_multipart_uploads_parts s3_multipart_uploads_parts_upload_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.s3_multipart_uploads_parts
    ADD CONSTRAINT s3_multipart_uploads_parts_upload_id_fkey FOREIGN KEY (upload_id) REFERENCES storage.s3_multipart_uploads(id) ON DELETE CASCADE;


--
-- TOC entry 4242 (class 2606 OID 31191)
-- Name: vector_indexes vector_indexes_bucket_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.vector_indexes
    ADD CONSTRAINT vector_indexes_bucket_id_fkey FOREIGN KEY (bucket_id) REFERENCES storage.buckets_vectors(id);


--
-- TOC entry 4445 (class 0 OID 16525)
-- Dependencies: 238
-- Name: audit_log_entries; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.audit_log_entries ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4459 (class 0 OID 16929)
-- Dependencies: 255
-- Name: flow_state; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.flow_state ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4450 (class 0 OID 16727)
-- Dependencies: 246
-- Name: identities; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.identities ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4444 (class 0 OID 16518)
-- Dependencies: 237
-- Name: instances; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.instances ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4454 (class 0 OID 16816)
-- Dependencies: 250
-- Name: mfa_amr_claims; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.mfa_amr_claims ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4453 (class 0 OID 16804)
-- Dependencies: 249
-- Name: mfa_challenges; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.mfa_challenges ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4452 (class 0 OID 16791)
-- Dependencies: 248
-- Name: mfa_factors; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.mfa_factors ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4460 (class 0 OID 16979)
-- Dependencies: 256
-- Name: one_time_tokens; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.one_time_tokens ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4443 (class 0 OID 16507)
-- Dependencies: 236
-- Name: refresh_tokens; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.refresh_tokens ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4457 (class 0 OID 16858)
-- Dependencies: 253
-- Name: saml_providers; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.saml_providers ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4458 (class 0 OID 16876)
-- Dependencies: 254
-- Name: saml_relay_states; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.saml_relay_states ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4446 (class 0 OID 16533)
-- Dependencies: 239
-- Name: schema_migrations; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.schema_migrations ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4451 (class 0 OID 16757)
-- Dependencies: 247
-- Name: sessions; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.sessions ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4456 (class 0 OID 16843)
-- Dependencies: 252
-- Name: sso_domains; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.sso_domains ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4455 (class 0 OID 16834)
-- Dependencies: 251
-- Name: sso_providers; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.sso_providers ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4442 (class 0 OID 16495)
-- Dependencies: 234
-- Name: users; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.users ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4464 (class 0 OID 17435)
-- Dependencies: 269
-- Name: messages; Type: ROW SECURITY; Schema: realtime; Owner: -
--

ALTER TABLE realtime.messages ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4477 (class 0 OID 48556)
-- Dependencies: 285
-- Name: audit_logs; Type: ROW SECURITY; Schema: reserve; Owner: -
--

ALTER TABLE reserve.audit_logs ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4471 (class 0 OID 48358)
-- Dependencies: 279
-- Name: availability_calendar; Type: ROW SECURITY; Schema: reserve; Owner: -
--

ALTER TABLE reserve.availability_calendar ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4467 (class 0 OID 48251)
-- Dependencies: 275
-- Name: cities; Type: ROW SECURITY; Schema: reserve; Owner: -
--

ALTER TABLE reserve.cities ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4512 (class 3256 OID 48687)
-- Name: sync_jobs edge_function_sync_jobs; Type: POLICY; Schema: reserve; Owner: -
--

CREATE POLICY edge_function_sync_jobs ON reserve.sync_jobs TO authenticated USING (((auth.jwt() ->> 'app_role'::text) = 'sync_worker'::text)) WITH CHECK (((auth.jwt() ->> 'app_role'::text) = 'sync_worker'::text));


--
-- TOC entry 4513 (class 3256 OID 48688)
-- Name: sync_logs edge_function_sync_logs; Type: POLICY; Schema: reserve; Owner: -
--

CREATE POLICY edge_function_sync_logs ON reserve.sync_logs TO authenticated USING (((auth.jwt() ->> 'app_role'::text) = 'sync_worker'::text)) WITH CHECK (((auth.jwt() ->> 'app_role'::text) = 'sync_worker'::text));


--
-- TOC entry 4476 (class 0 OID 48534)
-- Dependencies: 284
-- Name: events; Type: ROW SECURITY; Schema: reserve; Owner: -
--

ALTER TABLE reserve.events ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4478 (class 0 OID 48573)
-- Dependencies: 286
-- Name: funnel_events; Type: ROW SECURITY; Schema: reserve; Owner: -
--

ALTER TABLE reserve.funnel_events ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4479 (class 0 OID 48611)
-- Dependencies: 287
-- Name: kpi_daily_snapshots; Type: ROW SECURITY; Schema: reserve; Owner: -
--

ALTER TABLE reserve.kpi_daily_snapshots ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4468 (class 0 OID 48270)
-- Dependencies: 276
-- Name: properties_map; Type: ROW SECURITY; Schema: reserve; Owner: -
--

ALTER TABLE reserve.properties_map ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4507 (class 3256 OID 48681)
-- Name: availability_calendar public_read_availability; Type: POLICY; Schema: reserve; Owner: -
--

CREATE POLICY public_read_availability ON reserve.availability_calendar FOR SELECT TO anon USING (((is_available = true) AND (is_blocked = false)));


--
-- TOC entry 4500 (class 3256 OID 50140)
-- Name: cities public_read_cities; Type: POLICY; Schema: reserve; Owner: -
--

CREATE POLICY public_read_cities ON reserve.cities FOR SELECT TO anon USING ((is_active = true));


--
-- TOC entry 4501 (class 3256 OID 50141)
-- Name: properties_map public_read_properties; Type: POLICY; Schema: reserve; Owner: -
--

CREATE POLICY public_read_properties ON reserve.properties_map FOR SELECT TO anon USING (((is_active = true) AND (is_published = true) AND (deleted_at IS NULL)));


--
-- TOC entry 4506 (class 3256 OID 48680)
-- Name: rate_plans public_read_rate_plans; Type: POLICY; Schema: reserve; Owner: -
--

CREATE POLICY public_read_rate_plans ON reserve.rate_plans FOR SELECT TO anon USING (((is_active = true) AND (deleted_at IS NULL)));


--
-- TOC entry 4482 (class 3256 OID 48794)
-- Name: search_config public_read_search_config; Type: POLICY; Schema: reserve; Owner: -
--

CREATE POLICY public_read_search_config ON reserve.search_config FOR SELECT TO anon USING (true);


--
-- TOC entry 4502 (class 3256 OID 50142)
-- Name: unit_map public_read_units; Type: POLICY; Schema: reserve; Owner: -
--

CREATE POLICY public_read_units ON reserve.unit_map FOR SELECT TO anon USING (((is_active = true) AND (deleted_at IS NULL)));


--
-- TOC entry 4470 (class 0 OID 48329)
-- Dependencies: 278
-- Name: rate_plans; Type: ROW SECURITY; Schema: reserve; Owner: -
--

ALTER TABLE reserve.rate_plans ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4473 (class 0 OID 48423)
-- Dependencies: 281
-- Name: reservations; Type: ROW SECURITY; Schema: reserve; Owner: -
--

ALTER TABLE reserve.reservations ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4480 (class 0 OID 48760)
-- Dependencies: 292
-- Name: search_config; Type: ROW SECURITY; Schema: reserve; Owner: -
--

ALTER TABLE reserve.search_config ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4487 (class 3256 OID 50074)
-- Name: audit_logs service_role_all_audit_logs; Type: POLICY; Schema: reserve; Owner: -
--

CREATE POLICY service_role_all_audit_logs ON reserve.audit_logs TO service_role USING (true) WITH CHECK (true);


--
-- TOC entry 4484 (class 3256 OID 50068)
-- Name: availability_calendar service_role_all_availability; Type: POLICY; Schema: reserve; Owner: -
--

CREATE POLICY service_role_all_availability ON reserve.availability_calendar TO service_role USING (true) WITH CHECK (true);


--
-- TOC entry 4494 (class 3256 OID 50134)
-- Name: cities service_role_all_cities; Type: POLICY; Schema: reserve; Owner: -
--

CREATE POLICY service_role_all_cities ON reserve.cities TO service_role USING (true) WITH CHECK (true);


--
-- TOC entry 4499 (class 3256 OID 50139)
-- Name: events service_role_all_events; Type: POLICY; Schema: reserve; Owner: -
--

CREATE POLICY service_role_all_events ON reserve.events TO service_role USING (true) WITH CHECK (true);


--
-- TOC entry 4488 (class 3256 OID 50075)
-- Name: funnel_events service_role_all_funnel; Type: POLICY; Schema: reserve; Owner: -
--

CREATE POLICY service_role_all_funnel ON reserve.funnel_events TO service_role USING (true) WITH CHECK (true);


--
-- TOC entry 4489 (class 3256 OID 50076)
-- Name: kpi_daily_snapshots service_role_all_kpi; Type: POLICY; Schema: reserve; Owner: -
--

CREATE POLICY service_role_all_kpi ON reserve.kpi_daily_snapshots TO service_role USING (true) WITH CHECK (true);


--
-- TOC entry 4495 (class 3256 OID 50135)
-- Name: properties_map service_role_all_properties; Type: POLICY; Schema: reserve; Owner: -
--

CREATE POLICY service_role_all_properties ON reserve.properties_map TO service_role USING (true) WITH CHECK (true);


--
-- TOC entry 4483 (class 3256 OID 50067)
-- Name: rate_plans service_role_all_rate_plans; Type: POLICY; Schema: reserve; Owner: -
--

CREATE POLICY service_role_all_rate_plans ON reserve.rate_plans TO service_role USING (true) WITH CHECK (true);


--
-- TOC entry 4486 (class 3256 OID 50070)
-- Name: reservations service_role_all_reservations; Type: POLICY; Schema: reserve; Owner: -
--

CREATE POLICY service_role_all_reservations ON reserve.reservations TO service_role USING (true) WITH CHECK (true);


--
-- TOC entry 4497 (class 3256 OID 50137)
-- Name: sync_jobs service_role_all_sync_jobs; Type: POLICY; Schema: reserve; Owner: -
--

CREATE POLICY service_role_all_sync_jobs ON reserve.sync_jobs TO service_role USING (true) WITH CHECK (true);


--
-- TOC entry 4498 (class 3256 OID 50138)
-- Name: sync_logs service_role_all_sync_logs; Type: POLICY; Schema: reserve; Owner: -
--

CREATE POLICY service_role_all_sync_logs ON reserve.sync_logs TO service_role USING (true) WITH CHECK (true);


--
-- TOC entry 4485 (class 3256 OID 50069)
-- Name: travelers service_role_all_travelers; Type: POLICY; Schema: reserve; Owner: -
--

CREATE POLICY service_role_all_travelers ON reserve.travelers TO service_role USING (true) WITH CHECK (true);


--
-- TOC entry 4496 (class 3256 OID 50136)
-- Name: unit_map service_role_all_units; Type: POLICY; Schema: reserve; Owner: -
--

CREATE POLICY service_role_all_units ON reserve.unit_map TO service_role USING (true) WITH CHECK (true);


--
-- TOC entry 4481 (class 3256 OID 48793)
-- Name: search_config service_role_search_config; Type: POLICY; Schema: reserve; Owner: -
--

CREATE POLICY service_role_search_config ON reserve.search_config TO service_role USING (true) WITH CHECK (true);


--
-- TOC entry 4474 (class 0 OID 48484)
-- Dependencies: 282
-- Name: sync_jobs; Type: ROW SECURITY; Schema: reserve; Owner: -
--

ALTER TABLE reserve.sync_jobs ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4475 (class 0 OID 48515)
-- Dependencies: 283
-- Name: sync_logs; Type: ROW SECURITY; Schema: reserve; Owner: -
--

ALTER TABLE reserve.sync_logs ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4510 (class 3256 OID 48684)
-- Name: reservations traveler_create_reservation; Type: POLICY; Schema: reserve; Owner: -
--

CREATE POLICY traveler_create_reservation ON reserve.reservations FOR INSERT TO authenticated WITH CHECK ((traveler_id IN ( SELECT travelers.id
   FROM reserve.travelers
  WHERE (travelers.auth_user_id = auth.uid()))));


--
-- TOC entry 4508 (class 3256 OID 48682)
-- Name: travelers traveler_own_profile; Type: POLICY; Schema: reserve; Owner: -
--

CREATE POLICY traveler_own_profile ON reserve.travelers TO authenticated USING ((auth_user_id = auth.uid())) WITH CHECK ((auth_user_id = auth.uid()));


--
-- TOC entry 4509 (class 3256 OID 48683)
-- Name: reservations traveler_own_reservations; Type: POLICY; Schema: reserve; Owner: -
--

CREATE POLICY traveler_own_reservations ON reserve.reservations FOR SELECT TO authenticated USING ((traveler_id IN ( SELECT travelers.id
   FROM reserve.travelers
  WHERE (travelers.auth_user_id = auth.uid()))));


--
-- TOC entry 4511 (class 3256 OID 48685)
-- Name: reservations traveler_update_reservation; Type: POLICY; Schema: reserve; Owner: -
--

CREATE POLICY traveler_update_reservation ON reserve.reservations FOR UPDATE TO authenticated USING ((traveler_id IN ( SELECT travelers.id
   FROM reserve.travelers
  WHERE (travelers.auth_user_id = auth.uid())))) WITH CHECK ((traveler_id IN ( SELECT travelers.id
   FROM reserve.travelers
  WHERE (travelers.auth_user_id = auth.uid()))));


--
-- TOC entry 4472 (class 0 OID 48398)
-- Dependencies: 280
-- Name: travelers; Type: ROW SECURITY; Schema: reserve; Owner: -
--

ALTER TABLE reserve.travelers ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4469 (class 0 OID 48301)
-- Dependencies: 277
-- Name: unit_map; Type: ROW SECURITY; Schema: reserve; Owner: -
--

ALTER TABLE reserve.unit_map ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4491 (class 3256 OID 31534)
-- Name: objects Authenticated users can upload product images; Type: POLICY; Schema: storage; Owner: -
--

CREATE POLICY "Authenticated users can upload product images" ON storage.objects FOR INSERT TO authenticated WITH CHECK ((bucket_id = 'product-images'::text));


--
-- TOC entry 4504 (class 3256 OID 50144)
-- Name: objects Property photos accessible via service role; Type: POLICY; Schema: storage; Owner: -
--

CREATE POLICY "Property photos accessible via service role" ON storage.objects TO service_role USING ((bucket_id = 'property-photos'::text));


--
-- TOC entry 4503 (class 3256 OID 50143)
-- Name: objects Public assets are publicly accessible; Type: POLICY; Schema: storage; Owner: -
--

CREATE POLICY "Public assets are publicly accessible" ON storage.objects FOR SELECT USING ((bucket_id = 'public-assets'::text));


--
-- TOC entry 4490 (class 3256 OID 31533)
-- Name: objects Public can view product images; Type: POLICY; Schema: storage; Owner: -
--

CREATE POLICY "Public can view product images" ON storage.objects FOR SELECT USING ((bucket_id = 'product-images'::text));


--
-- TOC entry 4505 (class 3256 OID 50145)
-- Name: objects Unit photos accessible via service role; Type: POLICY; Schema: storage; Owner: -
--

CREATE POLICY "Unit photos accessible via service role" ON storage.objects TO service_role USING ((bucket_id = 'unit-photos'::text));


--
-- TOC entry 4493 (class 3256 OID 31536)
-- Name: objects Users can delete their org product images; Type: POLICY; Schema: storage; Owner: -
--

CREATE POLICY "Users can delete their org product images" ON storage.objects FOR DELETE TO authenticated USING ((bucket_id = 'product-images'::text));


--
-- TOC entry 4492 (class 3256 OID 31535)
-- Name: objects Users can update their org product images; Type: POLICY; Schema: storage; Owner: -
--

CREATE POLICY "Users can update their org product images" ON storage.objects FOR UPDATE TO authenticated USING ((bucket_id = 'product-images'::text));


--
-- TOC entry 4447 (class 0 OID 16546)
-- Dependencies: 240
-- Name: buckets; Type: ROW SECURITY; Schema: storage; Owner: -
--

ALTER TABLE storage.buckets ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4463 (class 0 OID 17246)
-- Dependencies: 263
-- Name: buckets_analytics; Type: ROW SECURITY; Schema: storage; Owner: -
--

ALTER TABLE storage.buckets_analytics ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4465 (class 0 OID 31171)
-- Dependencies: 271
-- Name: buckets_vectors; Type: ROW SECURITY; Schema: storage; Owner: -
--

ALTER TABLE storage.buckets_vectors ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4449 (class 0 OID 16588)
-- Dependencies: 242
-- Name: migrations; Type: ROW SECURITY; Schema: storage; Owner: -
--

ALTER TABLE storage.migrations ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4448 (class 0 OID 16561)
-- Dependencies: 241
-- Name: objects; Type: ROW SECURITY; Schema: storage; Owner: -
--

ALTER TABLE storage.objects ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4461 (class 0 OID 17149)
-- Dependencies: 261
-- Name: s3_multipart_uploads; Type: ROW SECURITY; Schema: storage; Owner: -
--

ALTER TABLE storage.s3_multipart_uploads ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4462 (class 0 OID 17163)
-- Dependencies: 262
-- Name: s3_multipart_uploads_parts; Type: ROW SECURITY; Schema: storage; Owner: -
--

ALTER TABLE storage.s3_multipart_uploads_parts ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4466 (class 0 OID 31181)
-- Dependencies: 272
-- Name: vector_indexes; Type: ROW SECURITY; Schema: storage; Owner: -
--

ALTER TABLE storage.vector_indexes ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4514 (class 6104 OID 16426)
-- Name: supabase_realtime; Type: PUBLICATION; Schema: -; Owner: -
--

CREATE PUBLICATION supabase_realtime WITH (publish = 'insert, update, delete, truncate');


--
-- TOC entry 3701 (class 3466 OID 16621)
-- Name: issue_graphql_placeholder; Type: EVENT TRIGGER; Schema: -; Owner: -
--

CREATE EVENT TRIGGER issue_graphql_placeholder ON sql_drop
         WHEN TAG IN ('DROP EXTENSION')
   EXECUTE FUNCTION extensions.set_graphql_placeholder();


--
-- TOC entry 3706 (class 3466 OID 16700)
-- Name: issue_pg_cron_access; Type: EVENT TRIGGER; Schema: -; Owner: -
--

CREATE EVENT TRIGGER issue_pg_cron_access ON ddl_command_end
         WHEN TAG IN ('CREATE EXTENSION')
   EXECUTE FUNCTION extensions.grant_pg_cron_access();


--
-- TOC entry 3700 (class 3466 OID 16619)
-- Name: issue_pg_graphql_access; Type: EVENT TRIGGER; Schema: -; Owner: -
--

CREATE EVENT TRIGGER issue_pg_graphql_access ON ddl_command_end
         WHEN TAG IN ('CREATE FUNCTION')
   EXECUTE FUNCTION extensions.grant_pg_graphql_access();


--
-- TOC entry 3707 (class 3466 OID 16703)
-- Name: issue_pg_net_access; Type: EVENT TRIGGER; Schema: -; Owner: -
--

CREATE EVENT TRIGGER issue_pg_net_access ON ddl_command_end
         WHEN TAG IN ('CREATE EXTENSION')
   EXECUTE FUNCTION extensions.grant_pg_net_access();


--
-- TOC entry 3702 (class 3466 OID 16622)
-- Name: pgrst_ddl_watch; Type: EVENT TRIGGER; Schema: -; Owner: -
--

CREATE EVENT TRIGGER pgrst_ddl_watch ON ddl_command_end
   EXECUTE FUNCTION extensions.pgrst_ddl_watch();


--
-- TOC entry 3703 (class 3466 OID 16623)
-- Name: pgrst_drop_watch; Type: EVENT TRIGGER; Schema: -; Owner: -
--

CREATE EVENT TRIGGER pgrst_drop_watch ON sql_drop
   EXECUTE FUNCTION extensions.pgrst_drop_watch();


-- Completed on 2026-02-15 18:58:01

--
-- PostgreSQL database dump complete
--

\unrestrict ikcJNqAfsqTuCtHW9JkbU02Yx5zgO9KfFqbglFBlXQxUTR6bbJVlhGsZA00lXl9

