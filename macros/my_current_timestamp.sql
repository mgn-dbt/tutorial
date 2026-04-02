{# 
unit_tests overrides dont work with internal current_timestamp macro (dbt fusion)
#}

{% macro my_current_timestamp() -%}
    {{ return(adapter.dispatch('my_current_timestamp')()) }}
{%- endmacro %}

{% macro bigquery__my_current_timestamp() -%}
    current_timestamp()
{%- endmacro %}

{% macro default__my_current_timestamp() -%}
    current_timestamp
{%- endmacro %}
