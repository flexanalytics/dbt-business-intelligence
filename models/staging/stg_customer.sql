-- depends_on: {{ ref('stg_sales_data') }}

select distinct
    customer_code,
    customer_name,
    address,
    postal_code,
    country,
    {{ split_part('latlng', "','", 1) }} latitude,
    {{ split_part('latlng', "','", 2) }} longitude,
    region,
    contact_name,
    phone,
    email,
    max(order_date) over (partition by customer_code) as recent_order_date, --slowly changing dimension type 1, using partition
    min(order_date) over (partition by customer_code) as first_order_date --slowly changing dimension type 0, using partition
from {{ source('salesforce', 'stg_sales_data') }}
