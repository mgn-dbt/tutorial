
{%- macro incremental_filter(timestamp_column, interval_days=0) -%}
    {%- if is_incremental() -%}
        {{ timestamp_column }} >= (
            select coalesce(
                {#- { dbt.dateadd("day", - interval_days, "max(" ~ timestamp_column ~ ")") }, #}
                max({{ timestamp_column }}) - {{ interval_days }},
                {{ my_make_date(1900,1,1) }})
            from {{ this }} )
    {%- else -%}
        1=1
    {%- endif -%}
{%- endmacro -%}
