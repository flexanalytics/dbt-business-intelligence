select distinct
    product_code,
    product_name,
    product_category,
    msrp,
    max(order_date) over (partition by product_code) as recent_order_date, --slowly changing dimension type 1, using partition
    min(order_date) over (partition by product_code) as first_order_date --slowly changing dimension type 0, using partition
from {{ source('salesforce', 'product') }} as a
