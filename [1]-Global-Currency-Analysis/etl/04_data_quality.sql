-- Data Quality and Summary Statistics are generated

    -- Combining records
SELECT 'ETL Complete' AS status;

SELECT 
    'Date Records' AS dimenions,
    COUNT(*) AS count
FROM dim_date
UNION ALL
SELECT 
    'Country Records',
    COUNT(*)
FROM dim_country
UNION ALL
SELECT
    'Indicator Records',
    COUNT(*)
FROM dim_indicator
UNION ALL
SELECT
    'Fact Records',
    COUNT(*)
FROM fact_economic_indicator;

    -- Viewing if any records did not load
SELECT 
    'Records in Staging' AS metric,
    COUNT(*) AS count
FROM staging_raw_data
UNION ALL
SELECT
    'Records in Fact Table' AS metric,
    COUNT(*) AS count
FROM fact_economic_indicator;

    -- Checking for any orphaned records
SELECT 
    'Missing Date Keys' AS issue,
    COUNT(*) AS count
FROM staging_raw_data AS srd
WHERE NOT EXISTS (
    SELECT 1
    FROM dim_date AS dd
    WHERE dd.date_key = srd.year * 10000 + 101
);

SELECT
    'Missing Country Keys' AS issue,
    COUNT(*) AS count
FROM staging_raw_data AS srd
WHERE NOT EXISTS (
    SELECT 1
    FROM dim_country AS dc
    WHERE dc.country_key = COALESCE(srd.country_code, 'UNK')
)

SELECT 
    'Missing Indicator Keys' AS issue,
    COUNT(*) AS count
FROM staging_raw_data AS srd
WHERE NOT EXISTS (
    SELECT 1
    FROM dim_indicator AS di
    WHERE di.indicator_key = srd.indicator_key
)

    -- Checking for NULL values in fact_economic_indicator fact table
SELECT
    SUM(CASE 
            WHEN date_key IS NULL 
            THEN 1 
            ELSE 0 
            END) AS null_dates,
    SUM(CASE
            WHEN indicator_key IS NULL 
            THEN 1
            ELSE 0
            END) AS null_indicators,
    SUM(CASE
            WHEN country_key IS NULL
            THEN 1
            ELSE 0
            END) AS null_countries,
    SUM(CASE
            WHEN values IS NULL
            THEN 1
            ELSE 0
            END) AS null_values
FROM fact_economic_indicator;

    -- Grouping duplicate combinations
SELECT
    date_key,
    country_key,
    indicator_key,
    COUNT(*) AS duplicate_count
FROM fact_economic_indicator
GROUP BY
    country_key,
    indicator_key,
    date_key
HAVING COUNT(*) > 1;