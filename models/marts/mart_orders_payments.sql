WITH orders AS (
    SELECT *
    FROM {{ ref('stg_orders') }}
),

payments AS (
    SELECT *
    FROM {{ ref('stg_payments') }}
)

SELECT
    o.order_id,
    o.cust_id,
    o.amount AS order_amount,
    o.order_status,
    o.order_date,
    p.payment_id,
    p.amount AS payment_amount,
    p.payment_method,
    p.payment_date
FROM orders o
LEFT JOIN payments p
    ON o.order_id = p.order_id