with
source as (
    select * from {{ source('jaffle_shop', 'customers') }}
),

transformed as (
    select
        id as customer_id,
        last_name, --surname,
        first_name, --givenname,

        initcap({{ dbt.concat(["first_name", "' '", "last_name"]) }}) as full_name

    from source
)

select * from transformed
