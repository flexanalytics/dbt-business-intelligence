{{ config(materialized='external', location='/db/edw/dim_order.parquet') }}

select
    {{
        dbt_utils.generate_surrogate_key(
            ['order_number','order_line_number']
            )
    }} order_key,
    order_number,
    order_line_number,
    order_date,
    status
from {{ ref('int_order') }}
