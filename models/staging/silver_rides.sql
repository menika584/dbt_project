WITH bronze AS (
    SELECT *
    FROM {{ ref('bronze_rides') }}
)

SELECT
    ride_id,
    CAST(user_id AS INT) AS user_id,
    CAST(driver_id AS INT) AS driver_id,
    CAST(fare AS INT) AS fare,
    city,
    status
FROM bronze
WHERE status = 'completed'