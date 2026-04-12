{{
    config(
        materialized='table',
        description='Sales Per Category'
    )
}}

with product_sales as (
    select 
        date(transaction_timestamp) as sale_date,
        sal.store_key,
        store.store_name,
        store.borough,
        prd.product_group,
        count(*) as transaction_count,
        sum(quantity) as total_quantity_sold,
        round(sum(revenue), 2) as total_revenue,
        round(avg(revenue), 2) as avg_revenue_per_transaction
    from {{ref('fct_sales_transactions')}} sal
    left join {{ref('dim_products')}} prd 
        on sal.product_key=prd.product_key
    left join {{ref('dim_stores')}} store 
        on store.store_key=sal.store_key
    group by
        date(transaction_timestamp),
        sal.store_key,
        store.store_name,
        store.borough,
        prd.product_group
)

select * from product_sales