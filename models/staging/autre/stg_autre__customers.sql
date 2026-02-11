with
source as (
    select * from {{ source('autre', 'customers') }}
),

renamed as (
    select
        ----------  ids
        id as customer_id,
        ---------- properties
        name as customer_name
    from source
)

select * from renamed
