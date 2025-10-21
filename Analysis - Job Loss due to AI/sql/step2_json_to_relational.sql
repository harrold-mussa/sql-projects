-- First step
    -- Create the dimension tables for all information collected from Reddit posts.

CREATE TABLE dim_time (
    date_key DATE PRIMARY KEY,
    year INT IS NOT NULL,
    month INT IS NOT NULL,
    day_of_week VARCHAR(10)
);

-- Second step
    -- Create the fact table to clean collected information from Reddit posts.

CREATE TABLE fact_table_job_posts (
    post_id_key VARCHAR(12) PRIMARY KEY,
    user_id VARCHAR(50) IS NOT NULL,
    subreddit VARCHAR(50) IS NOT NULL,
    post_score INT,
    num_comments INT, 
    sentiment_label VARCHAR(10),
    post_title TEXT IS NOT NULL,
    post_date DATE REFERENCES dim_time(date_key)
);

-- Third step
    -- The INSERT function allows me to insert and tranform the data collected. 
    -- The SELECT using the ->> operator will help to extract text fields from the JSONB files.
    -- The WHERE will filter to focus only on posts mentioning job loss or layoff in the title.
    
INSERT INTO fact_table_job_posts (
    post_id_key, user_id, subreddit, post_score, num_comments, sentiment_label, post_title, post_date
)
SELECT 
    (rrp.raw_data ->> 'id') AS post_id_key,
    (rrp.raw_data ->> 'author') AS user_id,
    (rrp.raw_data ->> 'subreddit') AS subreddit,
    (rrp.raw_data ->> 'score')::INT AS post_score,
    (rrp.raw_data ->> 'num_comments')::INT AS num_comments,
    (rrp.raw_data ->> 'title') AS post_title
    (TO_TIMESTAMP((rrp.raw_data ->> 'created_utc')::BIGINT))::DATE AS post_date
FROM reddit_raw_posts AS rrp
WHERE
    rrp.raw_data ->> 'title' ILIKE '%job loss%' OR rrp.raw_date ->> 'title' ILIKE '%layoff%';