WITH source AS (
    SELECT * FROM {{ source('menika', 'raw_courses') }}
)
SELECT
      course_id,
      course_name,
      LOWER(category) AS category,
      CAST(price AS DECIMAL(10,2)) AS price,
      CAST(created_at AS DATE) AS created_date
FROM source
