-- First Step
    -- Analyze the queries by ranking subreddits by average engagement for job loss posts.

SELECT
    subreddit,
    COUNT(post_id_key) AS total_posts,
    ROUND(AVG(post_score), 2) AS avg_score,
    RANK() OVER (ORDER BY AVG(post_score) DESC) AS engagement_rank
FROM fact_table_job_posts
GROUP BY subreddit
ORDER BY engagement_rank;

-- Second step
    -- Analyze the queries by finding the most active user in the highest-scoring subreddit.
SELECT
    user_id,
    COUNT(post_key) AS post_count,
    SUM(post_score) AS total_score
FROM fact_table_job_posts
WHERE subreddit = ''