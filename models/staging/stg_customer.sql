-- depends_on: {{ ref('stg_sales_data') }}

select distinct
    customer_code,
    customer_name,
    address,
    postal_code,
    country,
    {{ split_part('latlng', "','", 1) }} latitude,
    {{ split_part('latlng', "','", 2) }} longitude,
    contact_name,
    phone,
    email
from {{ source('salesforce', 'stg_sales_data') }}