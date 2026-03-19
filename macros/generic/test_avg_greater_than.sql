{# 
generic test to check that the average of a column is greater than the limit, 
grouped by a specified column.
usage: 
          - avg_greater_than:
              arguments:
                group_by_column: customer_id
                limit: 1 (par default)
#}
{% macro test_avg_greater_than(model, column_name, group_by_column, limit=1) %}

select
    {{ group_by_column }},
    avg( {{ column_name }} ) as average_amount
from {{ model }}
group by 1
having avg( {{ column_name }} ) < {{ limit }}

{% endmacro %}
