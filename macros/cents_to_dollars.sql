-- funcsign: cents_to_dollars(column_name: string, scale: int) -> float
-- description: Converts a monetary value in cents to dollars.
-- example: {{ cents_to_dollars('amount_in_cents') }} converts 12345 to 123.45

{% macro cents_to_dollars(column_name, scale=2) -%}
    {{ return(adapter.dispatch('cents_to_dollars')(column_name, scale)) }}
{%- endmacro %}

{#
https://docs.cloud.google.com/bigquery/docs/reference/standard-sql/conversion_functions#cast_numeric
#}
{% macro bigquery__cents_to_dollars(column_name, scale) -%}
    trunc(cast(({{ column_name }} / 100) as numeric), {{ scale }})
{%- endmacro %}

{#
https://duckdb.org/docs/current/sql/data_types/numeric
https://www.postgresql.org/docs/current/datatype-numeric.html#DATATYPE-NUMERIC-DECIMAL
#}
{% macro default__cents_to_dollars(column_name, scale) -%}
    ({{ column_name }}::numeric(16, {{ scale }}) / 100)
{%- endmacro %}

