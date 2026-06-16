{#
dbt run-operation is_same_table --args "{
    table_name_A: 'stg_extended__locations', 
    table_name_B: 'test_locations', 
    columns_to_compare: 'location_id,location_name,tax_rate,opened_at'}"

return True if the tables are the same based on the columns compared, False otherwise.

cf audit_helper.compare_relations
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
        {# same table == empty_set #}
    {% else %}
        {% set results = none %}
    {% endif %}

    {% if results is not none %}
        {% set differences = results.columns[0].values() %}
        {% if differences | length == 0 %}
            {{ log("The tables are the same based on the columns compared.", info=True) }}
            {{ return(True) }}
        {% else %}
            {{ log("The tables are different based on the columns compared.", info=True) }}
        {% endif %}
    {% endif %}

    {{ return(False) }}

{% endmacro %}
