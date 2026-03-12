WITH customers AS (
    SELECT * FROM {{ ref('stg_customers') }}
    -- ☝️ ref() tells dbt: use the stg_customers model as input
),

orders AS (
    SELECT * FROM {{ ref('stg_orders') }}
),

order_summary AS (
    -- Count and sum orders per customer
    SELECT
        customer_id,
        COUNT(order_id)     AS total_orders,
        SUM(amount)         AS total_spent,
        MIN(order_date)     AS first_order_date,
        MAX(order_date)     AS latest_order_date
    FROM orders
    GROUP BY customer_id
)

SELECT
    c.customer_id,
    c.full_name,
    c.email,
    COALESCE(o.total_orders, 0)  AS total_orders,
    COALESCE(o.total_spent, 0)   AS total_spent,
    o.first_order_date,
    o.latest_order_date
FROM customers c
LEFT JOIN order_summary o ON c.customer_id = o.customer_id