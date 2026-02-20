{{ config ( materialized = 'table' ) }}

with
days as (
{% if target.type == 'postgres' %}
    {{ dbt.date_spine(
            datepart="day",
            start_date="'2000-01-01'::date",
            end_date="'2030-01-01'::date"
    ) }}
{% else %}
    {{ dbt.date_spine(
            datepart="day",
            start_date="'2000-01-01'",
            end_date="'2030-01-01'"
    ) }}
{% endif %}
),

final as (
    select cast(date_day as date) as date_day
    from days
)

select *
from final
where
    date_day > {{ dbt.dateadd("year", -11, my_current_timestamp() ) }}  -- Keep recent dates only
    and date_day < {{ dbt.dateadd("day", 30, my_current_timestamp() ) }}
