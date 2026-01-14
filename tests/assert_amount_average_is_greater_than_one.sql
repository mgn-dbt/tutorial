{{ config(enabled = false) }}

select
    customer_id, 
    avg(amount) as average_amount
from {{ ref('fct_orders') }}
group by 1
having average_amount < 1
--and count(customer_id) > 1