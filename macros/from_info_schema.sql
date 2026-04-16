{#
https://github.com/bbrewington/dbt-bigquery-information-schema/blob/main/dbt_bigquery_info_schema/macros
#}

{%- macro from_info_schema(info_schema_type, dataset) -%}
{% if target.type == 'bigquery' -%}
    {%- if dataset -%}
    `{{ target.database }}.{{ dataset }}`.INFORMATION_SCHEMA.{{ info_schema_type|upper }}
    {%- else -%}
    `{{ target.database }}.region-{{ target.location|upper }}`.INFORMATION_SCHEMA.{{ info_schema_type|upper }}
    {%- endif -%}
{% elif target.type == 'duckdb' %}
    "system".information_schema.{{ info_schema_type|lower }}
{% else %}
    information_schema.{{ info_schema_type|lower }}
{% endif %}
{%- endmacro -%}