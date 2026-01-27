-- macros/safe_ratio.sql
{% macro safe_ratio(numerator, denominator, default_value=0) %}
    case
        when {{ denominator }} is null
          or {{ denominator }} = 0
          or {{ numerator }} is null
        then {{ default_value }}
        else {{ dbt.cast(numerator, 'numeric') }} / {{ dbt.cast(denominator, 'numeric') }}
    end
{% endmacro %}