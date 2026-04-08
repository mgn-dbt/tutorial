--dbt show -s orders_daily_summary
with
orders as (
    select * from {{ ref('stg_jaffle_shop__orders') }}
)

select
    customer_id,
    order_date,
    {{ dbt_utils.generate_surrogate_key(['customer_id', 'order_date']) }} as pk,
    count(*) as c
from orders
group by 1, 2
