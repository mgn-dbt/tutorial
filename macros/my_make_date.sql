{# 
dbt.date replacement
#}

{% macro my_make_date(year=9999, month=12, day=31) -%}
    {{ return(adapter.dispatch('my_make_date')(year=year, month=month, day=day)) }}
{%- endmacro %}

{% macro bigquery__my_make_date(year=none, month=none, day=none) -%}
    date({{ year }}, {{ month }}, {{ day }})
{%- endmacro %}

{% macro default__my_make_date(year=none, month=none, day=none) -%}
    make_date({{ year }}, {{ month }}, {{ day }})
{%- endmacro %}
