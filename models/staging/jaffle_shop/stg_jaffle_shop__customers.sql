with
source as (
    select * from {{ source('jaffle_shop', 'customers') }}
),

transformed as (
    select
        id as customer_id,
        last_name,
        first_name,
        {%- set chaine = dbt.concat(["first_name", "' '", "last_name"]) -%}
        {{ my_initcap( chaine ) }} as full_name -- noqa: disable=all

    from source
)

select * from transformed
