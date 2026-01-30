{{ 
    config (
        materialized = 'table',
    )
}}

with
days as (
    {{ 
        dbt.date_spine(
            datepart="day",
            start_date="cast('2000-01-01' as date)",
            end_date="cast('2030-01-01' as date)"
        )
    }}
),

final as (
    select cast(date_day as date) as date_day
    from days
)

select *
from final
where
    date_day > {{ dbt.dateadd("year", -5, current_timestamp()) }}  -- Keep recent dates only
    and date_day < {{ dbt.dateadd("day", 30, current_timestamp()) }}
