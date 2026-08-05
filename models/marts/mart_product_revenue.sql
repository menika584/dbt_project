WITH product_orders AS (

    SELECT *
    FROM {{ ref('int_product_orders') }}

)

SELECT

    product_id,

    product_name,

    product_price,

    month,

    COUNT(order_id) AS product_order_count,

    SUM(revenue) AS total_revenue,

    SUM(profit) AS profit

FROM product_orders

GROUP BY

    product_id,
    product_name,
    product_price,
    month

ORDER BY

    month,
    product_name