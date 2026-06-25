{#
Macro to create a view pointing to the latest version of a model.
cf https://github.com/nydasco/dbt_with_duckdb/blob/model-versioning/macros/create_latest_version_view.sql

    dbt-core v1.12 new feature :
    https://docs.getdbt.com/reference/resource-configs/latest_version_pointer

#}

{% macro create_latest_version_view() %}

    -- this hook will run only if the model is versioned, and only if it's the latest version
    -- otherwise, it's a no-op
    {% if model.version and model.version == model.latest_version %}

        {% set new_relation = this.incorporate(path={"identifier": model['name']}) %}

        {% set existing_relation = load_relation(new_relation) %}

        {% if existing_relation and not existing_relation.is_view %}
            {% do log("Dropping existing relation " ~ existing_relation, info = true) if execute %}
            {{ drop_relation_if_exists(existing_relation) }}
        {% endif %}
        
        {% set create_view_sql -%}
            -- this syntax may vary by data platform
            create or replace view {{ new_relation }}
              as select * from {{ this }}
        {%- endset %}
        
        {% do log("Creating view " ~ new_relation ~ " pointing to " ~ this, info = true) if execute %}
        
        {{ return(create_view_sql) }}
        
    {% else %}
    
        -- no-op
        select 1 as id
    
    {% endif %}

{% endmacro %}