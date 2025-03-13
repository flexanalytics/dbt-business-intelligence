select distinct
    order_number,
    order_line_number,
    order_date,
    status
from {{ source('salesforce', 'order_data_raw') }}
