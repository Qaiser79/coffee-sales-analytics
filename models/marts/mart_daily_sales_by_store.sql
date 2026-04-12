{{
    config(
        materialized='table',
        description='Daily Sales Summary'
    )
}}

with daily_sales as(

    select date(transaction_timestamp) as sale_date,

        -- Store dimension
        fct.store_key,
        dim.store_name,           -- from dim_stores
        borough,              -- from dim_stores

        -- Measures (aggregated)
        count(*) as transaction_count,
        sum(quantity) as total_quantity_sold,
        round(sum(revenue), 2) as total_revenue,
        round(avg(revenue), 2) as avg_revenue_per_transaction,

        -- Useful flags / counts
        sum(case when is_weekend then 1 else 0 end) as weekend_transaction_count,
        min(sale_hour) as earliest_sale_hour,
        max(sale_hour) as latest_sale_hour,

        -- For quick ranking later
        row_number() over (
            partition by date(transaction_timestamp)
            order by sum(revenue) desc
        ) as daily_revenue_rank

        from {{ref('fct_sales_transactions')}} fct 
        left join {{ ref('dim_stores') }} dim
        on fct.store_key = dim.store_key

        group by
        date(transaction_timestamp),
        fct.store_key,
        store_name,
        borough
)

select * from daily_sales