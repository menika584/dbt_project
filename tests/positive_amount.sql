-- Test: Order amounts should always be positive
SELECT *
FROM {{ ref('stg_orders') }}
WHERE amount <= 0

