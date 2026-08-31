WITH trips AS (

    SELECT *
    FROM {{ ref('stg_fact_trip') }}

),

drivers AS (

    SELECT *
    FROM {{ ref('stg_dim_driver') }}

),

rides AS (

    SELECT *
    FROM {{ ref('stg_dim_ride') }}

),

pickup AS (

    SELECT *
    FROM {{ ref('stg_dim_location') }}

),

drop_loc AS (

    SELECT *
    FROM {{ ref('stg_dim_location') }}

),

dates AS (

    SELECT *
    FROM {{ ref('stg_dim_date') }}

)

SELECT

    t.trip_id,
    t.trip_date,
    d.driver_id,
    d.driver_name,
    d.vehicle_type,

    r.ride_type,
    r.ride_status,

    p.location_name AS pickup_location,
    dr.location_name AS drop_location,

    dt.day_name,
    dt.month_name,
    dt.quarter,
    dt.year,

    t.distance_km,
    t.duration_minutes,
    t.fare_amount,
    t.payment_method

FROM trips t

LEFT JOIN drivers d
       ON t.driver_id = d.driver_id

LEFT JOIN rides r
       ON t.ride_id = r.ride_id

LEFT JOIN pickup p
       ON t.pickup_location_id = p.location_id

LEFT JOIN drop_loc dr
       ON t.drop_location_id = dr.location_id

LEFT JOIN dates dt
       ON t.trip_date = dt.full_date