WITH src_sales AS (
    SELECT *
    FROM {{ source('menika', 'sales') }}
)

SELECT
       sale_id,
       product_id,
       quantity,
       unit_price,
       quantity * unit_price AS total_sale,
       sale_date
FROM src_sales