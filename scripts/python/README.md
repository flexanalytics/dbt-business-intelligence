# Example for connecting to the ADBC driver, or using GraphQL from a Python project

This basic example shows how to set up a Python project using hatch to connect to and query the Semantic Layer.

To run this, make sure you have set the `DBT_JDBC_URL` env var and run:

NOTE: Python curlies need to be escaped by doubling them up, so we end up with 4 curlies instead of 2 for the jinja template section.

Using ADBC:
```
hatch run python src/adbc_example.py 'select * from {{{{ semantic_layer.query(metrics=["orders"]) }}}}'
```

Using GraphQL (this one can't take a dynamic query, but you can look at the code to see how to change it):
```
hatch run python src/gql_example.py
```
