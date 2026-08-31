WITH driver_performance AS (

    SELECT *
    FROM {{ ref('int_driver_performance') }}

)

SELECT
    driver_id,
    driver_name,
    total_trips,
    completed_trips,
    cancelled_trips,
    total_revenue,
    avg_fare,
    total_distance,

    ROUND(
        (completed_trips::DECIMAL / NULLIF(total_trips, 0)) * 100,
        2
    ) AS completion_rate,

    RANK() OVER (
        ORDER BY total_revenue DESC
    ) AS driver_rank

FROM driver_performance