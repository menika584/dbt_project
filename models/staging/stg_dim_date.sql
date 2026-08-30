WITH source AS (
    SELECT *
    FROM {{ source('menika', 'dim_date') }}
)

SELECT
    date_id,
    full_date,
    day,
    month,
    TRIM(month_name) AS month_name,
    TRIM(quarter) AS quarter,
    year,
    TRIM(day_name) AS day_name
FROM source
WHERE date_id IS NOT NULL