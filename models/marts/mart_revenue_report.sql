WITH revenue AS (

    SELECT *
    FROM {{ ref('int_revenue_transactions') }}

)

SELECT
    product_id,
    total_orders,
    total_quantity,
    total_discount

FROM revenue