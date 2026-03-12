WITH source AS (
    SELECT * FROM {{ source('raw', 'payments') }}
)

SELECT
    id              AS payment_id,
    order_id,
    payment_date,
    payment_method,
    amount          AS payment_amount
FROM source