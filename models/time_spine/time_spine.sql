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
    select {{ dbt.cast('date_day', 'date') }} as date_day
    from days
)

select *
from final
where
    -- Keep recent dates only
    date_day > {{ dbt.dateadd("year", -11, my_current_timestamp() ) }}
    and date_day < {{ dbt.dateadd("day", 30, my_current_timestamp() ) }}
