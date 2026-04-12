WITH source AS (
    SELECT *
    FROM {{ source('menika', 'bronze_employee') }}
)

SELECT
    CASE
        WHEN id ~ '^[0-9]+$' THEN CAST(id AS INT)
        ELSE NULL
    END AS employee_id,

    COALESCE(TRIM(name), 'Unknown') AS employee_name,

    CASE
        WHEN comp_id ~ '^[0-9]+$' THEN CAST(comp_id AS INT)
        ELSE NULL
    END AS company_id,

    CASE
        WHEN sal ~ '^[0-9]+$' THEN CAST(sal AS INT)
        ELSE NULL
    END AS employee_salary,

         COALESCE(
             TO_DATE(NULLIF("join_date", ''), 'YYYY-MM-YYYY'),
             TO_DATE("join_date", 'DD-MM-YYYY'),
             CAST('1900-01-01' AS DATE)
         ) AS join_date


FROM source



