--dbt show -s test_safe_ratio
select {{ safe_ratio(1, 2) }} as test_safe_ratio
