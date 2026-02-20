with
customers as (
    select * from {{ ref('stg_jaffle_shop__customers') }}
),

orders as (
    select * from {{ ref('fct_orders') }}
),

employees as (
    select
        cast(employee_id as integer) as employee_id,
        email,
        cast(customer_id as integer) as customer_id
    from {{ ref('employees') }}
),

customer_orders as (
    select
        customer_id,
        min(order_date) as first_order_date,
        max(order_date) as most_recent_order_date,
        count(order_id) as number_of_orders,
        sum(amount) as lifetime_value

    from orders
    group by 1
),

final as (
    select
        customers.customer_id,
        customers.first_name,
        customers.last_name,
        customer_orders.first_order_date,
        customer_orders.most_recent_order_date,
        customer_orders.lifetime_value,
        employees.employee_id,
        coalesce(customer_orders.number_of_orders, 0) as number_of_orders

    from customers
    left join customer_orders on customers.customer_id = customer_orders.customer_id
    left join employees on customers.customer_id = employees.customer_id
)

select * from final
