-- Create the database
CREATE DATABASE todoapp_db;

-- Connect to the database
\c todoapp_db

-- Create the tasks table if it does not exist
CREATE TABLE IF NOT EXISTS tasks (
  id SERIAL PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  description TEXT,
  is_complete BOOLEAN DEFAULT false
);
