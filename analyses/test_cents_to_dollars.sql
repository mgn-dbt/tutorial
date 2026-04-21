--dbt show -s test_cents_to_dollars

select {{ cents_to_dollars(139.9) }} as test_dollars