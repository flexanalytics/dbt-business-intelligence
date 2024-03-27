{{
    config(
        schema='staging',
        materialized='incremental',
        unique_key='order_number',
        incremental_strategy='merge',
        merge_update_columns=['order_line_number', 'status']
        )
}}

select
    {{
        dbt_utils.generate_surrogate_key(
            ['order_number','order_line_number']
        )
    }} id,
    order_number,
    order_line_number,
    order_date,
    status,
    product_category,
    product_code,
    product_name,
    msrp,
    customer_code,
    customer_name,
    address,
    postal_code,
    region,
    country,
    contact_name,
    phone,
    email,
    latlng,
    quantity,
    price,
    sales,
    target,
    {{ current_timestamp() }} data_loaded_at
from {{ ref('sales_data_raw') }}

{% if is_incremental() %}
    where order_date >= (select max(order_date) from {{ this }})
{% endif %}
