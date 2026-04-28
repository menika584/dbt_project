WITH src_orders AS (
    SELECT *
    FROM {{ source('public', 'orders') }}
)

SELECT
    orderid AS order_id,
    COALESCE(custid, -1) AS cust_id,
    CASE
        WHEN amount < 0 THEN 0
        ELSE amount
    END AS amount,
    CASE
        WHEN LOWER(status) IN ('completed', 'pending', 'shipped')
            THEN LOWER(status)
        ELSE 'unknown'
    END AS order_status,
    CAST(order_date AS DATE) AS order_date
FROM src_orders