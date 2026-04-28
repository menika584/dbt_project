WITH src_payments AS (
    SELECT *
    FROM {{ source('public', 'payments') }}
)

SELECT
    paymentid AS payment_id,
    orderid AS order_id,
    CASE
        WHEN amount < 0 THEN 0
        ELSE amount
    END AS amount,
    LOWER(COALESCE(method, 'unknown')) AS payment_method,
    CAST(COALESCE(payment_date, CURRENT_DATE) AS DATE) AS payment_date
FROM src_payments