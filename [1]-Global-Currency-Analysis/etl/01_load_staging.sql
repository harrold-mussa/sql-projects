-- Cleaning staging data from staging_raw_data table

DELETE FROM staging_raw_data
WHERE year is NULL OR value is NULL;