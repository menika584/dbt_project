WITH source AS (
    SELECT *
    FROM {{ source('menika', 'row_orders') }}
)
SELECT
    orderid AS order_id,
    custid AS customer_id,
    CASE WHEN amount < 0 THEN 0 ELSE amount END AS amount,
    LOWER(status) AS status,
    order_date
FROM (
    SELECT *,
           ROW_NUMBER() OVER(PARTITION BY orderid ORDER BY order_date DESC) AS rn
    FROM source
    WHERE custid IS NOT NULL
) t
WHERE rn = 1
