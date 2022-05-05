-- depends_on: {{ ref('stg_sales_data') }}

select distinct
    customer_code,
    customer_name,
    address,
    postal_code,
    country,
    {{ dbt_utils.split_part('latlng', "','", 1) }} latitude,
    {{ dbt_utils.split_part('latlng', "','", 2) }} longitude,
    contact_name,
    phone,
    email
from {{ source('salesforce', 'stg_sales_data') }}