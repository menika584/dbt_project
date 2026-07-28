WITH sales AS (

    SELECT *
    FROM {{ ref('stg_sales') }}

),

product AS (

    SELECT *
    FROM {{ ref('stg_product') }}

),

customers AS (

    SELECT *
    FROM {{ ref('stg_customers') }}

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

LEFT JOIN product p
    ON s.product_id = p.product_id

LEFT JOIN customers c
    ON s.customer_id = c.customer_id