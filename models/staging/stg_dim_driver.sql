WITH source AS (
    SELECT *
    FROM {{ source('menika', 'dim_driver') }}
)

SELECT
    driver_id,
    TRIM(driver_name) AS driver_name,
    TRIM(vehicle_type) AS vehicle_type,
    UPPER(TRIM(vehicle_number)) AS vehicle_number,
    driver_rating,
    join_date,
    TRIM(city) AS city
FROM source
WHERE driver_id IS NOT NULL