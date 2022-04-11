select distinct
    customer_name,
    phone,
    address_line_1,
    address_line_2,
    city,
    state,
    postal_code,
    country,
    territory,
    contact_last_name,
    contact_first_name
from {{ source('salesforce', 'stg_sales_data') }}