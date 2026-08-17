WITH source AS (

    SELECT *
    FROM {{ source('menika', 'revenue_transactions') }}

)

SELECT
    transaction_id,
    product_id,
    customer_id,
    CAST(transaction_date AS DATE) AS transaction_date,

    COALESCE(quantity, 0) AS quantity,

    COALESCE(discount, 0) AS discount,

    LOWER(TRIM(status)) AS status

FROM source

WHERE transaction_id IS NOT NULL
  AND product_id IS NOT NULL