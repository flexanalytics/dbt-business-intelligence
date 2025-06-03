{% docs fact_sales %}

| Metric         | Definition                                       |
|----------------|--------------------------------------------------|
| quantity       | Sum of quantity sold                             |
| price          | Average price for an ordered product             |
| sales          | Sum of total sales revenue                       |
| target         | Sum of target sales revenue                      |

{% enddocs %}

{% docs dim_customer %}
Customer (sometimes known as a client, buyer, or purchaser) is the recipient of a good, service, product or an idea - obtained from a seller, vendor, or supplier via a financial transaction or exchange for money or some other valuable consideration. [Click here](https://en.wikipedia.org/wiki/Customer) for more information.
{% enddocs %}

{% docs dim_order %}
Detailed information about a customer purchase of product(s) such as order date and status
{% enddocs %}

{% docs dim_product %}
Detailed information about products in the following categories:
* Classic Cars
* Motorcycles
* Planes
* Ships
* Trains
* Trucks and Buses
* Vintage Cars
{% enddocs %}

{% docs dim_date %}
The Order Date dimension allows you to analyze metrics across time periods at many levels of granularity (year, quarter, month, day).
{% enddocs %}

{% docs dim_date__date_day %}
The calendar date in `YYYY-MM-DD` format.
{% enddocs %}

{% docs dim_date__prior_date_day %}
The date preceding `date_day` by one day.
{% enddocs %}

{% docs dim_date__next_date_day %}
The date following `date_day` by one day.
{% enddocs %}

{% docs dim_date__prior_year_date_day %}
The same calendar day in the previous year.
{% enddocs %}

{% docs dim_date__prior_year_over_year_date_day %}
The date used to compare year-over-year performance, typically aligning weeks.
{% enddocs %}

{% docs dim_date__day_of_week %}
Numeric representation of the day of the week, where Monday = 1 and Sunday = 7.
{% enddocs %}

{% docs dim_date__day_of_week_name %}
Full name of the day of the week (e.g., "Monday").
{% enddocs %}

{% docs dim_date__day_of_week_name_short %}
Abbreviated name of the day of the week (e.g., "Mon").
{% enddocs %}

{% docs dim_date__day_of_month %}
Day number within the month (1–31).
{% enddocs %}

{% docs dim_date__day_of_year %}
Day number within the year (1–365).
{% enddocs %}

{% docs dim_date__date_week %}
Start date of the week (`YYYY-MM-DD`), typically a Sunday.
{% enddocs %}

{% docs dim_date__week_end_date %}
End date of the week (`YYYY-MM-DD`), typically a Saturday.
{% enddocs %}

{% docs dim_date__prior_year_week_start_date %}
Week start date corresponding to the same week in the previous year.
{% enddocs %}

{% docs dim_date__prior_year_week_end_date %}
Week end date corresponding to the same week in the previous year.
{% enddocs %}

{% docs dim_date__week_of_year %}
Calendar week number of the year (1–53).
{% enddocs %}

{% docs dim_date__iso_week_start_date %}
Start date of the ISO week, which begins on Monday.
{% enddocs %}

{% docs dim_date__iso_week_end_date %}
End date of the ISO week, which ends on Sunday.
{% enddocs %}

{% docs dim_date__prior_year_iso_week_start_date %}
Start date of the corresponding ISO week in the prior year.
{% enddocs %}

{% docs dim_date__prior_year_iso_week_end_date %}
End date of the corresponding ISO week in the prior year.
{% enddocs %}

{% docs dim_date__iso_week_of_year %}
ISO 8601 week number of the year (1–53).
{% enddocs %}

{% docs dim_date__prior_year_week_of_year %}
Calendar week number for the same week in the prior year.
{% enddocs %}

{% docs dim_date__prior_year_iso_week_of_year %}
ISO week number for the same ISO week in the prior year.
{% enddocs %}

{% docs dim_date__month_of_year %}
Month number (1 = January, 12 = December).
{% enddocs %}

{% docs dim_date__month_name %}
Full name of the month (e.g., "January").
{% enddocs %}

{% docs dim_date__month_name_short %}
Abbreviated name of the month (e.g., "Jan").
{% enddocs %}

{% docs dim_date__date_month %}
First day of the month (`YYYY-MM-DD`).
{% enddocs %}

{% docs dim_date__month_end_date %}
Last day of the month (`YYYY-MM-DD`).
{% enddocs %}

{% docs dim_date__prior_year_month_start_date %}
First day of the same month in the previous year.
{% enddocs %}

{% docs dim_date__prior_year_month_end_date %}
Last day of the same month in the previous year.
{% enddocs %}

{% docs dim_date__quarter_of_year %}
Quarter number of the year (1–4).
{% enddocs %}

{% docs dim_date__date_quarter %}
First day of the quarter (`YYYY-MM-DD`).
{% enddocs %}

{% docs dim_date__quarter_end_date %}
Last day of the quarter (`YYYY-MM-DD`).
{% enddocs %}

{% docs dim_date__year_number %}
Four-digit calendar year (e.g., 2025).
{% enddocs %}

{% docs dim_date__date_year %}
First day of the year (`YYYY-MM-DD`).
{% enddocs %}

{% docs dim_date__year_end_date %}
Last day of the year (`YYYY-MM-DD`).
{% enddocs %}
