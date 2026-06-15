# ❤ Jinja Cheatsheet ❤

## Variables

### Basic

```jinja
{% set my_string = "example" %}

{% set multiline_text %}
  Lorem ipsum dolor sit amet consectetur adipiscing elit. 
  Quisque faucibus ex sapien vitae pellentesque sem placerat. 
  In id cursus mi pretium tellus duis convallis. 
  Tempus leo eu aenean sed diam urna tempor. 
{% endset %}
```

### Tuple (Immutable ordered indexed collection)

```jinja
{% set empty_tuple = () %}
{% set singleton = ('a',) %}
{% set my_tuple = ('un', 'deux', 'trois') %}

{{ my_tuple[1,2] }}
{# ('deux', 'trois') #}

{# unpack a tuple #}
a, b, c = my_tuple
```

### List (Ordered indexed collection duplicate allowed)

```jinja
{% set empty_list = [] %}
{% set my_list = ["apple", "lemon", "grape"] %}
{{ my_list[0] }}
{{ my_list[1] }}
{# Keep in mind that lists are indexed from 0 #}

{% for fruit in my_list | reject('eq', 'grape') -%}
  My favorite fruit is the {{ fruit }}
{%- endfor %}

{% set my_list = [3,2,1,3,4,4,5] %}
{{ my_list | unique }}
{# [1,2,3,4,5] #}
{{ my_list | reverse }}
{# [5,4,4,3,1,2,3] #}

{#  Adding elements to a List #}
{% set numbers = [] %}
{% for i in range(1, 10) %}
{% do numbers.append(i) %}
{% endfor %}
{# [1,2,3,4,5,6,7,8,9,10] #}
```

### Set (Immutable unordered unindexed collection with no duplicate)

```jinja
{% set empty_set = {} %}
{% set my_set = set_strict([1,2,2,3,4,4,5]) %}
{# {1,2,3,4,5} #}
```

Duplicate values will be ignored  
True and 1 is considered the same value  
False and 0 is considered the same value

