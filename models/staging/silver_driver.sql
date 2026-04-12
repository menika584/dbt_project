WITH source AS (
    SELECT *
    FROM {{ source('menika', 'bronze_driver') }}
)
SELECT
    driver_id,
    driver_name,
    CASE
        WHEN city IS NULL OR city = '' THEN 'Unknown'
        WHEN city = 'NY' THEN 'New York'
        ELSE city
    END AS city,
    CASE
        WHEN LOWER(rating) = 'five' THEN 5
        ELSE CAST(rating AS FLOAT)
    END AS rating,
    COALESCE(end_time, CURRENT_TIMESTAMP) AS end_time
FROM source

