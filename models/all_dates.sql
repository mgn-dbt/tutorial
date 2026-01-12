{{ config (
    materialized="table"
)}}

--dbt1000: Detected unsafe introspection which may lead to non-deterministic static analysis. 
--To suppress this warning, set static_analysis to 'unsafe' in the nodes' configuration. 
--Learn more: https://docs.getdbt.com/docs/fusion/new-concepts. 
--Nodes: 'model.jaffle_shop.all_dates' (execute)
{{ dbt_utils.date_spine(
    datepart="day",
    start_date="cast('2025-01-01' as date)",
    end_date="cast('2030-01-01' as date)"
   )
}}
