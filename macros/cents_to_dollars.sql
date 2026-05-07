-- funcsign: cents_to_dollars(column_name: string, scale: int) -> float
-- description: Converts a monetary value in cents to dollars.
-- example: {{ cents_to_dollars('amount_in_cents') }} converts 12345 to 123.45

{#
https://github.com/dbt-labs/jaffle-shop/blob/main/macros/cents_to_dollars.sql
#}

{% macro cents_to_dollars(column_name, scale=2) -%}
    {% if scale>2 %}
        {{ log('Scale cannot be greater than 2. Defaulting to 2.', info=True) }}
        {{ return(adapter.dispatch('cents_to_dollars')(column_name, 2)) }}
    {% else %}
        {{ return(adapter.dispatch('cents_to_dollars')(column_name, scale)) }}
    {% endif %}
{%- endmacro %}

{#
https://docs.cloud.google.com/bigquery/docs/reference/standard-sql/data-types#numeric_types
https://docs.cloud.google.com/bigquery/docs/reference/standard-sql/operators#arithmetic_operators
https://docs.cloud.google.com/bigquery/docs/reference/standard-sql/mathematical_functions#trunc
INT64 / INT64 -> FLOAT64
round ou trunc FLOAT64 -> FLOAT64
#}
{% macro bigquery__cents_to_dollars(column_name, scale) -%}
    cast(round({{ column_name }} / 100, {{ scale }}) as numeric)
{%- endmacro %}

{#
https://duckdb.org/docs/current/sql/data_types/numeric
https://www.postgresql.org/docs/current/datatype-numeric.html#DATATYPE-NUMERIC-DECIMAL
#}
{% macro default__cents_to_dollars(column_name, scale) -%}
    (trunc({{ column_name }})::numeric(16, {{ scale }}) / 100)
{%- endmacro %}

