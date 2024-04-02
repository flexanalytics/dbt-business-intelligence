# Semantic Model Setup
This will give an overview on setup of dbt's [semantic layer](https://www.getdbt.com/product/semantic-layer) as well as focus on the [Tableau integration](https://docs.getdbt.com/docs/use-dbt-semantic-layer/tableau)

First, make sure you meet all the pre-requisites outlined in the link above, including running dbt cloud on at least a Team tier.

## First, let's look at the yaml file setup:

In our example [semantic_models.yml](./semantic_models.yml) file, you'll find
models, entities, measures, dimensions, metrics, saved_queries, and exports. Below is a walkthrough of each section:

This first section of the model file, below, tells dbt that this is a configuration for semantic models.
This does not have to be in its own file, and the file name does not have to be at all related to semantic models, as long as `semantic_models:` is the mapping name.

Next comes the `name` sequence. This corresponds to a model name within your dbt project that you want to apply semantics to. Note the model ref below that uses dbt's `ref` to refer to the actual model name. This example also uses descriptions for clear definitions of the model as well as a default aggregate time to day, which will be used later in metrics as the granularity during calculation.

```yml
semantic_models:
  - name: fact_sales
    defaults:
      agg_time_dimension: date_day
    description: "{{ doc('fact_sales') }}"
    model: ref('fact_sales')
```

---

