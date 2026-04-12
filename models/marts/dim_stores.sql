{{
    config(
        materialized='table'
    )
}}

with source as (
    select * from {{ref('stg_coffee_sales')}}
),

dim_stores as (
    select distinct
    STORE_ID,
    store_location,
    md5(coalesce(cast(STORE_ID as string), '-1')) as store_key,
    store_location as store_name,
    case store_location
            when 'Astoria'          then 'Queens'
            when 'Lower Manhattan'  then 'Manhattan'
            when 'Hell''s Kitchen'  then 'Manhattan'
            else 'Unknown Borough'
    end as borough,
    current_timestamp() as dbt_created_at
    from source
)

select * from dim_stores