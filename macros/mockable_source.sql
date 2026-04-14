
{% macro mockable_source(source_name, table_name, mock_table_name) %}

    {%- set target_name = target.name.lower() -%}

    {% if target_name in ['ci', 'default', 'dev'] %}
        {{ ref(mock_table_name) }}
    {% else %}
        {{ source(source_name, table_name) }}
    {% endif %}

{% endmacro %}
