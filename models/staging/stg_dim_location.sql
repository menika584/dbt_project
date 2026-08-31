WITH source AS (
    SELECT *
    FROM {{ source('menika', 'dim_location') }}
)

SELECT
    location_id,
    TRIM(location_name) AS location_name,
    TRIM(city) AS city,
    TRIM(state) AS state,
    TRIM(zone) AS zone
FROM source
WHERE location_id IS NOT NULL