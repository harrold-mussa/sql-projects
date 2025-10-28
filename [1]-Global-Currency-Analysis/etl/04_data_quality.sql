-- Data Quality and Summary Statistics are generated

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

    