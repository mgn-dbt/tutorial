# ❤ Jinja Cheatsheet ❤

## Datatypes

Cf https://documentation.bloomreach.com/engagement/docs/functions-on-data-types

## Variables

### Basic

```
{% set my_string = "example" %}

{% set multiline_text %}
  Lorem ipsum dolor sit amet consectetur adipiscing elit. 
  Quisque faucibus ex sapien vitae pellentesque sem placerat. 
  In id cursus mi pretium tellus duis convallis. 
  Tempus leo eu aenean sed diam urna tempor. 
{% endset %}
```

### List (Ordered collection)

```
{% set empty_list = [] %}
{% set my_list = ["apple", "lemon"] %}
{{ my_list[0] }}
{{ my_list[1] }}

{% for fruit in my_list -%}
  My favorite fruit is the {{ fruit }}
{%- endfor %}
```
Keep in mind that lists are indexed from 0

### Dictionary

```
{% set my_dict = {"firstname": "john", "lastname": "doe"} %}
my name is {{ my_dict['firstname'] }} {{ my_dict['lastname'] }}

{% for key, value in my_dict.items() %}
  {{ key }}: {{ value }}
{% endfor %}
```
Keys must be unique and always have exactly one value

### Tuple 

```
{% set singleton = ('a',) %}
{% set my_tuple = ('a', 'b') %}
```
Tuples are like lists that cannot be modified (Immutable)


## Comments

```
{# Example comment #}
```

## Statements

```
{% ... %} e.g.: loops, if
```

## Expressions

```
{{ ... }} e.g.: ref
```

## var()
```
SELECT *
FROM events
WHERE event_type = '{{ var("event_type") }}'
```

## Macros

Macros are reusable code snippets (functions) written in Jinja

```
{% macro cents_to_dollar(col_name, precision=2) %}
({{ col_name }} / 100)::numeric(16, {{ precision }})
{% endmacro %}
```

Run macro
```
dbt run-operation <macro> --args '{example: value}'
```

Call a macro
```
{{ my_macro(param01, param02) }}
```

Call a macro and get return value
```
{% set some_var = my_macro(param01, param02, param03) %}
```

### Return

```
{% macro example() %}
  {{ return("Hello") }}
{% endmacro %}
```

Without output :
```
{% macro example() %}
  {% do return("Hello") }
{% endmacro %}
```

### Examples

Concat take a list. All list element have to be strings.
```
{{ dbt.concat(["table_catalog", "'.'", "table_schema", "'.'", "table_name"]) }}
```

Casts<br>
Cf file://./dbt_internal_packages/dbt-adapters/macros/utils/data_types.sql<br>
There is no dbt.type_date or dbt.type_datetime
```
{{ dbt.cast('orders.ordered_at', 'date') }}
{{ dbt.cast('tax_rate', dbt.type_float()) }}
{{ dbt.cast('opened_at', dbt.type_string()) }}
{{ dbt.cast(dt_regex, dbt.type_timestamp()) }}
{{ dbt.cast('perishable', dbt.type_boolean()) }}
```

date_diff
```
{{ dbt.datediff("order_date", my_current_timestamp(), "day") }}
```

Column values
```
{%- set payment_methods = dbt_utils.get_column_values(    
    table=source('stripe','payment'),
    column='paymentmethod') -%}
```


## Cast variable

\# To string
```
{% set my_int_var = 2020 %}
{% set my_int_var|string %}
```

\# To int
```
{% set my_str_var = "2020" %}
{% set my_str_var|int %}
```

## Length

```
{% set my_list = ["apple", "lemon"] %}
```

Check if my_list has more than 3 elements
```
{% if my_list|length > 3 %}
```

## Adding elements to a List

```
{% set numbers = [] %}

{% for i in range(1, 10) %}
{% do numbers.append(i) %}
{% endfor %}
```

## Loop.last

To avoid trailing commas in loops use:
```
{% if not loop.last %},{% endif %}
```

## Loops

* Over list

