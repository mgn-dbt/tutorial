--dbt show -s list_unused_models [--output yml] [--profile pg|duck_tuto]

{% if execute %}
    {%- set current_models = [] %}
    {%- for node in graph.nodes.values() %}  {# | selectattr("resource_type", "equalto", "model") #}
        {%- do current_models.append(node.name) %}
    {%- endfor %}
{% endif %}

SELECT {# les 4 sont communes #}
    table_catalog,
    table_schema,
    table_name,
    table_type
FROM
    {{ from_info_schema('TABLES', target.schema) }}
WHERE UPPER(table_name) NOT IN (
{%- for model in current_models -%}
    '{{ model.upper() }}'
    {# to avoid comma in the end of list #}
    {%- if not loop.last -%},{% endif %}
{%- endfor -%}
)