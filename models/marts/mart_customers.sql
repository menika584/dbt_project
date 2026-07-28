WITH customers AS (

    SELECT *
    FROM {{ ref('stg_customers') }}

)

SELECT

    customer_id,
    customer_name,
    city,
    signup_date

FROM customers