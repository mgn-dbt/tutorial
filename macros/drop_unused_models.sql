{#
Show drop commands
dbt run-operation drop_unused_models
Show and execute drop commands
dbt run-operation drop_unused_models --args "{dry_run: False}"
#}

{% macro drop_unused_models(dry_run=True) %}

    {% if execute %}

        {% set cleanup_sql %}
with models_to_drop as (
select
    case 
        when table_type = 'BASE TABLE' then 'TABLE'
        when table_type = 'VIEW' then 'VIEW'
    end as relation_type,
    {% if target.type == 'bigquery' -%}
        {{ dbt.concat(["'`'", "table_catalog", "'.'", "table_schema", 
            "'.'", "table_name", "'`'"]) }} as relation_name
    {%- else -%}
        {{ dbt.concat(["table_catalog", "'.'", "table_schema", 
            "'.'", "table_name"]) }} as relation_name
    {%- endif %}
from
    {{ from_info_schema('TABLES', target.schema) }}
where
    UPPER(table_name) not in (
    {%- for node in graph.nodes.values() | 
        selectattr("resource_type", "in", ["model", "seed", "snapshot"]) %}
        '{{ node.name.upper() }}'
        {%- if not loop.last -%},{% endif %}
    {%- endfor %}
    )
)
select 
    {{ dbt.concat(["'DROP '", "relation_type", "' '", 
        "relation_name", "';'"]) }} as drop_commands
from models_to_drop
order by relation_type, relation_name
        {% endset %}

        {% set commands = run_query(cleanup_sql).columns[0].values() %}

        {% if commands %}

            {% do log("\nCommands :", info=True) %}
            
            {% for cmd in commands %}
                {# execute or print drop statements #}
                {% do log("sql> " ~ cmd, info=True) %}

                {% if not dry_run | as_bool %}
                    {% do run_query(cmd) %}
                    {% do log("Executed: " ~ cmd, info=True) %}
                {% endif %}
            {% endfor %}
        {% else %}

            {% do log("- No objects to drop -", info=True) %}
        
        {% endif %}

    {% endif %}
{% endmacro %}