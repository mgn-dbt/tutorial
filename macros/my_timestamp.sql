{# staging unit_tests overrides dont work with internal current_timestamp #}

{% macro my_timestamp(timestamp_str) -%}
  {{ return(adapter.dispatch('my_timestamp', 'dbt')(timestamp_str)) }}
{%- endmacro %}

{% macro bigquery__my_timestamp(timestamp_str) -%}
  timestamp("{{timestamp_str}}")
{%- endmacro %}

{% macro postgres__my_timestamp(timestamp_str) -%}
  timestamp "{{timestamp_str}}"
{%- endmacro %}