
--------------------------------------------------------------------------------
-- 1) Create user (choose ONE of the two options below)
--------------------------------------------------------------------------------
-- Option A: Use existing USERS/TEMP tablespaces (simple and common on OCI/APEX)
CREATE USER xx_lior IDENTIFIED BY "StrongP@ssw0rd!"
  DEFAULT TABLESPACE USERS
  TEMPORARY TABLESPACE TEMP
  QUOTA UNLIMITED ON USERS;

-- Option B: If you prefer a dedicated tablespace (uncomment and edit paths)
-- CREATE TABLESPACE APP_TBS DATAFILE 'app_tbs01.dbf' SIZE 200M AUTOEXTEND ON NEXT 50M MAXSIZE UNLIMITED;
-- CREATE USER app_user IDENTIFIED BY "StrongP@ssw0rd!"
--   DEFAULT TABLESPACE APP_TBS
--   TEMPORARY TABLESPACE TEMP
--   QUOTA UNLIMITED ON APP_TBS;

--------------------------------------------------------------------------------
-- 2) Grant essential privileges (avoid old CONNECT/RESOURCE role)
--------------------------------------------------------------------------------
GRANT CREATE SESSION    TO xx_lior;
GRANT CREATE TABLE      TO xx_lior;
GRANT CREATE SEQUENCE   TO xx_lior;
GRANT CREATE VIEW       TO xx_lior;
GRANT CREATE PROCEDURE  TO xx_lior;
GRANT CREATE TRIGGER    TO xx_lior;
GRANT CREATE SYNONYM    TO xx_lior;

-- Optional extras if needed later:
-- GRANT CREATE TYPE              TO xx_lior;
-- GRANT CREATE MATERIALIZED VIEW TO xx_lior;

GRANT INHERIT PRIVILEGES ON USER ORDS_METADATA TO xx_lior;
GRANT INHERIT PRIVILEGES ON USER ORDS_PUBLIC_USER TO xx_lior;
--------------------------------------------------------------------------------
-- 3) ORDS: enable REST for the schema (run as a user with ORDS_ADMINISTRATOR_ROLE)
--    This publishes the schema at base path /app and leaves auth open (adjust as needed).
-- --------------------------------------------------------------------------------
-- BEGIN
--   ORDS.ENABLE_SCHEMA(
--     p_enabled            => TRUE,
--     p_schema             => 'APP_USER',
--     p_url_mapping_type   => 'BASE_PATH',
--     p_url_mapping_pattern=> 'app',
--     p_auto_rest_auth     => FALSE
--   );
--   COMMIT;
-- END;
-- /

-- If you plan to use AutoREST on specific tables or views, enable them explicitly:
-- (Run after creating the tables in APP_USER)
-- BEGIN
--   ORDS.ENABLE_OBJECT(
--     p_enabled      => TRUE,
--     p_schema       => 'xx_lior',
--     p_object       => 'PRODUCTS',          -- table/view name
--     p_object_type  => 'TABLE',             -- or 'VIEW'
--     p_object_alias => 'products',          -- URL alias
--     p_auto_rest_auth => FALSE
--   );
--   COMMIT;
-- END;
-- /

-- Optional: allow APP_USER to self-manage its REST definitions (powerful).
-- GRANT ORDS_ADMINISTRATOR_ROLE TO app_user;  -- Only if you want self-service REST admin.


----------------------------------------------------------------------------------- Additional Example: Create another user xx_lior and enable ORDS for it
---------------------------------------------------------------------------------

-- /* Connect as SYS, xx_hrms is a existing user. */
-- GRANT INHERIT PRIVILEGES ON USER ORDS_METADATA TO xx_lior;
-- GRANT INHERIT PRIVILEGES ON USER ORDS_PUBLIC_USER TO xx_lior;
-- /* Connect as xx_lior */
 
/* Connect as xx_lior */
BEGIN
    ORDS.ENABLE_SCHEMA(p_enabled => TRUE,
                       p_schema => 'xx_lior',
                       p_url_mapping_type => 'BASE_PATH',
                       p_url_mapping_pattern => 'hrms',
                       p_auto_rest_auth => FALSE);
    COMMIT;
END;
