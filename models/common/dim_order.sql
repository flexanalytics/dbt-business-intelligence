{{
  config(
    post_hook='{{ postgres_create_index(this, "order_key") }}'
  )
}}

select
    {{ dbt_utils.surrogate_key(['order_number','order_line_number']) }} order_key,
    *
from {{ ref('stg_order') }}