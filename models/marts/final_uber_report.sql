WITH trip_summary AS (

    SELECT *
    FROM {{ ref('mart_trip_summary') }}

)

SELECT
    total_trips,
    completed_trips,
    cancelled_trips,
    total_revenue,
    ROUND(average_fare, 2) AS average_fare,
    ROUND(total_distance_km, 2) AS total_distance_km,

    ROUND(
        (completed_trips::DECIMAL / NULLIF(total_trips, 0)) * 100,
        2
    ) AS completion_rate

FROM trip_summary