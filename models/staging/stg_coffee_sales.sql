{{

    config(
        materialized='table',
        schema='staging',
        alias='stg_coffee_sales'
    )

}}

with dump as(
    select * from {{source('coffee_raw','src_coffee_sales')}}
),
cleaned as(
    select 
    ---ids
      try_to_number(transaction_id) as transaction_id,
      try_to_number(store_id) as store_id,
      try_to_number(product_id) as product_id,
    ---date time
       to_date(transaction_date, 'MM/DD/YY') as transaction_date,
       to_time(transaction_time, 'HH24:MI:SS') as transaction_time,

    --measures
      try_to_number(transaction_qty) as quantity,
      try_to_decimal(unit_price,10, 2) as unit_price,
      --descriptive fields
      store_location,
      product_category,
      product_type,
      product_detail,
      ---derived
      transaction_qty*unit_price as revenue,
      to_timestamp(
        transaction_date||' '||transaction_time,
        'MM/DD/YY HH24:MI:SS'
      ) as transaction_timestamp,
      ---useful time related fields
      dayofweek(to_date(transaction_date, 'MM/DD/YY')) as day_of_week,
      dayname(to_date(transaction_date, 'MM/DD/YY')) as day_name,
      monthname(to_date(transaction_date, 'MM/DD/YY')) as month_name,
      year(to_date(transaction_date, 'MM/DD/YY')) as sale_year,
      hour(to_time(transaction_time, 'HH24:MI:SS')) as sale_hour

      from dump
       where transaction_id is not null
       and quantity > 0
)

select * from cleaned