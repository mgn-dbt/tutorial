-- funcsign: () -> string
{%- macro my_current_timestamp() -%}
    {{ adapter.dispatch('current_timestamp', 'dbt')() }}
    {# { log("appel my_current_timestamp", True)} #}
{%- endmacro -%}