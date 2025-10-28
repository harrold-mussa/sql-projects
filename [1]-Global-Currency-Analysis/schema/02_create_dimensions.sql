-- Creating the dimension tables based on global-currency-schema.png image

    -- dim_date table
CREATE TABLE dim_date(
    date_key INTEGER PRIMARY KEY,
    year DATE NOT NULL,
    fiscal_quarter DATE, 
    is_current_year BOOLEAN
);

    -- dim_country table
CREATE TABLE dim_country(
    country_key INTEGER PRIMARY KEY,
    country_code VARCHAR(3),
    country_name TEXT,
    region TEXT,
    income_group TEXT
);

    -- dim_indicator table
CREATE TABLE dim_indicator(
    indicator_key INTEGER PRIMARY KEY,
    indicator_name TEXT,
    indicator_unit INTEGER,
    category TEXT
);


