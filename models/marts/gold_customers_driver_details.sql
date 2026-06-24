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
 d.driver_id,
 d.driver_name,
 d.city AS driver_city,
 d.rating
 FROM customers c
 LEFT JOIN drivers d
 ON c.city = d.city
