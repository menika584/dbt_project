WITH source AS (

    SELECT *
    FROM {{ source('menika', 'revenue_products') }}

),

cleaned AS (

    SELECT
        product_id,
        TRIM(product_name) AS product_name,
        LOWER(TRIM(category)) AS category,
        COALESCE(product_price, 0) AS product_price,
        COALESCE(cost_price, 0) AS cost_price,

        ROW_NUMBER() OVER (
            PARTITION BY product_id
            ORDER BY product_id
        ) AS row_num

    FROM source

)

SELECT
    product_id,
    product_name,
    category,
    product_price,
    cost_price

FROM cleaned

WHERE row_num = 1
  AND product_id IS NOT NULL
  AND product_name IS NOT NULL