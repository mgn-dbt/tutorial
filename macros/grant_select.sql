{#
This macro grants select privileges on all tables in a schema to a role.
#}
{% macro grant_select(schema=target.schema, role=target.role) %}
    {% if target.type == 'postgres' %}
        {% set sql %}
            grant usage on schema {{ schema }} to {{ role }};
            grant select on all tables in schema {{ schema }} to {{ role }};
        {% endset %}

        {{ log('Granting select on all tables in schema ' 
            ~ schema ~ ' to role ' ~ role, info=True) }}
        {% do run_query(sql) %}
        {{ log('Privileges granted', info=True) }}
    {% endif %}
{% endmacro %}
