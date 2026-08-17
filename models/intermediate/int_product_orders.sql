WITH orders AS (

    SELECT *
    FROM {{ ref('stg_orders1') }}

),

products AS (

    SELECT *
    FROM {{ ref('stg_product1') }}

)

SELECT

    o.order_id,

    o.customer_id,

    o.product_id,

    p.product_name,

    p.category,

    p.brand_name,

    p.product_price,

    p.cost_price,

    o.quantity,

    o.order_date,

    DATE_TRUNC('month', o.order_date) AS month,

    (o.quantity * p.product_price) AS revenue,

    (o.quantity * (p.product_price - p.cost_price)) AS profit

FROM orders o

INNER JOIN products p
    ON o.product_id = p.product_id