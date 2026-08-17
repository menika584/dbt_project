WITH transactions AS (

    SELECT *
    FROM {{ ref('stg_revenue_transactions') }}

),

products AS (

    SELECT *
    FROM {{ ref('stg_revenue_products') }}

),

joined_data AS (

    SELECT
        t.transaction_id,
        t.product_id,
        p.product_name,
        p.category,
        t.transaction_date,
        t.quantity,
        p.product_price,
        p.cost_price,
        t.discount,
        t.status,

        (p.product_price * t.quantity) - t.discount AS revenue,

        ((p.product_price * t.quantity) - t.discount)
            - (p.cost_price * t.quantity) AS profit

    FROM transactions t

    INNER JOIN products p
        ON t.product_id = p.product_id

    WHERE t.status = 'completed'

)

SELECT
    transaction_id,
    product_id,
    product_name,
    category,
    transaction_date,
    quantity,
    product_price,
    cost_price,
    discount,
    revenue,
    profit

FROM joined_data