Below are [entities](https://docs.getdbt.com/docs/build/entities) which are essentially the join keys for the semantic model, comprising of name, type, and expr (the name of the materialized id column).

```yml
entities:
      - name: fact_sales_key
        type: primary
      - name: customer
        type: foreign
        expr: customer_key
      - name: order
        type: foreign
        expr: order_key
      - name: product
        type: foreign
        expr: product_key
      - name: date
        type: foreign
        expr: date_key
```

---

Next up we have [dimensions](https://docs.getdbt.com/docs/build/dimensions) which are how metrics can be grouped. The syntax to use these as group-bys is shown down below.
note that `type_params` and `time_granularity` are required for most connectors to work

```yml
    dimensions:
      - name: date_day
        type: time
        type_params:
          time_granularity: day
```

---

Now on to [measures](https://docs.getdbt.com/docs/build/measures) which are essentially the aggregations performed on your model.

```yml
  measures:
      - name: price
        label: Price
        description: Price paid on this order
        expr: price
        agg: average
        agg_time_dimension: date_day
        create_metric: true
      - name: quantity
        label: Quantity
        expr: 1
        agg: sum
        agg_time_dimension: date_day
        create_metric: true
      - name: sales
        label: Sales
        description: The total revenue for each order.
        agg: sum
        agg_time_dimension: date_day
        expr: sales
        create_metric: true
      - name: target
        label: Target
        description: Distinct count of customers placing orders
        agg: sum
        agg_time_dimension: date_day
        expr: target
        create_metric: true
      - name: row_count
        label: Rowcount
        expr: 1
        agg: sum
        agg_time_dimension: date_day
        create_metric: true
      - name: customer_count
        label: Customer Count
        description: Distinct count of customers
        agg: count_distinct
        agg_time_dimension: date_day
        expr: customer_key
        create_metric: true
      - name: product_count
        label: Product Count
        description: Distinct count of products
        agg: count_distinct
        agg_time_dimension: date_day
        expr: product_key
        create_metric: true
      - name: order_count
        label: Order Count
        description: Distinct count of orders
        agg: count_distinct
        agg_time_dimension: date_day
        expr: order_key
        create_metric: true
      - name: sales_to_target
        label: Sales to Target %
        description: Percentage of actual sales to target sales
        expr: sales / target
        agg: average
        agg_time_dimension: date_day
```

---

We've now reached [metrics](https://docs.getdbt.com/docs/build/metrics-overview), which are the driving force behind dbt's semantic layer. These come in various types, so make sure to read up on them in the documentation:
- Conversion metrics
- Cumulative metrics
- Derived metrics
- Ratio metrics
- Simple metrics

```yml
metrics:
  - name: sales_to_target
    label: Sales to Target Ratio
    type: simple
    description: Percentage of actual sales to target sales
    type_params:
      measure: sales_to_target
```
here's dbt's full example:

```yml
metrics:
  - name: metric name                     ## Required
    description: same as always           ## Optional
    type: the type of the metric          ## Required
    type_params:                          ## Required
      - specific properties for the metric type
    config: here for `enabled`            ## Optional
    meta:
        my_meta_direct: 'direct'           ## Optional
    label: The display name for your metric. This value will be shown in downstream tools. ## Required
    filter: |                             ## Optional
      {{  Dimension('entity__name') }} > 0 and {{ Dimension(' entity__another_name') }} is not
      null
```

*note the dimension filter, which uses the syntax of `Dimension('entity__name')`*

---
Lastly, [saved queries](https://docs.getdbt.com/docs/build/saved-queries) and [exports](https://docs.getdbt.com/docs/use-dbt-semantic-layer/exports) allow you to materialize a table or view with pre-defined metrics without having to actually write any sql or create model files. Useful for high-level summary views from reusable metrics

```yml
saved_queries:
  - name: order_metrics
    description: Relevant order metrics
    query_params:
      metrics:
        - sales_to_target
        - order_count
        - product_count
        - customer_count
        - sales
        - target
      group_by:
        - TimeDimension('fact_sales_key__date_day', 'day')
      where:
        - "{{TimeDimension('fact_sales_key__date_day')}} > current_timestamp - interval '1 month'"
    exports:
      - name: order_metrics
        config:
          export_as: view
          schema: dev
          alias: order_summary
```

## Tableau Desktop Integration

In order to connect Tableau directly to dbt's semantic layer, there are a couple of tasks to complete:

### Download the necessary drivers and connectors

There are two needed downloads: dbt's connector and a jdbc driver. The links to both are found in [dbt's documentation here](https://docs.getdbt.com/docs/use-dbt-semantic-layer/tableau#installing-the-connector)


### Save the drivers in the right place

[From the same documentation](https://docs.getdbt.com/docs/use-dbt-semantic-layer/tableau#installing-the-connector), make sure the files are stored in the right place

### Set up a service token

In order to connect to the semantic layer, you'll need to set up a service token as well as complete the semantic layer setup as [outlined here](https://docs.getdbt.com/docs/use-dbt-semantic-layer/setup-sl#set-up-dbt-semantic-layer)

**Make sure you save your token in a safe place!** dbt only shows it to you once and you'll need to enter it every time the connection is reset (if your computer restarts for example)

### Use the semantic layer in Tableau

Once setup is complete and a connection is established, you'll see a data source table called `ALL` which will contain all your metrics, dimensions, and entities. These can then be used for analysis and visualization

### Considerations

### Latency
As it stands, the integration will compile queries to run against your data warehouse which means that every update to a sheet will result in a new query run. Depending on your architecture this could result in slow development time

### Limited visibility

We have not seen much useful metadata get pulled into Tableau, such as `description`, which would be very helpful as a hover tooltip

### Other limitations
In the spirit of full disclosure, not all of our dimensions were materialized in the semantic layer - neither visible in Tableau nor direct querying. A developer at dbt labs is working on troubleshooting this and we will update this guide as we receive answers. The semantic layer is still technically immature and bugs and limitations are to be expected.

Make sure to also review the [things to note section](https://docs.getdbt.com/docs/use-dbt-semantic-layer/tableau#things-to-note) - there is some limited functionality to the integration

## Useful tools and guides for troubleshooting

[This guide](https://docs.getdbt.com/best-practices/how-we-build-our-metrics/semantic-layer-3-build-semantic-models) from dbt was useful in setting up semantic models


You can run `mf validate-configs` locally with the [metricflow cli](https://github.com/dbt-labs/metricflow) to test the setup of your semantic model, and it even runs against your data warehouse so you don't have to push to a repo and run from dbt cloud.

[This guide](https://xebia.com/blog/setting-up-the-new-dbt-semantic-layer-and-testing-with-dbeaver/) walks you through connecting an IDE like [dbeaver](https://dbeaver.io/) up to the semantic layer for direct querying.

[This repo](https://github.com/dbt-labs/example-semantic-layer-clients) has examples for programatic access to the semantic api.
