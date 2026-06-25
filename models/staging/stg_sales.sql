WITH source AS (

SELECT *
FROM {{ source('menika', 'raw_sales') }}

)

SELECT
      sale_id,
      customer_id,
      TRIM(product_name) AS product_name,
      UPPER(category) AS category,
      quantity,
      unit_price,
      quantity * unit_price AS total_amount,
      sale_date,
      city

FROM source
