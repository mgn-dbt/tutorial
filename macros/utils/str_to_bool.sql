{% macro str_to_bool(value) %}
    {% if value is none %}
        {{ return(false) }}
    {% endif %}

    {% set true_values = ['true', '1', 'yes', 'y', 'on'] %}

    {% set normalized_value = value | string | lower | trim %}

    {% if normalized_value in true_values %}
        {{ return(true) }}
    {% else %}
        {{ return(false) }}
    {% endif %}
{% endmacro %}