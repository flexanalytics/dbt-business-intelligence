select distinct
    product_code,
    product_name,
    product_category,
    msrp,
    order_date
from {{ source('salesforce', 'product_data_raw') }}
