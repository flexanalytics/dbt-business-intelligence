{{
  config(
    indexes=[
      {'columns': ['customer_key', 'order_key', 'product_key', 'date_key'], 'unique': True},
    ]
  )
}}

with customer as (

    select * from {{ ref('dim_customer') }}

),

orders as (

    select * from {{ ref('dim_order') }}

),

product as (

    select * from {{ ref('dim_product') }}

),

dim_date as (

    select * from {{ ref('dim_date') }}

),

sales_data as (

    select * from {{ ref('stg_sales_data') }}

),

final as (

    select
        customer.customer_key,
        orders.order_key,
        product.product_key,
        dim_date.date_key,
        dim_date.date_day,
        sales_data.quantity,
        sales_data.price,
        sales_data.sales,
        sales_data.target
    from sales_data
        inner join customer
            on customer.customer_name = sales_data.customer_name
                and customer.phone = sales_data.phone
        inner join orders
            on orders.order_number = sales_data.order_number
                and orders.order_line_number = sales_data.order_line_number
        inner join product
            on product.product_code = sales_data.product_code
        inner join dim_date
            on dim_date.date_day = sales_data.order_date

)

select * from final