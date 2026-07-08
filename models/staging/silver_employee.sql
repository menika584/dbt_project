WITH source AS (
    SELECT *
    FROM {{ source('menika', 'employee') }}
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

    CASE
        WHEN join_date ~ '^\d{4}-\d{2}-\d{2}$'
            THEN TO_DATE(join_date, 'YYYY-MM-DD')

        WHEN join_date ~ '^\d{2}-\d{2}-\d{4}$'
            THEN TO_DATE(join_date, 'DD-MM-YYYY')

        ELSE DATE '1900-01-01'
    END AS join_date

FROM source



