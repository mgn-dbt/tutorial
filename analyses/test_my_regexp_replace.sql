--dbt show -s test_my_regexp_replace

select {{ my_regexp_replace(string_literal("2026-04-21T00:00:00"), '^(\d{4}-\d{2}-\d{2}).*', '\1') }} as test_date