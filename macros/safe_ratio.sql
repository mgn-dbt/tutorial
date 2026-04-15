{#
division can be dangerous when the denominator is zero or null. 
This macro will return a default value (0 by default) in those cases, and perform the division otherwise.
#}
{% macro safe_ratio(numerator, denominator, default_value=0) %}
    case
        when {{ denominator }} is null
          or {{ denominator }} = 0
          or {{ numerator }} is null
        then {{ default_value }}
        else {{ dbt.cast(numerator, 'numeric') }} / {{ dbt.cast(denominator, 'numeric') }}
    end
{% endmacro %}
