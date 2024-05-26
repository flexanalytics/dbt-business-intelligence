-- depends_on: {{ ref('stg_sales_data') }}

select distinct
    order_number,
    order_line_number,
    order_date,
    status
from {{ source('salesforce', 'stg_sales_data') }}
