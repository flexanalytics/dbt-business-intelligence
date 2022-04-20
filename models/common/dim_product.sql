{{
  config(
    post_hook='{{ postgres_create_index(this, "product_key") }}'
  )
}}

select
    {{ dbt_utils.surrogate_key(['product_code']) }} product_key,
    *
from {{ ref('stg_product') }}