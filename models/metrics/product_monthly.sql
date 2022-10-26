 -- depends_on: {{ ref('fact_sales') }}

with product_metrics as (

    select *
    from
    {{ 
        metrics.calculate(
            metric('sales'),
            grain='month',
            dimensions=['product_key'],
            secondary_calculations=[
                metrics.period_over_period(comparison_strategy="ratio", interval=1),
                metrics.period_over_period(comparison_strategy="difference", interval=1),

                metrics.period_to_date(aggregate="average", period="month"),
                metrics.period_to_date(aggregate="sum", period="year"),

                metrics.rolling(aggregate="average", interval=6),
                metrics.rolling(aggregate="min", interval=6)
            ],
        ) 
    }}

),

products as (

    select * from {{ ref('dim_product') }}

)

select
    products.product_category,
    products.product_name,
    product_metrics.*
from product_metrics inner join products
    on product_metrics.product_key = products.product_key