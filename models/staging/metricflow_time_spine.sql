{{
    config(
        materialized = 'table',
    )
}}

with days as (

    {{
        dbt.date_spine(
            'day',
            "convert(date, '01/01/2000', 101)",
            "convert(date, '01/01/2027', 101)"
        )
    }}

),

final as (
    select cast(date_day as date) as date_day
    from days
)

select * from final
