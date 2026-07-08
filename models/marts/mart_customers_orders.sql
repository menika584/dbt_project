SELECT
    c.customer_id,
    c.customer_name,
    c.customer_email,
    c.city,
    c.created_date,

    o.order_id,
    o.amount AS order_amount,
    o.order_status,
    o.order_date

FROM {{ ref('stg_customers') }} c

LEFT JOIN {{ ref('stg_orders') }} o
    ON c.customer_id = o.cust_id