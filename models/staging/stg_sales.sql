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
      CASE
          WHEN quantity * unit_price < 0 THEN 0
          ELSE quantity * unit_price
      END AS total_amount,
      sale_date,
      city

FROM source
