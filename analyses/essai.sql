--dbt show -s essai
select {{ safe_ratio(1, 2) }} as test_safe_ratio
