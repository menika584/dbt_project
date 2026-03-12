WITH source AS (
    SELECT * FROM {{ source('raw', 'customers') }}
    -- ☝️ source() tells dbt: read from the raw schema, customers table
)

SELECT
    id              AS customer_id,   -- rename id → customer_id (clearer)
    first_name,
    last_name,
    first_name || ' ' || last_name  AS full_name,  -- combine into one column
    LOWER(email)    AS email,          -- make email lowercase
    created_at
FROM source