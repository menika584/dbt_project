-- Example 3: Build a new model by referencing existing models + one raw table
-- Question: Which product category earns the most? Who buys from each category?

WITH order_summary AS (
    -- ✅ ref() an already-built mart model from Example 2
    SELECT * FROM {{ ref('mart_order_summary') }}
),

customer_orders AS (
    -- ✅ ref() an already-built mart model from Example 1
    SELECT * FROM {{ ref('mart_customer_orders') }}
),

products AS (
    -- ✅ source() a raw table directly — we just need the category column
    SELECT * FROM {{ source('raw', 'products') }}
),

-- Step 1: Join order_summary with products to tag each order with a category
orders_with_category AS (
    SELECT
        os.order_id,
        os.customer_id,
        os.order_date,
        os.order_status,
        os.items_total,
        os.payment_status,
        p.category
    FROM order_summary os
    -- Use LIKE to match product names back to the products table
    -- (order_summary already has products_bought as a text column)
    LEFT JOIN products p
        ON os.products_bought LIKE '%' || p.name || '%'
),

-- Step 2: Group by category to calculate revenue totals
category_summary AS (
    SELECT
        category,
        COUNT(DISTINCT order_id)        AS total_orders,
        SUM(items_total)                AS total_revenue,
        COUNT(DISTINCT customer_id)     AS unique_customers
    FROM orders_with_category
    WHERE order_status = 'COMPLETED'      -- only count completed orders
    GROUP BY category
)

-- Step 3: Final select — attach the top customer name per category
SELECT
    cs.category,
    cs.total_orders,
    cs.total_revenue,
    cs.unique_customers,
    -- Pull in a sample customer name from customer_orders model (Example 1)
    (
        SELECT co.full_name
        FROM customer_orders co
        WHERE co.customer_id = (
            SELECT owc.customer_id
            FROM orders_with_category owc
            WHERE owc.category = cs.category
              AND owc.order_status = 'COMPLETED'
            ORDER BY owc.items_total DESC
            LIMIT 1
        )
    )                                   AS top_customer_name
FROM category_summary cs
ORDER BY cs.total_revenue DESC