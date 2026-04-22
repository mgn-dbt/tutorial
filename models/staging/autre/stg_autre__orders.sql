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
        {{ cents_to_dollars('subtotal') }} as subtotal,
        {{ cents_to_dollars('tax_paid') }} as tax_paid,
        {{ cents_to_dollars('order_total') }} as order_total,
        ---------- timestamps
        cast(
            regexp_replace(
                cast(ordered_at as {{ dbt.type_string() }} ),
                {%- if target.type == 'bigquery' -%}{# bigquery raw text #}
                r{%- endif %}'^(\d{4}-\d{2}-\d{2})\s(\d{2}:\d{2}:\d{2}).*',
                '\\1T\\2'
            ) as {{ dbt.type_timestamp() }}
        ) as ordered_at
    from source
)

select * from renamed
where ordered_at <= {{ var('truncate_timespan_to') }}
