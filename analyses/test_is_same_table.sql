select 1 as one

{# 

{% set columns_to_compare = '
    identifier::string
    , name::string
    , nb_ordered::number
    , global_turnover::number
    , global_profit::number
    , hour::timestamp' 
%}

{{ is_same_table('restaurants__benefit_orders_hourly', 'expect_restaurants__benefit_orders_hourly', columns_to_compare) }} 

#}
