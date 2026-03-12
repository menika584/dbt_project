-- Intermediate model: enrich order items with product info
-- Why? So the final mart doesn't need to do this join itself.

WITH order_items AS (
    SELECT * FROM {{ ref('stg_order_items') }}
    -- ☝️ ref() the staging model, not the raw table
),

products AS (
    SELECT * FROM {{ ref('stg_products') }}
)

SELECT
    oi.order_item_id,
    oi.order_id,
    oi.quantity,
    oi.unit_price,
    oi.line_total,
    p.product_id,
    p.product_name,
    p.category
FROM order_items oi
LEFT JOIN products p ON oi.product_id = p.product_id