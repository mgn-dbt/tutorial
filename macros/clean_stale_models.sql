{#  
    -- let's develop a macro that 
    1. queries the information schema of a database
    2. finds objects that are > 1 week old (no longer maintained)
    3. generates automated drop statements
    4. has the ability to execute those drop statements
    
    dbt run-operation clean_stale_models --args '{"database": "my_database", "schema": "my_schema", "days": 30}'

    cf dbt_internal_packages\dbt-adapters\macros\adapters\metadata.sql
    get_tables_by_pattern_sql()

    get_relation_last_modified(`dbt-jaffle-shop-481313.region-US.INFORMATION_SCHEMA.TABLE_STORAGE`, relations)

    SELECT * FROM `dbt-jaffle-shop-481313.region-US.INFORMATION_SCHEMA.TABLE_STORAGE`;

{%-
        set info_schema_tb_store = api.Relation.create(
            database=target.database,
            schema="region-US.INFORMATION_SCHEMA",
            identifier="TABLE_STORAGE",
            quote_policy={database: true, schema: true, identifier: true},
        )
-%}

https://github.com/dbt-labs/dbt-adapters/issues/1005
https://medium.com/google-cloud/bigquery-information-schema-a6a852535cf1

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