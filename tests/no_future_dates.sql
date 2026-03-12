-- Test: Order dates should not be in the future
SELECT *
FROM {{ ref('stg_orders') }}
WHERE order_date > CURRENT_DATE

