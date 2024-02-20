select
    {{ dbt_utils.generate_surrogate_key(['customer_code']) }} customer_key,
    *
from {{ ref('stg_customer') }}