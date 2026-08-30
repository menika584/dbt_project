WITH trip_details AS (

    SELECT *
    FROM {{ ref('int_trip_details') }}

)

SELECT
    driver_id,
    driver_name,

    COUNT(trip_id) AS total_trips,

    SUM(
        CASE
            WHEN ride_status = 'completed' THEN 1
            ELSE 0
        END
    ) AS completed_trips,

    SUM(
        CASE
            WHEN ride_status = 'cancelled' THEN 1
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
    ) AS avg_fare,

    SUM(distance_km) AS total_distance

FROM trip_details

GROUP BY
    driver_id,
    driver_name