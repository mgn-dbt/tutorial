{{ config ( materialized = 'table' ) }}

with
days_spine as (
    {% if target.type == 'postgres' %}
        {{ dbt.date_spine(
                datepart="day",
                start_date="'2000-01-01'::date",
                end_date="'2030-01-01'::date"
        ) }}
    {% elif target.type == 'duckdb' %}
        {{ dbt.date_spine(
                datepart="day",
                start_date="'2000-01-01'::timestamp",
                end_date="'2030-01-01'::timestamp"
        ) }}
    {% elif target.type == 'bigquery' %}
        select cast(date_day as date) as date_day
        from ({{ dbt.date_spine(
                datepart="day",
                start_date="'2000-01-01'",
                end_date="'2030-01-01'"
        ) }}) as dt
    {% else %}
        {{ exceptions.raise_compiler_error("Time spine not implemented for target type: " ~ target.type) }}
    {% endif %}
)

select *
from days_spine
where
    -- Keep recent dates only
    date_day > {{ dbt.dateadd("year", -11, my_current_timestamp() ) }}
    and date_day < {{ dbt.dateadd("day", 30, my_current_timestamp() ) }}
