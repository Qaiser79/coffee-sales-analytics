{{
    config(
        materialized='table',
        description='Top selling products'
    )
}}

with top_products as (
    select
        -- Product dimension
        prd.product_key,
        prd.product_id,
        prd.product_category,
        prd.product_type,
        prd.product_detail,
        prd.product_group,

        -- Aggregated measures
        count(*) as transaction_count,
        sum(sal.quantity) as total_quantity_sold,
        round(sum(sal.revenue), 2) as total_revenue,
        round(avg(sal.revenue), 2) as avg_revenue_per_transaction,

        -- Additional useful metrics
        min(date(sal.transaction_timestamp)) as first_sale_date,
        max(date(sal.transaction_timestamp)) as last_sale_date,

        -- Ranking (highest revenue = rank 1)
        row_number() over (order by sum(sal.revenue) desc) as revenue_rank,
        row_number() over (order by sum(sal.quantity) desc) as quantity_rank
    from {{ref('fct_sales_transactions')}} sal
    left join {{ ref('dim_products') }} prd
        on sal.product_key = prd.product_key

    group by
        prd.product_key,
        prd.product_id,
        prd.product_category,
        prd.product_type,
        prd.product_detail,
        prd.product_group
)

select
    *,
    current_timestamp() as dbt_last_updated
from top_products