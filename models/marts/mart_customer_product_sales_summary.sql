WITH customers AS (

    SELECT *
    FROM {{ ref('mart_customers') }}

),

products AS (

    SELECT *
    FROM {{ ref('mart_product') }}

),

sales AS (

    SELECT *
    FROM {{ ref('mart_sales') }}

)

SELECT

    s.sale_id,

    c.customer_id,
    c.customer_name,
    c.city,

    p.product_id,
    p.product_name,
    p.category,
    p.price,

    s.quantity,
    s.sale_date,

    (s.quantity * p.price) AS total_amount

FROM sales s

LEFT JOIN customers c
    ON s.customer_id = c.customer_id

LEFT JOIN products p
    ON s.product_id = p.product_id