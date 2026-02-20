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
            '^(\\d{4}-\\d{2}-\\d{2})T(\\d{2}:\\d{2}:\\d{2}).*',
            '\\1T\\2')
        {%- endset -%}
        {{ dbt.cast(dt_regex, dbt.type_timestamp()) }} as opened_at
    from source
)

select * from renamed
where opened_at <= {{ var('truncate_timespan_to') }}
