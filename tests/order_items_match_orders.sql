-- Test: All order items must have a corresponding order
SELECT oi.*
FROM {{ ref('stg_order_items') }} oi
LEFT JOIN {{ ref('stg_orders') }} o ON oi.order_id = o.order_id
WHERE o.order_id IS NULL

