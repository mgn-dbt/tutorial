{#
dbt run-operation is_same_table --args "{table_name_A: 'stg_autre__locations', 
    table_name_B: 'test_locations', 
    columns_to_compare: 'location_id,location_name,tax_rate,opened_at'}"
equivalent a audit_helper.compare_relations
#}
{% macro is_same_table(table_name_A, table_name_B, columns_to_compare) %}

    {% set query %}
    (
        select
            '{{ table_name_A }}' AS in_table
            , {{ columns_to_compare }}
        from {{ ref(table_name_A) }}
        {{ dbt.except() }}
        select
            '{{ table_name_A }}' AS in_table
            , {{ columns_to_compare }} 
        from 
            {{ ref(table_name_B) }}
    )

    union all

    (
        select
            '{{ table_name_B }}' AS in_table
            , {{ columns_to_compare }}
        from {{ ref(table_name_B) }}
        {{ dbt.except() }}
        select
            '{{ table_name_B }}' AS in_table
            , {{ columns_to_compare }} 
        from 
            {{ ref(table_name_A) }}
    )
    {% endset %}

    {% if execute %}
        {% set results = run_query(query) %}
        {% set nb_differences = results|length %}
        {% if nb_differences > 0 %}
            {{ log('The tables are different based on the columns compared. ' 
                ~ nb_differences // 2 ~ ' differences', info=True) }}
            {% do return(False) %}
        {% else %}
            {{ log('The tables are the same based on the columns compared.', info=True) }}
            {% do return(True) %}
        {% endif %}
    {% endif %}

{% endmacro %}
