-- funcsign: cents_to_dollars(column_name: string, decimal_places: int = 2) -> float
-- description: Converts a monetary value in cents to dollars, rounding to the specified number of decimal places.
-- example: {{ cents_to_dollars('amount_in_cents', 2) }} converts 12345 to 123.45
{% macro cents_to_dollars(column_name, decimal_places=2) -%}
    round( 1.0 * {{ column_name }} / 100, {{ decimal_places }})
{%- endmacro %}