# dbt Business Intelligence

**Business Intelligence standards for integrating with dbt**

This project shows how to structure dbt to enable analytics in a business intelligence (BI) tool for reporting and dashboarding without the need for defining metadata in the BI tool ("Metadata-less BI"). In short, remove the "black box" of BI by pushing the semantic layer down to dbt and enabling all BI tools to speak the same language in a standardized metadata-less BI experience.

The project also highlights dimensional modeling (star schema) techniques using the Kimball methodology.

Tested on both **dbt Core** and **dbt Cloud** versions 1.0+. Database agnostic and has been tested with the **Postgres**, **BigQuery**, **Snowflake**, and **Redshift** [adapters](https://docs.getdbt.com/docs/available-adapters).

## Create dbt Project

If you're just getting started learning dbt, then you may want to look at Getting Started with [dbt Core](https://docs.getdbt.com/tutorial/learning-more/getting-started-dbt-core) or [dbt Cloud](https://docs.getdbt.com/tutorial/getting-started)


### Choose a database

* **BigQuery** - follow the [dbt BigQuery instructions](https://docs.getdbt.com/tutorial/getting-set-up/setting-up-bigquery#operation/get-account-run) to set up a BigQuery account and connect dbt

* **Snowflake** - follow the [dbt Snowflake instructions](https://docs.getdbt.com/tutorial/getting-set-up/setting-up-snowflake) to set up a Snowflake trial account and connect dbt

* **Redshift** - follow the [dbt Redshift instructions](https://docs.getdbt.com/tutorial/getting-set-up/setting-up-redshift) to set up a Redshift trial account and connect dbt

* **Postgres** - follow these [instructions](https://dev.to/prisma/how-to-setup-a-free-postgresql-database-on-heroku-1dc1) to set up a free Postgres instance on Heroku


### dbt Client

To run this project (assuming you have dbt installed):

1. Clone this repo
2. [Set up a profile](https://docs.getdbt.com/reference/profiles.yml) to connect to your database
3. Run `dbt deps`
4. Run `dbt seed`
5. Run `dbt run`
6. Run `dbt source freshness`
7. Run `dbt docs generate`
8. Run `dbt docs serve` (if you want to run a local docs server)

### dbt Cloud

1. [Login to dbt](https://cloud.getdbt.com/login) or [Signup for a new](https://cloud.getdbt.com/signup/) dbt Account
    
    > Team Account ([free trial](https://www.getdbt.com/pricing/)) is required for BI tools to use the Metadata API

    > First time using dbt Cloud? Review the [dbt Cloud Quickstart](https://docs.getdbt.com/docs/dbt-cloud/cloud-quickstart) guide

2. Create a new project

    a. **New** accounts create a new project immediately

    b. **Existing** accounts need to go to "Account Settings > Projects" and click **New Project**

3. Give the project a name, e.g. "Sales Project"

4. [Create a connection](https://docs.getdbt.com/docs/dbt-cloud/cloud-quickstart#create-a-connection) to either Snowflake, BigQuery, PostgreSQL or Redshift

5. [Connect a repository](https://docs.getdbt.com/docs/dbt-cloud/cloud-quickstart#connect-a-repository) with either **Git Clone** or **Github**

    a. **Git Clone** - enter *Git URL* as `https://github.com/flexanalytics/dbt-business-intelligence`

    b. **Github** - fork this repo, set up a [dbt GitHub connection](https://docs.getdbt.com/docs/dbt-cloud/cloud-configuring-dbt-cloud/cloud-installing-the-github-application), and then choose the forked repository

6. Click **Start developing** to enter the *develop* portal in dbt Cloud

7. In the command line at the bottom, run `dbt deps`

8. Run `dbt seed`

9. Run `dbt run`

10. Run `dbt source freshness`

11. If all runs OK, then [Set up an Environment](https://docs.getdbt.com/docs/dbt-cloud/cloud-quickstart#create-an-environment)

    > Make sure it is a **deployment** environment

12. [Create a new Job](https://docs.getdbt.com/docs/dbt-cloud/cloud-quickstart#create-a-new-job)

    > In *Execution Settings*, check **Generate Docs** and **Run Source Freshness**

13. Run the new job


## Connect Business Intelligence tool

To see how a Business Intelligence tool can integrate with dbt using these standards, check out one of these:

* [FlexIt Analytics](https://learn.flexitanalytics.com/docs/dbt)
* Add more here

## BI Standards

BI vendors and dbt projects should follow these standards to "speak the same langauge" for a metadata-less BI experience. The following sections highlight how these standards should be applied to dbt projects.

### Lineage

Models must use `ref` and `source` for lineage to be accessible

```sql
select
    {{ dbt_utils.surrogate_key(['order_number','order_line_number']) }} order_key,
    *
from {{ ref('stg_order') }}
```

```sql
select distinct
    order_number,
    order_line_number,
    order_date,
    status
from {{ source('salesforce', 'stg_sales_data') }}
```

### Metrics

Metrics can be defined two ways

1. Using the recommended dbt [Metrics](https://docs.getdbt.com/docs/building-a-dbt-project/metrics) definition

```yaml
metrics:
  - name: quantity
    label: Quantity
    model: ref('fact_sales')
    description: "Sum of quantity sold"
    type: sum
    sql: quantity
    timestamp: date_day
    time_grains: [day, week, month, year]
```

2. Using the `meta` tag

```yaml
models:
  - name: fact_sales
    columns:
      - name: quantity
        meta:
          metrics:
            total_quantity:
              label: 'Total Quantity'
              type: sum # sum, average, count, count_distinct, min, max
              description: "Sum of quantity sold"
```

### Business (Friendly) Names

Metrics allow for a `label` attribute to create business friendly names.

```yaml
metrics:
  - name: quantity
    label: Quantity
```

All models and model columns will need to use the `meta` tag and define a `label` attribute, as such:

```yaml
models:
  - name: dim_customer
    meta:
      label: Customer
    columns:
      - name: customer_name
        meta:
          label: Customer Name
```

### Descriptions

The `description` attribute is standard on models, columns, metrics, etc. and allow for a detailed definition.

```yaml
models:
  - name: fact_sales
    description: "{{ doc('fact_sales') }}" # references docs block

  - name: dim_order
    description: "All your orders here" # standard description
    columns:
      - name: order_date
        description: "Date of the order from {{ var('company_name') }}" # uses a var

```

You can store descriptions in a `markdown` file and reference with `{{ doc('fact_sales') }}`, which references this markdown file:

```markdown
{% docs fact_sales %}

| Metric         | Definition                                       |
|----------------|--------------------------------------------------|
| quantity       | Sum of quantity sold                             |
| price          | Average price for an ordered product             |
| sales          | Sum of total sales revenue                       |
| target         | Sum of target sales revenue                      |

{% enddocs %}
```

### Report Dependencies

Report and dashboard dependencies are called [exposures](https://docs.getdbt.com/docs/building-a-dbt-project/exposures) in dbt. Exposures allow you to bring together all the downstream usage of a model (BI, ML, or the many other tools an organization has).

Exposures can be part of `schema.yml` or managed in separate files (e.g. `exposures.yml`).

> Use the `meta.tool` to define the tool

```yaml
exposures:
  - name: Area Chart (100% Stacked)
    type: analysis
    url: https://cloud.flexitanalytics.com/#analysis/area-stacked-100
    description: ''
    depends_on:
      - ref('dim_order')
      - ref('dim_product')
      - ref('fact_sales')
    owner:
      name: Andrew Taft
      email: some@email.address
    meta:
      tool: flexit
```

### Joins

The preferred method uses dbt’s `relationships` [test](https://docs.getdbt.com/docs/building-a-dbt-project/tests), which serves two purposes:
1. Tests referential integrity, ensuring your data is correct
2. Allows BI tools to know relationships to joining entities

Dbt’s `relationships` test works great for well modeled data (e.g. dimensional star schema), but there may be use cases for more complex joins (multi-column, expressions other than equals, etc.). In this case, we can leverage dbt’s meta property. Here’s an example of both ways to handle joins:

```yaml
models:
  - name: fact_sales
    meta:
      label: Sales Fact
      joins:
        - to: dim_customer
          type: inner #inner, left, right, full; default 'inner'
          join_on:
            - from_field: customer_key
              exp: '=' #optional; default '='; '=','<>'
              to_field: customer_key
    columns:
      - name: customer_key
        tests:
          - relationships: #JOINS the dbt integrity way
              to: ref('dim_customer')
              field: customer_key
```

### Data Freshness

BI tools should use dbt's built in run/job update timestamps and [source freshness](https://docs.getdbt.com/reference/resource-properties/freshness) to display data freshness information to end users.

You can also use dbt [Dashboard Tiles](https://docs.getdbt.com/docs/dbt-cloud/using-dbt-cloud/cloud-dashboard-status-tiles) to place freshness “tiles” into dashboards, giving users the ability to see high-level freshness and drill into detail, if necessary.

### Statistics

Information such as `Number of rows` or `Size` of a table/model can be very informative and build trust in the data. If the underlying data source supports these statistics, then dbt makes `stats` available on models and then the BI tool can make them available to end users.

### Synonyms

Synonyms (aliases) allow you to assign multiple potential names to a single column. For example, sales might be called revenue, receipts, proceeds, or other names depending on who you ask. Synonyms can be used for search and Natural Language Query (NLQ).

This is not a build-in dbt feature, so we use the meta tag, as shown here:

```yaml
metrics:
  - name: sales
    label: Sales
    model: ref('fact_sales')
    description: "Sum of total sales revenue"
    type: sum
    sql: sales
    timestamp: date_day
    time_grains: [day, week, month, year]
    meta:
      synonyms: # for business searching and natural language processing
        - Revenue
        - Proceeds
        - Receipts
```

### Formatting

Define column formatting for numbers, dates, currency, and text

```yaml
models:
  - name: monthly_sales
    columns:
      - name: revenue
        meta:
          format:
            type: number
            decimalPlaces: 2
            prefix: "$"
            displayUnits: auto # auto, thousands, millions, billions, trillions
      - name: quantity
        meta:
          format:
            type: number
            suffix: " units sold"
      - name: date_day
        meta:
          format:
            type: date
            pattern: 'MMM D, YYYY'
      - name: mrr_change
        meta:
          format:
            type: percent
            divideBy100: true
      - name: descr
        meta:
          format:
            type: text
            showNullAs: 'No Value Entered'
```

Depending on type, possible attributes are:
* decimalPlaces
* prefix
* suffix
* displayUnits
* showNullAs
* pattern (*date only*)
* divideBy100 (*percent only*)


### Hidden

Use the `meta.hidden` attribute on models, model columns, and metrics to hide it from being displayed to end users in the BI tool.

```yaml title="models/schema.yml"
models:
  - name: stg_dummy_table
    meta:
      hidden: true
```

### Display Order

Use the `display_index` meta tag to place models and columns in a specific order

```yaml title="models/schema.yml"
models:
  - name: fact_sales
    meta:
      label: Sales Fact
      display_index: 1 # display first
```

## Concepts

Here is a list of concepts that were covered in this repo.

### dbt Concepts

* **Database agnostic** - how to use macros and packages to create models that work across database platforms

* **Multi-dimensional Modeling** - how to create multi-dimensional models using the Kimball methodology

* **Date Dimension** - build a database agnostic date dimension using the [`dbt-date`](https://github.com/calogica/dbt-date#get_date_dimensionstart_date-end_date) package.

* **Metrics** - how to define [Metrics](https://docs.getdbt.com/docs/building-a-dbt-project/metrics)

* **Metrics Package** - how to use the [dbt_metrics](https://github.com/dbt-labs/dbt_metrics) package to generate queries.

* **Meta** - using the [meta config](https://docs.getdbt.com/reference/resource-configs/meta) for downstream BI tools to handle joins, formatting, aliases, model and column order, hide/display columns and models, and more

* **Tests** - how to use singular and generic [tests](https://docs.getdbt.com/docs/building-a-dbt-project/tests), including relationships tests for referential integrity

* **Packages** - using packages such as [`dbt-date`](https://github.com/calogica/dbt-date#get_date_dimensionstart_date-end_date) and [`dbt-utils`](https://github.com/dbt-labs/dbt-utils)

* **Jinja & Macros** - using [Jinja & Macros](https://docs.getdbt.com/docs/building-a-dbt-project/jinja-macros) to create re-usable code

* **Seeds** - use [Seeds](https://docs.getdbt.com/docs/building-a-dbt-project/seeds) to load source data into the data warehouse

* **Exposures** - document downstream model dependencies, such as reports and dashboards, using [Exposures](https://docs.getdbt.com/docs/building-a-dbt-project/exposures)

* **Custom Schemas** - how to use [Custom Schemas](https://docs.getdbt.com/docs/building-a-dbt-project/building-models/using-custom-schemas) to organize models (e.g. staging tables)

* **Documentation**  - [documenting dbt models](https://docs.getdbt.com/docs/building-a-dbt-project/documentation) for optimized downstream discovery in BI tools

* **Sources** - defining [Sources](https://docs.getdbt.com/docs/building-a-dbt-project/using-sources) and using the source freshness features

* **Snapshots** - use [Snapshots](https://docs.getdbt.com/docs/building-a-dbt-project/snapshots) to maintain a history of record changes in a table over time

* **Pre-hook & Post-hook** - use [post-hooks](https://docs.getdbt.com/reference/resource-configs/pre-hook-post-hook) to run SQL after a model is built. For example, to create indexes, primary/foreign keys, grant permissions.

* **Best Practices** - follow [dbt Best Practices](https://docs.getdbt.com/docs/guides/best-practices)


### Business Intelligence Concepts

* **Metadata-less BI** - bypass defining metadata models at the BI semantic layer

* **Data Literacy** - create a full data dictionary with source controlled definitions using dbt documentation

* **Lineage** - instantly see upstream model and source dependencies with the ability to view and run upstream SQL

* **Joins** - entity relationships defined by dbt tests `relationships` or model `meta`

* **Formatting** - define universal formatting for number, string, date and other data types

* **Data Freshness** - from reports and models, view model refresh date/time and source data freshness

* **Metrics** - use dbt Metrics for complex calculations and aggregation

* **Natural Language Query (NLQ)** - define model `meta.synonyms` (a.k.a aliases) to be used by natural language query or generic searching

* **Report dependencies** - define model dependencies for reports and dashboards using Exposures


## Let's Collaborate

With **Business Intelligence standards for integrating with dbt**, we can enable all BI tools to speak the same language and offer a 100% metadata-less BI experience. Join us in creating those standards!
