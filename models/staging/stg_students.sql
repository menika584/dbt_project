WITH src_students AS (
    SELECT * FROM {{ source('menika', 'students') }}
)
SELECT
      student_id,
      name AS student_name,
      LOWER(email) AS student_email,
      age,
      course_id,
      CAST(created_at AS DATE) AS created_date
FROM src_students

