WITH source AS (
    SELECT * FROM {{ source('raw', 'orders') }}
)

SELECT
    id              AS order_id,
    customer_id,
    order_date,
    amount,
    UPPER(status)   AS status         -- make status uppercase (e.g. COMPLETED)
FROM source