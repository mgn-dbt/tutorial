{# cf dbt_packages\dbt_expectations\macros\regex\regexp_instr.sql #}

{% macro my_regexp_replace(source_value, regexp, repl_str, flags="") -%}
    {{ adapter.dispatch('my_regexp_replace')(source_value, regexp, repl_str, flags ) }}
{%- endmacro %}

{# BigQuery uses "r" to escape raw strings and re2 flags are in the regexp #}
{% macro bigquery__my_regexp_replace(source_value, regexp, repl_str, flags) -%}
    regexp_replace({{ source_value }}, r'{{ regexp }}', r'{{ repl_str }}')
{%- endmacro %}

{# others does not need to escape raw strings #}
{% macro default__my_regexp_replace(source_value, regexp, repl_str, flags) -%}
    regexp_replace({{ source_value }}, '{{ regexp }}', '{{ repl_str }}', '{{ flags }}')
{%- endmacro %}

