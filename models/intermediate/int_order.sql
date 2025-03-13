select distinct
    order_number,
    order_line_number,
    cast(order_date as date) as order_date,
    status
from {{ ref('stg_order') }}
