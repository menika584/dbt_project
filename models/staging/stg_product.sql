WITH source AS (

    SELECT *
    FROM {{ source('menika', 'product') }}

)

SELECT

    product_id,
    INITCAP(TRIM(product_name)) AS product_name,
    INITCAP(TRIM(category)) AS category,
    price

FROM source