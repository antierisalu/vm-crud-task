-- Create the rabbit user if it doesn't exist
DO
$do$
BEGIN
   IF NOT EXISTS (
      SELECT FROM pg_catalog.pg_roles
      WHERE  rolname = 'rabbit') THEN

      CREATE USER rabbit WITH PASSWORD 'rabbit' SUPERUSER;
   END IF;
END
$do$;

SELECT 'CREATE DATABASE billing'
WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = 'billing')\gexec

-- Connect to the orders database
\c billing

CREATE TABLE IF NOT EXISTS public.orders (
  id SERIAL PRIMARY KEY,
  user_id INTEGER NOT NULL,
  number_of_items INTEGER NOT NULL,
  total_amount NUMERIC(10, 2) NOT NULL
);

GRANT ALL PRIVILEGES ON DATABASE billing TO rabbit;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO rabbit;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO rabbit;

-- Ensure future tables get the same permissions
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON TABLES TO rabbit;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON SEQUENCES TO rabbit;
