WITH source AS (
    SELECT *
    FROM {{ source('menika', 'fact_trip') }}
)

SELECT
       trip_id,
       ride_id,
       driver_id,
       pickup_location_id,
       drop_location_id,
       trip_date,
       distance_km,
       duration_minutes,
       fare_amount,
       LOWER(TRIM(payment_method)) AS payment_method
       FROM source
       WHERE trip_id IS NOT NULL