-- Final mart: full order summary with products and payment status
-- Uses the intermediate model + stg_orders + stg_payments

WITH order_details AS (
    SELECT * FROM {{ ref('int_order_details') }}
    -- ☝️ ref() the INTERMEDIATE model — not raw, not staging
),

orders AS (
    SELECT * FROM {{ ref('stg_orders') }}
),

payments AS (
    SELECT * FROM {{ ref('stg_payments') }}
),

-- Roll up items per order (one order can have many items)
items_per_order AS (
    SELECT
        order_id,
        COUNT(order_item_id)                AS total_items,
        SUM(line_total)                     AS items_total,
        STRING_AGG(product_name, ', ')      AS products_bought
    FROM order_details
    GROUP BY order_id
)

SELECT
    o.order_id,
    o.customer_id,
    o.order_date,
    o.status                            AS order_status,
    i.total_items,
    i.items_total,
    i.products_bought,
    p.payment_method,
    p.payment_amount,
    CASE
        WHEN p.payment_id IS NOT NULL THEN 'Paid'
        ELSE 'Unpaid'
    END                                 AS payment_status
FROM orders o
LEFT JOIN items_per_order i  ON o.order_id = i.order_id
LEFT JOIN payments p         ON o.order_id = p.order_id