-- Staging Table is created to transform CSV files into liquidable data. 

CREATE TABLE staging_raw_data (
    country VARCHAR(50),
    country_code VARHCHAR(10),
    indicator_name VARCHAR(255),
    indicator_code VARCHAR(10),
    year INTEGER,
    value DECIMAL(20, 6)
)

-- Create Indexes

CREATE INDEX idx_country ON staging_raw_data (country_code);
CREATE INDEX idx_indicator ON staging_raw_data (indicator_code);
CREATE INDEX idx_year ON staging_raw_data (year);

-- Load CSV Data

    -- currency.csv
COPY staging_raw_data
FROM '/workspaces/sql-projects/[1]-Global-Currency-Analysis/data/currency.csv' 
DELIMITER ','
CSV HEADER;

    -- global_currency_data_trends.csv
COPY staging_raw_data
FROM '/workspaces/sql-projects/[1]-Global-Currency-Analysis/data/global_currency_data_trends.csv' 
DELIMITER ','
CSV HEADER;

    -- metadata.csv
COPY staging_raw_data
FROM '/workspaces/sql-projects/[1]-Global-Currency-Analysis/data/metadata.csv'
DELIMITER ','
CSV HEADER;

    -- world_global_currency.csv
COPY staging_raw_data
FROM '/workspaces/sql-projects/[1]-Global-Currency-Analysis/data/world_global_currency.csv'
DELIMITER ','
CSV HEADER;

    -- world_indicators_data_human_development_index.csv
COPY staging_raw_data
FROM '/workspaces/sql-projects/[1]-Global-Currency-Analysis/data/world_indicators_data_human_development_index.csv'
DELIMITER ','
CSV HEADER;

    -- world_indicators_data.csv
COPY staging_raw_data
FROM '/workspaces/sql-projects/[1]-Global-Currency-Analysis/data/world_indicators_data.csv'
DELIMITER ','
CSV HEADER;