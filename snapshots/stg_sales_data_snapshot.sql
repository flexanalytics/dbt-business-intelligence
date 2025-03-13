{% snapshot stg_sales_data_snapshot %}
-- Using dbt updated at field as we want a new set of data everyday.
    {{
        config(
            target_schema='snapshots',
            unique_key='id',
            strategy='timestamp',
            updated_at='data_loaded_at',
            invalidate_hard_deletes=True
        )
    }}

    select
    {{
        dbt_utils.star(
            from=ref('int_sales')
        )
    }}
    from {{ ref('int_sales') }}

{% endsnapshot %}
