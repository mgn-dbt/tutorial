with
source as (
    select * from {{ source('jaffle_shop', 'customers') }}
),

transformed as (
    select 

        id as customer_id,
        last_name as last_name, --surname,
        first_name as first_name, --givenname,
        upper(left(first_name, 1)) 
            || lower(right(first_name, length(first_name) -1)) 
            || ' '
            || upper(left(last_name, 1)) 
            || lower(right(last_name, length(last_name) -1)) 
            as full_name

    from source
)

select * from transformed