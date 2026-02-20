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
        ({{ dbt.cast('order_total', dbt.type_int()) }} / 100.0) as order_total,
        ({{ dbt.cast('tax_paid', dbt.type_int()) }} / 100.0) as tax_paid,
        ---------- timestamps
        {%- set dt_regex -%}
            regexp_replace({{ dbt.cast('ordered_at', dbt.type_string()) }},
            '^(\\d{4}-\\d{2}-\\d{2})\\s(\\d{2}:\\d{2}:\\d{2}).*',
            '\\1T\\2')
        {%- endset -%}
        {{ dbt.cast(dt_regex, dbt.type_timestamp()) }} as ordered_at
    from source
)

select * from renamed
where ordered_at <= {{ var('truncate_timespan_to') }}
