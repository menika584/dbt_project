WITH source AS (
    SELECT * FROM {{ source('menika', 'row_payments') }}
)
SELECT
      paymentid AS payment_id,
      orderid AS order_id,
      CASE
          WHEN amount < 0 THEN 0
          ELSE amount
      END AS amount,
      COALESCE(method, 'unknown') AS method,
      COALESCE(payment_date, CURRENT_DATE) AS payment_date
FROM source