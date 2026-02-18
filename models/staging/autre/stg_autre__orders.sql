{{
    config(
        materialized = 'table',
        unique_key = 'order_id'
    )
}}

with
source as (
    select * from {{ source('autre', 'orders') }}
    {# 
    attention le type de ordered_at depend du type dans le seed 
    cast(REGEXP_REPLACE(ordered_at,r'^(\d{4}-\d{2}-\d{2})\s(\d{2}:\d{2}:\d{2}).*',
    r'\1T\2') as timestamp)
    #}
    where 
        ordered_at <= {{ var('truncate_timespan_to') }}
),

renamed as (
    select
        ----------  ids
        id as order_id,
        store_id as location_id,
        customer as customer_id,
        ---------- properties
        (order_total / 100.0) as order_total,
        (tax_paid / 100.0) as tax_paid,
        ---------- timestamps
        ordered_at
    from source
)

select * from renamed
