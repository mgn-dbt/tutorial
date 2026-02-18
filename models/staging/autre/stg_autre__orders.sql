{{
    config(
        materialized = 'table',
        unique_key = 'order_id'
    )
}}

with
source as (
    select * from {{ source('autre', 'orders') }}
),

renamed as (
    select
        ----------  ids
        id as order_id,
        store_id as location_id,
        customer as customer_id,
        ---------- properties
        (cast(order_total as integer) / 100.0) as order_total,
        (cast(tax_paid as integer) / 100.0) as tax_paid,
        ---------- timestamps
        cast(regexp_replace(cast(ordered_at as string),
            r'^(\d{4}-\d{2}-\d{2})\s(\d{2}:\d{2}:\d{2}).*',
            r'\1T\2') as timestamp) as ordered_at
    from source
)

select * from renamed
where ordered_at <= {{ var('truncate_timespan_to') }}