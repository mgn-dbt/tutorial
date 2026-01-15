with 
source as (
    select * from {{ source('stripe', 'payment') }}
),

transformed as (
    select 
        id as payment_id,
        orderid as order_id,
        paymentmethod as payment_method,
        status as payment_status,
        {{ cents_to_dollars('amount', 4) }} as amount,
        created as payment_created_at,
        _batched_at
    from source
)

select * from transformed