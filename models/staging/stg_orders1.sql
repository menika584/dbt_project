WITH src_orders AS (

    SELECT *
    FROM {{ source('menika', 'orders') }}

)

SELECT

    orderid AS order_id,

    COALESCE(custid, -1) AS customer_id,

    COALESCE(prodid, -1) AS product_id,

    COALESCE(sellid, -1) AS seller_id,

    CAST(orderdt AS DATE) AS order_date,

    CASE
        WHEN qty < 0 THEN 0
        ELSE qty
    END AS quantity,

    CASE
        WHEN price < 0 THEN 0
        ELSE price
    END AS product_price,

    CASE
        WHEN disc < 0 THEN 0
        ELSE disc
    END AS discount,

    CASE
        WHEN taxamt < 0 THEN 0
        ELSE taxamt
    END AS tax_amount,

    CASE
        WHEN shipcharge < 0 THEN 0
        ELSE shipcharge
    END AS shipping_charge,

    CASE
        WHEN totalamt < 0 THEN 0
        ELSE totalamt
    END AS total_amount,

    LOWER(TRIM(paymethod)) AS payment_method,

    LOWER(TRIM(paystatus)) AS payment_status,

    LOWER(TRIM(ordstatus)) AS order_status,

    TRIM(shipcity) AS ship_city,

    TRIM(shipstate) AS ship_state,

    TRIM(shipcountry) AS ship_country,

    CAST(deliverydt AS DATE) AS delivery_date,

    CAST(createddt AS TIMESTAMP) AS created_date,

    CAST(updateddt AS TIMESTAMP) AS updated_date

FROM src_orders