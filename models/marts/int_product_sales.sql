WITH product AS (

    SELECT *
    FROM {{ ref('stg_product') }}

),

sales AS (

    SELECT *
    FROM {{ ref('stg_sales_new') }}

)

SELECT
    p.product_id,
    p.item_name,
    p.category,
    s.sale_id,
    s.quantity,
    s.unit_price,
    s.total_sale,
    s.sale_date

FROM product p
JOIN sales s
ON p.product_id = s.product_id