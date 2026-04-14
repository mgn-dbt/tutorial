--dbt show -s list_unused_models [--output yml]

{% if execute %}
    {%- set current_models = [] %}
    {%- for node in graph.nodes.values() | 
        selectattr("resource_type", "in", ["model", "seed", "snapshot"]) %}
        {%- do current_models.append(node.name) %}
    {%- endfor %}
{% endif %}

{# les 4 sont communes #}
select
    table_catalog,
    table_schema,
    table_name,
    table_type
from
    {{ from_info_schema('TABLES', target.schema) }}
where UPPER(table_name) not in (
    {%- for model in current_models -%}
        '{{ model.upper() }}'
        {# to avoid comma in the end of list #}
        {%- if not loop.last -%},{% endif %}
    {%- endfor -%}
)
