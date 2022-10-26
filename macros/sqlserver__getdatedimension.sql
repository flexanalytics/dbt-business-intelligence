{% macro sqlserver__date_part(datepart, date) -%}

    {%- if datepart == "dayofweek" -%}
        datepart = "WEEKDAY"
    {%- elif datepart == "isoweek" -%}
        datepart = "ISO_WEEK"
    {%- endif -%}

    datepart({{ datepart }}, {{  date }})
{%- endmacro %}

{%- macro sqlserver__week_end(date) -%}
    {%- set dt = dbt_date.week_start(date) -%}
    {{ dbt_date.n_days_away(6, dt) }}
{%- endmacro %}

{% macro sqlserver__date_spine_sql(datepart, start_date, end_date) %}


    with

    l0 as (

        select c
        from (select 1 union all select 1) as d(c)

    ),
    l1 as (

        select
            1 as c
        from l0 as a
        cross join l0 as b

    ),

    l2 as (

        select 1 as c
        from l1 as a
        cross join l1 as b
    ),

    l3 as (

        select 1 as c
        from l2 as a
        cross join l2 as b
    ),

    l4 as (

        select 1 as c
        from l3 as a
        cross join l3 as b
    ),

    l5 as (

        select 1 as c
        from l4 as a
        cross join l4 as b
    ),

    nums as (

        select row_number() over (order by (select null)) as rownum
        from l5
    ),

    rawdata as (

        select top ({{datediff(start_date, end_date, datepart)}}) rownum -1 as n
        from nums
        order by rownum
    ),

    all_periods as (

        select (
            {{
                dateadd(
                    datepart,
                    'n',
                    start_date
                )
            }}
        ) as date_{{datepart}}
        from rawdata
    ),

    filtered as (

        select *
        from all_periods
        where date_{{datepart}} <= {{ end_date }}

    )

    select * from filtered

{% endmacro %}


{% macro sqlserver__date_spine(datepart, start_date, end_date) -%}

    {% set date_spine_query %}

        {{tsql_utils.sqlserver__date_spine_sql(datepart, start_date, end_date)}} order by 1

    {% endset %}


    {% set results = run_query(date_spine_query) %}

    {% if execute %}

    {% set results_list = results.columns[0].values() %}
    
    {% else %}

    {% set results_list = [] %}

    {% endif %}

    {%- for date_field in results_list %}
        select '{{ date_field }}' as date_{{datepart}} {{ 'union all ' if not loop.last else '' }}
    {% endfor -%}

{% endmacro %}

{% macro sqlserver__get_date_dimension(start_date, end_date) %}

{%- set start_date="cast('" ~ start_date ~ "' as " ~ type_timestamp() ~ ")" -%}
{%- set end_date="cast('" ~ end_date ~ "' as " ~ type_timestamp() ~ ")"  -%}

with base_dates as (

    {{ dbt_utils.date_spine(
        datepart="day",
        start_date=start_date,
        end_date=end_date
    )
    }}

),
dates_with_prior_year_dates as (

    select
        cast(d.date_day as date) as date_day,
        cast({{ dateadd('year', -1 , 'd.date_day') }} as date) as prior_year_date_day,
        cast({{ dateadd('day', -364 , 'd.date_day') }} as date) as prior_year_over_year_date_day
    from
    	base_dates d

)
select
    d.date_day,
    {{ dbt_date.yesterday('d.date_day') }} as prior_date_day,
    {{ dbt_date.tomorrow('d.date_day') }} as next_date_day,
    d.prior_year_date_day as prior_year_date_day,
    d.prior_year_over_year_date_day,

    DATEPART(WEEKDAY, d.date_day) as day_of_week,
    DATEPART(WEEKDAY, d.date_day) as day_of_week_iso,
    DATENAME(WEEKDAY, d.date_day) as day_of_week_name,
    LEFT(DATENAME(WEEKDAY, d.date_day), 3) as day_of_week_name_short,
    /*
    {{ dbt_date.day_of_week('d.date_day', isoweek=false) }} as day_of_week,
    {{ dbt_date.day_of_week('d.date_day', isoweek=true) }} as day_of_week_iso,
    {{ dbt_date.day_name('d.date_day', short=false) }} as day_of_week_name,
    {{ dbt_date.day_name('d.date_day', short=true) }} as day_of_week_name_short,
    */
    {{ dbt_date.day_of_month('d.date_day') }} as day_of_month,
    {{ dbt_date.day_of_year('d.date_day') }} as day_of_year,

    {{ dbt_date.week_start('d.date_day') }} as week_start_date,
    {{ dbt_date.week_end('d.date_day') }} as week_end_date,
    {{ dbt_date.week_start('d.prior_year_over_year_date_day') }} as prior_year_week_start_date,
    {{ dbt_date.week_end('d.prior_year_over_year_date_day') }} as prior_year_week_end_date,
    {{ dbt_date.week_of_year('d.date_day') }} as week_of_year,

    /*
    {{ dbt_date.iso_week_start('d.date_day') }} as iso_week_start_date,
    {{ dbt_date.iso_week_end('d.date_day') }} as iso_week_end_date,
    {{ dbt_date.iso_week_start('d.prior_year_over_year_date_day') }} as prior_year_iso_week_start_date,
    {{ dbt_date.iso_week_end('d.prior_year_over_year_date_day') }} as prior_year_iso_week_end_date,
    {{ dbt_date.iso_week_of_year('d.date_day') }} as iso_week_of_year,
    */

    {{ dbt_date.week_of_year('d.prior_year_over_year_date_day') }} as prior_year_week_of_year,
    /*
    {{ dbt_date.iso_week_of_year('d.prior_year_over_year_date_day') }} as prior_year_iso_week_of_year,
    */
    cast({{ dbt_date.date_part('month', 'd.date_day') }} as {{ type_int() }}) as month_of_year,
    
    DATENAME(MONTH, d.date_day) as month_name,
    LEFT(DATENAME(MONTH, d.date_day), 3) as month_name_short,
    /*
    {{ dbt_date.month_name('d.date_day', short=false) }}  as month_name,
    {{ dbt_date.month_name('d.date_day', short=true) }}  as month_name_short,
    */

    cast({{ date_trunc('month', 'd.date_day') }} as date) as month_start_date,
    cast({{ last_day('d.date_day', 'month') }} as date) as month_end_date,

    cast({{ date_trunc('month', 'd.prior_year_date_day') }} as date) as prior_year_month_start_date,
    cast({{ last_day('d.prior_year_date_day', 'month') }} as date) as prior_year_month_end_date,

    cast({{ dbt_date.date_part('quarter', 'd.date_day') }} as {{ type_int() }}) as quarter_of_year,
    cast({{ date_trunc('quarter', 'd.date_day') }} as date) as quarter_start_date,
    cast({{ last_day('d.date_day', 'quarter') }} as date) as quarter_end_date,

    cast({{ dbt_date.date_part('year', 'd.date_day') }} as {{ type_int() }}) as year_number,
    cast({{ date_trunc('year', 'd.date_day') }} as date) as year_start_date,
    cast({{ last_day('d.date_day', 'year') }} as date) as year_end_date
from
    dates_with_prior_year_dates d

{% endmacro %}
