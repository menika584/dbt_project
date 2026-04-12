select
      s.student_id,
      s.student_name,
      m.course_name
FROM{{ ref('stg_students') }} s
join {{ ref('mart_students_courses') }} m
ON s.course_id = m.course_id
