WITH src_courses AS (
    SELECT *
    FROM {{ source('public', 'courses') }}
)

SELECT
    course_id,
    course_name,
    LOWER(COALESCE(category, 'unknown')) AS category,
    CAST(price AS DECIMAL(10,2)) AS price,
    CAST(created_at AS DATE) AS created_date
FROM src_courses
