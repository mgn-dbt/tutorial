    select
        id as customer_id,
        first_name,
        last_name,
        upper(left(first_name, 1)) 
            || lower(right(first_name, length(first_name) -1)) 
            || ' '
            || upper(left(last_name, 1)) 
            || lower(right(last_name, length(last_name) -1)) 
        as full_name

    from {{ source('jaffle_shop', 'customers') }}

    