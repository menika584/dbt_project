select
 c.customer_id,
 c.customer_name,
 c.created_date
from {{ ref('stg_customers') }} c

