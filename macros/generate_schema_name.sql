{% macro generate_schema_name(custom_schema_name, node) %}

    {%- set default_schema = target.schema -%}

    {%- if custom_schema_name is none -%}
            
        {{ default_schema }}

    {%- else -%}

        {#  traitement spécial des seeds de dev  #}
        {% if node.resource_type == 'seed' and env_var('DBT_ENV_NAME', 'sans') == 'dev' %}
            
            {{ custom_schema_name | trim }}
        
        {% else %}

            {{ default_schema }}_{{ custom_schema_name | trim }}

        {%- endif -%}

    {% endif %}

{% endmacro %}