"""
This is an example for how to query the Semantic Layer using the GraphQL API.

This example is meant to be run from the CLI when you have the env var DBT_JDBC_URL
set. See the README for details.

For using in a Jupyter notebook or your own program, you should only need the `execute_query`
function, and you need to adapt it to your needs. In this example we simply print out the
DataFrame, but you probably want to return it instead. You might also prefer to use a GraphQL
client that auto-generates code based on the public schema.
"""
import base64
import os
import string
from concurrent.futures import ThreadPoolExecutor, as_completed
from dataclasses import dataclass
from urllib.parse import parse_qs, urlparse

import httpx
import pyarrow as pa

# You can use either HTTP1 or HTTP2
use_http2 = True
s = httpx.Client(http2=use_http2)


@dataclass
class ConnAttr:
    host: str  # "https://semantic-layer.cloud.getdbt.com/api/graphql"
    environment_id: str  # 42
    token: str  # dbts_thisismyprivateservicetoken


def parse_jdbc_uri(uri):
    """Helper function to convert the JDBC url into ConnAttr."""
    parsed = urlparse(uri)
    params = {k.lower(): v[0] for k, v in parse_qs(parsed.query).items()}
    return ConnAttr(
        host=(
            "http://localhost:8000/graphql"
            if "localhost" in parsed.path
            else parsed.path.replace("arrow-flight-sql", "https").replace(
                ":443", "/api/graphql"
            )
        ),
        environment_id=params.pop("environmentid"),
        token=params.pop("token"),
    )


def execute_query(host, environment_id, token):
    headers = {"authorization": f"Bearer {token}"}
    mut = string.Template(
        """
        mutation {
          createQuery(environmentId:$environment_id, metrics:[{name:"cancelled_orders"}], groupBy:[{name:"metric_time"}]){
            queryId
          }
        }
        """
    ).substitute(environment_id=environment_id)

    resp = s.post(host, json={"query": mut}, headers=headers).json()

    if resp.get("errors"):
        return print("Error creating query: " + str(resp["errors"]))

    query_id = resp["data"]["createQuery"]["queryId"]
    resp = query_request(host, headers, query_id, environment_id)
    if resp.get("errors"):
        return print("Error fetching query status: " + str(resp["errors"]))

    while resp and resp["data"]["query"]["status"] not in [
        "SUCCESSFUL",
        "FAILED",
    ]:
        resp = query_request(host, headers, query_id, environment_id)

    if resp["data"]["query"]["status"] == "FAILED":
        return print("Error fetching results: " + str(resp["data"]["query"]["error"]))

    tables = [get_table(resp)]

    # Fetching pages asynchronously is significantly faster for large data sets
    with ThreadPoolExecutor() as executor:
        jobs = [
            executor.submit(query_request, host, headers, query_id, environment_id, i)
            for i in range(2, resp["data"]["query"]["totalPages"] + 1)
        ]
        tables.extend(get_table(future.result()) for future in as_completed(jobs))
    arrow_table = pa.concat_tables(tables)
    print(arrow_table.to_pandas())


def query_request(host, headers, query_id, environment_id, page_num=1):
    query = string.Template(
        """
        {
          query(queryId:"$query_id", environmentId:$environment_id, pageNum:$page_num){
            status
            arrowResult
            error
            queryId
            totalPages
          }
        }
        """
    ).substitute(query_id=query_id, environment_id=environment_id, page_num=page_num)
    return s.post(host, json={"query": query}, headers=headers).json()


def get_table(resp):
    with pa.ipc.open_stream(
        base64.b64decode(resp["data"]["query"]["arrowResult"])
    ) as reader:
        return reader.read_all()


if __name__ == "__main__":
    conn_attr = parse_jdbc_uri(os.environ["DBT_JDBC_URL"])
    execute_query(conn_attr.host, conn_attr.environment_id, conn_attr.token)
