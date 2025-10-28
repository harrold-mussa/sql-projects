-- Loading fact table
TRUNCATE TABLE fact_economic_indicator;

    -- Loading fact_economic_indicator table
INSERT INTO fact_economic_indicator (date_key, country_key, indicator_key, value)
SELECT 
    dd. date_key,
    dc.country_key,
    do.indicator_key,
    srd.value
FROM staging_raw_data AS srd
INNER JOIN dim_country AS dc
    ON COALESCE(srd.country_code, 'UNK') = dc.country_key
INNER JOIN dim_indicator AS di
    ON srd.indicator_key = di.indicator_key
INNER JOIN dim_date AS dd 
    ON srd.year * 10000 + 101 = dd.date_key
WHERE srd.value IS NOT NULL;