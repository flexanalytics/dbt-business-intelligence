with customer as (

    select * from {{ ref('dim_customer') }}

),

orders as (

    select * from {{ ref('dim_order') }}

),

product as (

    select * from {{ ref('dim_product') }}

),

sales_data as (

    select * from {{ ref('stg_sales_data') }}

),

final as (

    select
        customer.customer_key,
        orders.order_key,
        product.product_key,
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

)

select * from final