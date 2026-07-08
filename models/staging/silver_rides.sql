WITH bronze AS (
    SELECT *
    FROM {{ ref('bronze_rides') }}
)

SELECT
     ride_id,
     user_id,
     driver_id,
     CAST(fare AS INT) AS fare,
     city,
     status
FROM bronze
WHERE status = 'completed'
