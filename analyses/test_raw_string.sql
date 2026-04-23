--dbt show -s test_raw_string
{#
\1 is interpreted with SOH caracter "\u0001" by jinja
To prevent it use double backslash \\1
#}

select
    regexp_replace(
        '2026-04-21T00:00:00',
        {{ raw_string('^(\d{4}-\d{2}-\d{2}).*') }},
        {{ raw_string('\\1') }}
    ) as test_date
