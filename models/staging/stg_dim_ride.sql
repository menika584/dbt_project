WITH source AS (
    SELECT *
    FROM {{ source('menika', 'dim_ride') }}
)

SELECT
    ride_id,
    TRIM(ride_type) AS ride_type,
    LOWER(TRIM(ride_status)) AS ride_status,
    booking_time,
    TRIM(cancelled_by) AS cancelled_by,
    TRIM(cancel_reason) AS cancel_reason
FROM source
WHERE ride_id IS NOT NULL