select
    {{ dbt_utils.surrogate_key(['product_code']) }} product_key,
    *
from {{ ref('stg_product') }}