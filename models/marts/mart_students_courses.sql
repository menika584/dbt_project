SELECT
    s.student_id,
    s.student_name,
    c.course_id,
    c.course_name
FROM {{ ref('stg_students') }} s
JOIN {{ ref('stg_courses') }} c
    ON s.course_id = c.course_id