WITH source AS (
    SELECT *
    FROM {{ source('menika', 'bronze_customers') }}
)
SELECT
    customer_id,
    customer_name,
    LOWER(COALESCE(email, 'noemail@example.com')) AS customer_email,
    CASE
        WHEN city IS NULL OR city = '' THEN 'Unknown'
        WHEN city = 'NY' THEN 'New York'
        ELSE city
    END AS city,
    COALESCE(start_time, CURRENT_TIMESTAMP) AS start_time
FROM source



