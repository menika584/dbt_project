WITH products AS (

    SELECT *
    FROM {{ ref('stg_product') }}

),

sales AS (

    SELECT *
    FROM {{ ref('stg_sales_new') }}

),
orders AS (

    SELECT *
    FROM {{ ref('silver_orders') }}

)

SELECT
    p.product_id,
    p.item_name,
    p.category,

    COUNT(DISTINCT s.sale_id) AS total_sales,

    COALESCE(SUM(s.quantity), 0) AS total_sales_quantity,

    COUNT(DISTINCT o.order_id) AS total_orders,

    COALESCE(SUM(o.quantity), 0) AS total_order_quantity,

    COALESCE(SUM(o.amount), 0) AS total_order_amount

FROM products p

LEFT JOIN sales s
    ON p.product_id = s.product_id

LEFT JOIN orders o
    ON p.product_id = o.product_id

GROUP BY
    p.product_id,
    p.item_name,
    p.category

ORDER BY
    total_order_amount DESC