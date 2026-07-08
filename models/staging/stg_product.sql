WITH src_product AS (
    SELECT *
    FROM {{ source('menika', 'product') }}
)

SELECT
      product_id,
      item_name,
      category
FROM src_product