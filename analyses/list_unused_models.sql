--dbt show -s list_unused_models

with models_to_drop as (
select
    case 
        when table_type = 'BASE TABLE' then 'TABLE'
        when table_type = 'VIEW' then 'VIEW'
    end as relation_type,
    {% if target.type == 'bigquery' -%}
        {{ dbt.concat(["'`'", "table_catalog", "'.'", "table_schema", 
            "'.'", "table_name", "'`'"]) }} as relation_name
    {%- else -%}
        {{ dbt.concat(["table_catalog", "'.'", "table_schema", 
            "'.'", "table_name"]) }} as relation_name
    {%- endif %}
from
    {{ from_info_schema('TABLES') }}
where
    UPPER(table_schema) = UPPER('{{ target.schema }}') and
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
