WITH source AS (
    SELECT *
    FROM {{ source('menika', 'bronze_orders') }}
),

typed AS (
    SELECT *,
        CASE
            WHEN id ~ '^[0-9]+$' THEN CAST(id AS INT)
            ELSE NULL
        END AS raw_order_id,

        CASE
            WHEN product_id ~ '^[0-9]+$' THEN CAST(product_id AS INT)
            ELSE NULL
        END AS raw_product_id,

        CASE
            WHEN quantity ~ '^[0-9]+$' THEN CAST(quantity AS INT)
            ELSE NULL
        END AS raw_quantity,

        CASE
            WHEN amount ~ '^[0-9]+$' THEN CAST(amount AS INT)
            ELSE NULL
        END AS raw_amount,

        CAST(order_date AS DATE) AS raw_order_date

    FROM source
),

cleaned AS (
    SELECT
        raw_order_id AS order_id,
        raw_product_id AS product_id,

        CASE
            WHEN raw_quantity > 0 THEN raw_quantity
            ELSE NULL
        END AS quantity,

        CASE
            WHEN raw_amount > 0 THEN raw_amount
            ELSE NULL
        END AS amount,

        raw_order_date AS order_date

    FROM typed
)

SELECT *
FROM cleaned
WHERE order_id IS NOT NULL
  AND product_id IS NOT NULL


