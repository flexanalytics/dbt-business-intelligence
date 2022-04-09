select
    {{ dbt_utils.surrogate_key(['customer_name','phone']) }} customer_key,
    *
from {{ ref('stg_customer') }}