-- Create the user if it doesn't exist and set the password
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

SELECT 'CREATE DATABASE inventory'
WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = 'inventory')\gexec

-- Connect to the inventory database
\c inventory

CREATE TABLE IF NOT EXISTS public.movies (
  id SERIAL PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  description TEXT,
  "createdAt" TIMESTAMP WITH TIME ZONE NOT NULL,
  "updatedAt" TIMESTAMP WITH TIME ZONE NOT NULL
);

GRANT ALL PRIVILEGES ON DATABASE inventory TO rabbit;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO rabbit;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO rabbit;

-- Ensure future tables get the same permissions
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON TABLES TO rabbit;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON SEQUENCES TO rabbit;
