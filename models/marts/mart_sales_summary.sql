WITH sales AS (

SELECT *
FROM {{ ref('stg_sales') }}

)

SELECT
city,
category,
COUNT(*) AS total_orders,
SUM(quantity) AS total_quantity,
SUM(total_amount) AS total_sales,
AVG(total_amount) AS avg_order_value

FROM sales

GROUP BY
city,
category
