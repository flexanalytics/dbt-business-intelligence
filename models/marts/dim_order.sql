select
    {{ dbt_utils.generate_surrogate_key(['order_number','order_line_number']) }} order_key,
    *
from {{ ref('stg_order') }}