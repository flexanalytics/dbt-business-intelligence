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

    final as (
        select
            {{
                dbt_utils.generate_surrogate_key(
                    ['customer_code','order_number','order_line_number','product_code','order_date']
                )
            }} as fact_sales_key,
            {{ dbt_utils.generate_surrogate_key(['customer_code']) }} as customer_key,
            {{
                dbt_utils.generate_surrogate_key(
                    ['order_number','order_line_number']
                )
            }} as order_key,
            {{ dbt_utils.generate_surrogate_key(['product_code']) }} as product_key,
            {{ dbt_utils.generate_surrogate_key(['order_date']) }} as date_key,
            order_date as date_day,
            quantity,
            price,
            sales,
            target,
            (target - sales) as actual_vs_target
        from sales_data

    )

select * from final
