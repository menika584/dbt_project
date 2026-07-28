WITH source AS (

    SELECT *
    FROM {{ source('menika', 'customers') }}

)

SELECT

    customer_id,
    INITCAP(TRIM(customer_name)) AS customer_name,
    INITCAP(TRIM(city)) AS city,
    signup_date

FROM source