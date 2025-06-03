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
    email,
    --slowly changing dimension Type 1, using subquery
    (
        select max(order_date)
        from {{ source('salesforce', 'stg_sales_data') }} as b
        where a.customer_code = b.customer_code
    ) as recent_order_date,
    --slowly changing dimension Type 0, using subquery
    (
        select min(order_date)
        from {{ source('salesforce', 'stg_sales_data') }} as b
        where a.customer_code = b.customer_code
    ) as first_order_date
from {{ source('salesforce', 'stg_sales_data') }} as a
