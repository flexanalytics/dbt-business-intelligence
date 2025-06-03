-- depends_on: {{ ref('stg_sales_data') }}

select distinct
    product_code,
    product_name,
    product_category,
    msrp,
    max(order_date) over (partition by product_code order by order_date desc) as recent_order_date, --slowly changing dimension type 1, using partition
    min(order_date) over (partition by product_code order by order_date asc) as first_order_date --slowly changing dimension type 0, using partition
from {{ source('salesforce', 'stg_sales_data') }} as a
