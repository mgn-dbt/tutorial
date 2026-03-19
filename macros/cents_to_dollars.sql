-- funcsign: cents_to_dollars(column_name: string, scale: int) -> float
-- description: Converts a monetary value in cents to dollars.
-- example: {{ cents_to_dollars('amount_in_cents') }} converts 12345 to 123.45

{% macro cents_to_dollars(column_name, scale=2) -%}
    {{ return(adapter.dispatch('cents_to_dollars')(column_name, scale)) }}
{%- endmacro %}

{% macro postgres__cents_to_dollars(column_name, scale) -%}
    -- float8
    ({{ column_name }}::numeric(16, {{ scale }}) / 100)
{%- endmacro %}

{% macro bigquery__cents_to_dollars(column_name, scale) %}
    round(cast(({{ column_name }} / 100) as numeric), {{ scale }})
{% endmacro %}
