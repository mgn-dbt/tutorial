-- macros/incremental_filter.sql
{%- macro incremental_filter(timestamp_column, interval_days=0) -%}
    {%- if is_incremental() -%}
        where {{ timestamp_column }} >= (
            select coalesce(max({{ timestamp_column }}), {{ dbt.date(1900,1,1) }}) - {{ interval_days }}
            {#- { dbt.dateadd("day", - interval_days, "max(" ~ timestamp_column ~ ")") } #}
            from {{ this }} )
    {%- endif -%}
{%- endmacro -%}
