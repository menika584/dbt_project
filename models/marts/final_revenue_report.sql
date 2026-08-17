WITH transaction_summary AS (

    SELECT *
    FROM {{ ref('int_revenue_transactions') }}

),

product_revenue AS (

    SELECT *
    FROM {{ ref('mart_revenue_report2') }}

)

SELECT
    p.product_id,
    p.product_name,
    p.category,
    p.month,

    p.total_orders,
    p.total_quantity,
    p.total_discount,
    p.total_revenue,
    p.total_profit

FROM product_revenue p

LEFT JOIN transaction_summary t
    ON p.product_id = t.product_id