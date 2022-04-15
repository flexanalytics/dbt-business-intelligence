-- depends_on: {{ ref('stg_sales_data') }}

select distinct
    product_code,
    product_name,
    product_category,
    msrp
from {{ source('salesforce', 'stg_sales_data') }}