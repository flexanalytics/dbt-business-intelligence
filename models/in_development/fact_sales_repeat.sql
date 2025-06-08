with
    sales_data as (
        select
            id,
            order_number,
            order_line_number,
            order_date,
            status,
            product_category,
            product_code,
            product_name,
            msrp,
            customer_code,
            customer_name,
            address,
            postal_code,
            region,
            country,
            contact_name,
            phone,
            email,
            latlng,
            quantity,
            price,
            sales,
            target,
            data_loaded_at
        from {{ ref('stg_sales_data') }}
    ),

    repeat_customers as (
        select customer_code
        from sales_data
        group by customer_code
        having count(*) > 1
    ),

    final as (
        select
            {{
                dbt_utils.generate_surrogate_key(
                    ['sales_data.customer_code','sales_data.order_number','sales_data.order_line_number','sales_data.product_code','sales_data.order_date']
                )
            }} as fact_sales_key,
            {{ dbt_utils.generate_surrogate_key(['sales_data.customer_code']) }} as customer_key,
            {{
                dbt_utils.generate_surrogate_key(
                    ['sales_data.order_number','sales_data.order_line_number']
                )
            }} as order_key,
            {{ dbt_utils.generate_surrogate_key(['sales_data.product_code']) }} as product_key,
            {{ dbt_utils.generate_surrogate_key(['sales_data.order_date']) }} as date_key,
            sales_data.order_date as date_day,
            sales_data.quantity,
            sales_data.price,
            sales_data.sales,
            sales_data.target
        from sales_data
        inner join repeat_customers
            on sales_data.customer_code = repeat_customers.customer_code

    )

select * from final
