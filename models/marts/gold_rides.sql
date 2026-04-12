WITH silver AS (
    SELECT *
    FROM {{ ref('silver_rides') }}
)

SELECT
    city,
    COUNT(*) AS total_rides,
    SUM(fare) AS total_revenue,
    AVG(fare) AS avg_fare
FROM silver
GROUP BY city