select
      o.order_id,
      o.product_id,
      o.quantity,
      o.amount,
      o.order_date,

      p.product_name,
      p.category,
      p.price,
      p.created_date,

      (o.quantity * o.amount) AS total_order_value

from {{ ref('silver_orders') }} o
join {{ ref('silver_products') }} p
on p.product_id = o.product_id