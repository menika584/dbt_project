WITH product_sales AS (

    SELECT *
    FROM {{ ref('int_product_sales') }}

)
select
      item_name,
          SUM(quantity) AS sales_quantity,

          SUM(
              CASE
                  WHEN sale_date = '2026-06-27'
                  THEN total_sale
                  ELSE 0
              END
          ) AS daily_total_sales,

          SUM(
              CASE
                  WHEN sale_date BETWEEN '2026-04-01' AND '2026-06-30'
                  THEN total_sale
                  ELSE 0
              END
          ) AS quarterly_total_sales

      FROM product_sales

      GROUP BY item_name