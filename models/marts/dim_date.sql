select
    {{ dbt_utils.generate_surrogate_key(['date_day']) }} date_key,
    week_start_date as date_week,
    month_start_date as date_month,
    quarter_start_date as date_quarter,
    year_start_date as date_year,
    {{
      dbt_utils.star(
        from=ref('stg_date_dimension'),
        except=["week_start_date", "month_start_date", "quarter_start_date", "year_start_date"]
      )
    }}
from {{ ref('stg_date_dimension') }}
