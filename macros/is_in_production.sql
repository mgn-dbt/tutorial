{% macro is_in_production() %}
    {% if target.name == 'prod' %}
        {{ return(True) }}
    {% else %}
        {{ return(False) }}
    {% endif %}
{%endmacro%}