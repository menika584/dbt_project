WITH bronze AS (
    SELECT *
    FROM {{ ref('bronze_rides') }}
),
silver AS (
    SELECT *
    FROM {{ ref('silver_rides') }}
)

SELECT
    s.ride_id,
    s.driver_id,
    s.fare,
    s.city,
    s.status,
    b.user_id,
    b.fare AS bronze_fare,
    b.city AS bronze_city,
    b.status AS bronze_status
FROM silver s
LEFT JOIN bronze b
    ON s.ride_id = b.ride_id
