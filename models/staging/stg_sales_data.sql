{{ config(schema='staging', materialized='table') }}

select
    {{ dbt_utils.surrogate_key(['order_number','order_line_number']) }} id,
    *,
    {{ current_timestamp() }} data_loaded_at
from {{ ref('sales_data_raw') }}