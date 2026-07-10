{#
This macro allows you to mock a source with a table in certain environments (e.g. dev).
#}
{% macro mockable_source(source_name, table_name) %}

    {%- set target_name = target.name.lower() -%}

    {% if target_name in ['ci', 'dev'] %}
        {{ ref('jaffle_shop_init', table_name) }}
    {% else %}
        {{ source(source_name, table_name) }}
    {% endif %}

{% endmacro %}
