WITH source AS (
    SELECT *
    FROM {{ source('menika', 'company') }}
)

SELECT
    CASE
        WHEN id ~ '^[0-9]+$' THEN CAST(id AS INT)
        ELSE NULL
    END AS company_id,

    COALESCE(TRIM(name), 'Unknown') AS company_name,

    CASE
        WHEN country_name IN ('IND', 'India') THEN 'India'
        WHEN country_name IN ('USA', 'US') THEN 'USA'
        ELSE 'USA'
    END AS country_name,

    CASE
        WHEN "date" ~ '^\d{4}-\d{2}-\d{2}$'
            THEN TO_DATE("date", 'YYYY-MM-DD')

        WHEN "date" ~ '^\d{2}-\d{2}-\d{4}$'
            THEN TO_DATE("date", 'DD-MM-YYYY')

        ELSE DATE '1900-01-01'
    END AS join_date

FROM source
