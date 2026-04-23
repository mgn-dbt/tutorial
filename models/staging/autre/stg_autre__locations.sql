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
        cast(tax_rate as {{ dbt.type_float() }}) as tax_rate,
        ---------- date
        cast(
            regexp_replace(
                cast(opened_at as {{ dbt.type_string() }}),
                {{ raw_string('^(\d{4}-\d{2}-\d{2}).*') }},
                {{ raw_string('\\1') }}
            ) as date
        ) as opened_at
    from source
)

select * from renamed
where
    opened_at <= {% if target.type == 'bigquery' -%}
        {# bigquery comparison doesnt accept type mismatch date/timestamp #}
        DATE({{ var('truncate_timespan_to') }}){%- else -%}
        {{ var('truncate_timespan_to') }}{%- endif %}
