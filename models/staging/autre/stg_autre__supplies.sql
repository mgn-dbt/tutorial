with
source as (
    select * from {{ source('autre', 'supplies') }}
),

renamed as (
    select
        ----------  ids
        {{ dbt_utils.generate_surrogate_key(['id', 'sku']) }} as supply_uuid,
        id as supply_id,
        sku as product_id,
        ---------- properties
        name as supply_name,
        {{ cents_to_dollars('cost') }} as supply_cost,
        {{ dbt.cast('perishable', dbt.type_boolean()) }} as is_perishable_supply
    from source
)

select * from renamed
