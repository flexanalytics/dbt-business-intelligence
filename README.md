# dbt Business Intelligence

This project shows how to structure dbt to enable analytics in a business intelligence (BI) tool for reporting and dashboarding without the need for defining metadata in the BI tool.

The project has been tested on both **dbt Core** and **dbt Cloud** versions 1.0+. The project is also database agnostic and has been tested with the **Postgres**, **BigQuery**, **Snowflake**, and **Redshift** [adapters](https://docs.getdbt.com/docs/available-adapters).

## Overview

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


### BI Concepts

* **Metadata-less BI** - bypass defining metadata models at the BI semantic layer

* **Lineage** - instantly see upstream model and source dependencies with the ability to view and run upstream SQL

* **Joins** - entity relationships defined by dbt tests `relationships` or model `meta`

* **Formatting** - define universal formatting for number, string, date and other data types

* **Data Freshness** - from reports and models, view model refresh date/time and source data freshness

* **Metrics** - use dbt Metrics for complex calculations and aggregation

* **Natural Language Query (NLQ)** - define model `meta.synonyms` (a.k.a aliases) to be used by natural language query or generic searching

* **Report dependencies** - define model dependencies for reports and dashboards using Exposures

* **Documentation** - create a full data dictionary with source controlled definitions


## Getting started

If you're just getting started learning dbt, then you may want to look at Getting Started with [dbt Core](https://docs.getdbt.com/tutorial/learning-more/getting-started-dbt-core) or [dbt Cloud](https://docs.getdbt.com/tutorial/getting-started) first. The concepts in this tutorial may be a bit more difficult.


### Choose a database

[BigQuery](https://docs.getdbt.com/tutorial/getting-set-up/setting-up-bigquery#operation/get-account-run)

[Snowflake](https://docs.getdbt.com/tutorial/getting-set-up/setting-up-snowflake) - TODO issues with server name and location

[Redshift](https://docs.getdbt.com/tutorial/getting-set-up/setting-up-redshift)

[Postgres](heroku.com) - TODO show how to set up free hosted Postgres database on Heroku



### dbt Client

run the following commands:

First run:
* `dbt deps`
* `dbt seed`

Schedule:
* `dbt run`
* `dbt source freshness`

Docs:
* `dbt docs generate`
* `dbt docs serve`

### dbt Cloud

instructions for cloud accounts

