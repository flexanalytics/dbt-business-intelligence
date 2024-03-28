-- depends_on: {{ ref('stg_sales_data') }}

{{
    config(
        schema='staging',
        materialized='incremental',
        unique_key='order_number',
        incremental_strategy='merge',
        merge_update_columns=['order_line_number', 'status']
    )
}}

select distinct
    order_number,
    order_line_number,
    order_date,
    status
from {{ source('salesforce', 'stg_sales_data') }}

{% if is_incremental() %}
    where order_date >= (select max(order_date) from {{ this }})
{% endif %}
