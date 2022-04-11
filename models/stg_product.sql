{{ config(schema='staging') }}

select distinct
    product_code,
    product_name,
    product_category,
    msrp
from {{ source('salesforce', 'stg_sales_data') }}