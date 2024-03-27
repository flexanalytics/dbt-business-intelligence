select
    {{ dbt_utils.generate_surrogate_key(['customer_code']) }} customer_key,
    customer_code,
    customer_name,
    address,
    postal_code,
    country,
    latitude,
    longitude,
    contact_name,
    phone,
    email
from {{ ref('stg_customer') }}
