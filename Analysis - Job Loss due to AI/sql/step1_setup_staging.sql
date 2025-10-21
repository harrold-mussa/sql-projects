-- First step
    -- The setup and staging part of JSON files.
    -- Create the main database of our Job Loss Analysis of Reddit Posts.

CREATE DATABASE reddit_job_loss_db;

-- Second step
    -- creating a JSONB type in PostgreSQL to hold all of our entire raw object.
CREATE TABLE reddit_raw_posts (
    id SERIAL PRIMARY KEY,
    raw_data JSONB
);

-- Third step
    -- this stop would be to allow the Jupyter notebook to load the data for analysis.