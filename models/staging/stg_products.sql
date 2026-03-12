WITH source AS (
    SELECT * FROM {{ source('raw', 'products') }}
)

SELECT
    id          AS product_id,
    name        AS product_name,
    category,
    price       AS list_price
FROM source