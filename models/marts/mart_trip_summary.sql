WITH trip_details AS (

    SELECT *
    FROM {{ ref('int_trip_details') }}

)

SELECT
    COUNT(trip_id) AS total_trips,

    SUM(
        CASE
            WHEN ride_status = 'completed'
            THEN 1
            ELSE 0
        END
    ) AS completed_trips,

    SUM(
        CASE
            WHEN ride_status = 'cancelled'
            THEN 1
            ELSE 0
        END
    ) AS cancelled_trips,

    SUM(fare_amount) AS total_revenue,

    AVG(
        CASE
            WHEN ride_status = 'completed'
            THEN fare_amount
            ELSE NULL
        END
    ) AS average_fare,

    SUM(distance_km) AS total_distance_km,

    SUM(duration_minutes) AS total_duration_minutes

FROM trip_details