--dbt show -s list_unused_models

with models_to_drop as (
select
    case 
        when table_type = 'BASE TABLE' then 'TABLE'
        when table_type = 'VIEW' then 'VIEW'
    end as relation_type,
    {{ dbt.concat(["table_catalog", "'.'", "table_schema", 
        "'.'", "table_name"]) }} as relation_name
from
    {{ from_info_schema('TABLES', target.schema) }}
where
    UPPER(table_name) not in (
    {%- for node in graph.nodes.values() | 
        selectattr("resource_type", "in", ["model", "seed", "snapshot"]) %}
        '{{ node.name.upper() }}'
        {%- if not loop.last -%},{% endif %}
    {%- endfor %}
    )
)

select 
    {{ dbt.concat(["'DROP '", "relation_type", "' '", 
        "relation_name", "';'"]) }} as drop_commands
from models_to_drop
