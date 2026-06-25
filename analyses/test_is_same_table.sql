-- depends_on: {{ ref('stg_extended__locations') }}
-- depends_on: {{ ref('test_locations') }}

--dbt show -s test_is_same_table

{% set columns_to_compare = '
    location_id,
    location_name,
    tax_rate,
    opened_at'
%}

select
    {{ is_same_table('stg_extended__locations', 'test_locations', columns_to_compare) }}
        as same_table
