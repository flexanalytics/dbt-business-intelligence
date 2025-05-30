select distinct
    product_code,
    product_name,
    product_category,
    msrp,
    --, max(order_date) OVER (PARTITION BY product_code ORDER BY order_date DESC) as recent_order_date --slowly changing dimension Type 1, using partition
    --slowly changing dimension Type 1, using subquery
    (
        select max(order_date)
        from {{ source('salesforce', 'sales_data') }} as b
        where a.product_code = b.product_code
    ) as recent_order_date,
    --slowly changing dimension Type 0, using subquery
    (
        select min(order_date)
        from {{ source('salesforce', 'sales_data') }} as b
        where a.product_code = b.product_code
    ) as first_order_date
from {{ source('salesforce', 'sales_data') }} as a
