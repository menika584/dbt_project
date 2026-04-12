select
    c.customer_id,
    c.customer_name,
    c.customer_email,
    c.city,
    c.created_date,
    o.order_id,
    o.amount as order_amount,
    o.status as order_status,
    o.order_date
from {{ ref('stg_customers') }} c
left join {{ ref('stg_orders') }} o
    on c.customer_id = o.customer_id