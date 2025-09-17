-- Initialize TODO application database
-- This script runs when the PostgreSQL container starts for the first time

-- Create extensions if they don't exist
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pg_trgm";

-- Create indexes for better performance (these will be created by Alembic migrations)
-- But we can set up some basic configuration here

-- Set timezone
SET timezone = 'UTC';

-- Create a function to update timestamps
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Grant necessary permissions to the application user
GRANT ALL PRIVILEGES ON DATABASE todoapp TO todouser;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO todouser;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO todouser;

-- Set default permissions for future tables
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON TABLES TO todouser;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON SEQUENCES TO todouser;
