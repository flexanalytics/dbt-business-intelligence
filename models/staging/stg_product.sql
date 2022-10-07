-- depends_on: {{ ref('stg_sales_data') }}

select distinct
    product_code
    , product_name
    , product_category
    , msrp
    --, max(order_date) OVER (PARTITION BY product_code ORDER BY order_date DESC) as recent_order_date --slowly changing dimension Type 1, using partition
    , (select max(order_date) from {{ source('salesforce', 'stg_sales_data') }} b where a.product_code = b.product_code) recent_order_date --slowly changing dimension Type 1, using subquery
    , (select min(order_date) from {{ source('salesforce', 'stg_sales_data') }} b where a.product_code = b.product_code) as first_order_date --slowly changing dimension Type 0, using subquery
from {{ source('salesforce', 'stg_sales_data') }} a