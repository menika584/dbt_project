WITH src_order_history AS (

    SELECT *
    FROM {{ source('menika', 'order_history') }}

)

SELECT

    histid AS history_id,

    ordid AS order_id,

    COALESCE(buyerid, -1) AS buyer_id,

    COALESCE(sellerid, -1) AS seller_id,

    CASE
        WHEN TRIM(oldstatus) = '' THEN 'unknown'
        ELSE LOWER(TRIM(oldstatus))
    END AS old_status,

    CASE
        WHEN TRIM(newstatus) = '' THEN 'unknown'
        ELSE LOWER(TRIM(newstatus))
    END AS new_status,

    CAST(changedt AS TIMESTAMP) AS change_date,

    TRIM(changedby) AS changed_by,

    COALESCE(TRIM(remarks), 'No Remarks') AS remarks,

    CAST(createddt AS TIMESTAMP) AS created_date

FROM src_order_history