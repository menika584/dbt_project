select
s.student_id,
s.student_name,
c.course_id,
c.course_name
from {{ ref('stg_students') }} s
join {{ ref('stg_courses') }} c
on s.course_id = c.course_id