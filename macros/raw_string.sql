{# bigquery raw string #}
{% macro raw_string(str) -%}
    {{ adapter.dispatch('raw_string')(str) }}
{%- endmacro %}

{% macro bigquery__raw_string(str) -%}
    r'{{ str }}'
{%- endmacro %}

{% macro default__raw_string(str) -%}
    '{{ str }}'
{%- endmacro %}
