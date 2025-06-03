select distinct
    product_code,
    product_name,
    product_category,
    msrp,
<<<<<<< HEAD
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
||||||| parent of b3784681 (update first and recent product order date to use window function)
    --, max(order_date) OVER (PARTITION BY product_code ORDER BY order_date DESC) as recent_order_date --slowly changing dimension Type 1, using partition
    --slowly changing dimension Type 1, using subquery
    (
        select max(order_date)
        from {{ source('salesforce', 'stg_sales_data') }} as b
        where a.product_code = b.product_code
    ) as recent_order_date,
    --slowly changing dimension Type 0, using subquery
    (
        select min(order_date)
        from {{ source('salesforce', 'stg_sales_data') }} as b
        where a.product_code = b.product_code
    ) as first_order_date
from {{ source('salesforce', 'stg_sales_data') }} as a
=======
    max(order_date) over (partition by product_code order by order_date desc) as recent_order_date, --slowly changing dimension type 1, using partition
    min(order_date) over (partition by product_code order by order_date asc) as first_order_date --slowly changing dimension type 0, using partition
from {{ source('salesforce', 'stg_sales_data') }} as a
>>>>>>> b3784681 (update first and recent product order date to use window function)
