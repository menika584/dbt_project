WITH product_revenue AS (

    SELECT *
    FROM {{ ref('mart_product_revenue') }}

)

SELECT

    product_name,

    product_price,

    product_order_count,

    month,

    total_revenue,

    profit

FROM product_revenue

ORDER BY

    month,
    product_name