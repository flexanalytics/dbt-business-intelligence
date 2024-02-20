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

{% docs product_monthly %}

Monthly product metrics using **Period over Period**, **Period to Date**, and **Rolling** secondary calculations

{% enddocs %}