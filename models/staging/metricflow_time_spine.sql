{{
    config(
        materialized = 'table',
    )
}}

select date_day from {{ ref('stg_date_dimension') }}
