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

### Examples
Concat take a list. All list element have to be strings.
```
{{ dbt.concat(["table_catalog", "'.'", "table_schema", "'.'", "table_name"]) }}
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

\# Check if my_list has more than 3 elements
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

|Input | Compiled |
| :----------- | :----------- |
| -- Over list | SELECT |
| {% set my_list = ['sales_x', 'sales_y'] %} | id, |
| SELECT | SUM(sales_x), |
| id, | SUM(sales_y) |
| {%- for col_name in my_list %} | FROM example |
| SUM({{ col_name }}) | GROUP BY 1 |
| {%- if not loop.last -%}, {%- endif -%} ||
| {% endfor %} ||
| FROM example ||
| GROUP BY 1 ||

|Input | Compiled |
| :----------- | :----------- |
| -- Over dictionary | SELECT |
| {% set payment_methods = {"type_0" : "bank_transfer", | order_id, |
| "type_1" : "credit_card", | sum(CASE |
| "type_2" : "gift_card"} %} | WHEN payment_method = ’type_0’ |
| SELECT | THEN amount END) AS bank_transfer_amt, |
| order_id, | sum(CASE |
| {%- for type, column_name in payment_methods.items()%} | WHEN payment_method = ‘type_1’ |
| sum(CASE | THEN amount END) AS credit_card_amt, |
| WHEN payment_method = ‘{{type}}' | sum(CASE |
| THEN amount end) as {{ column_name }}_amt | WHEN payment_method = ‘type_2’ |
| {%- if not loop.last -%}, {%- endif -%} | THEN amount END) AS gift_card_amt |
| {%- endfor -%} | FROM example |
| FROM example | GROUP BY 1 |
| GROUP BY 1 ||


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

## Run query
```
{% set results = run_query("select * from table") %}
{% do results.print_table() %}
```

Cf https://docs.getdbt.com/reference/dbt-jinja-functions/run_query

Return a agate table object.<br>
Cf <br>
https://agate.readthedocs.io/en/latest/api/table.html<br>
https://agate.readthedocs.io/en/latest/api/table.html#agate.Table.print_table<br>
https://agate.readthedocs.io/en/latest/api/table.html#agate.Table.print_structure<br>
https://agate.readthedocs.io/en/latest/api/table.html#agate.Table.print_html<br>
https://agate.readthedocs.io/en/latest/api/table.html#agate.Table.print_csv


## Trim whitespace
```
{%- ... %}  Strips before
{%- ... -%} Strips before and after
```

## Logging to Stdout
```
{{ log("Some text" ~ my_string, info=True) }}
```

## Print
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
{% do log(node.unique_id ~ ", config: " ~ node.config, info=true) %}
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