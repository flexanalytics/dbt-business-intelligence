-- NULL as fact table foreign key: https://www.kimballgroup.com/2003/02/design-tip-43-dealing-with-nulls-in-the-dimensional-model/
{{ config(
    post_hook=[
      "insert into {{ this }} values ({{ dbt_utils.surrogate_key(['-1']) }},'Unknown','Unknown','Unknown','Unknown','Unknown','Unknown','Unknown','Unknown','Unknown','Unknown')"
    ]
) }}

select
    {{ dbt_utils.surrogate_key(['customer_code']) }} customer_key,
    *
from {{ ref('stg_customer') }}