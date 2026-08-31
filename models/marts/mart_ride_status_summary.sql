WITH trip_details AS (

    SELECT *
    FROM {{ ref('int_trip_details') }}

)

SELECT
    ride_status,
    COUNT(trip_id) AS total_rides,
    SUM(fare_amount) AS total_revenue,
    AVG(
        CASE
            WHEN ride_status = 'completed'
            THEN fare_amount
            ELSE NULL
        END
    ) AS average_fare

FROM trip_details

GROUP BY ride_status
ORDER BY total_rides DESC