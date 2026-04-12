select
      c.customer_id,
      c.customer_name,
      c.customer_email,
      c. city,
      c.created_date,
      o.order_id,
      o.amount as order_amount,
      o.status as order_status,
      o.order_date,
      p.payment_id,
      p.amount as payment_amount,
      p.method as payment_method,
      p.payment_date
from {{ ref('stg_customers') }} c
left join {{ ref('stg_orders') }} o
on c.customer_id = o.customer_id
left join {{ ref('stg_payments') }} p
ON o.order_id = p.order_id