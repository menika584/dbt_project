WITH company AS (
    SELECT *
    FROM {{ ref('silver_company') }}
),
employee AS (
    SELECT *
    FROM {{ ref('silver_employee') }}
)
select
     c.company_id,
     c.company_name,
     c.country_name,
     e.employee_id,
     e.employee_name,
     e.employee_salary,
     c.join_date AS company_join_date,
     e.join_date AS employee_join_date

FROM company c
join employee e
ON c.company_id = e.company_id