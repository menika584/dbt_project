WITH src_product AS (

    SELECT *
    FROM {{ source('menika', 'raw_product') }}

)

SELECT

    prodid AS product_id,

    TRIM(prodname) AS product_name,

    UPPER(TRIM(cat)) AS category,

    TRIM(brandnm) AS brand_name,

    COALESCE(suppid, -1) AS supplier_id,

    CASE
        WHEN prodprice <= 0 THEN 1
        ELSE prodprice
    END AS product_price,

    CASE
        WHEN costprice < 0 THEN 0
        ELSE costprice
    END AS cost_price,

    CASE
        WHEN stockqty < 0 THEN 0
        ELSE stockqty
    END AS stock_quantity,

    CAST(proddt AS DATE) AS product_date,

    LOWER(TRIM(prodstatus)) AS product_status,

    TRIM(clr) AS color,

    wt AS weight,

    warranty_months,

    CAST(createddt AS TIMESTAMP) AS created_date,

    CAST(updateddt AS TIMESTAMP) AS updated_date

FROM src_product