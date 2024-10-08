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

-- Create the orders database if it doesn't exist
SELECT 'CREATE DATABASE orders'
WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = 'orders')\gexec

-- Connect to the orders database
\c orders

-- Create the orders table if it doesn't exist
CREATE TABLE IF NOT EXISTS public.orders (
  id SERIAL PRIMARY KEY,
  user_id INTEGER NOT NULL,
  number_of_items INTEGER NOT NULL,
  total_amount NUMERIC(10, 2) NOT NULL
);

-- Grant necessary permissions
GRANT ALL PRIVILEGES ON DATABASE orders TO rabbit;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO rabbit;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO rabbit;

-- Ensure future tables get the same permissions
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON TABLES TO rabbit;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON SEQUENCES TO rabbit;
