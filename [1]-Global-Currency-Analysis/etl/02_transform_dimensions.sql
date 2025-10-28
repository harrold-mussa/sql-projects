-- Loading the dimension tables (dim_date, dim_indicator, dim_country)
TRUNCATE TABLE dim_date;
TRUNCATE TABLE dim_country;
TRUNCATE TABLE dim_indicator;

    -- Loading dim_date table
INSERT INTO dim_date (date_key, year, fiscal_quarter, is_current_year)
SELECT DISTINCT
    year * 10000 + 101 AS date_key,
    year,
    EXTRACT(MONTH FROM year) AS month_number,
    CEIL(EXTRACT(MONTH from year) / 3.0) AS fiscal_quarter
FROM staging_raw_data
WHERE year IS NOT NULL;

    -- Loading dim_country table
INSERT INTO dim_country (country_key, country_code, country_name, region, income_group)
SELECT DISTINCT
    COALESCE(country_code, 'UNK') AS country_key, 
    country AS country_name,
    CASE 
        WHEN 
            country IN ('United States of America', 'Canada', 'Mexico') 
            OR 
            country IN ('United States', 'Canada', 'Mexico')
        THEN 'North America'
        WHEN 
            country IN ('Albania', 'Andorra', 'Austria', 'Belarus', 'Belgium', 'Bosnia and Herzegovina', 'Bulgaria', 'Croatia', 'Cyprus', 'Czechia', 'Denmark', 'Estonia', 'Finland', 'France', 'Germany', 'Greece', 'Hungary', 'Iceland', 'Ireland', 'Italy', 'Kosovo', 'Latvia', 'Liechtenstein', 'Lithuania', 'Luxembourg', 'Malta', 'Moldova', 'Monaco', 'Montenegro', 'Netherlands', 'North Macedonia', 'Norway', 'Poland', 'Portugal', 'Romania', 'Russia', 'San Marino', 'Serbia', 'Slovakia', 'Slovenia', 'Spain', 'Sweden', 'Switzerland', 'Turkey', 'Ukraine', 'United Kingdom', 'Vatican City')
        THEN 'Europe'
        WHEN 
            country IN ('Afghanistan', 'Armenia', 'Azerbaijan', 'Bahrain', 'Bangladesh', 'Bhutan', 'Brunei', 'Cambodia', 'China', 'East Timor', 'Georgia', 'India', 'Indonesia', 'Iran', 'Iraq', 'Israel', 'Japan', 'Jordan', 'Kazakhstan', 'Kuwait', 'Kyrgyzstan', 'Laos', 'Lebanon', 'Malaysia', 'Maldives', 'Mongolia', 'Myanmar (Burma)', 'Nepal', 'North Korea', 'Oman', 'Pakistan', 'Palestine', 'Philippines', 'Qatar', 'Saudi Arabia', 'Singapore', 'South Korea', 'Sri Lanka', 'Syria', 'Taiwan', 'Tajikistan', 'Thailand', 'Turkey', 'Turkmenistan', 'United Arab Emirates', 'Uzbekistan', 'Vietnam', 'Yemen')
        THEN 'Asia'
        WHEN
            country IN ('Algeria', 'Angola', 'Benin', 'Botswana', 'Burkina Faso', 'Burundi', 'Cabo Verde', 'Cameroon', 'Central African Republic', 'Chad', 'Comoros', 'Congo (Brazzaville)', 'Congo (Kinshasa)', 'Cote Ivoire', 'Djibouti', 'Egypt', 'Equatorial Guinea', 'Eritrea', 'Eswatini', 'Ethiopia', 'Gabon', 'Gambia', 'Ghana', 'Guinea', 'Guinea-Bissau', 'Kenya', 'Lesotho', 'Liberia', 'Libya', 'Madagascar', 'Malawi', 'Mali', 'Mauritania', 'Mauritius', 'Morocco', 'Mozambique', 'Namibia', 'Niger', 'Nigeria', 'Rwanda', 'Sao Tome and Principe', 'Senegal', 'Seychelles', 'Sierra Leone', 'Somalia', 'South Africa', 'South Sudan', 'Sudan', 'Tanzania', 'Togo', 'Tunisia', 'Uganda', 'Zambia', 'Zimbabwe')
        THEN 'Africa'
        WHEN
            country IN ('Argentina', 'Bolivia', 'Brazil', 'Chile', 'Colombia', 'Ecuador', 'Guyana', 'Paraguay', 'Peru', 'Suriname', 'Uruguay', 'Venezuela')
        THEN 'South America'
        ELSE 'Other'
        END AS region,
        NULL AS income_group
FROM staging_raw_data
WHERE country_name IS NOT NULL;

    -- Loading dim_indicator table
INSERT INTO dim_indicator (indicator_key, indicator_name, indicator_unit, category)
SELECT DISTINCT
    indicator_key
    indicator_name,
    CASE
        WHEN 
            indicator_name LIKE '%GDP%' 
        THEN 'USD'
        WHEN
            indicator_name LIKE '%rate%'
        THEN 'Percentage'
        WHEN
            indicator_name LIKE '%population%'
        THEN 'Count'
        ELSE 'Various'
        END AS indicator_unit,
    CASE
        WHEN
            indicator_name LIKE '%GDP%' 
        THEN 'Economic Output'
        WHEN 
            indicator_name ILIKE '%inflation%' 
        THEN 'Monetary' 
        WHEN 
            indicator_name ILIKE '%exchange%' 
        THEN 'Currency'
        WHEN 
            indicator_name ILIKE '%trade%' 
        THEN 'Trade'
        ELSE 'Other'
    END AS category
FROM staging_raw_data
WHERE indicator_key IS NOT NULL;