|Input | Compiled |
| :----------- | :----------- |
| {% set my_list = ['sales_x', 'sales_y'] %} ||
| SELECT | SELECT |
| id, | id, |
| {%- for col_name in my_list %} | SUM(sales_x), |
| SUM({{ col_name }}) | SUM(sales_y) |
| {%- if not loop.last -%}, {%- endif -%} | FROM example |
| {% endfor %} | GROUP BY 1 |
| FROM example ||
| GROUP BY 1 ||

* Over dictionary

|Input | Compiled |
| :----------- | :----------- |
| {% set payment_methods = {"type_0" : "bank_transfer", |  |
| "type_1" : "credit_card", | SELECT |
| "type_2" : "gift_card"} %} | order_id, |
| SELECT | sum(CASE |
| order_id, | WHEN payment_method = ’type_0’ |
| {%- for type, column_name in payment_methods.items()%} | THEN amount END) AS bank_transfer_amt, |
| sum(CASE | sum(CASE |
| WHEN payment_method = ‘{{type}}' | WHEN payment_method = ‘type_1’ |
| THEN amount end) as {{ column_name }}_amt | THEN amount END) AS credit_card_amt, |
| {%- if not loop.last -%}, {%- endif -%} | sum(CASE |
| {%- endfor -%} | WHEN payment_method = ‘type_2’ |
| FROM example | THEN amount END) AS gift_card_amt |
| GROUP BY 1 | FROM example |
|| GROUP BY 1 |


## if | elif | else

```
{% macro generate_schema_name() -%}
{%- if target.name == 'dev' -%}
  ...
{%- elif target.name == 'prod' -%}
  ...
{%- else -%}
  ...
{%- endif -%}
{%- endmacro %}
```

## Exceptions

-- Warning
```
{% do exceptions.warn("Warning message") %}
```

-- Error
```
{{ exceptions.raise_compiler_error("Error message") }}
```

## Debug

The {{ debug() }} macro will open an iPython debugger in the context of a compiled dbt macro

Usage:
```
...
{{ debug() }}
...
```

## Call statement

Cf file://./dbt_internal_packages/dbt-adapters/macros/etc/statement.sql
```
{% macro run_query(sql) %}
  {% call statement("run_query_statement", fetch_result=true, auto_begin=false) %}
    {{ sql }}
  {% endcall %}

  {% do return(load_result("run_query_statement").table) %}
{% endmacro %}
```

https://docs.getdbt.com/reference/dbt-jinja-functions/statement-blocks

Load_result returns a result having 3 keys (response, data, table).<br>
Table is a agate table<br>
It can be transformed in text with print_table()<br>
print_table(max_rows=None, max_columns=None) to print all rows and columns.

cf <br>
https://agate.readthedocs.io/en/latest/api/table.html<br>
https://agate.readthedocs.io/en/latest/api/table.html#agate.Table.print_table


## Run query

```
{% set results = run_query("select * from table") %}
{% do print(results.print_table()) %}
```

https://docs.getdbt.com/reference/dbt-jinja-functions/run_query

Run_query returns a agate table object (Cf call statement).


## Trim whitespace

```
{%- ... %}  Strips before
{%- ... -%} Strips before and after
```

## Logging

write to both the log file and stdout
```
{{ log("Some text" ~ my_string, info=True) }}
```

write only to the log file
```
{{ log("Some text" ~ my_string) }}
```

## Print

print() function print messages to both the log file and standard output (stdout).
```
{{ print("My Message") }}
```

## Environment variables

```
{{ env_var("VAR_NAME") }}
```

## Graph (dag)

```
{% macro example() %}

  {% if execute %}
    {% for node in graph.nodes.values() %}
      {% do log(node.unique_id ~ ", config: " ~ node.config) %}
    {% endfor %}
  {% endif %}

{% endmacro %}
```

Cf https://docs.getdbt.com/reference/dbt-jinja-functions/graph

## dbt_utils

dbt_utils is a collection of reusable dbt macros

Examples:
- deduplicate - remove duplicates from a model
- group_by - build a group by statement for (1..N)