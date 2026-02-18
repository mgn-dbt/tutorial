with
source as (
    select * from {{ source('autre', 'stores') }}
    {# 
    attention le type de opened_at depend du type dans le seed 
    dbt.cast(var('truncate_timespan_to'), 'datetime')
    #}
    where opened_at <= {{ var('truncate_timespan_to') }}
),

renamed as (
    select
        ----------  ids
        id as location_id,
        ---------- properties
        name as location_name,
        tax_rate,
        ---------- timestamp
        opened_at
    from source
)

select * from renamed
