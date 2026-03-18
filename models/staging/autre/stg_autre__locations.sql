with
source as (
    select * from {{ source('autre', 'stores') }}
),

renamed as (
    select
        ----------  ids
        id as location_id,
        ---------- properties
        name as location_name,
        {{ dbt.cast('tax_rate', dbt.type_float()) }} as tax_rate,
        ---------- timestamp
        {%- set dt_regex -%}
            regexp_replace({{ dbt.cast('opened_at', dbt.type_string()) }},
            '^(\\d{4}-\\d{2}-\\d{2}).*',
            '\\1')
        {%- endset -%}
        {{ dbt.cast(dt_regex, 'date') }} as opened_at
    from source
)

select * from renamed
where
    opened_at <= {{ ensure_bq_date(var('truncate_timespan_to')) }}
