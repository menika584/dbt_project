WITH transactions AS (

    SELECT *
    FROM {{ ref('stg_revenue_transactions') }}

)

SELECT
    product_id,
    COUNT(transaction_id) AS total_orders,
    SUM(quantity) AS total_quantity,
    SUM(discount) AS total_discount

FROM transactions

WHERE status = 'completed'

GROUP BY product_id