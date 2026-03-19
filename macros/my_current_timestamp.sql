{# staging unit_tests overrides dont work with internal current_timestamp #}

{% macro my_current_timestamp() -%}
    {{ return(adapter.dispatch('my_current_timestamp', 'dbt')()) }}
{%- endmacro %}

{% macro bigquery__my_current_timestamp() -%}
    current_timestamp()
{%- endmacro %}

{% macro postgres__my_current_timestamp() -%}
    current_timestamp
{%- endmacro %}
