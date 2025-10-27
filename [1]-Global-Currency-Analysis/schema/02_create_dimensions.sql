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

-- Second step is to create the fact table based on the global-currency-schema.png image created

    -- fact_economic_indicator table
CREATE TABLE fact_economic_indicator(
    fact_id BIGSERIAL PRIMARY KEY,
    date_key INTEGER NOT NULL,
    country_key INTEGER NOT NULL,
    indicator_key INTEGER NOT NULL,
    value DECIMAL(20, 6)

    CONSTRAINT fk_date FOREIGN KEY (date_key) REFERENCES dim_date(date_key),
    CONSTRAINT fk_country FOREIGN KEY (country_key) REFERENCES dim_country(country_key),
    CONSTRAINT fk_indicator FOREIGN KEY (indicator_key) REFERENCES dim_indicator(indicator_key)
);

CREATE INDEX idx_date ON fact_economic_indicator (date_key);
CREATE INDEX idx_country ON fact_economic_indicator (country_key);
CREATE INDEX idx_indicator ON fact_economic_indicator (indicator_key);
CREATE INDEX idx_composite ON fact_economic_indicator (date_key, country_key, indicator_key);

