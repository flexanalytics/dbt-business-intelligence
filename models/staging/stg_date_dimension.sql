-- depends_on: {{ ref('stg_sales_data') }}

{%- call statement('date_range_query', fetch_result=True) -%}
    select
        min(order_date) min_date,
        cast({{ dateadd(datepart='day', interval=1, from_date_or_timestamp="max(order_date)") }} as date) max_date
    from {{ ref('stg_sales_data') }}
{%- endcall -%}

{%- set start_date = load_result('date_range_query')['data'][0][0] -%}
{%- set end_date = load_result('date_range_query')['data'][0][1] -%}

{{ dbt_date.get_date_dimension(start_date, end_date) }}