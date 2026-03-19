{# 
not_null generic test with an additional env argument to specify the environment in which the test should be run.
usage: 
          - not_null_in_env:
              arguments:
                env: prod
#}

{% macro test_not_null_in_env(model, column_name, env) %}
  
  {#-
  We should run this test when:
  * the environment has not been specified OR,
  * we are in the specified environment
  -#}
  {%- if env is none or target.name == env -%}
    {% set filtre = "where " ~ column_name ~ " is null" %}
  {%- else -%}
    {% set filtre = "limit 0" %}
  {%- endif -%}

  select *
  from {{ model }}
  {{ filtre }}

{% endmacro %}
