--dbt show -s test_cents_to_dollars

select {{ cents_to_dollars(130.989, 2) }} as test_dollars
