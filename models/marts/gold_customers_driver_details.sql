WITH customers AS (
    SELECT *
    FROM {{ ref('silver_customers') }}
),
drivers AS (
    SELECT *
    FROM {{ ref('silver_driver') }}
)
SELECT
    c.customer_id,
    c.customer_name,
    c.customer_email,
    c.city AS customer_city,
    c.start_time AS customer_start_time,
    d.driver_id,
    d.driver_name,
    d.city AS driver_city,
    d.rating AS driver_rating,
    d.end_time AS driver_end_time
FROM customers c
LEFT JOIN drivers d
    ON c.city = d.city
ORDER BY c.city, d.rating DESC