[set](https://docs.getdbt.com/reference/dbt-jinja-functions/set)

### Dictionary (Ordered collection with no duplicate)

Keys must be unique and always have exactly one value (no duplicate)

```jinja
{% set empty_dict = {} %}
{% set my_dict = {"firstname": "john", "lastname": "doe"} %}
my name is {{ my_dict['firstname'] }} {{ my_dict['lastname'] }}

{% for key, value in my_dict.items() %}
  {{ key }}: {{ value }}
{% endfor %}
```

## Comments

```jinja
{# Example comment #}
```

Jinja comments don't appear in compiled code.
Sql comments do.

## Statements

```jinja
{% ... %} e.g.: loops, if
```

## Expressions

```jinja
{{ ... }} e.g.: ref
```

## Jinja Filters

[jinja functions](https://docs.getdbt.com/reference/dbt-jinja-functions-context-variables)

### cast

```jinja
{% set my_str_var = "2020" %}
{{ my_str_var | as_number }}
{{ my_str_var | int }}
```

### Default value

```jinja
{# if the variable username is not defined or is empty, it will default to "Guest". #}
{{ username | default('Guest') }}
{# if the variable count is not defined or is empty, it will default to 0. #}
{{ count | default(0) }}
```

### Length

```jinja
{# Check if my_list has more than 3 elements #}
{% set my_list = ["apple", "lemon"] %}
{% if my_list | length > 3 %}...{% endif %}
```

### Join

```jinja
{% set words = ["apple", "lemon"] %}
{% [word.upper() for word in words ] | join(', ') %}
{# APPLE, LEMON #}
```

### Slice

```jinja
{% set sentence = "Hello, World!" %}
{% sentence | slice(0,5) %}
{# Hello #}
```

### run_started_at and datetime/pytz modules

[python modules](https://docs.getdbt.com/reference/dbt-jinja-functions/modules)

```sql
select '{{ run_started_at.strftime("%Y-%m-%d") }}' as run_started_day

select '{{ run_started_at.astimezone(modules.pytz.timezone("America/New_York")) }}' as run_started_at_for_ny
```

```jinja
{% set dt_now = modules.datetime.datetime.now() %}
{# Displaying the Current Date #}
{{ print(dt_now.strftime('%Y-%m-%d')) }}
{# Displaying the Current Time #}
{{ print(dt_now.strftime('%H:%M:%S')) }}
{% set three_days_ago_iso = (dt_now - modules.datetime.timedelta(3)).isoformat() %}
{{ print(three_days_ago_iso) }}

{% set dt = modules.datetime.datetime(2002, 10, 27, 6, 0, 0) %}
{% set dt_local = modules.pytz.timezone('Europe/Paris').localize(dt) %}
{{ print(dt) }}
{{ print(dt_local) }}
```

datetime is a dictionary (year, month, day, etc ...)  
dt_now.year  
dt_now.month  
etc...

## if | elif | else

```jinja
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

you can use "if variable" to test if a variable is defined, not empty and not false.

other tests on variables :

```jinja
{% if variable is defined %}...
{% if variable is undefined %}...
{% if variable is none %}...
{% if variable is number %}...
{% if variable is string %}...
{% if variable is mapping %}...{# variable is a dictionary ? #}
```

## Loops

| Property name | Type | Returns |
| :----------- | :----------- | :----------- |
| loop.first | Integer | True if it is the first iteration, else false |
| loop.last | Integer | True if it is the last iteration, else false |
| loop.length | Integer | Number of total iterations |
| loop.index | Integer | Current index starting from 1 |
| loop.index0 | Integer | Current index starting from 0 |
| loop.depth | Integer | Current depth in a loop with 'recursive' tag.<br>Starts at level 1.<br>See Recursive for loop. |
| loop.depth0 | Integer | Current depth in a loop with 'recursive' tag.<br>Starts at level 0.<br>See Recursive for loop. |

To avoid trailing commas in loops use:

```jinja
{% if not loop.last %},{% endif %}
```

* Over list

| Input | Compiled |
| :----------- | :----------- |
| {% set my_list = ['sales_x', 'sales_y'] %}<br>SELECT<br>id,<br>{%- for col_name in my_list %}<br>SUM({{ col_name }})<br>{%- if not loop.last -%}, {%- endif -%}<br>{% endfor %}<br>FROM example<br>GROUP BY 1 | SELECT<br>id,<br>SUM(sales_x),<br>SUM(sales_y)<br>FROM example<br>GROUP BY 1 |

* Over dictionary

| Input | Compiled |
| :----------- | :----------- |
| {% set payment_methods = {"type_0" : "bank_transfer",<br>"type_1" : "credit_card",<br>"type_2" : "gift_card"} %}<br>SELECT<br>order_id,<br>{%- for type, column_name in payment_methods.items() %}<br>sum(CASE<br>WHEN payment_method = '{{type}}'<br>THEN amount end) as {{ column_name }}_amt<br>{%- if not loop.last -%}, {%- endif -%}<br>{%- endfor -%}<br>FROM example<br>GROUP BY 1 | SELECT<br>order_id,<br>sum(CASE<br>WHEN payment_method = 'type_0'<br>THEN amount END) AS bank_transfer_amt,<br>sum(CASE<br>WHEN payment_method = 'type_1'<br>THEN amount END) AS credit_card_amt,<br>sum(CASE<br>WHEN payment_method = 'type_2'<br>THEN amount END) AS gift_card_amt<br>FROM example<br>GROUP BY 1 |

For loop filtering

```jinja
{%- for item in ['hello', 42, 'world'] if item is string %}
```

## Exceptions

-- Warning

```jinja
{% do exceptions.warn("Warning message") %}
```

-- Error

```jinja
{{ exceptions.raise_compiler_error("Error message") }}
```

-- Not implemented

```jinja
{{ exceptions.raise_not_implemented('xxx not implemented for adapter '+adapter.type()) }}
```

## Call statement

Cf file://./dbt_internal_packages/dbt-adapters/macros/etc/statement.sql

```jinja
{% macro run_query(sql) %}
  {% call statement("run_query_statement", fetch_result=true, auto_begin=false) %}
    {{ sql }}
  {% endcall %}

  {% do return(load_result("run_query_statement").table) %}
{% endmacro %}
```

[statement blocks](https://docs.getdbt.com/reference/dbt-jinja-functions/statement-blocks)

Load_result returns a result having 3 keys (response, data, table).  
Table is a agate table  
It can be transformed in text with print_table()  
print_table(max_rows=None, max_columns=None) to print all rows and columns.

cf  
[agate table](https://agate.readthedocs.io/en/latest/api/table.html)  
[print agate table](https://agate.readthedocs.io/en/latest/api/table.html#agate.Table.print_table)

## Run query

```jinja
{% set results = run_query("select * from table") %}
{% do print(results.print_table()) %}
```

[run query](https://docs.getdbt.com/reference/dbt-jinja-functions/run_query)

Run_query returns a agate table object (Cf call statement).

## Trim whitespace

```jinja
{%- ... %}  Strips before
{%- ... -%} Strips before and after
```

## Debug

The debug() macro will open an iPython debugger in the context of a compiled dbt macro.  
The debug() macro is only available when using dbt Core CLI in a local development environment.  
It's not available in dbt platform.  
The DBT_ENGINE_MACRO_DEBUGGING environment variable must be set to use the debugger.

Usage:

```jinja
...
{{ debug() }}
...
```

```cmd
DBT_ENGINE_MACRO_DEBUGGING=write dbt compile
```

## Logging

Write to both the log file and stdout  
during Jinja rendering

```jinja
{{ log("Some text" ~ my_string, info=True) }}
```

Write only to the log file  
during Jinja rendering

```jinja
{{ log("Some text" ~ my_string) }}
```

## Print

print() function print messages to both the log file and standard output (stdout).

```jinja
{{ print("My Message") }}
```

## Defined variables

Using variables defined in dbt_project.yml  
or passed in --vars command-line argument

```jinja
SELECT *
FROM events
WHERE event_type = '{{ var("event_type") }}'
```

## Environment variables

Ypu can use .env file to define environment variables.  
Shell environment variables take precedence over values in .env  
.env values will not override variables already set in your shell.

```jinja
{{ env_var("VAR_NAME") }}
```

## Graph (dag)

```jinja
{% macro example() %}

  {% if execute %}
    {% for node in graph.nodes.values() %}
      {% do log(node.unique_id ~ ", config: " ~ node.config) %}
    {% endfor %}
  {% endif %}

{% endmacro %}
```

Cf [graph](https://docs.getdbt.com/reference/dbt-jinja-functions/graph)

## Macros

Macros are reusable code snippets (functions) written in Jinja

```jinja
{% macro cents_to_dollar(col_name, precision=2) %}
({{ col_name }} / 100)::numeric(16, {{ precision }})
{% endmacro %}
```

Run macro

```powershell
dbt run-operation <macro> --args '{example: value}'
```

Call a macro

```jinja
{{ my_macro(param01, param02) }}
```

Call a macro and get return value

```jinja
{% set some_var = my_macro(param01, param02, param03) %}
```

### Return

```jinja
{% macro example() %}
  {{ return("Hello") }}
{% endmacro %}
```

Without output :

```jinja
{% macro example() %}
  {% do return("Hello") }
{% endmacro %}
```

### Examples

Concat take a list. All list element have to be strings.

```jinja
{{ dbt.concat(["table_catalog", "'.'", "table_schema", "'.'", "table_name"]) }}
```

Casts  
Cf dbt_internal_packages/dbt-adapters/macros/utils/data_types.sql  
There is no dbt.type_date or dbt.type_datetime

```jinja
{{ dbt.cast('orders.ordered_at', 'date') }}
{{ dbt.cast('tax_rate', dbt.type_float()) }}
{{ dbt.cast('opened_at', dbt.type_string()) }}
{{ dbt.cast(dt_regex, dbt.type_timestamp()) }}
{{ dbt.cast('perishable', dbt.type_boolean()) }}
```

date_diff

```jinja
{{ dbt.datediff("order_date", my_current_timestamp(), "day") }}
```

Column values

```jinja
{%- set payment_methods = dbt_utils.get_column_values(    
    table=source('stripe','payment'),
    column='paymentmethod') -%}
```

## dbt_utils

dbt_utils is a collection of reusable dbt macros

Examples:

* deduplicate - remove duplicates from a model
* group_by - build a group by statement for (1..N)

## adapter

[adapter functions](https://docs.getdbt.com/reference/dbt-jinja-functions/adapter)

* adapter.dispatch
* adapter.get_missing_columns
* adapter.expand_target_column_types
* adapter.get_relation or load_relation
* adapter.get_columns_in_relation
* adapter.create_schema
* adapter.drop_schema
* adapter.drop_relation
* adapter.rename_relation
* adapter.quote
