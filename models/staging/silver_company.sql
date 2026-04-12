WITH source AS (
    SELECT *
    FROM {{ source('menika', 'bronze_company') }}
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
        ELSE 'Other'
    END AS country_name,


     COALESCE(
            TO_DATE("date", 'YYYY-MM-DD'),
            TO_DATE("date", 'DD-MM-YYYY'),
            CAST('1900-01-01' AS DATE)
        ) AS join_date

FROM source
