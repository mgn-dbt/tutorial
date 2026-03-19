{# bigquery date comparison doesn't accept type mismatch date/timestamp #}
{% macro ensure_bq_date(timestamp_str) -%}

    {% if target.type == 'bigquery' -%}
        DATE({{timestamp_str}})
    {%- else -%}
        {{timestamp_str}}
    {%- endif %}

{% endmacro %}
