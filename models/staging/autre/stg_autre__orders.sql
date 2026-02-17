{{
    config(
        materialized = 'table',
        unique_key = 'order_id'
    )
}}

with
source as (
    select * from {{ source('autre', 'orders') }}
    {# attention le type de ordered_at depend du type dans le seed 
    where 
        PARSE_TIMESTAMP("%Y-%m-%d %H:%M:%S.000", ordered_at) 
        <= {#{ var('truncate_timespan_to') }#}
        #}
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
