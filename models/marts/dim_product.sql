select
    {{ dbt_utils.generate_surrogate_key(['product_code']) }} product_key,
    product_code,
    product_name,
    product_category,
    msrp,
    recent_order_date,
    first_order_date
from {{ ref('stg_product') }}
