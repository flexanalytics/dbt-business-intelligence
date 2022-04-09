select
    {{ dbt_utils.surrogate_key(['date_day']) }} date_key,
    *
from {{ ref('stg_date_dimension') }}