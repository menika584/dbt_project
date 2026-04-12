WITH source AS (
    SELECT * FROM {{ source('menika', 'raw_customers') }}
)
SELECT
      custid as customer_id,
      COALESCE(custname, 'unknown') AS customer_name,  -- NULL fix
      LOWER(email) AS customer_email,
      LOWER(city) AS city,
      CAST(created_at AS DATE) AS created_date
FROM source
WHERE custid IS NOT NULL
