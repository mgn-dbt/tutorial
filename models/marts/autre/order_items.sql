with

order_items as (
    select * from {{ ref('stg_autre__order_items') }}
),

orders as (
    select * from {{ ref('stg_autre__orders') }}
),

products as (
    select * from {{ ref('stg_autre__products') }}
),

supplies as (
    select * from {{ ref('stg_autre__supplies') }}
),

order_supplies_summary as (
    select
        product_id,
        sum(supply_cost) as supply_cost
    from supplies
    group by 1
),

joined as (
    select
        order_items.*,
        products.product_price,
        order_supplies_summary.supply_cost,
        products.is_food_item,
        products.is_drink_item,
        orders.ordered_at,
        {{ dbt.date_trunc('day', 'orders.ordered_at') }} as ordered_at_day

    from order_items
    left join orders on order_items.order_id = orders.order_id
    left join products on order_items.product_id = products.product_id
    left join order_supplies_summary on order_items.product_id = order_supplies_summary.product_id
)

select * from joined
