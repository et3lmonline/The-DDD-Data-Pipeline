import os

import dlt
import sqlalchemy as sa
import sqlalchemy.dialects.postgresql as pg_sql_type
from dlt.destinations import duckdb
from dlt.sources.sql_database import sql_database

from .tables import public_schema_tables

database = os.environ.get("SRC_PG_CONTOSO_DATABASE")
password = os.environ.get("SRC_PG_CONTOSO_PASSWORD")
username = os.environ.get("SRC_PG_CONTOSO_USERNAME")
host = os.environ.get("SRC_PG_CONTOSO_HOST")
port = os.environ.get("SRC_PG_CONTOSO_PORT")

connection_string = f"postgresql://{username}:{password}@{host}:{port}/{database}"


def type_adapter_callback(sql_type):
    if isinstance(sql_type, pg_sql_type.MONEY):
        return sa.String(255)


table_names = [
    table.get("name") for table in public_schema_tables if table.get("is_enabled")
]

contoso_tables = sql_database(
    credentials=connection_string,
    schema="public",
    table_names=table_names,
    chunk_size=50000,
    backend="sqlalchemy",
    include_views=False,
    engine_adapter_callback=None,
    table_adapter_callback=None,
    type_adapter_callback=type_adapter_callback,
    query_adapter_callback=None,
)

for table in public_schema_tables:
    is_enabled = table.get("is_enabled")
    if not is_enabled:
        continue
    table_name = table.get("name")
    write_disposition = table.get("write_disposition")
    primary_key = table.get("primary_key")
    incremental = table.get("incremental")

    contoso_tables.resources.get(table_name).apply_hints(
        incremental=incremental,
        write_disposition=write_disposition,
        primary_key=primary_key,
    )

destination = duckdb("duckdb:///data/duckdbs/dwh.duckdb")

pipeline = dlt.pipeline(
    pipeline_name="pg_contoso_duckdb",
    dataset_name="raw",
    destination=destination,
    pipelines_dir="data/dlt_pipelines",
    progress="log",
)

pipeline.run(data=contoso_tables)

audit_pipeline = dlt.pipeline(
    pipeline_name="dlt_dwh_auditing",
    destination=destination,
    pipelines_dir="data/dlt_pipelines",
    dataset_name="audit",
)
audit_pipeline.run(
    data=[pipeline.last_trace],
    table_name="last_trace",
    write_disposition="append",
)

"""
python -m etl.pipelines.pg_contoso_to_duckdb.pipeline
"""
