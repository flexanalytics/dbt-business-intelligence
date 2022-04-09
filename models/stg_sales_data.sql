select 
    *,
    {{ dbt_utils.current_timestamp() }} data_loaded_at
from {{ ref('sales_data_raw') }}