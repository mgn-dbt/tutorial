{# cf dbt_packages\dbt_expectations\macros\regex\regexp_instr.sql #}

{% macro my_regexp_replace(source_value, regexp, repl_str, flags="") -%}
    {{ adapter.dispatch('my_regexp_replace')(source_value, regexp, repl_str, flags ) }}
{%- endmacro %}

{# BigQuery uses "r" to escape raw strings and re2 flags are in the regexp #}
{% macro bigquery__my_regexp_replace(source_value, regexp, repl_str, flags) -%}
    regexp_replace({{ source_value }}, r'{{ regexp }}', r'{{ repl_str }}')
{%- endmacro %}

{# others need escape for \n pattern replacement #}
{% macro default__my_regexp_replace(source_value, regexp, repl_str, flags) -%}
    {% set e_repl_str = repl_str | replace('\\1', '\\\\1') | replace('\\2', '\\\\2') | replace('\\3', '\\\\3') %}
    regexp_replace({{ source_value }}, '{{ regexp }}', '{{ e_repl_str }}', '{{ flags }}')
{%- endmacro %}

