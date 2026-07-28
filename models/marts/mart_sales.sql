WITH sales AS (

    SELECT *
    FROM {{ ref('stg_sales') }}

)

SELECT

    sale_id,
    customer_id,
    product_id,
    quantity,
    sale_date

FROM sales