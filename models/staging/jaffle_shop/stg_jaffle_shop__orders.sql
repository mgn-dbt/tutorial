with 
source as (
    select * from {{ source('jaffle_shop', 'orders') }}
),

transformed as (
    select
        id as order_id,
        user_id as customer_id,
        order_date,
        date_diff( date({{ my_current_timestamp() }}), order_date, DAY ) as days_since_ordered,
        case 
            when status like '%shipped%' then 'shipped'
            when status like '%return%' then 'returned'
            when status like '%pending%' then 'placed'
            else status
        end as order_status
    from source
)

select * from transformed