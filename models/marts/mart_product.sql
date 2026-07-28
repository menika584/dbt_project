WITH product AS (

    SELECT *
    FROM {{ ref('stg_product') }}

)

SELECT

    product_id,
    product_name,
    category,
    price

FROM product