WITH source AS (
    SELECT * FROM {{ source('raw', 'order_items') }}
)

SELECT
    id          AS order_item_id,
    order_id,
    product_id,
    quantity,
    unit_price,
    quantity * unit_price   AS line_total   -- calculate line total
FROM source