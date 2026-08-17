WITH product_revenue AS (

    SELECT *
    FROM {{ ref('int_product_revenue') }}

)

SELECT
    product_id,
    product_name,
    category,

    DATE_TRUNC('month', transaction_date)::DATE AS month,

    COUNT(DISTINCT transaction_id) AS total_orders,
    SUM(quantity) AS total_quantity,

    SUM(discount) AS total_discount,
    SUM(revenue) AS total_revenue,
    SUM(profit) AS total_profit

FROM product_revenue

GROUP BY
    product_id,
    product_name,
    category,
    DATE_TRUNC('month', transaction_date)::DATE