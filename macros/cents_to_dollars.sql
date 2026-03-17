-- funcsign: cents_to_dollars(column_name: string) -> float
-- description: Converts a monetary value in cents to dollars.
-- example: {{ cents_to_dollars('amount_in_cents') }} converts 12345 to 123.45

{% macro cents_to_dollars(column_name) -%}
    {{ return(adapter.dispatch('cents_to_dollars')(column_name)) }}
{%- endmacro %}

{% macro default__cents_to_dollars(column_name) -%}
    -- implicite casting to float, then dividing by 100 and rounding to 2 decimal places
    round( 1.0 * {{ column_name }} / 100, 2)
{%- endmacro %}

{% macro postgres__cents_to_dollars(column_name) -%}
    -- float8
    ({{ column_name }}::numeric(16, 2) / 100)
{%- endmacro %}

{% macro bigquery__cents_to_dollars(column_name) %}
    round(cast(({{ column_name }} / 100) as numeric), 2)
{% endmacro %}