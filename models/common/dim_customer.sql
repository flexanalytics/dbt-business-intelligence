select
    {{ dbt_utils.surrogate_key(['customer_code']) }} customer_key,
    *
from {{ ref('stg_customer') }}