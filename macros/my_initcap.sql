{# 
adaptation initcap for duckdb, which does not support it natively.
#}

{% macro my_initcap(chaine) -%}
    {{ return(adapter.dispatch('my_initcap')(chaine)) }}
{%- endmacro %}

{% macro duckdb__my_initcap(chaine) -%}
    {# sqlfluff unparsable sql ! #}
    list_reduce(list_transform(string_split({{chaine}}, ' '), lambda t: upper(t[1])||lower(t[2:]) ), lambda str, r: str || ' ' || r )
{%- endmacro %}

{% macro default__my_initcap(chaine) -%}
    initcap({{ chaine }})
{%- endmacro %}
