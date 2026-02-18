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
        cast(tax_rate as float64) as tax_rate,
        ---------- timestamp
        cast(regexp_replace(cast(opened_at as string),
            r'^(\d{4}-\d{2}-\d{2})T(\d{2}:\d{2}:\d{2}).*',
            r'\1T\2') as timestamp)
        as opened_at
    from source
)

select * from renamed
where opened_at <= {{ var('truncate_timespan_to') }}
