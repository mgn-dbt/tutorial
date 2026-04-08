{#  
    -- let's develop a macro that 
    1. queries the information schema of a database
    2. finds objects that are > 1 week old (no longer maintained)
    3. generates automated drop statements
    4. has the ability to execute those drop statements
    
    dbt run-operation clean_stale_models --args '{"database": "my_database", "schema": "my_schema", "days": 30}'
#}

{% macro clean_stale_models(database=target.database, schema=target.schema, days=7, dry_run=True) %}
    
    {% set get_drop_commands_query %}
        select 
            'DROP ' || case 
                when table_type = 'VIEW'
                    then table_type
                else 
                    'TABLE'
            end || ' {{ database | upper }}.' || table_schema || '.' || table_name || ';'
        from {{ database }}.{{ schema }}.INFORMATION_SCHEMA.TABLES 
        where 1=1
        --and table_schema = upper('{{ schema }}')
        and DATE(creation_time) <= current_date - {{ days }}
    {% endset %}

    {{ log('\nGenerating cleanup queries...\n', info=True) }}
    {% set drop_queries = run_query(get_drop_commands_query).columns[0].values() %}

    {% for query in drop_queries %}
        {% if dry_run %}
            {{ log(query, info=True) }}
        {% else %}
            {{ log('Dropping object with command: ' ~ query, info=True) }}
            {% do run_query(query) %} 
        {% endif %}
    {% endfor %}

{% endmacro %}