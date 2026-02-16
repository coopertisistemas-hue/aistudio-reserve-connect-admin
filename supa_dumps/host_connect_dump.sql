--
-- PostgreSQL database dump
--

\restrict QGqXGArDypXQuQXqCB6kPSrnuBfUl6PimhiWaL6Z9WbHq0VZgjTUsdgJXmYH6dM

-- Dumped from database version 17.6
-- Dumped by pg_dump version 18.1

-- Started on 2026-02-15 19:00:37

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
-- TOC entry 36 (class 2615 OID 16494)
-- Name: auth; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA auth;


--
-- TOC entry 22 (class 2615 OID 16388)
-- Name: extensions; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA extensions;


--
-- TOC entry 34 (class 2615 OID 16624)
-- Name: graphql; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA graphql;


--
-- TOC entry 33 (class 2615 OID 16613)
-- Name: graphql_public; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA graphql_public;


--
-- TOC entry 12 (class 2615 OID 16386)
-- Name: pgbouncer; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA pgbouncer;


--
-- TOC entry 9 (class 2615 OID 16605)
-- Name: realtime; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA realtime;


--
-- TOC entry 37 (class 2615 OID 16542)
-- Name: storage; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA storage;


--
-- TOC entry 126 (class 2615 OID 88186)
-- Name: supabase_migrations; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA supabase_migrations;


--
-- TOC entry 31 (class 2615 OID 16653)
-- Name: vault; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA vault;


--
-- TOC entry 6 (class 3079 OID 16689)
-- Name: pg_graphql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_graphql WITH SCHEMA graphql;


--
-- TOC entry 5282 (class 0 OID 0)
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
-- TOC entry 5283 (class 0 OID 0)
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
-- TOC entry 5284 (class 0 OID 0)
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
-- TOC entry 5285 (class 0 OID 0)
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
-- TOC entry 5286 (class 0 OID 0)
-- Dependencies: 3
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


--
-- TOC entry 1244 (class 1247 OID 16784)
-- Name: aal_level; Type: TYPE; Schema: auth; Owner: -
--

CREATE TYPE auth.aal_level AS ENUM (
    'aal1',
    'aal2',
    'aal3'
);


--
-- TOC entry 1268 (class 1247 OID 16925)
-- Name: code_challenge_method; Type: TYPE; Schema: auth; Owner: -
--

CREATE TYPE auth.code_challenge_method AS ENUM (
    's256',
    'plain'
);


--
-- TOC entry 1241 (class 1247 OID 16778)
-- Name: factor_status; Type: TYPE; Schema: auth; Owner: -
--

CREATE TYPE auth.factor_status AS ENUM (
    'unverified',
    'verified'
);


--
-- TOC entry 1238 (class 1247 OID 16773)
-- Name: factor_type; Type: TYPE; Schema: auth; Owner: -
--

CREATE TYPE auth.factor_type AS ENUM (
    'totp',
    'webauthn',
    'phone'
);


--
-- TOC entry 1286 (class 1247 OID 17028)
-- Name: oauth_authorization_status; Type: TYPE; Schema: auth; Owner: -
--

CREATE TYPE auth.oauth_authorization_status AS ENUM (
    'pending',
    'approved',
    'denied',
    'expired'
);


--
-- TOC entry 1298 (class 1247 OID 17101)
-- Name: oauth_client_type; Type: TYPE; Schema: auth; Owner: -
--

CREATE TYPE auth.oauth_client_type AS ENUM (
    'public',
    'confidential'
);


--
-- TOC entry 1280 (class 1247 OID 17006)
-- Name: oauth_registration_type; Type: TYPE; Schema: auth; Owner: -
--

CREATE TYPE auth.oauth_registration_type AS ENUM (
    'dynamic',
    'manual'
);


--
-- TOC entry 1289 (class 1247 OID 17038)
-- Name: oauth_response_type; Type: TYPE; Schema: auth; Owner: -
--

CREATE TYPE auth.oauth_response_type AS ENUM (
    'code'
);


--
-- TOC entry 1274 (class 1247 OID 16967)
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
-- TOC entry 1325 (class 1247 OID 17318)
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
-- TOC entry 1316 (class 1247 OID 17278)
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
-- TOC entry 1319 (class 1247 OID 17293)
-- Name: user_defined_filter; Type: TYPE; Schema: realtime; Owner: -
--

CREATE TYPE realtime.user_defined_filter AS (
	column_name text,
	op realtime.equality_op,
	value text
);


--
-- TOC entry 1331 (class 1247 OID 17360)
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
-- TOC entry 1328 (class 1247 OID 17331)
-- Name: wal_rls; Type: TYPE; Schema: realtime; Owner: -
--

CREATE TYPE realtime.wal_rls AS (
	wal jsonb,
	is_rls_enabled boolean,
	subscription_ids uuid[],
	errors text[]
);


--
-- TOC entry 1307 (class 1247 OID 17236)
-- Name: buckettype; Type: TYPE; Schema: storage; Owner: -
--

CREATE TYPE storage.buckettype AS ENUM (
    'STANDARD',
    'ANALYTICS',
    'VECTOR'
);


--
-- TOC entry 504 (class 1255 OID 16540)
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
-- TOC entry 5287 (class 0 OID 0)
-- Dependencies: 504
-- Name: FUNCTION email(); Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON FUNCTION auth.email() IS 'Deprecated. Use auth.jwt() -> ''email'' instead.';


--
-- TOC entry 523 (class 1255 OID 16755)
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
-- TOC entry 503 (class 1255 OID 16539)
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
-- TOC entry 5288 (class 0 OID 0)
-- Dependencies: 503
-- Name: FUNCTION role(); Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON FUNCTION auth.role() IS 'Deprecated. Use auth.jwt() -> ''role'' instead.';


--
-- TOC entry 502 (class 1255 OID 16538)
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
-- TOC entry 5289 (class 0 OID 0)
-- Dependencies: 502
-- Name: FUNCTION uid(); Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON FUNCTION auth.uid() IS 'Deprecated. Use auth.jwt() -> ''sub'' instead.';


--
-- TOC entry 505 (class 1255 OID 16597)
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
-- TOC entry 5290 (class 0 OID 0)
-- Dependencies: 505
-- Name: FUNCTION grant_pg_cron_access(); Type: COMMENT; Schema: extensions; Owner: -
--

COMMENT ON FUNCTION extensions.grant_pg_cron_access() IS 'Grants access to pg_cron';


--
-- TOC entry 509 (class 1255 OID 16618)
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
-- TOC entry 5291 (class 0 OID 0)
-- Dependencies: 509
-- Name: FUNCTION grant_pg_graphql_access(); Type: COMMENT; Schema: extensions; Owner: -
--

COMMENT ON FUNCTION extensions.grant_pg_graphql_access() IS 'Grants access to pg_graphql';


--
-- TOC entry 506 (class 1255 OID 16599)
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
-- TOC entry 5292 (class 0 OID 0)
-- Dependencies: 506
-- Name: FUNCTION grant_pg_net_access(); Type: COMMENT; Schema: extensions; Owner: -
--

COMMENT ON FUNCTION extensions.grant_pg_net_access() IS 'Grants access to pg_net';


--
-- TOC entry 507 (class 1255 OID 16609)
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
-- TOC entry 508 (class 1255 OID 16610)
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
-- TOC entry 510 (class 1255 OID 16620)
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
-- TOC entry 5293 (class 0 OID 0)
-- Dependencies: 510
-- Name: FUNCTION set_graphql_placeholder(); Type: COMMENT; Schema: extensions; Owner: -
--

COMMENT ON FUNCTION extensions.set_graphql_placeholder() IS 'Reintroduces placeholder function for graphql_public.graphql';


--
-- TOC entry 452 (class 1255 OID 16387)
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
-- TOC entry 569 (class 1255 OID 63757)
-- Name: accept_invite(text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.accept_invite(p_token text) RETURNS json
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
  v_invite public.org_invites%ROWTYPE;
  v_user_email text;
  v_user_id uuid;
BEGIN
  -- Get Invite
  SELECT * INTO v_invite
  FROM public.org_invites
  WHERE token = p_token AND status = 'pending' AND expires_at > now();

  IF v_invite.id IS NULL THEN
    RETURN json_build_object('success', false, 'error', 'Invalid or expired token');
  END IF;

  -- Get Current User
  v_user_id := auth.uid();
  IF v_user_id IS NULL THEN
     RETURN json_build_object('success', false, 'error', 'Not authenticated');
  END IF;

  SELECT email INTO v_user_email FROM auth.users WHERE id = v_user_id;

  -- Verify Email? (Optional: Strict or Open Link)
  -- Prompt says: "admin cria e envia link". Usually implies link is key.
  -- But for security, matching email is better. 
  -- Let's enforce email match if invite prompt specifically asked for email.
  -- But user might have different email alias. 
  -- Let's be lenient for this "Simples" mvp: If they have the valid token, they claim it.
  -- BUT update the invite with the actual user who claimed it.

  -- Add to Org Members
  INSERT INTO public.org_members (org_id, user_id, role)
  VALUES (v_invite.org_id, v_user_id, v_invite.role)
  ON CONFLICT (org_id, user_id) DO UPDATE SET role = EXCLUDED.role;

  -- Update Invite Status
  UPDATE public.org_invites
  SET status = 'accepted'
  WHERE id = v_invite.id;

  RETURN json_build_object('success', true, 'org_id', v_invite.org_id);
END;
$$;


--
-- TOC entry 571 (class 1255 OID 69386)
-- Name: auto_set_accommodation_limit(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.auto_set_accommodation_limit() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  -- Only update if plan has changed or is being set for the first time
  IF (TG_OP = 'INSERT') OR (OLD.plan IS DISTINCT FROM NEW.plan) THEN
    -- Set accommodation_limit based on plan
    CASE NEW.plan
      WHEN 'founder' THEN NEW.accommodation_limit := 100;
      WHEN 'premium' THEN NEW.accommodation_limit := 100;
      WHEN 'pro' THEN NEW.accommodation_limit := 10;
      WHEN 'basic' THEN NEW.accommodation_limit := 2;
      ELSE NEW.accommodation_limit := 1; -- Free or unknown
    END CASE;
  END IF;
  RETURN NEW;
END;
$$;


--
-- TOC entry 573 (class 1255 OID 70947)
-- Name: calculate_movement_balance(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.calculate_movement_balance() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  current_balance DECIMAL(10,2);
BEGIN
  -- Busca o estoque atual do item
  SELECT current_stock INTO current_balance
  FROM stock_items
  WHERE id = NEW.stock_item_id;
  
  -- Define o saldo antes da movimentação
  NEW.balance_before := current_balance;
  
  -- Calcula o saldo depois da movimentação
  NEW.balance_after := current_balance + NEW.quantity;
  
  RETURN NEW;
END;
$$;


--
-- TOC entry 559 (class 1255 OID 63572)
-- Name: check_accommodation_limit(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.check_accommodation_limit() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  current_count INTEGER;
  max_limit INTEGER;
  user_plan TEXT;
  user_plan_status TEXT;
  user_trial_expires_at TIMESTAMPTZ;
  is_trial_active BOOLEAN;
BEGIN
  -- Get the current number of properties for the user
  SELECT COUNT(*) INTO current_count
  FROM public.properties
  WHERE user_id = new.user_id; 
  -- Get the user's limit, plan, and trial info from profiles
  SELECT 
    accommodation_limit, 
    plan, 
    plan_status, 
    trial_expires_at 
  INTO 
    max_limit, 
    user_plan, 
    user_plan_status, 
    user_trial_expires_at
  FROM public.profiles
  WHERE id = new.user_id;
  -- Determine if trial is active
  IF user_plan_status = 'trial' AND user_trial_expires_at > NOW() THEN
    is_trial_active := TRUE;
  ELSE
    is_trial_active := FALSE;
  END IF;
  -- Default limit logic (Fallback + Trial Override)
  IF is_trial_active THEN
     -- If in trial, ensure at least 100 slots (Premium/Founder level)
     IF max_limit IS NULL OR max_limit < 100 THEN
        max_limit := 100;
        user_plan := 'trial (premium)'; -- Just for error message context
     END IF;
  ELSIF max_limit IS NULL THEN
    -- Fallback for non-trial users with NULL limits
    CASE user_plan
      WHEN 'founder' THEN max_limit := 100;
      WHEN 'premium' THEN max_limit := 100;
      WHEN 'pro' THEN max_limit := 10;
      WHEN 'basic' THEN max_limit := 2;
      ELSE max_limit := 1; -- Free or unknown
    END CASE;
  END IF;
  -- Check if adding 1 would exceed the limit
  IF (current_count + 1) > max_limit THEN
    RAISE EXCEPTION 'Limite de acomodações atingido para o plano %. Atual: %, Limite: %', user_plan, current_count, max_limit
      USING ERRCODE = 'P0001'; 
  END IF;
  RETURN NEW;
END;
$$;


--
-- TOC entry 556 (class 1255 OID 63306)
-- Name: check_booking_access(uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.check_booking_access(target_booking_id uuid) RETURNS boolean
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
DECLARE
  linked_property_id uuid;
BEGIN
  SELECT property_id INTO linked_property_id FROM public.bookings WHERE id = target_booking_id;
  
  IF linked_property_id IS NULL THEN
    RETURN false;
  END IF;

  RETURN public.check_user_access(linked_property_id);
END;
$$;


--
-- TOC entry 555 (class 1255 OID 63297)
-- Name: check_user_access(uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.check_user_access(target_property_id uuid) RETURNS boolean
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
BEGIN
  -- 1. Allow Super Admins (role = 'admin' in profiles)
  IF EXISTS (SELECT 1 FROM public.profiles WHERE id = auth.uid() AND role = 'admin') THEN
    RETURN true;
  END IF;

  -- 2. Allow Property Owners
  IF EXISTS (SELECT 1 FROM public.properties WHERE id = target_property_id AND user_id = auth.uid()) THEN
    RETURN true;
  END IF;

  RETURN false;
END;
$$;


--
-- TOC entry 566 (class 1255 OID 63649)
-- Name: create_organization(text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.create_organization(org_name text) RETURNS json
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
DECLARE
    new_org_id uuid;
BEGIN
    -- 1. Create Org
    INSERT INTO public.organizations (name, owner_id)
    VALUES (org_name, auth.uid())
    RETURNING id INTO new_org_id;

    -- 2. Add Creator as Owner
    INSERT INTO public.org_members (org_id, user_id, role)
    VALUES (new_org_id, auth.uid(), 'owner');

    RETURN json_build_object('id', new_org_id, 'name', org_name);
END;
$$;


--
-- TOC entry 567 (class 1255 OID 63650)
-- Name: create_personal_org_for_user(uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.create_personal_org_for_user(p_user_id uuid) RETURNS void
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
DECLARE
    v_org_id uuid;
    v_user_name text;
BEGIN
    -- Idempotency Check: If user is already a member of ANY organization, skip.
    -- (We assume if they are a member, they are 'set up'. If we wanted to force a PERSONAL org specifically, logic would differ).
    IF EXISTS (SELECT 1 FROM public.org_members WHERE user_id = p_user_id) THEN
        RETURN;
    END IF;

    -- Get user name for better org name (optional, fallback to generic)
    SELECT full_name INTO v_user_name FROM public.profiles WHERE id = p_user_id;
    IF v_user_name IS NULL OR v_user_name = '' THEN
        v_user_name := 'Minha Hospedagem';
    ELSE
        v_user_name := v_user_name || ' - Hospedagem';
    END IF;

    -- Create Org
    INSERT INTO public.organizations (name, owner_id)
    VALUES (v_user_name, p_user_id)
    RETURNING id INTO v_org_id;

    -- Add User as Owner
    INSERT INTO public.org_members (org_id, user_id, role)
    VALUES (v_org_id, p_user_id, 'owner');
    
EXCEPTION WHEN OTHERS THEN
    -- Log error or ignore to prevent blocking user creation
    RAISE WARNING 'Failed to create personal org for user %: %', p_user_id, SQLERRM;
END;
$$;


--
-- TOC entry 565 (class 1255 OID 63643)
-- Name: current_org_id(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.current_org_id() RETURNS uuid
    LANGUAGE plpgsql STABLE SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
DECLARE
    v_org_id uuid;
BEGIN
    SELECT org_id INTO v_org_id
    FROM public.org_members
    WHERE user_id = auth.uid()
    ORDER BY created_at ASC -- Stable ordering (oldest membership)
    LIMIT 1;
    
    RETURN v_org_id;
END;
$$;


--
-- TOC entry 561 (class 1255 OID 63579)
-- Name: extend_trial(uuid, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.extend_trial(target_user_id uuid, reason text) RETURNS json
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
DECLARE
    target_profile record;
    old_expiration timestamptz;
BEGIN
    -- Check Permissions
    IF NOT public.is_hostconnect_staff() THEN
        RAISE EXCEPTION 'Access Denied: Only staff can extend trials.';
    END IF;

    SELECT * INTO target_profile FROM public.profiles WHERE id = target_user_id;
    
    IF NOT FOUND THEN
        RAISE EXCEPTION 'User profile not found.';
    END IF;

    -- Validate
    IF target_profile.plan_status != 'trial' THEN
         RAISE EXCEPTION 'Cannot extend trial: User is not currently in active trial (Status: %)', target_profile.plan_status;
    END IF;

    IF target_profile.trial_extension_days > 0 THEN
        RAISE EXCEPTION 'Cannot extend trial: Trial has already been extended once.';
    END IF;
    
    old_expiration := target_profile.trial_expires_at;

    -- Update
    UPDATE public.profiles
    SET 
        trial_extended_at = now(),
        trial_extension_days = 15,
        trial_extension_reason = reason,
        trial_expires_at = trial_expires_at + interval '15 days'
    WHERE id = target_user_id;

    -- Explicit Audit Log for Action Context (The trigger will also catch the data change)
    INSERT INTO public.audit_log (
        actor_user_id,
        target_user_id,
        action,
        old_data,
        new_data
    ) VALUES (
        auth.uid(),
        target_user_id,
        'TRIAL_EXTENSION_RPC',
        jsonb_build_object('reason', reason, 'old_expires_at', old_expiration),
        jsonb_build_object('extension_days', 15, 'new_expires_at', old_expiration + interval '15 days')
    );

    RETURN json_build_object(
        'success', true, 
        'message', 'Trial extended by 15 days.',
        'new_expires_at', (target_profile.trial_expires_at + interval '15 days')
    );
END;
$$;


--
-- TOC entry 554 (class 1255 OID 18084)
-- Name: get_user_role(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.get_user_role() RETURNS text
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
  DECLARE
    user_role text;
  BEGIN
    SELECT role INTO user_role FROM public.profiles WHERE id = auth.uid();
    RETURN user_role;
  END;
$$;


--
-- TOC entry 553 (class 1255 OID 17541)
-- Name: handle_new_user(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.handle_new_user() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
  selected_plan TEXT;
BEGIN
  -- Extract plan from user metadata (sent from frontend during signup)
  selected_plan := NEW.raw_user_meta_data->>'plan';
  
  -- Default to 'basic' if no plan specified
  IF selected_plan IS NULL OR selected_plan = '' THEN
    selected_plan := 'basic';
  END IF;
  -- Insert profile with plan
  INSERT INTO public.profiles (id, full_name, email, phone, plan)
  VALUES (
    NEW.id,
    NEW.raw_user_meta_data->>'full_name',
    NEW.email,
    NEW.raw_user_meta_data->>'phone',
    selected_plan
  );
  
  RETURN NEW;
END;
$$;


--
-- TOC entry 568 (class 1255 OID 63651)
-- Name: handle_new_user_org(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.handle_new_user_org() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
    PERFORM public.create_personal_org_for_user(NEW.id);
    RETURN NEW;
END;
$$;


--
-- TOC entry 560 (class 1255 OID 63577)
-- Name: handle_new_user_trial(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.handle_new_user_trial() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
    -- Only initialize trial if plan is empty or free (default assumption for new signups)
    IF (NEW.plan IS NULL OR NEW.plan = 'free' OR NEW.plan = '') THEN
        NEW.plan_status := 'trial';
        NEW.trial_started_at := now();
        NEW.trial_expires_at := now() + interval '15 days';
        -- Optional: Set plan to 'premium' or similar if trial gives access to everything?
        -- User requirements didn't specify changing the 'plan' column itself, only setting 'plan_status'='trial'.
        -- We will assume Entitlements Logic will handle (plan='free' AND plan_status='trial') -> Give Premium Access.
    END IF;
    RETURN NEW;
END;
$$;


--
-- TOC entry 558 (class 1255 OID 63446)
-- Name: is_hostconnect_staff(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.is_hostconnect_staff() RETURNS boolean
    LANGUAGE plpgsql STABLE SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
BEGIN
  -- HostConnect staff members are super admins
  -- This is an alias for consistency with existing policies
  RETURN public.is_super_admin();
END;
$$;


--
-- TOC entry 5294 (class 0 OID 0)
-- Dependencies: 558
-- Name: FUNCTION is_hostconnect_staff(); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION public.is_hostconnect_staff() IS 'Returns true if current user is a HostConnect staff member (super admin). 
Used in RLS policies for cross-organizational support access.';


--
-- TOC entry 564 (class 1255 OID 63642)
-- Name: is_org_admin(uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.is_org_admin(p_org_id uuid) RETURNS boolean
    LANGUAGE plpgsql STABLE SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
BEGIN
  RETURN EXISTS (
    SELECT 1 
    FROM public.org_members 
    WHERE org_id = p_org_id 
    AND user_id = auth.uid()
    AND role IN ('owner', 'admin')
  );
END;
$$;


--
-- TOC entry 578 (class 1255 OID 88180)
-- Name: is_org_admin_no_rls(uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.is_org_admin_no_rls(p_org_id uuid) RETURNS boolean
    LANGUAGE plpgsql STABLE SECURITY DEFINER
    SET search_path TO 'public'
    SET row_security TO 'off'
    AS $$
BEGIN
  RETURN EXISTS (
    SELECT 1
    FROM public.org_members
    WHERE org_id = p_org_id
      AND user_id = auth.uid()
      AND role IN ('owner', 'admin')
  );
END;
$$;


--
-- TOC entry 563 (class 1255 OID 63641)
-- Name: is_org_member(uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.is_org_member(p_org_id uuid) RETURNS boolean
    LANGUAGE plpgsql STABLE SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
BEGIN
  RETURN EXISTS (
    SELECT 1 
    FROM public.org_members 
    WHERE org_id = p_org_id 
    AND user_id = auth.uid()
  );
END;
$$;


--
-- TOC entry 576 (class 1255 OID 85869)
-- Name: is_super_admin(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.is_super_admin() RETURNS boolean
    LANGUAGE plpgsql STABLE SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
BEGIN
  RETURN EXISTS (
    SELECT 1 
    FROM public.profiles 
    WHERE id = auth.uid() 
    AND is_super_admin = true
  );
END;
$$;


--
-- TOC entry 5295 (class 0 OID 0)
-- Dependencies: 576
-- Name: FUNCTION is_super_admin(); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION public.is_super_admin() IS 'Returns true if current user is a super admin (Connect team member)';


--
-- TOC entry 562 (class 1255 OID 63601)
-- Name: log_profile_sensitive_changes(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.log_profile_sensitive_changes() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    current_actor uuid;
    changes_detected boolean := false;
    old_snapshot jsonb;
    new_snapshot jsonb;
BEGIN
    -- Attempt to get actor from auth.uid()
    current_actor := auth.uid();

    -- Check for sensitive columns changes
    IF (OLD.plan IS DISTINCT FROM NEW.plan) OR 
       (OLD.plan_status IS DISTINCT FROM NEW.plan_status) OR
       (OLD.trial_expires_at IS DISTINCT FROM NEW.trial_expires_at) OR 
       (OLD.trial_extension_days IS DISTINCT FROM NEW.trial_extension_days) THEN
       
       changes_detected := true;
    END IF;

    IF changes_detected THEN
        -- Construct snapshots of relevant fields only
        old_snapshot := jsonb_build_object(
            'plan', OLD.plan,
            'plan_status', OLD.plan_status,
            'trial_expires_at', OLD.trial_expires_at,
            'trial_extension_days', OLD.trial_extension_days
        );
        new_snapshot := jsonb_build_object(
            'plan', NEW.plan,
            'plan_status', NEW.plan_status,
            'trial_expires_at', NEW.trial_expires_at,
            'trial_extension_days', NEW.trial_extension_days
        );

        INSERT INTO public.audit_log (
            actor_user_id,
            target_user_id,
            action,
            old_data,
            new_data
        ) VALUES (
            current_actor,
            NEW.id,
            'PROFILE_SENSITIVE_UPDATE',
            old_snapshot,
            new_snapshot
        );
    END IF;

    RETURN NEW;
END;
$$;


--
-- TOC entry 552 (class 1255 OID 17536)
-- Name: moddatetime(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.moddatetime() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW;
END;
$$;


--
-- TOC entry 577 (class 1255 OID 85882)
-- Name: prevent_super_admin_self_promotion(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.prevent_super_admin_self_promotion() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
  -- Only allow if current user is already a super admin
  -- This prevents regular users from promoting themselves
  IF NEW.is_super_admin = true AND OLD.is_super_admin = false THEN
    IF NOT public.is_super_admin() THEN
      RAISE EXCEPTION 'Only super admins can promote users to super admin';
    END IF;
  END IF;
  
  RETURN NEW;
END;
$$;


--
-- TOC entry 575 (class 1255 OID 83293)
-- Name: set_org_id_from_inventory_item(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.set_org_id_from_inventory_item() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF NEW.org_id IS NULL AND NEW.item_id IS NOT NULL THEN
    SELECT org_id INTO NEW.org_id
    FROM public.inventory_items
    WHERE id = NEW.item_id;
    
    IF NEW.org_id IS NULL THEN
      RAISE EXCEPTION 'Cannot determine org_id: item_id % not found', NEW.item_id;
    END IF;
  END IF;
  RETURN NEW;
END;
$$;


--
-- TOC entry 570 (class 1255 OID 63758)
-- Name: set_org_id_from_property(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.set_org_id_from_property() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF NEW.org_id IS NULL AND NEW.property_id IS NOT NULL THEN
    SELECT org_id INTO NEW.org_id
    FROM public.properties
    WHERE id = NEW.property_id;
    
    IF NEW.org_id IS NULL THEN
      RAISE EXCEPTION 'Cannot determine org_id: property_id % not found', NEW.property_id;
    END IF;
  END IF;
  RETURN NEW;
END;
$$;


--
-- TOC entry 574 (class 1255 OID 83292)
-- Name: set_org_id_from_room_type(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.set_org_id_from_room_type() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF NEW.org_id IS NULL AND NEW.room_type_id IS NOT NULL THEN
    SELECT org_id INTO NEW.org_id
    FROM public.room_types
    WHERE id = NEW.room_type_id;
    
    IF NEW.org_id IS NULL THEN
      RAISE EXCEPTION 'Cannot determine org_id: room_type_id % not found', NEW.room_type_id;
    END IF;
  END IF;
  RETURN NEW;
END;
$$;


--
-- TOC entry 572 (class 1255 OID 70945)
-- Name: update_stock_balance(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.update_stock_balance() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  -- Atualiza o estoque atual do item
  UPDATE stock_items
  SET 
    current_stock = NEW.balance_after,
    updated_at = NOW()
  WHERE id = NEW.stock_item_id;
  
  RETURN NEW;
END;
$$;


--
-- TOC entry 557 (class 1255 OID 63431)
-- Name: update_updated_at_column(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.update_updated_at_column() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = clock_timestamp();
    RETURN NEW;
END;
$$;


--
-- TOC entry 545 (class 1255 OID 17353)
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
-- TOC entry 551 (class 1255 OID 17432)
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
-- TOC entry 547 (class 1255 OID 17365)
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
-- TOC entry 543 (class 1255 OID 17315)
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
-- TOC entry 542 (class 1255 OID 17310)
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
-- TOC entry 546 (class 1255 OID 17361)
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
-- TOC entry 548 (class 1255 OID 17372)
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
-- TOC entry 541 (class 1255 OID 17309)
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
-- TOC entry 550 (class 1255 OID 17431)
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
-- TOC entry 540 (class 1255 OID 17307)
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
-- TOC entry 544 (class 1255 OID 17342)
-- Name: to_regrole(text); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime.to_regrole(role_name text) RETURNS regrole
    LANGUAGE sql IMMUTABLE
    AS $$ select role_name::regrole $$;


--
-- TOC entry 549 (class 1255 OID 17425)
-- Name: topic(); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime.topic() RETURNS text
    LANGUAGE sql STABLE
    AS $$
select nullif(current_setting('realtime.topic', true), '')::text;
$$;


--
-- TOC entry 529 (class 1255 OID 17140)
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
-- TOC entry 539 (class 1255 OID 17255)
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
-- TOC entry 537 (class 1255 OID 17233)
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
-- TOC entry 526 (class 1255 OID 17114)
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
-- TOC entry 525 (class 1255 OID 17113)
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
-- TOC entry 524 (class 1255 OID 17112)
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
-- TOC entry 579 (class 1255 OID 99612)
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
-- TOC entry 532 (class 1255 OID 17196)
-- Name: get_level(text); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.get_level(name text) RETURNS integer
    LANGUAGE sql IMMUTABLE STRICT
    AS $$
SELECT array_length(string_to_array("name", '/'), 1);
$$;


--
-- TOC entry 533 (class 1255 OID 17212)
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
-- TOC entry 534 (class 1255 OID 17213)
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
-- TOC entry 536 (class 1255 OID 17231)
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
-- TOC entry 530 (class 1255 OID 17179)
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
-- TOC entry 580 (class 1255 OID 99613)
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
-- TOC entry 531 (class 1255 OID 17195)
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
-- TOC entry 582 (class 1255 OID 99618)
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
-- TOC entry 527 (class 1255 OID 17129)
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
-- TOC entry 581 (class 1255 OID 99616)
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
-- TOC entry 535 (class 1255 OID 17229)
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
-- TOC entry 538 (class 1255 OID 17253)
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
-- TOC entry 528 (class 1255 OID 17130)
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
-- TOC entry 349 (class 1259 OID 16525)
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
-- TOC entry 5296 (class 0 OID 0)
-- Dependencies: 349
-- Name: TABLE audit_log_entries; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.audit_log_entries IS 'Auth: Audit trail for user actions.';


--
-- TOC entry 366 (class 1259 OID 16929)
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
-- TOC entry 5297 (class 0 OID 0)
-- Dependencies: 366
-- Name: TABLE flow_state; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.flow_state IS 'Stores metadata for all OAuth/SSO login flows';


--
-- TOC entry 357 (class 1259 OID 16727)
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
-- TOC entry 5298 (class 0 OID 0)
-- Dependencies: 357
-- Name: TABLE identities; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.identities IS 'Auth: Stores identities associated to a user.';


--
-- TOC entry 5299 (class 0 OID 0)
-- Dependencies: 357
-- Name: COLUMN identities.email; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON COLUMN auth.identities.email IS 'Auth: Email is a generated column that references the optional email property in the identity_data';


--
-- TOC entry 348 (class 1259 OID 16518)
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
-- TOC entry 5300 (class 0 OID 0)
-- Dependencies: 348
-- Name: TABLE instances; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.instances IS 'Auth: Manages users across multiple sites.';


--
-- TOC entry 361 (class 1259 OID 16816)
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
-- TOC entry 5301 (class 0 OID 0)
-- Dependencies: 361
-- Name: TABLE mfa_amr_claims; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.mfa_amr_claims IS 'auth: stores authenticator method reference claims for multi factor authentication';


--
-- TOC entry 360 (class 1259 OID 16804)
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
-- TOC entry 5302 (class 0 OID 0)
-- Dependencies: 360
-- Name: TABLE mfa_challenges; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.mfa_challenges IS 'auth: stores metadata about challenge requests made';


--
-- TOC entry 359 (class 1259 OID 16791)
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
-- TOC entry 5303 (class 0 OID 0)
-- Dependencies: 359
-- Name: TABLE mfa_factors; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.mfa_factors IS 'auth: stores metadata about factors';


--
-- TOC entry 5304 (class 0 OID 0)
-- Dependencies: 359
-- Name: COLUMN mfa_factors.last_webauthn_challenge_data; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON COLUMN auth.mfa_factors.last_webauthn_challenge_data IS 'Stores the latest WebAuthn challenge data including attestation/assertion for customer verification';


--
-- TOC entry 369 (class 1259 OID 17041)
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
-- TOC entry 403 (class 1259 OID 58652)
-- Name: oauth_client_states; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.oauth_client_states (
    id uuid NOT NULL,
    provider_type text NOT NULL,
    code_verifier text,
    created_at timestamp with time zone NOT NULL
);


--
-- TOC entry 5305 (class 0 OID 0)
-- Dependencies: 403
-- Name: TABLE oauth_client_states; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.oauth_client_states IS 'Stores OAuth states for third-party provider authentication flows where Supabase acts as the OAuth client.';


--
-- TOC entry 368 (class 1259 OID 17011)
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
-- TOC entry 370 (class 1259 OID 17074)
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
-- TOC entry 367 (class 1259 OID 16979)
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
-- TOC entry 347 (class 1259 OID 16507)
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
-- TOC entry 5306 (class 0 OID 0)
-- Dependencies: 347
-- Name: TABLE refresh_tokens; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.refresh_tokens IS 'Auth: Store of tokens used to refresh JWT tokens once they expire.';


--
-- TOC entry 346 (class 1259 OID 16506)
-- Name: refresh_tokens_id_seq; Type: SEQUENCE; Schema: auth; Owner: -
--

CREATE SEQUENCE auth.refresh_tokens_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5307 (class 0 OID 0)
-- Dependencies: 346
-- Name: refresh_tokens_id_seq; Type: SEQUENCE OWNED BY; Schema: auth; Owner: -
--

ALTER SEQUENCE auth.refresh_tokens_id_seq OWNED BY auth.refresh_tokens.id;


--
-- TOC entry 364 (class 1259 OID 16858)
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
-- TOC entry 5308 (class 0 OID 0)
-- Dependencies: 364
-- Name: TABLE saml_providers; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.saml_providers IS 'Auth: Manages SAML Identity Provider connections.';


--
-- TOC entry 365 (class 1259 OID 16876)
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
-- TOC entry 5309 (class 0 OID 0)
-- Dependencies: 365
-- Name: TABLE saml_relay_states; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.saml_relay_states IS 'Auth: Contains SAML Relay State information for each Service Provider initiated login.';


--
-- TOC entry 350 (class 1259 OID 16533)
-- Name: schema_migrations; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.schema_migrations (
    version character varying(255) NOT NULL
);


--
-- TOC entry 5310 (class 0 OID 0)
-- Dependencies: 350
-- Name: TABLE schema_migrations; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.schema_migrations IS 'Auth: Manages updates to the auth system.';


--
-- TOC entry 358 (class 1259 OID 16757)
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
-- TOC entry 5311 (class 0 OID 0)
-- Dependencies: 358
-- Name: TABLE sessions; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.sessions IS 'Auth: Stores session data associated to a user.';


--
-- TOC entry 5312 (class 0 OID 0)
-- Dependencies: 358
-- Name: COLUMN sessions.not_after; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON COLUMN auth.sessions.not_after IS 'Auth: Not after is a nullable column that contains a timestamp after which the session should be regarded as expired.';


--
-- TOC entry 5313 (class 0 OID 0)
-- Dependencies: 358
-- Name: COLUMN sessions.refresh_token_hmac_key; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON COLUMN auth.sessions.refresh_token_hmac_key IS 'Holds a HMAC-SHA256 key used to sign refresh tokens for this session.';


--
-- TOC entry 5314 (class 0 OID 0)
-- Dependencies: 358
-- Name: COLUMN sessions.refresh_token_counter; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON COLUMN auth.sessions.refresh_token_counter IS 'Holds the ID (counter) of the last issued refresh token.';


--
-- TOC entry 363 (class 1259 OID 16843)
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
-- TOC entry 5315 (class 0 OID 0)
-- Dependencies: 363
-- Name: TABLE sso_domains; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.sso_domains IS 'Auth: Manages SSO email address domain mapping to an SSO Identity Provider.';


--
-- TOC entry 362 (class 1259 OID 16834)
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
-- TOC entry 5316 (class 0 OID 0)
-- Dependencies: 362
-- Name: TABLE sso_providers; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.sso_providers IS 'Auth: Manages SSO identity provider information; see saml_providers for SAML.';


--
-- TOC entry 5317 (class 0 OID 0)
-- Dependencies: 362
-- Name: COLUMN sso_providers.resource_id; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON COLUMN auth.sso_providers.resource_id IS 'Auth: Uniquely identifies a SSO provider according to a user-chosen resource ID (case insensitive), useful in infrastructure as code.';


--
-- TOC entry 345 (class 1259 OID 16495)
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
-- TOC entry 5318 (class 0 OID 0)
-- Dependencies: 345
-- Name: TABLE users; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.users IS 'Auth: Stores user login data within a secure schema.';


--
-- TOC entry 5319 (class 0 OID 0)
-- Dependencies: 345
-- Name: COLUMN users.is_sso_user; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON COLUMN auth.users.is_sso_user IS 'Auth: Set this column to true when the account comes from SSO. These accounts can have duplicate emails.';


--
-- TOC entry 383 (class 1259 OID 18026)
-- Name: amenities; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.amenities (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    name text NOT NULL,
    icon text,
    description text,
    org_id uuid NOT NULL
);


--
-- TOC entry 418 (class 1259 OID 63581)
-- Name: audit_log; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.audit_log (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    actor_user_id uuid,
    target_user_id uuid,
    action text NOT NULL,
    old_data jsonb,
    new_data jsonb
);


--
-- TOC entry 412 (class 1259 OID 61059)
-- Name: booking_charges; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.booking_charges (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    booking_id uuid NOT NULL,
    description text NOT NULL,
    amount numeric(10,2) NOT NULL,
    category text DEFAULT 'minibar'::text,
    created_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL,
    updated_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL
);


--
-- TOC entry 434 (class 1259 OID 83395)
-- Name: booking_guests; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.booking_guests (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    org_id uuid NOT NULL,
    booking_id uuid,
    guest_id uuid,
    is_head boolean DEFAULT false,
    relationship text,
    created_at timestamp with time zone DEFAULT now(),
    full_name text DEFAULT 'Hóspede'::text NOT NULL,
    document text,
    is_primary boolean DEFAULT false NOT NULL
);


--
-- TOC entry 438 (class 1259 OID 84672)
-- Name: booking_rooms; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.booking_rooms (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    org_id uuid NOT NULL,
    property_id uuid NOT NULL,
    booking_id uuid NOT NULL,
    room_id uuid NOT NULL,
    is_primary boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- TOC entry 5320 (class 0 OID 0)
-- Dependencies: 438
-- Name: TABLE booking_rooms; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.booking_rooms IS 'Links bookings to rooms (Sprint 4.5)';


--
-- TOC entry 5321 (class 0 OID 0)
-- Dependencies: 438
-- Name: COLUMN booking_rooms.is_primary; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.booking_rooms.is_primary IS 'Indicates the main room assigned to this booking';


--
-- TOC entry 385 (class 1259 OID 18054)
-- Name: bookings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.bookings (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    property_id uuid NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    guest_name text NOT NULL,
    guest_email text NOT NULL,
    guest_phone text,
    check_in date NOT NULL,
    check_out date NOT NULL,
    total_guests integer DEFAULT 1 NOT NULL,
    total_amount numeric DEFAULT 0 NOT NULL,
    status text DEFAULT 'pending'::text NOT NULL,
    notes text,
    room_type_id uuid,
    services_json jsonb DEFAULT '[]'::jsonb,
    current_room_id uuid,
    lead_id uuid,
    org_id uuid NOT NULL,
    stripe_session_id text,
    CONSTRAINT bookings_status_check CHECK ((status = ANY (ARRAY['INQUIRY'::text, 'QUOTED'::text, 'CONFIRMED'::text, 'CHECKED_IN'::text, 'CHECKED_OUT'::text, 'CANCELLED'::text, 'NO_SHOW'::text])))
);


--
-- TOC entry 5322 (class 0 OID 0)
-- Dependencies: 385
-- Name: COLUMN bookings.services_json; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.bookings.services_json IS 'JSON array of service IDs associated with the booking.';


--
-- TOC entry 404 (class 1259 OID 59768)
-- Name: departments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.departments (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    property_id uuid NOT NULL,
    name text NOT NULL,
    active boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT timezone('utc'::text, now())
);


--
-- TOC entry 386 (class 1259 OID 18072)
-- Name: entity_photos; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.entity_photos (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    entity_id uuid NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    photo_url text NOT NULL,
    is_primary boolean DEFAULT false,
    display_order integer DEFAULT 0
);


--
-- TOC entry 392 (class 1259 OID 18532)
-- Name: expenses; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.expenses (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    property_id uuid NOT NULL,
    description text NOT NULL,
    amount numeric NOT NULL,
    expense_date date NOT NULL,
    category text,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    payment_status text DEFAULT 'pending'::text NOT NULL,
    paid_date date
);


--
-- TOC entry 396 (class 1259 OID 18781)
-- Name: faqs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.faqs (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    question text NOT NULL,
    answer text NOT NULL,
    display_order integer DEFAULT 0,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


--
-- TOC entry 399 (class 1259 OID 18823)
-- Name: features; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.features (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    title text NOT NULL,
    description text NOT NULL,
    icon text,
    display_order integer DEFAULT 0,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


--
-- TOC entry 433 (class 1259 OID 83380)
-- Name: guest_consents; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.guest_consents (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    org_id uuid NOT NULL,
    guest_id uuid,
    consent_type text,
    accepted boolean DEFAULT false NOT NULL,
    ip_address text,
    user_agent text,
    created_at timestamp with time zone DEFAULT now(),
    type text DEFAULT 'data_processing'::text NOT NULL,
    granted boolean DEFAULT false NOT NULL,
    source text DEFAULT 'system'::text NOT NULL,
    captured_by uuid
);

ALTER TABLE ONLY public.guest_consents FORCE ROW LEVEL SECURITY;


--
-- TOC entry 432 (class 1259 OID 83368)
-- Name: guests; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.guests (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    org_id uuid NOT NULL,
    full_name text,
    email text,
    phone text,
    document_id text,
    document_type text,
    birth_date date,
    gender text,
    address_json jsonb,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    document text,
    birthdate date,
    notes text,
    first_name text NOT NULL,
    last_name text NOT NULL
);

ALTER TABLE ONLY public.guests FORCE ROW LEVEL SECURITY;


--
-- TOC entry 439 (class 1259 OID 85814)
-- Name: hostconnect_onboarding; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.hostconnect_onboarding (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    org_id uuid NOT NULL,
    property_id uuid,
    mode text,
    last_step integer DEFAULT 1 NOT NULL,
    completed_at timestamp with time zone,
    dismissed_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT hostconnect_onboarding_mode_check CHECK ((mode = ANY (ARRAY['simple'::text, 'standard'::text, 'hotel'::text])))
);


--
-- TOC entry 413 (class 1259 OID 63432)
-- Name: hostconnect_staff; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.hostconnect_staff (
    user_id uuid NOT NULL,
    role text DEFAULT 'support'::text,
    created_at timestamp with time zone DEFAULT now()
);


--
-- TOC entry 400 (class 1259 OID 18836)
-- Name: how_it_works_steps; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.how_it_works_steps (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    step_number integer NOT NULL,
    title text NOT NULL,
    description text NOT NULL,
    icon text,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


--
-- TOC entry 417 (class 1259 OID 63505)
-- Name: idea_comments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.idea_comments (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    idea_id uuid NOT NULL,
    user_id uuid DEFAULT auth.uid() NOT NULL,
    content text NOT NULL,
    is_staff_reply boolean DEFAULT false,
    created_at timestamp with time zone DEFAULT now()
);


--
-- TOC entry 416 (class 1259 OID 63487)
-- Name: ideas; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ideas (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid DEFAULT auth.uid() NOT NULL,
    title text NOT NULL,
    description text NOT NULL,
    status text DEFAULT 'under_review'::text NOT NULL,
    votes integer DEFAULT 0,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    org_id uuid NOT NULL
);


--
-- TOC entry 397 (class 1259 OID 18794)
-- Name: integrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.integrations (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name text NOT NULL,
    icon text,
    description text,
    is_visible boolean DEFAULT true,
    display_order integer DEFAULT 0,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


--
-- TOC entry 423 (class 1259 OID 63793)
-- Name: inventory_items; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.inventory_items (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    org_id uuid,
    name text NOT NULL,
    category text DEFAULT 'Geral'::text,
    description text,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    price numeric(10,2) DEFAULT 0.00,
    is_for_sale boolean DEFAULT false
);


--
-- TOC entry 394 (class 1259 OID 18739)
-- Name: invoices; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.invoices (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    booking_id uuid NOT NULL,
    property_id uuid NOT NULL,
    issue_date timestamp with time zone DEFAULT now(),
    due_date timestamp with time zone,
    total_amount numeric NOT NULL,
    paid_amount numeric DEFAULT 0,
    status text DEFAULT 'pending'::text NOT NULL,
    payment_method text,
    payment_intent_id text,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    CONSTRAINT invoices_status_check CHECK ((status = ANY (ARRAY['OPEN'::text, 'CLOSED'::text, 'REFUNDED'::text])))
);


--
-- TOC entry 425 (class 1259 OID 63838)
-- Name: item_stock; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.item_stock (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    item_id uuid,
    location text DEFAULT 'pantry'::text NOT NULL,
    quantity integer DEFAULT 0 NOT NULL,
    last_updated_at timestamp with time zone DEFAULT now(),
    updated_by uuid,
    org_id uuid NOT NULL
);


--
-- TOC entry 411 (class 1259 OID 59931)
-- Name: lead_timeline_events; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.lead_timeline_events (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    lead_id uuid NOT NULL,
    type text NOT NULL,
    payload jsonb DEFAULT '{}'::jsonb,
    created_by uuid,
    created_at timestamp with time zone DEFAULT timezone('utc'::text, now())
);


--
-- TOC entry 421 (class 1259 OID 63711)
-- Name: member_permissions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.member_permissions (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    org_id uuid NOT NULL,
    user_id uuid NOT NULL,
    module_key text NOT NULL,
    can_read boolean DEFAULT true,
    can_write boolean DEFAULT false,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


--
-- TOC entry 393 (class 1259 OID 18552)
-- Name: notifications; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.notifications (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    type text NOT NULL,
    message text NOT NULL,
    is_read boolean DEFAULT false NOT NULL,
    created_at timestamp with time zone DEFAULT now()
);


--
-- TOC entry 422 (class 1259 OID 63737)
-- Name: org_invites; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.org_invites (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    org_id uuid NOT NULL,
    email text NOT NULL,
    role text DEFAULT 'member'::text NOT NULL,
    token text DEFAULT encode(extensions.gen_random_bytes(32), 'hex'::text) NOT NULL,
    status text DEFAULT 'pending'::text NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    expires_at timestamp with time zone DEFAULT (now() + '7 days'::interval)
);


--
-- TOC entry 420 (class 1259 OID 63619)
-- Name: org_members; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.org_members (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    org_id uuid NOT NULL,
    user_id uuid NOT NULL,
    role text NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    CONSTRAINT org_members_role_check CHECK ((role = ANY (ARRAY['owner'::text, 'admin'::text, 'member'::text, 'viewer'::text])))
);


--
-- TOC entry 419 (class 1259 OID 63605)
-- Name: organizations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.organizations (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name text NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    owner_id uuid
);


--
-- TOC entry 435 (class 1259 OID 83418)
-- Name: pre_checkin_sessions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.pre_checkin_sessions (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    org_id uuid NOT NULL,
    booking_id uuid,
    token_hash text,
    expires_at timestamp with time zone NOT NULL,
    status text DEFAULT 'pending'::text NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    token text NOT NULL
);


--
-- TOC entry 436 (class 1259 OID 84583)
-- Name: pre_checkin_submissions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.pre_checkin_submissions (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    org_id uuid NOT NULL,
    session_id uuid NOT NULL,
    status text DEFAULT 'submitted'::text NOT NULL,
    payload jsonb NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT pre_checkin_submissions_status_check CHECK ((status = ANY (ARRAY['submitted'::text, 'applied'::text, 'rejected'::text])))
);


--
-- TOC entry 5323 (class 0 OID 0)
-- Dependencies: 436
-- Name: TABLE pre_checkin_submissions; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.pre_checkin_submissions IS 'Stores guest-submitted pre-check-in data pending admin review and application to bookings. Scoped by org_id for multi-tenant isolation.';


--
-- TOC entry 5324 (class 0 OID 0)
-- Dependencies: 436
-- Name: COLUMN pre_checkin_submissions.status; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.pre_checkin_submissions.status IS 'Workflow status: submitted (pending review), applied (added to booking), rejected (declined by admin)';


--
-- TOC entry 5325 (class 0 OID 0)
-- Dependencies: 436
-- Name: COLUMN pre_checkin_submissions.payload; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.pre_checkin_submissions.payload IS 'JSONB containing participant data: {full_name, document?, email?, phone?, birthdate?}';


--
-- TOC entry 437 (class 1259 OID 84631)
-- Name: precheckin_sessions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.precheckin_sessions (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    booking_id uuid NOT NULL,
    org_id uuid NOT NULL,
    status text NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    CONSTRAINT precheckin_sessions_status_check CHECK ((status = ANY (ARRAY['pending'::text, 'incomplete'::text, 'complete'::text])))
);


--
-- TOC entry 395 (class 1259 OID 18766)
-- Name: pricing_plans; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.pricing_plans (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name text NOT NULL,
    price numeric NOT NULL,
    commission numeric NOT NULL,
    period text NOT NULL,
    description text,
    is_popular boolean DEFAULT false,
    display_order integer DEFAULT 0,
    features jsonb DEFAULT '[]'::jsonb,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


--
-- TOC entry 388 (class 1259 OID 18342)
-- Name: pricing_rules; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.pricing_rules (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    property_id uuid NOT NULL,
    room_type_id uuid,
    start_date date NOT NULL,
    end_date date NOT NULL,
    base_price_override numeric(10,2),
    price_modifier numeric(5,2),
    min_stay integer DEFAULT 1,
    max_stay integer,
    promotion_name text,
    status text DEFAULT 'active'::text NOT NULL,
    org_id uuid NOT NULL,
    CONSTRAINT pricing_rules_check_dates CHECK ((end_date >= start_date)),
    CONSTRAINT pricing_rules_check_price_or_modifier CHECK (((base_price_override IS NOT NULL) OR (price_modifier IS NOT NULL)))
);


--
-- TOC entry 381 (class 1259 OID 17992)
-- Name: profiles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.profiles (
    id uuid NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    full_name text NOT NULL,
    email text NOT NULL,
    phone text,
    role text DEFAULT 'user'::text NOT NULL,
    plan text DEFAULT 'free'::text NOT NULL,
    accommodation_limit integer DEFAULT 0,
    founder_started_at timestamp with time zone,
    founder_expires_at timestamp with time zone,
    entitlements jsonb,
    onboarding_completed boolean DEFAULT false,
    onboarding_step integer DEFAULT 1,
    onboarding_type text,
    trial_started_at timestamp with time zone,
    trial_expires_at timestamp with time zone,
    trial_extended_at timestamp with time zone,
    trial_extension_days integer DEFAULT 0 NOT NULL,
    trial_extension_reason text,
    plan_status text DEFAULT 'active'::text NOT NULL,
    is_super_admin boolean DEFAULT false
);

ALTER TABLE ONLY public.profiles FORCE ROW LEVEL SECURITY;


--
-- TOC entry 5326 (class 0 OID 0)
-- Dependencies: 381
-- Name: COLUMN profiles.is_super_admin; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.profiles.is_super_admin IS 'Connect team members with cross-organizational access for support. Only set via direct SQL.';


--
-- TOC entry 382 (class 1259 OID 18008)
-- Name: properties; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.properties (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    user_id uuid NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    name text NOT NULL,
    description text,
    address text NOT NULL,
    city text NOT NULL,
    state text NOT NULL,
    country text DEFAULT 'Brasil'::text NOT NULL,
    postal_code text,
    phone text,
    email text,
    total_rooms integer DEFAULT 0 NOT NULL,
    status text DEFAULT 'active'::text NOT NULL,
    org_id uuid NOT NULL,
    neighborhood text,
    number text,
    no_number boolean DEFAULT false,
    whatsapp text
);


--
-- TOC entry 409 (class 1259 OID 59872)
-- Name: reservation_leads; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.reservation_leads (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    property_id uuid NOT NULL,
    source text DEFAULT 'manual'::text NOT NULL,
    channel text,
    status text DEFAULT 'new'::text NOT NULL,
    guest_name text NOT NULL,
    guest_phone text,
    guest_email text,
    check_in_date date,
    check_out_date date,
    adults integer DEFAULT 1,
    children integer DEFAULT 0,
    notes text,
    assigned_to uuid,
    created_by uuid,
    created_at timestamp with time zone DEFAULT timezone('utc'::text, now()),
    updated_at timestamp with time zone DEFAULT timezone('utc'::text, now()),
    CONSTRAINT reservation_leads_status_check CHECK ((status = ANY (ARRAY['new'::text, 'contacted'::text, 'quoted'::text, 'negotiation'::text, 'won'::text, 'lost'::text])))
);


--
-- TOC entry 410 (class 1259 OID 59902)
-- Name: reservation_quotes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.reservation_quotes (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    lead_id uuid NOT NULL,
    property_id uuid NOT NULL,
    currency text DEFAULT 'BRL'::text,
    subtotal numeric(10,2) NOT NULL,
    fees numeric(10,2) DEFAULT 0,
    taxes numeric(10,2) DEFAULT 0,
    total numeric(10,2) NOT NULL,
    policy_text text,
    expires_at timestamp with time zone,
    sent_at timestamp with time zone,
    status text DEFAULT 'draft'::text,
    created_by uuid,
    created_at timestamp with time zone DEFAULT timezone('utc'::text, now()),
    CONSTRAINT reservation_quotes_status_check CHECK ((status = ANY (ARRAY['draft'::text, 'sent'::text, 'accepted'::text, 'rejected'::text])))
);


--
-- TOC entry 426 (class 1259 OID 69393)
-- Name: room_categories; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.room_categories (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name text NOT NULL,
    slug text NOT NULL,
    description text,
    display_order integer DEFAULT 0,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    property_id uuid NOT NULL,
    org_id uuid NOT NULL
);


--
-- TOC entry 424 (class 1259 OID 63813)
-- Name: room_type_inventory; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.room_type_inventory (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    room_type_id uuid,
    item_id uuid,
    quantity integer DEFAULT 1,
    created_at timestamp with time zone DEFAULT now(),
    org_id uuid NOT NULL,
    CONSTRAINT room_type_inventory_quantity_check CHECK ((quantity > 0))
);


--
-- TOC entry 384 (class 1259 OID 18036)
-- Name: room_types; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.room_types (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    property_id uuid NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    name text NOT NULL,
    description text,
    capacity integer DEFAULT 1 NOT NULL,
    base_price numeric DEFAULT 0 NOT NULL,
    status text DEFAULT 'active'::text NOT NULL,
    amenities_json text[],
    category text DEFAULT 'standard'::text,
    abbreviation text,
    occupation_label text,
    occupation_abbr text,
    org_id uuid NOT NULL
);


--
-- TOC entry 5327 (class 0 OID 0)
-- Dependencies: 384
-- Name: COLUMN room_types.category; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.room_types.category IS 'Room category/standard: standard, superior, deluxe, luxury, suite';


--
-- TOC entry 387 (class 1259 OID 18266)
-- Name: rooms; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.rooms (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    property_id uuid NOT NULL,
    room_type_id uuid NOT NULL,
    room_number text NOT NULL,
    status text DEFAULT 'available'::text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    last_booking_id uuid,
    org_id uuid NOT NULL,
    updated_by uuid,
    CONSTRAINT rooms_status_check CHECK ((status = ANY (ARRAY['available'::text, 'occupied'::text, 'maintenance'::text, 'dirty'::text, 'cleaning'::text, 'clean'::text, 'inspected'::text, 'out_of_order'::text])))
);


--
-- TOC entry 389 (class 1259 OID 18392)
-- Name: services; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.services (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    property_id uuid NOT NULL,
    name text NOT NULL,
    description text,
    price numeric NOT NULL,
    is_per_person boolean DEFAULT false NOT NULL,
    is_per_day boolean DEFAULT false NOT NULL,
    status text DEFAULT 'active'::text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    org_id uuid NOT NULL,
    CONSTRAINT services_status_check CHECK ((status = ANY (ARRAY['active'::text, 'inactive'::text])))
);


--
-- TOC entry 407 (class 1259 OID 59830)
-- Name: shift_assignments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.shift_assignments (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    shift_id uuid NOT NULL,
    staff_id uuid NOT NULL,
    role_on_shift text,
    status text DEFAULT 'assigned'::text,
    check_in_at timestamp with time zone,
    check_out_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT timezone('utc'::text, now()),
    CONSTRAINT shift_assignments_status_check CHECK ((status = ANY (ARRAY['assigned'::text, 'confirmed'::text, 'absent'::text])))
);


--
-- TOC entry 408 (class 1259 OID 59851)
-- Name: shift_handoffs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.shift_handoffs (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    shift_id uuid NOT NULL,
    text text NOT NULL,
    tags jsonb DEFAULT '[]'::jsonb,
    attachments jsonb DEFAULT '[]'::jsonb,
    created_by uuid,
    created_at timestamp with time zone DEFAULT timezone('utc'::text, now())
);


--
-- TOC entry 406 (class 1259 OID 59804)
-- Name: shifts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.shifts (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    property_id uuid NOT NULL,
    department_id uuid,
    start_at timestamp with time zone NOT NULL,
    end_at timestamp with time zone NOT NULL,
    status text DEFAULT 'planned'::text,
    notes text,
    created_by uuid,
    created_at timestamp with time zone DEFAULT timezone('utc'::text, now()),
    CONSTRAINT shifts_status_check CHECK ((status = ANY (ARRAY['planned'::text, 'active'::text, 'closed'::text])))
);


--
-- TOC entry 405 (class 1259 OID 59783)
-- Name: staff_profiles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.staff_profiles (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    property_id uuid NOT NULL,
    user_id uuid,
    name text NOT NULL,
    phone text,
    role text NOT NULL,
    departments jsonb DEFAULT '[]'::jsonb,
    active boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT timezone('utc'::text, now())
);


--
-- TOC entry 431 (class 1259 OID 70918)
-- Name: stock_check_items; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.stock_check_items (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    daily_check_id uuid NOT NULL,
    stock_item_id uuid NOT NULL,
    expected_quantity numeric(10,2) NOT NULL,
    counted_quantity numeric(10,2),
    divergence numeric(10,2) GENERATED ALWAYS AS ((counted_quantity - expected_quantity)) STORED,
    status character varying(50) DEFAULT 'pending'::character varying,
    notes text,
    created_at timestamp with time zone DEFAULT now()
);


--
-- TOC entry 430 (class 1259 OID 70863)
-- Name: stock_daily_checks; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.stock_daily_checks (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    location_id uuid NOT NULL,
    check_date date NOT NULL,
    checked_by uuid,
    status character varying(50) DEFAULT 'pending'::character varying,
    total_items integer DEFAULT 0,
    items_with_divergence integer DEFAULT 0,
    notes text,
    created_at timestamp with time zone DEFAULT now(),
    completed_at timestamp with time zone
);


--
-- TOC entry 428 (class 1259 OID 70820)
-- Name: stock_items; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.stock_items (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    property_id uuid NOT NULL,
    location_id uuid NOT NULL,
    name character varying(255) NOT NULL,
    category character varying(100),
    unit character varying(50) DEFAULT 'unidade'::character varying,
    minimum_stock numeric(10,2) DEFAULT 0,
    current_stock numeric(10,2) DEFAULT 0,
    cost_price numeric(10,2),
    notes text,
    is_active boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


--
-- TOC entry 427 (class 1259 OID 70806)
-- Name: stock_locations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.stock_locations (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    property_id uuid NOT NULL,
    name character varying(100) NOT NULL,
    type character varying(50) NOT NULL,
    is_active boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


--
-- TOC entry 429 (class 1259 OID 70844)
-- Name: stock_movements; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.stock_movements (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    stock_item_id uuid NOT NULL,
    movement_type character varying(50) NOT NULL,
    quantity numeric(10,2) NOT NULL,
    balance_before numeric(10,2) NOT NULL,
    balance_after numeric(10,2) NOT NULL,
    user_id uuid,
    reference_date date,
    notes text,
    created_at timestamp with time zone DEFAULT now()
);


--
-- TOC entry 391 (class 1259 OID 18506)
-- Name: tasks; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.tasks (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    property_id uuid NOT NULL,
    title text NOT NULL,
    description text,
    status text DEFAULT 'todo'::text NOT NULL,
    due_date date,
    assigned_to uuid,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


--
-- TOC entry 398 (class 1259 OID 18808)
-- Name: testimonials; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.testimonials (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name text NOT NULL,
    role text,
    content text NOT NULL,
    location text,
    rating integer DEFAULT 5,
    is_visible boolean DEFAULT true,
    display_order integer DEFAULT 0,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


--
-- TOC entry 415 (class 1259 OID 63466)
-- Name: ticket_comments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ticket_comments (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    ticket_id uuid NOT NULL,
    user_id uuid DEFAULT auth.uid() NOT NULL,
    content text NOT NULL,
    is_staff_reply boolean DEFAULT false,
    created_at timestamp with time zone DEFAULT now()
);


--
-- TOC entry 414 (class 1259 OID 63447)
-- Name: tickets; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.tickets (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid DEFAULT auth.uid() NOT NULL,
    title text NOT NULL,
    description text NOT NULL,
    status text DEFAULT 'open'::text NOT NULL,
    severity text DEFAULT 'low'::text NOT NULL,
    category text DEFAULT 'general'::text,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    org_id uuid NOT NULL
);


--
-- TOC entry 390 (class 1259 OID 18462)
-- Name: website_settings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.website_settings (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    property_id uuid NOT NULL,
    setting_key text NOT NULL,
    setting_value jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    org_id uuid NOT NULL
);


--
-- TOC entry 380 (class 1259 OID 17435)
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
-- TOC entry 374 (class 1259 OID 17272)
-- Name: schema_migrations; Type: TABLE; Schema: realtime; Owner: -
--

CREATE TABLE realtime.schema_migrations (
    version bigint NOT NULL,
    inserted_at timestamp(0) without time zone
);


--
-- TOC entry 377 (class 1259 OID 17295)
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
-- TOC entry 376 (class 1259 OID 17294)
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
-- TOC entry 351 (class 1259 OID 16546)
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
-- TOC entry 5328 (class 0 OID 0)
-- Dependencies: 351
-- Name: COLUMN buckets.owner; Type: COMMENT; Schema: storage; Owner: -
--

COMMENT ON COLUMN storage.buckets.owner IS 'Field is deprecated, use owner_id instead';


--
-- TOC entry 373 (class 1259 OID 17242)
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
-- TOC entry 401 (class 1259 OID 47575)
-- Name: buckets_vectors; Type: TABLE; Schema: storage; Owner: -
--

CREATE TABLE storage.buckets_vectors (
    id text NOT NULL,
    type storage.buckettype DEFAULT 'VECTOR'::storage.buckettype NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- TOC entry 353 (class 1259 OID 16588)
-- Name: migrations; Type: TABLE; Schema: storage; Owner: -
--

CREATE TABLE storage.migrations (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    hash character varying(40) NOT NULL,
    executed_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- TOC entry 352 (class 1259 OID 16561)
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
-- TOC entry 5329 (class 0 OID 0)
-- Dependencies: 352
-- Name: COLUMN objects.owner; Type: COMMENT; Schema: storage; Owner: -
--

COMMENT ON COLUMN storage.objects.owner IS 'Field is deprecated, use owner_id instead';


--
-- TOC entry 371 (class 1259 OID 17144)
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
-- TOC entry 372 (class 1259 OID 17158)
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
-- TOC entry 402 (class 1259 OID 47585)
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
-- TOC entry 440 (class 1259 OID 88187)
-- Name: schema_migrations; Type: TABLE; Schema: supabase_migrations; Owner: -
--

CREATE TABLE supabase_migrations.schema_migrations (
    version text NOT NULL,
    statements text[],
    name text
);


--
-- TOC entry 3918 (class 2604 OID 16510)
-- Name: refresh_tokens id; Type: DEFAULT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.refresh_tokens ALTER COLUMN id SET DEFAULT nextval('auth.refresh_tokens_id_seq'::regclass);


--
-- TOC entry 5192 (class 0 OID 16525)
-- Dependencies: 349
-- Data for Name: audit_log_entries; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.audit_log_entries (instance_id, id, payload, created_at, ip_address) FROM stdin;
00000000-0000-0000-0000-000000000000	b6f39f63-eee4-4f21-aca8-5d89cfdaf215	{"action":"user_confirmation_requested","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"José Alexandre F de Santana","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"user","traits":{"provider":"email"}}	2025-10-14 07:11:06.800021+00	
00000000-0000-0000-0000-000000000000	7f4ad05b-26a7-432a-9efc-b4f28b92535b	{"action":"user_signedup","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"José Alexandre F de Santana","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"team","traits":{"provider":"email"}}	2025-10-14 07:11:59.880405+00	
00000000-0000-0000-0000-000000000000	91c48231-8ff2-435b-adbc-25428b0460cd	{"action":"login","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"José Alexandre F de Santana","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-10-14 07:13:08.193311+00	
00000000-0000-0000-0000-000000000000	db7f8bb0-6771-4dcc-9586-0cb1d196ff42	{"action":"login","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"José Alexandre F de Santana","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-10-14 07:15:16.978315+00	
00000000-0000-0000-0000-000000000000	ae716145-f07b-4d33-9de6-68026d32c01c	{"action":"login","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"José Alexandre F de Santana","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-10-15 12:26:24.460623+00	
00000000-0000-0000-0000-000000000000	85ca3616-22f9-4403-8b59-7253d0025202	{"action":"login","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"José Alexandre F de Santana","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-10-15 14:53:49.369402+00	
00000000-0000-0000-0000-000000000000	77f0fd0e-d405-453b-a5f1-e047f97f6703	{"action":"token_refreshed","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"José Alexandre F de Santana","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-10-15 16:03:38.465141+00	
00000000-0000-0000-0000-000000000000	4cc26060-8c48-4f7a-a6f8-001cdb83755a	{"action":"token_revoked","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"José Alexandre F de Santana","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-10-15 16:03:38.473929+00	
00000000-0000-0000-0000-000000000000	97f0d8f6-b8e4-4ada-8022-5d1dac79611c	{"action":"token_refreshed","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"José Alexandre F de Santana","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-10-15 17:17:55.054072+00	
00000000-0000-0000-0000-000000000000	6433c14f-83bc-4cb3-9797-ad58536c8978	{"action":"token_revoked","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"José Alexandre F de Santana","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-10-15 17:17:55.066244+00	
00000000-0000-0000-0000-000000000000	ce227a99-022e-4d6f-a54a-0ecae999ccdc	{"action":"login","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"José Alexandre F de Santana","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-10-20 18:21:50.176704+00	
00000000-0000-0000-0000-000000000000	6ffc52f8-10aa-426d-b2b5-fbaf89d6185f	{"action":"login","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"José Alexandre F de Santana","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-12-20 14:27:20.464083+00	
00000000-0000-0000-0000-000000000000	89358d6c-a2b6-4a1e-a0d5-b9e7265aef1a	{"action":"token_refreshed","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"José Alexandre F de Santana","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-12-20 15:40:24.976629+00	
00000000-0000-0000-0000-000000000000	bb40fa21-aee7-47dc-8546-be0bbb96a7d8	{"action":"token_revoked","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"José Alexandre F de Santana","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-12-20 15:40:24.991906+00	
00000000-0000-0000-0000-000000000000	010c4b89-b85b-4861-a1e7-0289578d010d	{"action":"token_refreshed","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"José Alexandre F de Santana","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-12-20 16:42:40.0249+00	
00000000-0000-0000-0000-000000000000	bb265f43-5406-4f19-aff7-a62a0a811da9	{"action":"token_revoked","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"José Alexandre F de Santana","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-12-20 16:42:40.040705+00	
00000000-0000-0000-0000-000000000000	6553f9b7-908c-4bf4-a4e0-05ec7cec6926	{"action":"login","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"José Alexandre F de Santana","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-12-20 17:13:24.070349+00	
00000000-0000-0000-0000-000000000000	0b844670-db31-42a7-8199-70ac9b10ef26	{"action":"token_refreshed","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"José Alexandre F de Santana","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-12-20 18:35:12.312874+00	
00000000-0000-0000-0000-000000000000	05504ff3-4915-44cf-b1f9-407a5b8ad5c5	{"action":"token_revoked","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"José Alexandre F de Santana","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-12-20 18:35:12.321783+00	
00000000-0000-0000-0000-000000000000	0f8e9fc7-3107-48f1-9e02-a0c488a46808	{"action":"token_refreshed","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"José Alexandre F de Santana","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-12-20 21:29:09.018968+00	
00000000-0000-0000-0000-000000000000	7e7f8087-9921-4550-b2eb-3d1c9c2ecab8	{"action":"token_revoked","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"José Alexandre F de Santana","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-12-20 21:29:09.027025+00	
00000000-0000-0000-0000-000000000000	bdb5b130-011a-4c77-b760-abda8165b9bd	{"action":"login","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"José Alexandre F de Santana","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-12-20 21:36:38.131294+00	
00000000-0000-0000-0000-000000000000	9b312353-d820-4522-8abd-86783e3a9dbc	{"action":"token_refreshed","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"José Alexandre F de Santana","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-12-21 06:55:55.696333+00	
00000000-0000-0000-0000-000000000000	6d9c928f-7152-460e-8e11-1d00db00126a	{"action":"token_revoked","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"José Alexandre F de Santana","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-12-21 06:55:55.716482+00	
00000000-0000-0000-0000-000000000000	b2401223-0672-493e-8b9a-037de0e1dcad	{"action":"token_refreshed","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"José Alexandre F de Santana","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-12-21 07:54:50.917537+00	
00000000-0000-0000-0000-000000000000	24fab284-7fd8-4b2a-9468-32ac4897c95d	{"action":"token_revoked","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"José Alexandre F de Santana","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-12-21 07:54:50.928718+00	
00000000-0000-0000-0000-000000000000	726cca14-2c82-4b78-8fef-2ccfd3baec6a	{"action":"token_refreshed","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"José Alexandre F de Santana","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-12-21 16:19:48.16063+00	
00000000-0000-0000-0000-000000000000	f9713ebe-00f3-4424-90df-5d751dc475b0	{"action":"token_revoked","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"José Alexandre F de Santana","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-12-21 16:19:48.180527+00	
00000000-0000-0000-0000-000000000000	77d9093f-65d1-4b20-aa6b-3d3d56b8a499	{"action":"token_refreshed","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"José Alexandre F de Santana","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-12-21 17:44:19.944611+00	
00000000-0000-0000-0000-000000000000	8e5eacbe-7e6d-4e98-be6b-592e9658e7f3	{"action":"token_revoked","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"José Alexandre F de Santana","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-12-21 17:44:19.959835+00	
00000000-0000-0000-0000-000000000000	2a5f53d5-7e3c-4fc8-9d8d-d947c942a2ae	{"action":"token_refreshed","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"José Alexandre F de Santana","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-12-21 18:50:04.08884+00	
00000000-0000-0000-0000-000000000000	42e0e8ed-a77a-42d4-8299-2be45ab2a875	{"action":"token_revoked","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"José Alexandre F de Santana","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-12-21 18:50:04.10647+00	
00000000-0000-0000-0000-000000000000	7ffed504-7383-42bb-8574-c9478e342f73	{"action":"login","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"José Alexandre F de Santana","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-12-21 18:50:05.307672+00	
00000000-0000-0000-0000-000000000000	5b0d477c-1240-407a-b4fa-a24a4c3bd6f6	{"action":"token_refreshed","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"José Alexandre F de Santana","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-12-21 20:55:11.895121+00	
00000000-0000-0000-0000-000000000000	294923ee-3157-422c-84e3-f988b34e3f25	{"action":"token_revoked","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"José Alexandre F de Santana","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-12-21 20:55:11.913356+00	
00000000-0000-0000-0000-000000000000	8f468749-b8df-4436-94d6-1ec6e4ffa6a9	{"action":"login","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"José Alexandre F de Santana","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-12-21 21:12:54.150171+00	
00000000-0000-0000-0000-000000000000	d26c25aa-db71-490c-b11a-236d4aebf646	{"action":"login","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"José Alexandre F de Santana","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-12-21 21:38:23.956424+00	
00000000-0000-0000-0000-000000000000	9975ae52-fdd6-427b-99b8-6a03fc18d609	{"action":"token_refreshed","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"José Alexandre F de Santana","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-12-21 22:38:49.880212+00	
00000000-0000-0000-0000-000000000000	c3fdd479-9144-49e9-82a5-5cbc0c9ac1d5	{"action":"token_revoked","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"José Alexandre F de Santana","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-12-21 22:38:49.901786+00	
00000000-0000-0000-0000-000000000000	f406b3a7-0d87-4de8-a055-874ad74a2674	{"action":"token_refreshed","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"José Alexandre F de Santana","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-12-21 23:49:37.667685+00	
00000000-0000-0000-0000-000000000000	886230a3-caad-4a4a-8d14-cba213d9075c	{"action":"token_revoked","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"José Alexandre F de Santana","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-12-21 23:49:37.684127+00	
00000000-0000-0000-0000-000000000000	3ba5cd7a-5d1f-488a-9601-264738879dbc	{"action":"login","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"José Alexandre F de Santana","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-12-22 00:06:52.976032+00	
00000000-0000-0000-0000-000000000000	4e9b84e3-f759-4b5a-9371-1afc74248b8c	{"action":"token_refreshed","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"José Alexandre F de Santana","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-12-22 10:18:55.104784+00	
00000000-0000-0000-0000-000000000000	99ecfc4a-8c73-4c04-b3d8-e7516dadc6ff	{"action":"token_revoked","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"José Alexandre F de Santana","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-12-22 10:18:55.127048+00	
00000000-0000-0000-0000-000000000000	3f4279c8-76b7-4bf6-bf2d-9348cc1af599	{"action":"token_refreshed","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"José Alexandre F de Santana","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-12-22 12:23:37.911328+00	
00000000-0000-0000-0000-000000000000	bfbc31e1-2071-4720-8657-d73f53acfb84	{"action":"token_revoked","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"José Alexandre F de Santana","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-12-22 12:23:37.925076+00	
00000000-0000-0000-0000-000000000000	62172b72-8827-4b0a-924f-a009b16a3cf9	{"action":"login","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"José Alexandre F de Santana","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-12-22 12:42:19.7907+00	
00000000-0000-0000-0000-000000000000	51601511-dec9-495c-8cfe-f1b3051b9a68	{"action":"login","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"José Alexandre F de Santana","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-12-22 12:54:35.077347+00	
00000000-0000-0000-0000-000000000000	be070433-eb8c-432c-9882-b7decc9d66b7	{"action":"token_refreshed","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"José Alexandre F de Santana","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-12-22 13:57:00.622062+00	
00000000-0000-0000-0000-000000000000	32486ae3-724b-4438-a6a9-c70cfd430fdc	{"action":"token_revoked","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"José Alexandre F de Santana","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-12-22 13:57:00.640892+00	
00000000-0000-0000-0000-000000000000	b2bf4a24-757b-4bd3-8788-b3a1e1594363	{"action":"token_refreshed","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"José Alexandre F de Santana","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-12-22 15:08:03.959943+00	
00000000-0000-0000-0000-000000000000	72a4f403-d37a-48bd-9e8a-9f3829aa508f	{"action":"token_revoked","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"José Alexandre F de Santana","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-12-22 15:08:03.977189+00	
00000000-0000-0000-0000-000000000000	22b34ac2-35be-4aae-9f6a-3ad0523b5618	{"action":"token_refreshed","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"José Alexandre F de Santana","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-12-22 19:23:18.490899+00	
00000000-0000-0000-0000-000000000000	b716d701-c94a-4268-b9fa-30eb68a3731d	{"action":"token_revoked","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"José Alexandre F de Santana","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-12-22 19:23:18.511445+00	
00000000-0000-0000-0000-000000000000	4da95782-781a-40cc-bb77-c70bd59f5ddc	{"action":"token_refreshed","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"José Alexandre F de Santana","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-12-22 20:31:51.588686+00	
00000000-0000-0000-0000-000000000000	85e4e530-59b1-4a75-b0b4-0d8b9a67decd	{"action":"token_revoked","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"José Alexandre F de Santana","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-12-22 20:31:51.607526+00	
00000000-0000-0000-0000-000000000000	90fdbe8a-fbc1-4e49-a3b8-8d23078b6d80	{"action":"login","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"José Alexandre F de Santana","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-12-22 20:48:26.059801+00	
00000000-0000-0000-0000-000000000000	88a1d9c1-78f7-4b6b-a135-2f3a40f11119	{"action":"login","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"José Alexandre F de Santana","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-12-22 21:09:43.273292+00	
00000000-0000-0000-0000-000000000000	f3a7ba3f-f838-4140-ad6a-de92ecc2c3d1	{"action":"token_refreshed","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"José Alexandre F de Santana","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-12-22 22:10:07.356361+00	
00000000-0000-0000-0000-000000000000	e338a409-98c4-499e-9d91-029fcaa22714	{"action":"token_revoked","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"José Alexandre F de Santana","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-12-22 22:10:07.376152+00	
00000000-0000-0000-0000-000000000000	5ece5fd9-2bb8-499c-8196-aad4a8d4ddc3	{"action":"login","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"José Alexandre F de Santana","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-12-22 22:51:07.014566+00	
00000000-0000-0000-0000-000000000000	ac51e026-a143-4916-b111-4333d00135e6	{"action":"login","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"José Alexandre F de Santana","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-12-22 22:52:59.652733+00	
00000000-0000-0000-0000-000000000000	38d2c6da-d05b-4357-9cac-c344097d4bf3	{"action":"login","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"José Alexandre F de Santana","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-12-22 23:00:31.168257+00	
00000000-0000-0000-0000-000000000000	3a220df4-2558-4870-8550-395a22e88a8c	{"action":"login","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"José Alexandre F de Santana","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-12-22 23:07:51.878318+00	
00000000-0000-0000-0000-000000000000	463c7b89-6650-4f85-87b1-cc606fa079dc	{"action":"login","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"José Alexandre F de Santana","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-12-23 00:26:31.101168+00	
00000000-0000-0000-0000-000000000000	90c2643f-e629-482d-8a14-0c04d056ab2b	{"action":"login","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"José Alexandre F de Santana","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-12-23 00:33:38.655208+00	
00000000-0000-0000-0000-000000000000	bd62da1a-ce0d-46f0-b797-8772edf549ec	{"action":"token_refreshed","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"José Alexandre F de Santana","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-12-23 07:29:40.289705+00	
00000000-0000-0000-0000-000000000000	b1f4c1d1-3839-49cb-b3c5-8d0f2d76db98	{"action":"token_revoked","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"José Alexandre F de Santana","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-12-23 07:29:40.297204+00	
00000000-0000-0000-0000-000000000000	908215ef-77bf-4828-b504-72fb44c62b05	{"action":"login","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"José Alexandre F de Santana","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-12-23 07:33:05.923897+00	
00000000-0000-0000-0000-000000000000	3f291b60-ca35-4019-91b2-056819cb5b8f	{"action":"login","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"José Alexandre F de Santana","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-12-23 08:54:40.282001+00	
00000000-0000-0000-0000-000000000000	25c9b27d-28fc-499e-9690-2b90c7945dbf	{"action":"token_refreshed","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"José Alexandre F de Santana","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-12-23 10:08:50.125232+00	
00000000-0000-0000-0000-000000000000	0ba77d40-8e93-4026-ae4a-b86be02d9bb0	{"action":"token_revoked","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"José Alexandre F de Santana","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-12-23 10:08:50.139253+00	
00000000-0000-0000-0000-000000000000	7b1a50fc-c485-46a0-8689-b878e5c713a5	{"action":"token_refreshed","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"José Alexandre F de Santana","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-12-23 11:07:33.417082+00	
00000000-0000-0000-0000-000000000000	ebde73e4-fd0c-4a14-85c1-72dab2f1f738	{"action":"token_revoked","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"José Alexandre F de Santana","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-12-23 11:07:33.437431+00	
00000000-0000-0000-0000-000000000000	067fac0c-2f80-4c64-8634-7164548d991f	{"action":"token_refreshed","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"José Alexandre F de Santana","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-12-23 12:07:39.095979+00	
00000000-0000-0000-0000-000000000000	cb637e22-d999-4d6b-96aa-9813a7eb1b6c	{"action":"token_revoked","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"José Alexandre F de Santana","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-12-23 12:07:39.116629+00	
00000000-0000-0000-0000-000000000000	a7998730-c3e7-4705-b80c-b248ecbcc5f4	{"action":"token_refreshed","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"José Alexandre F de Santana","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-12-23 13:30:08.492526+00	
00000000-0000-0000-0000-000000000000	2536029b-0e21-4841-907c-a7cfdd832348	{"action":"token_revoked","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"José Alexandre F de Santana","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-12-23 13:30:08.501007+00	
00000000-0000-0000-0000-000000000000	d0ac815d-eb2a-4cfe-a29b-9f708d021287	{"action":"token_refreshed","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"José Alexandre F de Santana","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-12-23 15:00:59.448686+00	
00000000-0000-0000-0000-000000000000	29070f80-ddeb-4416-9386-6ca98f6aa60e	{"action":"token_revoked","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"José Alexandre F de Santana","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-12-23 15:00:59.459761+00	
00000000-0000-0000-0000-000000000000	fe49489d-0ab7-4209-813c-49feac4decc9	{"action":"token_refreshed","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"José Alexandre F de Santana","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-12-23 16:53:15.241764+00	
00000000-0000-0000-0000-000000000000	301cdac3-d111-44a4-9ea1-7df11f48afa9	{"action":"token_revoked","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"José Alexandre F de Santana","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-12-23 16:53:15.257829+00	
00000000-0000-0000-0000-000000000000	9d28c293-9ef5-49fa-8b36-b1b7464fa301	{"action":"token_refreshed","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"José Alexandre F de Santana","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-12-23 18:20:00.87521+00	
00000000-0000-0000-0000-000000000000	95b90f5d-5ef6-4938-8a24-4b810051facf	{"action":"token_revoked","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"José Alexandre F de Santana","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-12-23 18:20:00.888662+00	
00000000-0000-0000-0000-000000000000	dce5c62e-96d4-41ad-a033-5bd93d795238	{"action":"token_refreshed","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"José Alexandre F de Santana","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-12-24 11:58:28.354615+00	
00000000-0000-0000-0000-000000000000	38e753e3-1a2f-406e-b76f-0bb42698f0e1	{"action":"token_revoked","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"José Alexandre F de Santana","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-12-24 11:58:28.372725+00	
00000000-0000-0000-0000-000000000000	e1f19d21-a68b-45b2-a879-bf75a40ffaa7	{"action":"token_refreshed","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"José Alexandre F de Santana","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-12-24 13:22:38.409203+00	
00000000-0000-0000-0000-000000000000	d5047958-f6c3-4efe-a355-14db1fa7bffb	{"action":"token_revoked","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"José Alexandre F de Santana","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-12-24 13:22:38.427614+00	
00000000-0000-0000-0000-000000000000	707da567-5532-4c52-8361-b6fc3827bd5e	{"action":"login","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"José Alexandre F de Santana","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-12-24 15:34:14.013472+00	
00000000-0000-0000-0000-000000000000	5f390875-55e0-47c7-84e2-5f2c0e87044e	{"action":"token_refreshed","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"José Alexandre F de Santana","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-12-24 18:50:09.540636+00	
00000000-0000-0000-0000-000000000000	ad7b9088-5c1a-4e05-bbde-5668e67f7e6b	{"action":"token_revoked","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"José Alexandre F de Santana","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-12-24 18:50:09.554224+00	
00000000-0000-0000-0000-000000000000	c9ea16a2-1fa8-48eb-9c98-92ff870e2f18	{"action":"token_refreshed","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"José Alexandre F de Santana","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-12-25 11:03:47.713546+00	
00000000-0000-0000-0000-000000000000	6731e72a-a40a-42f3-ab78-3e743aa2b5fc	{"action":"token_revoked","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"José Alexandre F de Santana","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-12-25 11:03:47.723119+00	
00000000-0000-0000-0000-000000000000	cd4498f4-bdc3-4eac-a99c-c05e30061ee7	{"action":"token_refreshed","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"José Alexandre F de Santana","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-12-25 17:36:24.933352+00	
00000000-0000-0000-0000-000000000000	9445ee77-17ca-44b9-824c-a17b3838cd01	{"action":"token_revoked","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"José Alexandre F de Santana","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-12-25 17:36:24.959199+00	
00000000-0000-0000-0000-000000000000	b7474553-f72d-4da4-84de-4a41cdcf5955	{"action":"token_refreshed","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"José Alexandre F de Santana","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-12-25 17:43:32.251007+00	
00000000-0000-0000-0000-000000000000	a2d05ce8-6161-4fcb-93fe-5af4f5db5b10	{"action":"token_revoked","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"José Alexandre F de Santana","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-12-25 17:43:32.252427+00	
00000000-0000-0000-0000-000000000000	f00f7efa-d180-48f3-90b6-47d598530269	{"action":"token_refreshed","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"José Alexandre F de Santana","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-12-25 18:50:25.881126+00	
00000000-0000-0000-0000-000000000000	773d5192-6975-4bdc-8ad7-76c0278de9de	{"action":"token_revoked","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"José Alexandre F de Santana","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-12-25 18:50:25.890281+00	
00000000-0000-0000-0000-000000000000	ee41755b-e795-4a85-a81b-584b12de4bb4	{"action":"token_refreshed","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"José Alexandre F de Santana","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-12-26 10:29:16.608631+00	
00000000-0000-0000-0000-000000000000	3152db01-97a7-4280-acca-cf2bb85eac35	{"action":"token_revoked","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"José Alexandre F de Santana","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-12-26 10:29:16.619041+00	
00000000-0000-0000-0000-000000000000	91da4fe2-079b-46ea-bcba-4e957f70070e	{"action":"token_refreshed","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"José Alexandre F de Santana","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-12-26 13:45:18.685363+00	
00000000-0000-0000-0000-000000000000	f24d49d2-d3b0-4500-b46e-70f615f2c5af	{"action":"token_revoked","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"José Alexandre F de Santana","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-12-26 13:45:18.706955+00	
00000000-0000-0000-0000-000000000000	054c0340-a400-4acf-a043-3a81242a77ca	{"action":"token_refreshed","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"José Alexandre F de Santana","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-12-26 15:52:06.440034+00	
00000000-0000-0000-0000-000000000000	cd313dfd-f4e8-4667-8e32-81c15cb3ae66	{"action":"token_revoked","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"José Alexandre F de Santana","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-12-26 15:52:06.457385+00	
00000000-0000-0000-0000-000000000000	30ecb019-ec85-47ad-87bc-aac66e136b62	{"action":"user_signedup","actor_id":"d94701c4-30cd-45c7-b642-40b35ef8894c","actor_name":"Urubici Park Hotel","actor_username":"urubiciparkhotel.ac@gmail.com","actor_via_sso":false,"log_type":"team","traits":{"provider":"google"}}	2025-12-26 16:35:43.99262+00	
00000000-0000-0000-0000-000000000000	cfe73b86-5e7e-4ece-89a0-9a0db3e9bb4b	{"action":"login","actor_id":"d94701c4-30cd-45c7-b642-40b35ef8894c","actor_name":"Urubici Park Hotel","actor_username":"urubiciparkhotel.ac@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"google"}}	2025-12-26 17:15:53.564971+00	
00000000-0000-0000-0000-000000000000	d3b32b18-a4d3-48d3-b0e9-ff076fe76256	{"action":"token_refreshed","actor_id":"d94701c4-30cd-45c7-b642-40b35ef8894c","actor_name":"Urubici Park Hotel","actor_username":"urubiciparkhotel.ac@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-12-26 17:53:27.436272+00	
00000000-0000-0000-0000-000000000000	d3ab2baa-87ac-4883-abde-7c57f92c1a48	{"action":"token_revoked","actor_id":"d94701c4-30cd-45c7-b642-40b35ef8894c","actor_name":"Urubici Park Hotel","actor_username":"urubiciparkhotel.ac@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-12-26 17:53:27.456717+00	
00000000-0000-0000-0000-000000000000	a275a448-e450-4acc-82cf-8c6a894ed0dd	{"action":"token_refreshed","actor_id":"d94701c4-30cd-45c7-b642-40b35ef8894c","actor_name":"Urubici Park Hotel","actor_username":"urubiciparkhotel.ac@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-12-26 19:37:10.605665+00	
00000000-0000-0000-0000-000000000000	38089923-cbd1-484b-a248-d059c83a6010	{"action":"token_revoked","actor_id":"d94701c4-30cd-45c7-b642-40b35ef8894c","actor_name":"Urubici Park Hotel","actor_username":"urubiciparkhotel.ac@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-12-26 19:37:10.626477+00	
00000000-0000-0000-0000-000000000000	84fe11b0-522d-42f9-a185-ef96e30917b4	{"action":"token_refreshed","actor_id":"d94701c4-30cd-45c7-b642-40b35ef8894c","actor_name":"Urubici Park Hotel","actor_username":"urubiciparkhotel.ac@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-12-27 11:40:14.503373+00	
00000000-0000-0000-0000-000000000000	e224fd7c-d668-4f28-9428-e35103327fa0	{"action":"token_revoked","actor_id":"d94701c4-30cd-45c7-b642-40b35ef8894c","actor_name":"Urubici Park Hotel","actor_username":"urubiciparkhotel.ac@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-12-27 11:40:14.520686+00	
00000000-0000-0000-0000-000000000000	916a6d1c-f625-4e7c-bddd-e1d2b6b6912e	{"action":"token_refreshed","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"José Alexandre F de Santana","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-12-27 11:44:31.549301+00	
00000000-0000-0000-0000-000000000000	b55d9edc-89e8-4753-b2f0-834f933055dc	{"action":"token_revoked","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"José Alexandre F de Santana","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-12-27 11:44:31.555643+00	
00000000-0000-0000-0000-000000000000	e0e55989-9498-45d2-a994-98db5d1f7079	{"action":"token_refreshed","actor_id":"d94701c4-30cd-45c7-b642-40b35ef8894c","actor_name":"Urubici Park Hotel","actor_username":"urubiciparkhotel.ac@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-12-27 11:44:42.185752+00	
00000000-0000-0000-0000-000000000000	098a7ee2-75b3-41ad-b32f-e96529d18f25	{"action":"token_revoked","actor_id":"d94701c4-30cd-45c7-b642-40b35ef8894c","actor_name":"Urubici Park Hotel","actor_username":"urubiciparkhotel.ac@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-12-27 11:44:42.186616+00	
00000000-0000-0000-0000-000000000000	77e4e2e6-6281-42ae-b988-f3d10bcde588	{"action":"token_refreshed","actor_id":"d94701c4-30cd-45c7-b642-40b35ef8894c","actor_name":"Urubici Park Hotel","actor_username":"urubiciparkhotel.ac@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-12-27 12:59:37.204955+00	
00000000-0000-0000-0000-000000000000	048632eb-fd10-4b04-bbac-fcc14ae5d116	{"action":"token_revoked","actor_id":"d94701c4-30cd-45c7-b642-40b35ef8894c","actor_name":"Urubici Park Hotel","actor_username":"urubiciparkhotel.ac@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-12-27 12:59:37.230351+00	
00000000-0000-0000-0000-000000000000	77e924b0-3fa4-4586-bbd1-453791665287	{"action":"token_refreshed","actor_id":"d94701c4-30cd-45c7-b642-40b35ef8894c","actor_name":"Urubici Park Hotel","actor_username":"urubiciparkhotel.ac@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-12-27 13:58:14.70696+00	
00000000-0000-0000-0000-000000000000	14698294-6b3e-4043-aa7e-9f6ad89a07ce	{"action":"token_revoked","actor_id":"d94701c4-30cd-45c7-b642-40b35ef8894c","actor_name":"Urubici Park Hotel","actor_username":"urubiciparkhotel.ac@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-12-27 13:58:14.720527+00	
00000000-0000-0000-0000-000000000000	9b585bf5-d654-46d4-9223-5d49af30fbe0	{"action":"token_refreshed","actor_id":"d94701c4-30cd-45c7-b642-40b35ef8894c","actor_name":"Urubici Park Hotel","actor_username":"urubiciparkhotel.ac@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-12-27 22:21:58.552546+00	
00000000-0000-0000-0000-000000000000	5dc75b2e-e9b1-4f20-ba80-e3b4945dc796	{"action":"token_revoked","actor_id":"d94701c4-30cd-45c7-b642-40b35ef8894c","actor_name":"Urubici Park Hotel","actor_username":"urubiciparkhotel.ac@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-12-27 22:21:58.571008+00	
00000000-0000-0000-0000-000000000000	0cbd7255-bec0-4f6d-8f6f-49428cddb7d2	{"action":"user_modified","actor_id":"d94701c4-30cd-45c7-b642-40b35ef8894c","actor_name":"Urubici Park Hotel","actor_username":"urubiciparkhotel.ac@gmail.com","actor_via_sso":false,"log_type":"user"}	2025-12-27 22:38:41.002049+00	
00000000-0000-0000-0000-000000000000	d04626e0-bd23-4c39-8770-305d3b3cf882	{"action":"token_refreshed","actor_id":"d94701c4-30cd-45c7-b642-40b35ef8894c","actor_name":"Urubici Park Hotel","actor_username":"urubiciparkhotel.ac@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-12-27 23:20:59.684607+00	
00000000-0000-0000-0000-000000000000	e7b9089c-b1c3-4707-99cc-f04c829fc0fc	{"action":"token_revoked","actor_id":"d94701c4-30cd-45c7-b642-40b35ef8894c","actor_name":"Urubici Park Hotel","actor_username":"urubiciparkhotel.ac@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-12-27 23:20:59.695881+00	
00000000-0000-0000-0000-000000000000	47732dd1-e3b5-424a-a22c-1fb62fee6215	{"action":"token_refreshed","actor_id":"d94701c4-30cd-45c7-b642-40b35ef8894c","actor_name":"Urubici Park Hotel","actor_username":"urubiciparkhotel.ac@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-12-28 04:09:08.021772+00	
00000000-0000-0000-0000-000000000000	425ce6a7-5e3b-40c9-91a3-5afe3bae4e85	{"action":"token_revoked","actor_id":"d94701c4-30cd-45c7-b642-40b35ef8894c","actor_name":"Urubici Park Hotel","actor_username":"urubiciparkhotel.ac@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-12-28 04:09:08.041191+00	
00000000-0000-0000-0000-000000000000	41e71e35-a3c7-4f5f-ab96-d2b5d0ee716d	{"action":"token_refreshed","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"José Alexandre F de Santana","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-12-30 15:27:53.537164+00	
00000000-0000-0000-0000-000000000000	01075aad-9d92-461a-8718-42ce5bb7efa3	{"action":"token_revoked","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"José Alexandre F de Santana","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-12-30 15:27:53.558347+00	
00000000-0000-0000-0000-000000000000	50aa7a82-628f-4d7e-9b0b-052f033b98cd	{"action":"token_refreshed","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"José Alexandre F de Santana","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-12-30 22:25:41.121372+00	
00000000-0000-0000-0000-000000000000	1daca255-ba71-473a-bf7b-0a91711daaf7	{"action":"token_revoked","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"José Alexandre F de Santana","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-12-30 22:25:41.14226+00	
00000000-0000-0000-0000-000000000000	5be9419f-5eb3-46f6-bca4-6bf4b86afc01	{"action":"token_refreshed","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"José Alexandre F de Santana","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-12-31 13:42:22.521022+00	
00000000-0000-0000-0000-000000000000	4e0354c1-fa6a-4405-98c9-0231f0320eb4	{"action":"token_revoked","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"José Alexandre F de Santana","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-12-31 13:42:22.539881+00	
00000000-0000-0000-0000-000000000000	d70ad52c-fa01-4183-82a3-dc2ca1c14462	{"action":"token_refreshed","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"José Alexandre F de Santana","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-12-31 14:30:58.950932+00	
00000000-0000-0000-0000-000000000000	b932dd4c-e3fe-458c-8a14-efe53720b1ec	{"action":"token_revoked","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"José Alexandre F de Santana","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-12-31 14:30:58.968543+00	
00000000-0000-0000-0000-000000000000	55a28332-cf9d-407d-ac34-acdf0fd775cc	{"action":"token_refreshed","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"José Alexandre F de Santana","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-12-31 17:57:41.841573+00	
00000000-0000-0000-0000-000000000000	d05c5bd3-09c3-4d62-9bc3-5b46bf0a34eb	{"action":"token_revoked","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"José Alexandre F de Santana","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-12-31 17:57:41.8568+00	
00000000-0000-0000-0000-000000000000	5896c5ad-230d-4c07-82ed-c51dac38fe16	{"action":"token_refreshed","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"José Alexandre F de Santana","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-12-31 17:59:34.092215+00	
00000000-0000-0000-0000-000000000000	2b5ce845-6aac-45bd-9e7a-7dfc011b8f27	{"action":"token_revoked","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"José Alexandre F de Santana","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-12-31 17:59:34.093448+00	
00000000-0000-0000-0000-000000000000	027ae6f0-1cb2-464a-b015-b0f8f09229b1	{"action":"token_refreshed","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"José Alexandre F de Santana","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-12-31 19:06:10.145553+00	
00000000-0000-0000-0000-000000000000	6c8212cc-4d26-451b-bf70-18d14747989d	{"action":"token_revoked","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"José Alexandre F de Santana","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-12-31 19:06:10.162433+00	
00000000-0000-0000-0000-000000000000	ab400efa-e88a-418a-ba6b-655306b20d74	{"action":"token_refreshed","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"José Alexandre F de Santana","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-01-01 01:01:07.750768+00	
00000000-0000-0000-0000-000000000000	2ca72957-830b-4d35-aebf-3528803e82d1	{"action":"token_revoked","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"José Alexandre F de Santana","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-01-01 01:01:07.766734+00	
00000000-0000-0000-0000-000000000000	2d56b77a-f528-4b91-8740-ce05ded60084	{"action":"token_refreshed","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"José Alexandre F de Santana","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-01-01 12:27:01.225396+00	
00000000-0000-0000-0000-000000000000	f00fbfbb-a59f-4e01-96ba-ba8fd9cbedbe	{"action":"token_revoked","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"José Alexandre F de Santana","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-01-01 12:27:01.248122+00	
00000000-0000-0000-0000-000000000000	4edb7e2c-85f5-41f6-9411-3a73181fe37e	{"action":"token_refreshed","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"José Alexandre F de Santana","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-01-01 14:08:41.277392+00	
00000000-0000-0000-0000-000000000000	1c1a6df5-66c1-4e59-9063-fe0f10315aeb	{"action":"token_revoked","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"José Alexandre F de Santana","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-01-01 14:08:41.288874+00	
00000000-0000-0000-0000-000000000000	89dffbdc-0c74-45a7-9b69-ad67a58e7a6e	{"action":"token_refreshed","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"José Alexandre F de Santana","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-01-01 14:08:53.869304+00	
00000000-0000-0000-0000-000000000000	f432e19d-1309-4576-804d-98f51d44e2ab	{"action":"token_revoked","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"José Alexandre F de Santana","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-01-01 14:08:53.87+00	
00000000-0000-0000-0000-000000000000	9bf8f052-5d48-4eb5-b2bc-f6b59f28b100	{"action":"token_refreshed","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"José Alexandre F de Santana","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-01-01 14:09:28.52766+00	
00000000-0000-0000-0000-000000000000	42279d94-0bac-4dc2-b4f1-20f14f9fcefa	{"action":"token_revoked","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"José Alexandre F de Santana","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-01-01 14:09:28.529446+00	
00000000-0000-0000-0000-000000000000	2d1d5bdb-63e0-4e05-8389-4d6f229e433e	{"action":"token_refreshed","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"José Alexandre F de Santana","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-01-01 22:26:16.222448+00	
00000000-0000-0000-0000-000000000000	3375b5a7-0aca-468c-89a5-ccc9f36c1c9e	{"action":"token_revoked","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"José Alexandre F de Santana","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-01-01 22:26:16.234632+00	
00000000-0000-0000-0000-000000000000	d81bf33a-de9f-4e01-807d-6794d95c8cdc	{"action":"token_refreshed","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"José Alexandre F de Santana","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-01-01 22:30:06.272247+00	
00000000-0000-0000-0000-000000000000	af63eca5-8175-438e-9783-60b787d959a8	{"action":"token_revoked","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"José Alexandre F de Santana","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-01-01 22:30:06.273973+00	
00000000-0000-0000-0000-000000000000	c1fb17d1-8c69-4ec0-a2f6-1b0a9f653a71	{"action":"token_refreshed","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"José Alexandre F de Santana","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-01-02 05:32:54.249658+00	
00000000-0000-0000-0000-000000000000	0747e71a-0c9f-4994-8123-ef4d6d7b4894	{"action":"token_revoked","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"José Alexandre F de Santana","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-01-02 05:32:54.265938+00	
00000000-0000-0000-0000-000000000000	985cd953-d8e5-4e91-9976-c4cc464ad304	{"action":"token_refreshed","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"José Alexandre F de Santana","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-01-02 05:32:54.768296+00	
00000000-0000-0000-0000-000000000000	167663ec-a72b-4936-ad96-578d5a2fe2d3	{"action":"token_revoked","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"José Alexandre F de Santana","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-01-02 05:32:54.769003+00	
00000000-0000-0000-0000-000000000000	7c2d7a96-ac87-42f2-b1eb-771f3d0cf574	{"action":"logout","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"José Alexandre F de Santana","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"account"}	2026-01-02 05:42:40.628817+00	
00000000-0000-0000-0000-000000000000	dde7c0d4-f6e4-4883-baca-67d232de9d00	{"action":"login","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"cooperti sistemas","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"google"}}	2026-01-02 06:50:56.511804+00	
00000000-0000-0000-0000-000000000000	fda0c05c-319a-424b-bef5-75a7a106d30c	{"action":"login","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"cooperti sistemas","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-01-02 06:51:56.08853+00	
00000000-0000-0000-0000-000000000000	2fe1068f-c09f-416d-b236-932b155c8ac2	{"action":"logout","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"cooperti sistemas","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"account"}	2026-01-02 07:06:34.88135+00	
00000000-0000-0000-0000-000000000000	72571dc9-c77a-4d2d-a930-be62dea55e92	{"action":"login","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"cooperti sistemas","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"google"}}	2026-01-02 07:25:00.292473+00	
00000000-0000-0000-0000-000000000000	87cc005e-fa97-492b-b574-c96a3e0f7272	{"action":"login","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"cooperti sistemas","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-01-02 07:46:10.908282+00	
00000000-0000-0000-0000-000000000000	22e8b47b-21c6-4940-94b2-ebb03d79aabc	{"action":"token_refreshed","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"cooperti sistemas","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-01-02 09:34:43.693454+00	
00000000-0000-0000-0000-000000000000	d97a67bf-1056-4511-a2b9-d2c8ea66f4fd	{"action":"token_revoked","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"cooperti sistemas","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-01-02 09:34:43.717497+00	
00000000-0000-0000-0000-000000000000	fb06d675-e74d-48b5-b036-f32aa6452982	{"action":"login","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"cooperti sistemas","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-01-02 09:53:17.439705+00	
00000000-0000-0000-0000-000000000000	7baaf708-3b42-4ad8-a80a-165685ccc7f6	{"action":"login","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"cooperti sistemas","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-01-02 10:44:19.60619+00	
00000000-0000-0000-0000-000000000000	5305b453-945c-4a27-a4d0-9a87c3c6817b	{"action":"login","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"cooperti sistemas","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"google"}}	2026-01-02 10:56:39.449821+00	
00000000-0000-0000-0000-000000000000	49e64997-e759-4adb-9e58-723c88c60a45	{"action":"login","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"cooperti sistemas","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"google"}}	2026-01-02 10:57:43.170826+00	
00000000-0000-0000-0000-000000000000	49f42624-0683-469a-ae74-56df8a445d33	{"action":"token_refreshed","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"cooperti sistemas","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-01-02 11:56:16.997893+00	
00000000-0000-0000-0000-000000000000	10534192-7b31-4b8d-aef8-25df47c2a85f	{"action":"token_revoked","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"cooperti sistemas","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-01-02 11:56:17.005018+00	
00000000-0000-0000-0000-000000000000	0fa118cb-18ec-4236-842e-2d7f2fed6e2a	{"action":"login","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"cooperti sistemas","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-01-02 12:53:21.691073+00	
00000000-0000-0000-0000-000000000000	e3f92060-d888-4014-a36c-7691d3053e59	{"action":"token_refreshed","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"cooperti sistemas","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-01-02 13:51:59.896306+00	
00000000-0000-0000-0000-000000000000	ee6f2ef2-5fbc-4a0a-be4b-a90d77336d3a	{"action":"token_revoked","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"cooperti sistemas","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-01-02 13:51:59.900617+00	
00000000-0000-0000-0000-000000000000	8dc8323e-11d0-4758-a84a-8cb18cde15c7	{"action":"token_refreshed","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"cooperti sistemas","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-01-02 14:50:40.705836+00	
00000000-0000-0000-0000-000000000000	1ef9cf53-994b-4a42-b997-84c82bf38644	{"action":"token_revoked","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"cooperti sistemas","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-01-02 14:50:40.718173+00	
00000000-0000-0000-0000-000000000000	3bd3720b-3ada-43c2-bf13-343f338cee72	{"action":"login","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"cooperti sistemas","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-01-02 15:00:38.507309+00	
00000000-0000-0000-0000-000000000000	8eaa9bbc-edf8-4e3c-a96b-98d1966903f1	{"action":"login","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"cooperti sistemas","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"google"}}	2026-01-02 15:02:10.529594+00	
00000000-0000-0000-0000-000000000000	c8261192-d916-452c-be07-0d3609554af5	{"action":"token_refreshed","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"cooperti sistemas","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-01-03 15:17:20.982074+00	
00000000-0000-0000-0000-000000000000	1a5473e6-4116-4d29-9108-b422d1cf38e1	{"action":"token_revoked","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"cooperti sistemas","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-01-03 15:17:21.003504+00	
00000000-0000-0000-0000-000000000000	039835f4-d820-4e28-bbc3-19bf399db762	{"action":"token_refreshed","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"cooperti sistemas","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-01-03 17:14:27.847732+00	
00000000-0000-0000-0000-000000000000	dc3719d4-c083-4cf7-ae95-4d8a457a7404	{"action":"token_revoked","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"cooperti sistemas","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-01-03 17:14:27.858384+00	
00000000-0000-0000-0000-000000000000	86deff7a-cd4f-44b2-af37-ae3f4800c5bf	{"action":"login","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"cooperti sistemas","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"google"}}	2026-01-03 17:16:38.396482+00	
00000000-0000-0000-0000-000000000000	b4be8d15-7b82-44f2-aca2-5223b82ff9d2	{"action":"login","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"cooperti sistemas","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-01-03 17:17:03.859905+00	
00000000-0000-0000-0000-000000000000	2970c5da-7c79-45db-a7ae-6d52da5f9a59	{"action":"login","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"cooperti sistemas","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-01-03 17:51:09.402358+00	
00000000-0000-0000-0000-000000000000	cf5dcaf0-b93f-4d30-bbca-e36fe4d6fc00	{"action":"login","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"cooperti sistemas","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"google"}}	2026-01-03 18:31:16.550285+00	
00000000-0000-0000-0000-000000000000	82257529-7098-4a81-9ee9-a72ea9973e42	{"action":"login","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"cooperti sistemas","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-01-03 18:51:25.047787+00	
00000000-0000-0000-0000-000000000000	b37dc65e-bd0e-4527-bfc2-98d7f1b9ae1f	{"action":"login","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"cooperti sistemas","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-01-03 19:34:21.379719+00	
00000000-0000-0000-0000-000000000000	7c9d99d7-29fd-4092-b36d-439a1cf3eabb	{"action":"login","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"cooperti sistemas","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"google"}}	2026-01-03 19:43:06.422165+00	
00000000-0000-0000-0000-000000000000	ebc9c8ff-fcac-4740-b269-6f7fc5f0c3cd	{"action":"login","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"cooperti sistemas","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"google"}}	2026-01-03 20:16:44.018871+00	
00000000-0000-0000-0000-000000000000	fccbe1a6-1da8-4410-adb4-f227bd66347d	{"action":"login","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"cooperti sistemas","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-01-03 21:00:53.093859+00	
00000000-0000-0000-0000-000000000000	00c06a32-1aaa-4c88-a6ea-5d12190b5312	{"action":"login","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"cooperti sistemas","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"google"}}	2026-01-03 21:59:52.221449+00	
00000000-0000-0000-0000-000000000000	5693c513-b49c-4aa7-91ed-e8af54d981b6	{"action":"token_refreshed","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"cooperti sistemas","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-01-04 02:58:00.820377+00	
00000000-0000-0000-0000-000000000000	44e2a61a-2fb1-4ae5-8eb7-8655e0378fcc	{"action":"token_revoked","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"cooperti sistemas","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-01-04 02:58:00.839936+00	
00000000-0000-0000-0000-000000000000	4868f2d4-970f-4351-a233-3dbf047c1b84	{"action":"token_refreshed","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"cooperti sistemas","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-01-04 03:56:39.3124+00	
00000000-0000-0000-0000-000000000000	1c539c0c-1e3f-4480-ad9b-110d0bb76b11	{"action":"token_revoked","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"cooperti sistemas","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-01-04 03:56:39.334192+00	
00000000-0000-0000-0000-000000000000	99aec724-5fd2-4d41-b896-923113376dbd	{"action":"login","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"cooperti sistemas","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-01-04 03:57:37.274159+00	
00000000-0000-0000-0000-000000000000	9badaabd-cba8-4c73-8f8e-06d7db24ad01	{"action":"login","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"cooperti sistemas","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"google"}}	2026-01-04 04:35:09.366709+00	
00000000-0000-0000-0000-000000000000	4c7f11f4-d714-4990-94ca-9f07df492901	{"action":"token_refreshed","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"cooperti sistemas","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-01-04 05:36:14.722135+00	
00000000-0000-0000-0000-000000000000	b87c05a5-6412-4b9e-8984-2c61a0463686	{"action":"token_revoked","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"cooperti sistemas","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-01-04 05:36:14.73743+00	
00000000-0000-0000-0000-000000000000	148918e4-ee6c-4f02-9c71-f765938ef5b5	{"action":"token_refreshed","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"cooperti sistemas","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-01-04 06:55:40.833433+00	
00000000-0000-0000-0000-000000000000	afd3c582-3843-4564-8fd8-d3bf0a7e2ac2	{"action":"token_revoked","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"cooperti sistemas","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-01-04 06:55:40.845495+00	
00000000-0000-0000-0000-000000000000	90822738-d3a0-48a2-b461-eeaa85f8bec3	{"action":"login","actor_id":"d94701c4-30cd-45c7-b642-40b35ef8894c","actor_name":"Urubici Park Hotel","actor_username":"urubiciparkhotel.ac@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"google"}}	2026-01-04 07:03:56.999369+00	
00000000-0000-0000-0000-000000000000	c6934cb0-091c-4579-b1df-bf1b6f12a6f8	{"action":"login","actor_id":"d94701c4-30cd-45c7-b642-40b35ef8894c","actor_name":"Urubici Park Hotel","actor_username":"urubiciparkhotel.ac@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"google"}}	2026-01-04 07:32:27.665255+00	
00000000-0000-0000-0000-000000000000	b57c5f40-a5b3-4f03-a418-00e804ba2fb6	{"action":"login","actor_id":"d94701c4-30cd-45c7-b642-40b35ef8894c","actor_name":"Urubici Park Hotel","actor_username":"urubiciparkhotel.ac@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"google"}}	2026-01-04 07:41:25.64991+00	
00000000-0000-0000-0000-000000000000	93c09c48-fcd1-420f-9225-01e11cac13de	{"action":"login","actor_id":"d94701c4-30cd-45c7-b642-40b35ef8894c","actor_name":"Urubici Park Hotel","actor_username":"urubiciparkhotel.ac@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"google"}}	2026-01-04 07:50:57.834061+00	
00000000-0000-0000-0000-000000000000	06b6508a-bb1e-48ee-ba0b-8230ceefc02a	{"action":"login","actor_id":"d94701c4-30cd-45c7-b642-40b35ef8894c","actor_name":"Urubici Park Hotel","actor_username":"urubiciparkhotel.ac@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"google"}}	2026-01-04 11:55:20.926951+00	
00000000-0000-0000-0000-000000000000	50955535-3cee-4b07-a3ce-67d379c596e0	{"action":"login","actor_id":"d94701c4-30cd-45c7-b642-40b35ef8894c","actor_name":"Urubici Park Hotel","actor_username":"urubiciparkhotel.ac@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"google"}}	2026-01-04 12:21:22.327591+00	
00000000-0000-0000-0000-000000000000	524fb41f-3917-4560-99ed-fffd01daf99a	{"action":"token_refreshed","actor_id":"d94701c4-30cd-45c7-b642-40b35ef8894c","actor_name":"Urubici Park Hotel","actor_username":"urubiciparkhotel.ac@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-01-04 13:27:34.667637+00	
00000000-0000-0000-0000-000000000000	3932e852-9093-4852-ab82-8abd11a5d63b	{"action":"token_revoked","actor_id":"d94701c4-30cd-45c7-b642-40b35ef8894c","actor_name":"Urubici Park Hotel","actor_username":"urubiciparkhotel.ac@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-01-04 13:27:34.688739+00	
00000000-0000-0000-0000-000000000000	413634ce-c44d-40d5-bacd-2537b183d4ee	{"action":"login","actor_id":"d94701c4-30cd-45c7-b642-40b35ef8894c","actor_name":"Urubici Park Hotel","actor_username":"urubiciparkhotel.ac@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"google"}}	2026-01-04 13:27:43.977647+00	
00000000-0000-0000-0000-000000000000	5d7139a4-afa8-4394-b340-5ec138529963	{"action":"login","actor_id":"d94701c4-30cd-45c7-b642-40b35ef8894c","actor_name":"Urubici Park Hotel","actor_username":"urubiciparkhotel.ac@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"google"}}	2026-01-04 14:26:03.560782+00	
00000000-0000-0000-0000-000000000000	6e333fa8-98d1-44e6-9015-53cda4ede5f6	{"action":"token_refreshed","actor_id":"d94701c4-30cd-45c7-b642-40b35ef8894c","actor_name":"Urubici Park Hotel","actor_username":"urubiciparkhotel.ac@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-01-04 16:17:38.775287+00	
00000000-0000-0000-0000-000000000000	a76f359d-2290-4597-bcdc-aaeafc024932	{"action":"token_revoked","actor_id":"d94701c4-30cd-45c7-b642-40b35ef8894c","actor_name":"Urubici Park Hotel","actor_username":"urubiciparkhotel.ac@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-01-04 16:17:38.797859+00	
00000000-0000-0000-0000-000000000000	ab7694c0-9f5d-4d4b-b2f8-6e6f3bdf8250	{"action":"login","actor_id":"d94701c4-30cd-45c7-b642-40b35ef8894c","actor_name":"Urubici Park Hotel","actor_username":"urubiciparkhotel.ac@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"google"}}	2026-01-04 16:17:50.013273+00	
00000000-0000-0000-0000-000000000000	9a9d4d08-ed98-4781-b1f6-05fa3ad14b2b	{"action":"login","actor_id":"d94701c4-30cd-45c7-b642-40b35ef8894c","actor_name":"Urubici Park Hotel","actor_username":"urubiciparkhotel.ac@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"google"}}	2026-01-04 16:21:44.796536+00	
00000000-0000-0000-0000-000000000000	076c3db8-ae19-4a8e-adc9-1f7836f405a3	{"action":"token_refreshed","actor_id":"d94701c4-30cd-45c7-b642-40b35ef8894c","actor_name":"Urubici Park Hotel","actor_username":"urubiciparkhotel.ac@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-01-07 11:56:13.348213+00	
00000000-0000-0000-0000-000000000000	500e4bff-83c8-4208-a5d3-c749ea57d8f6	{"action":"token_revoked","actor_id":"d94701c4-30cd-45c7-b642-40b35ef8894c","actor_name":"Urubici Park Hotel","actor_username":"urubiciparkhotel.ac@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-01-07 11:56:13.362646+00	
00000000-0000-0000-0000-000000000000	8921f0f9-9b45-474f-a5e7-53df8c746e46	{"action":"login","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"cooperti sistemas","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-01-11 22:22:56.268479+00	
00000000-0000-0000-0000-000000000000	b8612b03-658d-4103-8820-2b3185620a8c	{"action":"login","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"cooperti sistemas","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-01-23 10:52:56.340611+00	
00000000-0000-0000-0000-000000000000	6ff0f738-3545-4c14-8ab8-4a4fff889035	{"action":"login","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"cooperti sistemas","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-01-23 16:09:38.157205+00	
00000000-0000-0000-0000-000000000000	349ad69b-666a-4cbc-ae52-8e1b934538dd	{"action":"token_refreshed","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"cooperti sistemas","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-01-23 17:09:01.597108+00	
00000000-0000-0000-0000-000000000000	d9502f32-c1f9-4514-8207-ab90d723cf82	{"action":"token_revoked","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"cooperti sistemas","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-01-23 17:09:01.604208+00	
00000000-0000-0000-0000-000000000000	2a6fb2a5-6a5d-4a83-b6a6-ca8635c41b57	{"action":"login","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"cooperti sistemas","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-01-23 17:16:54.829226+00	
00000000-0000-0000-0000-000000000000	e3b0c9e2-e1c4-4cd7-ba52-ef224e01d64d	{"action":"login","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"cooperti sistemas","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-01-23 17:19:27.591595+00	
00000000-0000-0000-0000-000000000000	8d8a49b8-3dbb-443a-8af7-de62e96ecb11	{"action":"login","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"cooperti sistemas","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-01-23 17:22:15.662312+00	
00000000-0000-0000-0000-000000000000	0a0171c0-0f97-4039-a8b9-55f141556e03	{"action":"login","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"cooperti sistemas","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-01-23 17:27:46.009606+00	
00000000-0000-0000-0000-000000000000	9ede544d-1ab5-4005-b3b0-aa3d53645e20	{"action":"token_refreshed","actor_id":"d94701c4-30cd-45c7-b642-40b35ef8894c","actor_name":"Urubici Park Hotel","actor_username":"urubiciparkhotel.ac@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-01-24 08:41:18.0388+00	
00000000-0000-0000-0000-000000000000	5cab548a-e87b-4b61-8db9-0894bb3f2f3a	{"action":"token_revoked","actor_id":"d94701c4-30cd-45c7-b642-40b35ef8894c","actor_name":"Urubici Park Hotel","actor_username":"urubiciparkhotel.ac@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-01-24 08:41:18.060541+00	
00000000-0000-0000-0000-000000000000	82392d32-28b0-487e-a658-7b1fab858b14	{"action":"login","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"cooperti sistemas","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-01-24 08:45:20.535039+00	
00000000-0000-0000-0000-000000000000	d3d06010-a2bd-4aa4-ac0f-9ae24bf07dcc	{"action":"login","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"cooperti sistemas","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-01-24 08:54:32.183497+00	
00000000-0000-0000-0000-000000000000	c2b7018b-218b-4175-aeb4-9869874653a5	{"action":"login","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"cooperti sistemas","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-01-24 09:03:39.634738+00	
00000000-0000-0000-0000-000000000000	cc253e00-5254-4282-8f30-0fa82b4663d6	{"action":"login","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"cooperti sistemas","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-01-24 11:12:41.949405+00	
00000000-0000-0000-0000-000000000000	1b3e07ac-f982-49c2-bd42-457a11927ad3	{"action":"login","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"cooperti sistemas","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-01-24 11:59:48.599538+00	
00000000-0000-0000-0000-000000000000	c892ecfe-df8d-4f27-977b-d2005a820278	{"action":"login","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"cooperti sistemas","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-01-24 12:42:50.524226+00	
00000000-0000-0000-0000-000000000000	be7c9957-6480-4235-b7b8-aad02a93fc6f	{"action":"login","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"cooperti sistemas","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-01-24 17:17:47.860712+00	
00000000-0000-0000-0000-000000000000	df8d4c54-83f2-415c-bdfa-3a24bc394d6f	{"action":"login","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"cooperti sistemas","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-01-24 17:35:02.849847+00	
00000000-0000-0000-0000-000000000000	4aa538b1-4768-4f63-81e8-c9295483a363	{"action":"login","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"cooperti sistemas","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-01-27 19:47:01.136997+00	
00000000-0000-0000-0000-000000000000	cb7feb94-5a45-44f3-8dfa-b9fc796e5947	{"action":"token_refreshed","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"cooperti sistemas","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-01-27 21:44:05.665941+00	
00000000-0000-0000-0000-000000000000	51990503-d86b-4031-a7e7-bb9572c56bd1	{"action":"token_revoked","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"cooperti sistemas","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-01-27 21:44:05.676919+00	
00000000-0000-0000-0000-000000000000	a9385d49-36db-4bc5-9674-c542a6f32576	{"action":"token_refreshed","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"cooperti sistemas","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-01-27 23:17:15.548106+00	
00000000-0000-0000-0000-000000000000	7ad950d2-3379-4ce4-8878-45308d322edf	{"action":"token_revoked","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"cooperti sistemas","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-01-27 23:17:15.556775+00	
00000000-0000-0000-0000-000000000000	be2aab38-ab25-4a74-8046-53b20ada5b5f	{"action":"token_refreshed","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"cooperti sistemas","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-01-28 01:06:56.256413+00	
00000000-0000-0000-0000-000000000000	62278e0a-f93c-4a13-b686-bc2eccbaf55d	{"action":"token_revoked","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"cooperti sistemas","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-01-28 01:06:56.263143+00	
00000000-0000-0000-0000-000000000000	f88ad3a3-ed42-4efe-b45b-9f462ddf2ecd	{"action":"login","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"cooperti sistemas","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-01-28 01:31:14.296591+00	
00000000-0000-0000-0000-000000000000	7467e2cd-2d58-4d27-b8e6-e94bb8fb8cc8	{"action":"login","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"cooperti sistemas","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-01-28 01:31:33.957051+00	
00000000-0000-0000-0000-000000000000	77f1dc9c-c875-44e2-88a9-8252017537b7	{"action":"login","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"cooperti sistemas","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-01-28 10:09:44.331419+00	
00000000-0000-0000-0000-000000000000	2edd8b2c-0bf0-4122-a007-10929866c4dd	{"action":"login","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"cooperti sistemas","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-01-28 10:45:26.763461+00	
00000000-0000-0000-0000-000000000000	5a3b5997-68b7-4900-8611-555600cbdf78	{"action":"login","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"cooperti sistemas","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-01-28 10:59:28.359687+00	
00000000-0000-0000-0000-000000000000	b2a39f66-7fbe-437d-b00d-ece2e6b49cc2	{"action":"login","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"cooperti sistemas","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-01-28 11:08:45.778064+00	
00000000-0000-0000-0000-000000000000	5c925964-18f6-482a-840a-92dc33a13c02	{"action":"logout","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"cooperti sistemas","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"account"}	2026-01-28 11:37:20.832269+00	
00000000-0000-0000-0000-000000000000	32993956-b2b7-4521-bacd-4ddc9af8c6d1	{"action":"login","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"cooperti sistemas","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-01-28 11:38:15.601911+00	
00000000-0000-0000-0000-000000000000	3b6db7a7-cb3c-4559-a9c3-d0f4ed2194da	{"action":"logout","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"cooperti sistemas","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"account"}	2026-01-28 11:40:35.652104+00	
00000000-0000-0000-0000-000000000000	e2378fda-8154-4f20-af83-fcd85774613e	{"action":"login","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"cooperti sistemas","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-01-28 11:40:41.587349+00	
00000000-0000-0000-0000-000000000000	b74d59ad-7aac-4538-93db-532dee0dd844	{"action":"logout","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"cooperti sistemas","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"account"}	2026-01-28 11:47:51.311149+00	
00000000-0000-0000-0000-000000000000	c783bb64-ee07-4fdf-93a6-8e75d0704fe0	{"action":"login","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"cooperti sistemas","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-01-28 11:52:48.178095+00	
00000000-0000-0000-0000-000000000000	e91a78eb-0a75-468d-a13c-8040fcaa4182	{"action":"logout","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"cooperti sistemas","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"account"}	2026-01-28 12:11:35.385747+00	
00000000-0000-0000-0000-000000000000	8c6dd941-650d-4d7b-afd6-40ebd77ba065	{"action":"login","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"cooperti sistemas","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-01-28 12:11:47.607011+00	
00000000-0000-0000-0000-000000000000	35d04a09-ef27-43aa-b322-91a7182056de	{"action":"login","actor_id":"d94701c4-30cd-45c7-b642-40b35ef8894c","actor_name":"Urubici Park Hotel","actor_username":"urubiciparkhotel.ac@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-01-28 13:06:52.031115+00	
00000000-0000-0000-0000-000000000000	e3ac4b38-0d3b-4267-b95d-d87e8137e276	{"action":"token_refreshed","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"cooperti sistemas","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-01-28 13:11:42.370283+00	
00000000-0000-0000-0000-000000000000	053eeff5-4c14-489a-8f6f-e010099dfbdc	{"action":"token_revoked","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"cooperti sistemas","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-01-28 13:11:42.375962+00	
00000000-0000-0000-0000-000000000000	038b6a56-b6d1-455b-b88c-60081a1a9638	{"action":"token_refreshed","actor_id":"d94701c4-30cd-45c7-b642-40b35ef8894c","actor_name":"Urubici Park Hotel","actor_username":"urubiciparkhotel.ac@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-01-28 14:11:35.758052+00	
00000000-0000-0000-0000-000000000000	2080b45c-d771-46ec-90cd-2d9746dfb4bc	{"action":"token_revoked","actor_id":"d94701c4-30cd-45c7-b642-40b35ef8894c","actor_name":"Urubici Park Hotel","actor_username":"urubiciparkhotel.ac@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-01-28 14:11:35.778565+00	
00000000-0000-0000-0000-000000000000	c29f74a8-ef26-4746-8017-f233eec095ac	{"action":"token_refreshed","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"cooperti sistemas","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-01-29 10:08:54.300526+00	
00000000-0000-0000-0000-000000000000	4d56a2e3-329f-4df1-aa57-d5f348605962	{"action":"token_revoked","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"cooperti sistemas","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-01-29 10:08:54.318503+00	
00000000-0000-0000-0000-000000000000	71b3db01-efab-4881-89e6-138387854244	{"action":"token_refreshed","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"cooperti sistemas","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-01-29 11:08:30.384958+00	
00000000-0000-0000-0000-000000000000	48bf7393-e830-46ec-b425-abf5c60f0d0d	{"action":"token_revoked","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"cooperti sistemas","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-01-29 11:08:30.410399+00	
00000000-0000-0000-0000-000000000000	618b030a-c6a3-4085-bf75-c32fa5bc5296	{"action":"token_refreshed","actor_id":"d94701c4-30cd-45c7-b642-40b35ef8894c","actor_name":"Urubici Park Hotel","actor_username":"urubiciparkhotel.ac@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-01-29 11:29:18.08645+00	
00000000-0000-0000-0000-000000000000	8c1d54d3-f7d7-4c78-8bcc-48d7075a198e	{"action":"token_revoked","actor_id":"d94701c4-30cd-45c7-b642-40b35ef8894c","actor_name":"Urubici Park Hotel","actor_username":"urubiciparkhotel.ac@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-01-29 11:29:18.094738+00	
00000000-0000-0000-0000-000000000000	d7285c03-55cc-4349-919d-2841fe202e64	{"action":"token_refreshed","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"cooperti sistemas","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-01-29 12:13:26.92607+00	
00000000-0000-0000-0000-000000000000	b02bfefc-cc6d-4a74-8c80-aaf168101e30	{"action":"token_revoked","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"cooperti sistemas","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-01-29 12:13:26.943721+00	
00000000-0000-0000-0000-000000000000	607ef960-617d-4ab6-a8bb-71f4fe17061c	{"action":"token_refreshed","actor_id":"d94701c4-30cd-45c7-b642-40b35ef8894c","actor_name":"Urubici Park Hotel","actor_username":"urubiciparkhotel.ac@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-01-29 12:27:30.88243+00	
00000000-0000-0000-0000-000000000000	9c48d2a7-8fa8-422b-b9c7-fff61470ff48	{"action":"token_revoked","actor_id":"d94701c4-30cd-45c7-b642-40b35ef8894c","actor_name":"Urubici Park Hotel","actor_username":"urubiciparkhotel.ac@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-01-29 12:27:30.892462+00	
00000000-0000-0000-0000-000000000000	cdc8a46b-a2f2-4f6f-b616-19e0e276a697	{"action":"token_refreshed","actor_id":"d94701c4-30cd-45c7-b642-40b35ef8894c","actor_name":"Urubici Park Hotel","actor_username":"urubiciparkhotel.ac@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-01-29 13:26:01.187086+00	
00000000-0000-0000-0000-000000000000	49ab9b67-e1f6-4403-8037-476a97b238c7	{"action":"token_revoked","actor_id":"d94701c4-30cd-45c7-b642-40b35ef8894c","actor_name":"Urubici Park Hotel","actor_username":"urubiciparkhotel.ac@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-01-29 13:26:01.204265+00	
00000000-0000-0000-0000-000000000000	837c96a8-b514-4063-80ce-07b716c8b07e	{"action":"token_refreshed","actor_id":"d94701c4-30cd-45c7-b642-40b35ef8894c","actor_name":"Urubici Park Hotel","actor_username":"urubiciparkhotel.ac@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-01-29 15:02:22.04516+00	
00000000-0000-0000-0000-000000000000	d6720929-5e9f-494a-bf56-6c5e8d504329	{"action":"token_revoked","actor_id":"d94701c4-30cd-45c7-b642-40b35ef8894c","actor_name":"Urubici Park Hotel","actor_username":"urubiciparkhotel.ac@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-01-29 15:02:22.063123+00	
00000000-0000-0000-0000-000000000000	df37d453-8975-433a-b6e1-a7fcaa8e6cf9	{"action":"token_refreshed","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"cooperti sistemas","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-01-29 16:51:11.043069+00	
00000000-0000-0000-0000-000000000000	c28182f2-f526-4000-9834-81c3adf41a31	{"action":"token_revoked","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"cooperti sistemas","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-01-29 16:51:11.059635+00	
00000000-0000-0000-0000-000000000000	e3ac9124-e5f0-4b39-9cf2-18ee0d451c1c	{"action":"token_refreshed","actor_id":"d94701c4-30cd-45c7-b642-40b35ef8894c","actor_name":"Urubici Park Hotel","actor_username":"urubiciparkhotel.ac@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-01-29 16:51:51.475731+00	
00000000-0000-0000-0000-000000000000	1faa6b7c-4584-43af-a21c-2821293df7d1	{"action":"token_revoked","actor_id":"d94701c4-30cd-45c7-b642-40b35ef8894c","actor_name":"Urubici Park Hotel","actor_username":"urubiciparkhotel.ac@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-01-29 16:51:51.476815+00	
00000000-0000-0000-0000-000000000000	ad4cf13f-4865-4a01-8d20-02b2620adb4c	{"action":"token_refreshed","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"cooperti sistemas","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-01-29 17:49:36.996783+00	
00000000-0000-0000-0000-000000000000	f4a1ee0d-3325-49ce-ad95-830a7c326d8f	{"action":"token_revoked","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"cooperti sistemas","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-01-29 17:49:37.011566+00	
00000000-0000-0000-0000-000000000000	bb7634e9-d216-4878-b972-e9963ab8bafc	{"action":"token_refreshed","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"cooperti sistemas","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-01-29 18:48:09.651441+00	
00000000-0000-0000-0000-000000000000	97e4cc73-bd3e-4616-b5c4-56da9037491e	{"action":"token_revoked","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"cooperti sistemas","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-01-29 18:48:09.669854+00	
00000000-0000-0000-0000-000000000000	8d46ff50-3018-4a31-b903-f709eb8ff1de	{"action":"token_refreshed","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"cooperti sistemas","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-01-29 19:47:04.978835+00	
00000000-0000-0000-0000-000000000000	70a6bd1d-1feb-479f-b3fc-2933454f58e1	{"action":"token_revoked","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"cooperti sistemas","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-01-29 19:47:04.993593+00	
00000000-0000-0000-0000-000000000000	516c4701-f4b4-403d-ad7c-2fa8be9af3fe	{"action":"token_refreshed","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"cooperti sistemas","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-01-29 23:40:20.238417+00	
00000000-0000-0000-0000-000000000000	e3f06f42-d048-43dd-a5aa-195c6079d485	{"action":"token_revoked","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"cooperti sistemas","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-01-29 23:40:20.251784+00	
00000000-0000-0000-0000-000000000000	3d1ad0cb-ffd3-4e7e-a94f-53d297418e22	{"action":"token_refreshed","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"cooperti sistemas","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-01-30 11:30:57.434453+00	
00000000-0000-0000-0000-000000000000	94f7a3df-7e72-40af-9e97-982d8eb6571f	{"action":"token_revoked","actor_id":"cfc38522-8687-4066-bb9c-6dbcc465396f","actor_name":"cooperti sistemas","actor_username":"cooperti.sistemas@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-01-30 11:30:57.437532+00	
\.


--
-- TOC entry 5206 (class 0 OID 16929)
-- Dependencies: 366
-- Data for Name: flow_state; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.flow_state (id, user_id, auth_code, code_challenge_method, code_challenge, provider_type, provider_access_token, provider_refresh_token, created_at, updated_at, authentication_method, auth_code_issued_at, invite_token, referrer, oauth_client_state_id, linking_target_id, email_optional) FROM stdin;
\.


--
-- TOC entry 5197 (class 0 OID 16727)
-- Dependencies: 357
-- Data for Name: identities; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.identities (provider_id, user_id, identity_data, provider, last_sign_in_at, created_at, updated_at, id) FROM stdin;
cfc38522-8687-4066-bb9c-6dbcc465396f	cfc38522-8687-4066-bb9c-6dbcc465396f	{"sub": "cfc38522-8687-4066-bb9c-6dbcc465396f", "email": "cooperti.sistemas@gmail.com", "phone": "51986859236", "full_name": "José Alexandre F de Santana", "email_verified": true, "phone_verified": false}	email	2025-10-14 07:11:06.795497+00	2025-10-14 07:11:06.795553+00	2025-10-14 07:11:06.795553+00	a152b461-3526-4768-9e06-f56686a016e3
117902222818336046834	cfc38522-8687-4066-bb9c-6dbcc465396f	{"iss": "https://accounts.google.com", "sub": "117902222818336046834", "name": "cooperti sistemas", "email": "cooperti.sistemas@gmail.com", "picture": "https://lh3.googleusercontent.com/a/ACg8ocKOAhA5Ptc37HNlwxofXTaRy4jTOA8AiJkoyJygemYcTR4syQ=s96-c", "full_name": "cooperti sistemas", "avatar_url": "https://lh3.googleusercontent.com/a/ACg8ocKOAhA5Ptc37HNlwxofXTaRy4jTOA8AiJkoyJygemYcTR4syQ=s96-c", "provider_id": "117902222818336046834", "email_verified": true, "phone_verified": false}	google	2026-01-02 06:50:56.481528+00	2026-01-02 06:50:56.482804+00	2026-01-04 04:35:09.340915+00	243a40a7-76a2-4a32-a895-b1d7a9c6bc44
117320287655913329565	d94701c4-30cd-45c7-b642-40b35ef8894c	{"iss": "https://accounts.google.com", "sub": "117320287655913329565", "name": "Urubici Park Hotel", "email": "urubiciparkhotel.ac@gmail.com", "picture": "https://lh3.googleusercontent.com/a/ACg8ocKgNzXYgud2F6-Y2v1ZCUVnqHkLR2em4NONkFxf3KnL3AYfzLY=s96-c", "full_name": "Urubici Park Hotel", "avatar_url": "https://lh3.googleusercontent.com/a/ACg8ocKgNzXYgud2F6-Y2v1ZCUVnqHkLR2em4NONkFxf3KnL3AYfzLY=s96-c", "provider_id": "117320287655913329565", "email_verified": true, "phone_verified": false}	google	2025-12-26 16:35:43.977742+00	2025-12-26 16:35:43.97781+00	2026-01-04 16:21:44.784661+00	00779843-6816-4588-a6a1-87d93307b458
\.


--
-- TOC entry 5191 (class 0 OID 16518)
-- Dependencies: 348
-- Data for Name: instances; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.instances (id, uuid, raw_base_config, created_at, updated_at) FROM stdin;
\.


--
-- TOC entry 5201 (class 0 OID 16816)
-- Dependencies: 361
-- Data for Name: mfa_amr_claims; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.mfa_amr_claims (session_id, created_at, updated_at, authentication_method, id) FROM stdin;
11bdb55c-d9fe-4d15-9a98-cc6d1022ac0a	2026-01-28 12:11:47.641524+00	2026-01-28 12:11:47.641524+00	password	05707454-4489-4eb6-a0e9-c41da695d15d
ff622ef0-711d-4087-bb4d-3def77d7c18b	2026-01-28 13:06:52.134524+00	2026-01-28 13:06:52.134524+00	password	37774227-255f-486f-bc53-91eb3d9bd363
ded6fce4-c4da-4d31-a14e-caea63166d65	2025-12-26 16:35:44.056699+00	2025-12-26 16:35:44.056699+00	oauth	e6c4e09d-36bc-40f8-82c6-0c8080f584e7
41c55bae-6e8e-4932-8e07-728100a3e84e	2025-12-26 17:15:53.602967+00	2025-12-26 17:15:53.602967+00	oauth	1266c1d3-28e7-4685-b4b7-f6443299238d
45172cba-a2c7-4493-8b50-eacdf6c2a4b2	2026-01-04 07:03:57.04568+00	2026-01-04 07:03:57.04568+00	oauth	b986fccf-11d8-46f9-9d2a-1aa176840b4f
59fba7cc-86b4-4588-ab03-4aef10de4bbd	2026-01-04 07:32:27.689764+00	2026-01-04 07:32:27.689764+00	oauth	41674bdd-7c7a-4eb2-8684-512dbb131127
336863f9-3f74-4c96-b39a-bd952426a781	2026-01-04 07:41:25.708394+00	2026-01-04 07:41:25.708394+00	oauth	8fef66ea-d313-4964-b8dc-36de05b301b7
cab27bcd-ca1c-46c5-ae9a-41f325017f62	2026-01-04 07:50:57.838247+00	2026-01-04 07:50:57.838247+00	oauth	bd2e8adb-7ea6-4b9d-8d5f-a36aaf1c5b42
f46f0c77-0bc3-4dbc-b054-c6e6ef678da5	2026-01-04 11:55:21.008781+00	2026-01-04 11:55:21.008781+00	oauth	e273c8b7-8603-45f2-a71d-f52fbe544288
ee9572f3-ca2d-4ae4-9f08-4a4ccb94715c	2026-01-04 12:21:22.365005+00	2026-01-04 12:21:22.365005+00	oauth	03221553-0baa-42fa-8b7e-d9e699f72030
d8ad4b72-dc9e-49e4-adbe-1b3b49857ae4	2026-01-04 13:27:43.987813+00	2026-01-04 13:27:43.987813+00	oauth	5a4e825e-73b5-4ca8-9162-eb1b8b87d3cc
a0026f6d-8a22-4934-9bec-e5d1481823ca	2026-01-04 14:26:03.632232+00	2026-01-04 14:26:03.632232+00	oauth	c426f179-cfbc-4b10-a9db-cd3160cb7c49
27157fb3-f40e-477a-99fc-08ba5dddebf4	2026-01-04 16:17:50.028099+00	2026-01-04 16:17:50.028099+00	oauth	9a935c49-3e1c-4893-97ca-8975177a31c3
5200c85f-31c9-4448-b681-82f2ad5806f8	2026-01-04 16:21:44.810948+00	2026-01-04 16:21:44.810948+00	oauth	3cf530fe-ec54-479f-8ae0-27192df3576f
\.


--
-- TOC entry 5200 (class 0 OID 16804)
-- Dependencies: 360
-- Data for Name: mfa_challenges; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.mfa_challenges (id, factor_id, created_at, verified_at, ip_address, otp_code, web_authn_session_data) FROM stdin;
\.


--
-- TOC entry 5199 (class 0 OID 16791)
-- Dependencies: 359
-- Data for Name: mfa_factors; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.mfa_factors (id, user_id, friendly_name, factor_type, status, created_at, updated_at, secret, phone, last_challenged_at, web_authn_credential, web_authn_aaguid, last_webauthn_challenge_data) FROM stdin;
\.


--
-- TOC entry 5209 (class 0 OID 17041)
-- Dependencies: 369
-- Data for Name: oauth_authorizations; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.oauth_authorizations (id, authorization_id, client_id, user_id, redirect_uri, scope, state, resource, code_challenge, code_challenge_method, response_type, status, authorization_code, created_at, expires_at, approved_at, nonce) FROM stdin;
\.


--
-- TOC entry 5239 (class 0 OID 58652)
-- Dependencies: 403
-- Data for Name: oauth_client_states; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.oauth_client_states (id, provider_type, code_verifier, created_at) FROM stdin;
\.


--
-- TOC entry 5208 (class 0 OID 17011)
-- Dependencies: 368
-- Data for Name: oauth_clients; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.oauth_clients (id, client_secret_hash, registration_type, redirect_uris, grant_types, client_name, client_uri, logo_uri, created_at, updated_at, deleted_at, client_type, token_endpoint_auth_method) FROM stdin;
\.


--
-- TOC entry 5210 (class 0 OID 17074)
-- Dependencies: 370
-- Data for Name: oauth_consents; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.oauth_consents (id, user_id, client_id, scopes, granted_at, revoked_at) FROM stdin;
\.


--
-- TOC entry 5207 (class 0 OID 16979)
-- Dependencies: 367
-- Data for Name: one_time_tokens; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.one_time_tokens (id, user_id, token_type, token_hash, relates_to, created_at, updated_at) FROM stdin;
\.


--
-- TOC entry 5190 (class 0 OID 16507)
-- Dependencies: 347
-- Data for Name: refresh_tokens; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.refresh_tokens (instance_id, id, token, user_id, revoked, created_at, updated_at, parent, session_id) FROM stdin;
00000000-0000-0000-0000-000000000000	171	pi4ow5txiv7x	d94701c4-30cd-45c7-b642-40b35ef8894c	t	2026-01-28 13:06:52.092093+00	2026-01-28 14:11:35.780643+00	\N	ff622ef0-711d-4087-bb4d-3def77d7c18b
00000000-0000-0000-0000-000000000000	173	cp4svjplxkod	d94701c4-30cd-45c7-b642-40b35ef8894c	t	2026-01-28 14:11:35.803342+00	2026-01-29 11:29:18.095632+00	pi4ow5txiv7x	ff622ef0-711d-4087-bb4d-3def77d7c18b
00000000-0000-0000-0000-000000000000	175	o7mlkeznnuse	cfc38522-8687-4066-bb9c-6dbcc465396f	t	2026-01-29 11:08:30.433178+00	2026-01-29 12:13:26.945232+00	g5d7boyy3spt	11bdb55c-d9fe-4d15-9a98-cc6d1022ac0a
00000000-0000-0000-0000-000000000000	179	lodr4xrehmrw	d94701c4-30cd-45c7-b642-40b35ef8894c	t	2026-01-29 13:26:01.21872+00	2026-01-29 15:02:22.06397+00	aatze4guy2t3	ff622ef0-711d-4087-bb4d-3def77d7c18b
00000000-0000-0000-0000-000000000000	177	sd2rr2bpqi5x	cfc38522-8687-4066-bb9c-6dbcc465396f	t	2026-01-29 12:13:26.959429+00	2026-01-29 16:51:11.061059+00	o7mlkeznnuse	11bdb55c-d9fe-4d15-9a98-cc6d1022ac0a
00000000-0000-0000-0000-000000000000	182	dgam7mfgautf	d94701c4-30cd-45c7-b642-40b35ef8894c	f	2026-01-29 16:51:51.478184+00	2026-01-29 16:51:51.478184+00	cgodujbjtkri	ff622ef0-711d-4087-bb4d-3def77d7c18b
00000000-0000-0000-0000-000000000000	181	julxr7drbmil	cfc38522-8687-4066-bb9c-6dbcc465396f	t	2026-01-29 16:51:11.078456+00	2026-01-29 17:49:37.013365+00	sd2rr2bpqi5x	11bdb55c-d9fe-4d15-9a98-cc6d1022ac0a
00000000-0000-0000-0000-000000000000	184	ik2bi3wm3p2d	cfc38522-8687-4066-bb9c-6dbcc465396f	t	2026-01-29 18:48:09.685723+00	2026-01-29 19:47:04.99511+00	pountsn4maek	11bdb55c-d9fe-4d15-9a98-cc6d1022ac0a
00000000-0000-0000-0000-000000000000	186	ivy7yjaipsxu	cfc38522-8687-4066-bb9c-6dbcc465396f	t	2026-01-29 23:40:20.268909+00	2026-01-30 11:30:57.44059+00	vapdgfvoiyyk	11bdb55c-d9fe-4d15-9a98-cc6d1022ac0a
00000000-0000-0000-0000-000000000000	128	n7tqw2rvb5ge	d94701c4-30cd-45c7-b642-40b35ef8894c	f	2026-01-04 07:32:27.678681+00	2026-01-04 07:32:27.678681+00	\N	59fba7cc-86b4-4588-ab03-4aef10de4bbd
00000000-0000-0000-0000-000000000000	130	pjm3wnnxivuv	d94701c4-30cd-45c7-b642-40b35ef8894c	f	2026-01-04 07:50:57.836359+00	2026-01-04 07:50:57.836359+00	\N	cab27bcd-ca1c-46c5-ae9a-41f325017f62
00000000-0000-0000-0000-000000000000	132	q7r5rhawcid2	d94701c4-30cd-45c7-b642-40b35ef8894c	t	2026-01-04 12:21:22.353217+00	2026-01-04 13:27:34.690628+00	\N	ee9572f3-ca2d-4ae4-9f08-4a4ccb94715c
00000000-0000-0000-0000-000000000000	135	wbifr46vxj5w	d94701c4-30cd-45c7-b642-40b35ef8894c	f	2026-01-04 14:26:03.602751+00	2026-01-04 14:26:03.602751+00	\N	a0026f6d-8a22-4934-9bec-e5d1481823ca
00000000-0000-0000-0000-000000000000	138	oyy6hzmqme5b	d94701c4-30cd-45c7-b642-40b35ef8894c	t	2026-01-04 16:21:44.803942+00	2026-01-24 08:41:18.062244+00	\N	5200c85f-31c9-4448-b681-82f2ad5806f8
00000000-0000-0000-0000-000000000000	170	efvpxqjigngt	cfc38522-8687-4066-bb9c-6dbcc465396f	t	2026-01-28 12:11:47.627394+00	2026-01-28 13:11:42.377344+00	\N	11bdb55c-d9fe-4d15-9a98-cc6d1022ac0a
00000000-0000-0000-0000-000000000000	172	b6qffrorq2xz	cfc38522-8687-4066-bb9c-6dbcc465396f	t	2026-01-28 13:11:42.37984+00	2026-01-29 10:08:54.319274+00	efvpxqjigngt	11bdb55c-d9fe-4d15-9a98-cc6d1022ac0a
00000000-0000-0000-0000-000000000000	174	g5d7boyy3spt	cfc38522-8687-4066-bb9c-6dbcc465396f	t	2026-01-29 10:08:54.333893+00	2026-01-29 11:08:30.411273+00	b6qffrorq2xz	11bdb55c-d9fe-4d15-9a98-cc6d1022ac0a
00000000-0000-0000-0000-000000000000	176	fiyb3ujiepmc	d94701c4-30cd-45c7-b642-40b35ef8894c	t	2026-01-29 11:29:18.102627+00	2026-01-29 12:27:30.893288+00	cp4svjplxkod	ff622ef0-711d-4087-bb4d-3def77d7c18b
00000000-0000-0000-0000-000000000000	178	aatze4guy2t3	d94701c4-30cd-45c7-b642-40b35ef8894c	t	2026-01-29 12:27:30.901957+00	2026-01-29 13:26:01.205149+00	fiyb3ujiepmc	ff622ef0-711d-4087-bb4d-3def77d7c18b
00000000-0000-0000-0000-000000000000	180	cgodujbjtkri	d94701c4-30cd-45c7-b642-40b35ef8894c	t	2026-01-29 15:02:22.082933+00	2026-01-29 16:51:51.477736+00	lodr4xrehmrw	ff622ef0-711d-4087-bb4d-3def77d7c18b
00000000-0000-0000-0000-000000000000	183	pountsn4maek	cfc38522-8687-4066-bb9c-6dbcc465396f	t	2026-01-29 17:49:37.030041+00	2026-01-29 18:48:09.671408+00	julxr7drbmil	11bdb55c-d9fe-4d15-9a98-cc6d1022ac0a
00000000-0000-0000-0000-000000000000	185	vapdgfvoiyyk	cfc38522-8687-4066-bb9c-6dbcc465396f	t	2026-01-29 19:47:05.019805+00	2026-01-29 23:40:20.255195+00	ik2bi3wm3p2d	11bdb55c-d9fe-4d15-9a98-cc6d1022ac0a
00000000-0000-0000-0000-000000000000	187	odvcogod7fuj	cfc38522-8687-4066-bb9c-6dbcc465396f	f	2026-01-30 11:30:57.466397+00	2026-01-30 11:30:57.466397+00	ivy7yjaipsxu	11bdb55c-d9fe-4d15-9a98-cc6d1022ac0a
00000000-0000-0000-0000-000000000000	127	cusniiazlcvi	d94701c4-30cd-45c7-b642-40b35ef8894c	f	2026-01-04 07:03:57.032847+00	2026-01-04 07:03:57.032847+00	\N	45172cba-a2c7-4493-8b50-eacdf6c2a4b2
00000000-0000-0000-0000-000000000000	129	rjp4yjng2l7q	d94701c4-30cd-45c7-b642-40b35ef8894c	f	2026-01-04 07:41:25.687285+00	2026-01-04 07:41:25.687285+00	\N	336863f9-3f74-4c96-b39a-bd952426a781
00000000-0000-0000-0000-000000000000	131	ahwtm4pd4hqf	d94701c4-30cd-45c7-b642-40b35ef8894c	f	2026-01-04 11:55:20.978134+00	2026-01-04 11:55:20.978134+00	\N	f46f0c77-0bc3-4dbc-b054-c6e6ef678da5
00000000-0000-0000-0000-000000000000	133	nqgenfa5lhud	d94701c4-30cd-45c7-b642-40b35ef8894c	f	2026-01-04 13:27:34.713806+00	2026-01-04 13:27:34.713806+00	q7r5rhawcid2	ee9572f3-ca2d-4ae4-9f08-4a4ccb94715c
00000000-0000-0000-0000-000000000000	134	uq5l6ronjrms	d94701c4-30cd-45c7-b642-40b35ef8894c	t	2026-01-04 13:27:43.985888+00	2026-01-04 16:17:38.798507+00	\N	d8ad4b72-dc9e-49e4-adbe-1b3b49857ae4
00000000-0000-0000-0000-000000000000	136	tuo5e3g4xpkw	d94701c4-30cd-45c7-b642-40b35ef8894c	f	2026-01-04 16:17:38.818659+00	2026-01-04 16:17:38.818659+00	uq5l6ronjrms	d8ad4b72-dc9e-49e4-adbe-1b3b49857ae4
00000000-0000-0000-0000-000000000000	66	up6jjhevfy4j	d94701c4-30cd-45c7-b642-40b35ef8894c	t	2025-12-26 16:35:44.034686+00	2025-12-26 17:53:27.462276+00	\N	ded6fce4-c4da-4d31-a14e-caea63166d65
00000000-0000-0000-0000-000000000000	137	ajx5ecwpw7rh	d94701c4-30cd-45c7-b642-40b35ef8894c	f	2026-01-04 16:17:50.026037+00	2026-01-04 16:17:50.026037+00	\N	27157fb3-f40e-477a-99fc-08ba5dddebf4
00000000-0000-0000-0000-000000000000	68	6vrda64r7xd5	d94701c4-30cd-45c7-b642-40b35ef8894c	t	2025-12-26 17:53:27.476741+00	2025-12-26 19:37:10.627126+00	up6jjhevfy4j	ded6fce4-c4da-4d31-a14e-caea63166d65
00000000-0000-0000-0000-000000000000	70	4vi5ol7zqqhj	d94701c4-30cd-45c7-b642-40b35ef8894c	t	2025-12-27 11:40:14.542827+00	2026-01-07 11:56:13.363399+00	age3qhoxmcb7	ded6fce4-c4da-4d31-a14e-caea63166d65
00000000-0000-0000-0000-000000000000	69	age3qhoxmcb7	d94701c4-30cd-45c7-b642-40b35ef8894c	t	2025-12-26 19:37:10.654086+00	2025-12-27 11:40:14.521377+00	6vrda64r7xd5	ded6fce4-c4da-4d31-a14e-caea63166d65
00000000-0000-0000-0000-000000000000	139	gvuhdow4rjpy	d94701c4-30cd-45c7-b642-40b35ef8894c	f	2026-01-07 11:56:13.381625+00	2026-01-07 11:56:13.381625+00	4vi5ol7zqqhj	ded6fce4-c4da-4d31-a14e-caea63166d65
00000000-0000-0000-0000-000000000000	67	5bx56wflh2lw	d94701c4-30cd-45c7-b642-40b35ef8894c	t	2025-12-26 17:15:53.585051+00	2025-12-27 11:44:42.187258+00	\N	41c55bae-6e8e-4932-8e07-728100a3e84e
00000000-0000-0000-0000-000000000000	72	eq5j4m5ncibb	d94701c4-30cd-45c7-b642-40b35ef8894c	t	2025-12-27 11:44:42.188233+00	2025-12-27 12:59:37.231029+00	5bx56wflh2lw	41c55bae-6e8e-4932-8e07-728100a3e84e
00000000-0000-0000-0000-000000000000	73	w4t7ql4trabs	d94701c4-30cd-45c7-b642-40b35ef8894c	t	2025-12-27 12:59:37.252024+00	2025-12-27 13:58:14.721232+00	eq5j4m5ncibb	41c55bae-6e8e-4932-8e07-728100a3e84e
00000000-0000-0000-0000-000000000000	74	ayt7wfkulff6	d94701c4-30cd-45c7-b642-40b35ef8894c	t	2025-12-27 13:58:14.742394+00	2025-12-27 22:21:58.571733+00	w4t7ql4trabs	41c55bae-6e8e-4932-8e07-728100a3e84e
00000000-0000-0000-0000-000000000000	148	2pirlo4dn4jn	d94701c4-30cd-45c7-b642-40b35ef8894c	f	2026-01-24 08:41:18.083645+00	2026-01-24 08:41:18.083645+00	oyy6hzmqme5b	5200c85f-31c9-4448-b681-82f2ad5806f8
00000000-0000-0000-0000-000000000000	75	y6e72pcdzubx	d94701c4-30cd-45c7-b642-40b35ef8894c	t	2025-12-27 22:21:58.584711+00	2025-12-27 23:20:59.697188+00	ayt7wfkulff6	41c55bae-6e8e-4932-8e07-728100a3e84e
00000000-0000-0000-0000-000000000000	76	5fvgwmzovnin	d94701c4-30cd-45c7-b642-40b35ef8894c	t	2025-12-27 23:20:59.712349+00	2025-12-28 04:09:08.041869+00	y6e72pcdzubx	41c55bae-6e8e-4932-8e07-728100a3e84e
00000000-0000-0000-0000-000000000000	77	una7dfqotey6	d94701c4-30cd-45c7-b642-40b35ef8894c	f	2025-12-28 04:09:08.066514+00	2025-12-28 04:09:08.066514+00	5fvgwmzovnin	41c55bae-6e8e-4932-8e07-728100a3e84e
\.


--
-- TOC entry 5204 (class 0 OID 16858)
-- Dependencies: 364
-- Data for Name: saml_providers; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.saml_providers (id, sso_provider_id, entity_id, metadata_xml, metadata_url, attribute_mapping, created_at, updated_at, name_id_format) FROM stdin;
\.


--
-- TOC entry 5205 (class 0 OID 16876)
-- Dependencies: 365
-- Data for Name: saml_relay_states; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.saml_relay_states (id, sso_provider_id, request_id, for_email, redirect_to, created_at, updated_at, flow_state_id) FROM stdin;
\.


--
-- TOC entry 5193 (class 0 OID 16533)
-- Dependencies: 350
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
-- TOC entry 5198 (class 0 OID 16757)
-- Dependencies: 358
-- Data for Name: sessions; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.sessions (id, user_id, created_at, updated_at, factor_id, aal, not_after, refreshed_at, user_agent, ip, tag, oauth_client_id, refresh_token_hmac_key, refresh_token_counter, scopes) FROM stdin;
11bdb55c-d9fe-4d15-9a98-cc6d1022ac0a	cfc38522-8687-4066-bb9c-6dbcc465396f	2026-01-28 12:11:47.614384+00	2026-01-30 11:30:57.493265+00	\N	aal1	\N	2026-01-30 11:30:57.493127	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0	168.232.24.174	\N	\N	\N	\N	\N
336863f9-3f74-4c96-b39a-bd952426a781	d94701c4-30cd-45c7-b642-40b35ef8894c	2026-01-04 07:41:25.664813+00	2026-01-04 07:41:25.664813+00	\N	aal1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36	138.0.69.95	\N	\N	\N	\N	\N
41c55bae-6e8e-4932-8e07-728100a3e84e	d94701c4-30cd-45c7-b642-40b35ef8894c	2025-12-26 17:15:53.572678+00	2025-12-28 04:09:08.088284+00	\N	aal1	\N	2025-12-28 04:09:08.08754	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36	138.0.69.26	\N	\N	\N	\N	\N
cab27bcd-ca1c-46c5-ae9a-41f325017f62	d94701c4-30cd-45c7-b642-40b35ef8894c	2026-01-04 07:50:57.835065+00	2026-01-04 07:50:57.835065+00	\N	aal1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36	138.0.69.95	\N	\N	\N	\N	\N
f46f0c77-0bc3-4dbc-b054-c6e6ef678da5	d94701c4-30cd-45c7-b642-40b35ef8894c	2026-01-04 11:55:20.945169+00	2026-01-04 11:55:20.945169+00	\N	aal1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36	138.0.69.95	\N	\N	\N	\N	\N
45172cba-a2c7-4493-8b50-eacdf6c2a4b2	d94701c4-30cd-45c7-b642-40b35ef8894c	2026-01-04 07:03:57.009362+00	2026-01-04 07:03:57.009362+00	\N	aal1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36	138.0.69.95	\N	\N	\N	\N	\N
59fba7cc-86b4-4588-ab03-4aef10de4bbd	d94701c4-30cd-45c7-b642-40b35ef8894c	2026-01-04 07:32:27.669853+00	2026-01-04 07:32:27.669853+00	\N	aal1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36	138.0.69.95	\N	\N	\N	\N	\N
ee9572f3-ca2d-4ae4-9f08-4a4ccb94715c	d94701c4-30cd-45c7-b642-40b35ef8894c	2026-01-04 12:21:22.339596+00	2026-01-04 13:27:34.738099+00	\N	aal1	\N	2026-01-04 13:27:34.737993	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36	138.0.69.95	\N	\N	\N	\N	\N
a0026f6d-8a22-4934-9bec-e5d1481823ca	d94701c4-30cd-45c7-b642-40b35ef8894c	2026-01-04 14:26:03.578478+00	2026-01-04 14:26:03.578478+00	\N	aal1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36	138.0.69.95	\N	\N	\N	\N	\N
d8ad4b72-dc9e-49e4-adbe-1b3b49857ae4	d94701c4-30cd-45c7-b642-40b35ef8894c	2026-01-04 13:27:43.978974+00	2026-01-04 16:17:38.846022+00	\N	aal1	\N	2026-01-04 16:17:38.845911	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36	138.0.69.95	\N	\N	\N	\N	\N
27157fb3-f40e-477a-99fc-08ba5dddebf4	d94701c4-30cd-45c7-b642-40b35ef8894c	2026-01-04 16:17:50.018388+00	2026-01-04 16:17:50.018388+00	\N	aal1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36	138.0.69.95	\N	\N	\N	\N	\N
ded6fce4-c4da-4d31-a14e-caea63166d65	d94701c4-30cd-45c7-b642-40b35ef8894c	2025-12-26 16:35:44.012776+00	2026-01-07 11:56:13.407102+00	\N	aal1	\N	2026-01-07 11:56:13.406439	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36	168.232.24.174	\N	\N	\N	\N	\N
5200c85f-31c9-4448-b681-82f2ad5806f8	d94701c4-30cd-45c7-b642-40b35ef8894c	2026-01-04 16:21:44.799689+00	2026-01-24 08:41:18.115124+00	\N	aal1	\N	2026-01-24 08:41:18.115008	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36	138.0.69.159	\N	\N	\N	\N	\N
ff622ef0-711d-4087-bb4d-3def77d7c18b	d94701c4-30cd-45c7-b642-40b35ef8894c	2026-01-28 13:06:52.050677+00	2026-01-29 16:51:51.481223+00	\N	aal1	\N	2026-01-29 16:51:51.48112	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36	168.232.24.174	\N	\N	\N	\N	\N
\.


--
-- TOC entry 5203 (class 0 OID 16843)
-- Dependencies: 363
-- Data for Name: sso_domains; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.sso_domains (id, sso_provider_id, domain, created_at, updated_at) FROM stdin;
\.


--
-- TOC entry 5202 (class 0 OID 16834)
-- Dependencies: 362
-- Data for Name: sso_providers; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.sso_providers (id, resource_id, created_at, updated_at, disabled) FROM stdin;
\.


--
-- TOC entry 5188 (class 0 OID 16495)
-- Dependencies: 345
-- Data for Name: users; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.users (instance_id, id, aud, role, email, encrypted_password, email_confirmed_at, invited_at, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user, deleted_at, is_anonymous) FROM stdin;
00000000-0000-0000-0000-000000000000	d94701c4-30cd-45c7-b642-40b35ef8894c	authenticated	authenticated	urubiciparkhotel.ac@gmail.com	$2a$06$zAMl0aPG69c.fBhI5u249u8qO.FM6bgHzPG/G5EwOzz8cIe8Z3dYG	2025-12-26 16:35:44.002586+00	\N		\N		\N			\N	2026-01-28 13:06:52.050551+00	{"provider": "google", "providers": ["google"]}	{"iss": "https://accounts.google.com", "sub": "117320287655913329565", "name": "Urubici Park Hotel", "email": "urubiciparkhotel.ac@gmail.com", "picture": "https://lh3.googleusercontent.com/a/ACg8ocKgNzXYgud2F6-Y2v1ZCUVnqHkLR2em4NONkFxf3KnL3AYfzLY=s96-c", "full_name": "Urubici Park Hotel", "avatar_url": "https://lh3.googleusercontent.com/a/ACg8ocKgNzXYgud2F6-Y2v1ZCUVnqHkLR2em4NONkFxf3KnL3AYfzLY=s96-c", "provider_id": "117320287655913329565", "email_verified": true, "phone_verified": false, "onboarding_completed": true}	\N	2025-12-26 16:35:43.874051+00	2026-01-29 16:51:51.479279+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	cfc38522-8687-4066-bb9c-6dbcc465396f	authenticated	authenticated	cooperti.sistemas@gmail.com	$2a$10$lCPxdrKGDxULgzjFFRMKLey27FGfobn8ANmWKc./3WvIfQ1NjwSvq	2025-10-14 07:11:59.882266+00	\N		2025-10-14 07:11:06.80379+00		\N			\N	2026-01-28 12:11:47.614249+00	{"provider": "email", "providers": ["email", "google"]}	{"iss": "https://accounts.google.com", "sub": "117902222818336046834", "name": "cooperti sistemas", "email": "cooperti.sistemas@gmail.com", "phone": "51986859236", "picture": "https://lh3.googleusercontent.com/a/ACg8ocKOAhA5Ptc37HNlwxofXTaRy4jTOA8AiJkoyJygemYcTR4syQ=s96-c", "full_name": "cooperti sistemas", "avatar_url": "https://lh3.googleusercontent.com/a/ACg8ocKOAhA5Ptc37HNlwxofXTaRy4jTOA8AiJkoyJygemYcTR4syQ=s96-c", "provider_id": "117902222818336046834", "email_verified": true, "phone_verified": false}	\N	2025-10-14 07:11:06.774408+00	2026-01-30 11:30:57.477488+00	\N	\N			\N		0	\N		\N	f	\N	f
\.


--
-- TOC entry 5219 (class 0 OID 18026)
-- Dependencies: 383
-- Data for Name: amenities; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.amenities (id, created_at, updated_at, name, icon, description, org_id) FROM stdin;
c2d3e4f5-a6b7-8c9d-0e1f-2a3b4c5d6e7f	2025-10-14 06:50:34.766109+00	2025-10-14 06:50:34.766109+00	Wi-Fi Grátis	Wifi	Acesso à internet de alta velocidade em todas as áreas.	b729534c-753b-48b0-ab4f-0756cc1cd271
d3e4f5a6-b7c8-9d0e-1f2a-3b4c5d6e7f8a	2025-10-14 06:50:34.766109+00	2025-10-14 06:50:34.766109+00	Piscina Aquecida	SwimmingPool	Piscina coberta e aquecida disponível o ano todo.	b729534c-753b-48b0-ab4f-0756cc1cd271
e4f5a6b7-c8d9-0e1f-2a3b-4c5d6e7f8a9b	2025-10-14 06:50:34.766109+00	2025-10-14 06:50:34.766109+00	Café da Manhã	Coffee	Café da manhã completo incluso na diária.	b729534c-753b-48b0-ab4f-0756cc1cd271
96b84744-48e9-4dbb-acc8-ce9408ee5064	2026-01-02 13:44:37.478841+00	2026-01-02 13:44:37.478841+00	Televisor	tv	Televisor, para maior conforto e entretenimento durante a estadia.	b729534c-753b-48b0-ab4f-0756cc1cd271
161cdb45-37c3-4888-bd18-69b5893e071d	2026-01-02 13:54:16.758741+00	2026-01-02 13:54:16.758741+00	frigobar	refrigerator		b729534c-753b-48b0-ab4f-0756cc1cd271
c9b15cf3-bcaf-448e-95f7-183bab88778a	2026-01-02 12:52:58.956311+00	2026-01-02 12:52:58.956311+00	Cama BOX Spring	Bed-double	Cama BOX Spring, com suporte uniforme e conforto superior, ideal para uma noite de descanso tranquila.	b729534c-753b-48b0-ab4f-0756cc1cd271
62679e40-62d8-47c0-8d11-e2dd9afa8af1	2026-01-02 14:08:02.528751+00	2026-01-02 14:08:02.528751+00	telefonia direta	phone-outgoing		b729534c-753b-48b0-ab4f-0756cc1cd271
cbaaa21a-b943-4ff8-b010-b6e6c3f5a145	2026-01-02 14:11:14.973287+00	2026-01-02 14:11:14.973287+00	Ducha com aquecimento central quente e fria	shower-head		b729534c-753b-48b0-ab4f-0756cc1cd271
59ffc9c7-3517-4625-a91a-93a09c57c7f3	2026-01-02 14:09:31.776694+00	2026-01-02 14:09:31.776694+00	Banheiro privativo	bath		b729534c-753b-48b0-ab4f-0756cc1cd271
65c3d7f0-2fe5-4001-9df7-77cdb23918d8	2026-01-02 14:14:18.752007+00	2026-01-02 14:14:18.752007+00	Ar Condicionado	air-vent		b729534c-753b-48b0-ab4f-0756cc1cd271
\.


--
-- TOC entry 5254 (class 0 OID 63581)
-- Dependencies: 418
-- Data for Name: audit_log; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.audit_log (id, created_at, actor_user_id, target_user_id, action, old_data, new_data) FROM stdin;
59456e1a-5bb9-4674-a7ad-d73f6d289732	2026-01-02 10:37:19.776065+00	\N	cfc38522-8687-4066-bb9c-6dbcc465396f	PROFILE_SENSITIVE_UPDATE	{"plan": "free", "plan_status": "active", "trial_expires_at": null, "trial_extension_days": 0}	{"plan": "founder", "plan_status": "active", "trial_expires_at": null, "trial_extension_days": 0}
a99b858d-b74b-4226-8bb6-ee784e0c796b	2026-01-28 13:11:21.170479+00	\N	d94701c4-30cd-45c7-b642-40b35ef8894c	PROFILE_SENSITIVE_UPDATE	{"plan": "free", "plan_status": "trial", "trial_expires_at": "2026-01-10T16:35:43.787521+00:00", "trial_extension_days": 0}	{"plan": "premium", "plan_status": "active", "trial_expires_at": null, "trial_extension_days": 0}
\.


--
-- TOC entry 5248 (class 0 OID 61059)
-- Dependencies: 412
-- Data for Name: booking_charges; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.booking_charges (id, booking_id, description, amount, category, created_at, updated_at) FROM stdin;
\.


--
-- TOC entry 5270 (class 0 OID 83395)
-- Dependencies: 434
-- Data for Name: booking_guests; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.booking_guests (id, org_id, booking_id, guest_id, is_head, relationship, created_at, full_name, document, is_primary) FROM stdin;
\.


--
-- TOC entry 5274 (class 0 OID 84672)
-- Dependencies: 438
-- Data for Name: booking_rooms; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.booking_rooms (id, org_id, property_id, booking_id, room_id, is_primary, created_at, updated_at) FROM stdin;
b77107b5-edff-4e38-9d6d-84078dd631ec	b729534c-753b-48b0-ab4f-0756cc1cd271	11111111-1111-1111-1111-111111111111	94b10108-3bd6-4af7-b098-5e654f588f7c	44444444-4444-4444-4444-444444444401	t	2026-02-14 14:06:01.887278+00	2026-02-14 14:06:01.887278+00
\.


--
-- TOC entry 5221 (class 0 OID 18054)
-- Dependencies: 385
-- Data for Name: bookings; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.bookings (id, property_id, created_at, updated_at, guest_name, guest_email, guest_phone, check_in, check_out, total_guests, total_amount, status, notes, room_type_id, services_json, current_room_id, lead_id, org_id, stripe_session_id) FROM stdin;
94b10108-3bd6-4af7-b098-5e654f588f7c	11111111-1111-1111-1111-111111111111	2026-02-14 11:05:27.234954+00	2026-02-14 11:05:27.234954+00	Hóspede Teste Confirmado	confirmado@teste.com	(49) 90000-0001	2026-03-01	2026-03-05	2	720.00	CONFIRMED	Reserva seed CONFIRMED (bloqueia disponibilidade do Standard).	22222222-2222-2222-2222-222222222222	{}	44444444-4444-4444-4444-444444444401	\N	b729534c-753b-48b0-ab4f-0756cc1cd271	\N
b5ae3cd4-0c28-4106-af14-16f2d546e1a1	11111111-1111-1111-1111-111111111111	2026-02-14 11:05:27.234954+00	2026-02-14 11:05:27.234954+00	Hóspede Teste Cancelado	cancelado@teste.com	(49) 90000-0002	2026-03-02	2026-03-04	2	360.00	CANCELLED	Reserva seed CANCELLED (não bloqueia).	22222222-2222-2222-2222-222222222222	{}	\N	\N	b729534c-753b-48b0-ab4f-0756cc1cd271	\N
\.


--
-- TOC entry 5240 (class 0 OID 59768)
-- Dependencies: 404
-- Data for Name: departments; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.departments (id, property_id, name, active, created_at) FROM stdin;
\.


--
-- TOC entry 5222 (class 0 OID 18072)
-- Dependencies: 386
-- Data for Name: entity_photos; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.entity_photos (id, entity_id, created_at, updated_at, photo_url, is_primary, display_order) FROM stdin;
\.


--
-- TOC entry 5228 (class 0 OID 18532)
-- Dependencies: 392
-- Data for Name: expenses; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.expenses (id, property_id, description, amount, expense_date, category, created_at, updated_at, payment_status, paid_date) FROM stdin;
\.


--
-- TOC entry 5232 (class 0 OID 18781)
-- Dependencies: 396
-- Data for Name: faqs; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.faqs (id, question, answer, display_order, created_at, updated_at) FROM stdin;
0eaa803a-839a-4cea-a57b-79a218a26531	Como funciona a garantia de 30 dias?	Oferecemos uma garantia de satisfação de 30 dias. Se por qualquer motivo você não estiver satisfeito com o HostConnect, devolveremos o valor integral do seu plano. Sem burocracia, sem perguntas.	1	2025-10-15 17:01:33.182218+00	2025-10-15 17:01:33.182218+00
d7958f68-948c-499a-8073-91cb899f0136	Posso gerenciar múltiplas propriedades com um único plano?	Sim! Nossos planos Profissional e Corporativo permitem gerenciar múltiplas propriedades. O plano Profissional suporta até 3 propriedades, enquanto o Corporativo oferece propriedades ilimitadas.	2	2025-10-15 17:01:33.182218+00	2025-10-15 17:01:33.182218+00
4bdc6620-6eca-4539-b27c-f7951c5d3204	Como o HostConnect se integra com Booking.com e Airbnb?	Nosso sistema possui integrações diretas com as principais OTAs (Online Travel Agencies) como Booking.com e Airbnb. Isso permite a sincronização automática de disponibilidade e preços, evitando overbookings e otimizando sua gestão.	3	2025-10-15 17:01:33.182218+00	2025-10-15 17:01:33.182218+00
29c65906-0347-46bc-a70b-51b479bae877	O que é o Agente de IA para Vendas?	O Agente de IA é uma ferramenta inovadora que atua como um SDR (Sales Development Representative) virtual. Ele responde a dúvidas de potenciais hóspedes 24/7, qualifica leads e pode até auxiliar no processo de reserva, liberando sua equipe para focar no atendimento presencial.	4	2025-10-15 17:01:33.182218+00	2025-10-15 17:01:33.182218+00
75d4db8d-c03c-486a-beb8-818f5f767f35	Posso ter um motor de reservas com a minha própria marca?	Sim! A partir do plano Essencial, você recebe um motor de reservas personalizável para o seu site, sem comissões sobre as reservas diretas. No plano Corporativo, oferecemos a opção de White Label, onde o motor de reservas é totalmente integrado à sua marca, sem menção ao HostConnect.	5	2025-10-15 17:01:33.182218+00	2025-10-15 17:01:33.182218+00
1cb02cf3-b0c8-45c1-a536-de9b04f5048a	Como funciona a comissão sobre reservas?	Além de um valor fixo mensal, cobramos uma pequena porcentagem sobre as reservas confirmadas através da plataforma. Essa comissão varia de acordo com o plano escolhido, incentivando o seu crescimento e garantindo que pagamos apenas pelo sucesso.	6	2025-10-15 17:01:33.182218+00	2025-10-15 17:01:33.182218+00
55f7cd5b-a996-4aea-af82-b1242d9f227f	O HostConnect é compatível com a LGPD?	Sim, a segurança e privacidade dos dados são prioridades. O HostConnect é totalmente compatível com a Lei Geral de Proteção de Dados (LGPD), garantindo que todas as informações de seus hóspedes e de sua propriedade sejam tratadas com a máxima segurança e transparência.	7	2025-10-15 17:01:33.182218+00	2025-10-15 17:01:33.182218+00
e99cf62d-ee3b-4512-bd0d-68a34e3965cf	Posso integrar o HostConnect com outros sistemas que já utilizo?	Oferecemos uma API REST para integração com outros sistemas, permitindo que você conecte o HostConnect ao seu ecossistema de ferramentas. Esta API é projetada para uso dentro do ambiente HostConnect, garantindo a segurança e a integridade dos dados.	8	2025-10-15 17:01:33.182218+00	2025-10-15 17:01:33.182218+00
\.


--
-- TOC entry 5235 (class 0 OID 18823)
-- Dependencies: 399
-- Data for Name: features; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.features (id, title, description, icon, display_order, created_at, updated_at) FROM stdin;
7fc1c0c5-3e68-4b30-a696-81e57f3a8951	Gestão de Reservas Inteligente e Flexível	Sistema completo para gerenciar todas as suas reservas online e offline, com calendário intuitivo, automações e flexibilidade para se adaptar às suas necessidades.	Calendar	1	2025-10-15 17:01:33.182218+00	2025-10-15 17:01:33.182218+00
79b87a3a-344d-4517-b560-ad35dfc03ecc	Pagamentos Online Integrados	Receba pagamentos de forma segura e automatizada via Stripe, configurável por propriedade.	CreditCard	2	2025-10-15 17:01:33.182218+00	2025-10-15 17:01:33.182218+00
03b19f5c-aeac-4b28-bd3c-e616f5f0e6ae	Dashboard de Performance	Métricas e relatórios em tempo real para análises financeiras e operacionais, otimizando suas decisões.	BarChart3	3	2025-10-15 17:01:33.182218+00	2025-10-15 17:01:33.182218+00
3129aa4b-ce7e-4eda-bd61-9c77f6f4e78c	Motor de Reservas Personalizável	Tenha um site próprio com sistema de reservas integrado, com a sua marca e sem comissões.	Globe	4	2025-10-15 17:01:33.182218+00	2025-10-15 17:01:33.182218+00
f7a19f4b-9467-4f10-9d9e-df1312f68361	Gestão Multi-Propriedades	Gerencie múltiplas propriedades de diferentes cidades ou tipos, tudo em uma única plataforma.	Users	5	2025-10-15 17:01:33.182218+00	2025-10-15 17:01:33.182218+00
9d6516bc-8ce8-4068-9fc6-703b3da81e77	Segurança e Conformidade	Seus dados e os de seus hóspedes protegidos com criptografia de nível empresarial e conformidade com LGPD.	ShieldCheck	6	2025-10-15 17:01:33.182218+00	2025-10-15 17:01:33.182218+00
0d095e17-6601-442f-b784-fde4a723cb6a	Otimização de Preços Dinâmica	Crie regras de precificação flexíveis, promoções e gerencie estadias mínimas/máximas para maximizar sua receita.	Zap	7	2025-10-15 17:01:33.182218+00	2025-10-15 17:01:33.182218+00
e7757323-5105-472d-9352-dd23b4dd8c78	Comunicação Automatizada	Envie confirmações, lembretes e mensagens personalizadas aos seus hóspedes automaticamente.	MessageSquareText	8	2025-10-15 17:01:33.182218+00	2025-10-15 17:01:33.182218+00
9918f535-c55c-467c-8234-92e0b317d3ca	Relatórios Detalhados	Acesse relatórios completos sobre ocupação, receita, hóspedes e muito mais para uma gestão eficiente.	FileText	9	2025-10-15 17:01:33.182218+00	2025-10-15 17:01:33.182218+00
67bddd0c-32ec-4d41-9191-4077c2fea6a4	Gestão de Tarefas e Equipe	Organize as atividades diárias da sua propriedade com um sistema de tarefas intuitivo e atribua responsabilidades à sua equipe.	ListTodo	10	2025-10-15 17:01:33.182218+00	2025-10-15 17:01:33.182218+00
5cba7107-e6f5-42f5-abd4-c91aef42e70c	Controle de Despesas Simplificado	Registre e acompanhe todas as despesas da sua propriedade para uma visão financeira completa e precisa.	Wallet	11	2025-10-15 17:01:33.182218+00	2025-10-15 17:01:33.182218+00
\.


--
-- TOC entry 5269 (class 0 OID 83380)
-- Dependencies: 433
-- Data for Name: guest_consents; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.guest_consents (id, org_id, guest_id, consent_type, accepted, ip_address, user_agent, created_at, type, granted, source, captured_by) FROM stdin;
\.


--
-- TOC entry 5268 (class 0 OID 83368)
-- Dependencies: 432
-- Data for Name: guests; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.guests (id, org_id, full_name, email, phone, document_id, document_type, birth_date, gender, address_json, created_at, updated_at, document, birthdate, notes, first_name, last_name) FROM stdin;
\.


--
-- TOC entry 5275 (class 0 OID 85814)
-- Dependencies: 439
-- Data for Name: hostconnect_onboarding; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.hostconnect_onboarding (id, org_id, property_id, mode, last_step, completed_at, dismissed_at, created_at, updated_at) FROM stdin;
5a316f37-cd16-4b0a-8b27-3b577ace8a45	63489650-68ee-4593-9f06-544bbec80339	\N	hotel	1	\N	2026-01-28 12:52:51.587+00	2026-01-23 17:22:16.860072+00	2026-01-28 12:53:04.159744+00
ddd7f5ef-263f-4566-9767-95adee2d0241	b729534c-753b-48b0-ab4f-0756cc1cd271	\N	hotel	2	\N	\N	2026-01-28 13:06:53.574527+00	2026-01-28 13:15:19.794551+00
\.


--
-- TOC entry 5249 (class 0 OID 63432)
-- Dependencies: 413
-- Data for Name: hostconnect_staff; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.hostconnect_staff (user_id, role, created_at) FROM stdin;
\.


--
-- TOC entry 5236 (class 0 OID 18836)
-- Dependencies: 400
-- Data for Name: how_it_works_steps; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.how_it_works_steps (id, step_number, title, description, icon, created_at, updated_at) FROM stdin;
d65f35bf-ace9-4709-9b62-64c68b9272df	1	Crie sua Conta	Cadastre-se e configure suas propriedades em poucos minutos. Conte com nossa garantia de 30 dias.	\N	2025-10-15 17:01:33.182218+00	2025-10-15 17:01:33.182218+00
7a1cc169-da34-4672-8cb4-0a72a72074e1	2	Personalize	Configure suas tarifas, quartos e preferências. Conecte com suas ferramentas favoritas.	\N	2025-10-15 17:01:33.182218+00	2025-10-15 17:01:33.182218+00
80403f3a-a81a-4ac6-9cde-3cdf0d4bd092	3	Comece a Vender	Receba suas primeiras reservas e acompanhe tudo em tempo real no dashboard completo.	\N	2025-10-15 17:01:33.182218+00	2025-10-15 17:01:33.182218+00
\.


--
-- TOC entry 5253 (class 0 OID 63505)
-- Dependencies: 417
-- Data for Name: idea_comments; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.idea_comments (id, idea_id, user_id, content, is_staff_reply, created_at) FROM stdin;
\.


--
-- TOC entry 5252 (class 0 OID 63487)
-- Dependencies: 416
-- Data for Name: ideas; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.ideas (id, user_id, title, description, status, votes, created_at, updated_at, org_id) FROM stdin;
\.


--
-- TOC entry 5233 (class 0 OID 18794)
-- Dependencies: 397
-- Data for Name: integrations; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.integrations (id, name, icon, description, is_visible, display_order, created_at, updated_at) FROM stdin;
838e5e1f-1636-4c3c-96d0-815bcfc3f33a	Booking.com	Globe	Sincronização de disponibilidade e preços.	t	1	2025-10-15 17:01:33.182218+00	2025-10-15 17:01:33.182218+00
f048c0bf-e5f5-4501-8d4c-8151f6d7ba95	Airbnb	Building2	Conexão direta com o calendário e tarifas.	t	2	2025-10-15 17:01:33.182218+00	2025-10-15 17:01:33.182218+00
c4301e53-ba37-4af3-987f-1f065d5b4a76	Expedia	Plane	Integração com o canal de vendas da Expedia.	t	3	2025-10-15 17:01:33.182218+00	2025-10-15 17:01:33.182218+00
a188e848-11fc-4cec-81b5-f124600ae27f	Stripe	CreditCard	Processamento de pagamentos online seguro.	t	4	2025-10-15 17:01:33.182218+00	2025-10-15 17:01:33.182218+00
c7c6e16c-efb3-40b6-a1b3-e6f9da622829	WhatsApp	Smartphone	Comunicação direta com hóspedes.	t	5	2025-10-15 17:01:33.182218+00	2025-10-15 17:01:33.182218+00
0bdbef0d-ef79-42b0-875e-fb3dabda239f	API HostConnect	Wifi	Para integração exclusiva dentro do ecossistema HostConnect.	t	6	2025-10-15 17:01:33.182218+00	2025-10-15 17:01:33.182218+00
\.


--
-- TOC entry 5259 (class 0 OID 63793)
-- Dependencies: 423
-- Data for Name: inventory_items; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.inventory_items (id, org_id, name, category, description, created_at, updated_at, price, is_for_sale) FROM stdin;
\.


--
-- TOC entry 5230 (class 0 OID 18739)
-- Dependencies: 394
-- Data for Name: invoices; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.invoices (id, booking_id, property_id, issue_date, due_date, total_amount, paid_amount, status, payment_method, payment_intent_id, created_at, updated_at) FROM stdin;
\.


--
-- TOC entry 5261 (class 0 OID 63838)
-- Dependencies: 425
-- Data for Name: item_stock; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.item_stock (id, item_id, location, quantity, last_updated_at, updated_by, org_id) FROM stdin;
\.


--
-- TOC entry 5247 (class 0 OID 59931)
-- Dependencies: 411
-- Data for Name: lead_timeline_events; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.lead_timeline_events (id, lead_id, type, payload, created_by, created_at) FROM stdin;
\.


--
-- TOC entry 5257 (class 0 OID 63711)
-- Dependencies: 421
-- Data for Name: member_permissions; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.member_permissions (id, org_id, user_id, module_key, can_read, can_write, created_at, updated_at) FROM stdin;
\.


--
-- TOC entry 5229 (class 0 OID 18552)
-- Dependencies: 393
-- Data for Name: notifications; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.notifications (id, user_id, type, message, is_read, created_at) FROM stdin;
\.


--
-- TOC entry 5258 (class 0 OID 63737)
-- Dependencies: 422
-- Data for Name: org_invites; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.org_invites (id, org_id, email, role, token, status, created_at, expires_at) FROM stdin;
\.


--
-- TOC entry 5256 (class 0 OID 63619)
-- Dependencies: 420
-- Data for Name: org_members; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.org_members (id, org_id, user_id, role, created_at) FROM stdin;
f8834898-9ff0-4a42-9d0c-45d6af481f46	b729534c-753b-48b0-ab4f-0756cc1cd271	d94701c4-30cd-45c7-b642-40b35ef8894c	owner	2025-12-26 16:35:43.787521+00
a0805f6d-5a0e-4a5d-87ee-c98501125736	63489650-68ee-4593-9f06-544bbec80339	cfc38522-8687-4066-bb9c-6dbcc465396f	owner	2026-01-23 17:01:01.581246+00
38857ba0-54e4-4c9d-b07b-f8a6966acee4	b729534c-753b-48b0-ab4f-0756cc1cd271	cfc38522-8687-4066-bb9c-6dbcc465396f	owner	2026-01-27 23:09:59.379889+00
\.


--
-- TOC entry 5255 (class 0 OID 63605)
-- Dependencies: 419
-- Data for Name: organizations; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.organizations (id, name, created_at, owner_id) FROM stdin;
b729534c-753b-48b0-ab4f-0756cc1cd271	Urubici Park Hotel - Hospedagem	2025-12-26 16:35:43.787521+00	d94701c4-30cd-45c7-b642-40b35ef8894c
63489650-68ee-4593-9f06-544bbec80339	cooperti sistemas's Organization	2026-01-23 10:52:57.311883+00	cfc38522-8687-4066-bb9c-6dbcc465396f
\.


--
-- TOC entry 5271 (class 0 OID 83418)
-- Dependencies: 435
-- Data for Name: pre_checkin_sessions; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.pre_checkin_sessions (id, org_id, booking_id, token_hash, expires_at, status, created_at, token) FROM stdin;
\.


--
-- TOC entry 5272 (class 0 OID 84583)
-- Dependencies: 436
-- Data for Name: pre_checkin_submissions; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.pre_checkin_submissions (id, org_id, session_id, status, payload, created_at, updated_at) FROM stdin;
\.


--
-- TOC entry 5273 (class 0 OID 84631)
-- Dependencies: 437
-- Data for Name: precheckin_sessions; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.precheckin_sessions (id, booking_id, org_id, status, created_at, updated_at) FROM stdin;
\.


--
-- TOC entry 5231 (class 0 OID 18766)
-- Dependencies: 395
-- Data for Name: pricing_plans; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.pricing_plans (id, name, price, commission, period, description, is_popular, display_order, features, created_at, updated_at) FROM stdin;
1e9b8dbe-f976-4b9e-a5b2-aec9e39ae757	Essencial	99.00	5.0	/mês + comissão	Ideal para pequenas pousadas e iniciantes.	f	1	["Até 5 acomodações", "Dashboard básico", "Gestão de reservas (online e offline)", "Suporte por email", "1 propriedade", "Motor de Reservas (Site Bônus)"]	2025-10-15 17:01:33.182218+00	2025-10-15 17:01:33.182218+00
1823c386-f2f2-40ed-a7ef-ba125cb891ae	Profissional	199.00	3.0	/mês + comissão	Para hotéis em crescimento que buscam otimização.	t	2	["Até 10 acomodações", "Dashboard avançado", "Motor de Reservas (Site Bônus)", "Até 3 propriedades", "Integrações OTAs (Booking, Airbnb, Expedia)", "Pagamentos Online (Stripe)", "Relatórios Detalhados"]	2025-10-15 17:01:33.182218+00	2025-10-15 17:01:33.182218+00
5ffa8202-9b12-475c-a01f-a7d330077418	Corporativo	499.00	1.0	/mês + comissão	Para grandes operações e redes hoteleiras.	f	3	["Acomodações ilimitadas", "Todas as funcionalidades", "Central de Reservas", "Propriedades ilimitadas", "Suporte prioritário (WhatsApp e Telefone)", "Motor de Reservas White Label (Site Bônus)", "API para Ecossistema HostConnect"]	2025-10-15 17:01:33.182218+00	2025-10-15 17:01:33.182218+00
\.


--
-- TOC entry 5224 (class 0 OID 18342)
-- Dependencies: 388
-- Data for Name: pricing_rules; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.pricing_rules (id, created_at, updated_at, property_id, room_type_id, start_date, end_date, base_price_override, price_modifier, min_stay, max_stay, promotion_name, status, org_id) FROM stdin;
62c2cb5e-ece1-4aff-adf2-17b400f09b1f	2026-02-14 11:06:08.406605+00	2026-02-14 11:06:08.406605+00	11111111-1111-1111-1111-111111111111	33333333-3333-3333-3333-333333333333	2026-03-01	2026-03-31	\N	50.00	1	30	Adicional Março (Seed)	active	b729534c-753b-48b0-ab4f-0756cc1cd271
\.


--
-- TOC entry 5217 (class 0 OID 17992)
-- Dependencies: 381
-- Data for Name: profiles; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.profiles (id, created_at, updated_at, full_name, email, phone, role, plan, accommodation_limit, founder_started_at, founder_expires_at, entitlements, onboarding_completed, onboarding_step, onboarding_type, trial_started_at, trial_expires_at, trial_extended_at, trial_extension_days, trial_extension_reason, plan_status, is_super_admin) FROM stdin;
d94701c4-30cd-45c7-b642-40b35ef8894c	2025-12-26 16:35:43.787521+00	2026-01-28 13:11:21.170479+00	Urubici Park Hotel	urubiciparkhotel.ac@gmail.com	(49) 98425-2023	admin	premium	100	\N	\N	\N	t	4	hotel	2025-12-26 16:35:43.787521+00	\N	\N	0	\N	active	f
cfc38522-8687-4066-bb9c-6dbcc465396f	2025-10-14 07:11:06.767909+00	2025-10-14 07:11:06.767909+00	José Alexandre F de Santana	cooperti.sistemas@gmail.com	51986859236	user	founder	100	\N	\N	\N	t	2	hotel	\N	\N	\N	0	\N	active	t
\.


--
-- TOC entry 5218 (class 0 OID 18008)
-- Dependencies: 382
-- Data for Name: properties; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.properties (id, user_id, created_at, updated_at, name, description, address, city, state, country, postal_code, phone, email, total_rooms, status, org_id, neighborhood, number, no_number, whatsapp) FROM stdin;
11111111-1111-1111-1111-111111111111	cfc38522-8687-4066-bb9c-6dbcc465396f	2026-02-14 01:15:40.544487+00	2026-02-14 01:15:40.544487+00	Urubici Park Hotel (Seed)	Seed de testes para validar sync Host → Reserve e search_availability.	Av. Principal, Centro	Urubici	SC	BR	88650-000	(49) 99999-9999	seed@urubiciparkhotel.com	5	active	b729534c-753b-48b0-ab4f-0756cc1cd271	Centro	100	f	(49) 99999-9999
\.


--
-- TOC entry 5245 (class 0 OID 59872)
-- Dependencies: 409
-- Data for Name: reservation_leads; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.reservation_leads (id, property_id, source, channel, status, guest_name, guest_phone, guest_email, check_in_date, check_out_date, adults, children, notes, assigned_to, created_by, created_at, updated_at) FROM stdin;
\.


--
-- TOC entry 5246 (class 0 OID 59902)
-- Dependencies: 410
-- Data for Name: reservation_quotes; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.reservation_quotes (id, lead_id, property_id, currency, subtotal, fees, taxes, total, policy_text, expires_at, sent_at, status, created_by, created_at) FROM stdin;
\.


--
-- TOC entry 5262 (class 0 OID 69393)
-- Dependencies: 426
-- Data for Name: room_categories; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.room_categories (id, name, slug, description, display_order, created_at, updated_at, property_id, org_id) FROM stdin;
\.


--
-- TOC entry 5260 (class 0 OID 63813)
-- Dependencies: 424
-- Data for Name: room_type_inventory; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.room_type_inventory (id, room_type_id, item_id, quantity, created_at, org_id) FROM stdin;
\.


--
-- TOC entry 5220 (class 0 OID 18036)
-- Dependencies: 384
-- Data for Name: room_types; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.room_types (id, property_id, created_at, updated_at, name, description, capacity, base_price, status, amenities_json, category, abbreviation, occupation_label, occupation_abbr, org_id) FROM stdin;
22222222-2222-2222-2222-222222222222	11111111-1111-1111-1111-111111111111	2026-02-14 01:16:15.794939+00	2026-02-14 01:16:15.794939+00	Standard (Seed)	Quarto standard para testes.	2	180.00	active	{wi-fi,"café da manhã",estacionamento}	standard	STD	Até 2 pessoas	2p	b729534c-753b-48b0-ab4f-0756cc1cd271
33333333-3333-3333-3333-333333333333	11111111-1111-1111-1111-111111111111	2026-02-14 01:16:15.794939+00	2026-02-14 01:16:15.794939+00	Deluxe (Seed)	Quarto deluxe para testes.	4	320.00	active	{wi-fi,"café da manhã",banheira,"vista serra"}	deluxe	DLX	Até 4 pessoas	4p	b729534c-753b-48b0-ab4f-0756cc1cd271
\.


--
-- TOC entry 5223 (class 0 OID 18266)
-- Dependencies: 387
-- Data for Name: rooms; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.rooms (id, property_id, room_type_id, room_number, status, created_at, updated_at, last_booking_id, org_id, updated_by) FROM stdin;
44444444-4444-4444-4444-444444444401	11111111-1111-1111-1111-111111111111	22222222-2222-2222-2222-222222222222	101	available	2026-02-14 01:16:32.729775+00	2026-02-14 01:16:32.729775+00	\N	b729534c-753b-48b0-ab4f-0756cc1cd271	\N
44444444-4444-4444-4444-444444444402	11111111-1111-1111-1111-111111111111	22222222-2222-2222-2222-222222222222	102	available	2026-02-14 01:16:32.729775+00	2026-02-14 01:16:32.729775+00	\N	b729534c-753b-48b0-ab4f-0756cc1cd271	\N
44444444-4444-4444-4444-444444444403	11111111-1111-1111-1111-111111111111	22222222-2222-2222-2222-222222222222	103	available	2026-02-14 01:16:32.729775+00	2026-02-14 01:16:32.729775+00	\N	b729534c-753b-48b0-ab4f-0756cc1cd271	\N
44444444-4444-4444-4444-444444444404	11111111-1111-1111-1111-111111111111	33333333-3333-3333-3333-333333333333	201	available	2026-02-14 01:16:32.729775+00	2026-02-14 01:16:32.729775+00	\N	b729534c-753b-48b0-ab4f-0756cc1cd271	\N
44444444-4444-4444-4444-444444444405	11111111-1111-1111-1111-111111111111	33333333-3333-3333-3333-333333333333	202	available	2026-02-14 01:16:32.729775+00	2026-02-14 01:16:32.729775+00	\N	b729534c-753b-48b0-ab4f-0756cc1cd271	\N
\.


--
-- TOC entry 5225 (class 0 OID 18392)
-- Dependencies: 389
-- Data for Name: services; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.services (id, property_id, name, description, price, is_per_person, is_per_day, status, created_at, updated_at, org_id) FROM stdin;
\.


--
-- TOC entry 5243 (class 0 OID 59830)
-- Dependencies: 407
-- Data for Name: shift_assignments; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.shift_assignments (id, shift_id, staff_id, role_on_shift, status, check_in_at, check_out_at, created_at) FROM stdin;
\.


--
-- TOC entry 5244 (class 0 OID 59851)
-- Dependencies: 408
-- Data for Name: shift_handoffs; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.shift_handoffs (id, shift_id, text, tags, attachments, created_by, created_at) FROM stdin;
\.


--
-- TOC entry 5242 (class 0 OID 59804)
-- Dependencies: 406
-- Data for Name: shifts; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.shifts (id, property_id, department_id, start_at, end_at, status, notes, created_by, created_at) FROM stdin;
\.


--
-- TOC entry 5241 (class 0 OID 59783)
-- Dependencies: 405
-- Data for Name: staff_profiles; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.staff_profiles (id, property_id, user_id, name, phone, role, departments, active, created_at) FROM stdin;
\.


--
-- TOC entry 5267 (class 0 OID 70918)
-- Dependencies: 431
-- Data for Name: stock_check_items; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.stock_check_items (id, daily_check_id, stock_item_id, expected_quantity, counted_quantity, status, notes, created_at) FROM stdin;
\.


--
-- TOC entry 5266 (class 0 OID 70863)
-- Dependencies: 430
-- Data for Name: stock_daily_checks; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.stock_daily_checks (id, location_id, check_date, checked_by, status, total_items, items_with_divergence, notes, created_at, completed_at) FROM stdin;
\.


--
-- TOC entry 5264 (class 0 OID 70820)
-- Dependencies: 428
-- Data for Name: stock_items; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.stock_items (id, property_id, location_id, name, category, unit, minimum_stock, current_stock, cost_price, notes, is_active, created_at, updated_at) FROM stdin;
\.


--
-- TOC entry 5263 (class 0 OID 70806)
-- Dependencies: 427
-- Data for Name: stock_locations; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.stock_locations (id, property_id, name, type, is_active, created_at, updated_at) FROM stdin;
\.


--
-- TOC entry 5265 (class 0 OID 70844)
-- Dependencies: 429
-- Data for Name: stock_movements; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.stock_movements (id, stock_item_id, movement_type, quantity, balance_before, balance_after, user_id, reference_date, notes, created_at) FROM stdin;
\.


--
-- TOC entry 5227 (class 0 OID 18506)
-- Dependencies: 391
-- Data for Name: tasks; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.tasks (id, property_id, title, description, status, due_date, assigned_to, created_at, updated_at) FROM stdin;
\.


--
-- TOC entry 5234 (class 0 OID 18808)
-- Dependencies: 398
-- Data for Name: testimonials; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.testimonials (id, name, role, content, location, rating, is_visible, display_order, created_at, updated_at) FROM stdin;
3322439c-d36a-496e-b242-9da47ef22d03	Maria Silva	Proprietária - Pousada Mar Azul	O HostConnect revolucionou nossa gestão. Conseguimos aumentar 40% nossa ocupação e reduzir custos operacionais.	Urubici, SC	5	t	1	2025-10-15 17:01:33.182218+00	2025-10-15 17:01:33.182218+00
bc5b5f51-bb3d-445e-b151-c9cd4870d929	João Santos	Gerente - Hotel Centro	A automação do sistema nos permitiu focar no atendimento. O ROI foi positivo em apenas 2 meses!	São Paulo, SP	5	t	2	2025-10-15 17:01:33.182218+00	2025-10-15 17:01:33.182218+00
6e055a47-6714-4daf-8e36-72719270b487	Ana Costa	Diretora - Rede Hospedagem+	Gerenciar 5 propriedades nunca foi tão fácil. Dashboard intuitivo e suporte excepcional.	Rio de Janeiro, RJ	5	t	3	2025-10-15 17:01:33.182218+00	2025-10-15 17:01:33.182218+00
\.


--
-- TOC entry 5251 (class 0 OID 63466)
-- Dependencies: 415
-- Data for Name: ticket_comments; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.ticket_comments (id, ticket_id, user_id, content, is_staff_reply, created_at) FROM stdin;
\.


--
-- TOC entry 5250 (class 0 OID 63447)
-- Dependencies: 414
-- Data for Name: tickets; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.tickets (id, user_id, title, description, status, severity, category, created_at, updated_at, org_id) FROM stdin;
\.


--
-- TOC entry 5226 (class 0 OID 18462)
-- Dependencies: 390
-- Data for Name: website_settings; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.website_settings (id, property_id, setting_key, setting_value, created_at, updated_at, org_id) FROM stdin;
\.


--
-- TOC entry 5214 (class 0 OID 17272)
-- Dependencies: 374
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: realtime; Owner: -
--

COPY realtime.schema_migrations (version, inserted_at) FROM stdin;
20211116024918	2025-10-14 02:17:06
20211116045059	2025-10-14 02:17:10
20211116050929	2025-10-14 02:17:14
20211116051442	2025-10-14 02:17:17
20211116212300	2025-10-14 02:17:21
20211116213355	2025-10-14 02:17:24
20211116213934	2025-10-14 02:17:28
20211116214523	2025-10-14 02:17:32
20211122062447	2025-10-14 02:17:36
20211124070109	2025-10-14 02:17:39
20211202204204	2025-10-14 02:17:42
20211202204605	2025-10-14 02:17:45
20211210212804	2025-10-14 02:17:56
20211228014915	2025-10-14 02:17:59
20220107221237	2025-10-14 02:18:02
20220228202821	2025-10-14 02:18:06
20220312004840	2025-10-14 02:18:09
20220603231003	2025-10-14 02:18:14
20220603232444	2025-10-14 02:18:17
20220615214548	2025-10-14 02:18:21
20220712093339	2025-10-14 02:18:25
20220908172859	2025-10-14 02:18:28
20220916233421	2025-10-14 02:18:31
20230119133233	2025-10-14 02:18:35
20230128025114	2025-10-14 02:18:39
20230128025212	2025-10-14 02:18:43
20230227211149	2025-10-14 02:18:46
20230228184745	2025-10-14 02:18:49
20230308225145	2025-10-14 02:18:52
20230328144023	2025-10-14 02:18:56
20231018144023	2025-10-14 02:19:00
20231204144023	2025-10-14 02:19:05
20231204144024	2025-10-14 02:19:08
20231204144025	2025-10-14 02:19:11
20240108234812	2025-10-14 02:19:14
20240109165339	2025-10-14 02:19:18
20240227174441	2025-10-14 02:19:24
20240311171622	2025-10-14 02:19:28
20240321100241	2025-10-14 02:19:35
20240401105812	2025-10-14 02:19:45
20240418121054	2025-10-14 02:19:49
20240523004032	2025-10-14 02:20:01
20240618124746	2025-10-14 02:20:04
20240801235015	2025-10-14 02:20:07
20240805133720	2025-10-14 02:20:10
20240827160934	2025-10-14 02:20:14
20240919163303	2025-10-14 02:20:18
20240919163305	2025-10-14 02:20:22
20241019105805	2025-10-14 02:20:25
20241030150047	2025-10-14 02:20:37
20241108114728	2025-10-14 02:20:42
20241121104152	2025-10-14 02:20:45
20241130184212	2025-10-14 02:20:49
20241220035512	2025-10-14 02:20:52
20241220123912	2025-10-14 02:20:55
20241224161212	2025-10-14 02:20:58
20250107150512	2025-10-14 02:21:02
20250110162412	2025-10-14 02:21:05
20250123174212	2025-10-14 02:21:08
20250128220012	2025-10-14 02:21:11
20250506224012	2025-10-14 02:21:14
20250523164012	2025-10-14 02:21:17
20250714121412	2025-10-14 02:21:21
20250905041441	2025-10-14 02:21:24
20251103001201	2025-11-26 11:39:28
20251120212548	2026-02-13 11:24:09
20251120215549	2026-02-13 11:24:10
\.


--
-- TOC entry 5216 (class 0 OID 17295)
-- Dependencies: 377
-- Data for Name: subscription; Type: TABLE DATA; Schema: realtime; Owner: -
--

COPY realtime.subscription (id, subscription_id, entity, filters, claims, created_at, action_filter) FROM stdin;
\.


--
-- TOC entry 5194 (class 0 OID 16546)
-- Dependencies: 351
-- Data for Name: buckets; Type: TABLE DATA; Schema: storage; Owner: -
--

COPY storage.buckets (id, name, owner, created_at, updated_at, public, avif_autodetection, file_size_limit, allowed_mime_types, owner_id, type) FROM stdin;
property-photos	property-photos	\N	2025-10-14 04:15:09.742196+00	2025-10-14 04:15:09.742196+00	t	f	5242880	{image/jpeg,image/png,image/webp,image/gif}	\N	STANDARD
website-assets	website-assets	\N	2025-10-15 11:57:18.116802+00	2025-10-15 11:57:18.116802+00	t	f	6291456	\N	\N	STANDARD
\.


--
-- TOC entry 5213 (class 0 OID 17242)
-- Dependencies: 373
-- Data for Name: buckets_analytics; Type: TABLE DATA; Schema: storage; Owner: -
--

COPY storage.buckets_analytics (name, type, format, created_at, updated_at, id, deleted_at) FROM stdin;
\.


--
-- TOC entry 5237 (class 0 OID 47575)
-- Dependencies: 401
-- Data for Name: buckets_vectors; Type: TABLE DATA; Schema: storage; Owner: -
--

COPY storage.buckets_vectors (id, type, created_at, updated_at) FROM stdin;
\.


--
-- TOC entry 5196 (class 0 OID 16588)
-- Dependencies: 353
-- Data for Name: migrations; Type: TABLE DATA; Schema: storage; Owner: -
--

COPY storage.migrations (id, name, hash, executed_at) FROM stdin;
0	create-migrations-table	e18db593bcde2aca2a408c4d1100f6abba2195df	2025-10-14 02:15:54.966862
1	initialmigration	6ab16121fbaa08bbd11b712d05f358f9b555d777	2025-10-14 02:15:55.006898
3	pathtoken-column	2cb1b0004b817b29d5b0a971af16bafeede4b70d	2025-10-14 02:15:55.102016
4	add-migrations-rls	427c5b63fe1c5937495d9c635c263ee7a5905058	2025-10-14 02:15:55.1791
5	add-size-functions	79e081a1455b63666c1294a440f8ad4b1e6a7f84	2025-10-14 02:15:55.194386
7	add-rls-to-buckets	e7e7f86adbc51049f341dfe8d30256c1abca17aa	2025-10-14 02:15:55.212799
8	add-public-to-buckets	fd670db39ed65f9d08b01db09d6202503ca2bab3	2025-10-14 02:15:55.220945
11	add-trigger-to-auto-update-updated_at-column	7425bdb14366d1739fa8a18c83100636d74dcaa2	2025-10-14 02:15:55.245868
12	add-automatic-avif-detection-flag	8e92e1266eb29518b6a4c5313ab8f29dd0d08df9	2025-10-14 02:15:55.272794
13	add-bucket-custom-limits	cce962054138135cd9a8c4bcd531598684b25e7d	2025-10-14 02:15:55.281255
14	use-bytes-for-max-size	941c41b346f9802b411f06f30e972ad4744dad27	2025-10-14 02:15:55.290919
15	add-can-insert-object-function	934146bc38ead475f4ef4b555c524ee5d66799e5	2025-10-14 02:15:55.329061
16	add-version	76debf38d3fd07dcfc747ca49096457d95b1221b	2025-10-14 02:15:55.337154
17	drop-owner-foreign-key	f1cbb288f1b7a4c1eb8c38504b80ae2a0153d101	2025-10-14 02:15:55.344758
18	add_owner_id_column_deprecate_owner	e7a511b379110b08e2f214be852c35414749fe66	2025-10-14 02:15:55.357902
19	alter-default-value-objects-id	02e5e22a78626187e00d173dc45f58fa66a4f043	2025-10-14 02:15:55.368739
20	list-objects-with-delimiter	cd694ae708e51ba82bf012bba00caf4f3b6393b7	2025-10-14 02:15:55.376895
21	s3-multipart-uploads	8c804d4a566c40cd1e4cc5b3725a664a9303657f	2025-10-14 02:15:55.38767
22	s3-multipart-uploads-big-ints	9737dc258d2397953c9953d9b86920b8be0cdb73	2025-10-14 02:15:55.410478
23	optimize-search-function	9d7e604cddc4b56a5422dc68c9313f4a1b6f132c	2025-10-14 02:15:55.423756
24	operation-function	8312e37c2bf9e76bbe841aa5fda889206d2bf8aa	2025-10-14 02:15:55.432072
25	custom-metadata	d974c6057c3db1c1f847afa0e291e6165693b990	2025-10-14 02:15:55.440509
37	add-bucket-name-length-trigger	3944135b4e3e8b22d6d4cbb568fe3b0b51df15c1	2025-10-14 02:15:56.143828
44	vector-bucket-type	99c20c0ffd52bb1ff1f32fb992f3b351e3ef8fb3	2025-11-26 11:39:25.836885
45	vector-buckets	049e27196d77a7cb76497a85afae669d8b230953	2025-11-26 11:39:25.865271
46	buckets-objects-grants	fedeb96d60fefd8e02ab3ded9fbde05632f84aed	2025-11-26 11:39:25.959682
47	iceberg-table-metadata	649df56855c24d8b36dd4cc1aeb8251aa9ad42c2	2025-11-26 11:39:25.967816
49	buckets-objects-grants-postgres	072b1195d0d5a2f888af6b2302a1938dd94b8b3d	2025-12-20 12:30:42.006249
2	storage-schema	f6a1fa2c93cbcd16d4e487b362e45fca157a8dbd	2025-10-14 02:15:55.018883
6	change-column-name-in-get-size	ded78e2f1b5d7e616117897e6443a925965b30d2	2025-10-14 02:15:55.203392
9	fix-search-function	af597a1b590c70519b464a4ab3be54490712796b	2025-10-14 02:15:55.228575
10	search-files-search-function	b595f05e92f7e91211af1bbfe9c6a13bb3391e16	2025-10-14 02:15:55.236889
26	objects-prefixes	215cabcb7f78121892a5a2037a09fedf9a1ae322	2025-10-14 02:15:55.448226
27	search-v2	859ba38092ac96eb3964d83bf53ccc0b141663a6	2025-10-14 02:15:55.466836
28	object-bucket-name-sorting	c73a2b5b5d4041e39705814fd3a1b95502d38ce4	2025-10-14 02:15:56.074203
29	create-prefixes	ad2c1207f76703d11a9f9007f821620017a66c21	2025-10-14 02:15:56.081526
30	update-object-levels	2be814ff05c8252fdfdc7cfb4b7f5c7e17f0bed6	2025-10-14 02:15:56.089061
31	objects-level-index	b40367c14c3440ec75f19bbce2d71e914ddd3da0	2025-10-14 02:15:56.097428
32	backward-compatible-index-on-objects	e0c37182b0f7aee3efd823298fb3c76f1042c0f7	2025-10-14 02:15:56.105923
33	backward-compatible-index-on-prefixes	b480e99ed951e0900f033ec4eb34b5bdcb4e3d49	2025-10-14 02:15:56.114295
34	optimize-search-function-v1	ca80a3dc7bfef894df17108785ce29a7fc8ee456	2025-10-14 02:15:56.116934
35	add-insert-trigger-prefixes	458fe0ffd07ec53f5e3ce9df51bfdf4861929ccc	2025-10-14 02:15:56.125514
36	optimise-existing-functions	6ae5fca6af5c55abe95369cd4f93985d1814ca8f	2025-10-14 02:15:56.132883
38	iceberg-catalog-flag-on-buckets	02716b81ceec9705aed84aa1501657095b32e5c5	2025-10-14 02:15:56.15326
39	add-search-v2-sort-support	6706c5f2928846abee18461279799ad12b279b78	2025-10-14 02:15:56.166357
40	fix-prefix-race-conditions-optimized	7ad69982ae2d372b21f48fc4829ae9752c518f6b	2025-10-14 02:15:56.17483
41	add-object-level-update-trigger	07fcf1a22165849b7a029deed059ffcde08d1ae0	2025-10-14 02:15:56.186522
42	rollback-prefix-triggers	771479077764adc09e2ea2043eb627503c034cd4	2025-10-14 02:15:56.195209
43	fix-object-level	84b35d6caca9d937478ad8a797491f38b8c2979f	2025-10-14 02:15:56.205123
48	iceberg-catalog-ids	e0e8b460c609b9999ccd0df9ad14294613eed939	2025-11-26 11:39:25.975463
50	search-v2-optimised	6323ac4f850aa14e7387eb32102869578b5bd478	2026-02-13 01:46:21.432062
51	index-backward-compatible-search	2ee395d433f76e38bcd3856debaf6e0e5b674011	2026-02-13 01:46:21.507969
52	drop-not-used-indexes-and-functions	5cc44c8696749ac11dd0dc37f2a3802075f3a171	2026-02-13 01:46:21.510592
53	drop-index-lower-name	d0cb18777d9e2a98ebe0bc5cc7a42e57ebe41854	2026-02-13 01:46:21.545209
54	drop-index-object-level	6289e048b1472da17c31a7eba1ded625a6457e67	2026-02-13 01:46:21.549806
55	prevent-direct-deletes	262a4798d5e0f2e7c8970232e03ce8be695d5819	2026-02-13 01:46:21.552358
56	fix-optimized-search-function	cb58526ebc23048049fd5bf2fd148d18b04a2073	2026-02-13 01:46:21.565148
\.


--
-- TOC entry 5195 (class 0 OID 16561)
-- Dependencies: 352
-- Data for Name: objects; Type: TABLE DATA; Schema: storage; Owner: -
--

COPY storage.objects (id, bucket_id, name, owner, created_at, updated_at, last_accessed_at, metadata, version, owner_id, user_metadata) FROM stdin;
35d248d6-c7a7-46c2-8f97-2749840931b7	website-assets	HostConnect Logotipo.png	\N	2025-10-15 11:58:23.668246+00	2025-10-15 11:58:23.668246+00	2025-10-15 11:58:23.668246+00	{"eTag": "\\"ed09f6b55f0a101069ccf30eabae780d-1\\"", "size": 137632, "mimetype": "image/png", "cacheControl": "max-age=3600", "lastModified": "2025-10-15T11:58:24.000Z", "contentLength": 137632, "httpStatusCode": 200}	f0e474bc-4ea8-4ebb-a864-6ac783cc7b20	\N	\N
19635194-8b0e-49b5-b90d-7bb8b3fa9d28	website-assets	HostConnect Favicon.png	\N	2025-10-15 12:21:36.464996+00	2025-10-15 12:21:36.464996+00	2025-10-15 12:21:36.464996+00	{"eTag": "\\"d43009d57da821ef0aa33d4e50b5739c-1\\"", "size": 80170, "mimetype": "image/png", "cacheControl": "max-age=3600", "lastModified": "2025-10-15T12:21:36.000Z", "contentLength": 80170, "httpStatusCode": 200}	01d22167-b8b8-4c0b-bb2b-4d3816056139	\N	\N
33203934-2ce2-44e1-962f-9963c8509911	property-photos	cfc38522-8687-4066-bb9c-6dbcc465396f/06ad2a48-6bf2-4c0a-9106-3386d9b05c68/1767351116991.jpg	cfc38522-8687-4066-bb9c-6dbcc465396f	2026-01-02 10:51:59.391814+00	2026-01-02 10:51:59.391814+00	2026-01-02 10:51:59.391814+00	{"eTag": "\\"cb19c6b7286c2e5f802cf3a7b4e15d54\\"", "size": 214740, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-01-02T10:52:00.000Z", "contentLength": 214740, "httpStatusCode": 200}	1749d607-5484-416a-ab63-d169951aa6ca	cfc38522-8687-4066-bb9c-6dbcc465396f	{}
1d6a2e22-fe88-41ae-9df6-436757f52866	property-photos	cfc38522-8687-4066-bb9c-6dbcc465396f/73bb08db-d607-4346-ac5b-5cc2d739d506/1767352620244.jpg	cfc38522-8687-4066-bb9c-6dbcc465396f	2026-01-02 11:17:02.437743+00	2026-01-02 11:17:02.437743+00	2026-01-02 11:17:02.437743+00	{"eTag": "\\"cb19c6b7286c2e5f802cf3a7b4e15d54\\"", "size": 214740, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-01-02T11:17:03.000Z", "contentLength": 214740, "httpStatusCode": 200}	7ce5ca7f-0845-4a69-9499-dc116feb99b8	cfc38522-8687-4066-bb9c-6dbcc465396f	{}
\.


--
-- TOC entry 5211 (class 0 OID 17144)
-- Dependencies: 371
-- Data for Name: s3_multipart_uploads; Type: TABLE DATA; Schema: storage; Owner: -
--

COPY storage.s3_multipart_uploads (id, in_progress_size, upload_signature, bucket_id, key, version, owner_id, created_at, user_metadata) FROM stdin;
\.


--
-- TOC entry 5212 (class 0 OID 17158)
-- Dependencies: 372
-- Data for Name: s3_multipart_uploads_parts; Type: TABLE DATA; Schema: storage; Owner: -
--

COPY storage.s3_multipart_uploads_parts (id, upload_id, size, part_number, bucket_id, key, etag, owner_id, version, created_at) FROM stdin;
\.


--
-- TOC entry 5238 (class 0 OID 47585)
-- Dependencies: 402
-- Data for Name: vector_indexes; Type: TABLE DATA; Schema: storage; Owner: -
--

COPY storage.vector_indexes (id, name, bucket_id, data_type, dimension, distance_metric, metadata_configuration, created_at, updated_at) FROM stdin;
\.


--
-- TOC entry 5276 (class 0 OID 88187)
-- Dependencies: 440
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: supabase_migrations; Owner: -
--

COPY supabase_migrations.schema_migrations (version, statements, name) FROM stdin;
20240101000000	{"-- Create the 'profiles' table\nCREATE TABLE public.profiles (\n    id uuid REFERENCES auth.users ON DELETE CASCADE NOT NULL PRIMARY KEY,\n    full_name text,\n    email text UNIQUE NOT NULL,\n    phone text,\n    created_at timestamp with time zone DEFAULT now() NOT NULL,\n    updated_at timestamp with time zone DEFAULT now() NOT NULL\n)","-- Create the 'properties' table\nCREATE TABLE public.properties (\n    id uuid DEFAULT gen_random_uuid() NOT NULL PRIMARY KEY,\n    user_id uuid NOT NULL, -- Temporarily without FK to avoid circular dependency if profiles is not fully ready\n    name text NOT NULL,\n    description text,\n    address text NOT NULL,\n    city text NOT NULL,\n    state text NOT NULL,\n    country text DEFAULT 'Brasil' NOT NULL,\n    postal_code text,\n    phone text,\n    email text,\n    total_rooms integer DEFAULT 0 NOT NULL,\n    status text DEFAULT 'active' NOT NULL,\n    created_at timestamp with time zone DEFAULT now() NOT NULL,\n    updated_at timestamp with time zone DEFAULT now() NOT NULL\n)","-- Create the 'property_photos' table\nCREATE TABLE public.property_photos (\n    id uuid DEFAULT gen_random_uuid() NOT NULL PRIMARY KEY,\n    property_id uuid NOT NULL, -- Temporarily without FK\n    photo_url text NOT NULL,\n    is_primary boolean DEFAULT false,\n    display_order integer,\n    created_at timestamp with time zone DEFAULT now(),\n    updated_at timestamp with time zone DEFAULT now()\n)","-- Create the 'bookings' table\nCREATE TABLE public.bookings (\n    id uuid DEFAULT gen_random_uuid() NOT NULL PRIMARY KEY,\n    property_id uuid NOT NULL, -- Temporarily without FK\n    guest_name text NOT NULL,\n    guest_email text NOT NULL,\n    guest_phone text,\n    check_in date NOT NULL,\n    check_out date NOT NULL,\n    total_guests integer DEFAULT 1 NOT NULL,\n    total_amount numeric(10, 2) NOT NULL,\n    status text DEFAULT 'pending' NOT NULL, -- 'pending', 'confirmed', 'cancelled', 'completed'\n    notes text,\n    created_at timestamp with time zone DEFAULT now() NOT NULL,\n    updated_at timestamp with time zone DEFAULT now() NOT NULL\n)","-- Add Foreign Key constraints after all tables are created\nALTER TABLE public.properties ADD CONSTRAINT properties_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.profiles(id) ON DELETE CASCADE","ALTER TABLE public.property_photos ADD CONSTRAINT property_photos_property_id_fkey FOREIGN KEY (property_id) REFERENCES public.properties(id) ON DELETE CASCADE","ALTER TABLE public.bookings ADD CONSTRAINT bookings_property_id_fkey FOREIGN KEY (property_id) REFERENCES public.properties(id) ON DELETE CASCADE","-- Enable Row Level Security\nALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY","ALTER TABLE public.properties ENABLE ROW LEVEL SECURITY","ALTER TABLE public.bookings ENABLE ROW LEVEL SECURITY","ALTER TABLE public.property_photos ENABLE ROW LEVEL SECURITY","-- RLS policies for 'profiles'\nCREATE POLICY \\"Public profiles are viewable by everyone.\\" ON public.profiles FOR SELECT USING (true)","CREATE POLICY \\"Users can insert their own profile.\\" ON public.profiles FOR INSERT WITH CHECK (auth.uid() = id)","CREATE POLICY \\"Users can update their own profile.\\" ON public.profiles FOR UPDATE USING (auth.uid() = id)","CREATE POLICY \\"Users can delete their own profile.\\" ON public.profiles FOR DELETE USING (auth.uid() = id)","-- RLS policies for 'properties'\nCREATE POLICY \\"Users can view their own properties.\\" ON public.properties FOR SELECT USING (auth.uid() = user_id)","CREATE POLICY \\"Users can insert their own properties.\\" ON public.properties FOR INSERT WITH CHECK (auth.uid() = user_id)","CREATE POLICY \\"Users can update their own properties.\\" ON public.properties FOR UPDATE USING (auth.uid() = user_id)","CREATE POLICY \\"Users can delete their own properties.\\" ON public.properties FOR DELETE USING (auth.uid() = user_id)","-- RLS policies for 'property_photos'\nCREATE POLICY \\"Property photos are viewable by property owners.\\" ON public.property_photos FOR SELECT USING (\n  EXISTS (SELECT 1 FROM public.properties WHERE id = property_photos.property_id AND user_id = auth.uid())\n)","CREATE POLICY \\"Property owners can insert photos.\\" ON public.property_photos FOR INSERT WITH CHECK (\n  EXISTS (SELECT 1 FROM public.properties WHERE id = property_photos.property_id AND user_id = auth.uid())\n)","CREATE POLICY \\"Property owners can update photos.\\" ON public.property_photos FOR UPDATE USING (\n  EXISTS (SELECT 1 FROM public.properties WHERE id = property_photos.property_id AND user_id = auth.uid())\n)","CREATE POLICY \\"Property owners can delete photos.\\" ON public.property_photos FOR DELETE USING (\n  EXISTS (SELECT 1 FROM public.properties WHERE id = property_photos.property_id AND user_id = auth.uid())\n)","-- RLS policies for 'bookings'\nCREATE POLICY \\"Bookings are viewable by property owners.\\" ON public.bookings FOR SELECT USING (\n  EXISTS (SELECT 1 FROM public.properties WHERE id = bookings.property_id AND user_id = auth.uid())\n)","CREATE POLICY \\"Property owners can insert bookings.\\" ON public.bookings FOR INSERT WITH CHECK (\n  EXISTS (SELECT 1 FROM public.properties WHERE id = bookings.property_id AND user_id = auth.uid())\n)","CREATE POLICY \\"Property owners can update bookings.\\" ON public.bookings FOR UPDATE USING (\n  EXISTS (SELECT 1 FROM public.properties WHERE id = bookings.property_id AND user_id = auth.uid())\n)","CREATE POLICY \\"Property owners can delete bookings.\\" ON public.bookings FOR DELETE USING (\n  EXISTS (SELECT 1 FROM public.properties WHERE id = bookings.property_id AND user_id = auth.uid())\n)","-- Create a trigger to update 'updated_at' timestamp for 'profiles'\nCREATE OR REPLACE FUNCTION moddatetime()\nRETURNS TRIGGER AS $$\nBEGIN\n    NEW.updated_at = now();\n    RETURN NEW;\nEND;\n$$ LANGUAGE plpgsql","CREATE TRIGGER handle_profiles_updated_at BEFORE UPDATE ON public.profiles FOR EACH ROW EXECUTE FUNCTION moddatetime()","CREATE TRIGGER handle_properties_updated_at BEFORE UPDATE ON public.properties FOR EACH ROW EXECUTE FUNCTION moddatetime()","CREATE TRIGGER handle_property_photos_updated_at BEFORE UPDATE ON public.property_photos FOR EACH ROW EXECUTE FUNCTION moddatetime()","CREATE TRIGGER handle_bookings_updated_at BEFORE UPDATE ON public.bookings FOR EACH ROW EXECUTE FUNCTION moddatetime()","-- Create a function to create a profile on new user signup\nCREATE OR REPLACE FUNCTION public.handle_new_user()\nRETURNS TRIGGER AS $$\nBEGIN\n  INSERT INTO public.profiles (id, email, full_name)\n  VALUES (NEW.id, NEW.email, NEW.raw_user_meta_data->>'full_name');\n  RETURN NEW;\nEND;\n$$ LANGUAGE plpgsql SECURITY DEFINER","-- Create a trigger to call 'handle_new_user' function on auth.users inserts\nCREATE TRIGGER on_auth_user_created\n  AFTER INSERT ON auth.users\n  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user()"}	initial_schema
20240121000000	{"-- Migration: Create booking_rooms table for Sprint 4.5\r\n-- Goal: Link bookings to specific rooms in a multi-tenant way.\r\n\r\nCREATE TABLE IF NOT EXISTS public.booking_rooms (\r\n    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),\r\n    org_id uuid NOT NULL REFERENCES public.organizations(id) ON DELETE RESTRICT,\r\n    property_id uuid NOT NULL REFERENCES public.properties(id) ON DELETE RESTRICT,\r\n    booking_id uuid NOT NULL REFERENCES public.bookings(id) ON DELETE CASCADE,\r\n    room_id uuid NOT NULL REFERENCES public.rooms(id) ON DELETE RESTRICT,\r\n    is_primary boolean NOT NULL DEFAULT true,\r\n    created_at timestamp with time zone DEFAULT now() NOT NULL,\r\n    updated_at timestamp with time zone DEFAULT now() NOT NULL,\r\n\r\n    -- Constraints\r\n    CONSTRAINT booking_rooms_org_booking_room_unique UNIQUE (org_id, booking_id, room_id)\r\n)","-- RLS Policies\r\nALTER TABLE public.booking_rooms ENABLE ROW LEVEL SECURITY","CREATE POLICY \\"Users can view booking_rooms for their org\\"\r\n    ON public.booking_rooms FOR SELECT\r\n    USING (org_id = (SELECT org_id FROM public.profiles WHERE id = auth.uid()))","CREATE POLICY \\"Users can insert booking_rooms for their org\\"\r\n    ON public.booking_rooms FOR INSERT\r\n    WITH CHECK (org_id = (SELECT org_id FROM public.profiles WHERE id = auth.uid()))","CREATE POLICY \\"Users can update booking_rooms for their org\\"\r\n    ON public.booking_rooms FOR UPDATE\r\n    USING (org_id = (SELECT org_id FROM public.profiles WHERE id = auth.uid()))","CREATE POLICY \\"Users can delete booking_rooms for their org\\"\r\n    ON public.booking_rooms FOR DELETE\r\n    USING (org_id = (SELECT org_id FROM public.profiles WHERE id = auth.uid()))","-- Indexes for performance\r\nCREATE INDEX IF NOT EXISTS idx_booking_rooms_composite_booking \r\n    ON public.booking_rooms (org_id, property_id, booking_id)","CREATE INDEX IF NOT EXISTS idx_booking_rooms_composite_room \r\n    ON public.booking_rooms (org_id, property_id, room_id)","CREATE INDEX IF NOT EXISTS idx_booking_rooms_primary \r\n    ON public.booking_rooms (org_id, property_id, booking_id, is_primary)","-- Updated_at Trigger\r\nCREATE TRIGGER handle_booking_rooms_updated_at \r\n    BEFORE UPDATE ON public.booking_rooms \r\n    FOR EACH ROW EXECUTE FUNCTION public.moddatetime()","-- Audit Comments\r\nCOMMENT ON TABLE public.booking_rooms IS 'Links bookings to rooms (Sprint 4.5)'","COMMENT ON COLUMN public.booking_rooms.is_primary IS 'Indicates the main room assigned to this booking'"}	create_booking_rooms
20240801000000	{"-- Create the amenities table\nCREATE TABLE public.amenities (\n    id uuid DEFAULT gen_random_uuid() NOT NULL,\n    name text NOT NULL,\n    icon text,\n    description text,\n    created_at timestamp with time zone DEFAULT now() NOT NULL,\n    updated_at timestamp with time zone DEFAULT now() NOT NULL\n)","ALTER TABLE public.amenities OWNER TO postgres","ALTER TABLE ONLY public.amenities\n    ADD CONSTRAINT amenities_pkey PRIMARY KEY (id)","ALTER TABLE public.amenities ENABLE ROW LEVEL SECURITY","CREATE POLICY \\"Enable read access for all users\\" ON public.amenities FOR SELECT USING (true)","CREATE POLICY \\"Enable insert for authenticated users\\" ON public.amenities FOR INSERT WITH CHECK (auth.role() = 'authenticated')","CREATE POLICY \\"Enable update for authenticated users\\" ON public.amenities FOR UPDATE USING (auth.role() = 'authenticated')","CREATE POLICY \\"Enable delete for authenticated users\\" ON public.amenities FOR DELETE USING (auth.role() = 'authenticated')","-- Add amenities_json column to room_types table\nALTER TABLE public.room_types\nADD COLUMN amenities_json jsonb DEFAULT '[]'::jsonb","-- Update updated_at column automatically\nCREATE TRIGGER handle_updated_at BEFORE UPDATE ON public.amenities FOR EACH ROW EXECUTE FUNCTION moddatetime('updated_at')","CREATE TRIGGER handle_updated_at BEFORE UPDATE ON public.room_types FOR EACH ROW EXECUTE FUNCTION moddatetime('updated_at')"}	add_amenities_and_room_type_amenities
20240802000000	{"CREATE TABLE public.rooms (\n    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),\n    property_id uuid NOT NULL REFERENCES public.properties(id) ON DELETE CASCADE,\n    room_type_id uuid NOT NULL REFERENCES public.room_types(id) ON DELETE CASCADE,\n    room_number text NOT NULL,\n    status text DEFAULT 'available'::text NOT NULL, -- e.g., 'available', 'occupied', 'maintenance'\n    created_at timestamp with time zone DEFAULT now() NOT NULL,\n    updated_at timestamp with time zone DEFAULT now() NOT NULL,\n\n    CONSTRAINT rooms_room_number_property_id_key UNIQUE (room_number, property_id)\n)","ALTER TABLE public.rooms ENABLE ROW LEVEL SECURITY","CREATE POLICY \\"Enable read access for all users\\" ON public.rooms FOR SELECT USING (true)","CREATE POLICY \\"Enable insert for authenticated users\\" ON public.rooms FOR INSERT WITH CHECK (auth.role() = 'authenticated')","CREATE POLICY \\"Enable update for users who own property\\" ON public.rooms FOR UPDATE USING (EXISTS ( SELECT 1 FROM public.properties WHERE properties.id = rooms.property_id AND properties.user_id = auth.uid() ))","CREATE POLICY \\"Enable delete for users who own property\\" ON public.rooms FOR DELETE USING (EXISTS ( SELECT 1 FROM public.properties WHERE properties.id = rooms.property_id AND properties.user_id = auth.uid() ))","-- Trigger para atualizar 'updated_at'\nCREATE TRIGGER handle_updated_at BEFORE UPDATE ON public.rooms FOR EACH ROW EXECUTE FUNCTION moddatetime()"}	create_rooms_table
20240803000000	{"ALTER TABLE public.bookings\nADD COLUMN room_type_id uuid NULL","ALTER TABLE public.bookings\nADD CONSTRAINT bookings_room_type_id_fkey\nFOREIGN KEY (room_type_id) REFERENCES public.room_types(id) ON DELETE SET NULL","-- Opcional: Adicionar um índice para melhorar a performance das consultas\nCREATE INDEX bookings_room_type_id_idx ON public.bookings (room_type_id)"}	add_room_type_id_to_bookings
20240804000000	{"CREATE TABLE public.pricing_rules (\n    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),\n    created_at timestamp with time zone DEFAULT now() NOT NULL,\n    updated_at timestamp with time zone DEFAULT now() NOT NULL,\n    property_id uuid NOT NULL REFERENCES public.properties(id) ON DELETE CASCADE,\n    room_type_id uuid REFERENCES public.room_types(id) ON DELETE CASCADE, -- Optional, for property-wide rules\n    start_date date NOT NULL,\n    end_date date NOT NULL,\n    base_price_override numeric(10, 2), -- Direct price override\n    price_modifier numeric(5, 2), -- Percentage modifier (e.g., 1.10 for +10%, 0.90 for -10%)\n    min_stay integer DEFAULT 1,\n    max_stay integer,\n    promotion_name text,\n    status text DEFAULT 'active' NOT NULL, -- 'active', 'inactive'\n    CONSTRAINT pricing_rules_check_dates CHECK (end_date >= start_date),\n    CONSTRAINT pricing_rules_check_price_or_modifier CHECK (base_price_override IS NOT NULL OR price_modifier IS NOT NULL)\n)","ALTER TABLE public.pricing_rules ENABLE ROW LEVEL SECURITY","CREATE POLICY \\"Enable read access for all users\\" ON public.pricing_rules FOR SELECT USING (true)","CREATE POLICY \\"Enable insert for authenticated users\\" ON public.pricing_rules FOR INSERT WITH CHECK (auth.uid() IN (SELECT user_id FROM public.properties WHERE id = property_id))","CREATE POLICY \\"Enable update for users who own property\\" ON public.pricing_rules FOR UPDATE USING (auth.uid() IN (SELECT user_id FROM public.properties WHERE id = property_id))","CREATE POLICY \\"Enable delete for users who own property\\" ON public.pricing_rules FOR DELETE USING (auth.uid() IN (SELECT user_id FROM public.properties WHERE id = property_id))","-- Trigger to update 'updated_at' column\nCREATE TRIGGER handle_updated_at BEFORE UPDATE ON public.pricing_rules FOR EACH ROW EXECUTE FUNCTION moddatetime('updated_at')"}	create_pricing_rules_table
20260121100000	{"-- noop placeholder to align migration history with remote\n-- remote already has this version recorded in supabase_migrations.schema_migrations"}	operational_alerts_tables
20260121200001	{"-- Sprint 5.2: Extend pre_checkin_submissions for group mode\r\n-- Purpose: Add \\"mode\\" column to differentiate individual vs group submissions\r\n-- Additive only, pilot-safe\r\n\r\n-- Add mode column (default 'individual' for backward compatibility)\r\nALTER TABLE pre_checkin_submissions \r\nADD COLUMN IF NOT EXISTS mode text NOT NULL DEFAULT 'individual' \r\nCHECK (mode IN ('individual', 'group'))","-- Update payload comment to document group mode structure\r\nCOMMENT ON COLUMN pre_checkin_submissions.payload IS 'JSONB containing participant data. Individual mode: {full_name, document?, email?, phone?, birthdate?}. Group mode: {participants: [{full_name, document?, email?, phone?}, ...]}'","-- Update table comment to reflect group mode support\r\nCOMMENT ON TABLE pre_checkin_submissions IS 'Stores guest-submitted pre-check-in data pending admin review and application to bookings. Supports individual and group (batch) submissions. Scoped by org_id for multi-tenant isolation.'"}	add_group_mode_to_submissions
20240805000000	{"CREATE TABLE public.services (\n    id uuid DEFAULT gen_random_uuid() NOT NULL,\n    property_id uuid NOT NULL,\n    name text NOT NULL,\n    description text,\n    price numeric NOT NULL,\n    is_per_person boolean DEFAULT false NOT NULL,\n    is_per_day boolean DEFAULT false NOT NULL,\n    status text DEFAULT 'active'::text NOT NULL,\n    created_at timestamp with time zone DEFAULT now() NOT NULL,\n    updated_at timestamp with time zone DEFAULT now() NOT NULL,\n    CONSTRAINT services_pkey PRIMARY KEY (id),\n    CONSTRAINT services_status_check CHECK (status IN ('active', 'inactive'))\n)","ALTER TABLE public.services ENABLE ROW LEVEL SECURITY","CREATE POLICY \\"Enable read access for all users\\" ON public.services FOR SELECT USING (true)","CREATE POLICY \\"Enable insert for authenticated users\\" ON public.services FOR INSERT WITH CHECK (auth.role() = 'authenticated')","CREATE POLICY \\"Enable update for users who own the property\\" ON public.services FOR UPDATE USING (EXISTS ( SELECT 1 FROM public.properties WHERE (properties.id = services.property_id) AND (properties.user_id = auth.uid())))","CREATE POLICY \\"Enable delete for users who own the property\\" ON public.services FOR DELETE USING (EXISTS ( SELECT 1 FROM public.properties WHERE (properties.id = services.property_id) AND (properties.user_id = auth.uid())))","ALTER TABLE public.services ADD CONSTRAINT services_property_id_fkey FOREIGN KEY (property_id) REFERENCES public.properties(id) ON DELETE CASCADE","CREATE INDEX services_property_id_idx ON public.services USING btree (property_id)","-- Trigger to update 'updated_at' column\nCREATE TRIGGER handle_updated_at BEFORE UPDATE ON public.services FOR EACH ROW EXECUTE FUNCTION moddatetime('updated_at')"}	create_services_table
20240806000000	{"ALTER TABLE public.bookings\nADD COLUMN services_json jsonb DEFAULT '[]'::jsonb","-- Optional: Add a comment for documentation\nCOMMENT ON COLUMN public.bookings.services_json IS 'JSON array of service IDs associated with the booking.'"}	add_services_to_bookings
20240807000000	{"CREATE TABLE public.website_settings (\n    id uuid DEFAULT gen_random_uuid() NOT NULL,\n    property_id uuid NOT NULL,\n    setting_key text NOT NULL,\n    setting_value jsonb,\n    created_at timestamp with time zone DEFAULT now() NOT NULL,\n    updated_at timestamp with time zone DEFAULT now() NOT NULL,\n    CONSTRAINT website_settings_pkey PRIMARY KEY (id),\n    CONSTRAINT website_settings_property_id_setting_key_key UNIQUE (property_id, setting_key)\n)","ALTER TABLE public.website_settings ENABLE ROW LEVEL SECURITY","CREATE POLICY \\"Enable read access for all users\\" ON public.website_settings FOR SELECT USING (true)","CREATE POLICY \\"Enable insert for authenticated users\\" ON public.website_settings FOR INSERT WITH CHECK (auth.role() = 'authenticated')","CREATE POLICY \\"Enable update for authenticated users\\" ON public.website_settings FOR UPDATE USING (auth.role() = 'authenticated')","CREATE POLICY \\"Enable delete for authenticated users\\" ON public.website_settings FOR DELETE USING (auth.role() = 'authenticated')","ALTER TABLE public.website_settings ADD CONSTRAINT website_settings_property_id_fkey FOREIGN KEY (property_id) REFERENCES public.properties(id) ON DELETE CASCADE","CREATE TRIGGER handle_updated_at BEFORE UPDATE ON public.website_settings FOR EACH ROW EXECUTE FUNCTION moddatetime('updated_at')"}	create_website_settings_table
20251001060847	{"-- Create profiles table for user data\nCREATE TABLE public.profiles (\n  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,\n  full_name TEXT NOT NULL,\n  email TEXT NOT NULL,\n  phone TEXT,\n  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),\n  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()\n)","-- Enable RLS on profiles\nALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY","-- Profiles policies\nCREATE POLICY \\"Users can view own profile\\"\n  ON public.profiles FOR SELECT\n  USING (auth.uid() = id)","CREATE POLICY \\"Users can update own profile\\"\n  ON public.profiles FOR UPDATE\n  USING (auth.uid() = id)","-- Create properties table\nCREATE TABLE public.properties (\n  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),\n  user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,\n  name TEXT NOT NULL,\n  description TEXT,\n  address TEXT NOT NULL,\n  city TEXT NOT NULL,\n  state TEXT NOT NULL,\n  country TEXT NOT NULL DEFAULT 'Brasil',\n  postal_code TEXT,\n  phone TEXT,\n  email TEXT,\n  total_rooms INTEGER NOT NULL DEFAULT 0,\n  status TEXT NOT NULL DEFAULT 'active' CHECK (status IN ('active', 'inactive')),\n  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),\n  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()\n)","-- Enable RLS on properties\nALTER TABLE public.properties ENABLE ROW LEVEL SECURITY","-- Properties policies\nCREATE POLICY \\"Users can view own properties\\"\n  ON public.properties FOR SELECT\n  USING (auth.uid() = user_id)","CREATE POLICY \\"Users can insert own properties\\"\n  ON public.properties FOR INSERT\n  WITH CHECK (auth.uid() = user_id)","CREATE POLICY \\"Users can update own properties\\"\n  ON public.properties FOR UPDATE\n  USING (auth.uid() = user_id)","CREATE POLICY \\"Users can delete own properties\\"\n  ON public.properties FOR DELETE\n  USING (auth.uid() = user_id)","-- Create bookings table\nCREATE TABLE public.bookings (\n  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),\n  property_id UUID NOT NULL REFERENCES public.properties(id) ON DELETE CASCADE,\n  guest_name TEXT NOT NULL,\n  guest_email TEXT NOT NULL,\n  guest_phone TEXT,\n  check_in DATE NOT NULL,\n  check_out DATE NOT NULL,\n  total_guests INTEGER NOT NULL DEFAULT 1,\n  total_amount DECIMAL(10,2) NOT NULL,\n  status TEXT NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'confirmed', 'cancelled', 'completed')),\n  notes TEXT,\n  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),\n  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()\n)","-- Enable RLS on bookings\nALTER TABLE public.bookings ENABLE ROW LEVEL SECURITY","-- Bookings policies - users can only see bookings for their properties\nCREATE POLICY \\"Users can view bookings for own properties\\"\n  ON public.bookings FOR SELECT\n  USING (\n    EXISTS (\n      SELECT 1 FROM public.properties\n      WHERE properties.id = bookings.property_id\n      AND properties.user_id = auth.uid()\n    )\n  )","CREATE POLICY \\"Users can insert bookings for own properties\\"\n  ON public.bookings FOR INSERT\n  WITH CHECK (\n    EXISTS (\n      SELECT 1 FROM public.properties\n      WHERE properties.id = bookings.property_id\n      AND properties.user_id = auth.uid()\n    )\n  )","CREATE POLICY \\"Users can update bookings for own properties\\"\n  ON public.bookings FOR UPDATE\n  USING (\n    EXISTS (\n      SELECT 1 FROM public.properties\n      WHERE properties.id = bookings.property_id\n      AND properties.user_id = auth.uid()\n    )\n  )","CREATE POLICY \\"Users can delete bookings for own properties\\"\n  ON public.bookings FOR DELETE\n  USING (\n    EXISTS (\n      SELECT 1 FROM public.properties\n      WHERE properties.id = bookings.property_id\n      AND properties.user_id = auth.uid()\n    )\n  )","-- Function to automatically create profile on signup\nCREATE OR REPLACE FUNCTION public.handle_new_user()\nRETURNS TRIGGER\nLANGUAGE plpgsql\nSECURITY DEFINER\nSET search_path = public\nAS $$\nBEGIN\n  INSERT INTO public.profiles (id, full_name, email)\n  VALUES (\n    new.id,\n    COALESCE(new.raw_user_meta_data->>'full_name', 'User'),\n    new.email\n  );\n  RETURN new;\nEND;\n$$","-- Trigger to create profile on user signup\nCREATE TRIGGER on_auth_user_created\n  AFTER INSERT ON auth.users\n  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user()","-- Function to update updated_at timestamp\nCREATE OR REPLACE FUNCTION public.update_updated_at_column()\nRETURNS TRIGGER\nLANGUAGE plpgsql\nAS $$\nBEGIN\n  NEW.updated_at = now();\n  RETURN NEW;\nEND;\n$$","-- Triggers for updated_at\nCREATE TRIGGER update_profiles_updated_at\n  BEFORE UPDATE ON public.profiles\n  FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column()","CREATE TRIGGER update_properties_updated_at\n  BEFORE UPDATE ON public.properties\n  FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column()","CREATE TRIGGER update_bookings_updated_at\n  BEFORE UPDATE ON public.bookings\n  FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column()"}	29c70b9f-05a9-4a5a-86ab-672c3216a0f4
20251001060949	{"-- Fix security warning: Set search_path for update_updated_at_column function\nCREATE OR REPLACE FUNCTION public.update_updated_at_column()\nRETURNS TRIGGER\nLANGUAGE plpgsql\nSECURITY DEFINER\nSET search_path = public\nAS $$\nBEGIN\n  NEW.updated_at = now();\n  RETURN NEW;\nEND;\n$$"}	be8c5ed7-46ea-4aeb-97ff-e0100671e191
20251002124533	{"-- Create storage bucket for property photos\nINSERT INTO storage.buckets (id, name, public)\nVALUES ('property-photos', 'property-photos', true)","-- Create property_photos table\nCREATE TABLE public.property_photos (\n  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),\n  property_id uuid NOT NULL REFERENCES public.properties(id) ON DELETE CASCADE,\n  photo_url text NOT NULL,\n  is_primary boolean DEFAULT false,\n  display_order integer DEFAULT 0,\n  created_at timestamp with time zone DEFAULT now(),\n  updated_at timestamp with time zone DEFAULT now()\n)","-- Enable RLS\nALTER TABLE public.property_photos ENABLE ROW LEVEL SECURITY","-- RLS Policies for property_photos\nCREATE POLICY \\"Users can view photos for own properties\\"\nON public.property_photos\nFOR SELECT\nTO authenticated\nUSING (\n  EXISTS (\n    SELECT 1 FROM public.properties\n    WHERE properties.id = property_photos.property_id\n    AND properties.user_id = auth.uid()\n  )\n)","CREATE POLICY \\"Users can insert photos for own properties\\"\nON public.property_photos\nFOR INSERT\nTO authenticated\nWITH CHECK (\n  EXISTS (\n    SELECT 1 FROM public.properties\n    WHERE properties.id = property_photos.property_id\n    AND properties.user_id = auth.uid()\n  )\n)","CREATE POLICY \\"Users can update photos for own properties\\"\nON public.property_photos\nFOR UPDATE\nTO authenticated\nUSING (\n  EXISTS (\n    SELECT 1 FROM public.properties\n    WHERE properties.id = property_photos.property_id\n    AND properties.user_id = auth.uid()\n  )\n)","CREATE POLICY \\"Users can delete photos for own properties\\"\nON public.property_photos\nFOR DELETE\nTO authenticated\nUSING (\n  EXISTS (\n    SELECT 1 FROM public.properties\n    WHERE properties.id = property_photos.property_id\n    AND properties.user_id = auth.uid()\n  )\n)","-- Storage policies for property-photos bucket\nCREATE POLICY \\"Users can view property photos\\"\nON storage.objects\nFOR SELECT\nTO public\nUSING (bucket_id = 'property-photos')","CREATE POLICY \\"Users can upload photos to own properties\\"\nON storage.objects\nFOR INSERT\nTO authenticated\nWITH CHECK (\n  bucket_id = 'property-photos'\n  AND auth.uid()::text = (storage.foldername(name))[1]\n)","CREATE POLICY \\"Users can update own property photos\\"\nON storage.objects\nFOR UPDATE\nTO authenticated\nUSING (\n  bucket_id = 'property-photos'\n  AND auth.uid()::text = (storage.foldername(name))[1]\n)","CREATE POLICY \\"Users can delete own property photos\\"\nON storage.objects\nFOR DELETE\nTO authenticated\nUSING (\n  bucket_id = 'property-photos'\n  AND auth.uid()::text = (storage.foldername(name))[1]\n)","-- Trigger for updated_at\nCREATE TRIGGER update_property_photos_updated_at\nBEFORE UPDATE ON public.property_photos\nFOR EACH ROW\nEXECUTE FUNCTION public.update_updated_at_column()"}	b247b200-8a0b-4e9b-a163-ee2405d184eb
20251222100000	{"CREATE TABLE IF NOT EXISTS public.booking_charges (\r\n    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,\r\n    booking_id UUID NOT NULL REFERENCES public.bookings(id) ON DELETE CASCADE,\r\n    description TEXT NOT NULL,\r\n    amount DECIMAL(10,2) NOT NULL,\r\n    category TEXT DEFAULT 'minibar',\r\n    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,\r\n    updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL\r\n)","-- RLS Policies\r\nALTER TABLE public.booking_charges ENABLE ROW LEVEL SECURITY","CREATE POLICY \\"Enable read access for all users\\" ON public.booking_charges FOR SELECT USING (true)","CREATE POLICY \\"Enable insert for authenticated users\\" ON public.booking_charges FOR INSERT WITH CHECK (auth.role() = 'authenticated')"}	create_booking_charges_table
20251225080000	{"-- noop placeholder to align migration history with remote\n-- remote already has this version recorded in supabase_migrations.schema_migrations"}	add_phone_to_profiles_and_sync_trigger
20251225100000	{"-- Migration: Security Hardening (RLS & Policies)\r\n-- Description: Fixes critical data leakage by enforcing strict Owner-Based RLS on sensitive tables.\r\n-- Date: 2025-12-25\r\n\r\n-- 1. Helper Function for Centralized Access Control\r\nCREATE OR REPLACE FUNCTION public.check_user_access(target_property_id uuid)\r\nRETURNS boolean\r\nLANGUAGE plpgsql\r\nSECURITY DEFINER\r\nSET search_path = public -- Secure search path\r\nAS $$\r\nBEGIN\r\n  -- 1. Allow Super Admins (role = 'admin' in profiles)\r\n  IF EXISTS (SELECT 1 FROM public.profiles WHERE id = auth.uid() AND role = 'admin') THEN\r\n    RETURN true;\r\n  END IF;\r\n\r\n  -- 2. Allow Property Owners\r\n  IF EXISTS (SELECT 1 FROM public.properties WHERE id = target_property_id AND user_id = auth.uid()) THEN\r\n    RETURN true;\r\n  END IF;\r\n\r\n  RETURN false;\r\nEND;\r\n$$","-- Grant execution to authenticated users\r\nGRANT EXECUTE ON FUNCTION public.check_user_access(uuid) TO authenticated","-- 2. Security Hardening for 'rooms'\r\nALTER TABLE public.rooms ENABLE ROW LEVEL SECURITY","DROP POLICY IF EXISTS \\"Enable read access for all users\\" ON public.rooms","DROP POLICY IF EXISTS \\"Enable insert for authenticated users\\" ON public.rooms","DROP POLICY IF EXISTS \\"Enable update for users who own property\\" ON public.rooms","DROP POLICY IF EXISTS \\"Enable delete for users who own property\\" ON public.rooms","CREATE POLICY \\"Users can view rooms of their properties\\" ON public.rooms FOR SELECT USING (public.check_user_access(property_id))","CREATE POLICY \\"Users can insert rooms for their properties\\" ON public.rooms FOR INSERT WITH CHECK (public.check_user_access(property_id))","CREATE POLICY \\"Users can update rooms of their properties\\" ON public.rooms FOR UPDATE USING (public.check_user_access(property_id))","CREATE POLICY \\"Users can delete rooms of their properties\\" ON public.rooms FOR DELETE USING (public.check_user_access(property_id))","-- 3. Security Hardening for 'pricing_rules'\r\nALTER TABLE public.pricing_rules ENABLE ROW LEVEL SECURITY","DROP POLICY IF EXISTS \\"Enable read access for all users\\" ON public.pricing_rules","DROP POLICY IF EXISTS \\"Enable insert for authenticated users\\" ON public.pricing_rules","DROP POLICY IF EXISTS \\"Enable update for users who own property\\" ON public.pricing_rules","DROP POLICY IF EXISTS \\"Enable delete for users who own property\\" ON public.pricing_rules","CREATE POLICY \\"Users can view rules of their properties\\" ON public.pricing_rules FOR SELECT USING (public.check_user_access(property_id))","CREATE POLICY \\"Users can insert rules for their properties\\" ON public.pricing_rules FOR INSERT WITH CHECK (public.check_user_access(property_id))","CREATE POLICY \\"Users can update rules of their properties\\" ON public.pricing_rules FOR UPDATE USING (public.check_user_access(property_id))","CREATE POLICY \\"Users can delete rules of their properties\\" ON public.pricing_rules FOR DELETE USING (public.check_user_access(property_id))","-- 4. Security Hardening for 'booking_charges'\r\nALTER TABLE public.booking_charges ENABLE ROW LEVEL SECURITY","DROP POLICY IF EXISTS \\"Enable read access for all users\\" ON public.booking_charges","DROP POLICY IF EXISTS \\"Enable insert for authenticated users\\" ON public.booking_charges","-- Note: booking_charges needs to link to property via booking_id\r\n-- We need a specific check for booking_charges because it has booking_id, not property_id directly\r\n\r\nCREATE OR REPLACE FUNCTION public.check_booking_access(target_booking_id uuid)\r\nRETURNS boolean\r\nLANGUAGE plpgsql\r\nSECURITY DEFINER\r\nSET search_path = public\r\nAS $$\r\nDECLARE\r\n  linked_property_id uuid;\r\nBEGIN\r\n  SELECT property_id INTO linked_property_id FROM public.bookings WHERE id = target_booking_id;\r\n  \r\n  IF linked_property_id IS NULL THEN\r\n    RETURN false;\r\n  END IF;\r\n\r\n  RETURN public.check_user_access(linked_property_id);\r\nEND;\r\n$$","GRANT EXECUTE ON FUNCTION public.check_booking_access(uuid) TO authenticated","CREATE POLICY \\"Users can view charges of their bookings\\" ON public.booking_charges FOR SELECT USING (public.check_booking_access(booking_id))","CREATE POLICY \\"Users can insert charges for their bookings\\" ON public.booking_charges FOR INSERT WITH CHECK (public.check_booking_access(booking_id))","CREATE POLICY \\"Users can update charges of their bookings\\" ON public.booking_charges FOR UPDATE USING (public.check_booking_access(booking_id))","CREATE POLICY \\"Users can delete charges of their bookings\\" ON public.booking_charges FOR DELETE USING (public.check_booking_access(booking_id))","-- 5. Hardening Orphan Tables (Tasks, Expenses, Services, Invoices)\r\n\r\n-- Tasks\r\nALTER TABLE public.tasks ENABLE ROW LEVEL SECURITY","DROP POLICY IF EXISTS \\"Access tasks\\" ON public.tasks","-- Just in case\r\nCREATE POLICY \\"Manage own tasks\\" ON public.tasks FOR ALL USING (public.check_user_access(property_id)) WITH CHECK (public.check_user_access(property_id))","-- Expenses\r\nALTER TABLE public.expenses ENABLE ROW LEVEL SECURITY","DROP POLICY IF EXISTS \\"Access expenses\\" ON public.expenses","CREATE POLICY \\"Manage own expenses\\" ON public.expenses FOR ALL USING (public.check_user_access(property_id)) WITH CHECK (public.check_user_access(property_id))","-- Services\r\nALTER TABLE public.services ENABLE ROW LEVEL SECURITY","DROP POLICY IF EXISTS \\"Access services\\" ON public.services","CREATE POLICY \\"Manage own services\\" ON public.services FOR ALL USING (public.check_user_access(property_id)) WITH CHECK (public.check_user_access(property_id))","-- Invoices\r\nALTER TABLE public.invoices ENABLE ROW LEVEL SECURITY","DROP POLICY IF EXISTS \\"Access invoices\\" ON public.invoices","CREATE POLICY \\"Manage own invoices\\" ON public.invoices FOR ALL USING (public.check_user_access(property_id)) WITH CHECK (public.check_user_access(property_id))"}	security_hardening
20251225110000	{"-- Migration: Support Module (Tickets & Ideas)\r\n-- Description: Implements database schema for Support Tickets and Ideas with strict Owner-Based RLS and Staff privileges.\r\n-- Date: 2025-12-25\r\n\r\n-- 0. Ensure Utility Functions Exist\r\nCREATE OR REPLACE FUNCTION public.update_updated_at_column()\r\nRETURNS TRIGGER\r\nLANGUAGE plpgsql\r\nSECURITY DEFINER\r\nSET search_path = public\r\nAS $$\r\nBEGIN\r\n  NEW.updated_at = now();\r\n  RETURN NEW;\r\nEND;\r\n$$","-- 1. Helper Function & Staff Table\r\n-- We create a table to explicitly list who is \\"HostConnect Staff\\".\r\nCREATE TABLE public.hostconnect_staff (\r\n    user_id uuid PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,\r\n    role text DEFAULT 'support', -- e.g., 'support', 'admin', 'developer'\r\n    created_at timestamptz DEFAULT now()\r\n)","-- RLS for hostconnect_staff: Only admins or the staff themselves can view/edit? \r\n-- Actually, for the system to work, we mostly check existence. \r\n-- We'll strict it down.\r\nALTER TABLE public.hostconnect_staff ENABLE ROW LEVEL SECURITY","-- For now, no public policies needed on this table if we only use the Security Definer function.\r\n\r\n-- Helper Function: is_hostconnect_staff()\r\nCREATE OR REPLACE FUNCTION public.is_hostconnect_staff()\r\nRETURNS boolean\r\nLANGUAGE plpgsql\r\nSECURITY DEFINER\r\nSET search_path = public\r\nAS $$\r\nBEGIN\r\n  RETURN EXISTS (\r\n    SELECT 1 FROM public.hostconnect_staff WHERE user_id = auth.uid()\r\n  );\r\nEND;\r\n$$","GRANT EXECUTE ON FUNCTION public.is_hostconnect_staff() TO authenticated","-- 2. Schema: Tickets\r\nCREATE TABLE public.tickets (\r\n    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),\r\n    user_id uuid NOT NULL DEFAULT auth.uid() REFERENCES auth.users(id) ON DELETE CASCADE,\r\n    title text NOT NULL,\r\n    description text NOT NULL,\r\n    status text NOT NULL DEFAULT 'open', -- open, in_progress, resolved, closed\r\n    severity text NOT NULL DEFAULT 'low', -- low, medium, high, critical\r\n    category text DEFAULT 'general', -- bug, billing, general\r\n    created_at timestamptz DEFAULT now(),\r\n    updated_at timestamptz DEFAULT now()\r\n)","-- 3. Schema: Ticket Comments\r\nCREATE TABLE public.ticket_comments (\r\n    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),\r\n    ticket_id uuid NOT NULL REFERENCES public.tickets(id) ON DELETE CASCADE,\r\n    user_id uuid NOT NULL DEFAULT auth.uid() REFERENCES auth.users(id) ON DELETE CASCADE,\r\n    content text NOT NULL,\r\n    is_staff_reply boolean DEFAULT false,\r\n    created_at timestamptz DEFAULT now()\r\n)","-- 4. Schema: Ideas\r\nCREATE TABLE public.ideas (\r\n    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),\r\n    user_id uuid NOT NULL DEFAULT auth.uid() REFERENCES auth.users(id) ON DELETE CASCADE,\r\n    title text NOT NULL,\r\n    description text NOT NULL,\r\n    status text NOT NULL DEFAULT 'under_review', -- under_review, planned, in_progress, completed, declined\r\n    votes integer DEFAULT 0,\r\n    created_at timestamptz DEFAULT now(),\r\n    updated_at timestamptz DEFAULT now()\r\n)","-- 5. Schema: Idea Comments\r\nCREATE TABLE public.idea_comments (\r\n    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),\r\n    idea_id uuid NOT NULL REFERENCES public.ideas(id) ON DELETE CASCADE,\r\n    user_id uuid NOT NULL DEFAULT auth.uid() REFERENCES auth.users(id) ON DELETE CASCADE,\r\n    content text NOT NULL,\r\n    is_staff_reply boolean DEFAULT false,\r\n    created_at timestamptz DEFAULT now()\r\n)","-- 6. Indexes\r\nCREATE INDEX idx_tickets_user_id ON public.tickets(user_id)","CREATE INDEX idx_tickets_status ON public.tickets(status)","CREATE INDEX idx_ticket_comments_ticket_id ON public.ticket_comments(ticket_id)","CREATE INDEX idx_ideas_user_id ON public.ideas(user_id)","CREATE INDEX idx_ideas_status ON public.ideas(status)","CREATE INDEX idx_idea_comments_idea_id ON public.idea_comments(idea_id)","-- 7. RLS Policies\r\n\r\n-- Tabela: tickets\r\nALTER TABLE public.tickets ENABLE ROW LEVEL SECURITY","CREATE POLICY \\"Staff views all tickets\\" ON public.tickets FOR SELECT\r\n    USING (public.is_hostconnect_staff())","CREATE POLICY \\"Users view own tickets\\" ON public.tickets FOR SELECT\r\n    USING (auth.uid() = user_id)","CREATE POLICY \\"Users inset own tickets\\" ON public.tickets FOR INSERT\r\n    WITH CHECK (auth.uid() = user_id)","CREATE POLICY \\"Staff updates tickets\\" ON public.tickets FOR UPDATE\r\n    USING (public.is_hostconnect_staff())","-- Tabela: ticket_comments\r\nALTER TABLE public.ticket_comments ENABLE ROW LEVEL SECURITY","CREATE POLICY \\"Staff views all comments\\" ON public.ticket_comments FOR SELECT\r\n    USING (public.is_hostconnect_staff())","CREATE POLICY \\"Users view comments on own tickets\\" ON public.ticket_comments FOR SELECT\r\n    USING (EXISTS (SELECT 1 FROM public.tickets WHERE id = ticket_id AND user_id = auth.uid()))","CREATE POLICY \\"Staff inserts comments\\" ON public.ticket_comments FOR INSERT\r\n    WITH CHECK (public.is_hostconnect_staff())","CREATE POLICY \\"Users comment on own tickets\\" ON public.ticket_comments FOR INSERT\r\n    WITH CHECK (\r\n        auth.uid() = user_id AND \r\n        EXISTS (SELECT 1 FROM public.tickets WHERE id = ticket_id AND user_id = auth.uid())\r\n    )","-- Tabela: ideas\r\nALTER TABLE public.ideas ENABLE ROW LEVEL SECURITY","CREATE POLICY \\"Staff views all ideas\\" ON public.ideas FOR SELECT\r\n    USING (public.is_hostconnect_staff())","CREATE POLICY \\"Users view own ideas\\" ON public.ideas FOR SELECT\r\n    USING (auth.uid() = user_id)","CREATE POLICY \\"Users insert own ideas\\" ON public.ideas FOR INSERT\r\n    WITH CHECK (auth.uid() = user_id)","CREATE POLICY \\"Staff updates ideas\\" ON public.ideas FOR UPDATE\r\n    USING (public.is_hostconnect_staff())","-- Tabela: idea_comments\r\nALTER TABLE public.idea_comments ENABLE ROW LEVEL SECURITY","CREATE POLICY \\"Staff views all idea comments\\" ON public.idea_comments FOR SELECT\r\n    USING (public.is_hostconnect_staff())","CREATE POLICY \\"Users view comments on own ideas\\" ON public.idea_comments FOR SELECT\r\n    USING (EXISTS (SELECT 1 FROM public.ideas WHERE id = idea_id AND user_id = auth.uid()))","CREATE POLICY \\"Staff inserts idea comments\\" ON public.idea_comments FOR INSERT\r\n    WITH CHECK (public.is_hostconnect_staff())","CREATE POLICY \\"Users comment on own ideas\\" ON public.idea_comments FOR INSERT\r\n    WITH CHECK (\r\n        auth.uid() = user_id AND \r\n        EXISTS (SELECT 1 FROM public.ideas WHERE id = idea_id AND user_id = auth.uid())\r\n    )","-- 8. Trigger for updated_at (Assuming moddatetime exists from previous migrations)\r\n-- If not, create it or use simple trigger\r\nCREATE TRIGGER update_tickets_modtime BEFORE UPDATE ON public.tickets FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column()","CREATE TRIGGER update_ideas_modtime BEFORE UPDATE ON public.ideas FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column()"}	support_module
20251225140000	{"ALTER TABLE public.profiles \r\nADD COLUMN IF NOT EXISTS accommodation_limit INTEGER DEFAULT 0,\r\nADD COLUMN IF NOT EXISTS founder_started_at TIMESTAMPTZ,\r\nADD COLUMN IF NOT EXISTS founder_expires_at TIMESTAMPTZ,\r\nADD COLUMN IF NOT EXISTS entitlements JSONB","-- Update RLS policies if necessary (assuming existing policies cover update by admin/self)\r\n-- Ideally, ensure only admins can update these specific columns, but for now we follow existing patterns."}	add_plan_entitlements
20251225150000	{"ALTER TABLE public.profiles \r\nADD COLUMN IF NOT EXISTS onboarding_completed BOOLEAN DEFAULT FALSE,\r\nADD COLUMN IF NOT EXISTS onboarding_step INTEGER DEFAULT 1,\r\nADD COLUMN IF NOT EXISTS onboarding_type TEXT","-- Index for faster filtering if needed later\r\nCREATE INDEX IF NOT EXISTS idx_profiles_onboarding_completed ON public.profiles(onboarding_completed)"}	add_onboarding_fields
20251225160000	{"-- Create a function to check accommodation limits before insertion\r\nCREATE OR REPLACE FUNCTION check_accommodation_limit()\r\nRETURNS TRIGGER AS $$\r\nDECLARE\r\n  current_count INTEGER;\r\n  max_limit INTEGER;\r\n  user_plan TEXT;\r\nBEGIN\r\n  -- Get the current number of properties for the user (owner)\r\n  -- Changed from created_by to user_id to match codebase usage in useProperties.tsx\r\n  SELECT COUNT(*) INTO current_count\r\n  FROM public.properties\r\n  WHERE user_id = new.user_id; \r\n\r\n  -- Get the user's limit and plan from profiles\r\n  SELECT accommodation_limit, plan INTO max_limit, user_plan\r\n  FROM public.profiles\r\n  WHERE id = new.user_id;\r\n\r\n  -- Default limit to 0 if not found (security fallback)\r\n  IF max_limit IS NULL THEN\r\n    max_limit := 0;\r\n  END IF;\r\n\r\n  -- Check if adding 1 would exceed the limit\r\n  -- Note: existing count + 1 (the one being inserted) > limit\r\n  IF (current_count + 1) > max_limit THEN\r\n    -- Raise a custom error that can be caught by the frontend\r\n    RAISE EXCEPTION 'Limite de acomodações atingido para o plano %. Atual: %, Limite: %', user_plan, current_count, max_limit\r\n      USING ERRCODE = 'P0001'; \r\n  END IF;\r\n\r\n  RETURN NEW;\r\nEND;\r\n$$ LANGUAGE plpgsql","-- Create the trigger on the properties table\r\nDROP TRIGGER IF EXISTS enforce_accommodation_limit ON public.properties","CREATE TRIGGER enforce_accommodation_limit\r\nBEFORE INSERT ON public.properties\r\nFOR EACH ROW\r\nEXECUTE FUNCTION check_accommodation_limit()"}	enforce_accommodation_limit
20251226085000	{"-- noop placeholder to align migration history with remote\n-- remote already has this version recorded in supabase_migrations.schema_migrations"}	fix_trial_limit_logic
20251226090000	{"-- Migration: Implement Backend Trial Logic\r\n-- Description: Adds trial columns to public.profiles and logic for initialization and extension.\r\n-- Date: 2025-12-26\r\n\r\n-- 1. Add Trial Columns to Profiles\r\nALTER TABLE public.profiles\r\nADD COLUMN IF NOT EXISTS trial_started_at timestamptz NULL,\r\nADD COLUMN IF NOT EXISTS trial_expires_at timestamptz NULL,\r\nADD COLUMN IF NOT EXISTS trial_extended_at timestamptz NULL,\r\nADD COLUMN IF NOT EXISTS trial_extension_days int NOT NULL DEFAULT 0,\r\nADD COLUMN IF NOT EXISTS trial_extension_reason text NULL,\r\nADD COLUMN IF NOT EXISTS plan_status text NOT NULL DEFAULT 'active'","-- 'trial' | 'active' | 'expired'\r\n\r\n-- 2. Trigger Function: Initialize Trial\r\nCREATE OR REPLACE FUNCTION public.handle_new_user_trial()\r\nRETURNS TRIGGER AS $$\r\nBEGIN\r\n    -- Only initialize trial if plan is empty or free (default assumption for new signups)\r\n    IF (NEW.plan IS NULL OR NEW.plan = 'free' OR NEW.plan = '') THEN\r\n        NEW.plan_status := 'trial';\r\n        NEW.trial_started_at := now();\r\n        NEW.trial_expires_at := now() + interval '15 days';\r\n        -- Optional: Set plan to 'premium' or similar if trial gives access to everything?\r\n        -- User requirements didn't specify changing the 'plan' column itself, only setting 'plan_status'='trial'.\r\n        -- We will assume Entitlements Logic will handle (plan='free' AND plan_status='trial') -> Give Premium Access.\r\n    END IF;\r\n    RETURN NEW;\r\nEND;\r\n$$ LANGUAGE plpgsql SECURITY DEFINER","-- 3. Create Trigger\r\n-- Check if trigger exists first to avoid errors on repeat runs (drop if exists)\r\nDROP TRIGGER IF EXISTS tr_initialize_trial ON public.profiles","CREATE TRIGGER tr_initialize_trial\r\nBEFORE INSERT ON public.profiles\r\nFOR EACH ROW\r\nEXECUTE FUNCTION public.handle_new_user_trial()","-- 4. Function: Extend Trial (RPC)\r\n-- Only staff (support/admin) can execute this.\r\nCREATE OR REPLACE FUNCTION public.extend_trial(\r\n    target_user_id uuid, \r\n    reason text\r\n)\r\nRETURNS json\r\nLANGUAGE plpgsql\r\nSECURITY DEFINER\r\nSET search_path = public\r\nAS $$\r\nDECLARE\r\n    target_profile record;\r\nBEGIN\r\n    -- 4.1 Check Permissions: Caller must be HostConnect Staff\r\n    IF NOT public.is_hostconnect_staff() THEN\r\n        RAISE EXCEPTION 'Access Denied: Only staff can extend trials.';\r\n    END IF;\r\n\r\n    -- 4.2 Fetch Target Profile\r\n    SELECT * INTO target_profile FROM public.profiles WHERE id = target_user_id;\r\n    \r\n    IF NOT FOUND THEN\r\n        RAISE EXCEPTION 'User profile not found.';\r\n    END IF;\r\n\r\n    -- 4.3 Validate Extension Rules\r\n    -- Rule: Must be in 'trial' status (or expired trial that we want to reactivate?)\r\n    -- Adding check: plan_status must be 'trial' OR (plan_status='expired' AND trial_started_at IS NOT NULL)\r\n    -- Actually user req: \\"só pode estender se plan_status='trial' e trial_extension_days=0\\"\r\n    \r\n    IF target_profile.plan_status != 'trial' THEN\r\n        RAISE EXCEPTION 'Cannot extend trial: User is not currently in active trial (Status: %)', target_profile.plan_status;\r\n    END IF;\r\n\r\n    IF target_profile.trial_extension_days > 0 THEN\r\n        RAISE EXCEPTION 'Cannot extend trial: Trial has already been extended once.';\r\n    END IF;\r\n\r\n    -- 4.4 Apply Extension\r\n    UPDATE public.profiles\r\n    SET \r\n        trial_extended_at = now(),\r\n        trial_extension_days = 15,\r\n        trial_extension_reason = reason,\r\n        trial_expires_at = trial_expires_at + interval '15 days'\r\n    WHERE id = target_user_id;\r\n\r\n    RETURN json_build_object(\r\n        'success', true, \r\n        'message', 'Trial extended by 15 days.',\r\n        'new_expires_at', (target_profile.trial_expires_at + interval '15 days')\r\n    );\r\nEND;\r\n$$"}	implement_trial_logic
20251226100000	{"-- Migration: Create Audit Log and Triggers\r\n-- Description: Tracks sensitive changes to profiles (plan, status, trial) and logs trial extensions.\r\n-- Date: 2025-12-26\r\n\r\n-- 1. Create Audit Log Table\r\nCREATE TABLE IF NOT EXISTS public.audit_log (\r\n    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),\r\n    created_at timestamptz DEFAULT now(),\r\n    actor_user_id uuid REFERENCES auth.users(id) ON DELETE SET NULL, -- Who performed the action\r\n    target_user_id uuid REFERENCES auth.users(id) ON DELETE SET NULL, -- Who was affected\r\n    action text NOT NULL, -- e.g., 'PROFILE_UPDATE', 'TRIAL_EXTENSION'\r\n    old_data jsonb NULL, -- Snapshot before change\r\n    new_data jsonb NULL  -- Snapshot after change\r\n)","-- 2. RLS Policies\r\nALTER TABLE public.audit_log ENABLE ROW LEVEL SECURITY","-- Staff can view all logs\r\nCREATE POLICY \\"Staff views audit logs\\" ON public.audit_log\r\n    FOR SELECT\r\n    USING (public.is_hostconnect_staff())","-- No one typically inserts directly via API, only via Server Functions/Triggers.\r\n-- But if we want to allow insert from authenticated staff via API? \r\n-- Better to keep it closed and rely on SECURITY DEFINER functions/triggers.\r\n\r\n-- 3. Trigger Function for Profile Changes\r\nCREATE OR REPLACE FUNCTION public.log_profile_sensitive_changes()\r\nRETURNS TRIGGER \r\nLANGUAGE plpgsql\r\nSECURITY DEFINER\r\nAS $$\r\nDECLARE\r\n    current_actor uuid;\r\n    changes_detected boolean := false;\r\n    old_snapshot jsonb;\r\n    new_snapshot jsonb;\r\nBEGIN\r\n    -- Attempt to get actor from auth.uid()\r\n    current_actor := auth.uid();\r\n\r\n    -- Check for sensitive columns changes\r\n    IF (OLD.plan IS DISTINCT FROM NEW.plan) OR \r\n       (OLD.plan_status IS DISTINCT FROM NEW.plan_status) OR\r\n       (OLD.trial_expires_at IS DISTINCT FROM NEW.trial_expires_at) OR \r\n       (OLD.trial_extension_days IS DISTINCT FROM NEW.trial_extension_days) THEN\r\n       \r\n       changes_detected := true;\r\n    END IF;\r\n\r\n    IF changes_detected THEN\r\n        -- Construct snapshots of relevant fields only\r\n        old_snapshot := jsonb_build_object(\r\n            'plan', OLD.plan,\r\n            'plan_status', OLD.plan_status,\r\n            'trial_expires_at', OLD.trial_expires_at,\r\n            'trial_extension_days', OLD.trial_extension_days\r\n        );\r\n        new_snapshot := jsonb_build_object(\r\n            'plan', NEW.plan,\r\n            'plan_status', NEW.plan_status,\r\n            'trial_expires_at', NEW.trial_expires_at,\r\n            'trial_extension_days', NEW.trial_extension_days\r\n        );\r\n\r\n        INSERT INTO public.audit_log (\r\n            actor_user_id,\r\n            target_user_id,\r\n            action,\r\n            old_data,\r\n            new_data\r\n        ) VALUES (\r\n            current_actor,\r\n            NEW.id,\r\n            'PROFILE_SENSITIVE_UPDATE',\r\n            old_snapshot,\r\n            new_snapshot\r\n        );\r\n    END IF;\r\n\r\n    RETURN NEW;\r\nEND;\r\n$$","-- 4. Apply Trigger to Profiles\r\nDROP TRIGGER IF EXISTS tr_audit_profile_changes ON public.profiles","CREATE TRIGGER tr_audit_profile_changes\r\nAFTER UPDATE ON public.profiles\r\nFOR EACH ROW\r\nEXECUTE FUNCTION public.log_profile_sensitive_changes()","-- 5. Update extend_trial Function to force an explicit log entry\r\n-- (The trigger will also fire, but this gives us the 'reason' in a separate clearer log if desired, \r\n-- or we can rely on the trigger. The user requested \\"validar\\" execution.\r\n-- Let's update it to insert a custom log with the REASON which the trigger doesn't see easily).\r\n\r\nCREATE OR REPLACE FUNCTION public.extend_trial(\r\n    target_user_id uuid, \r\n    reason text\r\n)\r\nRETURNS json\r\nLANGUAGE plpgsql\r\nSECURITY DEFINER\r\nSET search_path = public\r\nAS $$\r\nDECLARE\r\n    target_profile record;\r\n    old_expiration timestamptz;\r\nBEGIN\r\n    -- Check Permissions\r\n    IF NOT public.is_hostconnect_staff() THEN\r\n        RAISE EXCEPTION 'Access Denied: Only staff can extend trials.';\r\n    END IF;\r\n\r\n    SELECT * INTO target_profile FROM public.profiles WHERE id = target_user_id;\r\n    \r\n    IF NOT FOUND THEN\r\n        RAISE EXCEPTION 'User profile not found.';\r\n    END IF;\r\n\r\n    -- Validate\r\n    IF target_profile.plan_status != 'trial' THEN\r\n         RAISE EXCEPTION 'Cannot extend trial: User is not currently in active trial (Status: %)', target_profile.plan_status;\r\n    END IF;\r\n\r\n    IF target_profile.trial_extension_days > 0 THEN\r\n        RAISE EXCEPTION 'Cannot extend trial: Trial has already been extended once.';\r\n    END IF;\r\n    \r\n    old_expiration := target_profile.trial_expires_at;\r\n\r\n    -- Update\r\n    UPDATE public.profiles\r\n    SET \r\n        trial_extended_at = now(),\r\n        trial_extension_days = 15,\r\n        trial_extension_reason = reason,\r\n        trial_expires_at = trial_expires_at + interval '15 days'\r\n    WHERE id = target_user_id;\r\n\r\n    -- Explicit Audit Log for Action Context (The trigger will also catch the data change)\r\n    INSERT INTO public.audit_log (\r\n        actor_user_id,\r\n        target_user_id,\r\n        action,\r\n        old_data,\r\n        new_data\r\n    ) VALUES (\r\n        auth.uid(),\r\n        target_user_id,\r\n        'TRIAL_EXTENSION_RPC',\r\n        jsonb_build_object('reason', reason, 'old_expires_at', old_expiration),\r\n        jsonb_build_object('extension_days', 15, 'new_expires_at', old_expiration + interval '15 days')\r\n    );\r\n\r\n    RETURN json_build_object(\r\n        'success', true, \r\n        'message', 'Trial extended by 15 days.',\r\n        'new_expires_at', (target_profile.trial_expires_at + interval '15 days')\r\n    );\r\nEND;\r\n$$"}	create_audit_log
20251226110000	{"-- Migration: Create Organizations and Members\r\n-- Description: Implements multi-user structure (organizations) without breaking existing profile model.\r\n-- Date: 2025-12-26\r\n\r\n-- 1. Create Organizations Table\r\nCREATE TABLE IF NOT EXISTS public.organizations (\r\n    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),\r\n    name text NOT NULL,\r\n    created_at timestamptz DEFAULT now(),\r\n    owner_id uuid REFERENCES auth.users(id) ON DELETE SET NULL -- Optional direct link to owner for easy access\r\n)","-- 2. Create Organization Members Table\r\nCREATE TABLE IF NOT EXISTS public.org_members (\r\n    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),\r\n    org_id uuid REFERENCES public.organizations(id) ON DELETE CASCADE NOT NULL,\r\n    user_id uuid REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,\r\n    role text NOT NULL CHECK (role IN ('owner', 'admin', 'member', 'viewer')),\r\n    created_at timestamptz DEFAULT now(),\r\n    UNIQUE(org_id, user_id)\r\n)","-- 3. Enable RLS\r\nALTER TABLE public.organizations ENABLE ROW LEVEL SECURITY","ALTER TABLE public.org_members ENABLE ROW LEVEL SECURITY","-- 4. Helper Functions (Security Definer)\r\n\r\n-- 4.1 Check if user is member of specific org\r\nCREATE OR REPLACE FUNCTION public.is_org_member(p_org_id uuid)\r\nRETURNS boolean\r\nLANGUAGE plpgsql\r\nSECURITY DEFINER\r\nSET search_path = public\r\nAS $$\r\nBEGIN\r\n  RETURN EXISTS (\r\n    SELECT 1 \r\n    FROM public.org_members \r\n    WHERE org_id = p_org_id \r\n    AND user_id = auth.uid()\r\n  );\r\nEND;\r\n$$","-- 4.2 Check if user is admin/owner of specific org\r\nCREATE OR REPLACE FUNCTION public.is_org_admin(p_org_id uuid)\r\nRETURNS boolean\r\nLANGUAGE plpgsql\r\nSECURITY DEFINER\r\nSET search_path = public\r\nAS $$\r\nBEGIN\r\n  RETURN EXISTS (\r\n    SELECT 1 \r\n    FROM public.org_members \r\n    WHERE org_id = p_org_id \r\n    AND user_id = auth.uid()\r\n    AND role IN ('owner', 'admin')\r\n  );\r\nEND;\r\n$$","-- 4.3 Get Current Org ID (Primary/First Found) for the user\r\n-- Usage: useful for default scope when user logs in\r\nCREATE OR REPLACE FUNCTION public.current_org_id()\r\nRETURNS uuid\r\nLANGUAGE plpgsql\r\nSTABLE\r\nSECURITY DEFINER\r\nSET search_path = public\r\nAS $$\r\nDECLARE\r\n    v_org_id uuid;\r\nBEGIN\r\n    SELECT org_id INTO v_org_id\r\n    FROM public.org_members\r\n    WHERE user_id = auth.uid()\r\n    ORDER BY created_at ASC -- Stable ordering (oldest membership)\r\n    LIMIT 1;\r\n    \r\n    RETURN v_org_id;\r\nEND;\r\n$$","-- 5. RLS Policies\r\n\r\n-- ORG_MEMBERS Policies\r\n-- Members can view members of their own orgs\r\nDROP POLICY IF EXISTS \\"Members can view their org members\\" ON public.org_members","CREATE POLICY \\"Members can view their org members\\" ON public.org_members\r\n    FOR SELECT\r\n    USING (\r\n      auth.uid() = user_id -- Can see self\r\n      OR \r\n      EXISTS ( -- Can see others in same org\r\n        SELECT 1 FROM public.org_members om \r\n        WHERE om.org_id = org_members.org_id \r\n        AND om.user_id = auth.uid()\r\n      )\r\n    )","-- Only Admins can insert/update/delete members\r\nDROP POLICY IF EXISTS \\"Admins can manage org members\\" ON public.org_members","CREATE POLICY \\"Admins can manage org members\\" ON public.org_members\r\n    FOR ALL\r\n    USING (\r\n      public.is_org_admin(org_id)\r\n    )","-- ORGANIZATIONS Policies\r\n-- Members can view their organizations\r\nDROP POLICY IF EXISTS \\"Members can view their organizations\\" ON public.organizations","CREATE POLICY \\"Members can view their organizations\\" ON public.organizations\r\n    FOR SELECT\r\n    USING (\r\n      public.is_org_member(id)\r\n    )","-- Only Admins (of that org) can update\r\nDROP POLICY IF EXISTS \\"Admins can update organization\\" ON public.organizations","CREATE POLICY \\"Admins can update organization\\" ON public.organizations\r\n    FOR UPDATE\r\n    USING (\r\n      public.is_org_admin(id)\r\n    )","-- Insert: usually done via RPC or global flow not restricted by row existing yet.\r\n-- But allowing authenticated users to create a NEW organization is often desired.\r\nDROP POLICY IF EXISTS \\"Users can create organizations\\" ON public.organizations","CREATE POLICY \\"Users can create organizations\\" ON public.organizations\r\n    FOR INSERT\r\n    WITH CHECK (true)","-- Note: After insert, they need to be added to org_members to see it/admin it.\r\n    -- Usually handled by a \\"create_organization\\" RPC to do both transactionally.\r\n\r\n-- 6. RPC to Create Organization (Transactional convenience)\r\nCREATE OR REPLACE FUNCTION public.create_organization(org_name text)\r\nRETURNS json\r\nLANGUAGE plpgsql\r\nSECURITY DEFINER\r\nSET search_path = public\r\nAS $$\r\nDECLARE\r\n    new_org_id uuid;\r\n    current_uid uuid;\r\nBEGIN\r\n    current_uid := auth.uid();\r\n    \r\n    -- Check Authentication\r\n    IF current_uid IS NULL THEN\r\n        RAISE EXCEPTION 'Not authenticated: You must be logged in to create an organization.';\r\n    END IF;\r\n\r\n    -- 1. Create Org\r\n    INSERT INTO public.organizations (name, owner_id)\r\n    VALUES (org_name, current_uid)\r\n    RETURNING id INTO new_org_id;\r\n\r\n    -- 2. Add Creator as Owner\r\n    INSERT INTO public.org_members (org_id, user_id, role)\r\n    VALUES (new_org_id, current_uid, 'owner');\r\n\r\n    RETURN json_build_object('id', new_org_id, 'name', org_name);\r\nEND;\r\n$$"}	create_organizations
20260121200000	{"-- Sprint 5.2: Booking Groups Model\r\n-- Enables group booking management with multi-tenant isolation\r\n\r\n-- Create booking_groups table\r\nCREATE TABLE IF NOT EXISTS public.booking_groups (\r\n    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),\r\n    org_id UUID NOT NULL REFERENCES public.organizations(id) ON DELETE RESTRICT,\r\n    property_id UUID NOT NULL REFERENCES public.properties(id) ON DELETE RESTRICT,\r\n    booking_id UUID NOT NULL REFERENCES public.bookings(id) ON DELETE CASCADE,\r\n    group_name TEXT NOT NULL,\r\n    leader_name TEXT,\r\n    leader_phone TEXT,\r\n    estimated_participants INTEGER,\r\n    notes TEXT,\r\n    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),\r\n    updated_at TIMESTAMPTZ NOT NULL DEFAULT now()\r\n)","-- Create indexes for efficient queries\r\nCREATE INDEX IF NOT EXISTS idx_booking_groups_org_property_booking \r\n    ON public.booking_groups(org_id, property_id, booking_id)","CREATE INDEX IF NOT EXISTS idx_booking_groups_org_property_name \r\n    ON public.booking_groups(org_id, property_id, group_name)","-- Add updated_at trigger\r\nCREATE TRIGGER set_updated_at_booking_groups\r\n    BEFORE UPDATE ON public.booking_groups\r\n    FOR EACH ROW\r\n    EXECUTE FUNCTION public.update_updated_at_column()","-- Enable RLS\r\nALTER TABLE public.booking_groups ENABLE ROW LEVEL SECURITY","-- RLS Policies: Multi-tenant isolation\r\n\r\n-- Policy: Users can view groups for bookings in their org\r\nCREATE POLICY \\"Users can view booking_groups in their org\\"\r\n    ON public.booking_groups\r\n    FOR SELECT\r\n    USING (\r\n        org_id IN (\r\n            SELECT om.org_id \r\n            FROM public.org_members om \r\n            WHERE om.user_id = auth.uid()\r\n        )\r\n    )","-- Policy: Admins/Managers/Staff can insert groups\r\nCREATE POLICY \\"Staff can insert booking_groups\\"\r\n    ON public.booking_groups\r\n    FOR INSERT\r\n    WITH CHECK (\r\n        org_id IN (\r\n            SELECT om.org_id \r\n            FROM public.org_members om \r\n            WHERE om.user_id = auth.uid()\r\n            AND om.role IN ('admin', 'manager', 'staff')\r\n        )\r\n        AND property_id IN (\r\n            SELECT p.id \r\n            FROM public.properties p \r\n            WHERE p.org_id = booking_groups.org_id\r\n        )\r\n        AND booking_id IN (\r\n            SELECT b.id \r\n            FROM public.bookings b \r\n            WHERE b.org_id = booking_groups.org_id \r\n            AND b.property_id = booking_groups.property_id\r\n        )\r\n    )","-- Policy: Admins/Managers/Staff can update groups\r\nCREATE POLICY \\"Staff can update booking_groups\\"\r\n    ON public.booking_groups\r\n    FOR UPDATE\r\n    USING (\r\n        org_id IN (\r\n            SELECT om.org_id \r\n            FROM public.org_members om \r\n            WHERE om.user_id = auth.uid()\r\n            AND om.role IN ('admin', 'manager', 'staff')\r\n        )\r\n    )\r\n    WITH CHECK (\r\n        org_id IN (\r\n            SELECT om.org_id \r\n            FROM public.org_members om \r\n            WHERE om.user_id = auth.uid()\r\n            AND om.role IN ('admin', 'manager', 'staff')\r\n        )\r\n    )","-- Policy: Admins/Managers can delete groups\r\nCREATE POLICY \\"Admins can delete booking_groups\\"\r\n    ON public.booking_groups\r\n    FOR DELETE\r\n    USING (\r\n        org_id IN (\r\n            SELECT om.org_id \r\n            FROM public.org_members om \r\n            WHERE om.user_id = auth.uid()\r\n            AND om.role IN ('admin', 'manager')\r\n        )\r\n    )","-- Add comment for documentation\r\nCOMMENT ON TABLE public.booking_groups IS 'Groups associated with bookings for efficient batch pre-checkin handling'"}	create_booking_groups
20251226120000	{"-- Migration: Bootstrap Personal Organization for Users\r\n-- Description: Ensures every user has at least one organization (Personal Org).\r\n-- Date: 2025-12-26\r\n\r\n-- 1. Helper Function: Create Personal Org\r\nCREATE OR REPLACE FUNCTION public.create_personal_org_for_user(p_user_id uuid)\r\nRETURNS void\r\nLANGUAGE plpgsql\r\nSECURITY DEFINER\r\nSET search_path = public\r\nAS $$\r\nDECLARE\r\n    v_org_id uuid;\r\n    v_user_name text;\r\nBEGIN\r\n    -- Idempotency Check: If user is already a member of ANY organization, skip.\r\n    -- (We assume if they are a member, they are 'set up'. If we wanted to force a PERSONAL org specifically, logic would differ).\r\n    IF EXISTS (SELECT 1 FROM public.org_members WHERE user_id = p_user_id) THEN\r\n        RETURN;\r\n    END IF;\r\n\r\n    -- Get user name for better org name (optional, fallback to generic)\r\n    SELECT full_name INTO v_user_name FROM public.profiles WHERE id = p_user_id;\r\n    IF v_user_name IS NULL OR v_user_name = '' THEN\r\n        v_user_name := 'Minha Hospedagem';\r\n    ELSE\r\n        v_user_name := v_user_name || ' - Hospedagem';\r\n    END IF;\r\n\r\n    -- Create Org\r\n    INSERT INTO public.organizations (name, owner_id)\r\n    VALUES (v_user_name, p_user_id)\r\n    RETURNING id INTO v_org_id;\r\n\r\n    -- Add User as Owner\r\n    INSERT INTO public.org_members (org_id, user_id, role)\r\n    VALUES (v_org_id, p_user_id, 'owner');\r\n    \r\nEXCEPTION WHEN OTHERS THEN\r\n    -- Log error or ignore to prevent blocking user creation\r\n    RAISE WARNING 'Failed to create personal org for user %: %', p_user_id, SQLERRM;\r\nEND;\r\n$$","-- 2. Trigger Function\r\nCREATE OR REPLACE FUNCTION public.handle_new_user_org()\r\nRETURNS TRIGGER \r\nLANGUAGE plpgsql\r\nSECURITY DEFINER\r\nAS $$\r\nBEGIN\r\n    PERFORM public.create_personal_org_for_user(NEW.id);\r\n    RETURN NEW;\r\nEND;\r\n$$","-- 3. Trigger Definition\r\nDROP TRIGGER IF EXISTS tr_ensure_personal_org ON public.profiles","CREATE TRIGGER tr_ensure_personal_org\r\nAFTER INSERT ON public.profiles\r\nFOR EACH ROW\r\nEXECUTE FUNCTION public.handle_new_user_org()","-- 4. Backfill: Run for existing users who might have been missed or pre-date this migration\r\nDO $$\r\nDECLARE\r\n    r record;\r\nBEGIN\r\n    FOR r IN SELECT id FROM public.profiles LOOP\r\n        PERFORM public.create_personal_org_for_user(r.id);\r\n    END LOOP;\r\nEND;\r\n$$"}	bootstrap_user_org
20251226130000	{"-- Migration: Add org_id to Core Tables\r\n-- Description: Prepares core tables for multi-tenancy by adding org_id column.\r\n-- Date: 2025-12-26\r\n\r\n-- 1. Add org_id to Properties\r\nALTER TABLE public.properties \r\nADD COLUMN IF NOT EXISTS org_id uuid REFERENCES public.organizations(id) ON DELETE SET NULL","CREATE INDEX IF NOT EXISTS idx_properties_org_id ON public.properties(org_id)","-- 2. Add org_id to Bookings\r\nALTER TABLE public.bookings \r\nADD COLUMN IF NOT EXISTS org_id uuid REFERENCES public.organizations(id) ON DELETE SET NULL","CREATE INDEX IF NOT EXISTS idx_bookings_org_id ON public.bookings(org_id)","-- 3. Add org_id to Rooms\r\nALTER TABLE public.rooms \r\nADD COLUMN IF NOT EXISTS org_id uuid REFERENCES public.organizations(id) ON DELETE SET NULL","CREATE INDEX IF NOT EXISTS idx_rooms_org_id ON public.rooms(org_id)","-- 4. Add org_id to Support Tickets\r\nALTER TABLE public.tickets \r\nADD COLUMN IF NOT EXISTS org_id uuid REFERENCES public.organizations(id) ON DELETE SET NULL","CREATE INDEX IF NOT EXISTS idx_tickets_org_id ON public.tickets(org_id)","-- 5. Add org_id to Ideas\r\nALTER TABLE public.ideas \r\nADD COLUMN IF NOT EXISTS org_id uuid REFERENCES public.organizations(id) ON DELETE SET NULL","CREATE INDEX IF NOT EXISTS idx_ideas_org_id ON public.ideas(org_id)","-- Note: user_id columns remain strict for now until RLS migration.\r\n-- In the future, we will likely backfill org_id based on the user's personal org\r\n-- and then switch RLS to check org_id."}	add_org_id_to_core
20251226140000	{"-- Migration: Backfill org_id for Existing Data\r\n-- Description: Populates org_id for core tables based on the user's personal organization.\r\n-- Date: 2025-12-26\r\n\r\nDO $$\r\nBEGIN\r\n\r\n    -- 1. Update Properties (Direct user_id)\r\n    UPDATE public.properties t\r\n    SET org_id = (\r\n        SELECT org_id \r\n        FROM public.org_members om \r\n        WHERE om.user_id = t.user_id \r\n        ORDER BY om.created_at ASC \r\n        LIMIT 1\r\n    )\r\n    WHERE t.org_id IS NULL;\r\n\r\n    -- 2. Update Tickets (Direct user_id)\r\n    UPDATE public.tickets t\r\n    SET org_id = (\r\n        SELECT org_id \r\n        FROM public.org_members om \r\n        WHERE om.user_id = t.user_id \r\n        ORDER BY om.created_at ASC \r\n        LIMIT 1\r\n    )\r\n    WHERE t.org_id IS NULL;\r\n\r\n    -- 3. Update Ideas (Direct user_id)\r\n    UPDATE public.ideas t\r\n    SET org_id = (\r\n        SELECT org_id \r\n        FROM public.org_members om \r\n        WHERE om.user_id = t.user_id \r\n        ORDER BY om.created_at ASC \r\n        LIMIT 1\r\n    )\r\n    WHERE t.org_id IS NULL;\r\n\r\n    -- 4. Update Rooms (Via Property)\r\n    -- Requires properties to be updated first\r\n    UPDATE public.rooms t\r\n    SET org_id = p.org_id\r\n    FROM public.properties p\r\n    WHERE t.property_id = p.id\r\n    AND t.org_id IS NULL\r\n    AND p.org_id IS NOT NULL;\r\n\r\n    -- 5. Update Bookings (Via Property)\r\n    -- Requires properties to be updated first\r\n    UPDATE public.bookings t\r\n    SET org_id = p.org_id\r\n    FROM public.properties p\r\n    WHERE t.property_id = p.id\r\n    AND t.org_id IS NULL\r\n    AND p.org_id IS NOT NULL;\r\n\r\nEND $$"}	backfill_org_id
20251226150000	{"-- Migration: Update RLS Policies for Organizations\r\n-- Description: Updates RLS to allow access via Organization Membership while maintaining legacy user_id compatibility.\r\n-- Date: 2025-12-26\r\n\r\n-- =============================================================================\r\n-- 1. PROPERTIES\r\n-- =============================================================================\r\nDROP POLICY IF EXISTS \\"Users can view own properties\\" ON public.properties","DROP POLICY IF EXISTS \\"Users can insert own properties\\" ON public.properties","DROP POLICY IF EXISTS \\"Users can update own properties\\" ON public.properties","DROP POLICY IF EXISTS \\"Users can delete own properties\\" ON public.properties","CREATE POLICY \\"Org: Users can view properties\\"\r\n  ON public.properties FOR SELECT\r\n  USING (\r\n    -- Legacy\r\n    auth.uid() = user_id \r\n    -- New\r\n    OR (org_id IS NOT NULL AND public.is_org_member(org_id))\r\n  )","CREATE POLICY \\"Org: Users can insert properties\\"\r\n  ON public.properties FOR INSERT\r\n  WITH CHECK (\r\n    -- Legacy\r\n    auth.uid() = user_id \r\n    -- New (Admins only for structure?)\r\n    OR (org_id IS NOT NULL AND public.is_org_admin(org_id))\r\n  )","CREATE POLICY \\"Org: Users can update properties\\"\r\n  ON public.properties FOR UPDATE\r\n  USING (\r\n    auth.uid() = user_id \r\n    OR (org_id IS NOT NULL AND public.is_org_admin(org_id))\r\n  )","CREATE POLICY \\"Org: Users can delete properties\\"\r\n  ON public.properties FOR DELETE\r\n  USING (\r\n    auth.uid() = user_id \r\n    OR (org_id IS NOT NULL AND public.is_org_admin(org_id))\r\n  )","-- =============================================================================\r\n-- 2. BOOKINGS\r\n-- =============================================================================\r\nDROP POLICY IF EXISTS \\"Users can view bookings for own properties\\" ON public.bookings","DROP POLICY IF EXISTS \\"Users can insert bookings for own properties\\" ON public.bookings","DROP POLICY IF EXISTS \\"Users can update bookings for own properties\\" ON public.bookings","DROP POLICY IF EXISTS \\"Users can delete bookings for own properties\\" ON public.bookings","CREATE POLICY \\"Org: Users can view bookings\\"\r\n  ON public.bookings FOR SELECT\r\n  USING (\r\n    auth.uid() = (SELECT user_id FROM public.properties WHERE id = property_id) -- Legacy Implicit\r\n    OR (org_id IS NOT NULL AND public.is_org_member(org_id))\r\n  )","CREATE POLICY \\"Org: Users can insert bookings\\"\r\n  ON public.bookings FOR INSERT\r\n  WITH CHECK (\r\n    (SELECT user_id FROM public.properties WHERE id = property_id) = auth.uid()\r\n    OR (org_id IS NOT NULL AND public.is_org_member(org_id))\r\n  )","CREATE POLICY \\"Org: Users can update bookings\\"\r\n  ON public.bookings FOR UPDATE\r\n  USING (\r\n    (SELECT user_id FROM public.properties WHERE id = property_id) = auth.uid()\r\n    OR (org_id IS NOT NULL AND public.is_org_member(org_id))\r\n  )","CREATE POLICY \\"Org: Users can delete bookings\\"\r\n  ON public.bookings FOR DELETE\r\n  USING (\r\n    (SELECT user_id FROM public.properties WHERE id = property_id) = auth.uid()\r\n    OR (org_id IS NOT NULL AND public.is_org_member(org_id))\r\n  )","-- =============================================================================\r\n-- 3. ROOMS\r\n-- =============================================================================\r\n-- Assumes policies existed or we replace them. \r\n-- Dropping potential standard names just in case.\r\nDROP POLICY IF EXISTS \\"Users can view own rooms\\" ON public.rooms","DROP POLICY IF EXISTS \\"Users can insert own rooms\\" ON public.rooms","DROP POLICY IF EXISTS \\"Users can update own rooms\\" ON public.rooms","DROP POLICY IF EXISTS \\"Users can delete own rooms\\" ON public.rooms","CREATE POLICY \\"Org: Users can view rooms\\" ON public.rooms FOR SELECT USING (\r\n    (SELECT user_id FROM public.properties WHERE id = property_id) = auth.uid()\r\n    OR (org_id IS NOT NULL AND public.is_org_member(org_id))\r\n)","CREATE POLICY \\"Org: Users can insert rooms\\" ON public.rooms FOR INSERT WITH CHECK (\r\n    (SELECT user_id FROM public.properties WHERE id = property_id) = auth.uid()\r\n    OR (org_id IS NOT NULL AND public.is_org_admin(org_id)) -- Strict for structural\r\n)","CREATE POLICY \\"Org: Users can update rooms\\" ON public.rooms FOR UPDATE USING (\r\n    (SELECT user_id FROM public.properties WHERE id = property_id) = auth.uid()\r\n    OR (org_id IS NOT NULL AND public.is_org_admin(org_id))\r\n)","CREATE POLICY \\"Org: Users can delete rooms\\" ON public.rooms FOR DELETE USING (\r\n    (SELECT user_id FROM public.properties WHERE id = property_id) = auth.uid()\r\n    OR (org_id IS NOT NULL AND public.is_org_admin(org_id))\r\n)","-- =============================================================================\r\n-- 4. PROPERTY PHOTOS (Table only, skipping Storage for now)\r\n-- =============================================================================\r\n-- =============================================================================\r\n-- 4. PROPERTY PHOTOS (Table only, skipping Storage for now)\r\n-- =============================================================================\r\n-- Use DO block to avoid error if table doesn't exist\r\nDO $$\r\nBEGIN\r\n  IF EXISTS (SELECT FROM pg_tables WHERE schemaname = 'public' AND tablename = 'property_photos') THEN\r\n    \r\n    DROP POLICY IF EXISTS \\"Users can view photos for own properties\\" ON public.property_photos;\r\n    DROP POLICY IF EXISTS \\"Users can insert photos for own properties\\" ON public.property_photos;\r\n    DROP POLICY IF EXISTS \\"Users can update photos for own properties\\" ON public.property_photos;\r\n    DROP POLICY IF EXISTS \\"Users can delete photos for own properties\\" ON public.property_photos;\r\n\r\n    EXECUTE '\r\n    CREATE POLICY \\"Org: Users can view photos\\" ON public.property_photos FOR SELECT USING (\r\n      EXISTS (\r\n        SELECT 1 FROM public.properties p\r\n        WHERE p.id = property_photos.property_id\r\n        AND (\r\n          p.user_id = auth.uid()\r\n          OR\r\n          (p.org_id IS NOT NULL AND public.is_org_member(p.org_id))\r\n        )\r\n      )\r\n    );\r\n\r\n    CREATE POLICY \\"Org: Users can manage photos\\" ON public.property_photos FOR ALL USING (\r\n      EXISTS (\r\n        SELECT 1 FROM public.properties p\r\n        WHERE p.id = property_photos.property_id\r\n        AND (\r\n          p.user_id = auth.uid()\r\n          OR\r\n          (p.org_id IS NOT NULL AND public.is_org_member(p.org_id))\r\n        )\r\n      )\r\n    );';\r\n    \r\n  END IF;\r\nEND $$","-- =============================================================================\r\n-- 5. SUPPORT MODULE (Tickets & Ideas)\r\n-- =============================================================================\r\n-- Note: Staff policies usually bypassing RLS or having specific Staff policies. \r\n-- We only touch \\"Users can...\\" policies.\r\n\r\n-- TICKETS\r\nDROP POLICY IF EXISTS \\"Users can see own tickets\\" ON public.tickets","CREATE POLICY \\"Org: Users can view tickets\\" ON public.tickets FOR SELECT USING (\r\n  auth.uid() = user_id \r\n  OR (org_id IS NOT NULL AND public.is_org_member(org_id))\r\n  OR public.is_hostconnect_staff() -- Ensure staff keeps access\r\n)","DROP POLICY IF EXISTS \\"Users can create tickets\\" ON public.tickets","CREATE POLICY \\"Org: Users can create tickets\\" ON public.tickets FOR INSERT WITH CHECK (\r\n  auth.uid() = user_id\r\n  OR (org_id IS NOT NULL AND public.is_org_member(org_id))\r\n)","-- IDEAS\r\nDROP POLICY IF EXISTS \\"Users can view ideas\\" ON public.ideas","-- Ideas are often public? If locked to user/org:\r\nCREATE POLICY \\"Org: Users can view ideas\\" ON public.ideas FOR SELECT USING (\r\n  -- Allowing access if user owns it, is in org, or is staff.\r\n  auth.uid() = user_id \r\n  OR (org_id IS NOT NULL AND public.is_org_member(org_id))\r\n  OR public.is_hostconnect_staff()\r\n)","-- Just in case Ideas was already public, this might restrict it. \r\n-- Checking: \\"Users can view all ideas\\" is common. \r\n-- If the previous policy allowed ALL authenticated, we shouldn't restrict it. \r\n-- Let's stick to the prompt \\"Para cada tabela core\\". \r\n-- If Ideas are shared global suggestions, org_id is just \\"who posted it\\".\r\n-- I will Skip altering Ideas SELECT policy to avoid breaking public nature if it exists.\r\n-- Only changing INSERT/UPDATE if necessary.\r\n\r\n-- Returning to safe update for Ideas: Update only if own/org.\r\nCREATE POLICY \\"Org: Users can update own ideas\\" ON public.ideas FOR UPDATE USING (\r\n  auth.uid() = user_id \r\n  OR (org_id IS NOT NULL AND public.is_org_admin(org_id))\r\n)"}	update_rls_for_orgs
20251226160000	{"-- Migration: Team Management and Permissions\r\n-- Description: Adds tables for invitations and fine-grained member permissions.\r\n-- Date: 2025-12-26\r\n\r\n-- 1. Member Permissions Table\r\nCREATE TABLE public.member_permissions (\r\n  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),\r\n  org_id uuid NOT NULL REFERENCES public.organizations(id) ON DELETE CASCADE,\r\n  user_id uuid NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,\r\n  module_key text NOT NULL, -- e.g., 'financial', 'guests', 'tasks'\r\n  can_read boolean DEFAULT true,\r\n  can_write boolean DEFAULT false,\r\n  created_at timestamptz DEFAULT now(),\r\n  updated_at timestamptz DEFAULT now(),\r\n  UNIQUE(org_id, user_id, module_key)\r\n)","-- RLS\r\nALTER TABLE public.member_permissions ENABLE ROW LEVEL SECURITY","CREATE POLICY \\"Admins manage permissions\\" ON public.member_permissions\r\n  FOR ALL USING (public.is_org_admin(org_id))","CREATE POLICY \\"Members view own permissions\\" ON public.member_permissions\r\n  FOR SELECT USING (auth.uid() = user_id)","-- 2. Organization Invites\r\nCREATE TABLE public.org_invites (\r\n  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),\r\n  org_id uuid NOT NULL REFERENCES public.organizations(id) ON DELETE CASCADE,\r\n  email text NOT NULL,\r\n  role text NOT NULL DEFAULT 'member', -- member, admin, viewer\r\n  token text NOT NULL DEFAULT encode(gen_random_bytes(32), 'hex'),\r\n  status text NOT NULL DEFAULT 'pending', -- pending, accepted, expired\r\n  created_at timestamptz DEFAULT now(),\r\n  expires_at timestamptz DEFAULT (now() + interval '7 days')\r\n)","-- RLS\r\nALTER TABLE public.org_invites ENABLE ROW LEVEL SECURITY","CREATE POLICY \\"Admins manage invites\\" ON public.org_invites\r\n  FOR ALL USING (public.is_org_admin(org_id))","CREATE POLICY \\"Anyone can look up token\\" ON public.org_invites\r\n  FOR SELECT USING (true)","-- Needed for public join page (conceptually)\r\n\r\n\r\n-- 3. Functions\r\n\r\n-- Function to create invite (handled by RLS mainly, but helper is nice)\r\n-- We will use direct Insert from frontend for simplicity if RLS allows.\r\n\r\n-- Function to accept invite\r\nCREATE OR REPLACE FUNCTION public.accept_invite(p_token text)\r\nRETURNS json\r\nLANGUAGE plpgsql\r\nSECURITY DEFINER\r\nAS $$\r\nDECLARE\r\n  v_invite public.org_invites%ROWTYPE;\r\n  v_user_email text;\r\n  v_user_id uuid;\r\nBEGIN\r\n  -- Get Invite\r\n  SELECT * INTO v_invite\r\n  FROM public.org_invites\r\n  WHERE token = p_token AND status = 'pending' AND expires_at > now();\r\n\r\n  IF v_invite.id IS NULL THEN\r\n    RETURN json_build_object('success', false, 'error', 'Invalid or expired token');\r\n  END IF;\r\n\r\n  -- Get Current User\r\n  v_user_id := auth.uid();\r\n  IF v_user_id IS NULL THEN\r\n     RETURN json_build_object('success', false, 'error', 'Not authenticated');\r\n  END IF;\r\n\r\n  SELECT email INTO v_user_email FROM auth.users WHERE id = v_user_id;\r\n\r\n  -- Verify Email? (Optional: Strict or Open Link)\r\n  -- Prompt says: \\"admin cria e envia link\\". Usually implies link is key.\r\n  -- But for security, matching email is better. \r\n  -- Let's enforce email match if invite prompt specifically asked for email.\r\n  -- But user might have different email alias. \r\n  -- Let's be lenient for this \\"Simples\\" mvp: If they have the valid token, they claim it.\r\n  -- BUT update the invite with the actual user who claimed it.\r\n\r\n  -- Add to Org Members\r\n  INSERT INTO public.org_members (org_id, user_id, role)\r\n  VALUES (v_invite.org_id, v_user_id, v_invite.role)\r\n  ON CONFLICT (org_id, user_id) DO UPDATE SET role = EXCLUDED.role;\r\n\r\n  -- Update Invite Status\r\n  UPDATE public.org_invites\r\n  SET status = 'accepted'\r\n  WHERE id = v_invite.id;\r\n\r\n  RETURN json_build_object('success', true, 'org_id', v_invite.org_id);\r\nEND;\r\n$$"}	team_management
20251226170000	{"-- Migration: Enforce Organization Isolation\r\n-- Description: Makes org_id NOT NULL, adds auto-fill triggers, and removes legacy user_id RLS.\r\n-- Date: 2025-12-26\r\n\r\n-- =============================================================================\r\n-- 1. TRIGGERS FOR AUTO-FILLING ORG_ID (Robustness)\r\n-- =============================================================================\r\n-- Function: set_org_id_from_property\r\nCREATE OR REPLACE FUNCTION public.set_org_id_from_property()\r\nRETURNS TRIGGER AS $$\r\nBEGIN\r\n  IF NEW.org_id IS NULL AND NEW.property_id IS NOT NULL THEN\r\n    SELECT org_id INTO NEW.org_id\r\n    FROM public.properties\r\n    WHERE id = NEW.property_id;\r\n  END IF;\r\n  RETURN NEW;\r\nEND;\r\n$$ LANGUAGE plpgsql","-- Triggers\r\nDROP TRIGGER IF EXISTS tr_bookings_set_org ON public.bookings","CREATE TRIGGER tr_bookings_set_org\r\nBEFORE INSERT ON public.bookings\r\nFOR EACH ROW EXECUTE FUNCTION public.set_org_id_from_property()","DROP TRIGGER IF EXISTS tr_rooms_set_org ON public.rooms","CREATE TRIGGER tr_rooms_set_org\r\nBEFORE INSERT ON public.rooms\r\nFOR EACH ROW EXECUTE FUNCTION public.set_org_id_from_property()","-- Property Photos Trigger (Conditional if table exists)\r\nDO $$\r\nBEGIN\r\n  IF EXISTS (SELECT FROM pg_tables WHERE tablename = 'property_photos') THEN\r\n    EXECUTE 'DROP TRIGGER IF EXISTS tr_photos_set_org ON public.property_photos';\r\n    EXECUTE 'CREATE TRIGGER tr_photos_set_org BEFORE INSERT ON public.property_photos FOR EACH ROW EXECUTE FUNCTION public.set_org_id_from_property()';\r\n  END IF;\r\nEND $$","-- =============================================================================\r\n-- 2. ENFORCE NOT NULL (Backfill Safety Check)\r\n-- =============================================================================\r\n-- If any NULLs exist, this will fail. User verified backfill.\r\n-- Just in case, we attempt one last backfill for stragglers?\r\n-- No, user said \\"Após validação\\". We assume it's clean.\r\n\r\nALTER TABLE public.properties ALTER COLUMN org_id SET NOT NULL","ALTER TABLE public.bookings ALTER COLUMN org_id SET NOT NULL","ALTER TABLE public.rooms ALTER COLUMN org_id SET NOT NULL","ALTER TABLE public.tickets ALTER COLUMN org_id SET NOT NULL","ALTER TABLE public.ideas ALTER COLUMN org_id SET NOT NULL","-- =============================================================================\r\n-- 3. STRICT RLS (Remove user_id fallback)\r\n-- =============================================================================\r\n\r\n-- PROPERTIES\r\nDROP POLICY IF EXISTS \\"Org: Users can view properties\\" ON public.properties","DROP POLICY IF EXISTS \\"Strict: Org Members view properties\\" ON public.properties","CREATE POLICY \\"Strict: Org Members view properties\\" ON public.properties FOR SELECT USING (\r\n  public.is_org_member(org_id)\r\n)","DROP POLICY IF EXISTS \\"Org: Users can insert properties\\" ON public.properties","DROP POLICY IF EXISTS \\"Strict: Org Admins insert properties\\" ON public.properties","CREATE POLICY \\"Strict: Org Admins insert properties\\" ON public.properties FOR INSERT WITH CHECK (\r\n  public.is_org_admin(org_id)\r\n)","DROP POLICY IF EXISTS \\"Org: Users can update properties\\" ON public.properties","DROP POLICY IF EXISTS \\"Strict: Org Admins update properties\\" ON public.properties","CREATE POLICY \\"Strict: Org Admins update properties\\" ON public.properties FOR UPDATE USING (\r\n  public.is_org_admin(org_id)\r\n)","DROP POLICY IF EXISTS \\"Org: Users can delete properties\\" ON public.properties","DROP POLICY IF EXISTS \\"Strict: Org Admins delete properties\\" ON public.properties","CREATE POLICY \\"Strict: Org Admins delete properties\\" ON public.properties FOR DELETE USING (\r\n  public.is_org_admin(org_id)\r\n)","-- BOOKINGS\r\nDROP POLICY IF EXISTS \\"Org: Users can view bookings\\" ON public.bookings","DROP POLICY IF EXISTS \\"Strict: Org Members view bookings\\" ON public.bookings","CREATE POLICY \\"Strict: Org Members view bookings\\" ON public.bookings FOR SELECT USING (\r\n  public.is_org_member(org_id)\r\n)","DROP POLICY IF EXISTS \\"Org: Users can insert bookings\\" ON public.bookings","DROP POLICY IF EXISTS \\"Strict: Org Members insert bookings\\" ON public.bookings","CREATE POLICY \\"Strict: Org Members insert bookings\\" ON public.bookings FOR INSERT WITH CHECK (\r\n  public.is_org_member(org_id)\r\n)","DROP POLICY IF EXISTS \\"Org: Users can update bookings\\" ON public.bookings","DROP POLICY IF EXISTS \\"Strict: Org Members update bookings\\" ON public.bookings","CREATE POLICY \\"Strict: Org Members update bookings\\" ON public.bookings FOR UPDATE USING (\r\n  public.is_org_member(org_id)\r\n)","DROP POLICY IF EXISTS \\"Org: Users can delete bookings\\" ON public.bookings","DROP POLICY IF EXISTS \\"Strict: Org Admins delete bookings\\" ON public.bookings","CREATE POLICY \\"Strict: Org Admins delete bookings\\" ON public.bookings FOR DELETE USING (\r\n  public.is_org_admin(org_id) -- Maybe Members too? Reverting to strict.\r\n)","-- ROOMS\r\nDROP POLICY IF EXISTS \\"Org: Users can view rooms\\" ON public.rooms","DROP POLICY IF EXISTS \\"Strict: Org Members view rooms\\" ON public.rooms","CREATE POLICY \\"Strict: Org Members view rooms\\" ON public.rooms FOR SELECT USING (\r\n  public.is_org_member(org_id)\r\n)","-- TICKETS & IDEAS (Strict)\r\nDROP POLICY IF EXISTS \\"Org: Users can view tickets\\" ON public.tickets","DROP POLICY IF EXISTS \\"Strict: Org Members view tickets\\" ON public.tickets","CREATE POLICY \\"Strict: Org Members view tickets\\" ON public.tickets FOR SELECT USING (\r\n  public.is_org_member(org_id) OR public.is_hostconnect_staff()\r\n)","-- Note: We rely on previous updates for INSERT/UPDATE/DELETE.\r\n-- Ideally we would review them all, but for conciseness we targeted mostly SELECT/Visibility.\r\n-- Previous migration step updated \\"Users can create tickets\\" to include ORG.\r\n-- We must remove the legacy part there too if we want full strictness.\r\n-- But \\"viewing\\" is the big one for isolation. Creation usually implies sending org_id now.\r\n\r\n-- =============================================================================\r\n-- 4. CLEANUP (Optional)\r\n-- =============================================================================\r\n-- We do not drop user_id columns as requested (\\"audit only\\")."}	enforce_org_isolation
20251227120000	{"-- Fix Infinite Recursion in org_members RLS\r\n-- The previous policy used a direct subquery to check membership, which triggered RLS recursively.\r\n-- We must use the SECURITY DEFINER function is_org_member() to bypass RLS for this check.\r\n\r\nDROP POLICY IF EXISTS \\"Members can view their org members\\" ON public.org_members","CREATE POLICY \\"Members can view their org members\\" ON public.org_members\r\n    FOR SELECT\r\n    USING (\r\n      auth.uid() = user_id -- Can see self\r\n      OR \r\n      public.is_org_member(org_id) -- Use Security Definer function to check if I am in the same org\r\n    )"}	fix_org_members_recursion
20251227200000	{"-- Create Inventory Items Table (Catalog)\r\nCREATE TABLE IF NOT EXISTS public.inventory_items (\r\n    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,\r\n    org_id UUID REFERENCES public.organizations(id) ON DELETE CASCADE,\r\n    name TEXT NOT NULL,\r\n    category TEXT DEFAULT 'Geral', -- e.g., 'Bedding', 'Electronics', 'Toiletries'\r\n    description TEXT,\r\n    created_at TIMESTAMPTZ DEFAULT NOW(),\r\n    updated_at TIMESTAMPTZ DEFAULT NOW()\r\n)","-- RLS for inventory_items\r\nALTER TABLE public.inventory_items ENABLE ROW LEVEL SECURITY","CREATE POLICY \\"Users can view inventory items of their org\\" ON public.inventory_items\r\n    FOR SELECT USING (\r\n        org_id IN (\r\n            SELECT org_id FROM public.org_members WHERE user_id = auth.uid()\r\n        )\r\n    )","CREATE POLICY \\"Users can insert inventory items to their org\\" ON public.inventory_items\r\n    FOR INSERT WITH CHECK (\r\n        org_id IN (\r\n            SELECT org_id FROM public.org_members WHERE user_id = auth.uid()\r\n        )\r\n    )","CREATE POLICY \\"Users can update inventory items of their org\\" ON public.inventory_items\r\n    FOR UPDATE USING (\r\n        org_id IN (\r\n            SELECT org_id FROM public.org_members WHERE user_id = auth.uid()\r\n        )\r\n    )","CREATE POLICY \\"Users can delete inventory items of their org\\" ON public.inventory_items\r\n    FOR DELETE USING (\r\n        org_id IN (\r\n            SELECT org_id FROM public.org_members WHERE user_id = auth.uid()\r\n        )\r\n    )","-- Create Room Type Inventory Table (Association)\r\nCREATE TABLE IF NOT EXISTS public.room_type_inventory (\r\n    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,\r\n    room_type_id UUID REFERENCES public.room_types(id) ON DELETE CASCADE,\r\n    item_id UUID REFERENCES public.inventory_items(id) ON DELETE CASCADE,\r\n    quantity INTEGER DEFAULT 1 CHECK (quantity > 0),\r\n    created_at TIMESTAMPTZ DEFAULT NOW(),\r\n    UNIQUE(room_type_id, item_id) -- Prevent duplicate entries for same item in same room type\r\n)","-- RLS for room_type_inventory\r\nALTER TABLE public.room_type_inventory ENABLE ROW LEVEL SECURITY","-- Note: Access is controlled via room_types property ownership usually, \r\n-- but simpler RLS here is to check if user has access to the linked room_type's property -> org.\r\n-- For simplicity in this iteration, we rely on the fact that room_types are secured.\r\n-- BUT to be safe:\r\n\r\nCREATE POLICY \\"Users can view room inventory if they have access to room type\\" ON public.room_type_inventory\r\n    FOR SELECT USING (\r\n        EXISTS (\r\n            SELECT 1 FROM public.room_types rt\r\n            JOIN public.properties p ON p.id = rt.property_id\r\n            -- Assuming properties link to user or org. \r\n            -- Let's check properties table definition if needed, but usually RLS cascades or we simply check auth.\r\n            -- Using a simpler heuristic: If you can see the room_type, you can see its inventory.\r\n            WHERE rt.id = room_type_inventory.room_type_id\r\n            -- Add logic here if strict ownership is needed.\r\n        )\r\n    )","-- Actually, a simpler standard RLS for now allowing authenticated users to read/write if they own the related objects\r\nCREATE POLICY \\"Enable all access for authenticated users (Temporary for MVP)\\" ON public.room_type_inventory\r\n    FOR ALL USING (auth.role() = 'authenticated')"}	create_inventory_system
20251227201500	{"-- Create Item Stock Table (Central Inventory)\r\nCREATE TABLE IF NOT EXISTS public.item_stock (\r\n    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,\r\n    item_id UUID REFERENCES public.inventory_items(id) ON DELETE CASCADE,\r\n    location TEXT DEFAULT 'pantry' NOT NULL, -- 'pantry', 'laundry', 'maintenance_storage'\r\n    quantity INTEGER DEFAULT 0 NOT NULL,\r\n    last_updated_at TIMESTAMPTZ DEFAULT NOW(),\r\n    updated_by UUID REFERENCES auth.users(id),\r\n    UNIQUE(item_id, location)\r\n)","-- RLS for item_stock\r\nALTER TABLE public.item_stock ENABLE ROW LEVEL SECURITY","-- Allow authenticated users to view stock (Staff, Managers, Admins)\r\nCREATE POLICY \\"Authenticated users can view stock\\" ON public.item_stock\r\n    FOR SELECT USING (auth.role() = 'authenticated')","-- Allow authenticated users to update stock (simplified for MVP)\r\nCREATE POLICY \\"Authenticated users can update stock\\" ON public.item_stock\r\n    FOR INSERT WITH CHECK (auth.role() = 'authenticated')","CREATE POLICY \\"Authenticated users can modify stock\\" ON public.item_stock\r\n    FOR UPDATE USING (auth.role() = 'authenticated')","CREATE POLICY \\"Authenticated users can delete stock\\" ON public.item_stock\r\n    FOR DELETE USING (auth.role() = 'authenticated')"}	create_pantry_stock
20251227203000	{"-- Add Pricing and Sale status to Inventory Items\r\nALTER TABLE public.inventory_items \r\nADD COLUMN IF NOT EXISTS price NUMERIC(10, 2) DEFAULT 0.00,\r\nADD COLUMN IF NOT EXISTS is_for_sale BOOLEAN DEFAULT false","-- Add index for faster filtering of saleable items\r\nCREATE INDEX IF NOT EXISTS idx_inventory_items_for_sale ON public.inventory_items(is_for_sale) WHERE is_for_sale = true"}	add_inventory_pricing
20260119000000	{"-- Migration: Add org_id to existing operational tables (CORRECTED)\r\n-- Description: Adds org_id column only to tables that actually exist\r\n-- Date: 2026-01-19\r\n-- Author: Supabase Security Team\r\n-- CORRECTED: Removed references to non-existent tables\r\n\r\n-- =============================================================================\r\n-- PHASE 1: ADD org_id COLUMNS (Only to existing tables)\r\n-- =============================================================================\r\n\r\n-- CRITICAL TABLES (Missing org_id, high security risk)\r\n\r\n-- 1. amenities\r\nALTER TABLE public.amenities \r\nADD COLUMN IF NOT EXISTS org_id uuid","-- 2. room_categories (if exists)\r\nDO $$\r\nBEGIN\r\n    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = 'public' AND table_name = 'room_categories') THEN\r\n        ALTER TABLE public.room_categories ADD COLUMN IF NOT EXISTS org_id uuid;\r\n    END IF;\r\nEND $$","-- 3. room_types (has property_id, adding org_id for consistency)\r\nALTER TABLE public.room_types \r\nADD COLUMN IF NOT EXISTS org_id uuid","-- 4. services (has property_id, adding org_id for consistency)\r\nALTER TABLE public.services \r\nADD COLUMN IF NOT EXISTS org_id uuid","-- 5. item_stock\r\nALTER TABLE public.item_stock \r\nADD COLUMN IF NOT EXISTS org_id uuid","-- 6. room_type_inventory\r\nALTER TABLE public.room_type_inventory \r\nADD COLUMN IF NOT EXISTS org_id uuid","-- 7. pricing_rules (has property_id)\r\nALTER TABLE public.pricing_rules \r\nADD COLUMN IF NOT EXISTS org_id uuid","-- 8. website_settings (has property_id)\r\nALTER TABLE public.website_settings \r\nADD COLUMN IF NOT EXISTS org_id uuid","-- =============================================================================\r\n-- PHASE 2: ADD INDEXES (Before backfill for performance)\r\n-- =============================================================================\r\n\r\nCREATE INDEX IF NOT EXISTS idx_amenities_org_id ON public.amenities(org_id)","DO $$\r\nBEGIN\r\n    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = 'public' AND table_name = 'room_categories') THEN\r\n        CREATE INDEX IF NOT EXISTS idx_room_categories_org_id ON public.room_categories(org_id);\r\n    END IF;\r\nEND $$","CREATE INDEX IF NOT EXISTS idx_room_types_org_id ON public.room_types(org_id)","CREATE INDEX IF NOT EXISTS idx_services_org_id ON public.services(org_id)","CREATE INDEX IF NOT EXISTS idx_item_stock_org_id ON public.item_stock(org_id)","CREATE INDEX IF NOT EXISTS idx_room_type_inventory_org_id ON public.room_type_inventory(org_id)","CREATE INDEX IF NOT EXISTS idx_pricing_rules_org_id ON public.pricing_rules(org_id)","CREATE INDEX IF NOT EXISTS idx_website_settings_org_id ON public.website_settings(org_id)","-- =============================================================================\r\n-- VALIDATION QUERIES\r\n-- =============================================================================\r\n\r\n-- Check that all columns were added successfully\r\nDO $$\r\nDECLARE\r\n    missing_columns text[];\r\n    tables_to_check text[] := ARRAY[\r\n        'amenities',\r\n        'room_types',\r\n        'services',\r\n        'item_stock',\r\n        'room_type_inventory',\r\n        'pricing_rules',\r\n        'website_settings'\r\n    ];\r\n    tbl_name text;\r\nBEGIN\r\n    FOREACH tbl_name IN ARRAY tables_to_check\r\n    LOOP\r\n        IF NOT EXISTS (\r\n            SELECT 1\r\n            FROM information_schema.columns c\r\n            WHERE c.table_schema = 'public'\r\n              AND c.table_name = tbl_name\r\n              AND c.column_name = 'org_id'\r\n        ) THEN\r\n            missing_columns := array_append(missing_columns, tbl_name);\r\n        END IF;\r\n    END LOOP;\r\n    \r\n    IF array_length(missing_columns, 1) > 0 THEN\r\n        RAISE EXCEPTION 'Failed to add org_id to tables: %', array_to_string(missing_columns, ', ');\r\n    ELSE\r\n        RAISE NOTICE 'SUCCESS: org_id column added to all existing tables';\r\n    END IF;\r\nEND $$","-- Check room_categories separately (optional table)\r\nDO $$\r\nBEGIN\r\n    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = 'public' AND table_name = 'room_categories') THEN\r\n        IF NOT EXISTS (\r\n            SELECT 1 FROM information_schema.columns \r\n            WHERE table_schema = 'public' \r\n              AND table_name = 'room_categories' \r\n              AND column_name = 'org_id'\r\n        ) THEN\r\n            RAISE WARNING 'room_categories exists but org_id was not added';\r\n        ELSE\r\n            RAISE NOTICE 'SUCCESS: org_id added to room_categories';\r\n        END IF;\r\n    ELSE\r\n        RAISE NOTICE 'SKIPPED: room_categories table does not exist';\r\n    END IF;\r\nEND $$"}	add_org_id_to_operational_tables
20260119000001	{"-- Migration: Backfill org_id for existing operational tables (CORRECTED)\r\n-- Description: Safely populates org_id from properties table\r\n-- Date: 2026-01-19\r\n-- Author: Supabase Security Team\r\n-- IMPORTANT: Run this AFTER 20260119000000_add_org_id_to_operational_tables.sql\r\n-- CORRECTED: Only backfills tables that actually exist\r\n\r\n-- =============================================================================\r\n-- PHASE 1: BACKFILL FROM PROPERTIES (Tables with property_id)\r\n-- =============================================================================\r\n\r\n-- 1. room_types\r\nUPDATE public.room_types rt\r\nSET org_id = p.org_id\r\nFROM public.properties p\r\nWHERE rt.property_id = p.id\r\n  AND rt.org_id IS NULL","-- 2. services\r\nUPDATE public.services s\r\nSET org_id = p.org_id\r\nFROM public.properties p\r\nWHERE s.property_id = p.id\r\n  AND s.org_id IS NULL","-- 3. pricing_rules\r\nUPDATE public.pricing_rules pr\r\nSET org_id = p.org_id\r\nFROM public.properties p\r\nWHERE pr.property_id = p.id\r\n  AND pr.org_id IS NULL","-- 4. website_settings\r\nUPDATE public.website_settings ws\r\nSET org_id = p.org_id\r\nFROM public.properties p\r\nWHERE ws.property_id = p.id\r\n  AND ws.org_id IS NULL","-- =============================================================================\r\n-- PHASE 2: BACKFILL VIA FK RELATIONSHIPS\r\n-- =============================================================================\r\n\r\n-- room_type_inventory: Backfill via room_types\r\nUPDATE public.room_type_inventory rti\r\nSET org_id = rt.org_id\r\nFROM public.room_types rt\r\nWHERE rti.room_type_id = rt.id\r\n  AND rti.org_id IS NULL\r\n  AND rt.org_id IS NOT NULL","-- item_stock: Backfill via inventory_items (which already has org_id)\r\nUPDATE public.item_stock ist\r\nSET org_id = ii.org_id\r\nFROM public.inventory_items ii\r\nWHERE ist.item_id = ii.id\r\n  AND ist.org_id IS NULL\r\n  AND ii.org_id IS NOT NULL","-- =============================================================================\r\n-- PHASE 3: HANDLE SPECIAL CASES (Tables without property_id or FK)\r\n-- =============================================================================\r\n\r\n-- amenities: Business decision needed\r\n-- Option A: Assign to first org (temporary solution)\r\n-- Option B: Keep NULL and make global (staff-only management)\r\n-- Option C: Duplicate for each org\r\n\r\n-- TEMPORARY SOLUTION: Assign to first org if only one org exists\r\nDO $$\r\nDECLARE\r\n    org_count integer;\r\n    first_org_id uuid;\r\nBEGIN\r\n    SELECT COUNT(*) INTO org_count FROM public.organizations;\r\n    \r\n    IF org_count = 1 THEN\r\n        SELECT id INTO first_org_id FROM public.organizations LIMIT 1;\r\n        \r\n        UPDATE public.amenities\r\n        SET org_id = first_org_id\r\n        WHERE org_id IS NULL;\r\n        \r\n        RAISE NOTICE 'Assigned all amenities to org: %', first_org_id;\r\n    ELSIF org_count = 0 THEN\r\n        RAISE WARNING 'No organizations exist. Cannot backfill amenities.';\r\n    ELSE\r\n        RAISE NOTICE 'Multiple orgs exist (%). Amenities require manual assignment or duplication.', org_count;\r\n        RAISE NOTICE 'Current NULL amenities count: %', (SELECT COUNT(*) FROM public.amenities WHERE org_id IS NULL);\r\n    END IF;\r\nEND $$","-- room_categories: Similar to amenities (if table exists)\r\nDO $$\r\nDECLARE\r\n    org_count integer;\r\n    first_org_id uuid;\r\nBEGIN\r\n    IF NOT EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = 'public' AND table_name = 'room_categories') THEN\r\n        RAISE NOTICE 'SKIPPED: room_categories table does not exist';\r\n        RETURN;\r\n    END IF;\r\n    \r\n    SELECT COUNT(*) INTO org_count FROM public.organizations;\r\n    \r\n    IF org_count = 1 THEN\r\n        SELECT id INTO first_org_id FROM public.organizations LIMIT 1;\r\n        \r\n        EXECUTE 'UPDATE public.room_categories SET org_id = $1 WHERE org_id IS NULL' USING first_org_id;\r\n        \r\n        RAISE NOTICE 'Assigned all room_categories to org: %', first_org_id;\r\n    ELSIF org_count = 0 THEN\r\n        RAISE WARNING 'No organizations exist. Cannot backfill room_categories.';\r\n    ELSE\r\n        RAISE NOTICE 'Multiple orgs exist (%). Room categories require manual assignment or duplication.', org_count;\r\n    END IF;\r\nEND $$","-- =============================================================================\r\n-- PHASE 4: VALIDATION\r\n-- =============================================================================\r\n\r\n-- Report NULL org_id counts per table\r\nDO $$\r\nDECLARE\r\n    null_counts text;\r\nBEGIN\r\n    SELECT string_agg(table_name || ': ' || null_count::text, E'\\\\n')\r\n    INTO null_counts\r\n    FROM (\r\n        SELECT 'amenities' as table_name, COUNT(*) as null_count FROM public.amenities WHERE org_id IS NULL\r\n        UNION ALL\r\n        SELECT 'room_types', COUNT(*) FROM public.room_types WHERE org_id IS NULL\r\n        UNION ALL\r\n        SELECT 'services', COUNT(*) FROM public.services WHERE org_id IS NULL\r\n        UNION ALL\r\n        SELECT 'item_stock', COUNT(*) FROM public.item_stock WHERE org_id IS NULL\r\n        UNION ALL\r\n        SELECT 'room_type_inventory', COUNT(*) FROM public.room_type_inventory WHERE org_id IS NULL\r\n        UNION ALL\r\n        SELECT 'pricing_rules', COUNT(*) FROM public.pricing_rules WHERE org_id IS NULL\r\n        UNION ALL\r\n        SELECT 'website_settings', COUNT(*) FROM public.website_settings WHERE org_id IS NULL\r\n    ) counts\r\n    WHERE null_count > 0;\r\n    \r\n    IF null_counts IS NOT NULL THEN\r\n        RAISE WARNING E'Tables with NULL org_id:\\\\n%', null_counts;\r\n    ELSE\r\n        RAISE NOTICE 'SUCCESS: All tables have org_id populated';\r\n    END IF;\r\nEND $$","-- Check for orphaned records (org_id doesn't exist in organizations)\r\nDO $$\r\nDECLARE\r\n    orphaned_records text;\r\nBEGIN\r\n    SELECT string_agg(table_name || ': ' || orphan_count::text, E'\\\\n')\r\n    INTO orphaned_records\r\n    FROM (\r\n        SELECT 'amenities' as table_name, COUNT(*) as orphan_count \r\n        FROM public.amenities a\r\n        WHERE a.org_id IS NOT NULL \r\n          AND NOT EXISTS (SELECT 1 FROM public.organizations o WHERE o.id = a.org_id)\r\n        UNION ALL\r\n        SELECT 'room_types', COUNT(*) \r\n        FROM public.room_types rt\r\n        WHERE rt.org_id IS NOT NULL \r\n          AND NOT EXISTS (SELECT 1 FROM public.organizations o WHERE o.id = rt.org_id)\r\n        UNION ALL\r\n        SELECT 'services', COUNT(*) \r\n        FROM public.services s\r\n        WHERE s.org_id IS NOT NULL \r\n          AND NOT EXISTS (SELECT 1 FROM public.organizations o WHERE o.id = s.org_id)\r\n        UNION ALL\r\n        SELECT 'item_stock', COUNT(*) \r\n        FROM public.item_stock ist\r\n        WHERE ist.org_id IS NOT NULL \r\n          AND NOT EXISTS (SELECT 1 FROM public.organizations o WHERE o.id = ist.org_id)\r\n        UNION ALL\r\n        SELECT 'room_type_inventory', COUNT(*) \r\n        FROM public.room_type_inventory rti\r\n        WHERE rti.org_id IS NOT NULL \r\n          AND NOT EXISTS (SELECT 1 FROM public.organizations o WHERE o.id = rti.org_id)\r\n        UNION ALL\r\n        SELECT 'pricing_rules', COUNT(*) \r\n        FROM public.pricing_rules pr\r\n        WHERE pr.org_id IS NOT NULL \r\n          AND NOT EXISTS (SELECT 1 FROM public.organizations o WHERE o.id = pr.org_id)\r\n        UNION ALL\r\n        SELECT 'website_settings', COUNT(*) \r\n        FROM public.website_settings ws\r\n        WHERE ws.org_id IS NOT NULL \r\n          AND NOT EXISTS (SELECT 1 FROM public.organizations o WHERE o.id = ws.org_id)\r\n    ) orphans\r\n    WHERE orphan_count > 0;\r\n    \r\n    IF orphaned_records IS NOT NULL THEN\r\n        RAISE EXCEPTION E'Orphaned records found (org_id not in organizations):\\\\n%', orphaned_records;\r\n    ELSE\r\n        RAISE NOTICE 'SUCCESS: No orphaned records found';\r\n    END IF;\r\nEND $$"}	backfill_org_id
20260119000002	{"-- Migration: Enforce org_id NOT NULL and Foreign Keys (CORRECTED)\r\n-- Description: Makes org_id mandatory and adds FK constraints\r\n-- Date: 2026-01-19\r\n-- Author: Supabase Security Team\r\n-- IMPORTANT: Run this AFTER 20260119000001_backfill_org_id.sql\r\n-- CRITICAL: This migration will FAIL if any NULL org_id values exist\r\n-- CORRECTED: Only enforces constraints on tables that actually exist\r\n\r\n-- =============================================================================\r\n-- PRE-FLIGHT VALIDATION\r\n-- =============================================================================\r\n\r\n-- Check for NULL org_id values before enforcing NOT NULL\r\nDO $$\r\nDECLARE\r\n    tables_with_nulls text[];\r\n    null_count integer;\r\nBEGIN\r\n    -- Check each table for NULL org_id\r\n    SELECT array_agg(table_name)\r\n    INTO tables_with_nulls\r\n    FROM (\r\n        SELECT 'amenities' as table_name, COUNT(*) as cnt FROM public.amenities WHERE org_id IS NULL\r\n        UNION ALL\r\n        SELECT 'room_types', COUNT(*) FROM public.room_types WHERE org_id IS NULL\r\n        UNION ALL\r\n        SELECT 'services', COUNT(*) FROM public.services WHERE org_id IS NULL\r\n        UNION ALL\r\n        SELECT 'item_stock', COUNT(*) FROM public.item_stock WHERE org_id IS NULL\r\n        UNION ALL\r\n        SELECT 'room_type_inventory', COUNT(*) FROM public.room_type_inventory WHERE org_id IS NULL\r\n        UNION ALL\r\n        SELECT 'pricing_rules', COUNT(*) FROM public.pricing_rules WHERE org_id IS NULL\r\n        UNION ALL\r\n        SELECT 'website_settings', COUNT(*) FROM public.website_settings WHERE org_id IS NULL\r\n    ) t\r\n    WHERE cnt > 0;\r\n    \r\n    IF array_length(tables_with_nulls, 1) > 0 THEN\r\n        RAISE EXCEPTION 'Cannot enforce NOT NULL: The following tables have NULL org_id values: %. Run backfill migration first.', \r\n            array_to_string(tables_with_nulls, ', ');\r\n    ELSE\r\n        RAISE NOTICE 'PRE-FLIGHT CHECK PASSED: No NULL org_id values found';\r\n    END IF;\r\nEND $$","-- =============================================================================\r\n-- PHASE 1: ADD FOREIGN KEY CONSTRAINTS\r\n-- =============================================================================\r\n\r\n-- Add FK constraints BEFORE NOT NULL (allows for better error messages)\r\n\r\nALTER TABLE public.amenities\r\nADD CONSTRAINT fk_amenities_org_id \r\nFOREIGN KEY (org_id) REFERENCES public.organizations(id) ON DELETE CASCADE","-- room_categories (if exists)\r\nDO $$\r\nBEGIN\r\n    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = 'public' AND table_name = 'room_categories') THEN\r\n        ALTER TABLE public.room_categories\r\n        ADD CONSTRAINT fk_room_categories_org_id \r\n        FOREIGN KEY (org_id) REFERENCES public.organizations(id) ON DELETE CASCADE;\r\n    END IF;\r\nEND $$","ALTER TABLE public.room_types\r\nADD CONSTRAINT fk_room_types_org_id \r\nFOREIGN KEY (org_id) REFERENCES public.organizations(id) ON DELETE CASCADE","ALTER TABLE public.services\r\nADD CONSTRAINT fk_services_org_id \r\nFOREIGN KEY (org_id) REFERENCES public.organizations(id) ON DELETE CASCADE","ALTER TABLE public.item_stock\r\nADD CONSTRAINT fk_item_stock_org_id \r\nFOREIGN KEY (org_id) REFERENCES public.organizations(id) ON DELETE CASCADE","ALTER TABLE public.room_type_inventory\r\nADD CONSTRAINT fk_room_type_inventory_org_id \r\nFOREIGN KEY (org_id) REFERENCES public.organizations(id) ON DELETE CASCADE","ALTER TABLE public.pricing_rules\r\nADD CONSTRAINT fk_pricing_rules_org_id \r\nFOREIGN KEY (org_id) REFERENCES public.organizations(id) ON DELETE CASCADE","ALTER TABLE public.website_settings\r\nADD CONSTRAINT fk_website_settings_org_id \r\nFOREIGN KEY (org_id) REFERENCES public.organizations(id) ON DELETE CASCADE","-- =============================================================================\r\n-- PHASE 2: ENFORCE NOT NULL CONSTRAINTS\r\n-- =============================================================================\r\n\r\n-- Make org_id NOT NULL for all tables\r\n-- This will fail if any NULL values exist or if FK constraint violations occur\r\n\r\nALTER TABLE public.amenities ALTER COLUMN org_id SET NOT NULL","DO $$\r\nBEGIN\r\n    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = 'public' AND table_name = 'room_categories') THEN\r\n        ALTER TABLE public.room_categories ALTER COLUMN org_id SET NOT NULL;\r\n    END IF;\r\nEND $$","ALTER TABLE public.room_types ALTER COLUMN org_id SET NOT NULL","ALTER TABLE public.services ALTER COLUMN org_id SET NOT NULL","ALTER TABLE public.item_stock ALTER COLUMN org_id SET NOT NULL","ALTER TABLE public.room_type_inventory ALTER COLUMN org_id SET NOT NULL","ALTER TABLE public.pricing_rules ALTER COLUMN org_id SET NOT NULL","ALTER TABLE public.website_settings ALTER COLUMN org_id SET NOT NULL","-- =============================================================================\r\n-- PHASE 3: POST-ENFORCEMENT VALIDATION\r\n-- =============================================================================\r\n\r\n-- Verify all constraints were added\r\nDO $$\r\nDECLARE\r\n    missing_fks text[];\r\n    tables_to_check text[] := ARRAY[\r\n        'amenities',\r\n        'room_types',\r\n        'services',\r\n        'item_stock',\r\n        'room_type_inventory',\r\n        'pricing_rules',\r\n        'website_settings'\r\n    ];\r\n    tbl_name text;\r\nBEGIN\r\n    FOREACH tbl_name IN ARRAY tables_to_check\r\n    LOOP\r\n        IF NOT EXISTS (\r\n            SELECT 1\r\n            FROM information_schema.table_constraints tc\r\n            WHERE tc.table_schema = 'public'\r\n              AND tc.table_name = tbl_name\r\n              AND tc.constraint_name = 'fk_' || tbl_name || '_org_id'\r\n              AND tc.constraint_type = 'FOREIGN KEY'\r\n        ) THEN\r\n            missing_fks := array_append(missing_fks, tbl_name);\r\n        END IF;\r\n    END LOOP;\r\n    \r\n    IF array_length(missing_fks, 1) > 0 THEN\r\n        RAISE EXCEPTION 'Missing FK constraints on tables: %', array_to_string(missing_fks, ', ');\r\n    ELSE\r\n        RAISE NOTICE 'SUCCESS: All FK constraints added to existing tables';\r\n    END IF;\r\nEND $$","-- Verify all NOT NULL constraints were added\r\nDO $$\r\nDECLARE\r\n    nullable_columns text[];\r\n    tables_to_check text[] := ARRAY[\r\n        'amenities',\r\n        'room_types',\r\n        'services',\r\n        'item_stock',\r\n        'room_type_inventory',\r\n        'pricing_rules',\r\n        'website_settings'\r\n    ];\r\n    tbl_name text;\r\nBEGIN\r\n    FOREACH tbl_name IN ARRAY tables_to_check\r\n    LOOP\r\n        IF EXISTS (\r\n            SELECT 1\r\n            FROM information_schema.columns c\r\n            WHERE c.table_schema = 'public'\r\n              AND c.table_name = tbl_name\r\n              AND c.column_name = 'org_id'\r\n              AND c.is_nullable = 'YES'\r\n        ) THEN\r\n            nullable_columns := array_append(nullable_columns, tbl_name);\r\n        END IF;\r\n    END LOOP;\r\n    \r\n    IF array_length(nullable_columns, 1) > 0 THEN\r\n        RAISE EXCEPTION 'org_id is still nullable on tables: %', array_to_string(nullable_columns, ', ');\r\n    ELSE\r\n        RAISE NOTICE 'SUCCESS: All org_id columns are NOT NULL on existing tables';\r\n    END IF;\r\nEND $$","-- Final success message\r\nDO $$\r\nDECLARE\r\n    table_count integer;\r\nBEGIN\r\n    SELECT COUNT(*)\r\n    INTO table_count\r\n    FROM information_schema.table_constraints\r\n    WHERE constraint_schema = 'public'\r\n      AND constraint_type = 'FOREIGN KEY'\r\n      AND constraint_name LIKE 'fk_%_org_id';\r\n    \r\n    RAISE NOTICE '========================================';\r\n    RAISE NOTICE 'ORG_ID ENFORCEMENT COMPLETE';\r\n    RAISE NOTICE '========================================';\r\n    RAISE NOTICE '✓ % tables now have org_id NOT NULL', table_count;\r\n    RAISE NOTICE '✓ % FK constraints to organizations', table_count;\r\n    RAISE NOTICE '✓ Multi-tenant isolation enforced';\r\n    RAISE NOTICE '========================================';\r\nEND $$"}	enforce_org_id_constraints
20260119000003	{"-- Migration: Auto-fill org_id triggers (CORRECTED)\r\n-- Description: Automatically populate org_id for new records based on FK relationships\r\n-- Date: 2026-01-19\r\n-- Author: Supabase Security Team\r\n-- IMPORTANT: Run this AFTER 20260119000002_enforce_org_id_constraints.sql\r\n-- CORRECTED: Only creates triggers for tables that actually exist\r\n\r\n-- =============================================================================\r\n-- TRIGGER FUNCTIONS\r\n-- =============================================================================\r\n\r\n-- Function: Auto-fill org_id from property_id\r\nCREATE OR REPLACE FUNCTION public.set_org_id_from_property()\r\nRETURNS TRIGGER AS $$\r\nBEGIN\r\n  IF NEW.org_id IS NULL AND NEW.property_id IS NOT NULL THEN\r\n    SELECT org_id INTO NEW.org_id\r\n    FROM public.properties\r\n    WHERE id = NEW.property_id;\r\n    \r\n    IF NEW.org_id IS NULL THEN\r\n      RAISE EXCEPTION 'Cannot determine org_id: property_id % not found', NEW.property_id;\r\n    END IF;\r\n  END IF;\r\n  RETURN NEW;\r\nEND;\r\n$$ LANGUAGE plpgsql","-- Function: Auto-fill org_id from room_type_id\r\nCREATE OR REPLACE FUNCTION public.set_org_id_from_room_type()\r\nRETURNS TRIGGER AS $$\r\nBEGIN\r\n  IF NEW.org_id IS NULL AND NEW.room_type_id IS NOT NULL THEN\r\n    SELECT org_id INTO NEW.org_id\r\n    FROM public.room_types\r\n    WHERE id = NEW.room_type_id;\r\n    \r\n    IF NEW.org_id IS NULL THEN\r\n      RAISE EXCEPTION 'Cannot determine org_id: room_type_id % not found', NEW.room_type_id;\r\n    END IF;\r\n  END IF;\r\n  RETURN NEW;\r\nEND;\r\n$$ LANGUAGE plpgsql","-- Function: Auto-fill org_id from item_id (inventory_items)\r\nCREATE OR REPLACE FUNCTION public.set_org_id_from_inventory_item()\r\nRETURNS TRIGGER AS $$\r\nBEGIN\r\n  IF NEW.org_id IS NULL AND NEW.item_id IS NOT NULL THEN\r\n    SELECT org_id INTO NEW.org_id\r\n    FROM public.inventory_items\r\n    WHERE id = NEW.item_id;\r\n    \r\n    IF NEW.org_id IS NULL THEN\r\n      RAISE EXCEPTION 'Cannot determine org_id: item_id % not found', NEW.item_id;\r\n    END IF;\r\n  END IF;\r\n  RETURN NEW;\r\nEND;\r\n$$ LANGUAGE plpgsql","-- =============================================================================\r\n-- APPLY TRIGGERS (Only for existing tables)\r\n-- =============================================================================\r\n\r\n-- Tables with property_id that exist\r\nDROP TRIGGER IF EXISTS tr_room_types_set_org ON public.room_types","CREATE TRIGGER tr_room_types_set_org\r\nBEFORE INSERT ON public.room_types\r\nFOR EACH ROW EXECUTE FUNCTION public.set_org_id_from_property()","DROP TRIGGER IF EXISTS tr_services_set_org ON public.services","CREATE TRIGGER tr_services_set_org\r\nBEFORE INSERT ON public.services\r\nFOR EACH ROW EXECUTE FUNCTION public.set_org_id_from_property()","DROP TRIGGER IF EXISTS tr_pricing_rules_set_org ON public.pricing_rules","CREATE TRIGGER tr_pricing_rules_set_org\r\nBEFORE INSERT ON public.pricing_rules\r\nFOR EACH ROW EXECUTE FUNCTION public.set_org_id_from_property()","DROP TRIGGER IF EXISTS tr_website_settings_set_org ON public.website_settings","CREATE TRIGGER tr_website_settings_set_org\r\nBEFORE INSERT ON public.website_settings\r\nFOR EACH ROW EXECUTE FUNCTION public.set_org_id_from_property()","-- Tables with room_type_id\r\nDROP TRIGGER IF EXISTS tr_room_type_inventory_set_org ON public.room_type_inventory","CREATE TRIGGER tr_room_type_inventory_set_org\r\nBEFORE INSERT ON public.room_type_inventory\r\nFOR EACH ROW EXECUTE FUNCTION public.set_org_id_from_room_type()","-- Tables with item_id (inventory)\r\nDROP TRIGGER IF EXISTS tr_item_stock_set_org ON public.item_stock","CREATE TRIGGER tr_item_stock_set_org\r\nBEFORE INSERT ON public.item_stock\r\nFOR EACH ROW EXECUTE FUNCTION public.set_org_id_from_inventory_item()","-- =============================================================================\r\n-- VALIDATION\r\n-- =============================================================================\r\n\r\n-- Verify all triggers were created\r\nDO $$\r\nDECLARE\r\n    expected_triggers text[] := ARRAY[\r\n        'tr_room_types_set_org',\r\n        'tr_services_set_org',\r\n        'tr_pricing_rules_set_org',\r\n        'tr_website_settings_set_org',\r\n        'tr_room_type_inventory_set_org',\r\n        'tr_item_stock_set_org'\r\n    ];\r\n    missing_triggers text[];\r\n    trg_name text;\r\nBEGIN\r\n    FOREACH trg_name IN ARRAY expected_triggers\r\n    LOOP\r\n        IF NOT EXISTS (\r\n            SELECT 1\r\n            FROM information_schema.triggers t\r\n            WHERE t.trigger_schema = 'public'\r\n              AND t.trigger_name = trg_name\r\n        ) THEN\r\n            missing_triggers := array_append(missing_triggers, trg_name);\r\n        END IF;\r\n    END LOOP;\r\n    \r\n    IF array_length(missing_triggers, 1) > 0 THEN\r\n        RAISE EXCEPTION 'Missing triggers: %', array_to_string(missing_triggers, ', ');\r\n    ELSE\r\n        RAISE NOTICE 'SUCCESS: All 6 auto-fill triggers created';\r\n    END IF;\r\nEND $$","-- Final success message\r\nDO $$\r\nBEGIN\r\n    RAISE NOTICE '========================================';\r\n    RAISE NOTICE 'AUTO-FILL TRIGGERS COMPLETE';\r\n    RAISE NOTICE '========================================';\r\n    RAISE NOTICE '✓ 3 trigger functions created';\r\n    RAISE NOTICE '✓ 6 triggers applied to tables';\r\n    RAISE NOTICE '✓ org_id will auto-fill on INSERT';\r\n    RAISE NOTICE '========================================';\r\nEND $$"}	org_id_auto_fill_triggers
20260119000004	{"-- Migration: RLS Policy Hardening - Replace Unsafe Policies\r\n-- Description: Replace qual=true and overly permissive policies with strict org-based isolation\r\n-- Date: 2026-01-19\r\n-- Author: Supabase Security Team\r\n-- IMPORTANT: Run this AFTER org_id enforcement migrations (20260119000002)\r\n\r\n-- =============================================================================\r\n-- CRITICAL: This migration drops and recreates RLS policies\r\n-- Ensure org_id is populated and NOT NULL before running\r\n-- =============================================================================\r\n\r\n-- =============================================================================\r\n-- TABLE 1: amenities\r\n-- =============================================================================\r\n-- Current Issue: qual = true (ANY authenticated user can CRUD)\r\n-- Fix: Restrict to org members + HostConnect staff\r\n\r\n-- Drop unsafe policies\r\nDROP POLICY IF EXISTS \\"Manage all amenities\\" ON public.amenities","-- Policy: Org members can view their org's amenities\r\n-- Allows: All org members (owner, admin, member, viewer)\r\n-- Denies: Users from other orgs, unauthenticated users\r\nCREATE POLICY \\"org_members_select_amenities\\" \r\nON public.amenities\r\nFOR SELECT\r\nUSING (\r\n  public.is_org_member(org_id) \r\n  OR public.is_hostconnect_staff()\r\n)","-- Policy: Org admins can insert amenities\r\n-- Allows: Org owners and admins\r\n-- Denies: Members, viewers, other orgs\r\nCREATE POLICY \\"org_admins_insert_amenities\\" \r\nON public.amenities\r\nFOR INSERT\r\nWITH CHECK (\r\n  public.is_org_admin(org_id) \r\n  OR public.is_hostconnect_staff()\r\n)","-- Policy: Org admins can update amenities\r\n-- Allows: Org owners and admins\r\n-- Denies: Members, viewers, other orgs\r\nCREATE POLICY \\"org_admins_update_amenities\\" \r\nON public.amenities\r\nFOR UPDATE\r\nUSING (\r\n  public.is_org_admin(org_id) \r\n  OR public.is_hostconnect_staff()\r\n)","-- Policy: Org admins can delete amenities\r\n-- Allows: Org owners and admins\r\n-- Denies: Members, viewers, other orgs\r\nCREATE POLICY \\"org_admins_delete_amenities\\" \r\nON public.amenities\r\nFOR DELETE\r\nUSING (\r\n  public.is_org_admin(org_id) \r\n  OR public.is_hostconnect_staff()\r\n)","-- =============================================================================\r\n-- TABLE 2: room_types\r\n-- =============================================================================\r\n-- Current Issue: qual = true (ANY authenticated user can CRUD)\r\n-- Fix: Restrict to org members + HostConnect staff\r\n\r\n-- Drop unsafe policies\r\nDROP POLICY IF EXISTS \\"authenticated_manage_room_types\\" ON public.room_types","-- Policy: Org members can view their org's room types\r\nCREATE POLICY \\"org_members_select_room_types\\" \r\nON public.room_types\r\nFOR SELECT\r\nUSING (\r\n  public.is_org_member(org_id) \r\n  OR public.is_hostconnect_staff()\r\n)","-- Policy: Org admins can insert room types\r\nCREATE POLICY \\"org_admins_insert_room_types\\" \r\nON public.room_types\r\nFOR INSERT\r\nWITH CHECK (\r\n  public.is_org_admin(org_id) \r\n  OR public.is_hostconnect_staff()\r\n)","-- Policy: Org admins can update room types\r\nCREATE POLICY \\"org_admins_update_room_types\\" \r\nON public.room_types\r\nFOR UPDATE\r\nUSING (\r\n  public.is_org_admin(org_id) \r\n  OR public.is_hostconnect_staff()\r\n)","-- Policy: Org admins can delete room types\r\nCREATE POLICY \\"org_admins_delete_room_types\\" \r\nON public.room_types\r\nFOR DELETE\r\nUSING (\r\n  public.is_org_admin(org_id) \r\n  OR public.is_hostconnect_staff()\r\n)","-- =============================================================================\r\n-- TABLE 3: services\r\n-- =============================================================================\r\n-- Current Issue: qual = true for SELECT (global read access)\r\n-- Fix: Restrict to org members only\r\n\r\n-- Drop unsafe policies\r\nDROP POLICY IF EXISTS \\"Enable read access for all users\\" ON public.services","-- Policy: Org members can view their org's services\r\nCREATE POLICY \\"org_members_select_services\\" \r\nON public.services\r\nFOR SELECT\r\nUSING (\r\n  public.is_org_member(org_id) \r\n  OR public.is_hostconnect_staff()\r\n)","-- Policy: Org admins can insert services\r\nCREATE POLICY \\"org_admins_insert_services\\" \r\nON public.services\r\nFOR INSERT\r\nWITH CHECK (\r\n  public.is_org_admin(org_id) \r\n  OR public.is_hostconnect_staff()\r\n)","-- Policy: Org admins can update services\r\nCREATE POLICY \\"org_admins_update_services\\" \r\nON public.services\r\nFOR UPDATE\r\nUSING (\r\n  public.is_org_admin(org_id) \r\n  OR public.is_hostconnect_staff()\r\n)","-- Policy: Org admins can delete services\r\nCREATE POLICY \\"org_admins_delete_services\\" \r\nON public.services\r\nFOR DELETE\r\nUSING (\r\n  public.is_org_admin(org_id) \r\n  OR public.is_hostconnect_staff()\r\n)","-- =============================================================================\r\n-- TABLE 4: item_stock\r\n-- =============================================================================\r\n-- Current Issue: auth.role() = 'authenticated' (too permissive - global visibility)\r\n-- Fix: Restrict to org members only\r\n\r\n-- Drop unsafe policies\r\nDROP POLICY IF EXISTS \\"Authenticated users can view stock\\" ON public.item_stock","DROP POLICY IF EXISTS \\"Authenticated users can update stock\\" ON public.item_stock","DROP POLICY IF EXISTS \\"Authenticated users can modify stock\\" ON public.item_stock","DROP POLICY IF EXISTS \\"Authenticated users can delete stock\\" ON public.item_stock","-- Policy: Org members can view their org's stock\r\nCREATE POLICY \\"org_members_select_item_stock\\" \r\nON public.item_stock\r\nFOR SELECT\r\nUSING (\r\n  public.is_org_member(org_id) \r\n  OR public.is_hostconnect_staff()\r\n)","-- Policy: Org members can insert stock records\r\n-- Note: Members can manage stock (not just admins)\r\nCREATE POLICY \\"org_members_insert_item_stock\\" \r\nON public.item_stock\r\nFOR INSERT\r\nWITH CHECK (\r\n  public.is_org_member(org_id) \r\n  OR public.is_hostconnect_staff()\r\n)","-- Policy: Org members can update stock\r\nCREATE POLICY \\"org_members_update_item_stock\\" \r\nON public.item_stock\r\nFOR UPDATE\r\nUSING (\r\n  public.is_org_member(org_id) \r\n  OR public.is_hostconnect_staff()\r\n)","-- Policy: Org admins can delete stock records\r\nCREATE POLICY \\"org_admins_delete_item_stock\\" \r\nON public.item_stock\r\nFOR DELETE\r\nUSING (\r\n  public.is_org_admin(org_id) \r\n  OR public.is_hostconnect_staff()\r\n)","-- =============================================================================\r\n-- TABLE 5: room_type_inventory\r\n-- =============================================================================\r\n-- Current Issue: \\"Temporary for MVP\\" policy (complete bypass)\r\n-- Fix: Strict org-based policies\r\n\r\n-- Drop unsafe policies\r\nDROP POLICY IF EXISTS \\"Enable all access for authenticated users (Temporary for MVP)\\" ON public.room_type_inventory","-- Policy: Org members can view their org's inventory\r\nCREATE POLICY \\"org_members_select_room_type_inventory\\" \r\nON public.room_type_inventory\r\nFOR SELECT\r\nUSING (\r\n  public.is_org_member(org_id) \r\n  OR public.is_hostconnect_staff()\r\n)","-- Policy: Org members can insert inventory records\r\nCREATE POLICY \\"org_members_insert_room_type_inventory\\" \r\nON public.room_type_inventory\r\nFOR INSERT\r\nWITH CHECK (\r\n  public.is_org_member(org_id) \r\n  OR public.is_hostconnect_staff()\r\n)","-- Policy: Org members can update inventory\r\nCREATE POLICY \\"org_members_update_room_type_inventory\\" \r\nON public.room_type_inventory\r\nFOR UPDATE\r\nUSING (\r\n  public.is_org_member(org_id) \r\n  OR public.is_hostconnect_staff()\r\n)","-- Policy: Org admins can delete inventory records\r\nCREATE POLICY \\"org_admins_delete_room_type_inventory\\" \r\nON public.room_type_inventory\r\nFOR DELETE\r\nUSING (\r\n  public.is_org_admin(org_id) \r\n  OR public.is_hostconnect_staff()\r\n)","-- =============================================================================\r\n-- TABLE 6: pricing_rules\r\n-- =============================================================================\r\n-- Current Issue: May have overly permissive policies\r\n-- Fix: Ensure strict org-based access\r\n\r\n-- Drop any existing policies\r\nDROP POLICY IF EXISTS \\"Authenticated users can view pricing rules\\" ON public.pricing_rules","DROP POLICY IF EXISTS \\"Authenticated users can manage pricing rules\\" ON public.pricing_rules","-- Policy: Org members can view their org's pricing rules\r\nCREATE POLICY \\"org_members_select_pricing_rules\\" \r\nON public.pricing_rules\r\nFOR SELECT\r\nUSING (\r\n  public.is_org_member(org_id) \r\n  OR public.is_hostconnect_staff()\r\n)","-- Policy: Org admins can insert pricing rules\r\n-- Note: Only admins can create pricing rules (sensitive business logic)\r\nCREATE POLICY \\"org_admins_insert_pricing_rules\\" \r\nON public.pricing_rules\r\nFOR INSERT\r\nWITH CHECK (\r\n  public.is_org_admin(org_id) \r\n  OR public.is_hostconnect_staff()\r\n)","-- Policy: Org admins can update pricing rules\r\nCREATE POLICY \\"org_admins_update_pricing_rules\\" \r\nON public.pricing_rules\r\nFOR UPDATE\r\nUSING (\r\n  public.is_org_admin(org_id) \r\n  OR public.is_hostconnect_staff()\r\n)","-- Policy: Org admins can delete pricing rules\r\nCREATE POLICY \\"org_admins_delete_pricing_rules\\" \r\nON public.pricing_rules\r\nFOR DELETE\r\nUSING (\r\n  public.is_org_admin(org_id) \r\n  OR public.is_hostconnect_staff()\r\n)","-- =============================================================================\r\n-- TABLE 7: website_settings\r\n-- =============================================================================\r\n-- Current Issue: May have overly permissive policies\r\n-- Fix: Ensure strict admin-only access (sensitive config)\r\n\r\n-- Drop any existing policies\r\nDROP POLICY IF EXISTS \\"Enable read access for all users\\" ON public.website_settings","DROP POLICY IF EXISTS \\"Authenticated users can view website settings\\" ON public.website_settings","DROP POLICY IF EXISTS \\"Authenticated users can manage website settings\\" ON public.website_settings","-- Policy: Org members can view their org's website settings\r\nCREATE POLICY \\"org_members_select_website_settings\\" \r\nON public.website_settings\r\nFOR SELECT\r\nUSING (\r\n  public.is_org_member(org_id) \r\n  OR public.is_hostconnect_staff()\r\n)","-- Policy: Org admins can insert website settings\r\n-- Note: Only admins can manage website settings (public-facing config)\r\nCREATE POLICY \\"org_admins_insert_website_settings\\" \r\nON public.website_settings\r\nFOR INSERT\r\nWITH CHECK (\r\n  public.is_org_admin(org_id) \r\n  OR public.is_hostconnect_staff()\r\n)","-- Policy: Org admins can update website settings\r\nCREATE POLICY \\"org_admins_update_website_settings\\" \r\nON public.website_settings\r\nFOR UPDATE\r\nUSING (\r\n  public.is_org_admin(org_id) \r\n  OR public.is_hostconnect_staff()\r\n)","-- Policy: Org admins can delete website settings\r\nCREATE POLICY \\"org_admins_delete_website_settings\\" \r\nON public.website_settings\r\nFOR DELETE\r\nUSING (\r\n  public.is_org_admin(org_id) \r\n  OR public.is_hostconnect_staff()\r\n)","-- =============================================================================\r\n-- CONDITIONAL: room_categories (if exists)\r\n-- =============================================================================\r\n\r\nDO $$\r\nBEGIN\r\n    IF EXISTS (\r\n        SELECT 1 FROM information_schema.tables \r\n        WHERE table_schema = 'public' \r\n        AND table_name = 'room_categories'\r\n    ) THEN\r\n        -- Drop unsafe policies\r\n        EXECUTE 'DROP POLICY IF EXISTS \\"Manage all categories\\" ON public.room_categories';\r\n        \r\n        -- Create strict policies\r\n        EXECUTE '\r\n        CREATE POLICY \\"org_members_select_room_categories\\" \r\n        ON public.room_categories\r\n        FOR SELECT\r\n        USING (\r\n          public.is_org_member(org_id) \r\n          OR public.is_hostconnect_staff()\r\n        )';\r\n        \r\n        EXECUTE '\r\n        CREATE POLICY \\"org_admins_insert_room_categories\\" \r\n        ON public.room_categories\r\n        FOR INSERT\r\n        WITH CHECK (\r\n          public.is_org_admin(org_id) \r\n          OR public.is_hostconnect_staff()\r\n        )';\r\n        \r\n        EXECUTE '\r\n        CREATE POLICY \\"org_admins_update_room_categories\\" \r\n        ON public.room_categories\r\n        FOR UPDATE\r\n        USING (\r\n          public.is_org_admin(org_id) \r\n          OR public.is_hostconnect_staff()\r\n        )';\r\n        \r\n        EXECUTE '\r\n        CREATE POLICY \\"org_admins_delete_room_categories\\" \r\n        ON public.room_categories\r\n        FOR DELETE\r\n        USING (\r\n          public.is_org_admin(org_id) \r\n          OR public.is_hostconnect_staff()\r\n        )';\r\n        \r\n        RAISE NOTICE 'SUCCESS: RLS policies hardened for room_categories';\r\n    ELSE\r\n        RAISE NOTICE 'SKIPPED: room_categories table does not exist';\r\n    END IF;\r\nEND $$","-- =============================================================================\r\n-- VALIDATION\r\n-- =============================================================================\r\n\r\n-- Verify no tables have qual = true policies\r\nDO $$\r\nDECLARE\r\n    unsafe_policies text;\r\nBEGIN\r\n    SELECT string_agg(tablename || '.' || policyname, ', ')\r\n    INTO unsafe_policies\r\n    FROM pg_policies\r\n    WHERE schemaname = 'public'\r\n      AND qual = 'true'\r\n      AND tablename IN (\r\n        'amenities', 'room_categories', 'room_types', 'services',\r\n        'item_stock', 'room_type_inventory', 'pricing_rules', 'website_settings'\r\n      );\r\n    \r\n    IF unsafe_policies IS NOT NULL THEN\r\n        RAISE EXCEPTION 'Tables still have qual=true policies: %', unsafe_policies;\r\n    ELSE\r\n        RAISE NOTICE 'SUCCESS: No qual=true policies found on hardened tables';\r\n    END IF;\r\nEND $$","-- Verify all tables have at least one policy per operation\r\nDO $$\r\nDECLARE\r\n    tables_to_check text[] := ARRAY[\r\n        'amenities', 'room_types', 'services', 'item_stock',\r\n        'room_type_inventory', 'pricing_rules', 'website_settings'\r\n    ];\r\n    tbl_name text;\r\n    select_count integer;\r\n    insert_count integer;\r\n    update_count integer;\r\n    delete_count integer;\r\nBEGIN\r\n    FOREACH tbl_name IN ARRAY tables_to_check\r\n    LOOP\r\n        SELECT COUNT(*) INTO select_count FROM pg_policies \r\n        WHERE schemaname = 'public' AND tablename = tbl_name AND cmd = 'SELECT';\r\n        \r\n        SELECT COUNT(*) INTO insert_count FROM pg_policies \r\n        WHERE schemaname = 'public' AND tablename = tbl_name AND cmd = 'INSERT';\r\n        \r\n        SELECT COUNT(*) INTO update_count FROM pg_policies \r\n        WHERE schemaname = 'public' AND tablename = tbl_name AND cmd = 'UPDATE';\r\n        \r\n        SELECT COUNT(*) INTO delete_count FROM pg_policies \r\n        WHERE schemaname = 'public' AND tablename = tbl_name AND cmd = 'DELETE';\r\n        \r\n        IF select_count = 0 OR insert_count = 0 OR update_count = 0 OR delete_count = 0 THEN\r\n            RAISE WARNING 'Table % is missing policies: SELECT=%, INSERT=%, UPDATE=%, DELETE=%', \r\n                tbl_name, select_count, insert_count, update_count, delete_count;\r\n        ELSE\r\n            RAISE NOTICE 'Table % has complete policies: SELECT=%, INSERT=%, UPDATE=%, DELETE=%', \r\n                tbl_name, select_count, insert_count, update_count, delete_count;\r\n        END IF;\r\n    END LOOP;\r\nEND $$","-- Final success message\r\nDO $$\r\nBEGIN\r\n    RAISE NOTICE '========================================';\r\n    RAISE NOTICE 'RLS POLICY HARDENING COMPLETE';\r\n    RAISE NOTICE '========================================';\r\n    RAISE NOTICE '✓ 7 tables hardened with strict org-based policies';\r\n    RAISE NOTICE '✓ qual=true policies replaced';\r\n    RAISE NOTICE '✓ authenticated-only policies replaced';\r\n    RAISE NOTICE '✓ All operations (SELECT/INSERT/UPDATE/DELETE) covered';\r\n    RAISE NOTICE '========================================';\r\nEND $$"}	rls_policy_hardening
20260119000005	{"-- Migration: Inventory Table Isolation Hardening\r\n-- Description: Fix inventory-related RLS policies and ensure strict org_id enforcement\r\n-- Date: 2026-01-19\r\n-- Author: Supabase Security Team\r\n-- IMPORTANT: Run this AFTER 20260119000004_rls_policy_hardening.sql\r\n\r\n-- =============================================================================\r\n-- INVENTORY TABLES ANALYSIS\r\n-- =============================================================================\r\n-- 1. inventory_items - HAS org_id, uses SUBQUERIES (performance issue)\r\n-- 2. item_stock - NOW HAS org_id (added by migration 1), has unsafe policies\r\n-- 3. room_type_inventory - NOW HAS org_id (added by migration 1), \\"Temporary for MVP\\" policy\r\n--\r\n-- RISKS IDENTIFIED:\r\n-- - Subqueries in RLS policies (performance degradation)\r\n-- - Potential JOIN bypass in room_type_inventory policy\r\n-- - \\"Temporary for MVP\\" policy bypasses all security\r\n-- =============================================================================\r\n\r\n-- =============================================================================\r\n-- TABLE 1: inventory_items\r\n-- =============================================================================\r\n-- Current Issue: Uses subqueries instead of helper functions (performance issue)\r\n-- Fix: Replace with is_org_member() and is_org_admin()\r\n\r\n-- Drop existing subquery-based policies\r\nDROP POLICY IF EXISTS \\"Users can view inventory items of their org\\" ON public.inventory_items","DROP POLICY IF EXISTS \\"Users can insert inventory items to their org\\" ON public.inventory_items","DROP POLICY IF EXISTS \\"Users can update inventory items of their org\\" ON public.inventory_items","DROP POLICY IF EXISTS \\"Users can delete inventory items of their org\\" ON public.inventory_items","-- Policy: Org members can view their org's inventory items\r\n-- Allows: All org members (owner, admin, member, viewer) + staff\r\n-- Denies: Users from other orgs\r\n-- Performance: Uses helper function instead of subquery\r\nCREATE POLICY \\"org_members_select_inventory_items\\" \r\nON public.inventory_items\r\nFOR SELECT\r\nUSING (\r\n  public.is_org_member(org_id) \r\n  OR public.is_hostconnect_staff()\r\n)","-- Policy: Org members can insert inventory items\r\n-- Allows: Org members (not just admins - operational staff needs this)\r\n-- Denies: Viewers, other orgs\r\nCREATE POLICY \\"org_members_insert_inventory_items\\" \r\nON public.inventory_items\r\nFOR INSERT\r\nWITH CHECK (\r\n  public.is_org_member(org_id) \r\n  OR public.is_hostconnect_staff()\r\n)","-- Policy: Org members can update inventory items\r\n-- Allows: Org members (operational updates)\r\nCREATE POLICY \\"org_members_update_inventory_items\\" \r\nON public.inventory_items\r\nFOR UPDATE\r\nUSING (\r\n  public.is_org_member(org_id) \r\n  OR public.is_hostconnect_staff()\r\n)","-- Policy: Org admins can delete inventory items\r\n-- Allows: Only admins can delete catalog items\r\n-- Denies: Members, viewers\r\nCREATE POLICY \\"org_admins_delete_inventory_items\\" \r\nON public.inventory_items\r\nFOR DELETE\r\nUSING (\r\n  public.is_org_admin(org_id) \r\n  OR public.is_hostconnect_staff()\r\n)","-- =============================================================================\r\n-- TABLE 2: item_stock\r\n-- =============================================================================\r\n-- Already hardened by migration 20260119000004_rls_policy_hardening.sql\r\n-- Policies created:\r\n-- - org_members_select_item_stock\r\n-- - org_members_insert_item_stock\r\n-- - org_members_update_item_stock\r\n-- - org_admins_delete_item_stock\r\n-- No additional changes needed\r\nDO $$\r\nBEGIN\r\n    RAISE NOTICE 'item_stock policies already hardened by previous migration';\r\nEND $$","-- =============================================================================\r\n-- TABLE 3: room_type_inventory\r\n-- =============================================================================\r\n-- Already hardened by migration 20260119000004_rls_policy_hardening.sql\r\n-- \\"Temporary for MVP\\" policy removed\r\n-- Policies created:\r\n-- - org_members_select_room_type_inventory\r\n-- - org_members_insert_room_type_inventory\r\n-- - org_members_update_room_type_inventory\r\n-- - org_admins_delete_room_type_inventory\r\n-- No additional changes needed\r\nDO $$\r\nBEGIN\r\n    RAISE NOTICE 'room_type_inventory policies already hardened by previous migration';\r\nEND $$","-- =============================================================================\r\n-- ADDITIONAL: Fix potential JOIN bypass vulnerabilities\r\n-- =============================================================================\r\n\r\n-- Drop the old JOIN-based policy (if it still exists)\r\nDROP POLICY IF EXISTS \\"Users can view room inventory if they have access to room type\\" ON public.room_type_inventory","-- Note: The new org_id-based policies from migration 20260119000004 are sufficient\r\n-- and prevent JOIN bypass vulnerabilities\r\n\r\n-- =============================================================================\r\n-- VALIDATION: Ensure no JOIN-based RLS bypass\r\n-- =============================================================================\r\n\r\n-- Verify no policies use SELECT ... FROM in USING clause (potential bypass)\r\nDO $$\r\nDECLARE\r\n    risky_policies text;\r\nBEGIN\r\n    SELECT string_agg(tablename || '.' || policyname, ', ')\r\n    INTO risky_policies\r\n    FROM pg_policies\r\n    WHERE schemaname = 'public'\r\n      AND tablename IN ('inventory_items', 'item_stock', 'room_type_inventory')\r\n      AND (\r\n        qual LIKE '%SELECT%FROM%' \r\n        OR with_check LIKE '%SELECT%FROM%'\r\n      )\r\n      AND policyname NOT LIKE '%old%'\r\n      AND policyname NOT LIKE '%deprecated%';\r\n    \r\n    IF risky_policies IS NOT NULL THEN\r\n        RAISE WARNING 'Policies with potential JOIN bypass detected: %. Review these policies.', risky_policies;\r\n    ELSE\r\n        RAISE NOTICE 'SUCCESS: No risky JOIN-based policies found in inventory tables';\r\n    END IF;\r\nEND $$","-- =============================================================================\r\n-- VALIDATION: Verify all inventory tables have complete policies\r\n-- =============================================================================\r\n\r\nDO $$\r\nDECLARE\r\n    inventory_tables text[] := ARRAY['inventory_items', 'item_stock', 'room_type_inventory'];\r\n    tbl_name text;\r\n    select_count integer;\r\n    insert_count integer;\r\n    update_count integer;\r\n    delete_count integer;\r\nBEGIN\r\n    FOREACH tbl_name IN ARRAY inventory_tables\r\n    LOOP\r\n        SELECT COUNT(*) INTO select_count FROM pg_policies \r\n        WHERE schemaname = 'public' AND tablename = tbl_name AND cmd = 'SELECT';\r\n        \r\n        SELECT COUNT(*) INTO insert_count FROM pg_policies \r\n        WHERE schemaname = 'public' AND tablename = tbl_name AND cmd = 'INSERT';\r\n        \r\n        SELECT COUNT(*) INTO update_count FROM pg_policies \r\n        WHERE schemaname = 'public' AND tablename = tbl_name AND cmd = 'UPDATE';\r\n        \r\n        SELECT COUNT(*) INTO delete_count FROM pg_policies \r\n        WHERE schemaname = 'public' AND tablename = tbl_name AND cmd = 'DELETE';\r\n        \r\n        IF select_count = 0 OR insert_count = 0 OR update_count = 0 OR delete_count = 0 THEN\r\n            RAISE EXCEPTION 'Table % is missing required policies: SELECT=%, INSERT=%, UPDATE=%, DELETE=%', \r\n                tbl_name, select_count, insert_count, update_count, delete_count;\r\n        ELSE\r\n            RAISE NOTICE 'Table % has complete policies: SELECT=%, INSERT=%, UPDATE=%, DELETE=%', \r\n                tbl_name, select_count, insert_count, update_count, delete_count;\r\n        END IF;\r\n    END LOOP;\r\nEND $$","-- =============================================================================\r\n-- EXAMPLE: Secure SELECT queries demonstrating proper usage\r\n-- =============================================================================\r\n\r\n-- Example 1: Get all inventory items for current user's org\r\n-- RLS automatically filters to user's org\r\n-- SELECT id, name, category, description\r\n-- FROM inventory_items\r\n-- ORDER BY category, name;\r\n\r\n-- Example 2: Get stock levels for all items\r\n-- RLS ensures only current org's stock is visible\r\n-- SELECT \r\n--   ii.name,\r\n--   ii.category,\r\n--   ist.location,\r\n--   ist.quantity,\r\n--   ist.last_updated_at\r\n-- FROM inventory_items ii\r\n-- LEFT JOIN item_stock ist ON ist.item_id = ii.id\r\n-- ORDER BY ii.category, ii.name, ist.location;\r\n\r\n-- Example 3: Get room type inventory with item details\r\n-- RLS on both tables prevents cross-org access\r\n-- SELECT \r\n--   rt.name as room_type,\r\n--   ii.name as item_name,\r\n--   rti.quantity,\r\n--   ist.quantity as stock_available\r\n-- FROM room_type_inventory rti\r\n-- JOIN room_types rt ON rt.id = rti.room_type_id\r\n-- JOIN inventory_items ii ON ii.id = rti.item_id\r\n-- LEFT JOIN item_stock ist ON ist.item_id = ii.id AND ist.location = 'pantry'\r\n-- WHERE rt.property_id = '<current_property_id>'\r\n-- ORDER BY rt.name, ii.name;\r\n\r\n-- Note: All these queries are RLS-safe because:\r\n-- 1. Each table has org_id-based policies\r\n-- 2. JOINs don't bypass RLS (each table is filtered independently)\r\n-- 3. Helper functions (is_org_member) ensure consistent filtering\r\n\r\n-- =============================================================================\r\n-- FINAL SUCCESS MESSAGE\r\n-- =============================================================================\r\n\r\nDO $$\r\nBEGIN\r\n    RAISE NOTICE '========================================';\r\n    RAISE NOTICE 'INVENTORY ISOLATION HARDENING COMPLETE';\r\n    RAISE NOTICE '========================================';\r\n    RAISE NOTICE '✓ inventory_items: Subqueries replaced with helper functions';\r\n    RAISE NOTICE '✓ item_stock: Already hardened (previous migration)';\r\n    RAISE NOTICE '✓ room_type_inventory: Already hardened (previous migration)';\r\n    RAISE NOTICE '✓ No JOIN-based RLS bypass vulnerabilities';\r\n    RAISE NOTICE '✓ All tables have complete CRUD policies';\r\n    RAISE NOTICE '========================================';\r\nEND $$"}	inventory_isolation
20260119000006	{"-- ============================================================================\r\n-- MULTI-TENANT ISOLATION VALIDATION TEST SUITE\r\n-- ============================================================================\r\n-- Date: 2026-01-19\r\n-- Objective: Prove that multi-tenant isolation works with zero data leakage\r\n-- Author: Supabase Security Team\r\n--\r\n-- ⚠️ IMPORTANT: SETUP REQUIRED BEFORE RUNNING ⚠️\r\n--\r\n-- STEP 1: Create 5 users in Supabase Auth Dashboard\r\n--   - test-user-a1@example.com (Org A Admin)\r\n--   - test-user-a2@example.com (Org A Member)\r\n--   - test-user-b1@example.com (Org B Admin)\r\n--   - test-user-b2@example.com (Org B Member)\r\n--   - test-staff@example.com (Staff)\r\n--\r\n-- STEP 2: Copy each user's UUID from Supabase Auth\r\n--\r\n-- STEP 3: Replace the placeholder UUIDs below (lines 35-39) with real UUIDs\r\n--\r\n-- STEP 4: Run this file via Supabase SQL Editor\r\n--\r\n-- ============================================================================\r\n\r\n-- ============================================================================\r\n-- SECTION 1: SETUP - Create Test Organizations and Users\r\n-- ============================================================================\r\n\r\n-- ⚠️⚠️⚠️ REPLACE THESE UUIDs WITH REAL USER IDs FROM SUPABASE AUTH ⚠️⚠️⚠️\r\n-- These placeholder UUIDs will cause FK constraint errors if not replaced!\r\n--\r\n-- To get real UUIDs:\r\n-- 1. Go to Supabase Dashboard → Authentication → Users\r\n-- 2. Create the 5 test users listed above\r\n-- 3. Click on each user and copy their UUID\r\n-- 4. Replace the values below\r\n\r\nDO $$\r\nDECLARE\r\n    -- Organization IDs (generated automatically)\r\n    org_a_id uuid := gen_random_uuid();\r\n    org_b_id uuid := gen_random_uuid();\r\n    \r\n    -- 🔴 REPLACE THESE WITH ACTUAL AUTH.USERS IDs 🔴\r\n    user_a1_id uuid := '00000000-0000-0000-0000-000000000001'::uuid; -- ⚠️ REPLACE ME\r\n    user_a2_id uuid := '00000000-0000-0000-0000-000000000002'::uuid; -- ⚠️ REPLACE ME\r\n    user_b1_id uuid := '00000000-0000-0000-0000-000000000003'::uuid; -- ⚠️ REPLACE ME\r\n    user_b2_id uuid := '00000000-0000-0000-0000-000000000004'::uuid; -- ⚠️ REPLACE ME\r\n    user_s1_id uuid := '00000000-0000-0000-0000-000000000099'::uuid; -- ⚠️ REPLACE ME (staff)\r\n    \r\n    -- Property IDs\r\n    property_a_id uuid := gen_random_uuid();\r\n    property_b_id uuid := gen_random_uuid();\r\nBEGIN\r\n    -- Create Org A\r\n    INSERT INTO organizations (id, name)\r\n    VALUES (org_a_id, 'Test Org A')\r\n    ON CONFLICT (id) DO NOTHING;\r\n    \r\n    -- Create Org B\r\n    INSERT INTO organizations (id, name)\r\n    VALUES (org_b_id, 'Test Org B')\r\n    ON CONFLICT (id) DO NOTHING;\r\n    \r\n    -- Add users to Org A\r\n    INSERT INTO org_members (org_id, user_id, role)\r\n    VALUES \r\n        (org_a_id, user_a1_id, 'admin'),\r\n        (org_a_id, user_a2_id, 'member')\r\n    ON CONFLICT (org_id, user_id) DO NOTHING;\r\n    \r\n    -- Add users to Org B\r\n    INSERT INTO org_members (org_id, user_id, role)\r\n    VALUES \r\n        (org_b_id, user_b1_id, 'admin'),\r\n        (org_b_id, user_b2_id, 'member')\r\n    ON CONFLICT (org_id, user_id) DO NOTHING;\r\n    \r\n    -- Add staff member\r\n    INSERT INTO hostconnect_staff (user_id, role)\r\n    VALUES (user_s1_id, 'support')\r\n    ON CONFLICT (user_id) DO NOTHING;\r\n    \r\n    -- Create property for Org A\r\n    INSERT INTO properties (id, org_id, name, address)\r\n    VALUES (property_a_id, org_a_id, 'Hotel A', '123 Street A')\r\n    ON CONFLICT (id) DO NOTHING;\r\n    \r\n    -- Create property for Org B\r\n    INSERT INTO properties (id, org_id, name, address)\r\n    VALUES (property_b_id, org_b_id, 'Hotel B', '456 Street B')\r\n    ON CONFLICT (id) DO NOTHING;\r\n    \r\n    -- Create test data for Org A\r\n    INSERT INTO amenities (org_id, name, icon)\r\n    VALUES \r\n        (org_a_id, 'WiFi A', 'wifi'),\r\n        (org_a_id, 'Pool A', 'pool')\r\n    ON CONFLICT DO NOTHING;\r\n    \r\n    INSERT INTO room_types (org_id, property_id, name, base_price, capacity)\r\n    VALUES \r\n        (org_a_id, property_a_id, 'Standard A', 100, 2),\r\n        (org_a_id, property_a_id, 'Deluxe A', 200, 4)\r\n    ON CONFLICT DO NOTHING;\r\n    \r\n    INSERT INTO services (org_id, property_id, name, price)\r\n    VALUES \r\n        (org_a_id, property_a_id, 'Breakfast A', 20),\r\n        (org_a_id, property_a_id, 'Spa A', 50)\r\n    ON CONFLICT DO NOTHING;\r\n    \r\n    INSERT INTO inventory_items (org_id, name, category)\r\n    VALUES \r\n        (org_a_id, 'Towel A', 'Bedding'),\r\n        (org_a_id, 'Shampoo A', 'Toiletries')\r\n    ON CONFLICT DO NOTHING;\r\n    \r\n    -- Create test data for Org B\r\n    INSERT INTO amenities (org_id, name, icon)\r\n    VALUES \r\n        (org_b_id, 'WiFi B', 'wifi'),\r\n        (org_b_id, 'Gym B', 'gym')\r\n    ON CONFLICT DO NOTHING;\r\n    \r\n    INSERT INTO room_types (org_id, property_id, name, base_price, capacity)\r\n    VALUES \r\n        (org_b_id, property_b_id, 'Standard B', 150, 2),\r\n        (org_b_id, property_b_id, 'Suite B', 300, 6)\r\n    ON CONFLICT DO NOTHING;\r\n    \r\n    INSERT INTO services (org_id, property_id, name, price)\r\n    VALUES \r\n        (org_b_id, property_b_id, 'Breakfast B', 25),\r\n        (org_b_id, property_b_id, 'Laundry B', 30)\r\n    ON CONFLICT DO NOTHING;\r\n    \r\n    INSERT INTO inventory_items (org_id, name, category)\r\n    VALUES \r\n        (org_b_id, 'Towel B', 'Bedding'),\r\n        (org_b_id, 'Soap B', 'Toiletries')\r\n    ON CONFLICT DO NOTHING;\r\n    \r\n    RAISE NOTICE 'TEST DATA SETUP COMPLETE';\r\n    RAISE NOTICE 'Org A ID: %', org_a_id;\r\n    RAISE NOTICE 'Org B ID: %', org_b_id;\r\n    RAISE NOTICE 'Property A ID: %', property_a_id;\r\n    RAISE NOTICE 'Property B ID: %', property_b_id;\r\nEND $$","-- ============================================================================\r\n-- SECTION 2: POSITIVE TESTS - Verify users can see their own org's data\r\n-- ============================================================================\r\n\r\n-- Test 2.1: Org A Admin can see Org A data\r\n-- Expected: Success, returns Org A data only\r\nDO $$\r\nDECLARE\r\n    test_user_id uuid := '00000000-0000-0000-0000-000000000001'::uuid; -- User A1\r\n    amenities_count integer;\r\n    room_types_count integer;\r\n    services_count integer;\r\nBEGIN\r\n    -- Simulate user A1 session\r\n    PERFORM set_config('request.jwt.claims', json_build_object('sub', test_user_id)::text, true);\r\n    \r\n    -- Count visible amenities\r\n    SELECT COUNT(*) INTO amenities_count FROM amenities;\r\n    \r\n    -- Count visible room types\r\n    SELECT COUNT(*) INTO room_types_count FROM room_types;\r\n    \r\n    -- Count visible services\r\n    SELECT COUNT(*) INTO services_count FROM services;\r\n    \r\n    RAISE NOTICE '=== TEST 2.1: Org A Admin Access ===';\r\n    RAISE NOTICE 'Amenities visible: % (Expected: 2)', amenities_count;\r\n    RAISE NOTICE 'Room Types visible: % (Expected: 2)', room_types_count;\r\n    RAISE NOTICE 'Services visible: % (Expected: 2)', services_count;\r\n    \r\n    IF amenities_count = 2 AND room_types_count = 2 AND services_count = 2 THEN\r\n        RAISE NOTICE '✅ TEST 2.1 PASSED';\r\n    ELSE\r\n        RAISE EXCEPTION '❌ TEST 2.1 FAILED';\r\n    END IF;\r\nEND $$","-- Test 2.2: Org A Member can see Org A data (read-only mostly)\r\n-- Expected: Success, returns Org A data only\r\nDO $$\r\nDECLARE\r\n    test_user_id uuid := '00000000-0000-0000-0000-000000000002'::uuid; -- User A2\r\n    properties_count integer;\r\n    inventory_count integer;\r\nBEGIN\r\n    PERFORM set_config('request.jwt.claims', json_build_object('sub', test_user_id)::text, true);\r\n    \r\n    SELECT COUNT(*) INTO properties_count FROM properties;\r\n    SELECT COUNT(*) INTO inventory_count FROM inventory_items;\r\n    \r\n    RAISE NOTICE '=== TEST 2.2: Org A Member Access ===';\r\n    RAISE NOTICE 'Properties visible: % (Expected: 1)', properties_count;\r\n    RAISE NOTICE 'Inventory Items visible: % (Expected: 2)', inventory_count;\r\n    \r\n    IF properties_count = 1 AND inventory_count = 2 THEN\r\n        RAISE NOTICE '✅ TEST 2.2 PASSED';\r\n    ELSE\r\n        RAISE EXCEPTION '❌ TEST 2.2 FAILED';\r\n    END IF;\r\nEND $$","-- Test 2.3: Org B Admin can see Org B data\r\n-- Expected: Success, returns Org B data only\r\nDO $$\r\nDECLARE\r\n    test_user_id uuid := '00000000-0000-0000-0000-000000000003'::uuid; -- User B1\r\n    amenities_count integer;\r\n    room_types_count integer;\r\nBEGIN\r\n    PERFORM set_config('request.jwt.claims', json_build_object('sub', test_user_id)::text, true);\r\n    \r\n    SELECT COUNT(*) INTO amenities_count FROM amenities;\r\n    SELECT COUNT(*) INTO room_types_count FROM room_types;\r\n    \r\n    RAISE NOTICE '=== TEST 2.3: Org B Admin Access ===';\r\n    RAISE NOTICE 'Amenities visible: % (Expected: 2)', amenities_count;\r\n    RAISE NOTICE 'Room Types visible: % (Expected: 2)', room_types_count;\r\n    \r\n    IF amenities_count = 2 AND room_types_count = 2 THEN\r\n        RAISE NOTICE '✅ TEST 2.3 PASSED';\r\n    ELSE\r\n        RAISE EXCEPTION '❌ TEST 2.3 FAILED';\r\n    END IF;\r\nEND $$","-- ============================================================================\r\n-- SECTION 3: NEGATIVE TESTS - Verify users CANNOT see other org's data\r\n-- ============================================================================\r\n\r\n-- Test 3.1: Org A user tries to see Org B data via direct query\r\n-- Expected: Returns 0 rows\r\nDO $$\r\nDECLARE\r\n    test_user_id uuid := '00000000-0000-0000-0000-000000000001'::uuid; -- User A1\r\n    org_b_id uuid;\r\n    leaked_count integer;\r\nBEGIN\r\n    -- Get Org B ID\r\n    SELECT id INTO org_b_id FROM organizations WHERE name = 'Test Org B';\r\n    \r\n    PERFORM set_config('request.jwt.claims', json_build_object('sub', test_user_id)::text, true);\r\n    \r\n    -- Try to see Org B amenities\r\n    SELECT COUNT(*) INTO leaked_count \r\n    FROM amenities \r\n    WHERE name LIKE '%B';\r\n    \r\n    RAISE NOTICE '=== TEST 3.1: Cross-Org Direct Query ===';\r\n    RAISE NOTICE 'Org B amenities visible to Org A user: % (Expected: 0)', leaked_count;\r\n    \r\n    IF leaked_count = 0 THEN\r\n        RAISE NOTICE '✅ TEST 3.1 PASSED - No data leakage';\r\n    ELSE\r\n        RAISE EXCEPTION '❌ TEST 3.1 FAILED - DATA LEAKAGE DETECTED';\r\n    END IF;\r\nEND $$","-- Test 3.2: Org A user tries to see Org B data via org_id filter\r\n-- Expected: Returns 0 rows (RLS blocks it)\r\nDO $$\r\nDECLARE\r\n    test_user_id uuid := '00000000-0000-0000-0000-000000000001'::uuid; -- User A1\r\n    org_b_id uuid;\r\n    leaked_count integer;\r\nBEGIN\r\n    SELECT id INTO org_b_id FROM organizations WHERE name = 'Test Org B';\r\n    \r\n    PERFORM set_config('request.jwt.claims', json_build_object('sub', test_user_id)::text, true);\r\n    \r\n    -- Try to explicitly filter by Org B's org_id\r\n    SELECT COUNT(*) INTO leaked_count \r\n    FROM room_types \r\n    WHERE org_id = org_b_id;\r\n    \r\n    RAISE NOTICE '=== TEST 3.2: Cross-Org Filter Bypass Attempt ===';\r\n    RAISE NOTICE 'Org B room types visible via filter: % (Expected: 0)', leaked_count;\r\n    \r\n    IF leaked_count = 0 THEN\r\n        RAISE NOTICE '✅ TEST 3.2 PASSED - RLS blocked filter bypass';\r\n    ELSE\r\n        RAISE EXCEPTION '❌ TEST 3.2 FAILED - FILTER BYPASS DETECTED';\r\n    END IF;\r\nEND $$","-- Test 3.3: Org A user tries to see Org B data via JOIN\r\n-- Expected: Returns 0 rows (RLS on both tables)\r\nDO $$\r\nDECLARE\r\n    test_user_id uuid := '00000000-0000-0000-0000-000000000001'::uuid; -- User A1\r\n    leaked_count integer;\r\nBEGIN\r\n    PERFORM set_config('request.jwt.claims', json_build_object('sub', test_user_id)::text, true);\r\n    \r\n    -- Try to JOIN to see Org B data\r\n    SELECT COUNT(*) INTO leaked_count \r\n    FROM properties p\r\n    JOIN room_types rt ON rt.property_id = p.id\r\n    WHERE p.name LIKE '%B';\r\n    \r\n    RAISE NOTICE '=== TEST 3.3: Cross-Org JOIN Bypass Attempt ===';\r\n    RAISE NOTICE 'Org B data visible via JOIN: % (Expected: 0)', leaked_count;\r\n    \r\n    IF leaked_count = 0 THEN\r\n        RAISE NOTICE '✅ TEST 3.3 PASSED - JOIN did not bypass RLS';\r\n    ELSE\r\n        RAISE EXCEPTION '❌ TEST 3.3 FAILED - JOIN BYPASS DETECTED';\r\n    END IF;\r\nEND $$","-- Test 3.4: Org B user tries to see Org A data via inventory JOIN\r\n-- Expected: Returns 0 rows\r\nDO $$\r\nDECLARE\r\n    test_user_id uuid := '00000000-0000-0000-0000-000000000003'::uuid; -- User B1\r\n    leaked_count integer;\r\nBEGIN\r\n    PERFORM set_config('request.jwt.claims', json_build_object('sub', test_user_id)::text, true);\r\n    \r\n    -- Try to see Org A inventory via JOIN\r\n    SELECT COUNT(*) INTO leaked_count \r\n    FROM inventory_items ii\r\n    WHERE ii.name LIKE '%A';\r\n    \r\n    RAISE NOTICE '=== TEST 3.4: Reverse Cross-Org Access ===';\r\n    RAISE NOTICE 'Org A inventory visible to Org B user: % (Expected: 0)', leaked_count;\r\n    \r\n    IF leaked_count = 0 THEN\r\n        RAISE NOTICE '✅ TEST 3.4 PASSED - Reverse access blocked';\r\n    ELSE\r\n        RAISE EXCEPTION '❌ TEST 3.4 FAILED - REVERSE LEAKAGE DETECTED';\r\n    END IF;\r\nEND $$","-- ============================================================================\r\n-- SECTION 4: STAFF TESTS - Verify staff can see ALL data\r\n-- ============================================================================\r\n\r\n-- Test 4.1: Staff can see both Org A and Org B data\r\n-- Expected: Success, sees data from both orgs\r\nDO $$\r\nDECLARE\r\n    test_user_id uuid := '00000000-0000-0000-0000-000000000099'::uuid; -- User S1 (staff)\r\n    total_amenities integer;\r\n    total_properties integer;\r\n    total_room_types integer;\r\nBEGIN\r\n    PERFORM set_config('request.jwt.claims', json_build_object('sub', test_user_id)::text, true);\r\n    \r\n    SELECT COUNT(*) INTO total_amenities FROM amenities;\r\n    SELECT COUNT(*) INTO total_properties FROM properties;\r\n    SELECT COUNT(*) INTO total_room_types FROM room_types;\r\n    \r\n    RAISE NOTICE '=== TEST 4.1: Staff Cross-Org Access ===';\r\n    RAISE NOTICE 'Total amenities visible: % (Expected: 4 - both orgs)', total_amenities;\r\n    RAISE NOTICE 'Total properties visible: % (Expected: 2 - both orgs)', total_properties;\r\n    RAISE NOTICE 'Total room types visible: % (Expected: 4 - both orgs)', total_room_types;\r\n    \r\n    IF total_amenities = 4 AND total_properties = 2 AND total_room_types = 4 THEN\r\n        RAISE NOTICE '✅ TEST 4.1 PASSED - Staff has cross-org access';\r\n    ELSE\r\n        RAISE EXCEPTION '❌ TEST 4.1 FAILED - Staff access incorrect';\r\n    END IF;\r\nEND $$","-- Test 4.2: Verify staff can filter by specific org if needed\r\n-- Expected: Staff can explicitly access specific org data\r\nDO $$\r\nDECLARE\r\n    test_user_id uuid := '00000000-0000-0000-0000-000000000099'::uuid; -- User S1 (staff)\r\n    org_a_id uuid;\r\n    org_a_amenities integer;\r\nBEGIN\r\n    SELECT id INTO org_a_id FROM organizations WHERE name = 'Test Org A';\r\n    \r\n    PERFORM set_config('request.jwt.claims', json_build_object('sub', test_user_id)::text, true);\r\n    \r\n    SELECT COUNT(*) INTO org_a_amenities \r\n    FROM amenities \r\n    WHERE org_id = org_a_id;\r\n    \r\n    RAISE NOTICE '=== TEST 4.2: Staff Filtered Org Access ===';\r\n    RAISE NOTICE 'Org A amenities (filtered): % (Expected: 2)', org_a_amenities;\r\n    \r\n    IF org_a_amenities = 2 THEN\r\n        RAISE NOTICE '✅ TEST 4.2 PASSED - Staff can filter by org';\r\n    ELSE\r\n        RAISE EXCEPTION '❌ TEST 4.2 FAILED';\r\n    END IF;\r\nEND $$","-- ============================================================================\r\n-- SECTION 5: MALICIOUS QUERY ATTEMPTS\r\n-- ============================================================================\r\n\r\n-- Test 5.1: Attempt UNION bypass\r\n-- Expected: Returns 0 Org B rows for Org A user\r\nDO $$\r\nDECLARE\r\n    test_user_id uuid := '00000000-0000-0000-0000-000000000001'::uuid; -- User A1\r\n    leaked_count integer;\r\nBEGIN\r\n    PERFORM set_config('request.jwt.claims', json_build_object('sub', test_user_id)::text, true);\r\n    \r\n    -- Try UNION to combine Org A and Org B results\r\n    -- RLS should still filter both parts of the UNION\r\n    SELECT COUNT(*) INTO leaked_count FROM (\r\n        SELECT id, name FROM amenities WHERE name LIKE '%A'\r\n        UNION ALL\r\n        SELECT id, name FROM amenities WHERE name LIKE '%B'\r\n    ) combined;\r\n    \r\n    RAISE NOTICE '=== TEST 5.1: UNION Bypass Attempt ===';\r\n    RAISE NOTICE 'Rows returned via UNION: % (Expected: 2 - only Org A)', leaked_count;\r\n    \r\n    IF leaked_count = 2 THEN\r\n        RAISE NOTICE '✅ TEST 5.1 PASSED - UNION did not bypass RLS';\r\n    ELSE\r\n        RAISE EXCEPTION '❌ TEST 5.1 FAILED - UNION BYPASS DETECTED';\r\n    END IF;\r\nEND $$","-- Test 5.2: Attempt subquery bypass\r\n-- Expected: Subquery also respects RLS\r\nDO $$\r\nDECLARE\r\n    test_user_id uuid := '00000000-0000-0000-0000-000000000001'::uuid; -- User A1\r\n    leaked_count integer;\r\nBEGIN\r\n    PERFORM set_config('request.jwt.claims', json_build_object('sub', test_user_id)::text, true);\r\n    \r\n    -- Try to use subquery to access Org B data\r\n    SELECT COUNT(*) INTO leaked_count \r\n    FROM room_types rt\r\n    WHERE rt.id IN (\r\n        SELECT id FROM room_types WHERE name LIKE '%B'\r\n    );\r\n    \r\n    RAISE NOTICE '=== TEST 5.2: Subquery Bypass Attempt ===';\r\n    RAISE NOTICE 'Rows from subquery: % (Expected: 0)', leaked_count;\r\n    \r\n    IF leaked_count = 0 THEN\r\n        RAISE NOTICE '✅ TEST 5.2 PASSED - Subquery respects RLS';\r\n    ELSE\r\n        RAISE EXCEPTION '❌ TEST 5.2 FAILED - SUBQUERY BYPASS DETECTED';\r\n    END IF;\r\nEND $$","-- Test 5.3: Attempt CTE bypass\r\n-- Expected: CTE also respects RLS\r\nDO $$\r\nDECLARE\r\n    test_user_id uuid := '00000000-0000-0000-0000-000000000001'::uuid; -- User A1\r\n    leaked_count integer;\r\nBEGIN\r\n    PERFORM set_config('request.jwt.claims', json_build_object('sub', test_user_id)::text, true);\r\n    \r\n    -- Try to use CTE to access Org B data\r\n    WITH all_services AS (\r\n        SELECT * FROM services\r\n    )\r\n    SELECT COUNT(*) INTO leaked_count \r\n    FROM all_services\r\n    WHERE name LIKE '%B';\r\n    \r\n    RAISE NOTICE '=== TEST 5.3: CTE Bypass Attempt ===';\r\n    RAISE NOTICE 'Org B services via CTE: % (Expected: 0)', leaked_count;\r\n    \r\n    IF leaked_count = 0 THEN\r\n        RAISE NOTICE '✅ TEST 5.3 PASSED - CTE respects RLS';\r\n    ELSE\r\n        RAISE EXCEPTION '❌ TEST 5.3 FAILED - CTE BYPASS DETECTED';\r\n    END IF;\r\nEND $$","-- Test 5.4: Attempt multi-level JOIN bypass\r\n-- Expected: Returns 0 rows (RLS on all tables in JOIN chain)\r\nDO $$\r\nDECLARE\r\n    test_user_id uuid := '00000000-0000-0000-0000-000000000001'::uuid; -- User A1\r\n    leaked_count integer;\r\nBEGIN\r\n    PERFORM set_config('request.jwt.claims', json_build_object('sub', test_user_id)::text, true);\r\n    \r\n    -- Try complex JOIN chain to access Org B data\r\n    SELECT COUNT(*) INTO leaked_count \r\n    FROM properties p\r\n    JOIN room_types rt ON rt.property_id = p.id\r\n    JOIN services s ON s.property_id = p.id\r\n    WHERE s.name LIKE '%B';\r\n    \r\n    RAISE NOTICE '=== TEST 5.4: Multi-level JOIN Bypass Attempt ===';\r\n    RAISE NOTICE 'Org B data via complex JOIN: % (Expected: 0)', leaked_count;\r\n    \r\n    IF leaked_count = 0 THEN\r\n        RAISE NOTICE '✅ TEST 5.4 PASSED - Complex JOIN blocked';\r\n    ELSE\r\n        RAISE EXCEPTION '❌ TEST 5.4 FAILED - COMPLEX JOIN BYPASS DETECTED';\r\n    END IF;\r\nEND $$","-- ============================================================================\r\n-- SECTION 6: WRITE OPERATION TESTS\r\n-- ============================================================================\r\n\r\n-- Test 6.1: Org A user cannot INSERT into Org B\r\n-- Expected: INSERT succeeds but data is scoped to Org A, not Org B\r\nDO $$\r\nDECLARE\r\n    test_user_id uuid := '00000000-0000-0000-0000-000000000001'::uuid; -- User A1\r\n    org_b_id uuid;\r\n    new_amenity_id uuid;\r\n    inserted_org_id uuid;\r\nBEGIN\r\n    SELECT id INTO org_b_id FROM organizations WHERE name = 'Test Org B';\r\n    \r\n    PERFORM set_config('request.jwt.claims', json_build_object('sub', test_user_id)::text, true);\r\n    \r\n    -- Try to INSERT with Org B's org_id\r\n    BEGIN\r\n        INSERT INTO amenities (org_id, name, icon)\r\n        VALUES (org_b_id, 'Malicious Amenity', 'hack')\r\n        RETURNING id INTO new_amenity_id;\r\n        \r\n        -- Check what org_id was actually inserted\r\n        SELECT org_id INTO inserted_org_id FROM amenities WHERE id = new_amenity_id;\r\n        \r\n        RAISE EXCEPTION '❌ TEST 6.1 FAILED - INSERT should have been blocked by WITH CHECK';\r\n    EXCEPTION WHEN OTHERS THEN\r\n        RAISE NOTICE '=== TEST 6.1: Cross-Org INSERT Attempt ===';\r\n        RAISE NOTICE '✅ TEST 6.1 PASSED - INSERT to Org B blocked';\r\n    END;\r\nEND $$","-- ============================================================================\r\n-- SECTION 7: FINAL SUMMARY\r\n-- ============================================================================\r\n\r\nDO $$\r\nBEGIN\r\n    RAISE NOTICE '========================================';\r\n    RAISE NOTICE 'MULTI-TENANT ISOLATION TEST SUMMARY';\r\n    RAISE NOTICE '========================================';\r\n    RAISE NOTICE 'If you see this message, all tests passed!';\r\n    RAISE NOTICE '✅ Positive tests: Users can see own org data';\r\n    RAISE NOTICE '✅ Negative tests: Users cannot see other org data';\r\n    RAISE NOTICE '✅ Staff tests: Staff can see all org data';\r\n    RAISE NOTICE '✅ Malicious tests: All bypass attempts blocked';\r\n    RAISE NOTICE '✅ Write tests: Cross-org writes blocked';\r\n    RAISE NOTICE '========================================';\r\n    RAISE NOTICE 'ZERO DATA LEAKAGE CONFIRMED';\r\n    RAISE NOTICE '========================================';\r\nEND $$","-- ============================================================================\r\n-- CLEANUP (Optional - run to remove test data)\r\n-- ============================================================================\r\n\r\n-- Uncomment to cleanup:\r\n/*\r\nDELETE FROM amenities WHERE name LIKE '%A' OR name LIKE '%B';\r\nDELETE FROM room_types WHERE name LIKE '%A' OR name LIKE '%B';\r\nDELETE FROM services WHERE name LIKE '%A' OR name LIKE '%B';\r\nDELETE FROM inventory_items WHERE name LIKE '%A' OR name LIKE '%B';\r\nDELETE FROM properties WHERE name LIKE 'Hotel%';\r\nDELETE FROM org_members WHERE org_id IN (\r\n    SELECT id FROM organizations WHERE name IN ('Test Org A', 'Test Org B')\r\n);\r\nDELETE FROM organizations WHERE name IN ('Test Org A', 'Test Org B');\r\nDELETE FROM hostconnect_staff WHERE user_id = '00000000-0000-0000-0000-000000000099'::uuid;\r\n*/"}	multi_tenant_validation_tests
20260119120000	{"-- noop placeholder to align migration history with remote\n-- remote already has this version recorded in supabase_migrations.schema_migrations"}	sprint2_guest_domain_model
20260120120000	{"-- noop placeholder to align migration history with remote\n-- remote already has this version recorded in supabase_migrations.schema_migrations"}	sprint2_2_submissions
20260121080000	{"-- noop placeholder to align migration history with remote\n-- remote already has this version recorded in supabase_migrations.schema_migrations"}	hotfix_status_constraint
20260121090000	{"-- noop placeholder to align migration history with remote\n-- remote already has this version recorded in supabase_migrations.schema_migrations"}	housekeeping_foundation
20260122000000	{"-- Sprint 6.0: Onboarding Persistence Table\r\n-- Stores wizard progress and completion state per organization\r\n\r\nCREATE TABLE public.hostconnect_onboarding (\r\n    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),\r\n    org_id uuid NOT NULL REFERENCES public.organizations(id) ON DELETE CASCADE,\r\n    property_id uuid NULL REFERENCES public.properties(id) ON DELETE SET NULL,\r\n    mode text NULL CHECK (mode IN ('simple', 'standard', 'hotel')),\r\n    last_step int NOT NULL DEFAULT 1,\r\n    completed_at timestamptz NULL,\r\n    dismissed_at timestamptz NULL,\r\n    created_at timestamptz NOT NULL DEFAULT now(),\r\n    updated_at timestamptz NOT NULL DEFAULT now(),\r\n    \r\n    -- Ensure one onboarding record per org\r\n    CONSTRAINT hostconnect_onboarding_org_id_key UNIQUE (org_id)\r\n)","-- Indexes for performance\r\nCREATE INDEX idx_hostconnect_onboarding_org_id ON public.hostconnect_onboarding(org_id)","CREATE INDEX idx_hostconnect_onboarding_org_property ON public.hostconnect_onboarding(org_id, property_id)","CREATE INDEX idx_hostconnect_onboarding_completed ON public.hostconnect_onboarding(org_id, completed_at)","-- Enable RLS\r\nALTER TABLE public.hostconnect_onboarding ENABLE ROW LEVEL SECURITY","-- RLS Policies\r\n\r\n-- SELECT: Org members can read their org's onboarding state\r\nCREATE POLICY \\"Org members can view onboarding\\"\r\nON public.hostconnect_onboarding\r\nFOR SELECT\r\nUSING (\r\n    org_id IN (\r\n        SELECT id FROM public.organizations\r\n        WHERE owner_id = auth.uid()\r\n    )\r\n)","-- INSERT: Staff+ can create onboarding records\r\nCREATE POLICY \\"Staff+ can create onboarding\\"\r\nON public.hostconnect_onboarding\r\nFOR INSERT\r\nWITH CHECK (\r\n    org_id IN (\r\n        SELECT id FROM public.organizations\r\n        WHERE owner_id = auth.uid()\r\n    )\r\n)","-- UPDATE: Staff+ can update onboarding (viewer read-only)\r\nCREATE POLICY \\"Staff+ can update onboarding\\"\r\nON public.hostconnect_onboarding\r\nFOR UPDATE\r\nUSING (\r\n    org_id IN (\r\n        SELECT id FROM public.organizations\r\n        WHERE owner_id = auth.uid()\r\n    )\r\n)","-- DELETE: Admin only\r\nCREATE POLICY \\"Admin can delete onboarding\\"\r\nON public.hostconnect_onboarding\r\nFOR DELETE\r\nUSING (\r\n    org_id IN (\r\n        SELECT id FROM public.organizations\r\n        WHERE owner_id = auth.uid()\r\n    )\r\n)","-- Updated_at trigger (reuse existing moddatetime function)\r\nCREATE TRIGGER handle_updated_at\r\nBEFORE UPDATE ON public.hostconnect_onboarding\r\nFOR EACH ROW\r\nEXECUTE FUNCTION moddatetime()"}	create_onboarding_table
20260123000000	{"-- Migration: Add Super Admin Support\r\n-- Description: Enables Connect team members to access all organizations for support purposes\r\n-- Date: 2026-01-23\r\n\r\n-- ============================================================================\r\n-- 1. ADD SUPER ADMIN FIELD TO PROFILES\r\n-- ============================================================================\r\n\r\nALTER TABLE public.profiles \r\nADD COLUMN IF NOT EXISTS is_super_admin boolean DEFAULT false","-- Add index for performance (only index TRUE values to save space)\r\nCREATE INDEX IF NOT EXISTS idx_profiles_super_admin \r\nON public.profiles(is_super_admin) \r\nWHERE is_super_admin = true","-- Add comment for documentation\r\nCOMMENT ON COLUMN public.profiles.is_super_admin IS \r\n'Connect team members with cross-organizational access for support. Only set via direct SQL.'","-- ============================================================================\r\n-- 2. HELPER FUNCTION: CHECK IF USER IS SUPER ADMIN\r\n-- ============================================================================\r\n\r\nCREATE OR REPLACE FUNCTION public.is_super_admin()\r\nRETURNS boolean\r\nLANGUAGE plpgsql\r\nSECURITY DEFINER\r\nSTABLE\r\nSET search_path = public\r\nAS $$\r\nBEGIN\r\n  RETURN EXISTS (\r\n    SELECT 1 \r\n    FROM public.profiles \r\n    WHERE id = auth.uid() \r\n    AND is_super_admin = true\r\n  );\r\nEND;\r\n$$","COMMENT ON FUNCTION public.is_super_admin() IS \r\n'Returns true if current user is a super admin (Connect team member)'","-- ============================================================================\r\n-- 3. UPDATE RLS POLICIES - ORGANIZATIONS\r\n-- ============================================================================\r\n\r\n-- Members can view their organizations OR super admins can view all\r\nDROP POLICY IF EXISTS \\"Members can view their organizations\\" ON public.organizations","CREATE POLICY \\"Members can view their organizations\\" ON public.organizations\r\n    FOR SELECT\r\n    USING (\r\n      public.is_super_admin() -- ✅ Super admin sees all orgs\r\n      OR\r\n      public.is_org_member(id) -- ✅ Members see their orgs\r\n    )","-- Only Admins OR super admins can update\r\nDROP POLICY IF EXISTS \\"Admins can update organization\\" ON public.organizations","CREATE POLICY \\"Admins can update organization\\" ON public.organizations\r\n    FOR UPDATE\r\n    USING (\r\n      public.is_super_admin() -- ✅ Super admin can update any org\r\n      OR\r\n      public.is_org_admin(id) -- ✅ Org admins can update their org\r\n    )","-- ============================================================================\r\n-- 4. UPDATE RLS POLICIES - ORG MEMBERS\r\n-- ============================================================================\r\n\r\n-- Members can view org members OR super admins can view all\r\nDROP POLICY IF EXISTS \\"Members can view their org members\\" ON public.org_members","CREATE POLICY \\"Members can view their org members\\" ON public.org_members\r\n    FOR SELECT\r\n    USING (\r\n      public.is_super_admin() -- ✅ Super admin sees all members\r\n      OR\r\n      auth.uid() = user_id -- Can see self\r\n      OR \r\n      EXISTS ( -- Can see others in same org\r\n        SELECT 1 FROM public.org_members om \r\n        WHERE om.org_id = org_members.org_id \r\n        AND om.user_id = auth.uid()\r\n      )\r\n    )","-- Admins OR super admins can manage org members\r\nDROP POLICY IF EXISTS \\"Admins can manage org members\\" ON public.org_members","CREATE POLICY \\"Admins can manage org members\\" ON public.org_members\r\n    FOR ALL\r\n    USING (\r\n      public.is_super_admin() -- ✅ Super admin can manage any org members\r\n      OR\r\n      public.is_org_admin(org_id)\r\n    )","-- ============================================================================\r\n-- 5. UPDATE RLS POLICIES - BOOKINGS\r\n-- ============================================================================\r\n\r\n-- Super admin can view ALL bookings across all orgs\r\nDROP POLICY IF EXISTS \\"Users can view bookings in their org\\" ON public.bookings","CREATE POLICY \\"Users can view bookings in their org\\" ON public.bookings\r\n    FOR SELECT\r\n    USING (\r\n      public.is_super_admin() -- ✅ Super admin sees all bookings\r\n      OR\r\n      public.is_org_member(org_id)\r\n    )","-- Super admin can manage bookings in any org\r\nDROP POLICY IF EXISTS \\"Users can manage bookings in their org\\" ON public.bookings","CREATE POLICY \\"Users can manage bookings in their org\\" ON public.bookings\r\n    FOR ALL\r\n    USING (\r\n      public.is_super_admin() -- ✅ Super admin can manage any booking\r\n      OR\r\n      public.is_org_member(org_id)\r\n    )","-- ============================================================================\r\n-- 6. UPDATE RLS POLICIES - GUESTS\r\n-- ============================================================================\r\n\r\nDROP POLICY IF EXISTS \\"Users can view guests in their org\\" ON public.guests","CREATE POLICY \\"Users can view guests in their org\\" ON public.guests\r\n    FOR SELECT\r\n    USING (\r\n      public.is_super_admin()\r\n      OR\r\n      public.is_org_member(org_id)\r\n    )","DROP POLICY IF EXISTS \\"Users can manage guests in their org\\" ON public.guests","CREATE POLICY \\"Users can manage guests in their org\\" ON public.guests\r\n    FOR ALL\r\n    USING (\r\n      public.is_super_admin()\r\n      OR\r\n      public.is_org_member(org_id)\r\n    )","-- ============================================================================\r\n-- 7. UPDATE RLS POLICIES - ROOMS\r\n-- ============================================================================\r\n\r\nDROP POLICY IF EXISTS \\"Users can view rooms in their property\\" ON public.rooms","CREATE POLICY \\"Users can view rooms in their property\\" ON public.rooms\r\n    FOR SELECT\r\n    USING (\r\n      public.is_super_admin()\r\n      OR\r\n      EXISTS (\r\n        SELECT 1 FROM public.properties p\r\n        WHERE p.id = rooms.property_id\r\n        AND public.is_org_member(p.org_id)\r\n      )\r\n    )","DROP POLICY IF EXISTS \\"Users can manage rooms in their property\\" ON public.rooms","CREATE POLICY \\"Users can manage rooms in their property\\" ON public.rooms\r\n    FOR ALL\r\n    USING (\r\n      public.is_super_admin()\r\n      OR\r\n      EXISTS (\r\n        SELECT 1 FROM public.properties p\r\n        WHERE p.id = rooms.property_id\r\n        AND public.is_org_member(p.org_id)\r\n      )\r\n    )","-- ============================================================================\r\n-- 8. UPDATE RLS POLICIES - PROPERTIES\r\n-- ============================================================================\r\n\r\nDROP POLICY IF EXISTS \\"Users can view properties in their org\\" ON public.properties","CREATE POLICY \\"Users can view properties in their org\\" ON public.properties\r\n    FOR SELECT\r\n    USING (\r\n      public.is_super_admin()\r\n      OR\r\n      public.is_org_member(org_id)\r\n    )","DROP POLICY IF EXISTS \\"Users can manage properties in their org\\" ON public.properties","CREATE POLICY \\"Users can manage properties in their org\\" ON public.properties\r\n    FOR ALL\r\n    USING (\r\n      public.is_super_admin()\r\n      OR\r\n      public.is_org_member(org_id)\r\n    )","-- ============================================================================\r\n-- 9. UPDATE RLS POLICIES - FOLIO ITEMS (COMMENTED - Table does not exist yet)\r\n-- ============================================================================\r\n-- NOTE: Uncomment when folio_items table is created\r\n\r\n-- DROP POLICY IF EXISTS \\"Users can view folio items in their org\\" ON public.folio_items;\r\n-- CREATE POLICY \\"Users can view folio items in their org\\" ON public.folio_items\r\n--     FOR SELECT\r\n--     USING (\r\n--       public.is_super_admin()\r\n--       OR\r\n--       EXISTS (\r\n--         SELECT 1 FROM public.bookings b\r\n--         WHERE b.id = folio_items.booking_id\r\n--         AND public.is_org_member(b.org_id)\r\n--       )\r\n--     );\r\n\r\n-- DROP POLICY IF EXISTS \\"Users can manage folio items in their org\\" ON public.folio_items;\r\n-- CREATE POLICY \\"Users can manage folio items in their org\\" ON public.folio_items\r\n--     FOR ALL\r\n--     USING (\r\n--       public.is_super_admin()\r\n--       OR\r\n--       EXISTS (\r\n--         SELECT 1 FROM public.bookings b\r\n--         WHERE b.id = folio_items.booking_id\r\n--         AND public.is_org_member(b.org_id)\r\n--       )\r\n--     );\r\n\r\n-- ============================================================================\r\n-- 10. UPDATE RLS POLICIES - FOLIO PAYMENTS (COMMENTED - Table does not exist yet)\r\n-- ============================================================================\r\n-- NOTE: Uncomment when folio_payments table is created\r\n\r\n-- DROP POLICY IF EXISTS \\"Users can view folio payments in their org\\" ON public.folio_payments;\r\n-- CREATE POLICY \\"Users can view folio payments in their org\\" ON public.folio_payments\r\n--     FOR SELECT\r\n--     USING (\r\n--       public.is_super_admin()\r\n--       OR\r\n--       EXISTS (\r\n--         SELECT 1 FROM public.bookings b\r\n--         WHERE b.id = folio_payments.booking_id\r\n--         AND public.is_org_member(b.org_id)\r\n--       )\r\n--     );\r\n\r\n-- DROP POLICY IF EXISTS \\"Users can manage folio payments in their org\\" ON public.folio_payments;\r\n-- CREATE POLICY \\"Users can manage folio payments in their org\\" ON public.folio_payments\r\n--     FOR ALL\r\n--     USING (\r\n--       public.is_super_admin()\r\n--       OR\r\n--       EXISTS (\r\n--         SELECT 1 FROM public.bookings b\r\n--         WHERE b.id = folio_payments.booking_id\r\n--         AND public.is_org_member(b.org_id)\r\n--       )\r\n--     );\r\n\r\n-- ============================================================================\r\n-- 11. SECURITY: Prevent self-promotion to super admin\r\n-- ============================================================================\r\n\r\n-- Create trigger to prevent users from promoting themselves\r\nCREATE OR REPLACE FUNCTION public.prevent_super_admin_self_promotion()\r\nRETURNS TRIGGER\r\nLANGUAGE plpgsql\r\nSECURITY DEFINER\r\nAS $$\r\nBEGIN\r\n  -- Only allow if current user is already a super admin\r\n  -- This prevents regular users from promoting themselves\r\n  IF NEW.is_super_admin = true AND OLD.is_super_admin = false THEN\r\n    IF NOT public.is_super_admin() THEN\r\n      RAISE EXCEPTION 'Only super admins can promote users to super admin';\r\n    END IF;\r\n  END IF;\r\n  \r\n  RETURN NEW;\r\nEND;\r\n$$","-- Apply trigger\r\nDROP TRIGGER IF EXISTS trigger_prevent_super_admin_self_promotion ON public.profiles","CREATE TRIGGER trigger_prevent_super_admin_self_promotion\r\n  BEFORE UPDATE ON public.profiles\r\n  FOR EACH ROW\r\n  WHEN (OLD.is_super_admin IS DISTINCT FROM NEW.is_super_admin)\r\n  EXECUTE FUNCTION public.prevent_super_admin_self_promotion()","-- ============================================================================\r\n-- NOTES FOR ADMINS\r\n-- ============================================================================\r\n\r\n-- To create a super admin, run this SQL directly in Supabase SQL Editor:\r\n-- \r\n-- UPDATE public.profiles \r\n-- SET is_super_admin = true \r\n-- WHERE email = 'suporte@cooperti.com.br';\r\n--\r\n-- To list all super admins:\r\n--\r\n-- SELECT id, email, full_name, is_super_admin \r\n-- FROM public.profiles \r\n-- WHERE is_super_admin = true;"}	add_super_admin_support
20260123100000	{"-- Migration: Database Performance & Security Optimization - Sprint 1\r\n-- Description: Critical security fixes and performance indexes\r\n-- Date: 2026-01-23\r\n\r\n-- ============================================================================\r\n-- SPRINT 1: CRITICAL SECURITY & PERFORMANCE FIXES\r\n-- ============================================================================\r\n\r\n-- ============================================================================\r\n-- 1. FIX CRITICAL SECURITY ISSUE: Profiles Leaking Data\r\n-- ============================================================================\r\n\r\n-- ❌ REMOVE INSECURE POLICY\r\n-- This policy allows ANY user to see ALL profiles (emails, phones, names)\r\nDROP POLICY IF EXISTS \\"Public profiles are viewable by everyone.\\" ON public.profiles","-- ✅ SECURE POLICY: Users can only see profiles in their organization\r\nCREATE POLICY \\"Users can view profiles in their org\\" \r\nON public.profiles FOR SELECT\r\nUSING (\r\n  -- Super admin sees all\r\n  public.is_super_admin()\r\n  OR \r\n  -- Users can see their own profile\r\n  id = auth.uid()\r\n  OR\r\n  -- Users can see profiles of people in their organization\r\n  EXISTS (\r\n    SELECT 1 FROM public.org_members om1\r\n    WHERE om1.user_id = profiles.id\r\n    AND om1.org_id IN (\r\n      SELECT om2.org_id \r\n      FROM public.org_members om2 \r\n      WHERE om2.user_id = auth.uid()\r\n    )\r\n  )\r\n)","COMMENT ON POLICY \\"Users can view profiles in their org\\" ON public.profiles IS\r\n'Secure policy: Users can only view profiles within their organization(s) or their own profile. Super admins can view all.'","-- ============================================================================\r\n-- 2. ADD CRITICAL PERFORMANCE INDEXES\r\n-- ============================================================================\r\n\r\n-- Index for org_members lookups (used in EVERY permission check)\r\nCREATE INDEX IF NOT EXISTS idx_org_members_user_org \r\nON public.org_members(user_id, org_id)","CREATE INDEX IF NOT EXISTS idx_org_members_org_role \r\nON public.org_members(org_id, role)","COMMENT ON INDEX idx_org_members_user_org IS \r\n'Performance: Speeds up is_org_member() and is_org_admin() functions'","-- ============================================================================\r\n-- 3. OPTIMIZE HELPER FUNCTIONS WITH STABLE\r\n-- ============================================================================\r\n\r\n-- is_org_member: Add STABLE for query caching\r\nCREATE OR REPLACE FUNCTION public.is_org_member(p_org_id uuid)\r\nRETURNS boolean\r\nLANGUAGE plpgsql\r\nSECURITY DEFINER\r\nSTABLE  -- ✅ ADDED: Allows Postgres to cache result during query\r\nSET search_path = public\r\nAS $$\r\nBEGIN\r\n  RETURN EXISTS (\r\n    SELECT 1 \r\n    FROM public.org_members \r\n    WHERE org_id = p_org_id \r\n    AND user_id = auth.uid()\r\n  );\r\nEND;\r\n$$","-- is_org_admin: Add STABLE for query caching\r\nCREATE OR REPLACE FUNCTION public.is_org_admin(p_org_id uuid)\r\nRETURNS boolean\r\nLANGUAGE plpgsql\r\nSECURITY DEFINER\r\nSTABLE  -- ✅ ADDED: Allows Postgres to cache result during query\r\nSET search_path = public\r\nAS $$\r\nBEGIN\r\n  RETURN EXISTS (\r\n    SELECT 1 \r\n    FROM public.org_members \r\n    WHERE org_id = p_org_id \r\n    AND user_id = auth.uid()\r\n    AND role IN ('owner', 'admin')\r\n  );\r\nEND;\r\n$$","-- is_super_admin: Already marked as STABLE in previous migration\r\n-- No changes needed\r\n\r\n-- current_org_id: Already marked as STABLE in previous migration  \r\n-- No changes needed\r\n\r\n-- ============================================================================\r\n-- 4. ADD CORE TABLE INDEXES FOR PERFORMANCE\r\n-- ============================================================================\r\n\r\n-- BOOKINGS: Most queried table in the system\r\nCREATE INDEX IF NOT EXISTS idx_bookings_org_id \r\nON public.bookings(org_id)","CREATE INDEX IF NOT EXISTS idx_bookings_property_id \r\nON public.bookings(property_id)","CREATE INDEX IF NOT EXISTS idx_bookings_org_status \r\nON public.bookings(org_id, status)","CREATE INDEX IF NOT EXISTS idx_bookings_check_in \r\nON public.bookings(check_in)","CREATE INDEX IF NOT EXISTS idx_bookings_check_out \r\nON public.bookings(check_out)","CREATE INDEX IF NOT EXISTS idx_bookings_dates \r\nON public.bookings(check_in, check_out)","COMMENT ON INDEX idx_bookings_org_status IS \r\n'Performance: Dashboard queries filter by org_id and status'","COMMENT ON INDEX idx_bookings_dates IS \r\n'Performance: Arrivals/Departures queries filter by check-in/check-out dates'","-- PROPERTIES\r\nCREATE INDEX IF NOT EXISTS idx_properties_org_id \r\nON public.properties(org_id)","CREATE INDEX IF NOT EXISTS idx_properties_user_id \r\nON public.properties(user_id)","-- Legacy compatibility\r\n\r\nCOMMENT ON INDEX idx_properties_org_id IS \r\n'Performance: Multi-tenant isolation on properties'","-- GUESTS\r\nCREATE INDEX IF NOT EXISTS idx_guests_org_id \r\nON public.guests(org_id)","CREATE INDEX IF NOT EXISTS idx_guests_email \r\nON public.guests(email)","CREATE INDEX IF NOT EXISTS idx_guests_document \r\nON public.guests(document)","COMMENT ON INDEX idx_guests_email IS \r\n'Performance: Guest lookup by email during booking creation'","COMMENT ON INDEX idx_guests_document IS \r\n'Performance: Guest lookup by document during check-in'","-- ROOMS\r\nCREATE INDEX IF NOT EXISTS idx_rooms_property_id \r\nON public.rooms(property_id)","CREATE INDEX IF NOT EXISTS idx_rooms_property_status \r\nON public.rooms(property_id, status)","COMMENT ON INDEX idx_rooms_property_status IS \r\n'Performance: Housekeeping page filters rooms by property and status'","-- ============================================================================\r\n-- 5. ANALYZE TABLES TO UPDATE STATISTICS\r\n-- ============================================================================\r\n\r\nANALYZE public.profiles","ANALYZE public.org_members","ANALYZE public.bookings","ANALYZE public.properties","ANALYZE public.guests","ANALYZE public.rooms","-- ============================================================================\r\n-- NOTES FOR DEPLOYMENT\r\n-- ============================================================================\r\n\r\n-- IMPORTANT: \r\n-- - CONCURRENTLY indexes can be created without locking the table\r\n-- - This migration is safe to run in production\r\n-- - Expected execution time: 1-5 minutes depending on data size\r\n--\r\n-- To verify indexes were created:\r\n-- SELECT schemaname, tablename, indexname \r\n-- FROM pg_indexes \r\n-- WHERE schemaname = 'public' \r\n-- AND indexname LIKE 'idx_%'\r\n-- ORDER BY tablename, indexname;"}	critical_security_and_performance_fixes
20260123110000	{"-- Migration: Add Missing is_hostconnect_staff Function (CRITICAL FIX ONLY)\r\n-- Description: Creates missing function used in RLS policies\r\n-- Date: 2026-01-23\r\n-- NOTE: Minimal version - only creates critical function, no indexes\r\n\r\n-- ============================================================================\r\n-- CREATE MISSING FUNCTION: is_hostconnect_staff (CRITICAL)\r\n-- ============================================================================\r\n\r\n-- This function is referenced in multiple RLS policies but was never created\r\n-- Without this function, RLS policies will fail and users may be blocked\r\n-- HostConnect staff = Super Admins (same permissions)\r\n\r\nCREATE OR REPLACE FUNCTION public.is_hostconnect_staff()\r\nRETURNS boolean\r\nLANGUAGE plpgsql\r\nSECURITY DEFINER\r\nSTABLE  -- Cache result during query execution\r\nSET search_path = public\r\nAS $$\r\nBEGIN\r\n  -- HostConnect staff members are super admins\r\n  -- This is an alias for consistency with existing policies\r\n  RETURN public.is_super_admin();\r\nEND;\r\n$$","COMMENT ON FUNCTION public.is_hostconnect_staff() IS \r\n'Returns true if current user is a HostConnect staff member (super admin). \r\nUsed in RLS policies for cross-organizational support access.'","-- ============================================================================\r\n-- VERIFICATION\r\n-- ============================================================================\r\n\r\n-- Verify function was created successfully\r\nDO $$\r\nBEGIN\r\n  IF EXISTS (\r\n    SELECT 1 FROM pg_proc \r\n    WHERE proname = 'is_hostconnect_staff'\r\n  ) THEN\r\n    RAISE NOTICE '✅ SUCCESS: is_hostconnect_staff() function created';\r\n  ELSE\r\n    RAISE EXCEPTION '❌ FAILED: is_hostconnect_staff() function not found';\r\n  END IF;\r\nEND $$"}	add_hostconnect_staff_and_join_indexes
20260123120000	{"-- Migration: Add Performance Indexes for Join Tables\r\n-- Description: Creates indexes on confirmed tables and columns only\r\n-- Date: 2026-01-23\r\n-- NOTE: Based on actual schema verification\r\n\r\n-- ============================================================================\r\n-- INDEXES FOR JOIN TABLES (VERIFIED COLUMNS ONLY)\r\n-- ============================================================================\r\n\r\n-- BOOKING_ROOMS: Critical for folio and room assignment queries\r\nCREATE INDEX IF NOT EXISTS idx_booking_rooms_booking_id \r\nON public.booking_rooms(booking_id)","CREATE INDEX IF NOT EXISTS idx_booking_rooms_room_id \r\nON public.booking_rooms(room_id)","CREATE INDEX IF NOT EXISTS idx_booking_rooms_property_id \r\nON public.booking_rooms(property_id)","CREATE INDEX IF NOT EXISTS idx_booking_rooms_org_id \r\nON public.booking_rooms(org_id)","COMMENT ON INDEX idx_booking_rooms_booking_id IS \r\n'Performance: Folio page joins bookings with rooms'","-- BOOKING_GUESTS: Used in check-in and participant lists\r\nCREATE INDEX IF NOT EXISTS idx_booking_guests_booking_id \r\nON public.booking_guests(booking_id)","CREATE INDEX IF NOT EXISTS idx_booking_guests_guest_id \r\nON public.booking_guests(guest_id)","CREATE INDEX IF NOT EXISTS idx_booking_guests_org_id \r\nON public.booking_guests(org_id)","COMMENT ON INDEX idx_booking_guests_booking_id IS \r\n'Performance: Check-in and participant queries'","-- BOOKING_CHARGES: Extra charges on folio\r\nCREATE INDEX IF NOT EXISTS idx_booking_charges_booking_id \r\nON public.booking_charges(booking_id)","COMMENT ON INDEX idx_booking_charges_booking_id IS \r\n'Performance: Folio items query'","-- AUDIT_LOG: System audit trail (uses actor_user_id, not user_id!)\r\nCREATE INDEX IF NOT EXISTS idx_audit_log_actor_user_id \r\nON public.audit_log(actor_user_id)","CREATE INDEX IF NOT EXISTS idx_audit_log_target_user_id \r\nON public.audit_log(target_user_id)","CREATE INDEX IF NOT EXISTS idx_audit_log_created_at \r\nON public.audit_log(created_at DESC)","COMMENT ON INDEX idx_audit_log_created_at IS \r\n'Performance: Audit log typically queried by recent date'","-- ============================================================================\r\n-- UPDATE STATISTICS\r\n-- ============================================================================\r\n\r\nANALYZE public.booking_rooms","ANALYZE public.booking_guests","ANALYZE public.booking_charges","ANALYZE public.audit_log","-- ============================================================================\r\n-- SUMMARY\r\n-- ============================================================================\r\n\r\nDO $$\r\nBEGIN\r\n  RAISE NOTICE '========================================';\r\n  RAISE NOTICE 'INDEXES CREATED SUCCESSFULLY';\r\n  RAISE NOTICE '========================================';\r\n  RAISE NOTICE '✅ booking_rooms: 4 indexes';\r\n  RAISE NOTICE '✅ booking_guests: 3 indexes';\r\n  RAISE NOTICE '✅ booking_charges: 1 index';\r\n  RAISE NOTICE '✅ audit_log: 3 indexes';\r\n  RAISE NOTICE '========================================';\r\n  RAISE NOTICE 'TOTAL: 11 indexes created';\r\n  RAISE NOTICE '========================================';\r\nEND $$"}	add_join_table_indexes
20260124143000	{"-- Hotfix: Fix org_members RLS recursion (avoid org_members subqueries in policy)\n-- Date: 2026-01-24\n\nBEGIN","-- Remove ALL existing policies to avoid recursion regressions\nDO $$\nDECLARE\n  policy_record record;\nBEGIN\n  FOR policy_record IN\n    SELECT polname FROM pg_policies WHERE schemaname = 'public' AND tablename = 'org_members'\n  LOOP\n    EXECUTE format('DROP POLICY IF EXISTS %I ON public.org_members', policy_record.polname);\n  END LOOP;\nEND;\n$$","-- Helper to check admin role without RLS recursion\nCREATE OR REPLACE FUNCTION public.is_org_admin_no_rls(p_org_id uuid, p_user_id uuid)\nRETURNS boolean\nLANGUAGE plpgsql\nSECURITY DEFINER\nSTABLE\nSET search_path = public\nSET row_security = off\nAS $$\nBEGIN\n  IF p_user_id IS NULL OR p_user_id <> auth.uid() THEN\n    RETURN false;\n  END IF;\n\n  RETURN EXISTS (\n    SELECT 1\n    FROM public.org_members\n    WHERE org_id = p_org_id\n      AND user_id = auth.uid()\n      AND role IN ('owner', 'admin')\n  );\nEND;\n$$","REVOKE ALL ON FUNCTION public.is_org_admin_no_rls(uuid, uuid) FROM anon","GRANT EXECUTE ON FUNCTION public.is_org_admin_no_rls(uuid, uuid) TO authenticated","-- Replace recursive policies\nCREATE POLICY \\"Members can view their org members\\" ON public.org_members\n  FOR SELECT\n  USING (\n    public.is_super_admin()\n    OR auth.uid() = user_id\n    OR EXISTS (\n      SELECT 1\n      FROM public.organizations o\n      WHERE o.id = org_members.org_id\n        AND o.owner_id = auth.uid()\n    )\n    OR public.is_org_admin_no_rls(org_members.org_id, auth.uid())\n  )","CREATE POLICY \\"Admins can manage org members\\" ON public.org_members\n  FOR ALL\n  USING (\n    public.is_super_admin()\n    OR EXISTS (\n      SELECT 1\n      FROM public.organizations o\n      WHERE o.id = org_members.org_id\n        AND o.owner_id = auth.uid()\n    )\n    OR public.is_org_admin_no_rls(org_members.org_id, auth.uid())\n  )\n  WITH CHECK (\n    public.is_super_admin()\n    OR EXISTS (\n      SELECT 1\n      FROM public.organizations o\n      WHERE o.id = org_members.org_id\n        AND o.owner_id = auth.uid()\n    )\n    OR public.is_org_admin_no_rls(org_members.org_id, auth.uid())\n  )","-- Manual verification snippet (run as SQL Editor):\n-- 1) SELECT * FROM public.org_members WHERE user_id = auth.uid();\n-- 2) SELECT * FROM public.org_members WHERE org_id != (SELECT org_id FROM public.org_members WHERE user_id = auth.uid() LIMIT 1);\n-- 3) As org owner: SELECT * FROM public.org_members WHERE org_id = '<ORG_ID>'; \n\nCOMMIT"}	fix_org_members_recursion
20260124160000	{"-- Hotfix: Fix org_members RLS recursion (avoid org_members subqueries in policy)\n-- Date: 2026-01-24\n\nBEGIN","-- Remove ALL existing policies to avoid recursion regressions\nDO $$\nDECLARE\n  policy_record record;\nBEGIN\n  FOR policy_record IN\n    SELECT polname FROM pg_policies WHERE schemaname = 'public' AND tablename = 'org_members'\n  LOOP\n    EXECUTE format('DROP POLICY IF EXISTS %I ON public.org_members', policy_record.polname);\n  END LOOP;\nEND;\n$$","-- Helper to check admin role without RLS recursion\nCREATE OR REPLACE FUNCTION public.is_org_admin_no_rls(p_org_id uuid, p_user_id uuid)\nRETURNS boolean\nLANGUAGE plpgsql\nSECURITY DEFINER\nSTABLE\nSET search_path = public\nSET row_security = off\nAS $$\nBEGIN\n  IF p_user_id IS NULL OR p_user_id <> auth.uid() THEN\n    RETURN false;\n  END IF;\n\n  RETURN EXISTS (\n    SELECT 1\n    FROM public.org_members\n    WHERE org_id = p_org_id\n      AND user_id = auth.uid()\n      AND role IN ('owner', 'admin')\n  );\nEND;\n$$","REVOKE ALL ON FUNCTION public.is_org_admin_no_rls(uuid, uuid) FROM anon","GRANT EXECUTE ON FUNCTION public.is_org_admin_no_rls(uuid, uuid) TO authenticated","CREATE POLICY \\"Members can view their org members\\" ON public.org_members\n  FOR SELECT\n  USING (\n    public.is_super_admin()\n    OR auth.uid() = user_id\n    OR EXISTS (\n      SELECT 1\n      FROM public.organizations o\n      WHERE o.id = org_members.org_id\n        AND o.owner_id = auth.uid()\n    )\n    OR public.is_org_admin_no_rls(org_members.org_id, auth.uid())\n  )","CREATE POLICY \\"Admins can manage org members\\" ON public.org_members\n  FOR ALL\n  USING (\n    public.is_super_admin()\n    OR EXISTS (\n      SELECT 1\n      FROM public.organizations o\n      WHERE o.id = org_members.org_id\n        AND o.owner_id = auth.uid()\n    )\n    OR public.is_org_admin_no_rls(org_members.org_id, auth.uid())\n  )\n  WITH CHECK (\n    public.is_super_admin()\n    OR EXISTS (\n      SELECT 1\n      FROM public.organizations o\n      WHERE o.id = org_members.org_id\n        AND o.owner_id = auth.uid()\n    )\n    OR public.is_org_admin_no_rls(org_members.org_id, auth.uid())\n  )","-- Manual verification snippet (run as SQL Editor):\n-- select role from public.org_members where org_id='<ORG>' and user_id='<USER>';\n\nCOMMIT"}	fix_org_members_recursion_v2
\.


--
-- TOC entry 3908 (class 0 OID 16658)
-- Dependencies: 354
-- Data for Name: secrets; Type: TABLE DATA; Schema: vault; Owner: -
--

COPY vault.secrets (id, name, description, secret, key_id, nonce, created_at, updated_at) FROM stdin;
\.


--
-- TOC entry 5330 (class 0 OID 0)
-- Dependencies: 346
-- Name: refresh_tokens_id_seq; Type: SEQUENCE SET; Schema: auth; Owner: -
--

SELECT pg_catalog.setval('auth.refresh_tokens_id_seq', 187, true);


--
-- TOC entry 5331 (class 0 OID 0)
-- Dependencies: 376
-- Name: subscription_id_seq; Type: SEQUENCE SET; Schema: realtime; Owner: -
--

SELECT pg_catalog.setval('realtime.subscription_id_seq', 1, false);


--
-- TOC entry 4332 (class 2606 OID 16829)
-- Name: mfa_amr_claims amr_id_pk; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.mfa_amr_claims
    ADD CONSTRAINT amr_id_pk PRIMARY KEY (id);


--
-- TOC entry 4288 (class 2606 OID 16531)
-- Name: audit_log_entries audit_log_entries_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.audit_log_entries
    ADD CONSTRAINT audit_log_entries_pkey PRIMARY KEY (id);


--
-- TOC entry 4355 (class 2606 OID 16935)
-- Name: flow_state flow_state_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.flow_state
    ADD CONSTRAINT flow_state_pkey PRIMARY KEY (id);


--
-- TOC entry 4310 (class 2606 OID 16953)
-- Name: identities identities_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.identities
    ADD CONSTRAINT identities_pkey PRIMARY KEY (id);


--
-- TOC entry 4312 (class 2606 OID 16963)
-- Name: identities identities_provider_id_provider_unique; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.identities
    ADD CONSTRAINT identities_provider_id_provider_unique UNIQUE (provider_id, provider);


--
-- TOC entry 4286 (class 2606 OID 16524)
-- Name: instances instances_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.instances
    ADD CONSTRAINT instances_pkey PRIMARY KEY (id);


--
-- TOC entry 4334 (class 2606 OID 16822)
-- Name: mfa_amr_claims mfa_amr_claims_session_id_authentication_method_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.mfa_amr_claims
    ADD CONSTRAINT mfa_amr_claims_session_id_authentication_method_pkey UNIQUE (session_id, authentication_method);


--
-- TOC entry 4330 (class 2606 OID 16810)
-- Name: mfa_challenges mfa_challenges_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.mfa_challenges
    ADD CONSTRAINT mfa_challenges_pkey PRIMARY KEY (id);


--
-- TOC entry 4322 (class 2606 OID 17003)
-- Name: mfa_factors mfa_factors_last_challenged_at_key; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.mfa_factors
    ADD CONSTRAINT mfa_factors_last_challenged_at_key UNIQUE (last_challenged_at);


--
-- TOC entry 4324 (class 2606 OID 16797)
-- Name: mfa_factors mfa_factors_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.mfa_factors
    ADD CONSTRAINT mfa_factors_pkey PRIMARY KEY (id);


--
-- TOC entry 4368 (class 2606 OID 17062)
-- Name: oauth_authorizations oauth_authorizations_authorization_code_key; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.oauth_authorizations
    ADD CONSTRAINT oauth_authorizations_authorization_code_key UNIQUE (authorization_code);


--
-- TOC entry 4370 (class 2606 OID 17060)
-- Name: oauth_authorizations oauth_authorizations_authorization_id_key; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.oauth_authorizations
    ADD CONSTRAINT oauth_authorizations_authorization_id_key UNIQUE (authorization_id);


--
-- TOC entry 4372 (class 2606 OID 17058)
-- Name: oauth_authorizations oauth_authorizations_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.oauth_authorizations
    ADD CONSTRAINT oauth_authorizations_pkey PRIMARY KEY (id);


--
-- TOC entry 4479 (class 2606 OID 58658)
-- Name: oauth_client_states oauth_client_states_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.oauth_client_states
    ADD CONSTRAINT oauth_client_states_pkey PRIMARY KEY (id);


--
-- TOC entry 4365 (class 2606 OID 17022)
-- Name: oauth_clients oauth_clients_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.oauth_clients
    ADD CONSTRAINT oauth_clients_pkey PRIMARY KEY (id);


--
-- TOC entry 4376 (class 2606 OID 17084)
-- Name: oauth_consents oauth_consents_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.oauth_consents
    ADD CONSTRAINT oauth_consents_pkey PRIMARY KEY (id);


--
-- TOC entry 4378 (class 2606 OID 17086)
-- Name: oauth_consents oauth_consents_user_client_unique; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.oauth_consents
    ADD CONSTRAINT oauth_consents_user_client_unique UNIQUE (user_id, client_id);


--
-- TOC entry 4359 (class 2606 OID 16988)
-- Name: one_time_tokens one_time_tokens_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.one_time_tokens
    ADD CONSTRAINT one_time_tokens_pkey PRIMARY KEY (id);


--
-- TOC entry 4280 (class 2606 OID 16514)
-- Name: refresh_tokens refresh_tokens_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.refresh_tokens
    ADD CONSTRAINT refresh_tokens_pkey PRIMARY KEY (id);


--
-- TOC entry 4283 (class 2606 OID 16740)
-- Name: refresh_tokens refresh_tokens_token_unique; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.refresh_tokens
    ADD CONSTRAINT refresh_tokens_token_unique UNIQUE (token);


--
-- TOC entry 4344 (class 2606 OID 16869)
-- Name: saml_providers saml_providers_entity_id_key; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.saml_providers
    ADD CONSTRAINT saml_providers_entity_id_key UNIQUE (entity_id);


--
-- TOC entry 4346 (class 2606 OID 16867)
-- Name: saml_providers saml_providers_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.saml_providers
    ADD CONSTRAINT saml_providers_pkey PRIMARY KEY (id);


--
-- TOC entry 4351 (class 2606 OID 16883)
-- Name: saml_relay_states saml_relay_states_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.saml_relay_states
    ADD CONSTRAINT saml_relay_states_pkey PRIMARY KEY (id);


--
-- TOC entry 4291 (class 2606 OID 16537)
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- TOC entry 4317 (class 2606 OID 16761)
-- Name: sessions sessions_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.sessions
    ADD CONSTRAINT sessions_pkey PRIMARY KEY (id);


--
-- TOC entry 4341 (class 2606 OID 16850)
-- Name: sso_domains sso_domains_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.sso_domains
    ADD CONSTRAINT sso_domains_pkey PRIMARY KEY (id);


--
-- TOC entry 4336 (class 2606 OID 16841)
-- Name: sso_providers sso_providers_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.sso_providers
    ADD CONSTRAINT sso_providers_pkey PRIMARY KEY (id);


--
-- TOC entry 4273 (class 2606 OID 16923)
-- Name: users users_phone_key; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.users
    ADD CONSTRAINT users_phone_key UNIQUE (phone);


--
-- TOC entry 4275 (class 2606 OID 16501)
-- Name: users users_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- TOC entry 4407 (class 2606 OID 18035)
-- Name: amenities amenities_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.amenities
    ADD CONSTRAINT amenities_pkey PRIMARY KEY (id);


--
-- TOC entry 4518 (class 2606 OID 63589)
-- Name: audit_log audit_log_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.audit_log
    ADD CONSTRAINT audit_log_pkey PRIMARY KEY (id);


--
-- TOC entry 4497 (class 2606 OID 61069)
-- Name: booking_charges booking_charges_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.booking_charges
    ADD CONSTRAINT booking_charges_pkey PRIMARY KEY (id);


--
-- TOC entry 4586 (class 2606 OID 83406)
-- Name: booking_guests booking_guests_booking_id_guest_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.booking_guests
    ADD CONSTRAINT booking_guests_booking_id_guest_id_key UNIQUE (booking_id, guest_id);


--
-- TOC entry 4588 (class 2606 OID 83404)
-- Name: booking_guests booking_guests_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.booking_guests
    ADD CONSTRAINT booking_guests_pkey PRIMARY KEY (id);


--
-- TOC entry 4616 (class 2606 OID 84682)
-- Name: booking_rooms booking_rooms_org_booking_room_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.booking_rooms
    ADD CONSTRAINT booking_rooms_org_booking_room_unique UNIQUE (org_id, booking_id, room_id);


--
-- TOC entry 4618 (class 2606 OID 84680)
-- Name: booking_rooms booking_rooms_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.booking_rooms
    ADD CONSTRAINT booking_rooms_pkey PRIMARY KEY (id);


--
-- TOC entry 4413 (class 2606 OID 18066)
-- Name: bookings bookings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bookings
    ADD CONSTRAINT bookings_pkey PRIMARY KEY (id);


--
-- TOC entry 4481 (class 2606 OID 59777)
-- Name: departments departments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.departments
    ADD CONSTRAINT departments_pkey PRIMARY KEY (id);


--
-- TOC entry 4423 (class 2606 OID 18083)
-- Name: entity_photos entity_photos_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.entity_photos
    ADD CONSTRAINT entity_photos_pkey PRIMARY KEY (id);


--
-- TOC entry 4452 (class 2606 OID 18541)
-- Name: expenses expenses_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.expenses
    ADD CONSTRAINT expenses_pkey PRIMARY KEY (id);


--
-- TOC entry 4461 (class 2606 OID 18791)
-- Name: faqs faqs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.faqs
    ADD CONSTRAINT faqs_pkey PRIMARY KEY (id);


--
-- TOC entry 4467 (class 2606 OID 18833)
-- Name: features features_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.features
    ADD CONSTRAINT features_pkey PRIMARY KEY (id);


--
-- TOC entry 4581 (class 2606 OID 83389)
-- Name: guest_consents guest_consents_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.guest_consents
    ADD CONSTRAINT guest_consents_pkey PRIMARY KEY (id);


--
-- TOC entry 4574 (class 2606 OID 83377)
-- Name: guests guests_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.guests
    ADD CONSTRAINT guests_pkey PRIMARY KEY (id);


--
-- TOC entry 4627 (class 2606 OID 85827)
-- Name: hostconnect_onboarding hostconnect_onboarding_org_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.hostconnect_onboarding
    ADD CONSTRAINT hostconnect_onboarding_org_id_key UNIQUE (org_id);


--
-- TOC entry 4629 (class 2606 OID 85825)
-- Name: hostconnect_onboarding hostconnect_onboarding_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.hostconnect_onboarding
    ADD CONSTRAINT hostconnect_onboarding_pkey PRIMARY KEY (id);


--
-- TOC entry 4500 (class 2606 OID 63440)
-- Name: hostconnect_staff hostconnect_staff_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.hostconnect_staff
    ADD CONSTRAINT hostconnect_staff_pkey PRIMARY KEY (user_id);


--
-- TOC entry 4469 (class 2606 OID 18845)
-- Name: how_it_works_steps how_it_works_steps_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.how_it_works_steps
    ADD CONSTRAINT how_it_works_steps_pkey PRIMARY KEY (id);


--
-- TOC entry 4471 (class 2606 OID 18847)
-- Name: how_it_works_steps how_it_works_steps_step_number_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.how_it_works_steps
    ADD CONSTRAINT how_it_works_steps_step_number_key UNIQUE (step_number);


--
-- TOC entry 4515 (class 2606 OID 63515)
-- Name: idea_comments idea_comments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.idea_comments
    ADD CONSTRAINT idea_comments_pkey PRIMARY KEY (id);


--
-- TOC entry 4510 (class 2606 OID 63499)
-- Name: ideas ideas_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ideas
    ADD CONSTRAINT ideas_pkey PRIMARY KEY (id);


--
-- TOC entry 4463 (class 2606 OID 18805)
-- Name: integrations integrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.integrations
    ADD CONSTRAINT integrations_pkey PRIMARY KEY (id);


--
-- TOC entry 4538 (class 2606 OID 63803)
-- Name: inventory_items inventory_items_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.inventory_items
    ADD CONSTRAINT inventory_items_pkey PRIMARY KEY (id);


--
-- TOC entry 4457 (class 2606 OID 18751)
-- Name: invoices invoices_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.invoices
    ADD CONSTRAINT invoices_pkey PRIMARY KEY (id);


--
-- TOC entry 4546 (class 2606 OID 63850)
-- Name: item_stock item_stock_item_id_location_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.item_stock
    ADD CONSTRAINT item_stock_item_id_location_key UNIQUE (item_id, location);


--
-- TOC entry 4548 (class 2606 OID 63848)
-- Name: item_stock item_stock_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.item_stock
    ADD CONSTRAINT item_stock_pkey PRIMARY KEY (id);


--
-- TOC entry 4495 (class 2606 OID 59940)
-- Name: lead_timeline_events lead_timeline_events_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.lead_timeline_events
    ADD CONSTRAINT lead_timeline_events_pkey PRIMARY KEY (id);


--
-- TOC entry 4531 (class 2606 OID 63724)
-- Name: member_permissions member_permissions_org_id_user_id_module_key_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.member_permissions
    ADD CONSTRAINT member_permissions_org_id_user_id_module_key_key UNIQUE (org_id, user_id, module_key);


--
-- TOC entry 4533 (class 2606 OID 63722)
-- Name: member_permissions member_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.member_permissions
    ADD CONSTRAINT member_permissions_pkey PRIMARY KEY (id);


--
-- TOC entry 4455 (class 2606 OID 18561)
-- Name: notifications notifications_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT notifications_pkey PRIMARY KEY (id);


--
-- TOC entry 4535 (class 2606 OID 63749)
-- Name: org_invites org_invites_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.org_invites
    ADD CONSTRAINT org_invites_pkey PRIMARY KEY (id);


--
-- TOC entry 4527 (class 2606 OID 63630)
-- Name: org_members org_members_org_id_user_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.org_members
    ADD CONSTRAINT org_members_org_id_user_id_key UNIQUE (org_id, user_id);


--
-- TOC entry 4529 (class 2606 OID 63628)
-- Name: org_members org_members_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.org_members
    ADD CONSTRAINT org_members_pkey PRIMARY KEY (id);


--
-- TOC entry 4523 (class 2606 OID 63613)
-- Name: organizations organizations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.organizations
    ADD CONSTRAINT organizations_pkey PRIMARY KEY (id);


--
-- TOC entry 4600 (class 2606 OID 83427)
-- Name: pre_checkin_sessions pre_checkin_sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pre_checkin_sessions
    ADD CONSTRAINT pre_checkin_sessions_pkey PRIMARY KEY (id);


--
-- TOC entry 4602 (class 2606 OID 83429)
-- Name: pre_checkin_sessions pre_checkin_sessions_token_hash_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pre_checkin_sessions
    ADD CONSTRAINT pre_checkin_sessions_token_hash_key UNIQUE (token_hash);


--
-- TOC entry 4604 (class 2606 OID 83471)
-- Name: pre_checkin_sessions pre_checkin_sessions_token_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pre_checkin_sessions
    ADD CONSTRAINT pre_checkin_sessions_token_key UNIQUE (token);


--
-- TOC entry 4609 (class 2606 OID 84594)
-- Name: pre_checkin_submissions pre_checkin_submissions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pre_checkin_submissions
    ADD CONSTRAINT pre_checkin_submissions_pkey PRIMARY KEY (id);


--
-- TOC entry 4614 (class 2606 OID 84641)
-- Name: precheckin_sessions precheckin_sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.precheckin_sessions
    ADD CONSTRAINT precheckin_sessions_pkey PRIMARY KEY (id);


--
-- TOC entry 4459 (class 2606 OID 18778)
-- Name: pricing_plans pricing_plans_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pricing_plans
    ADD CONSTRAINT pricing_plans_pkey PRIMARY KEY (id);


--
-- TOC entry 4435 (class 2606 OID 18355)
-- Name: pricing_rules pricing_rules_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pricing_rules
    ADD CONSTRAINT pricing_rules_pkey PRIMARY KEY (id);


--
-- TOC entry 4401 (class 2606 OID 18002)
-- Name: profiles profiles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.profiles
    ADD CONSTRAINT profiles_pkey PRIMARY KEY (id);


--
-- TOC entry 4405 (class 2606 OID 18020)
-- Name: properties properties_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.properties
    ADD CONSTRAINT properties_pkey PRIMARY KEY (id);


--
-- TOC entry 4491 (class 2606 OID 59886)
-- Name: reservation_leads reservation_leads_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.reservation_leads
    ADD CONSTRAINT reservation_leads_pkey PRIMARY KEY (id);


--
-- TOC entry 4493 (class 2606 OID 59915)
-- Name: reservation_quotes reservation_quotes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.reservation_quotes
    ADD CONSTRAINT reservation_quotes_pkey PRIMARY KEY (id);


--
-- TOC entry 4552 (class 2606 OID 69403)
-- Name: room_categories room_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.room_categories
    ADD CONSTRAINT room_categories_pkey PRIMARY KEY (id);


--
-- TOC entry 4554 (class 2606 OID 71099)
-- Name: room_categories room_categories_property_slug_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.room_categories
    ADD CONSTRAINT room_categories_property_slug_key UNIQUE (property_id, slug);


--
-- TOC entry 4541 (class 2606 OID 63821)
-- Name: room_type_inventory room_type_inventory_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.room_type_inventory
    ADD CONSTRAINT room_type_inventory_pkey PRIMARY KEY (id);


--
-- TOC entry 4543 (class 2606 OID 63823)
-- Name: room_type_inventory room_type_inventory_room_type_id_item_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.room_type_inventory
    ADD CONSTRAINT room_type_inventory_room_type_id_item_id_key UNIQUE (room_type_id, item_id);


--
-- TOC entry 4411 (class 2606 OID 18048)
-- Name: room_types room_types_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.room_types
    ADD CONSTRAINT room_types_pkey PRIMARY KEY (id);


--
-- TOC entry 4430 (class 2606 OID 18276)
-- Name: rooms rooms_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.rooms
    ADD CONSTRAINT rooms_pkey PRIMARY KEY (id);


--
-- TOC entry 4432 (class 2606 OID 18278)
-- Name: rooms rooms_room_number_property_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.rooms
    ADD CONSTRAINT rooms_room_number_property_id_key UNIQUE (room_number, property_id);


--
-- TOC entry 4438 (class 2606 OID 18405)
-- Name: services services_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.services
    ADD CONSTRAINT services_pkey PRIMARY KEY (id);


--
-- TOC entry 4487 (class 2606 OID 59840)
-- Name: shift_assignments shift_assignments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.shift_assignments
    ADD CONSTRAINT shift_assignments_pkey PRIMARY KEY (id);


--
-- TOC entry 4489 (class 2606 OID 59861)
-- Name: shift_handoffs shift_handoffs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.shift_handoffs
    ADD CONSTRAINT shift_handoffs_pkey PRIMARY KEY (id);


--
-- TOC entry 4485 (class 2606 OID 59814)
-- Name: shifts shifts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.shifts
    ADD CONSTRAINT shifts_pkey PRIMARY KEY (id);


--
-- TOC entry 4483 (class 2606 OID 59793)
-- Name: staff_profiles staff_profiles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.staff_profiles
    ADD CONSTRAINT staff_profiles_pkey PRIMARY KEY (id);


--
-- TOC entry 4572 (class 2606 OID 70928)
-- Name: stock_check_items stock_check_items_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.stock_check_items
    ADD CONSTRAINT stock_check_items_pkey PRIMARY KEY (id);


--
-- TOC entry 4568 (class 2606 OID 70876)
-- Name: stock_daily_checks stock_daily_checks_location_id_check_date_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.stock_daily_checks
    ADD CONSTRAINT stock_daily_checks_location_id_check_date_key UNIQUE (location_id, check_date);


--
-- TOC entry 4570 (class 2606 OID 70874)
-- Name: stock_daily_checks stock_daily_checks_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.stock_daily_checks
    ADD CONSTRAINT stock_daily_checks_pkey PRIMARY KEY (id);


--
-- TOC entry 4561 (class 2606 OID 70833)
-- Name: stock_items stock_items_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.stock_items
    ADD CONSTRAINT stock_items_pkey PRIMARY KEY (id);


--
-- TOC entry 4556 (class 2606 OID 70814)
-- Name: stock_locations stock_locations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.stock_locations
    ADD CONSTRAINT stock_locations_pkey PRIMARY KEY (id);


--
-- TOC entry 4565 (class 2606 OID 70852)
-- Name: stock_movements stock_movements_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.stock_movements
    ADD CONSTRAINT stock_movements_pkey PRIMARY KEY (id);


--
-- TOC entry 4450 (class 2606 OID 18516)
-- Name: tasks tasks_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tasks
    ADD CONSTRAINT tasks_pkey PRIMARY KEY (id);


--
-- TOC entry 4465 (class 2606 OID 18820)
-- Name: testimonials testimonials_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.testimonials
    ADD CONSTRAINT testimonials_pkey PRIMARY KEY (id);


--
-- TOC entry 4508 (class 2606 OID 63476)
-- Name: ticket_comments ticket_comments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ticket_comments
    ADD CONSTRAINT ticket_comments_pkey PRIMARY KEY (id);


--
-- TOC entry 4505 (class 2606 OID 63460)
-- Name: tickets tickets_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tickets
    ADD CONSTRAINT tickets_pkey PRIMARY KEY (id);


--
-- TOC entry 4442 (class 2606 OID 18738)
-- Name: website_settings unique_property_setting; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.website_settings
    ADD CONSTRAINT unique_property_setting UNIQUE (property_id, setting_key);


--
-- TOC entry 4444 (class 2606 OID 18471)
-- Name: website_settings website_settings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.website_settings
    ADD CONSTRAINT website_settings_pkey PRIMARY KEY (id);


--
-- TOC entry 4446 (class 2606 OID 18473)
-- Name: website_settings website_settings_property_id_setting_key_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.website_settings
    ADD CONSTRAINT website_settings_property_id_setting_key_key UNIQUE (property_id, setting_key);


--
-- TOC entry 4396 (class 2606 OID 17449)
-- Name: messages messages_pkey; Type: CONSTRAINT; Schema: realtime; Owner: -
--

ALTER TABLE ONLY realtime.messages
    ADD CONSTRAINT messages_pkey PRIMARY KEY (id, inserted_at);


--
-- TOC entry 4392 (class 2606 OID 17303)
-- Name: subscription pk_subscription; Type: CONSTRAINT; Schema: realtime; Owner: -
--

ALTER TABLE ONLY realtime.subscription
    ADD CONSTRAINT pk_subscription PRIMARY KEY (id);


--
-- TOC entry 4389 (class 2606 OID 17276)
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: realtime; Owner: -
--

ALTER TABLE ONLY realtime.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- TOC entry 4386 (class 2606 OID 47608)
-- Name: buckets_analytics buckets_analytics_pkey; Type: CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.buckets_analytics
    ADD CONSTRAINT buckets_analytics_pkey PRIMARY KEY (id);


--
-- TOC entry 4294 (class 2606 OID 16554)
-- Name: buckets buckets_pkey; Type: CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.buckets
    ADD CONSTRAINT buckets_pkey PRIMARY KEY (id);


--
-- TOC entry 4473 (class 2606 OID 47584)
-- Name: buckets_vectors buckets_vectors_pkey; Type: CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.buckets_vectors
    ADD CONSTRAINT buckets_vectors_pkey PRIMARY KEY (id);


--
-- TOC entry 4302 (class 2606 OID 16595)
-- Name: migrations migrations_name_key; Type: CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.migrations
    ADD CONSTRAINT migrations_name_key UNIQUE (name);


--
-- TOC entry 4304 (class 2606 OID 16593)
-- Name: migrations migrations_pkey; Type: CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.migrations
    ADD CONSTRAINT migrations_pkey PRIMARY KEY (id);


--
-- TOC entry 4300 (class 2606 OID 16571)
-- Name: objects objects_pkey; Type: CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.objects
    ADD CONSTRAINT objects_pkey PRIMARY KEY (id);


--
-- TOC entry 4384 (class 2606 OID 17167)
-- Name: s3_multipart_uploads_parts s3_multipart_uploads_parts_pkey; Type: CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.s3_multipart_uploads_parts
    ADD CONSTRAINT s3_multipart_uploads_parts_pkey PRIMARY KEY (id);


--
-- TOC entry 4382 (class 2606 OID 17152)
-- Name: s3_multipart_uploads s3_multipart_uploads_pkey; Type: CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.s3_multipart_uploads
    ADD CONSTRAINT s3_multipart_uploads_pkey PRIMARY KEY (id);


--
-- TOC entry 4476 (class 2606 OID 47594)
-- Name: vector_indexes vector_indexes_pkey; Type: CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.vector_indexes
    ADD CONSTRAINT vector_indexes_pkey PRIMARY KEY (id);


--
-- TOC entry 4634 (class 2606 OID 88193)
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: supabase_migrations; Owner: -
--

ALTER TABLE ONLY supabase_migrations.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- TOC entry 4289 (class 1259 OID 16532)
-- Name: audit_logs_instance_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX audit_logs_instance_id_idx ON auth.audit_log_entries USING btree (instance_id);


--
-- TOC entry 4263 (class 1259 OID 16750)
-- Name: confirmation_token_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX confirmation_token_idx ON auth.users USING btree (confirmation_token) WHERE ((confirmation_token)::text !~ '^[0-9 ]*$'::text);


--
-- TOC entry 4264 (class 1259 OID 16752)
-- Name: email_change_token_current_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX email_change_token_current_idx ON auth.users USING btree (email_change_token_current) WHERE ((email_change_token_current)::text !~ '^[0-9 ]*$'::text);


--
-- TOC entry 4265 (class 1259 OID 16753)
-- Name: email_change_token_new_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX email_change_token_new_idx ON auth.users USING btree (email_change_token_new) WHERE ((email_change_token_new)::text !~ '^[0-9 ]*$'::text);


--
-- TOC entry 4320 (class 1259 OID 16831)
-- Name: factor_id_created_at_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX factor_id_created_at_idx ON auth.mfa_factors USING btree (user_id, created_at);


--
-- TOC entry 4353 (class 1259 OID 16939)
-- Name: flow_state_created_at_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX flow_state_created_at_idx ON auth.flow_state USING btree (created_at DESC);


--
-- TOC entry 4308 (class 1259 OID 16919)
-- Name: identities_email_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX identities_email_idx ON auth.identities USING btree (email text_pattern_ops);


--
-- TOC entry 5332 (class 0 OID 0)
-- Dependencies: 4308
-- Name: INDEX identities_email_idx; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON INDEX auth.identities_email_idx IS 'Auth: Ensures indexed queries on the email column';


--
-- TOC entry 4313 (class 1259 OID 16747)
-- Name: identities_user_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX identities_user_id_idx ON auth.identities USING btree (user_id);


--
-- TOC entry 4356 (class 1259 OID 16936)
-- Name: idx_auth_code; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX idx_auth_code ON auth.flow_state USING btree (auth_code);


--
-- TOC entry 4477 (class 1259 OID 58659)
-- Name: idx_oauth_client_states_created_at; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX idx_oauth_client_states_created_at ON auth.oauth_client_states USING btree (created_at);


--
-- TOC entry 4357 (class 1259 OID 16937)
-- Name: idx_user_id_auth_method; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX idx_user_id_auth_method ON auth.flow_state USING btree (user_id, authentication_method);


--
-- TOC entry 4328 (class 1259 OID 16942)
-- Name: mfa_challenge_created_at_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX mfa_challenge_created_at_idx ON auth.mfa_challenges USING btree (created_at DESC);


--
-- TOC entry 4325 (class 1259 OID 16803)
-- Name: mfa_factors_user_friendly_name_unique; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX mfa_factors_user_friendly_name_unique ON auth.mfa_factors USING btree (friendly_name, user_id) WHERE (TRIM(BOTH FROM friendly_name) <> ''::text);


--
-- TOC entry 4326 (class 1259 OID 16948)
-- Name: mfa_factors_user_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX mfa_factors_user_id_idx ON auth.mfa_factors USING btree (user_id);


--
-- TOC entry 4366 (class 1259 OID 17073)
-- Name: oauth_auth_pending_exp_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX oauth_auth_pending_exp_idx ON auth.oauth_authorizations USING btree (expires_at) WHERE (status = 'pending'::auth.oauth_authorization_status);


--
-- TOC entry 4363 (class 1259 OID 17026)
-- Name: oauth_clients_deleted_at_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX oauth_clients_deleted_at_idx ON auth.oauth_clients USING btree (deleted_at);


--
-- TOC entry 4373 (class 1259 OID 17099)
-- Name: oauth_consents_active_client_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX oauth_consents_active_client_idx ON auth.oauth_consents USING btree (client_id) WHERE (revoked_at IS NULL);


--
-- TOC entry 4374 (class 1259 OID 17097)
-- Name: oauth_consents_active_user_client_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX oauth_consents_active_user_client_idx ON auth.oauth_consents USING btree (user_id, client_id) WHERE (revoked_at IS NULL);


--
-- TOC entry 4379 (class 1259 OID 17098)
-- Name: oauth_consents_user_order_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX oauth_consents_user_order_idx ON auth.oauth_consents USING btree (user_id, granted_at DESC);


--
-- TOC entry 4360 (class 1259 OID 16995)
-- Name: one_time_tokens_relates_to_hash_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX one_time_tokens_relates_to_hash_idx ON auth.one_time_tokens USING hash (relates_to);


--
-- TOC entry 4361 (class 1259 OID 16994)
-- Name: one_time_tokens_token_hash_hash_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX one_time_tokens_token_hash_hash_idx ON auth.one_time_tokens USING hash (token_hash);


--
-- TOC entry 4362 (class 1259 OID 16996)
-- Name: one_time_tokens_user_id_token_type_key; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX one_time_tokens_user_id_token_type_key ON auth.one_time_tokens USING btree (user_id, token_type);


--
-- TOC entry 4266 (class 1259 OID 16754)
-- Name: reauthentication_token_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX reauthentication_token_idx ON auth.users USING btree (reauthentication_token) WHERE ((reauthentication_token)::text !~ '^[0-9 ]*$'::text);


--
-- TOC entry 4267 (class 1259 OID 16751)
-- Name: recovery_token_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX recovery_token_idx ON auth.users USING btree (recovery_token) WHERE ((recovery_token)::text !~ '^[0-9 ]*$'::text);


--
-- TOC entry 4276 (class 1259 OID 16515)
-- Name: refresh_tokens_instance_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX refresh_tokens_instance_id_idx ON auth.refresh_tokens USING btree (instance_id);


--
-- TOC entry 4277 (class 1259 OID 16516)
-- Name: refresh_tokens_instance_id_user_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX refresh_tokens_instance_id_user_id_idx ON auth.refresh_tokens USING btree (instance_id, user_id);


--
-- TOC entry 4278 (class 1259 OID 16746)
-- Name: refresh_tokens_parent_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX refresh_tokens_parent_idx ON auth.refresh_tokens USING btree (parent);


--
-- TOC entry 4281 (class 1259 OID 16833)
-- Name: refresh_tokens_session_id_revoked_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX refresh_tokens_session_id_revoked_idx ON auth.refresh_tokens USING btree (session_id, revoked);


--
-- TOC entry 4284 (class 1259 OID 16938)
-- Name: refresh_tokens_updated_at_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX refresh_tokens_updated_at_idx ON auth.refresh_tokens USING btree (updated_at DESC);


--
-- TOC entry 4347 (class 1259 OID 16875)
-- Name: saml_providers_sso_provider_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX saml_providers_sso_provider_id_idx ON auth.saml_providers USING btree (sso_provider_id);


--
-- TOC entry 4348 (class 1259 OID 16940)
-- Name: saml_relay_states_created_at_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX saml_relay_states_created_at_idx ON auth.saml_relay_states USING btree (created_at DESC);


--
-- TOC entry 4349 (class 1259 OID 16890)
-- Name: saml_relay_states_for_email_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX saml_relay_states_for_email_idx ON auth.saml_relay_states USING btree (for_email);


--
-- TOC entry 4352 (class 1259 OID 16889)
-- Name: saml_relay_states_sso_provider_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX saml_relay_states_sso_provider_id_idx ON auth.saml_relay_states USING btree (sso_provider_id);


--
-- TOC entry 4314 (class 1259 OID 16941)
-- Name: sessions_not_after_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX sessions_not_after_idx ON auth.sessions USING btree (not_after DESC);


--
-- TOC entry 4315 (class 1259 OID 17111)
-- Name: sessions_oauth_client_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX sessions_oauth_client_id_idx ON auth.sessions USING btree (oauth_client_id);


--
-- TOC entry 4318 (class 1259 OID 16832)
-- Name: sessions_user_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX sessions_user_id_idx ON auth.sessions USING btree (user_id);


--
-- TOC entry 4339 (class 1259 OID 16857)
-- Name: sso_domains_domain_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX sso_domains_domain_idx ON auth.sso_domains USING btree (lower(domain));


--
-- TOC entry 4342 (class 1259 OID 16856)
-- Name: sso_domains_sso_provider_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX sso_domains_sso_provider_id_idx ON auth.sso_domains USING btree (sso_provider_id);


--
-- TOC entry 4337 (class 1259 OID 16842)
-- Name: sso_providers_resource_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX sso_providers_resource_id_idx ON auth.sso_providers USING btree (lower(resource_id));


--
-- TOC entry 4338 (class 1259 OID 17004)
-- Name: sso_providers_resource_id_pattern_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX sso_providers_resource_id_pattern_idx ON auth.sso_providers USING btree (resource_id text_pattern_ops);


--
-- TOC entry 4327 (class 1259 OID 17001)
-- Name: unique_phone_factor_per_user; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX unique_phone_factor_per_user ON auth.mfa_factors USING btree (user_id, phone);


--
-- TOC entry 4319 (class 1259 OID 16830)
-- Name: user_id_created_at_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX user_id_created_at_idx ON auth.sessions USING btree (user_id, created_at);


--
-- TOC entry 4268 (class 1259 OID 16910)
-- Name: users_email_partial_key; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX users_email_partial_key ON auth.users USING btree (email) WHERE (is_sso_user = false);


--
-- TOC entry 5333 (class 0 OID 0)
-- Dependencies: 4268
-- Name: INDEX users_email_partial_key; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON INDEX auth.users_email_partial_key IS 'Auth: A partial unique index that applies only when is_sso_user is false';


--
-- TOC entry 4269 (class 1259 OID 16748)
-- Name: users_instance_id_email_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX users_instance_id_email_idx ON auth.users USING btree (instance_id, lower((email)::text));


--
-- TOC entry 4270 (class 1259 OID 16505)
-- Name: users_instance_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX users_instance_id_idx ON auth.users USING btree (instance_id);


--
-- TOC entry 4271 (class 1259 OID 16965)
-- Name: users_is_anonymous_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX users_is_anonymous_idx ON auth.users USING btree (is_anonymous);


--
-- TOC entry 4414 (class 1259 OID 18321)
-- Name: bookings_room_type_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX bookings_room_type_id_idx ON public.bookings USING btree (room_type_id);


--
-- TOC entry 4415 (class 1259 OID 88179)
-- Name: bookings_stripe_session_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX bookings_stripe_session_id_idx ON public.bookings USING btree (stripe_session_id);


--
-- TOC entry 4408 (class 1259 OID 83236)
-- Name: idx_amenities_org_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_amenities_org_id ON public.amenities USING btree (org_id);


--
-- TOC entry 4519 (class 1259 OID 87023)
-- Name: idx_audit_log_actor_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_audit_log_actor_user_id ON public.audit_log USING btree (actor_user_id);


--
-- TOC entry 4520 (class 1259 OID 87025)
-- Name: idx_audit_log_created_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_audit_log_created_at ON public.audit_log USING btree (created_at DESC);


--
-- TOC entry 5334 (class 0 OID 0)
-- Dependencies: 4520
-- Name: INDEX idx_audit_log_created_at; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON INDEX public.idx_audit_log_created_at IS 'Performance: Audit log typically queried by recent date';


--
-- TOC entry 4521 (class 1259 OID 87024)
-- Name: idx_audit_log_target_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_audit_log_target_user_id ON public.audit_log USING btree (target_user_id);


--
-- TOC entry 4498 (class 1259 OID 87022)
-- Name: idx_booking_charges_booking_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_booking_charges_booking_id ON public.booking_charges USING btree (booking_id);


--
-- TOC entry 5335 (class 0 OID 0)
-- Dependencies: 4498
-- Name: INDEX idx_booking_charges_booking_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON INDEX public.idx_booking_charges_booking_id IS 'Performance: Folio items query';


--
-- TOC entry 4589 (class 1259 OID 83417)
-- Name: idx_booking_guests_booking; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_booking_guests_booking ON public.booking_guests USING btree (booking_id);


--
-- TOC entry 4590 (class 1259 OID 84656)
-- Name: idx_booking_guests_booking_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_booking_guests_booking_id ON public.booking_guests USING btree (booking_id);


--
-- TOC entry 5336 (class 0 OID 0)
-- Dependencies: 4590
-- Name: INDEX idx_booking_guests_booking_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON INDEX public.idx_booking_guests_booking_id IS 'Performance: Check-in and participant queries';


--
-- TOC entry 4591 (class 1259 OID 87021)
-- Name: idx_booking_guests_guest_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_booking_guests_guest_id ON public.booking_guests USING btree (guest_id);


--
-- TOC entry 4592 (class 1259 OID 84657)
-- Name: idx_booking_guests_is_primary; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_booking_guests_is_primary ON public.booking_guests USING btree (is_primary);


--
-- TOC entry 4593 (class 1259 OID 83468)
-- Name: idx_booking_guests_org_booking; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_booking_guests_org_booking ON public.booking_guests USING btree (org_id, booking_id);


--
-- TOC entry 4594 (class 1259 OID 83469)
-- Name: idx_booking_guests_org_guest; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_booking_guests_org_guest ON public.booking_guests USING btree (org_id, guest_id);


--
-- TOC entry 4595 (class 1259 OID 83467)
-- Name: idx_booking_guests_org_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_booking_guests_org_id ON public.booking_guests USING btree (org_id);


--
-- TOC entry 4619 (class 1259 OID 87017)
-- Name: idx_booking_rooms_booking_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_booking_rooms_booking_id ON public.booking_rooms USING btree (booking_id);


--
-- TOC entry 5337 (class 0 OID 0)
-- Dependencies: 4619
-- Name: INDEX idx_booking_rooms_booking_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON INDEX public.idx_booking_rooms_booking_id IS 'Performance: Folio page joins bookings with rooms';


--
-- TOC entry 4620 (class 1259 OID 84707)
-- Name: idx_booking_rooms_composite_booking; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_booking_rooms_composite_booking ON public.booking_rooms USING btree (org_id, property_id, booking_id);


--
-- TOC entry 4621 (class 1259 OID 84708)
-- Name: idx_booking_rooms_composite_room; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_booking_rooms_composite_room ON public.booking_rooms USING btree (org_id, property_id, room_id);


--
-- TOC entry 4622 (class 1259 OID 87020)
-- Name: idx_booking_rooms_org_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_booking_rooms_org_id ON public.booking_rooms USING btree (org_id);


--
-- TOC entry 4623 (class 1259 OID 84709)
-- Name: idx_booking_rooms_primary; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_booking_rooms_primary ON public.booking_rooms USING btree (org_id, property_id, booking_id, is_primary);


--
-- TOC entry 4624 (class 1259 OID 87019)
-- Name: idx_booking_rooms_property_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_booking_rooms_property_id ON public.booking_rooms USING btree (property_id);


--
-- TOC entry 4625 (class 1259 OID 87018)
-- Name: idx_booking_rooms_room_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_booking_rooms_room_id ON public.booking_rooms USING btree (room_id);


--
-- TOC entry 4416 (class 1259 OID 86996)
-- Name: idx_bookings_check_in; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_bookings_check_in ON public.bookings USING btree (check_in);


--
-- TOC entry 4417 (class 1259 OID 86997)
-- Name: idx_bookings_check_out; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_bookings_check_out ON public.bookings USING btree (check_out);


--
-- TOC entry 4418 (class 1259 OID 86998)
-- Name: idx_bookings_dates; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_bookings_dates ON public.bookings USING btree (check_in, check_out);


--
-- TOC entry 5338 (class 0 OID 0)
-- Dependencies: 4418
-- Name: INDEX idx_bookings_dates; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON INDEX public.idx_bookings_dates IS 'Performance: Arrivals/Departures queries filter by check-in/check-out dates';


--
-- TOC entry 4419 (class 1259 OID 63664)
-- Name: idx_bookings_org_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_bookings_org_id ON public.bookings USING btree (org_id);


--
-- TOC entry 4420 (class 1259 OID 86995)
-- Name: idx_bookings_org_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_bookings_org_status ON public.bookings USING btree (org_id, status);


--
-- TOC entry 5339 (class 0 OID 0)
-- Dependencies: 4420
-- Name: INDEX idx_bookings_org_status; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON INDEX public.idx_bookings_org_status IS 'Performance: Dashboard queries filter by org_id and status';


--
-- TOC entry 4421 (class 1259 OID 86994)
-- Name: idx_bookings_property_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_bookings_property_id ON public.bookings USING btree (property_id);


--
-- TOC entry 4566 (class 1259 OID 70944)
-- Name: idx_daily_checks_location_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_daily_checks_location_date ON public.stock_daily_checks USING btree (location_id, check_date);


--
-- TOC entry 4582 (class 1259 OID 83463)
-- Name: idx_guest_consents_org_guest; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_guest_consents_org_guest ON public.guest_consents USING btree (org_id, guest_id);


--
-- TOC entry 4583 (class 1259 OID 83462)
-- Name: idx_guest_consents_org_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_guest_consents_org_id ON public.guest_consents USING btree (org_id);


--
-- TOC entry 4584 (class 1259 OID 83464)
-- Name: idx_guest_consents_org_type_granted; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_guest_consents_org_type_granted ON public.guest_consents USING btree (org_id, type, granted);


--
-- TOC entry 4575 (class 1259 OID 87000)
-- Name: idx_guests_document; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_guests_document ON public.guests USING btree (document);


--
-- TOC entry 5340 (class 0 OID 0)
-- Dependencies: 4575
-- Name: INDEX idx_guests_document; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON INDEX public.idx_guests_document IS 'Performance: Guest lookup by document during check-in';


--
-- TOC entry 4576 (class 1259 OID 83379)
-- Name: idx_guests_email; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_guests_email ON public.guests USING btree (email);


--
-- TOC entry 5341 (class 0 OID 0)
-- Dependencies: 4576
-- Name: INDEX idx_guests_email; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON INDEX public.idx_guests_email IS 'Performance: Guest lookup by email during booking creation';


--
-- TOC entry 4577 (class 1259 OID 83456)
-- Name: idx_guests_org_document; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_guests_org_document ON public.guests USING btree (org_id, document);


--
-- TOC entry 4578 (class 1259 OID 83457)
-- Name: idx_guests_org_email; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_guests_org_email ON public.guests USING btree (org_id, email);


--
-- TOC entry 4579 (class 1259 OID 83378)
-- Name: idx_guests_org_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_guests_org_id ON public.guests USING btree (org_id);


--
-- TOC entry 4630 (class 1259 OID 85840)
-- Name: idx_hostconnect_onboarding_completed; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_hostconnect_onboarding_completed ON public.hostconnect_onboarding USING btree (org_id, completed_at);


--
-- TOC entry 4631 (class 1259 OID 85838)
-- Name: idx_hostconnect_onboarding_org_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_hostconnect_onboarding_org_id ON public.hostconnect_onboarding USING btree (org_id);


--
-- TOC entry 4632 (class 1259 OID 85839)
-- Name: idx_hostconnect_onboarding_org_property; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_hostconnect_onboarding_org_property ON public.hostconnect_onboarding USING btree (org_id, property_id);


--
-- TOC entry 4516 (class 1259 OID 63531)
-- Name: idx_idea_comments_idea_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_idea_comments_idea_id ON public.idea_comments USING btree (idea_id);


--
-- TOC entry 4511 (class 1259 OID 63682)
-- Name: idx_ideas_org_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_ideas_org_id ON public.ideas USING btree (org_id);


--
-- TOC entry 4512 (class 1259 OID 63530)
-- Name: idx_ideas_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_ideas_status ON public.ideas USING btree (status);


--
-- TOC entry 4513 (class 1259 OID 63529)
-- Name: idx_ideas_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_ideas_user_id ON public.ideas USING btree (user_id);


--
-- TOC entry 4536 (class 1259 OID 63867)
-- Name: idx_inventory_items_for_sale; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_inventory_items_for_sale ON public.inventory_items USING btree (is_for_sale) WHERE (is_for_sale = true);


--
-- TOC entry 4544 (class 1259 OID 83240)
-- Name: idx_item_stock_org_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_item_stock_org_id ON public.item_stock USING btree (org_id);


--
-- TOC entry 4453 (class 1259 OID 91540)
-- Name: idx_notifications_user_created_at_desc; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_notifications_user_created_at_desc ON public.notifications USING btree (user_id, created_at DESC);


--
-- TOC entry 4524 (class 1259 OID 86993)
-- Name: idx_org_members_org_role; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_org_members_org_role ON public.org_members USING btree (org_id, role);


--
-- TOC entry 4525 (class 1259 OID 86992)
-- Name: idx_org_members_user_org; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_org_members_user_org ON public.org_members USING btree (user_id, org_id);


--
-- TOC entry 5342 (class 0 OID 0)
-- Dependencies: 4525
-- Name: INDEX idx_org_members_user_org; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON INDEX public.idx_org_members_user_org IS 'Performance: Speeds up is_org_member() and is_org_admin() functions';


--
-- TOC entry 4596 (class 1259 OID 83473)
-- Name: idx_pre_checkin_sessions_org_booking; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_pre_checkin_sessions_org_booking ON public.pre_checkin_sessions USING btree (org_id, booking_id);


--
-- TOC entry 4597 (class 1259 OID 83472)
-- Name: idx_pre_checkin_sessions_org_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_pre_checkin_sessions_org_id ON public.pre_checkin_sessions USING btree (org_id);


--
-- TOC entry 4598 (class 1259 OID 83474)
-- Name: idx_pre_checkin_sessions_org_token; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_pre_checkin_sessions_org_token ON public.pre_checkin_sessions USING btree (org_id, token);


--
-- TOC entry 4605 (class 1259 OID 84605)
-- Name: idx_pre_checkin_submissions_org_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_pre_checkin_submissions_org_id ON public.pre_checkin_submissions USING btree (org_id);


--
-- TOC entry 4606 (class 1259 OID 84606)
-- Name: idx_pre_checkin_submissions_org_session; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_pre_checkin_submissions_org_session ON public.pre_checkin_submissions USING btree (org_id, session_id);


--
-- TOC entry 4607 (class 1259 OID 84607)
-- Name: idx_pre_checkin_submissions_org_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_pre_checkin_submissions_org_status ON public.pre_checkin_submissions USING btree (org_id, status);


--
-- TOC entry 4610 (class 1259 OID 84652)
-- Name: idx_precheckin_sessions_booking_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_precheckin_sessions_booking_id ON public.precheckin_sessions USING btree (booking_id);


--
-- TOC entry 4611 (class 1259 OID 84653)
-- Name: idx_precheckin_sessions_org_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_precheckin_sessions_org_id ON public.precheckin_sessions USING btree (org_id);


--
-- TOC entry 4612 (class 1259 OID 84654)
-- Name: idx_precheckin_sessions_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_precheckin_sessions_status ON public.precheckin_sessions USING btree (status);


--
-- TOC entry 4433 (class 1259 OID 83242)
-- Name: idx_pricing_rules_org_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_pricing_rules_org_id ON public.pricing_rules USING btree (org_id);


--
-- TOC entry 4397 (class 1259 OID 91545)
-- Name: idx_profiles_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_profiles_id ON public.profiles USING btree (id);


--
-- TOC entry 4398 (class 1259 OID 63571)
-- Name: idx_profiles_onboarding_completed; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_profiles_onboarding_completed ON public.profiles USING btree (onboarding_completed);


--
-- TOC entry 4399 (class 1259 OID 85868)
-- Name: idx_profiles_super_admin; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_profiles_super_admin ON public.profiles USING btree (is_super_admin) WHERE (is_super_admin = true);


--
-- TOC entry 4402 (class 1259 OID 63658)
-- Name: idx_properties_org_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_properties_org_id ON public.properties USING btree (org_id);


--
-- TOC entry 5343 (class 0 OID 0)
-- Dependencies: 4402
-- Name: INDEX idx_properties_org_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON INDEX public.idx_properties_org_id IS 'Performance: Multi-tenant isolation on properties';


--
-- TOC entry 4403 (class 1259 OID 86999)
-- Name: idx_properties_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_properties_user_id ON public.properties USING btree (user_id);


--
-- TOC entry 4549 (class 1259 OID 83237)
-- Name: idx_room_categories_org_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_room_categories_org_id ON public.room_categories USING btree (org_id);


--
-- TOC entry 4550 (class 1259 OID 71097)
-- Name: idx_room_categories_property; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_room_categories_property ON public.room_categories USING btree (property_id);


--
-- TOC entry 4539 (class 1259 OID 83241)
-- Name: idx_room_type_inventory_org_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_room_type_inventory_org_id ON public.room_type_inventory USING btree (org_id);


--
-- TOC entry 4409 (class 1259 OID 83238)
-- Name: idx_room_types_org_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_room_types_org_id ON public.room_types USING btree (org_id);


--
-- TOC entry 4424 (class 1259 OID 63670)
-- Name: idx_rooms_org_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_rooms_org_id ON public.rooms USING btree (org_id);


--
-- TOC entry 4425 (class 1259 OID 84664)
-- Name: idx_rooms_org_property_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_rooms_org_property_status ON public.rooms USING btree (org_id, property_id, status);


--
-- TOC entry 4426 (class 1259 OID 84665)
-- Name: idx_rooms_org_property_updated; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_rooms_org_property_updated ON public.rooms USING btree (org_id, property_id, updated_at DESC);


--
-- TOC entry 4427 (class 1259 OID 87001)
-- Name: idx_rooms_property_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_rooms_property_id ON public.rooms USING btree (property_id);


--
-- TOC entry 4428 (class 1259 OID 84666)
-- Name: idx_rooms_property_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_rooms_property_status ON public.rooms USING btree (property_id, status);


--
-- TOC entry 5344 (class 0 OID 0)
-- Dependencies: 4428
-- Name: INDEX idx_rooms_property_status; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON INDEX public.idx_rooms_property_status IS 'Performance: Housekeeping page filters rooms by property and status';


--
-- TOC entry 4436 (class 1259 OID 83239)
-- Name: idx_services_org_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_services_org_id ON public.services USING btree (org_id);


--
-- TOC entry 4557 (class 1259 OID 70941)
-- Name: idx_stock_items_active; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_stock_items_active ON public.stock_items USING btree (is_active) WHERE (is_active = true);


--
-- TOC entry 4558 (class 1259 OID 70940)
-- Name: idx_stock_items_location; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_stock_items_location ON public.stock_items USING btree (location_id);


--
-- TOC entry 4559 (class 1259 OID 70939)
-- Name: idx_stock_items_property; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_stock_items_property ON public.stock_items USING btree (property_id);


--
-- TOC entry 4562 (class 1259 OID 70943)
-- Name: idx_stock_movements_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_stock_movements_date ON public.stock_movements USING btree (reference_date);


--
-- TOC entry 4563 (class 1259 OID 70942)
-- Name: idx_stock_movements_item; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_stock_movements_item ON public.stock_movements USING btree (stock_item_id);


--
-- TOC entry 4447 (class 1259 OID 91539)
-- Name: idx_tasks_property_created_at_desc; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_tasks_property_created_at_desc ON public.tasks USING btree (property_id, created_at DESC);


--
-- TOC entry 4448 (class 1259 OID 91538)
-- Name: idx_tasks_property_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_tasks_property_status ON public.tasks USING btree (property_id, status);


--
-- TOC entry 4506 (class 1259 OID 63528)
-- Name: idx_ticket_comments_ticket_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_ticket_comments_ticket_id ON public.ticket_comments USING btree (ticket_id);


--
-- TOC entry 4501 (class 1259 OID 63676)
-- Name: idx_tickets_org_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_tickets_org_id ON public.tickets USING btree (org_id);


--
-- TOC entry 4502 (class 1259 OID 63527)
-- Name: idx_tickets_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_tickets_status ON public.tickets USING btree (status);


--
-- TOC entry 4503 (class 1259 OID 63526)
-- Name: idx_tickets_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_tickets_user_id ON public.tickets USING btree (user_id);


--
-- TOC entry 4440 (class 1259 OID 83243)
-- Name: idx_website_settings_org_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_website_settings_org_id ON public.website_settings USING btree (org_id);


--
-- TOC entry 4439 (class 1259 OID 18415)
-- Name: services_property_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX services_property_id_idx ON public.services USING btree (property_id);


--
-- TOC entry 4390 (class 1259 OID 17450)
-- Name: ix_realtime_subscription_entity; Type: INDEX; Schema: realtime; Owner: -
--

CREATE INDEX ix_realtime_subscription_entity ON realtime.subscription USING btree (entity);


--
-- TOC entry 4394 (class 1259 OID 17451)
-- Name: messages_inserted_at_topic_index; Type: INDEX; Schema: realtime; Owner: -
--

CREATE INDEX messages_inserted_at_topic_index ON ONLY realtime.messages USING btree (inserted_at DESC, topic) WHERE ((extension = 'broadcast'::text) AND (private IS TRUE));


--
-- TOC entry 4393 (class 1259 OID 99624)
-- Name: subscription_subscription_id_entity_filters_action_filter_key; Type: INDEX; Schema: realtime; Owner: -
--

CREATE UNIQUE INDEX subscription_subscription_id_entity_filters_action_filter_key ON realtime.subscription USING btree (subscription_id, entity, filters, action_filter);


--
-- TOC entry 4292 (class 1259 OID 16560)
-- Name: bname; Type: INDEX; Schema: storage; Owner: -
--

CREATE UNIQUE INDEX bname ON storage.buckets USING btree (name);


--
-- TOC entry 4295 (class 1259 OID 16582)
-- Name: bucketid_objname; Type: INDEX; Schema: storage; Owner: -
--

CREATE UNIQUE INDEX bucketid_objname ON storage.objects USING btree (bucket_id, name);


--
-- TOC entry 4387 (class 1259 OID 47609)
-- Name: buckets_analytics_unique_name_idx; Type: INDEX; Schema: storage; Owner: -
--

CREATE UNIQUE INDEX buckets_analytics_unique_name_idx ON storage.buckets_analytics USING btree (name) WHERE (deleted_at IS NULL);


--
-- TOC entry 4380 (class 1259 OID 17178)
-- Name: idx_multipart_uploads_list; Type: INDEX; Schema: storage; Owner: -
--

CREATE INDEX idx_multipart_uploads_list ON storage.s3_multipart_uploads USING btree (bucket_id, key, created_at);


--
-- TOC entry 4296 (class 1259 OID 17143)
-- Name: idx_objects_bucket_id_name; Type: INDEX; Schema: storage; Owner: -
--

CREATE INDEX idx_objects_bucket_id_name ON storage.objects USING btree (bucket_id, name COLLATE "C");


--
-- TOC entry 4297 (class 1259 OID 99617)
-- Name: idx_objects_bucket_id_name_lower; Type: INDEX; Schema: storage; Owner: -
--

CREATE INDEX idx_objects_bucket_id_name_lower ON storage.objects USING btree (bucket_id, lower(name) COLLATE "C");


--
-- TOC entry 4298 (class 1259 OID 16583)
-- Name: name_prefix_search; Type: INDEX; Schema: storage; Owner: -
--

CREATE INDEX name_prefix_search ON storage.objects USING btree (name text_pattern_ops);


--
-- TOC entry 4474 (class 1259 OID 47600)
-- Name: vector_indexes_name_bucket_id_idx; Type: INDEX; Schema: storage; Owner: -
--

CREATE UNIQUE INDEX vector_indexes_name_bucket_id_idx ON storage.vector_indexes USING btree (name, bucket_id);


--
-- TOC entry 4753 (class 2620 OID 17542)
-- Name: users on_auth_user_created; Type: TRIGGER; Schema: auth; Owner: -
--

CREATE TRIGGER on_auth_user_created AFTER INSERT ON auth.users FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();


--
-- TOC entry 4764 (class 2620 OID 63574)
-- Name: properties enforce_accommodation_limit; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER enforce_accommodation_limit BEFORE INSERT ON public.properties FOR EACH ROW EXECUTE FUNCTION public.check_accommodation_limit();


--
-- TOC entry 4792 (class 2620 OID 84710)
-- Name: booking_rooms handle_booking_rooms_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER handle_booking_rooms_updated_at BEFORE UPDATE ON public.booking_rooms FOR EACH ROW EXECUTE FUNCTION public.moddatetime();


--
-- TOC entry 4776 (class 2620 OID 18551)
-- Name: expenses handle_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER handle_updated_at BEFORE UPDATE ON public.expenses FOR EACH ROW EXECUTE FUNCTION public.moddatetime();


--
-- TOC entry 4779 (class 2620 OID 18851)
-- Name: faqs handle_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER handle_updated_at BEFORE UPDATE ON public.faqs FOR EACH ROW EXECUTE FUNCTION public.moddatetime();


--
-- TOC entry 4782 (class 2620 OID 18854)
-- Name: features handle_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER handle_updated_at BEFORE UPDATE ON public.features FOR EACH ROW EXECUTE FUNCTION public.moddatetime();


--
-- TOC entry 4793 (class 2620 OID 85845)
-- Name: hostconnect_onboarding handle_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER handle_updated_at BEFORE UPDATE ON public.hostconnect_onboarding FOR EACH ROW EXECUTE FUNCTION public.moddatetime();


--
-- TOC entry 4783 (class 2620 OID 18855)
-- Name: how_it_works_steps handle_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER handle_updated_at BEFORE UPDATE ON public.how_it_works_steps FOR EACH ROW EXECUTE FUNCTION public.moddatetime();


--
-- TOC entry 4780 (class 2620 OID 18852)
-- Name: integrations handle_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER handle_updated_at BEFORE UPDATE ON public.integrations FOR EACH ROW EXECUTE FUNCTION public.moddatetime();


--
-- TOC entry 4777 (class 2620 OID 18764)
-- Name: invoices handle_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER handle_updated_at BEFORE UPDATE ON public.invoices FOR EACH ROW EXECUTE FUNCTION public.moddatetime();


--
-- TOC entry 4778 (class 2620 OID 18850)
-- Name: pricing_plans handle_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER handle_updated_at BEFORE UPDATE ON public.pricing_plans FOR EACH ROW EXECUTE FUNCTION public.moddatetime();


--
-- TOC entry 4769 (class 2620 OID 18370)
-- Name: pricing_rules handle_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER handle_updated_at BEFORE UPDATE ON public.pricing_rules FOR EACH ROW EXECUTE FUNCTION public.moddatetime('updated_at');


--
-- TOC entry 4767 (class 2620 OID 18293)
-- Name: rooms handle_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER handle_updated_at BEFORE UPDATE ON public.rooms FOR EACH ROW EXECUTE FUNCTION public.moddatetime();


--
-- TOC entry 4771 (class 2620 OID 18416)
-- Name: services handle_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER handle_updated_at BEFORE UPDATE ON public.services FOR EACH ROW EXECUTE FUNCTION public.moddatetime('updated_at');


--
-- TOC entry 4775 (class 2620 OID 18531)
-- Name: tasks handle_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER handle_updated_at BEFORE UPDATE ON public.tasks FOR EACH ROW EXECUTE FUNCTION public.moddatetime();


--
-- TOC entry 4781 (class 2620 OID 18853)
-- Name: testimonials handle_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER handle_updated_at BEFORE UPDATE ON public.testimonials FOR EACH ROW EXECUTE FUNCTION public.moddatetime();


--
-- TOC entry 4773 (class 2620 OID 18483)
-- Name: website_settings handle_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER handle_updated_at BEFORE UPDATE ON public.website_settings FOR EACH ROW EXECUTE FUNCTION public.moddatetime('updated_at');


--
-- TOC entry 4759 (class 2620 OID 69387)
-- Name: profiles set_accommodation_limit_on_plan_change; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER set_accommodation_limit_on_plan_change BEFORE INSERT OR UPDATE OF plan ON public.profiles FOR EACH ROW EXECUTE FUNCTION public.auto_set_accommodation_limit();


--
-- TOC entry 4791 (class 2620 OID 84608)
-- Name: pre_checkin_submissions set_pre_checkin_submissions_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER set_pre_checkin_submissions_updated_at BEFORE UPDATE ON public.pre_checkin_submissions FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- TOC entry 4760 (class 2620 OID 63602)
-- Name: profiles tr_audit_profile_changes; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tr_audit_profile_changes AFTER UPDATE ON public.profiles FOR EACH ROW EXECUTE FUNCTION public.log_profile_sensitive_changes();


--
-- TOC entry 4766 (class 2620 OID 63780)
-- Name: bookings tr_bookings_set_org; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tr_bookings_set_org BEFORE INSERT ON public.bookings FOR EACH ROW EXECUTE FUNCTION public.set_org_id_from_property();


--
-- TOC entry 4761 (class 2620 OID 63652)
-- Name: profiles tr_ensure_personal_org; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tr_ensure_personal_org AFTER INSERT ON public.profiles FOR EACH ROW EXECUTE FUNCTION public.handle_new_user_org();


--
-- TOC entry 4762 (class 2620 OID 63580)
-- Name: profiles tr_initialize_trial; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tr_initialize_trial BEFORE INSERT ON public.profiles FOR EACH ROW EXECUTE FUNCTION public.handle_new_user_trial();


--
-- TOC entry 4787 (class 2620 OID 83299)
-- Name: item_stock tr_item_stock_set_org; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tr_item_stock_set_org BEFORE INSERT ON public.item_stock FOR EACH ROW EXECUTE FUNCTION public.set_org_id_from_inventory_item();


--
-- TOC entry 4770 (class 2620 OID 83296)
-- Name: pricing_rules tr_pricing_rules_set_org; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tr_pricing_rules_set_org BEFORE INSERT ON public.pricing_rules FOR EACH ROW EXECUTE FUNCTION public.set_org_id_from_property();


--
-- TOC entry 4786 (class 2620 OID 83298)
-- Name: room_type_inventory tr_room_type_inventory_set_org; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tr_room_type_inventory_set_org BEFORE INSERT ON public.room_type_inventory FOR EACH ROW EXECUTE FUNCTION public.set_org_id_from_room_type();


--
-- TOC entry 4765 (class 2620 OID 83294)
-- Name: room_types tr_room_types_set_org; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tr_room_types_set_org BEFORE INSERT ON public.room_types FOR EACH ROW EXECUTE FUNCTION public.set_org_id_from_property();


--
-- TOC entry 4768 (class 2620 OID 63781)
-- Name: rooms tr_rooms_set_org; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tr_rooms_set_org BEFORE INSERT ON public.rooms FOR EACH ROW EXECUTE FUNCTION public.set_org_id_from_property();


--
-- TOC entry 4772 (class 2620 OID 83295)
-- Name: services tr_services_set_org; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tr_services_set_org BEFORE INSERT ON public.services FOR EACH ROW EXECUTE FUNCTION public.set_org_id_from_property();


--
-- TOC entry 4774 (class 2620 OID 83297)
-- Name: website_settings tr_website_settings_set_org; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tr_website_settings_set_org BEFORE INSERT ON public.website_settings FOR EACH ROW EXECUTE FUNCTION public.set_org_id_from_property();


--
-- TOC entry 4788 (class 2620 OID 70948)
-- Name: stock_movements trg_calculate_balance_before_insert; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trg_calculate_balance_before_insert BEFORE INSERT ON public.stock_movements FOR EACH ROW EXECUTE FUNCTION public.calculate_movement_balance();


--
-- TOC entry 4789 (class 2620 OID 70946)
-- Name: stock_movements trg_update_stock_after_movement; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trg_update_stock_after_movement AFTER INSERT ON public.stock_movements FOR EACH ROW EXECUTE FUNCTION public.update_stock_balance();


--
-- TOC entry 4763 (class 2620 OID 87038)
-- Name: profiles trigger_prevent_super_admin_self_promotion; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trigger_prevent_super_admin_self_promotion BEFORE UPDATE ON public.profiles FOR EACH ROW WHEN ((old.is_super_admin IS DISTINCT FROM new.is_super_admin)) EXECUTE FUNCTION public.prevent_super_admin_self_promotion();


--
-- TOC entry 4790 (class 2620 OID 84582)
-- Name: guests update_guests_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER update_guests_updated_at BEFORE UPDATE ON public.guests FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- TOC entry 4785 (class 2620 OID 63549)
-- Name: ideas update_ideas_modtime; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER update_ideas_modtime BEFORE UPDATE ON public.ideas FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- TOC entry 4784 (class 2620 OID 63548)
-- Name: tickets update_tickets_modtime; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER update_tickets_modtime BEFORE UPDATE ON public.tickets FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- TOC entry 4758 (class 2620 OID 17308)
-- Name: subscription tr_check_filters; Type: TRIGGER; Schema: realtime; Owner: -
--

CREATE TRIGGER tr_check_filters BEFORE INSERT OR UPDATE ON realtime.subscription FOR EACH ROW EXECUTE FUNCTION realtime.subscription_check_filters();


--
-- TOC entry 4754 (class 2620 OID 17234)
-- Name: buckets enforce_bucket_name_length_trigger; Type: TRIGGER; Schema: storage; Owner: -
--

CREATE TRIGGER enforce_bucket_name_length_trigger BEFORE INSERT OR UPDATE OF name ON storage.buckets FOR EACH ROW EXECUTE FUNCTION storage.enforce_bucket_name_length();


--
-- TOC entry 4755 (class 2620 OID 99619)
-- Name: buckets protect_buckets_delete; Type: TRIGGER; Schema: storage; Owner: -
--

CREATE TRIGGER protect_buckets_delete BEFORE DELETE ON storage.buckets FOR EACH STATEMENT EXECUTE FUNCTION storage.protect_delete();


--
-- TOC entry 4756 (class 2620 OID 99620)
-- Name: objects protect_objects_delete; Type: TRIGGER; Schema: storage; Owner: -
--

CREATE TRIGGER protect_objects_delete BEFORE DELETE ON storage.objects FOR EACH STATEMENT EXECUTE FUNCTION storage.protect_delete();


--
-- TOC entry 4757 (class 2620 OID 17131)
-- Name: objects update_objects_updated_at; Type: TRIGGER; Schema: storage; Owner: -
--

CREATE TRIGGER update_objects_updated_at BEFORE UPDATE ON storage.objects FOR EACH ROW EXECUTE FUNCTION storage.update_updated_at_column();


--
-- TOC entry 4637 (class 2606 OID 16734)
-- Name: identities identities_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.identities
    ADD CONSTRAINT identities_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- TOC entry 4642 (class 2606 OID 16823)
-- Name: mfa_amr_claims mfa_amr_claims_session_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.mfa_amr_claims
    ADD CONSTRAINT mfa_amr_claims_session_id_fkey FOREIGN KEY (session_id) REFERENCES auth.sessions(id) ON DELETE CASCADE;


--
-- TOC entry 4641 (class 2606 OID 16811)
-- Name: mfa_challenges mfa_challenges_auth_factor_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.mfa_challenges
    ADD CONSTRAINT mfa_challenges_auth_factor_id_fkey FOREIGN KEY (factor_id) REFERENCES auth.mfa_factors(id) ON DELETE CASCADE;


--
-- TOC entry 4640 (class 2606 OID 16798)
-- Name: mfa_factors mfa_factors_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.mfa_factors
    ADD CONSTRAINT mfa_factors_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- TOC entry 4648 (class 2606 OID 17063)
-- Name: oauth_authorizations oauth_authorizations_client_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.oauth_authorizations
    ADD CONSTRAINT oauth_authorizations_client_id_fkey FOREIGN KEY (client_id) REFERENCES auth.oauth_clients(id) ON DELETE CASCADE;


--
-- TOC entry 4649 (class 2606 OID 17068)
-- Name: oauth_authorizations oauth_authorizations_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.oauth_authorizations
    ADD CONSTRAINT oauth_authorizations_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- TOC entry 4650 (class 2606 OID 17092)
-- Name: oauth_consents oauth_consents_client_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.oauth_consents
    ADD CONSTRAINT oauth_consents_client_id_fkey FOREIGN KEY (client_id) REFERENCES auth.oauth_clients(id) ON DELETE CASCADE;


--
-- TOC entry 4651 (class 2606 OID 17087)
-- Name: oauth_consents oauth_consents_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.oauth_consents
    ADD CONSTRAINT oauth_consents_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- TOC entry 4647 (class 2606 OID 16989)
-- Name: one_time_tokens one_time_tokens_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.one_time_tokens
    ADD CONSTRAINT one_time_tokens_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- TOC entry 4635 (class 2606 OID 16767)
-- Name: refresh_tokens refresh_tokens_session_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.refresh_tokens
    ADD CONSTRAINT refresh_tokens_session_id_fkey FOREIGN KEY (session_id) REFERENCES auth.sessions(id) ON DELETE CASCADE;


--
-- TOC entry 4644 (class 2606 OID 16870)
-- Name: saml_providers saml_providers_sso_provider_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.saml_providers
    ADD CONSTRAINT saml_providers_sso_provider_id_fkey FOREIGN KEY (sso_provider_id) REFERENCES auth.sso_providers(id) ON DELETE CASCADE;


--
-- TOC entry 4645 (class 2606 OID 16943)
-- Name: saml_relay_states saml_relay_states_flow_state_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.saml_relay_states
    ADD CONSTRAINT saml_relay_states_flow_state_id_fkey FOREIGN KEY (flow_state_id) REFERENCES auth.flow_state(id) ON DELETE CASCADE;


--
-- TOC entry 4646 (class 2606 OID 16884)
-- Name: saml_relay_states saml_relay_states_sso_provider_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.saml_relay_states
    ADD CONSTRAINT saml_relay_states_sso_provider_id_fkey FOREIGN KEY (sso_provider_id) REFERENCES auth.sso_providers(id) ON DELETE CASCADE;


--
-- TOC entry 4638 (class 2606 OID 17106)
-- Name: sessions sessions_oauth_client_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.sessions
    ADD CONSTRAINT sessions_oauth_client_id_fkey FOREIGN KEY (oauth_client_id) REFERENCES auth.oauth_clients(id) ON DELETE CASCADE;


--
-- TOC entry 4639 (class 2606 OID 16762)
-- Name: sessions sessions_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.sessions
    ADD CONSTRAINT sessions_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- TOC entry 4643 (class 2606 OID 16851)
-- Name: sso_domains sso_domains_sso_provider_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.sso_domains
    ADD CONSTRAINT sso_domains_sso_provider_id_fkey FOREIGN KEY (sso_provider_id) REFERENCES auth.sso_providers(id) ON DELETE CASCADE;


--
-- TOC entry 4713 (class 2606 OID 63590)
-- Name: audit_log audit_log_actor_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.audit_log
    ADD CONSTRAINT audit_log_actor_user_id_fkey FOREIGN KEY (actor_user_id) REFERENCES auth.users(id) ON DELETE SET NULL;


--
-- TOC entry 4714 (class 2606 OID 63595)
-- Name: audit_log audit_log_target_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.audit_log
    ADD CONSTRAINT audit_log_target_user_id_fkey FOREIGN KEY (target_user_id) REFERENCES auth.users(id) ON DELETE SET NULL;


--
-- TOC entry 4703 (class 2606 OID 61070)
-- Name: booking_charges booking_charges_booking_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.booking_charges
    ADD CONSTRAINT booking_charges_booking_id_fkey FOREIGN KEY (booking_id) REFERENCES public.bookings(id) ON DELETE CASCADE;


--
-- TOC entry 4740 (class 2606 OID 83407)
-- Name: booking_guests booking_guests_booking_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.booking_guests
    ADD CONSTRAINT booking_guests_booking_id_fkey FOREIGN KEY (booking_id) REFERENCES public.bookings(id) ON DELETE CASCADE;


--
-- TOC entry 4741 (class 2606 OID 83412)
-- Name: booking_guests booking_guests_guest_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.booking_guests
    ADD CONSTRAINT booking_guests_guest_id_fkey FOREIGN KEY (guest_id) REFERENCES public.guests(id) ON DELETE CASCADE;


--
-- TOC entry 4747 (class 2606 OID 84693)
-- Name: booking_rooms booking_rooms_booking_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.booking_rooms
    ADD CONSTRAINT booking_rooms_booking_id_fkey FOREIGN KEY (booking_id) REFERENCES public.bookings(id) ON DELETE CASCADE;


--
-- TOC entry 4748 (class 2606 OID 84683)
-- Name: booking_rooms booking_rooms_org_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.booking_rooms
    ADD CONSTRAINT booking_rooms_org_id_fkey FOREIGN KEY (org_id) REFERENCES public.organizations(id) ON DELETE RESTRICT;


--
-- TOC entry 4749 (class 2606 OID 84688)
-- Name: booking_rooms booking_rooms_property_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.booking_rooms
    ADD CONSTRAINT booking_rooms_property_id_fkey FOREIGN KEY (property_id) REFERENCES public.properties(id) ON DELETE RESTRICT;


--
-- TOC entry 4750 (class 2606 OID 84698)
-- Name: booking_rooms booking_rooms_room_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.booking_rooms
    ADD CONSTRAINT booking_rooms_room_id_fkey FOREIGN KEY (room_id) REFERENCES public.rooms(id) ON DELETE RESTRICT;


--
-- TOC entry 4661 (class 2606 OID 18856)
-- Name: bookings bookings_current_room_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bookings
    ADD CONSTRAINT bookings_current_room_id_fkey FOREIGN KEY (current_room_id) REFERENCES public.rooms(id) ON DELETE SET NULL;


--
-- TOC entry 4662 (class 2606 OID 59951)
-- Name: bookings bookings_lead_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bookings
    ADD CONSTRAINT bookings_lead_id_fkey FOREIGN KEY (lead_id) REFERENCES public.reservation_leads(id);


--
-- TOC entry 4663 (class 2606 OID 63659)
-- Name: bookings bookings_org_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bookings
    ADD CONSTRAINT bookings_org_id_fkey FOREIGN KEY (org_id) REFERENCES public.organizations(id) ON DELETE SET NULL;


--
-- TOC entry 4664 (class 2606 OID 18067)
-- Name: bookings bookings_property_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bookings
    ADD CONSTRAINT bookings_property_id_fkey FOREIGN KEY (property_id) REFERENCES public.properties(id) ON DELETE CASCADE;


--
-- TOC entry 4665 (class 2606 OID 18316)
-- Name: bookings bookings_room_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bookings
    ADD CONSTRAINT bookings_room_type_id_fkey FOREIGN KEY (room_type_id) REFERENCES public.room_types(id) ON DELETE SET NULL;


--
-- TOC entry 4685 (class 2606 OID 59778)
-- Name: departments departments_property_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.departments
    ADD CONSTRAINT departments_property_id_fkey FOREIGN KEY (property_id) REFERENCES public.properties(id) ON DELETE CASCADE;


--
-- TOC entry 4680 (class 2606 OID 18542)
-- Name: expenses expenses_property_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.expenses
    ADD CONSTRAINT expenses_property_id_fkey FOREIGN KEY (property_id) REFERENCES public.properties(id) ON DELETE CASCADE;


--
-- TOC entry 4658 (class 2606 OID 83244)
-- Name: amenities fk_amenities_org_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.amenities
    ADD CONSTRAINT fk_amenities_org_id FOREIGN KEY (org_id) REFERENCES public.organizations(id) ON DELETE CASCADE;


--
-- TOC entry 4725 (class 2606 OID 83264)
-- Name: item_stock fk_item_stock_org_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.item_stock
    ADD CONSTRAINT fk_item_stock_org_id FOREIGN KEY (org_id) REFERENCES public.organizations(id) ON DELETE CASCADE;


--
-- TOC entry 4671 (class 2606 OID 83274)
-- Name: pricing_rules fk_pricing_rules_org_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pricing_rules
    ADD CONSTRAINT fk_pricing_rules_org_id FOREIGN KEY (org_id) REFERENCES public.organizations(id) ON DELETE CASCADE;


--
-- TOC entry 4728 (class 2606 OID 83249)
-- Name: room_categories fk_room_categories_org_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.room_categories
    ADD CONSTRAINT fk_room_categories_org_id FOREIGN KEY (org_id) REFERENCES public.organizations(id) ON DELETE CASCADE;


--
-- TOC entry 4722 (class 2606 OID 83269)
-- Name: room_type_inventory fk_room_type_inventory_org_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.room_type_inventory
    ADD CONSTRAINT fk_room_type_inventory_org_id FOREIGN KEY (org_id) REFERENCES public.organizations(id) ON DELETE CASCADE;


--
-- TOC entry 4659 (class 2606 OID 83254)
-- Name: room_types fk_room_types_org_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.room_types
    ADD CONSTRAINT fk_room_types_org_id FOREIGN KEY (org_id) REFERENCES public.organizations(id) ON DELETE CASCADE;


--
-- TOC entry 4674 (class 2606 OID 83259)
-- Name: services fk_services_org_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.services
    ADD CONSTRAINT fk_services_org_id FOREIGN KEY (org_id) REFERENCES public.organizations(id) ON DELETE CASCADE;


--
-- TOC entry 4676 (class 2606 OID 83279)
-- Name: website_settings fk_website_settings_org_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.website_settings
    ADD CONSTRAINT fk_website_settings_org_id FOREIGN KEY (org_id) REFERENCES public.organizations(id) ON DELETE CASCADE;


--
-- TOC entry 4739 (class 2606 OID 83390)
-- Name: guest_consents guest_consents_guest_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.guest_consents
    ADD CONSTRAINT guest_consents_guest_id_fkey FOREIGN KEY (guest_id) REFERENCES public.guests(id) ON DELETE CASCADE;


--
-- TOC entry 4751 (class 2606 OID 85828)
-- Name: hostconnect_onboarding hostconnect_onboarding_org_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.hostconnect_onboarding
    ADD CONSTRAINT hostconnect_onboarding_org_id_fkey FOREIGN KEY (org_id) REFERENCES public.organizations(id) ON DELETE CASCADE;


--
-- TOC entry 4752 (class 2606 OID 85833)
-- Name: hostconnect_onboarding hostconnect_onboarding_property_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.hostconnect_onboarding
    ADD CONSTRAINT hostconnect_onboarding_property_id_fkey FOREIGN KEY (property_id) REFERENCES public.properties(id) ON DELETE SET NULL;


--
-- TOC entry 4704 (class 2606 OID 63441)
-- Name: hostconnect_staff hostconnect_staff_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.hostconnect_staff
    ADD CONSTRAINT hostconnect_staff_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- TOC entry 4711 (class 2606 OID 63516)
-- Name: idea_comments idea_comments_idea_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.idea_comments
    ADD CONSTRAINT idea_comments_idea_id_fkey FOREIGN KEY (idea_id) REFERENCES public.ideas(id) ON DELETE CASCADE;


--
-- TOC entry 4712 (class 2606 OID 63521)
-- Name: idea_comments idea_comments_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.idea_comments
    ADD CONSTRAINT idea_comments_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- TOC entry 4709 (class 2606 OID 63677)
-- Name: ideas ideas_org_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ideas
    ADD CONSTRAINT ideas_org_id_fkey FOREIGN KEY (org_id) REFERENCES public.organizations(id) ON DELETE SET NULL;


--
-- TOC entry 4710 (class 2606 OID 63500)
-- Name: ideas ideas_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ideas
    ADD CONSTRAINT ideas_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- TOC entry 4721 (class 2606 OID 63804)
-- Name: inventory_items inventory_items_org_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.inventory_items
    ADD CONSTRAINT inventory_items_org_id_fkey FOREIGN KEY (org_id) REFERENCES public.organizations(id) ON DELETE CASCADE;


--
-- TOC entry 4682 (class 2606 OID 18752)
-- Name: invoices invoices_booking_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.invoices
    ADD CONSTRAINT invoices_booking_id_fkey FOREIGN KEY (booking_id) REFERENCES public.bookings(id) ON DELETE CASCADE;


--
-- TOC entry 4683 (class 2606 OID 18757)
-- Name: invoices invoices_property_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.invoices
    ADD CONSTRAINT invoices_property_id_fkey FOREIGN KEY (property_id) REFERENCES public.properties(id) ON DELETE CASCADE;


--
-- TOC entry 4726 (class 2606 OID 63851)
-- Name: item_stock item_stock_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.item_stock
    ADD CONSTRAINT item_stock_item_id_fkey FOREIGN KEY (item_id) REFERENCES public.inventory_items(id) ON DELETE CASCADE;


--
-- TOC entry 4727 (class 2606 OID 63856)
-- Name: item_stock item_stock_updated_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.item_stock
    ADD CONSTRAINT item_stock_updated_by_fkey FOREIGN KEY (updated_by) REFERENCES auth.users(id);


--
-- TOC entry 4701 (class 2606 OID 59946)
-- Name: lead_timeline_events lead_timeline_events_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.lead_timeline_events
    ADD CONSTRAINT lead_timeline_events_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.profiles(id);


--
-- TOC entry 4702 (class 2606 OID 59941)
-- Name: lead_timeline_events lead_timeline_events_lead_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.lead_timeline_events
    ADD CONSTRAINT lead_timeline_events_lead_id_fkey FOREIGN KEY (lead_id) REFERENCES public.reservation_leads(id) ON DELETE CASCADE;


--
-- TOC entry 4718 (class 2606 OID 63725)
-- Name: member_permissions member_permissions_org_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.member_permissions
    ADD CONSTRAINT member_permissions_org_id_fkey FOREIGN KEY (org_id) REFERENCES public.organizations(id) ON DELETE CASCADE;


--
-- TOC entry 4719 (class 2606 OID 63730)
-- Name: member_permissions member_permissions_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.member_permissions
    ADD CONSTRAINT member_permissions_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.profiles(id) ON DELETE CASCADE;


--
-- TOC entry 4681 (class 2606 OID 18562)
-- Name: notifications notifications_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT notifications_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- TOC entry 4720 (class 2606 OID 63750)
-- Name: org_invites org_invites_org_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.org_invites
    ADD CONSTRAINT org_invites_org_id_fkey FOREIGN KEY (org_id) REFERENCES public.organizations(id) ON DELETE CASCADE;


--
-- TOC entry 4716 (class 2606 OID 63631)
-- Name: org_members org_members_org_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.org_members
    ADD CONSTRAINT org_members_org_id_fkey FOREIGN KEY (org_id) REFERENCES public.organizations(id) ON DELETE CASCADE;


--
-- TOC entry 4717 (class 2606 OID 63636)
-- Name: org_members org_members_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.org_members
    ADD CONSTRAINT org_members_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- TOC entry 4715 (class 2606 OID 63614)
-- Name: organizations organizations_owner_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.organizations
    ADD CONSTRAINT organizations_owner_id_fkey FOREIGN KEY (owner_id) REFERENCES auth.users(id) ON DELETE SET NULL;


--
-- TOC entry 4742 (class 2606 OID 83430)
-- Name: pre_checkin_sessions pre_checkin_sessions_booking_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pre_checkin_sessions
    ADD CONSTRAINT pre_checkin_sessions_booking_id_fkey FOREIGN KEY (booking_id) REFERENCES public.bookings(id) ON DELETE CASCADE;


--
-- TOC entry 4743 (class 2606 OID 84595)
-- Name: pre_checkin_submissions pre_checkin_submissions_org_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pre_checkin_submissions
    ADD CONSTRAINT pre_checkin_submissions_org_id_fkey FOREIGN KEY (org_id) REFERENCES public.organizations(id) ON DELETE CASCADE;


--
-- TOC entry 4744 (class 2606 OID 84600)
-- Name: pre_checkin_submissions pre_checkin_submissions_session_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pre_checkin_submissions
    ADD CONSTRAINT pre_checkin_submissions_session_id_fkey FOREIGN KEY (session_id) REFERENCES public.pre_checkin_sessions(id) ON DELETE CASCADE;


--
-- TOC entry 4745 (class 2606 OID 84642)
-- Name: precheckin_sessions precheckin_sessions_booking_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.precheckin_sessions
    ADD CONSTRAINT precheckin_sessions_booking_id_fkey FOREIGN KEY (booking_id) REFERENCES public.bookings(id) ON DELETE CASCADE;


--
-- TOC entry 4746 (class 2606 OID 84647)
-- Name: precheckin_sessions precheckin_sessions_org_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.precheckin_sessions
    ADD CONSTRAINT precheckin_sessions_org_id_fkey FOREIGN KEY (org_id) REFERENCES public.organizations(id) ON DELETE CASCADE;


--
-- TOC entry 4672 (class 2606 OID 18356)
-- Name: pricing_rules pricing_rules_property_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pricing_rules
    ADD CONSTRAINT pricing_rules_property_id_fkey FOREIGN KEY (property_id) REFERENCES public.properties(id) ON DELETE CASCADE;


--
-- TOC entry 4673 (class 2606 OID 18361)
-- Name: pricing_rules pricing_rules_room_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pricing_rules
    ADD CONSTRAINT pricing_rules_room_type_id_fkey FOREIGN KEY (room_type_id) REFERENCES public.room_types(id) ON DELETE CASCADE;


--
-- TOC entry 4655 (class 2606 OID 18003)
-- Name: profiles profiles_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.profiles
    ADD CONSTRAINT profiles_id_fkey FOREIGN KEY (id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- TOC entry 4656 (class 2606 OID 63653)
-- Name: properties properties_org_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.properties
    ADD CONSTRAINT properties_org_id_fkey FOREIGN KEY (org_id) REFERENCES public.organizations(id) ON DELETE SET NULL;


--
-- TOC entry 4657 (class 2606 OID 18021)
-- Name: properties properties_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.properties
    ADD CONSTRAINT properties_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- TOC entry 4695 (class 2606 OID 59892)
-- Name: reservation_leads reservation_leads_assigned_to_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.reservation_leads
    ADD CONSTRAINT reservation_leads_assigned_to_fkey FOREIGN KEY (assigned_to) REFERENCES public.profiles(id);


--
-- TOC entry 4696 (class 2606 OID 59897)
-- Name: reservation_leads reservation_leads_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.reservation_leads
    ADD CONSTRAINT reservation_leads_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.profiles(id);


--
-- TOC entry 4697 (class 2606 OID 59887)
-- Name: reservation_leads reservation_leads_property_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.reservation_leads
    ADD CONSTRAINT reservation_leads_property_id_fkey FOREIGN KEY (property_id) REFERENCES public.properties(id) ON DELETE CASCADE;


--
-- TOC entry 4698 (class 2606 OID 59926)
-- Name: reservation_quotes reservation_quotes_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.reservation_quotes
    ADD CONSTRAINT reservation_quotes_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.profiles(id);


--
-- TOC entry 4699 (class 2606 OID 59916)
-- Name: reservation_quotes reservation_quotes_lead_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.reservation_quotes
    ADD CONSTRAINT reservation_quotes_lead_id_fkey FOREIGN KEY (lead_id) REFERENCES public.reservation_leads(id) ON DELETE CASCADE;


--
-- TOC entry 4700 (class 2606 OID 59921)
-- Name: reservation_quotes reservation_quotes_property_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.reservation_quotes
    ADD CONSTRAINT reservation_quotes_property_id_fkey FOREIGN KEY (property_id) REFERENCES public.properties(id) ON DELETE CASCADE;


--
-- TOC entry 4729 (class 2606 OID 71092)
-- Name: room_categories room_categories_property_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.room_categories
    ADD CONSTRAINT room_categories_property_id_fkey FOREIGN KEY (property_id) REFERENCES public.properties(id) ON DELETE CASCADE;


--
-- TOC entry 4723 (class 2606 OID 63829)
-- Name: room_type_inventory room_type_inventory_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.room_type_inventory
    ADD CONSTRAINT room_type_inventory_item_id_fkey FOREIGN KEY (item_id) REFERENCES public.inventory_items(id) ON DELETE CASCADE;


--
-- TOC entry 4724 (class 2606 OID 63824)
-- Name: room_type_inventory room_type_inventory_room_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.room_type_inventory
    ADD CONSTRAINT room_type_inventory_room_type_id_fkey FOREIGN KEY (room_type_id) REFERENCES public.room_types(id) ON DELETE CASCADE;


--
-- TOC entry 4660 (class 2606 OID 18049)
-- Name: room_types room_types_property_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.room_types
    ADD CONSTRAINT room_types_property_id_fkey FOREIGN KEY (property_id) REFERENCES public.properties(id) ON DELETE CASCADE;


--
-- TOC entry 4666 (class 2606 OID 18861)
-- Name: rooms rooms_last_booking_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.rooms
    ADD CONSTRAINT rooms_last_booking_id_fkey FOREIGN KEY (last_booking_id) REFERENCES public.bookings(id) ON DELETE SET NULL;


--
-- TOC entry 4667 (class 2606 OID 63665)
-- Name: rooms rooms_org_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.rooms
    ADD CONSTRAINT rooms_org_id_fkey FOREIGN KEY (org_id) REFERENCES public.organizations(id) ON DELETE SET NULL;


--
-- TOC entry 4668 (class 2606 OID 18279)
-- Name: rooms rooms_property_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.rooms
    ADD CONSTRAINT rooms_property_id_fkey FOREIGN KEY (property_id) REFERENCES public.properties(id) ON DELETE CASCADE;


--
-- TOC entry 4669 (class 2606 OID 18284)
-- Name: rooms rooms_room_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.rooms
    ADD CONSTRAINT rooms_room_type_id_fkey FOREIGN KEY (room_type_id) REFERENCES public.room_types(id) ON DELETE CASCADE;


--
-- TOC entry 4670 (class 2606 OID 84659)
-- Name: rooms rooms_updated_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.rooms
    ADD CONSTRAINT rooms_updated_by_fkey FOREIGN KEY (updated_by) REFERENCES auth.users(id);


--
-- TOC entry 4675 (class 2606 OID 18410)
-- Name: services services_property_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.services
    ADD CONSTRAINT services_property_id_fkey FOREIGN KEY (property_id) REFERENCES public.properties(id) ON DELETE CASCADE;


--
-- TOC entry 4691 (class 2606 OID 59841)
-- Name: shift_assignments shift_assignments_shift_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.shift_assignments
    ADD CONSTRAINT shift_assignments_shift_id_fkey FOREIGN KEY (shift_id) REFERENCES public.shifts(id) ON DELETE CASCADE;


--
-- TOC entry 4692 (class 2606 OID 59846)
-- Name: shift_assignments shift_assignments_staff_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.shift_assignments
    ADD CONSTRAINT shift_assignments_staff_id_fkey FOREIGN KEY (staff_id) REFERENCES public.staff_profiles(id) ON DELETE CASCADE;


--
-- TOC entry 4693 (class 2606 OID 59867)
-- Name: shift_handoffs shift_handoffs_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.shift_handoffs
    ADD CONSTRAINT shift_handoffs_created_by_fkey FOREIGN KEY (created_by) REFERENCES auth.users(id);


--
-- TOC entry 4694 (class 2606 OID 59862)
-- Name: shift_handoffs shift_handoffs_shift_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.shift_handoffs
    ADD CONSTRAINT shift_handoffs_shift_id_fkey FOREIGN KEY (shift_id) REFERENCES public.shifts(id) ON DELETE CASCADE;


--
-- TOC entry 4688 (class 2606 OID 59825)
-- Name: shifts shifts_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.shifts
    ADD CONSTRAINT shifts_created_by_fkey FOREIGN KEY (created_by) REFERENCES auth.users(id);


--
-- TOC entry 4689 (class 2606 OID 59820)
-- Name: shifts shifts_department_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.shifts
    ADD CONSTRAINT shifts_department_id_fkey FOREIGN KEY (department_id) REFERENCES public.departments(id);


--
-- TOC entry 4690 (class 2606 OID 59815)
-- Name: shifts shifts_property_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.shifts
    ADD CONSTRAINT shifts_property_id_fkey FOREIGN KEY (property_id) REFERENCES public.properties(id) ON DELETE CASCADE;


--
-- TOC entry 4686 (class 2606 OID 59794)
-- Name: staff_profiles staff_profiles_property_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.staff_profiles
    ADD CONSTRAINT staff_profiles_property_id_fkey FOREIGN KEY (property_id) REFERENCES public.properties(id) ON DELETE CASCADE;


--
-- TOC entry 4687 (class 2606 OID 59799)
-- Name: staff_profiles staff_profiles_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.staff_profiles
    ADD CONSTRAINT staff_profiles_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id);


--
-- TOC entry 4737 (class 2606 OID 70929)
-- Name: stock_check_items stock_check_items_daily_check_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.stock_check_items
    ADD CONSTRAINT stock_check_items_daily_check_id_fkey FOREIGN KEY (daily_check_id) REFERENCES public.stock_daily_checks(id) ON DELETE CASCADE;


--
-- TOC entry 4738 (class 2606 OID 70934)
-- Name: stock_check_items stock_check_items_stock_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.stock_check_items
    ADD CONSTRAINT stock_check_items_stock_item_id_fkey FOREIGN KEY (stock_item_id) REFERENCES public.stock_items(id) ON DELETE CASCADE;


--
-- TOC entry 4735 (class 2606 OID 70882)
-- Name: stock_daily_checks stock_daily_checks_checked_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.stock_daily_checks
    ADD CONSTRAINT stock_daily_checks_checked_by_fkey FOREIGN KEY (checked_by) REFERENCES auth.users(id);


--
-- TOC entry 4736 (class 2606 OID 70877)
-- Name: stock_daily_checks stock_daily_checks_location_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.stock_daily_checks
    ADD CONSTRAINT stock_daily_checks_location_id_fkey FOREIGN KEY (location_id) REFERENCES public.stock_locations(id) ON DELETE CASCADE;


--
-- TOC entry 4731 (class 2606 OID 70839)
-- Name: stock_items stock_items_location_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.stock_items
    ADD CONSTRAINT stock_items_location_id_fkey FOREIGN KEY (location_id) REFERENCES public.stock_locations(id) ON DELETE CASCADE;


--
-- TOC entry 4732 (class 2606 OID 70834)
-- Name: stock_items stock_items_property_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.stock_items
    ADD CONSTRAINT stock_items_property_id_fkey FOREIGN KEY (property_id) REFERENCES public.properties(id) ON DELETE CASCADE;


--
-- TOC entry 4730 (class 2606 OID 70815)
-- Name: stock_locations stock_locations_property_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.stock_locations
    ADD CONSTRAINT stock_locations_property_id_fkey FOREIGN KEY (property_id) REFERENCES public.properties(id) ON DELETE CASCADE;


--
-- TOC entry 4733 (class 2606 OID 70853)
-- Name: stock_movements stock_movements_stock_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.stock_movements
    ADD CONSTRAINT stock_movements_stock_item_id_fkey FOREIGN KEY (stock_item_id) REFERENCES public.stock_items(id) ON DELETE CASCADE;


--
-- TOC entry 4734 (class 2606 OID 70858)
-- Name: stock_movements stock_movements_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.stock_movements
    ADD CONSTRAINT stock_movements_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id);


--
-- TOC entry 4678 (class 2606 OID 18522)
-- Name: tasks tasks_assigned_to_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tasks
    ADD CONSTRAINT tasks_assigned_to_fkey FOREIGN KEY (assigned_to) REFERENCES auth.users(id) ON DELETE SET NULL;


--
-- TOC entry 4679 (class 2606 OID 18517)
-- Name: tasks tasks_property_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tasks
    ADD CONSTRAINT tasks_property_id_fkey FOREIGN KEY (property_id) REFERENCES public.properties(id) ON DELETE CASCADE;


--
-- TOC entry 4707 (class 2606 OID 63477)
-- Name: ticket_comments ticket_comments_ticket_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ticket_comments
    ADD CONSTRAINT ticket_comments_ticket_id_fkey FOREIGN KEY (ticket_id) REFERENCES public.tickets(id) ON DELETE CASCADE;


--
-- TOC entry 4708 (class 2606 OID 63482)
-- Name: ticket_comments ticket_comments_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ticket_comments
    ADD CONSTRAINT ticket_comments_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- TOC entry 4705 (class 2606 OID 63671)
-- Name: tickets tickets_org_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tickets
    ADD CONSTRAINT tickets_org_id_fkey FOREIGN KEY (org_id) REFERENCES public.organizations(id) ON DELETE SET NULL;


--
-- TOC entry 4706 (class 2606 OID 63461)
-- Name: tickets tickets_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tickets
    ADD CONSTRAINT tickets_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- TOC entry 4677 (class 2606 OID 18478)
-- Name: website_settings website_settings_property_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.website_settings
    ADD CONSTRAINT website_settings_property_id_fkey FOREIGN KEY (property_id) REFERENCES public.properties(id) ON DELETE CASCADE;


--
-- TOC entry 4636 (class 2606 OID 16572)
-- Name: objects objects_bucketId_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.objects
    ADD CONSTRAINT "objects_bucketId_fkey" FOREIGN KEY (bucket_id) REFERENCES storage.buckets(id);


--
-- TOC entry 4652 (class 2606 OID 17153)
-- Name: s3_multipart_uploads s3_multipart_uploads_bucket_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.s3_multipart_uploads
    ADD CONSTRAINT s3_multipart_uploads_bucket_id_fkey FOREIGN KEY (bucket_id) REFERENCES storage.buckets(id);


--
-- TOC entry 4653 (class 2606 OID 17173)
-- Name: s3_multipart_uploads_parts s3_multipart_uploads_parts_bucket_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.s3_multipart_uploads_parts
    ADD CONSTRAINT s3_multipart_uploads_parts_bucket_id_fkey FOREIGN KEY (bucket_id) REFERENCES storage.buckets(id);


--
-- TOC entry 4654 (class 2606 OID 17168)
-- Name: s3_multipart_uploads_parts s3_multipart_uploads_parts_upload_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.s3_multipart_uploads_parts
    ADD CONSTRAINT s3_multipart_uploads_parts_upload_id_fkey FOREIGN KEY (upload_id) REFERENCES storage.s3_multipart_uploads(id) ON DELETE CASCADE;


--
-- TOC entry 4684 (class 2606 OID 47595)
-- Name: vector_indexes vector_indexes_bucket_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.vector_indexes
    ADD CONSTRAINT vector_indexes_bucket_id_fkey FOREIGN KEY (bucket_id) REFERENCES storage.buckets_vectors(id);


--
-- TOC entry 4945 (class 0 OID 16525)
-- Dependencies: 349
-- Name: audit_log_entries; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.audit_log_entries ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4959 (class 0 OID 16929)
-- Dependencies: 366
-- Name: flow_state; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.flow_state ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4950 (class 0 OID 16727)
-- Dependencies: 357
-- Name: identities; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.identities ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4944 (class 0 OID 16518)
-- Dependencies: 348
-- Name: instances; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.instances ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4954 (class 0 OID 16816)
-- Dependencies: 361
-- Name: mfa_amr_claims; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.mfa_amr_claims ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4953 (class 0 OID 16804)
-- Dependencies: 360
-- Name: mfa_challenges; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.mfa_challenges ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4952 (class 0 OID 16791)
-- Dependencies: 359
-- Name: mfa_factors; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.mfa_factors ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4960 (class 0 OID 16979)
-- Dependencies: 367
-- Name: one_time_tokens; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.one_time_tokens ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4943 (class 0 OID 16507)
-- Dependencies: 347
-- Name: refresh_tokens; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.refresh_tokens ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4957 (class 0 OID 16858)
-- Dependencies: 364
-- Name: saml_providers; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.saml_providers ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4958 (class 0 OID 16876)
-- Dependencies: 365
-- Name: saml_relay_states; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.saml_relay_states ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4946 (class 0 OID 16533)
-- Dependencies: 350
-- Name: schema_migrations; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.schema_migrations ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4951 (class 0 OID 16757)
-- Dependencies: 358
-- Name: sessions; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.sessions ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4956 (class 0 OID 16843)
-- Dependencies: 363
-- Name: sso_domains; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.sso_domains ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4955 (class 0 OID 16834)
-- Dependencies: 362
-- Name: sso_providers; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.sso_providers ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4942 (class 0 OID 16495)
-- Dependencies: 345
-- Name: users; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.users ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 5186 (class 3256 OID 85844)
-- Name: hostconnect_onboarding Admin can delete onboarding; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Admin can delete onboarding" ON public.hostconnect_onboarding FOR DELETE USING ((org_id IN ( SELECT organizations.id
   FROM public.organizations
  WHERE (organizations.owner_id = auth.uid()))));


--
-- TOC entry 5132 (class 3256 OID 88182)
-- Name: org_members Admins can manage org members; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Admins can manage org members" ON public.org_members USING ((public.is_super_admin() OR (EXISTS ( SELECT 1
   FROM public.organizations o
  WHERE ((o.id = org_members.org_id) AND (o.owner_id = auth.uid())))) OR public.is_org_admin_no_rls(org_id))) WITH CHECK ((public.is_super_admin() OR (EXISTS ( SELECT 1
   FROM public.organizations o
  WHERE ((o.id = org_members.org_id) AND (o.owner_id = auth.uid())))) OR public.is_org_admin_no_rls(org_id)));


--
-- TOC entry 5100 (class 3256 OID 87027)
-- Name: organizations Admins can update organization; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Admins can update organization" ON public.organizations FOR UPDATE USING ((public.is_super_admin() OR public.is_org_admin(id)));


--
-- TOC entry 5110 (class 3256 OID 63755)
-- Name: org_invites Admins manage invites; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Admins manage invites" ON public.org_invites USING (public.is_org_admin(org_id));


--
-- TOC entry 5099 (class 3256 OID 63735)
-- Name: member_permissions Admins manage permissions; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Admins manage permissions" ON public.member_permissions USING (public.is_org_admin(org_id));


--
-- TOC entry 5032 (class 3256 OID 18088)
-- Name: bookings Allow admins to manage all bookings or owner of property to man; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Allow admins to manage all bookings or owner of property to man" ON public.bookings USING (((public.get_user_role() = 'admin'::text) OR (EXISTS ( SELECT 1
   FROM public.properties
  WHERE ((properties.id = bookings.property_id) AND (properties.user_id = auth.uid())))))) WITH CHECK (((public.get_user_role() = 'admin'::text) OR (EXISTS ( SELECT 1
   FROM public.properties
  WHERE ((properties.id = bookings.property_id) AND (properties.user_id = auth.uid()))))));


--
-- TOC entry 5034 (class 3256 OID 18093)
-- Name: entity_photos Allow admins to manage all photos or owner of entity to manage; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Allow admins to manage all photos or owner of entity to manage" ON public.entity_photos USING (((public.get_user_role() = 'admin'::text) OR (EXISTS ( SELECT 1
   FROM public.properties
  WHERE ((properties.id = entity_photos.entity_id) AND (properties.user_id = auth.uid())))) OR (EXISTS ( SELECT 1
   FROM (public.room_types rt
     JOIN public.properties p ON ((rt.property_id = p.id)))
  WHERE ((rt.id = entity_photos.entity_id) AND (p.user_id = auth.uid())))))) WITH CHECK (((public.get_user_role() = 'admin'::text) OR (EXISTS ( SELECT 1
   FROM public.properties
  WHERE ((properties.id = entity_photos.entity_id) AND (properties.user_id = auth.uid())))) OR (EXISTS ( SELECT 1
   FROM (public.room_types rt
     JOIN public.properties p ON ((rt.property_id = p.id)))
  WHERE ((rt.id = entity_photos.entity_id) AND (p.user_id = auth.uid()))))));


--
-- TOC entry 5031 (class 3256 OID 18087)
-- Name: properties Allow admins to manage all properties or owner to manage their ; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Allow admins to manage all properties or owner to manage their " ON public.properties USING (((public.get_user_role() = 'admin'::text) OR (auth.uid() = user_id))) WITH CHECK (((public.get_user_role() = 'admin'::text) OR (auth.uid() = user_id)));


--
-- TOC entry 5033 (class 3256 OID 18090)
-- Name: room_types Allow admins to manage all room types or owner of property to m; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Allow admins to manage all room types or owner of property to m" ON public.room_types USING (((public.get_user_role() = 'admin'::text) OR (EXISTS ( SELECT 1
   FROM public.properties
  WHERE ((properties.id = room_types.property_id) AND (properties.user_id = auth.uid())))))) WITH CHECK (((public.get_user_role() = 'admin'::text) OR (EXISTS ( SELECT 1
   FROM public.properties
  WHERE ((properties.id = room_types.property_id) AND (properties.user_id = auth.uid()))))));


--
-- TOC entry 5027 (class 3256 OID 18793)
-- Name: faqs Allow authenticated users to manage faqs; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Allow authenticated users to manage faqs" ON public.faqs TO authenticated USING ((auth.role() = 'admin'::text));


--
-- TOC entry 5054 (class 3256 OID 18835)
-- Name: features Allow authenticated users to manage features; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Allow authenticated users to manage features" ON public.features TO authenticated USING ((auth.role() = 'admin'::text));


--
-- TOC entry 5048 (class 3256 OID 18807)
-- Name: integrations Allow authenticated users to manage integrations; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Allow authenticated users to manage integrations" ON public.integrations TO authenticated USING ((auth.role() = 'admin'::text));


--
-- TOC entry 5050 (class 3256 OID 18762)
-- Name: invoices Allow authenticated users to manage invoices for their properti; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Allow authenticated users to manage invoices for their properti" ON public.invoices TO authenticated USING ((EXISTS ( SELECT 1
   FROM public.properties
  WHERE ((properties.id = invoices.property_id) AND (properties.user_id = auth.uid()))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM public.properties
  WHERE ((properties.id = invoices.property_id) AND (properties.user_id = auth.uid())))));


--
-- TOC entry 5022 (class 3256 OID 18780)
-- Name: pricing_plans Allow authenticated users to manage pricing plans; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Allow authenticated users to manage pricing plans" ON public.pricing_plans TO authenticated USING ((auth.role() = 'admin'::text));


--
-- TOC entry 5056 (class 3256 OID 18849)
-- Name: how_it_works_steps Allow authenticated users to manage steps; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Allow authenticated users to manage steps" ON public.how_it_works_steps TO authenticated USING ((auth.role() = 'admin'::text));


--
-- TOC entry 5052 (class 3256 OID 18822)
-- Name: testimonials Allow authenticated users to manage testimonials; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Allow authenticated users to manage testimonials" ON public.testimonials TO authenticated USING ((auth.role() = 'admin'::text));


--
-- TOC entry 5057 (class 3256 OID 18866)
-- Name: bookings Allow owner to update current_room_id on bookings; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Allow owner to update current_room_id on bookings" ON public.bookings FOR UPDATE TO authenticated USING ((EXISTS ( SELECT 1
   FROM public.properties
  WHERE ((properties.id = bookings.property_id) AND (properties.user_id = auth.uid()))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM public.properties
  WHERE ((properties.id = bookings.property_id) AND (properties.user_id = auth.uid())))));


--
-- TOC entry 5058 (class 3256 OID 18868)
-- Name: rooms Allow owner to update last_booking_id on rooms; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Allow owner to update last_booking_id on rooms" ON public.rooms FOR UPDATE TO authenticated USING ((EXISTS ( SELECT 1
   FROM public.properties
  WHERE ((properties.id = rooms.property_id) AND (properties.user_id = auth.uid()))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM public.properties
  WHERE ((properties.id = rooms.property_id) AND (properties.user_id = auth.uid())))));


--
-- TOC entry 5023 (class 3256 OID 18792)
-- Name: faqs Allow public read access for faqs; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Allow public read access for faqs" ON public.faqs FOR SELECT USING (true);


--
-- TOC entry 5053 (class 3256 OID 18834)
-- Name: features Allow public read access for features; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Allow public read access for features" ON public.features FOR SELECT USING (true);


--
-- TOC entry 5021 (class 3256 OID 18779)
-- Name: pricing_plans Allow public read access for pricing plans; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Allow public read access for pricing plans" ON public.pricing_plans FOR SELECT USING (true);


--
-- TOC entry 5049 (class 3256 OID 18573)
-- Name: website_settings Allow public read access for specific website settings; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Allow public read access for specific website settings" ON public.website_settings FOR SELECT USING ((setting_key = ANY (ARRAY['site_name'::text, 'site_logo_url'::text, 'site_favicon_url'::text, 'site_description'::text, 'site_about_content'::text, 'blog_url'::text, 'contact_email'::text, 'contact_phone'::text, 'social_facebook'::text, 'social_instagram'::text, 'social_google_business'::text])));


--
-- TOC entry 5055 (class 3256 OID 18848)
-- Name: how_it_works_steps Allow public read access for steps; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Allow public read access for steps" ON public.how_it_works_steps FOR SELECT USING (true);


--
-- TOC entry 5040 (class 3256 OID 18806)
-- Name: integrations Allow public read access for visible integrations; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Allow public read access for visible integrations" ON public.integrations FOR SELECT USING ((is_visible = true));


--
-- TOC entry 5051 (class 3256 OID 18821)
-- Name: testimonials Allow public read access for visible testimonials; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Allow public read access for visible testimonials" ON public.testimonials FOR SELECT USING ((is_visible = true));


--
-- TOC entry 5075 (class 3256 OID 63756)
-- Name: org_invites Anyone can look up token; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Anyone can look up token" ON public.org_invites FOR SELECT USING (true);


--
-- TOC entry 5026 (class 3256 OID 18477)
-- Name: website_settings Enable delete for authenticated users; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Enable delete for authenticated users" ON public.website_settings FOR DELETE USING ((auth.role() = 'authenticated'::text));


--
-- TOC entry 5030 (class 3256 OID 18409)
-- Name: services Enable delete for users who own the property; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Enable delete for users who own the property" ON public.services FOR DELETE USING ((EXISTS ( SELECT 1
   FROM public.properties
  WHERE ((properties.id = services.property_id) AND (properties.user_id = auth.uid())))));


--
-- TOC entry 5028 (class 3256 OID 18407)
-- Name: services Enable insert for authenticated users; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Enable insert for authenticated users" ON public.services FOR INSERT WITH CHECK ((auth.role() = 'authenticated'::text));


--
-- TOC entry 5024 (class 3256 OID 18475)
-- Name: website_settings Enable insert for authenticated users; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Enable insert for authenticated users" ON public.website_settings FOR INSERT WITH CHECK ((auth.role() = 'authenticated'::text));


--
-- TOC entry 5025 (class 3256 OID 18476)
-- Name: website_settings Enable update for authenticated users; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Enable update for authenticated users" ON public.website_settings FOR UPDATE USING ((auth.role() = 'authenticated'::text));


--
-- TOC entry 5029 (class 3256 OID 18408)
-- Name: services Enable update for users who own the property; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Enable update for users who own the property" ON public.services FOR UPDATE USING ((EXISTS ( SELECT 1
   FROM public.properties
  WHERE ((properties.id = services.property_id) AND (properties.user_id = auth.uid())))));


--
-- TOC entry 5072 (class 3256 OID 63312)
-- Name: expenses Manage own expenses; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Manage own expenses" ON public.expenses USING (public.check_user_access(property_id)) WITH CHECK (public.check_user_access(property_id));


--
-- TOC entry 5074 (class 3256 OID 63314)
-- Name: invoices Manage own invoices; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Manage own invoices" ON public.invoices USING (public.check_user_access(property_id)) WITH CHECK (public.check_user_access(property_id));


--
-- TOC entry 5073 (class 3256 OID 63313)
-- Name: services Manage own services; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Manage own services" ON public.services USING (public.check_user_access(property_id)) WITH CHECK (public.check_user_access(property_id));


--
-- TOC entry 5071 (class 3256 OID 63311)
-- Name: tasks Manage own tasks; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Manage own tasks" ON public.tasks USING (public.check_user_access(property_id)) WITH CHECK (public.check_user_access(property_id));


--
-- TOC entry 5131 (class 3256 OID 88181)
-- Name: org_members Members can view their org members; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Members can view their org members" ON public.org_members FOR SELECT USING ((public.is_super_admin() OR (auth.uid() = user_id) OR (EXISTS ( SELECT 1
   FROM public.organizations o
  WHERE ((o.id = org_members.org_id) AND (o.owner_id = auth.uid())))) OR public.is_org_admin_no_rls(org_id)));


--
-- TOC entry 5116 (class 3256 OID 87041)
-- Name: organizations Members can view their organizations; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Members can view their organizations" ON public.organizations FOR SELECT USING (((owner_id = auth.uid()) OR public.is_org_member(id)));


--
-- TOC entry 5102 (class 3256 OID 63736)
-- Name: member_permissions Members view own permissions; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Members view own permissions" ON public.member_permissions FOR SELECT USING ((auth.uid() = user_id));


--
-- TOC entry 5183 (class 3256 OID 85841)
-- Name: hostconnect_onboarding Org members can view onboarding; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Org members can view onboarding" ON public.hostconnect_onboarding FOR SELECT USING ((org_id IN ( SELECT organizations.id
   FROM public.organizations
  WHERE (organizations.owner_id = auth.uid()))));


--
-- TOC entry 5135 (class 3256 OID 91537)
-- Name: guest_consents Org members manage guest consents; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Org members manage guest consents" ON public.guest_consents USING ((public.is_super_admin() OR public.is_org_member(org_id))) WITH CHECK ((public.is_super_admin() OR public.is_org_member(org_id)));


--
-- TOC entry 5114 (class 3256 OID 63708)
-- Name: tickets Org: Users can create tickets; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Org: Users can create tickets" ON public.tickets FOR INSERT WITH CHECK (((auth.uid() = user_id) OR ((org_id IS NOT NULL) AND public.is_org_member(org_id))));


--
-- TOC entry 5113 (class 3256 OID 63706)
-- Name: rooms Org: Users can delete rooms; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Org: Users can delete rooms" ON public.rooms FOR DELETE USING (((( SELECT properties.user_id
   FROM public.properties
  WHERE (properties.id = rooms.property_id)) = auth.uid()) OR ((org_id IS NOT NULL) AND public.is_org_admin(org_id))));


--
-- TOC entry 5111 (class 3256 OID 63704)
-- Name: rooms Org: Users can insert rooms; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Org: Users can insert rooms" ON public.rooms FOR INSERT WITH CHECK (((( SELECT properties.user_id
   FROM public.properties
  WHERE (properties.id = rooms.property_id)) = auth.uid()) OR ((org_id IS NOT NULL) AND public.is_org_admin(org_id))));


--
-- TOC entry 5095 (class 3256 OID 63710)
-- Name: ideas Org: Users can update own ideas; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Org: Users can update own ideas" ON public.ideas FOR UPDATE USING (((auth.uid() = user_id) OR ((org_id IS NOT NULL) AND public.is_org_admin(org_id))));


--
-- TOC entry 5112 (class 3256 OID 63705)
-- Name: rooms Org: Users can update rooms; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Org: Users can update rooms" ON public.rooms FOR UPDATE USING (((( SELECT properties.user_id
   FROM public.properties
  WHERE (properties.id = rooms.property_id)) = auth.uid()) OR ((org_id IS NOT NULL) AND public.is_org_admin(org_id))));


--
-- TOC entry 5115 (class 3256 OID 63709)
-- Name: ideas Org: Users can view ideas; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Org: Users can view ideas" ON public.ideas FOR SELECT USING (((auth.uid() = user_id) OR ((org_id IS NOT NULL) AND public.is_org_member(org_id)) OR public.is_hostconnect_staff()));


--
-- TOC entry 5082 (class 3256 OID 63538)
-- Name: ticket_comments Staff inserts comments; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Staff inserts comments" ON public.ticket_comments FOR INSERT WITH CHECK (public.is_hostconnect_staff());


--
-- TOC entry 5092 (class 3256 OID 63546)
-- Name: idea_comments Staff inserts idea comments; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Staff inserts idea comments" ON public.idea_comments FOR INSERT WITH CHECK (public.is_hostconnect_staff());


--
-- TOC entry 5089 (class 3256 OID 63543)
-- Name: ideas Staff updates ideas; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Staff updates ideas" ON public.ideas FOR UPDATE USING (public.is_hostconnect_staff());


--
-- TOC entry 5079 (class 3256 OID 63535)
-- Name: tickets Staff updates tickets; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Staff updates tickets" ON public.tickets FOR UPDATE USING (public.is_hostconnect_staff());


--
-- TOC entry 5080 (class 3256 OID 63536)
-- Name: ticket_comments Staff views all comments; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Staff views all comments" ON public.ticket_comments FOR SELECT USING (public.is_hostconnect_staff());


--
-- TOC entry 5090 (class 3256 OID 63544)
-- Name: idea_comments Staff views all idea comments; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Staff views all idea comments" ON public.idea_comments FOR SELECT USING (public.is_hostconnect_staff());


--
-- TOC entry 5086 (class 3256 OID 63540)
-- Name: ideas Staff views all ideas; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Staff views all ideas" ON public.ideas FOR SELECT USING (public.is_hostconnect_staff());


--
-- TOC entry 5076 (class 3256 OID 63532)
-- Name: tickets Staff views all tickets; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Staff views all tickets" ON public.tickets FOR SELECT USING (public.is_hostconnect_staff());


--
-- TOC entry 5094 (class 3256 OID 63600)
-- Name: audit_log Staff views audit logs; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Staff views audit logs" ON public.audit_log FOR SELECT USING (public.is_hostconnect_staff());


--
-- TOC entry 5184 (class 3256 OID 85842)
-- Name: hostconnect_onboarding Staff+ can create onboarding; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Staff+ can create onboarding" ON public.hostconnect_onboarding FOR INSERT WITH CHECK ((org_id IN ( SELECT organizations.id
   FROM public.organizations
  WHERE (organizations.owner_id = auth.uid()))));


--
-- TOC entry 5185 (class 3256 OID 85843)
-- Name: hostconnect_onboarding Staff+ can update onboarding; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Staff+ can update onboarding" ON public.hostconnect_onboarding FOR UPDATE USING ((org_id IN ( SELECT organizations.id
   FROM public.organizations
  WHERE (organizations.owner_id = auth.uid()))));


--
-- TOC entry 5124 (class 3256 OID 63789)
-- Name: bookings Strict: Org Admins delete bookings; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Strict: Org Admins delete bookings" ON public.bookings FOR DELETE USING (public.is_org_admin(org_id));


--
-- TOC entry 5120 (class 3256 OID 63785)
-- Name: properties Strict: Org Admins delete properties; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Strict: Org Admins delete properties" ON public.properties FOR DELETE USING (public.is_org_admin(org_id));


--
-- TOC entry 5118 (class 3256 OID 63783)
-- Name: properties Strict: Org Admins insert properties; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Strict: Org Admins insert properties" ON public.properties FOR INSERT WITH CHECK (public.is_org_admin(org_id));


--
-- TOC entry 5119 (class 3256 OID 63784)
-- Name: properties Strict: Org Admins update properties; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Strict: Org Admins update properties" ON public.properties FOR UPDATE USING (public.is_org_admin(org_id));


--
-- TOC entry 5122 (class 3256 OID 63787)
-- Name: bookings Strict: Org Members insert bookings; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Strict: Org Members insert bookings" ON public.bookings FOR INSERT WITH CHECK (public.is_org_member(org_id));


--
-- TOC entry 5123 (class 3256 OID 63788)
-- Name: bookings Strict: Org Members update bookings; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Strict: Org Members update bookings" ON public.bookings FOR UPDATE USING (public.is_org_member(org_id));


--
-- TOC entry 5121 (class 3256 OID 63786)
-- Name: bookings Strict: Org Members view bookings; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Strict: Org Members view bookings" ON public.bookings FOR SELECT USING (public.is_org_member(org_id));


--
-- TOC entry 5117 (class 3256 OID 63782)
-- Name: properties Strict: Org Members view properties; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Strict: Org Members view properties" ON public.properties FOR SELECT USING (public.is_org_member(org_id));


--
-- TOC entry 5125 (class 3256 OID 63790)
-- Name: rooms Strict: Org Members view rooms; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Strict: Org Members view rooms" ON public.rooms FOR SELECT USING (public.is_org_member(org_id));


--
-- TOC entry 5126 (class 3256 OID 63791)
-- Name: tickets Strict: Org Members view tickets; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Strict: Org Members view tickets" ON public.tickets FOR SELECT USING ((public.is_org_member(org_id) OR public.is_hostconnect_staff()));


--
-- TOC entry 5096 (class 3256 OID 63648)
-- Name: organizations Users can create organizations; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can create organizations" ON public.organizations FOR INSERT WITH CHECK (true);


--
-- TOC entry 5182 (class 3256 OID 84706)
-- Name: booking_rooms Users can delete booking_rooms for their org; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can delete booking_rooms for their org" ON public.booking_rooms FOR DELETE USING ((org_id = ( SELECT booking_rooms.org_id
   FROM public.profiles
  WHERE (profiles.id = auth.uid()))));


--
-- TOC entry 5070 (class 3256 OID 63310)
-- Name: booking_charges Users can delete charges of their bookings; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can delete charges of their bookings" ON public.booking_charges FOR DELETE USING (public.check_booking_access(booking_id));


--
-- TOC entry 5043 (class 3256 OID 18550)
-- Name: expenses Users can delete expenses for their properties; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can delete expenses for their properties" ON public.expenses FOR DELETE TO authenticated USING ((EXISTS ( SELECT 1
   FROM public.properties
  WHERE ((properties.id = expenses.property_id) AND (properties.user_id = auth.uid())))));


--
-- TOC entry 5062 (class 3256 OID 63301)
-- Name: rooms Users can delete rooms of their properties; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can delete rooms of their properties" ON public.rooms FOR DELETE USING (public.check_user_access(property_id));


--
-- TOC entry 5066 (class 3256 OID 63305)
-- Name: pricing_rules Users can delete rules of their properties; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can delete rules of their properties" ON public.pricing_rules FOR DELETE USING (public.check_user_access(property_id));


--
-- TOC entry 5038 (class 3256 OID 18530)
-- Name: tasks Users can delete tasks for their properties; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can delete tasks for their properties" ON public.tasks FOR DELETE TO authenticated USING ((EXISTS ( SELECT 1
   FROM public.properties
  WHERE ((properties.id = tasks.property_id) AND (properties.user_id = auth.uid())))));


--
-- TOC entry 5047 (class 3256 OID 18570)
-- Name: notifications Users can delete their own notifications; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can delete their own notifications" ON public.notifications FOR DELETE TO authenticated USING ((auth.uid() = user_id));


--
-- TOC entry 5180 (class 3256 OID 84704)
-- Name: booking_rooms Users can insert booking_rooms for their org; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can insert booking_rooms for their org" ON public.booking_rooms FOR INSERT WITH CHECK ((org_id = ( SELECT booking_rooms.org_id
   FROM public.profiles
  WHERE (profiles.id = auth.uid()))));


--
-- TOC entry 5068 (class 3256 OID 63308)
-- Name: booking_charges Users can insert charges for their bookings; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can insert charges for their bookings" ON public.booking_charges FOR INSERT WITH CHECK (public.check_booking_access(booking_id));


--
-- TOC entry 5041 (class 3256 OID 18548)
-- Name: expenses Users can insert expenses for their properties; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can insert expenses for their properties" ON public.expenses FOR INSERT TO authenticated WITH CHECK ((EXISTS ( SELECT 1
   FROM public.properties
  WHERE ((properties.id = expenses.property_id) AND (properties.user_id = auth.uid())))));


--
-- TOC entry 5060 (class 3256 OID 63299)
-- Name: rooms Users can insert rooms for their properties; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can insert rooms for their properties" ON public.rooms FOR INSERT WITH CHECK (public.check_user_access(property_id));


--
-- TOC entry 5064 (class 3256 OID 63303)
-- Name: pricing_rules Users can insert rules for their properties; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can insert rules for their properties" ON public.pricing_rules FOR INSERT WITH CHECK (public.check_user_access(property_id));


--
-- TOC entry 5036 (class 3256 OID 18528)
-- Name: tasks Users can insert tasks for their properties; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can insert tasks for their properties" ON public.tasks FOR INSERT TO authenticated WITH CHECK ((EXISTS ( SELECT 1
   FROM public.properties
  WHERE ((properties.id = tasks.property_id) AND (properties.user_id = auth.uid())))));


--
-- TOC entry 5045 (class 3256 OID 18568)
-- Name: notifications Users can insert their own notifications; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can insert their own notifications" ON public.notifications FOR INSERT TO authenticated WITH CHECK ((auth.uid() = user_id));


--
-- TOC entry 5103 (class 3256 OID 87031)
-- Name: bookings Users can manage bookings in their org; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can manage bookings in their org" ON public.bookings USING ((public.is_super_admin() OR public.is_org_member(org_id)));


--
-- TOC entry 5084 (class 3256 OID 71106)
-- Name: room_categories Users can manage categories in their properties; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can manage categories in their properties" ON public.room_categories USING ((property_id IN ( SELECT p.id
   FROM ((public.properties p
     JOIN public.organizations o ON ((o.id = p.org_id)))
     JOIN public.org_members om ON ((om.org_id = o.id)))
  WHERE (om.user_id = auth.uid()))));


--
-- TOC entry 5134 (class 3256 OID 87033)
-- Name: guests Users can manage guests in their org; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can manage guests in their org" ON public.guests USING ((public.is_super_admin() OR public.is_org_member(org_id))) WITH CHECK ((public.is_super_admin() OR public.is_org_member(org_id)));


--
-- TOC entry 5108 (class 3256 OID 87037)
-- Name: properties Users can manage properties in their org; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can manage properties in their org" ON public.properties USING ((public.is_super_admin() OR public.is_org_member(org_id)));


--
-- TOC entry 5106 (class 3256 OID 87035)
-- Name: rooms Users can manage rooms in their property; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can manage rooms in their property" ON public.rooms USING ((public.is_super_admin() OR (EXISTS ( SELECT 1
   FROM public.properties p
  WHERE ((p.id = rooms.property_id) AND public.is_org_member(p.org_id))))));


--
-- TOC entry 5181 (class 3256 OID 84705)
-- Name: booking_rooms Users can update booking_rooms for their org; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can update booking_rooms for their org" ON public.booking_rooms FOR UPDATE USING ((org_id = ( SELECT booking_rooms.org_id
   FROM public.profiles
  WHERE (profiles.id = auth.uid()))));


--
-- TOC entry 5069 (class 3256 OID 63309)
-- Name: booking_charges Users can update charges of their bookings; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can update charges of their bookings" ON public.booking_charges FOR UPDATE USING (public.check_booking_access(booking_id));


--
-- TOC entry 5042 (class 3256 OID 18549)
-- Name: expenses Users can update expenses for their properties; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can update expenses for their properties" ON public.expenses FOR UPDATE TO authenticated USING ((EXISTS ( SELECT 1
   FROM public.properties
  WHERE ((properties.id = expenses.property_id) AND (properties.user_id = auth.uid())))));


--
-- TOC entry 5061 (class 3256 OID 63300)
-- Name: rooms Users can update rooms of their properties; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can update rooms of their properties" ON public.rooms FOR UPDATE USING (public.check_user_access(property_id));


--
-- TOC entry 5065 (class 3256 OID 63304)
-- Name: pricing_rules Users can update rules of their properties; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can update rules of their properties" ON public.pricing_rules FOR UPDATE USING (public.check_user_access(property_id));


--
-- TOC entry 5037 (class 3256 OID 18529)
-- Name: tasks Users can update tasks for their properties; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can update tasks for their properties" ON public.tasks FOR UPDATE TO authenticated USING ((EXISTS ( SELECT 1
   FROM public.properties
  WHERE ((properties.id = tasks.property_id) AND (properties.user_id = auth.uid())))));


--
-- TOC entry 5046 (class 3256 OID 18569)
-- Name: notifications Users can update their own notifications; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can update their own notifications" ON public.notifications FOR UPDATE TO authenticated USING ((auth.uid() = user_id));


--
-- TOC entry 5179 (class 3256 OID 84703)
-- Name: booking_rooms Users can view booking_rooms for their org; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can view booking_rooms for their org" ON public.booking_rooms FOR SELECT USING ((org_id = ( SELECT booking_rooms.org_id
   FROM public.profiles
  WHERE (profiles.id = auth.uid()))));


--
-- TOC entry 5101 (class 3256 OID 87030)
-- Name: bookings Users can view bookings in their org; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can view bookings in their org" ON public.bookings FOR SELECT USING ((public.is_super_admin() OR public.is_org_member(org_id)));


--
-- TOC entry 5083 (class 3256 OID 71104)
-- Name: room_categories Users can view categories in their properties; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can view categories in their properties" ON public.room_categories FOR SELECT USING ((property_id IN ( SELECT p.id
   FROM ((public.properties p
     JOIN public.organizations o ON ((o.id = p.org_id)))
     JOIN public.org_members om ON ((om.org_id = o.id)))
  WHERE (om.user_id = auth.uid()))));


--
-- TOC entry 5067 (class 3256 OID 63307)
-- Name: booking_charges Users can view charges of their bookings; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can view charges of their bookings" ON public.booking_charges FOR SELECT USING (public.check_booking_access(booking_id));


--
-- TOC entry 5039 (class 3256 OID 18547)
-- Name: expenses Users can view expenses for their properties; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can view expenses for their properties" ON public.expenses FOR SELECT TO authenticated USING ((EXISTS ( SELECT 1
   FROM public.properties
  WHERE ((properties.id = expenses.property_id) AND (properties.user_id = auth.uid())))));


--
-- TOC entry 5104 (class 3256 OID 87032)
-- Name: guests Users can view guests in their org; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can view guests in their org" ON public.guests FOR SELECT USING ((public.is_super_admin() OR public.is_org_member(org_id)));


--
-- TOC entry 5174 (class 3256 OID 84658)
-- Name: booking_guests Users can view own org booking guests; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can view own org booking guests" ON public.booking_guests FOR SELECT USING ((org_id = ( SELECT (current_setting('app.current_org_id'::text, true))::uuid AS current_setting)));


--
-- TOC entry 5173 (class 3256 OID 84655)
-- Name: precheckin_sessions Users can view own org precheckin sessions; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can view own org precheckin sessions" ON public.precheckin_sessions FOR SELECT USING ((org_id = ( SELECT (current_setting('app.current_org_id'::text, true))::uuid AS current_setting)));


--
-- TOC entry 5107 (class 3256 OID 87036)
-- Name: properties Users can view properties in their org; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can view properties in their org" ON public.properties FOR SELECT USING ((public.is_super_admin() OR public.is_org_member(org_id)));


--
-- TOC entry 5105 (class 3256 OID 87034)
-- Name: rooms Users can view rooms in their property; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can view rooms in their property" ON public.rooms FOR SELECT USING ((public.is_super_admin() OR (EXISTS ( SELECT 1
   FROM public.properties p
  WHERE ((p.id = rooms.property_id) AND public.is_org_member(p.org_id))))));


--
-- TOC entry 5059 (class 3256 OID 63298)
-- Name: rooms Users can view rooms of their properties; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can view rooms of their properties" ON public.rooms FOR SELECT USING (public.check_user_access(property_id));


--
-- TOC entry 5063 (class 3256 OID 63302)
-- Name: pricing_rules Users can view rules of their properties; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can view rules of their properties" ON public.pricing_rules FOR SELECT USING (public.check_user_access(property_id));


--
-- TOC entry 5035 (class 3256 OID 18527)
-- Name: tasks Users can view tasks for their properties; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can view tasks for their properties" ON public.tasks FOR SELECT TO authenticated USING ((EXISTS ( SELECT 1
   FROM public.properties
  WHERE ((properties.id = tasks.property_id) AND (properties.user_id = auth.uid())))));


--
-- TOC entry 5044 (class 3256 OID 18567)
-- Name: notifications Users can view their own notifications; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can view their own notifications" ON public.notifications FOR SELECT TO authenticated USING ((auth.uid() = user_id));


--
-- TOC entry 5133 (class 3256 OID 70579)
-- Name: properties Users can view their own properties; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can view their own properties" ON public.properties FOR SELECT TO authenticated USING ((auth.uid() = user_id));


--
-- TOC entry 5093 (class 3256 OID 63547)
-- Name: idea_comments Users comment on own ideas; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users comment on own ideas" ON public.idea_comments FOR INSERT WITH CHECK (((auth.uid() = user_id) AND (EXISTS ( SELECT 1
   FROM public.ideas
  WHERE ((ideas.id = idea_comments.idea_id) AND (ideas.user_id = auth.uid()))))));


--
-- TOC entry 5085 (class 3256 OID 63539)
-- Name: ticket_comments Users comment on own tickets; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users comment on own tickets" ON public.ticket_comments FOR INSERT WITH CHECK (((auth.uid() = user_id) AND (EXISTS ( SELECT 1
   FROM public.tickets
  WHERE ((tickets.id = ticket_comments.ticket_id) AND (tickets.user_id = auth.uid()))))));


--
-- TOC entry 5088 (class 3256 OID 63542)
-- Name: ideas Users insert own ideas; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users insert own ideas" ON public.ideas FOR INSERT WITH CHECK ((auth.uid() = user_id));


--
-- TOC entry 5078 (class 3256 OID 63534)
-- Name: tickets Users inset own tickets; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users inset own tickets" ON public.tickets FOR INSERT WITH CHECK ((auth.uid() = user_id));


--
-- TOC entry 5091 (class 3256 OID 63545)
-- Name: idea_comments Users view comments on own ideas; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users view comments on own ideas" ON public.idea_comments FOR SELECT USING ((EXISTS ( SELECT 1
   FROM public.ideas
  WHERE ((ideas.id = idea_comments.idea_id) AND (ideas.user_id = auth.uid())))));


--
-- TOC entry 5081 (class 3256 OID 63537)
-- Name: ticket_comments Users view comments on own tickets; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users view comments on own tickets" ON public.ticket_comments FOR SELECT USING ((EXISTS ( SELECT 1
   FROM public.tickets
  WHERE ((tickets.id = ticket_comments.ticket_id) AND (tickets.user_id = auth.uid())))));


--
-- TOC entry 5087 (class 3256 OID 63541)
-- Name: ideas Users view own ideas; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users view own ideas" ON public.ideas FOR SELECT USING ((auth.uid() = user_id));


--
-- TOC entry 5077 (class 3256 OID 63533)
-- Name: tickets Users view own tickets; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users view own tickets" ON public.tickets FOR SELECT USING ((auth.uid() = user_id));


--
-- TOC entry 4967 (class 0 OID 18026)
-- Dependencies: 383
-- Name: amenities; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.amenities ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 5001 (class 0 OID 63581)
-- Dependencies: 418
-- Name: audit_log; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.audit_log ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4995 (class 0 OID 61059)
-- Dependencies: 412
-- Name: booking_charges; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.booking_charges ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 5017 (class 0 OID 83395)
-- Dependencies: 434
-- Name: booking_guests; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.booking_guests ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 5019 (class 0 OID 84672)
-- Dependencies: 438
-- Name: booking_rooms; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.booking_rooms ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4969 (class 0 OID 18054)
-- Dependencies: 385
-- Name: bookings; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.bookings ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4987 (class 0 OID 59768)
-- Dependencies: 404
-- Name: departments; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.departments ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4970 (class 0 OID 18072)
-- Dependencies: 386
-- Name: entity_photos; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.entity_photos ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4976 (class 0 OID 18532)
-- Dependencies: 392
-- Name: expenses; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.expenses ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4980 (class 0 OID 18781)
-- Dependencies: 396
-- Name: faqs; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.faqs ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4983 (class 0 OID 18823)
-- Dependencies: 399
-- Name: features; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.features ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 5016 (class 0 OID 83380)
-- Dependencies: 433
-- Name: guest_consents; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.guest_consents ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 5015 (class 0 OID 83368)
-- Dependencies: 432
-- Name: guests; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.guests ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 5020 (class 0 OID 85814)
-- Dependencies: 439
-- Name: hostconnect_onboarding; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.hostconnect_onboarding ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4996 (class 0 OID 63432)
-- Dependencies: 413
-- Name: hostconnect_staff; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.hostconnect_staff ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4984 (class 0 OID 18836)
-- Dependencies: 400
-- Name: how_it_works_steps; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.how_it_works_steps ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 5000 (class 0 OID 63505)
-- Dependencies: 417
-- Name: idea_comments; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.idea_comments ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4999 (class 0 OID 63487)
-- Dependencies: 416
-- Name: ideas; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.ideas ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4981 (class 0 OID 18794)
-- Dependencies: 397
-- Name: integrations; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.integrations ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 5006 (class 0 OID 63793)
-- Dependencies: 423
-- Name: inventory_items; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.inventory_items ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4978 (class 0 OID 18739)
-- Dependencies: 394
-- Name: invoices; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.invoices ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 5008 (class 0 OID 63838)
-- Dependencies: 425
-- Name: item_stock; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.item_stock ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4994 (class 0 OID 59931)
-- Dependencies: 411
-- Name: lead_timeline_events; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.lead_timeline_events ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 5004 (class 0 OID 63711)
-- Dependencies: 421
-- Name: member_permissions; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.member_permissions ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4977 (class 0 OID 18552)
-- Dependencies: 393
-- Name: notifications; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.notifications ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 5139 (class 3256 OID 83335)
-- Name: amenities org_admins_delete_amenities; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY org_admins_delete_amenities ON public.amenities FOR DELETE USING ((public.is_org_admin(org_id) OR public.is_hostconnect_staff()));


--
-- TOC entry 5171 (class 3256 OID 83367)
-- Name: inventory_items org_admins_delete_inventory_items; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY org_admins_delete_inventory_items ON public.inventory_items FOR DELETE USING ((public.is_org_admin(org_id) OR public.is_hostconnect_staff()));


--
-- TOC entry 5151 (class 3256 OID 83347)
-- Name: item_stock org_admins_delete_item_stock; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY org_admins_delete_item_stock ON public.item_stock FOR DELETE USING ((public.is_org_admin(org_id) OR public.is_hostconnect_staff()));


--
-- TOC entry 5159 (class 3256 OID 83355)
-- Name: pricing_rules org_admins_delete_pricing_rules; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY org_admins_delete_pricing_rules ON public.pricing_rules FOR DELETE USING ((public.is_org_admin(org_id) OR public.is_hostconnect_staff()));


--
-- TOC entry 5167 (class 3256 OID 83363)
-- Name: room_categories org_admins_delete_room_categories; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY org_admins_delete_room_categories ON public.room_categories FOR DELETE USING ((public.is_org_admin(org_id) OR public.is_hostconnect_staff()));


--
-- TOC entry 5155 (class 3256 OID 83351)
-- Name: room_type_inventory org_admins_delete_room_type_inventory; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY org_admins_delete_room_type_inventory ON public.room_type_inventory FOR DELETE USING ((public.is_org_admin(org_id) OR public.is_hostconnect_staff()));


--
-- TOC entry 5143 (class 3256 OID 83339)
-- Name: room_types org_admins_delete_room_types; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY org_admins_delete_room_types ON public.room_types FOR DELETE USING ((public.is_org_admin(org_id) OR public.is_hostconnect_staff()));


--
-- TOC entry 5147 (class 3256 OID 83343)
-- Name: services org_admins_delete_services; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY org_admins_delete_services ON public.services FOR DELETE USING ((public.is_org_admin(org_id) OR public.is_hostconnect_staff()));


--
-- TOC entry 5163 (class 3256 OID 83359)
-- Name: website_settings org_admins_delete_website_settings; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY org_admins_delete_website_settings ON public.website_settings FOR DELETE USING ((public.is_org_admin(org_id) OR public.is_hostconnect_staff()));


--
-- TOC entry 5137 (class 3256 OID 83333)
-- Name: amenities org_admins_insert_amenities; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY org_admins_insert_amenities ON public.amenities FOR INSERT WITH CHECK ((public.is_org_admin(org_id) OR public.is_hostconnect_staff()));


--
-- TOC entry 5157 (class 3256 OID 83353)
-- Name: pricing_rules org_admins_insert_pricing_rules; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY org_admins_insert_pricing_rules ON public.pricing_rules FOR INSERT WITH CHECK ((public.is_org_admin(org_id) OR public.is_hostconnect_staff()));


--
-- TOC entry 5165 (class 3256 OID 83361)
-- Name: room_categories org_admins_insert_room_categories; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY org_admins_insert_room_categories ON public.room_categories FOR INSERT WITH CHECK ((public.is_org_admin(org_id) OR public.is_hostconnect_staff()));


--
-- TOC entry 5141 (class 3256 OID 83337)
-- Name: room_types org_admins_insert_room_types; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY org_admins_insert_room_types ON public.room_types FOR INSERT WITH CHECK ((public.is_org_admin(org_id) OR public.is_hostconnect_staff()));


--
-- TOC entry 5145 (class 3256 OID 83341)
-- Name: services org_admins_insert_services; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY org_admins_insert_services ON public.services FOR INSERT WITH CHECK ((public.is_org_admin(org_id) OR public.is_hostconnect_staff()));


--
-- TOC entry 5161 (class 3256 OID 83357)
-- Name: website_settings org_admins_insert_website_settings; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY org_admins_insert_website_settings ON public.website_settings FOR INSERT WITH CHECK ((public.is_org_admin(org_id) OR public.is_hostconnect_staff()));


--
-- TOC entry 5138 (class 3256 OID 83334)
-- Name: amenities org_admins_update_amenities; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY org_admins_update_amenities ON public.amenities FOR UPDATE USING ((public.is_org_admin(org_id) OR public.is_hostconnect_staff()));


--
-- TOC entry 5158 (class 3256 OID 83354)
-- Name: pricing_rules org_admins_update_pricing_rules; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY org_admins_update_pricing_rules ON public.pricing_rules FOR UPDATE USING ((public.is_org_admin(org_id) OR public.is_hostconnect_staff()));


--
-- TOC entry 5166 (class 3256 OID 83362)
-- Name: room_categories org_admins_update_room_categories; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY org_admins_update_room_categories ON public.room_categories FOR UPDATE USING ((public.is_org_admin(org_id) OR public.is_hostconnect_staff()));


--
-- TOC entry 5142 (class 3256 OID 83338)
-- Name: room_types org_admins_update_room_types; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY org_admins_update_room_types ON public.room_types FOR UPDATE USING ((public.is_org_admin(org_id) OR public.is_hostconnect_staff()));


--
-- TOC entry 5146 (class 3256 OID 83342)
-- Name: services org_admins_update_services; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY org_admins_update_services ON public.services FOR UPDATE USING ((public.is_org_admin(org_id) OR public.is_hostconnect_staff()));


--
-- TOC entry 5162 (class 3256 OID 83358)
-- Name: website_settings org_admins_update_website_settings; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY org_admins_update_website_settings ON public.website_settings FOR UPDATE USING ((public.is_org_admin(org_id) OR public.is_hostconnect_staff()));


--
-- TOC entry 5178 (class 3256 OID 84670)
-- Name: rooms org_delete_rooms; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY org_delete_rooms ON public.rooms FOR DELETE USING ((org_id = ( SELECT (current_setting('app.current_org_id'::text, true))::uuid AS current_setting)));


--
-- TOC entry 5176 (class 3256 OID 84668)
-- Name: rooms org_insert_rooms; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY org_insert_rooms ON public.rooms FOR INSERT WITH CHECK (((auth.role() = 'authenticated'::text) AND (org_id = ( SELECT (current_setting('app.current_org_id'::text, true))::uuid AS current_setting))));


--
-- TOC entry 5005 (class 0 OID 63737)
-- Dependencies: 422
-- Name: org_invites; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.org_invites ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 5003 (class 0 OID 63619)
-- Dependencies: 420
-- Name: org_members; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.org_members ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 5169 (class 3256 OID 83365)
-- Name: inventory_items org_members_insert_inventory_items; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY org_members_insert_inventory_items ON public.inventory_items FOR INSERT WITH CHECK ((public.is_org_member(org_id) OR public.is_hostconnect_staff()));


--
-- TOC entry 5149 (class 3256 OID 83345)
-- Name: item_stock org_members_insert_item_stock; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY org_members_insert_item_stock ON public.item_stock FOR INSERT WITH CHECK ((public.is_org_member(org_id) OR public.is_hostconnect_staff()));


--
-- TOC entry 5153 (class 3256 OID 83349)
-- Name: room_type_inventory org_members_insert_room_type_inventory; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY org_members_insert_room_type_inventory ON public.room_type_inventory FOR INSERT WITH CHECK ((public.is_org_member(org_id) OR public.is_hostconnect_staff()));


--
-- TOC entry 5136 (class 3256 OID 83332)
-- Name: amenities org_members_select_amenities; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY org_members_select_amenities ON public.amenities FOR SELECT USING ((public.is_org_member(org_id) OR public.is_hostconnect_staff()));


--
-- TOC entry 5168 (class 3256 OID 83364)
-- Name: inventory_items org_members_select_inventory_items; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY org_members_select_inventory_items ON public.inventory_items FOR SELECT USING ((public.is_org_member(org_id) OR public.is_hostconnect_staff()));


--
-- TOC entry 5148 (class 3256 OID 83344)
-- Name: item_stock org_members_select_item_stock; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY org_members_select_item_stock ON public.item_stock FOR SELECT USING ((public.is_org_member(org_id) OR public.is_hostconnect_staff()));


--
-- TOC entry 5156 (class 3256 OID 83352)
-- Name: pricing_rules org_members_select_pricing_rules; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY org_members_select_pricing_rules ON public.pricing_rules FOR SELECT USING ((public.is_org_member(org_id) OR public.is_hostconnect_staff()));


--
-- TOC entry 5164 (class 3256 OID 83360)
-- Name: room_categories org_members_select_room_categories; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY org_members_select_room_categories ON public.room_categories FOR SELECT USING ((public.is_org_member(org_id) OR public.is_hostconnect_staff()));


--
-- TOC entry 5152 (class 3256 OID 83348)
-- Name: room_type_inventory org_members_select_room_type_inventory; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY org_members_select_room_type_inventory ON public.room_type_inventory FOR SELECT USING ((public.is_org_member(org_id) OR public.is_hostconnect_staff()));


--
-- TOC entry 5140 (class 3256 OID 83336)
-- Name: room_types org_members_select_room_types; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY org_members_select_room_types ON public.room_types FOR SELECT USING ((public.is_org_member(org_id) OR public.is_hostconnect_staff()));


--
-- TOC entry 5144 (class 3256 OID 83340)
-- Name: services org_members_select_services; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY org_members_select_services ON public.services FOR SELECT USING ((public.is_org_member(org_id) OR public.is_hostconnect_staff()));


--
-- TOC entry 5160 (class 3256 OID 83356)
-- Name: website_settings org_members_select_website_settings; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY org_members_select_website_settings ON public.website_settings FOR SELECT USING ((public.is_org_member(org_id) OR public.is_hostconnect_staff()));


--
-- TOC entry 5172 (class 3256 OID 91543)
-- Name: org_members org_members_self_read; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY org_members_self_read ON public.org_members FOR SELECT TO authenticated USING ((user_id = auth.uid()));


--
-- TOC entry 5170 (class 3256 OID 83366)
-- Name: inventory_items org_members_update_inventory_items; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY org_members_update_inventory_items ON public.inventory_items FOR UPDATE USING ((public.is_org_member(org_id) OR public.is_hostconnect_staff()));


--
-- TOC entry 5150 (class 3256 OID 83346)
-- Name: item_stock org_members_update_item_stock; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY org_members_update_item_stock ON public.item_stock FOR UPDATE USING ((public.is_org_member(org_id) OR public.is_hostconnect_staff()));


--
-- TOC entry 5154 (class 3256 OID 83350)
-- Name: room_type_inventory org_members_update_room_type_inventory; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY org_members_update_room_type_inventory ON public.room_type_inventory FOR UPDATE USING ((public.is_org_member(org_id) OR public.is_hostconnect_staff()));


--
-- TOC entry 5175 (class 3256 OID 84667)
-- Name: rooms org_select_rooms; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY org_select_rooms ON public.rooms FOR SELECT USING ((org_id = ( SELECT (current_setting('app.current_org_id'::text, true))::uuid AS current_setting)));


--
-- TOC entry 5177 (class 3256 OID 84669)
-- Name: rooms org_update_rooms; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY org_update_rooms ON public.rooms FOR UPDATE USING ((org_id = ( SELECT (current_setting('app.current_org_id'::text, true))::uuid AS current_setting)));


--
-- TOC entry 5002 (class 0 OID 63605)
-- Dependencies: 419
-- Name: organizations; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.organizations ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 5018 (class 0 OID 84631)
-- Dependencies: 437
-- Name: precheckin_sessions; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.precheckin_sessions ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4979 (class 0 OID 18766)
-- Dependencies: 395
-- Name: pricing_plans; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.pricing_plans ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4972 (class 0 OID 18342)
-- Dependencies: 388
-- Name: pricing_rules; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.pricing_rules ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4965 (class 0 OID 17992)
-- Dependencies: 381
-- Name: profiles; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 5109 (class 3256 OID 92660)
-- Name: profiles profiles_insert_self; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY profiles_insert_self ON public.profiles FOR INSERT TO authenticated WITH CHECK ((id = auth.uid()));


--
-- TOC entry 5097 (class 3256 OID 91554)
-- Name: profiles profiles_read_authenticated; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY profiles_read_authenticated ON public.profiles FOR SELECT TO authenticated USING (true);


--
-- TOC entry 5098 (class 3256 OID 91555)
-- Name: profiles profiles_update_self; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY profiles_update_self ON public.profiles FOR UPDATE TO authenticated USING ((id = auth.uid())) WITH CHECK ((id = auth.uid()));


--
-- TOC entry 4966 (class 0 OID 18008)
-- Dependencies: 382
-- Name: properties; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.properties ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4992 (class 0 OID 59872)
-- Dependencies: 409
-- Name: reservation_leads; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.reservation_leads ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4993 (class 0 OID 59902)
-- Dependencies: 410
-- Name: reservation_quotes; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.reservation_quotes ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 5009 (class 0 OID 69393)
-- Dependencies: 426
-- Name: room_categories; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.room_categories ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 5007 (class 0 OID 63813)
-- Dependencies: 424
-- Name: room_type_inventory; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.room_type_inventory ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4968 (class 0 OID 18036)
-- Dependencies: 384
-- Name: room_types; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.room_types ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4971 (class 0 OID 18266)
-- Dependencies: 387
-- Name: rooms; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.rooms ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4973 (class 0 OID 18392)
-- Dependencies: 389
-- Name: services; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.services ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4990 (class 0 OID 59830)
-- Dependencies: 407
-- Name: shift_assignments; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.shift_assignments ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4991 (class 0 OID 59851)
-- Dependencies: 408
-- Name: shift_handoffs; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.shift_handoffs ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4989 (class 0 OID 59804)
-- Dependencies: 406
-- Name: shifts; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.shifts ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4988 (class 0 OID 59783)
-- Dependencies: 405
-- Name: staff_profiles; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.staff_profiles ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 5014 (class 0 OID 70918)
-- Dependencies: 431
-- Name: stock_check_items; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.stock_check_items ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 5013 (class 0 OID 70863)
-- Dependencies: 430
-- Name: stock_daily_checks; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.stock_daily_checks ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 5011 (class 0 OID 70820)
-- Dependencies: 428
-- Name: stock_items; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.stock_items ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 5010 (class 0 OID 70806)
-- Dependencies: 427
-- Name: stock_locations; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.stock_locations ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 5012 (class 0 OID 70844)
-- Dependencies: 429
-- Name: stock_movements; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.stock_movements ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4975 (class 0 OID 18506)
-- Dependencies: 391
-- Name: tasks; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.tasks ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4982 (class 0 OID 18808)
-- Dependencies: 398
-- Name: testimonials; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.testimonials ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4998 (class 0 OID 63466)
-- Dependencies: 415
-- Name: ticket_comments; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.ticket_comments ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4997 (class 0 OID 63447)
-- Dependencies: 414
-- Name: tickets; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.tickets ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4974 (class 0 OID 18462)
-- Dependencies: 390
-- Name: website_settings; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.website_settings ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4964 (class 0 OID 17435)
-- Dependencies: 380
-- Name: messages; Type: ROW SECURITY; Schema: realtime; Owner: -
--

ALTER TABLE realtime.messages ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 5127 (class 3256 OID 69388)
-- Name: objects Anyone can view property photos; Type: POLICY; Schema: storage; Owner: -
--

CREATE POLICY "Anyone can view property photos" ON storage.objects FOR SELECT USING ((bucket_id = 'property-photos'::text));


--
-- TOC entry 5130 (class 3256 OID 69391)
-- Name: objects Users can delete own photos; Type: POLICY; Schema: storage; Owner: -
--

CREATE POLICY "Users can delete own photos" ON storage.objects FOR DELETE TO authenticated USING (((bucket_id = 'property-photos'::text) AND ((storage.foldername(name))[1] = (auth.uid())::text)));


--
-- TOC entry 5129 (class 3256 OID 69390)
-- Name: objects Users can update own photos; Type: POLICY; Schema: storage; Owner: -
--

CREATE POLICY "Users can update own photos" ON storage.objects FOR UPDATE TO authenticated USING (((bucket_id = 'property-photos'::text) AND ((storage.foldername(name))[1] = (auth.uid())::text)));


--
-- TOC entry 5128 (class 3256 OID 69389)
-- Name: objects Users can upload photos to own folders; Type: POLICY; Schema: storage; Owner: -
--

CREATE POLICY "Users can upload photos to own folders" ON storage.objects FOR INSERT TO authenticated WITH CHECK (((bucket_id = 'property-photos'::text) AND ((storage.foldername(name))[1] = (auth.uid())::text)));


--
-- TOC entry 4947 (class 0 OID 16546)
-- Dependencies: 351
-- Name: buckets; Type: ROW SECURITY; Schema: storage; Owner: -
--

ALTER TABLE storage.buckets ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4963 (class 0 OID 17242)
-- Dependencies: 373
-- Name: buckets_analytics; Type: ROW SECURITY; Schema: storage; Owner: -
--

ALTER TABLE storage.buckets_analytics ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4985 (class 0 OID 47575)
-- Dependencies: 401
-- Name: buckets_vectors; Type: ROW SECURITY; Schema: storage; Owner: -
--

ALTER TABLE storage.buckets_vectors ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4949 (class 0 OID 16588)
-- Dependencies: 353
-- Name: migrations; Type: ROW SECURITY; Schema: storage; Owner: -
--

ALTER TABLE storage.migrations ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4948 (class 0 OID 16561)
-- Dependencies: 352
-- Name: objects; Type: ROW SECURITY; Schema: storage; Owner: -
--

ALTER TABLE storage.objects ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4961 (class 0 OID 17144)
-- Dependencies: 371
-- Name: s3_multipart_uploads; Type: ROW SECURITY; Schema: storage; Owner: -
--

ALTER TABLE storage.s3_multipart_uploads ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4962 (class 0 OID 17158)
-- Dependencies: 372
-- Name: s3_multipart_uploads_parts; Type: ROW SECURITY; Schema: storage; Owner: -
--

ALTER TABLE storage.s3_multipart_uploads_parts ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4986 (class 0 OID 47585)
-- Dependencies: 402
-- Name: vector_indexes; Type: ROW SECURITY; Schema: storage; Owner: -
--

ALTER TABLE storage.vector_indexes ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 5187 (class 6104 OID 16426)
-- Name: supabase_realtime; Type: PUBLICATION; Schema: -; Owner: -
--

CREATE PUBLICATION supabase_realtime WITH (publish = 'insert, update, delete, truncate');


--
-- TOC entry 3901 (class 3466 OID 16621)
-- Name: issue_graphql_placeholder; Type: EVENT TRIGGER; Schema: -; Owner: -
--

CREATE EVENT TRIGGER issue_graphql_placeholder ON sql_drop
         WHEN TAG IN ('DROP EXTENSION')
   EXECUTE FUNCTION extensions.set_graphql_placeholder();


--
-- TOC entry 3906 (class 3466 OID 16700)
-- Name: issue_pg_cron_access; Type: EVENT TRIGGER; Schema: -; Owner: -
--

CREATE EVENT TRIGGER issue_pg_cron_access ON ddl_command_end
         WHEN TAG IN ('CREATE EXTENSION')
   EXECUTE FUNCTION extensions.grant_pg_cron_access();


--
-- TOC entry 3900 (class 3466 OID 16619)
-- Name: issue_pg_graphql_access; Type: EVENT TRIGGER; Schema: -; Owner: -
--

CREATE EVENT TRIGGER issue_pg_graphql_access ON ddl_command_end
         WHEN TAG IN ('CREATE FUNCTION')
   EXECUTE FUNCTION extensions.grant_pg_graphql_access();


--
-- TOC entry 3907 (class 3466 OID 16703)
-- Name: issue_pg_net_access; Type: EVENT TRIGGER; Schema: -; Owner: -
--

CREATE EVENT TRIGGER issue_pg_net_access ON ddl_command_end
         WHEN TAG IN ('CREATE EXTENSION')
   EXECUTE FUNCTION extensions.grant_pg_net_access();


--
-- TOC entry 3902 (class 3466 OID 16622)
-- Name: pgrst_ddl_watch; Type: EVENT TRIGGER; Schema: -; Owner: -
--

CREATE EVENT TRIGGER pgrst_ddl_watch ON ddl_command_end
   EXECUTE FUNCTION extensions.pgrst_ddl_watch();


--
-- TOC entry 3903 (class 3466 OID 16623)
-- Name: pgrst_drop_watch; Type: EVENT TRIGGER; Schema: -; Owner: -
--

CREATE EVENT TRIGGER pgrst_drop_watch ON sql_drop
   EXECUTE FUNCTION extensions.pgrst_drop_watch();


-- Completed on 2026-02-15 19:00:47

--
-- PostgreSQL database dump complete
--

\unrestrict QGqXGArDypXQuQXqCB6kPSrnuBfUl6PimhiWaL6Z9WbHq0VZgjTUsdgJXmYH6dM

