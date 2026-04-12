WITH source AS (
    SELECT *
    FROM {{ source('menika', 'bronze_products') }}
),
cleaned AS (
SELECT
      CASE
          WHEN id ~ '^[0-9]+$' THEN CAST(id AS INT)
          ELSE NULL
      END AS product_id,
      NULLIF(TRIM(name), '') AS product_name,
      CASE
          WHEN category IS NULL THEN 'UNKNOWN'
          ELSE UPPER(TRIM(category))
      END AS category,
      CASE
          WHEN price ~ '^[0-9]+$' AND CAST(price AS INT) > 0
               THEN CAST(price AS INT)
          ELSE NULL
      END AS price,
      CAST(created_date AS DATE) AS created_date
from source
)
SELECT *
FROM cleaned
WHERE product_id IS NOT NULL