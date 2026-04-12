WITH source AS (
    SELECT *
    FROM {{ source('menika', 'rides') }}
)

SELECT
    ride_id,
    data ->> 'user_id' AS user_id,
    data ->> 'driver_id' AS driver_id,
    data ->> 'fare' AS fare,
    LOWER(data ->> 'city') AS city,
    LOWER(data ->> 'status') AS status
FROM source