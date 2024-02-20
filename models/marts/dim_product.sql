select
    {{ dbt_utils.generate_surrogate_key(['product_code']) }} product_key,
    *
from {{ ref('stg_product') }}