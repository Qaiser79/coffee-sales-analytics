{{
    config(
        materialized='table'
    )
}}

with fct_sales as (
    select 
        p.product_key,
        s.store_key,
        stg.transaction_id,
        stg.transaction_timestamp,
        stg.transaction_date,
        stg.transaction_time,
        stg.day_of_week,
        stg.day_name,
        stg.month_name,
        stg.sale_year,
        stg.sale_hour,
        stg.quantity,
        stg.unit_price,
        stg.revenue,
        case when stg.day_of_week in (0, 6) then true else false end as is_weekend,
        case 
            when stg.sale_hour between 7 and 11 then 'Morning'
            when stg.sale_hour between 12 and 16 then 'Afternoon'
            when stg.sale_hour between 17 and 20 then 'Evening'
            else 'Night'
        end as time_of_day,

        current_timestamp() as dbt_created_at

        from {{ ref('stg_coffee_sales') }} stg

        left join {{ ref('dim_products') }} p
            on stg.product_id = p.product_id
        left join {{ ref('dim_stores') }} s
            on stg.store_id = s.store_id
)

select * from fct_sales