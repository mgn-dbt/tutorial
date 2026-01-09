--
-- overrides with dbt internal macro (ex: dbt.current_timestamp) dont work with fusion
-- {{ log("appel my_current_timestamp", True) }}
--

-- funcsign: () -> string
{%- macro my_current_timestamp() -%}
    {{ adapter.dispatch('current_timestamp', 'dbt')() }}
{%- endmacro -%}
