select
    {{ dbt_utils.surrogate_key(['order_number','order_line_number']) }} id,
    *,
    {{ dbt_utils.current_timestamp() }} data_loaded_at
from {{ ref('sales_data_raw') }}