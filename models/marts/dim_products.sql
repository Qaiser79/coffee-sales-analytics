{{
    config(
        materialized='table'
    )
}}

with source as (
    select * from {{ref('stg_coffee_sales')}}
),
dim_products as(
    select 
        distinct
        product_id,
        product_category,
        product_type,
        product_detail,
        md5(cast(coalesce(product_id, -1) as string)) as product_key,
        case 
            when product_category ilike '%coffee%' or product_category ilike '%tea%' 
                then 'Beverage'
            when product_category ilike '%food%' or product_category ilike '%pastry%' or product_category ilike '%snack%'
                then 'Food'
            else 'Other'
        end as product_group,
        current_timestamp() as dbt_created_at
        from source
)
select * from dim_products