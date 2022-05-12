# dbt Business Intelligence

**Business Intelligence standards for integrating with dbt**

This project shows how to structure dbt to enable analytics in a business intelligence (BI) tool for reporting and dashboarding without the need for defining metadata in the BI tool ("Metadata-less BI"). In short, remove the "black box" of BI with dbt and allow all BI tools to speak the same language and offer a standardized metadata-less BI experience.

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

To see how a Business Intelligence tool can leverage dbt for "metadata-less BI", check out FlexIt Analytics:

[https://learn.flexitanalytics.com/docs/dbt](https://learn.flexitanalytics.com/docs/dbt)


## Let's Collaborate

With **Business Intelligence standards for integrating with dbt**, we can enable all BI tools to speak the same language and offer a 100% metadata-less BI experience. Join us in creating those standards!

**Self-service = clean data + modern BI + data literacy**

**Self-service = dbt + BI**