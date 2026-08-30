WITH trip_details AS (

    SELECT *
    FROM {{ ref('int_trip_details') }}

)

SELECT
    trip_date,
    day_name,
    month_name,
    quarter,
    year,

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

    SUM(
        CASE
            WHEN ride_status = 'completed'
            THEN fare_amount
            ELSE 0
        END
    ) AS total_revenue,

    AVG(
        CASE
            WHEN ride_status = 'completed'
            THEN fare_amount
            ELSE NULL
        END
    ) AS average_fare,

    SUM(distance_km) AS total_distance_km

FROM trip_details

GROUP BY
    trip_date,
    day_name,
    month_name,
    quarter,
    year

ORDER BY trip_date